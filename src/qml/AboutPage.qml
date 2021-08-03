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
 *  You should have received a copy of the GNU General Public License      *
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.  *
 ***************************************************************************/

import QtQuick 2.10
import QtQuick.Controls 2.3


Page {
  id: aboutPage

  property real defaultSpacing: font.pixelSize

  signal exit()

  Row {
    Rectangle {
      width: defaultSpacing * 6; height: aboutPage.height
      color: "white"
      Flickable {
        id: pageSwitch
        property int currentIndex: 0

        anchors.fill: parent
        clip: true
        flickableDirection: Flickable.VerticalFlick

        Column {
          width: parent.width
          topPadding: defaultSpacing

          Item { height: defaultSpacing / 2 }
          NavItem {
            id: aboutId
            iconFile: "qrc:/icons/about.png"
            text: qsTranslate("GrabPage", "About")
            onClicked: {
              if (pageSwitch.currentIndex !== 0) {
                stack.replace(comp1)
                pageSwitch.currentIndex = 0
              }
            }
          }
          NavItem {
            iconFile: "qrc:/icons/license.png"
            text: qsTr("License")
            onClicked: {
              if (pageSwitch.currentIndex !== 1) {
                stack.replace(comp2)
                pageSwitch.currentIndex = 1
              }
            }
          }
        }
      }
    }

    StackView {
      id: stack
      width: aboutPage.width - defaultSpacing * 6; height: aboutPage.height
      replaceEnter: Transition { NumberAnimation { property: "y"; from: -height; to: 0 }}
      replaceExit: Transition { NumberAnimation { property: "y"; from: 0; to: height }}

      initialItem: comp1

      Component {
        id: comp1
        Column { // 1st page with info about QRab
          width: parent ? parent.width : 0
          spacing: defaultSpacing

          Row {
            spacing: defaultSpacing
            anchors.horizontalCenter: parent.horizontalCenter
            Image {
              source: "qrc:/icons/qrab-image.png"
              sourceSize.height: defaultSpacing * 7
            }
            Column {
              anchors.verticalCenter: parent.verticalCenter
              Text {
                text: "QRab " + grabPage.version
                anchors.horizontalCenter: parent.horizontalCenter
                font { bold: true; pixelSize: defaultSpacing * 2 }
              }
              LinkText {
                text: " <a href=\"https://qrab.sourceforge.io\">https://qrab.sourceforge.io</a>"
                anchors.horizontalCenter: parent.horizontalCenter
              }
            }
          }
          Text {
            text: qsTr("Grabs QR code contexts from your screen")
            anchors.horizontalCenter: parent.horizontalCenter
          }
          Row {
            spacing: defaultSpacing
            anchors.horizontalCenter: parent.horizontalCenter
            Text { text: qsTr("Author:") }
            LinkText {
              text: " Tomasz Bojczuk <a href=\"mailto:seelook.gmail.com\">seelook@gmail.com</a>"
              font.bold: true
            }
          }
          Text {
            text: qsTr("On the terms of GNU GPLv3 license.") 
            anchors.horizontalCenter: parent.horizontalCenter
          }
          LinkText {
            text: qsTr("QRab uses %1 to handle QR codes.<br>Zbar is delivering on GNU LGPLv2.1 license.").arg("<b><a href=\"http://zbar.sf.net\">zbar</a></b>")
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
          }
          LinkText {
            text: qsTr("This program uses <b><a href=\"http://qt.io\">Qt framework</a></b>")
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
          }
        }
      }

      Component {
        id: comp2
        Flickable { // 2nd page
          width: parent ? parent.width : 0; height: aboutPage.height
          clip: true
          flickableDirection: Flickable.VerticalFlick
          contentWidth: width; contentHeight: secondPage.height
          Column {
            id: secondPage
            spacing: defaultSpacing
            anchors.horizontalCenter: parent.horizontalCenter
            Label {
              text: "\n" + qsTr("QRab
Copyright (C) %1 Tomasz Bojczuk
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software Foundation,
Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA"
                    ).arg("2016-2021")
              horizontalAlignment: Text.AlignJustify
            }
            LinkText {
              text: "<a href=\"https://www.gnu.org/licenses/gpl-3.0.html\">https://www.gnu.org/licenses/gpl-3.0.html</a>"
              anchors.horizontalCenter: parent.horizontalCenter
              font.bold: true
            }
          }
        } // 2nd page
      }

    }
  }

  Button {
    anchors { bottom: parent.bottom; right: parent.right; margins: defaultSpacing }
    text: qsTranslate("Qt", "OK") // QPlatformTheme context
    onClicked: aboutPage.exit()
  }
}

