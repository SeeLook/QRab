/***************************************************************************
 *   Copyright (C) 2016 by Tomasz Bojczuk                                  *
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
import QtQuick.Layouts 1.3

import QRab.settings 1.0


Page {
  id: settingsPage

  property real defaultSpacing: 10

  signal exit(bool accepted)

  Flickable {
    anchors.fill: parent
    flickableDirection: Flickable.VerticalFlick

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: defaultSpacing

      CheckBox {
        id: copyCheckBox
        checked: QRabSettings.copyToClipboard
        text: qsTr("Copy QR text to clipboard")
        anchors.horizontalCenter: parent.horizontalCenter
      }

      CheckBox {
        id: keepCheckBox
        checked: QRabSettings.keepOnTop
        text: qsTr("Keep QRab window on top")
        anchors.horizontalCenter: parent.horizontalCenter
      }

      RowLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        Text { text: qsTr("Grab delay") }
        SpinBox {
          id: delaySpinBox
          value: QRabSettings.grabDelay
          from: 0
          to: 2000
          stepSize: 100
        }
      }

      Item { Layout.fillHeight: true }

      RowLayout {
        Item { Layout.fillWidth: true }
        Button {
          text: qsTranslate("Qt", "Cancel") // QPlatformTheme
          onClicked: settingsPage.exit(false)
        }
        spacing: font.pixelSize
        Button {
          text: qsTranslate("Qt", "OK") // QPlatformTheme
          onClicked: {
            QRabSettings.copyToClipboard = copyCheckBox.checked
            QRabSettings.grabDelay = delaySpinBox.value
            QRabSettings.keepOnTop = keepCheckBox.checked
            settingsPage.exit(true)
          }
        }
      }
    }
  }

}
