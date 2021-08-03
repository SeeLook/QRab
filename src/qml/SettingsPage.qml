/***************************************************************************
 *   Copyright (C) 2016-2021 by Tomasz Bojczuk                             *
 *   seelook@gmail.com                                                     *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 3 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *  You should have received a copy of the GNU General Public License	     *
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.  *
 ***************************************************************************/

import QtQuick 2.10
import QtQuick.Controls 2.3

import QRab.settings 1.0


Page {
  id: settingsPage

  property real defaultSpacing: 10

  signal exit(bool accepted)

  Row {
    anchors { margins: defaultSpacing }
    Column {
      width: settingsPage.width - buttCol.width - defaultSpacing

      Flickable {
        width: parent.width; height: settingsPage.height
        flickableDirection: Flickable.VerticalFlick
        clip: true
        contentHeight: leftCol.height + 2 * defaultSpacing; contentWidth: width

        Column {
          id: leftCol
          width: parent.width

          ButtonGroup { id: oneOrContGr }

          RadioButton {
            id: onceClickRadio
            checked: !GLOB.conEnable
            x: defaultSpacing * 2
            text: qsTr("Grab QR once after click")
            ButtonGroup.group: oneOrContGr
          }
          Item {
            width: parent.width; height: onceClickRadio.checked ? oneClickCol.height : 0
            Behavior on height { NumberAnimation { duration: 250 }}
            Column {
              id: oneClickCol
              visible: parent.height === height
              anchors.horizontalCenter: parent.horizontalCenter
              CheckBox {
                id: copyCheckBox
                checked: GLOB.copyToClipB
                text: qsTr("Copy QR text to clipboard")
                anchors.horizontalCenter: parent.horizontalCenter
              }
              Row {
                anchors.horizontalCenter: parent.horizontalCenter
                Text { text: qsTr("Grab delay"); anchors.verticalCenter: parent.verticalCenter }
                SpinBox {
                  id: delaySpinBox
                  value: GLOB.grabDelay
                  from: 0; to: 2000
                  stepSize: 100
                }
              }
            }
          }

          Rectangle { width: parent.width * 0.8; height: 1; color: "black"; anchors.horizontalCenter: parent.horizontalCenter }

          RadioButton {
            id: continuousRadio
            checked: GLOB.conEnable
            x: defaultSpacing * 2
            text: qsTr("Scan screen continuously")
            ButtonGroup.group: oneOrContGr
          }
          Item {
            width: parent.width; height: continuousRadio.checked ? contiCol.height : 0
            Behavior on height { NumberAnimation { duration: 250 }}
            Column {
              id: contiCol
              visible: parent.height === height
              anchors.horizontalCenter: parent.horizontalCenter
              Row {
                anchors.horizontalCenter: parent.horizontalCenter
                Text { text: qsTr("every"); anchors.verticalCenter: parent.verticalCenter }
                SpinBox {
                  id: conIntSpin
                  value: GLOB.conInterval
                  from: 100; to: 10000
                  stepSize: 100
                }
                Text { text: qsTr("milliseconds"); anchors.verticalCenter: parent.verticalCenter }
              }
              Row {
                anchors.horizontalCenter: parent.horizontalCenter
                Text { text: qsTr("Display"); anchors.verticalCenter: parent.verticalCenter }
                SpinBox {
                  id: conRowSpin
                  value: GLOB.conRows
                  from: 1; to: 100
                }
                Text { text: qsTr("rows of detected texts"); anchors.verticalCenter: parent.verticalCenter }
              }
              CheckBox {
                id: conCountChB
                checked: GLOB.conCount
                text: qsTr("Count the same QR texts")
                anchors.horizontalCenter: parent.horizontalCenter
              }
            }
          }

          Rectangle { width: parent.width * 0.8; height: 1; color: "black"; anchors.horizontalCenter: parent.horizontalCenter }

          CheckBox {
            id: keepCheckBox
            checked: GLOB.keepOnTop
            text: qsTr("Keep QRab window on top")
            anchors.horizontalCenter: parent.horizontalCenter
          }

          Rectangle { width: parent.width * 0.8; height: 1; color: "black"; anchors.horizontalCenter: parent.horizontalCenter }

          Label {
            text: qsTr("Replace QR text")
            anchors.horizontalCenter: parent.horizontalCenter
          }
          ReplaceList {
            id: replaceList
            width: parent.width; height: contentHeight
            replaceTexts: QRabSettings.replaceList
          }
        }
      }
    }

    Column {
      id: buttCol
      anchors { bottom: parent.bottom; bottomMargin: defaultSpacing }
      spacing: font.pixelSize
      Button {
        text: qsTranslate("Qt", "OK") // QPlatformTheme
        onClicked: {
          replaceList.save()
          GLOB.copyToClipB = copyCheckBox.checked
          GLOB.grabDelay = delaySpinBox.value
          GLOB.keepOnTop = keepCheckBox.checked
          GLOB.setContinuous(continuousRadio.checked, conIntSpin.value, conRowSpin.value, conCountChB.checked)
          QRabSettings.replaceList = replaceList.replaceTexts
          settingsPage.exit(true)
        }
      }
      Button {
        text: qsTranslate("Qt", "Cancel") // QPlatformTheme
        onClicked: settingsPage.exit(false)
      }
    }
  }

}
