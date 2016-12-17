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



Page {
  id: aboutPage

  signal exit()

//   function fakeTR(context, string) {
//     var t = Qt.qsTranslate(context, sourceText);
//     console.log(context, string);
//     console.log(t);
//     return Qt.qsTranslate(context, sourceText);
//   }

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
        font.bold: true
        Component.onCompleted: font.pixelSize = font.pixelSize * 2
      }
    }

    Text {
      text: qsTr("Grabs QR code contexts from your screen")
      anchors.horizontalCenter: parent.horizontalCenter
    }
    Text {
      text: qsTr("Author:") 
      anchors.horizontalCenter: parent.horizontalCenter
    }
    Text {
      text: "Tomasz Bojczuk"
      anchors.horizontalCenter: parent.horizontalCenter
    }
    Text {
      text: qsTr("On the terms of GPLv3 license.") 
      anchors.horizontalCenter: parent.horizontalCenter
    }
    Item { // a spacer
      Layout.fillHeight: true
    }
    RowLayout {
      Item { Layout.fillWidth: true }
      Button {
        text: qsTranslate("QPlatformTheme", "OK")
//         text: fakeTR("QPlatformTheme", "OK")
        onClicked: aboutPage.exit()
      }
    }
  }
}

