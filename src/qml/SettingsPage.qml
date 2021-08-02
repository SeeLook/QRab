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

import QtQuick 2.7
import QtQuick.Controls 2.0

import QRab.settings 1.0


Page {
  id: settingsPage

  property real defaultSpacing: 10

  signal exit(bool accepted)

  Row {
    anchors { margins: defaultSpacing }
    Column {
      width: settingsPage.width - buttCol.width
      Flickable {
        width: parent.width; height: settingsPage.height
        flickableDirection: Flickable.VerticalFlick
        clip: true
        contentHeight: leftCol.height; contentWidth: width

        Column {
          id: leftCol
          width: parent.width

          CheckBox {
            id: copyCheckBox
            checked: GLOB.copyToClipB
            text: qsTr("Copy QR text to clipboard")
            anchors.horizontalCenter: parent.horizontalCenter
          }

          CheckBox {
            id: keepCheckBox
            checked: GLOB.keepOnTop
            text: qsTr("Keep QRab window on top")
            anchors.horizontalCenter: parent.horizontalCenter
          }

          Row {
            anchors.horizontalCenter: parent.horizontalCenter
            Text { text: qsTr("Grab delay"); anchors.verticalCenter: parent.verticalCenter }
            SpinBox {
              id: delaySpinBox
              value: GLOB.grabDelay
              from: 0
              to: 2000
              stepSize: 100
            }
          }
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
      anchors { bottom: parent.bottom }
      spacing: font.pixelSize
      Button {
        text: qsTranslate("Qt", "OK") // QPlatformTheme
        onClicked: {
          replaceList.save()
          GLOB.copyToClipB = copyCheckBox.checked
          GLOB.grabDelay = delaySpinBox.value
          GLOB.keepOnTop = keepCheckBox.checked
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
