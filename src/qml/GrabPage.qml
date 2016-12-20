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
import QtQuick.Window 2.0
import QtQuick.Controls.Material 2.0

import TgrabQR 1.0
import QRab.settings 1.0


Page {
  id: grabPage

  property real defaultSpacing: 10

  signal settingsOn()
  signal aboutOn()

  TgrabQR {
    id: qr
    Component.onCompleted: grabPage.acceptSettings()
  }

  function acceptSettings() {
    qr.copyToClipboard = QRabSettings.copyToClipboard
    qr.grabDelay = QRabSettings.grabDelay
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: defaultSpacing

    RowLayout {
      Button {
        id: settingsButt
        text: qsTr("Settings")
        onClicked: grabPage.settingsOn()
      }

      Item { Layout.fillWidth: true }

      Button {
        id: aboutButt
        text: qsTr("About")
        onClicked: grabPage.aboutOn()
      }
    }
    Flickable {
      id: flickText
      Layout.fillHeight: true
      Layout.fillWidth: true
      flickableDirection: Flickable.VerticalFlick
      contentWidth: qrText.paintedWidth
      contentHeight: qrText.paintedHeight

      function ensureVisible(r) {
          if (contentX >= r.x)
              contentX = r.x;
          else if (contentX+width <= r.x+r.width)
              contentX = r.x+r.width-width;
          if (contentY >= r.y)
              contentY = r.y;
          else if (contentY+height <= r.y+r.height)
              contentY = r.y+r.height-height;
       }

      TextEdit {
        id: qrText
        text: qsTr("Put any QR code on a screen\nThen hit GRAB! button")
        focus: true
        width: flickText.width
        height: flickText.height
        wrapMode: TextArea.Wrap
        readOnly: true
        onCursorRectangleChanged: flickText.ensureVisible(cursorRectangle)

        Connections {
          target: qr
          onGrabDone: {
            var str = qr.qrText
            if (str == "") {
                qrText.text = qsTr("No QR code found!")
                adjustButt.visible = false
            } else {
                qrText.text = str
                adjustButt.visible = true
            }
          }
        }
      }
    }

    RowLayout {
      Button {
        id: adjustButt
        text: qsTr("Adjust sheet")
        visible: false
      }
      Item { Layout.fillWidth: true }
      Button {
        id: qrabButt
        text: qsTr("GRAB!")
        onClicked: {
          qr.grab()
        }
      }
    }
  }
} 
