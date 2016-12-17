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

Page {
  id: grabPage

  signal settingsOn()
  signal aboutOn()

  TgrabQR {
    id: qr
  }

  ColumnLayout {
    anchors.fill: parent
    RowLayout {
      Button {
        id: "settingsButt"
        text: qsTr("Settings")
        onClicked: grabPage.settingsOn()
      }

      Item { Layout.fillWidth: true }

      Button {
        id: "aboutButt"
        text: qsTr("About")
        onClicked: grabPage.aboutOn()
      }
    }
    RowLayout {
      TextArea {
        id: "qrText"
        placeholderText: qsTr("Put any Qr code on a screen")
        Layout.fillHeight: true
        Layout.fillWidth: true
        wrapMode: TextArea.Wrap
      }
    }
    RowLayout {
      Label {
        id: "statusLabel"
        text: "Status"
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignHCenter
      }
      Button {
        id: "qrabButt"
        text: "QRab"
        onClicked: {
          qrText.text = qr.grab()
        }
      }
    }
  }
} 
