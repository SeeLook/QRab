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
import QtQuick.Controls.Material 2.0
import QtQuick.Dialogs 1.2


Dialog {
  title: qsTr("About QRab")

//   Material.theme: Material.Dark
//   Material.accent: Material.Purple

  ColumnLayout {
    anchors.fill: parent

    RowLayout {
      anchors.horizontalCenter: parent.horizontalCenter
      Image {
        source: "qrc:/icons/qrab.png"
        sourceSize.width: font.pixelSize * 5
      }
      Text {
        text: "  QRab 0.1"
//         font.pixelSize: font.pixelSize * 2
        font.bold: true
//         Component.onComplete: font.pixelSize: font.pixelSize * 2
      }
    }

    Text { text: qsTr("Grabs QR code contexts from your screen") }
    Text {
      text: qsTr("Author:") 
      anchors.horizontalCenter: parent.horizontalCenter
    }
    Text {
      text: "Tomasz Bojczuk"
      anchors.horizontalCenter: parent.horizontalCenter
    }
  }
}

