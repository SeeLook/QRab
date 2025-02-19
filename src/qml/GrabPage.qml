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

import TgrabQR 1.0
import QRab.settings 1.0


Page {
  id: grabPage

  property real defaultSpacing: grabPage.font.pixelSize
  property string version: qr.version()
  property alias conRun: qr.conRun

  signal settingsOn()
  signal aboutOn()

  TgrabQR {
    id: qr
    Component.onCompleted: {
      grabPage.acceptSettings()
      if (QRabSettings.cells)
        qr.setCells(QRabSettings.cells)
    }
  }

  function acceptSettings() {
    if (QRabSettings.replaceList)
      qr.replaceList = QRabSettings.replaceList
  }

  Column {
    width: parent.width
    anchors.margins: defaultSpacing

    Item {
      width: parent.width; height: settingsButt.height
      Button {
        id: settingsButt
        x: defaultSpacing
        text: qsTr("Settings")
        onClicked: {
          qr.stop()
          grabPage.settingsOn()
        }
      }

      Button {
        id: aboutButt
        anchors { right: parent.right; rightMargin: defaultSpacing }
        text: qsTr("About")
        onClicked: {
          qr.stop()
          grabPage.aboutOn()
        }
      }
    }

    Flickable {
      id: flickText
      width: parent.width; height: grabPage.height - settingsButt.height * 2
      flickableDirection: Flickable.VerticalFlick
      contentWidth: qrText.paintedWidth; contentHeight: qrText.paintedHeight
      clip: true

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
        textFormat: Text.RichText
        text: "<b><center style=\"font-size: xx-large\">" + qsTr("Put any QR code on a screen,<br>then hit GRAB! button") + "</center></b>"
        focus: true
        width: flickText.width; height: flickText.height
        wrapMode: TextArea.Wrap
        readOnly: true
        onCursorRectangleChanged: flickText.ensureVisible(cursorRectangle)

        Connections {
          target: qr
          onGrabDone: {
            if (qr.conRun) {
                qrText.text = qr.qrText
            } else {
                var str = qr.qrText
                if (str == "") {
                    qrText.textFormat = Text.RichText
                    qrText.text = "<b><center style=\"color: red; font-size: xx-large\">" + qsTr("No QR code found!") + "</center></b>"
                    adjustButt.visible = false
                    qrRadio.visible = false
                    clipRadio.visible = false
                } else {
                    qrText.textFormat = Text.PlainText
                    qrText.text = str
                    adjustButt.visible = true
                    qrRadio.visible = true
                    clipRadio.visible = true
                }
            }
          }
        }
      }
    }

    Item {
      width: parent.width; height: adjustButt.height
      Button {
        id: adjustButt
        x: defaultSpacing
        text: qsTr("Adjust sheet")
        visible: false
        onClicked: {
          qr.stop()
          var a = Qt.createComponent("qrc:/AdjustDialog.qml").createObject(grabPage)
          if (a.loadQRtext(qr.replacedText, QRabSettings.cells))
              a.adjusted.connect(adjustAccepted)
          else {
              noTabsComp.createObject(grabPage)
              a.destroy()
          }
        }
        function adjustAccepted(keyList) {
          qr.setCells(keyList)
          QRabSettings.cells = keyList
        }
      }
      Row {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: defaultSpacing
        RadioButton {
          id: qrRadio
          text: qsTr("QR text")
          checked: true
          visible: false
        }
        RadioButton {
          id: clipRadio
          text: qsTr("Clipboard text")
          visible: false
        }
      }

      Button {
        id: qrabButt
        anchors { right: parent.right; rightMargin: defaultSpacing }
        text: qr.conRun ? qsTranslate("Qt", "Stop") : qsTr("GRAB!")
        onClicked: {
          if (qr.conRun)
            qr.stop()
          else
            qr.grab()
        }
      }
    }
  }

  ButtonGroup {
    id: gr
    buttons: [qrRadio, clipRadio]
    onCheckedButtonChanged: {
      if (adjustButt.visible) { // ignore when no QR text was found or at very beginning
        if (gr.checkedButton == qrRadio)
          qrText.text = qr.qrText
        else
          qrText.text = qr.clipText
      }
    }
  }

  Component {
    id: noTabsComp
    Popup {
      id: noTabsPopup
      visible: true
      width: popCol.width + defaultSpacing; height: popCol.height + defaultSpacing
      x: (parent.width - width) / 2; y: (parent.height - height) / 2
      Column {
        id: popCol
        spacing: defaultSpacing
        Text {
      text: qsTr("There is no tabulators in the text.
It can not be split into spreadsheet columns.
To add tabulators, you may use find->replace settings.")
        }
        Button {
          anchors.horizontalCenter: parent.horizontalCenter
          text: qsTranslate("Qt", "OK")
          onClicked: noTabsPopup.close()
        }
      }
      onClosed: noTabsPopup.destroy()
    }
  }
}




