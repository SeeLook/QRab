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


ListView {
  id: replaceList
  clip: true

  Component {
    id: delegate

    Item {
      id: delegateItem
      width: replaceList.width;
      height: beforeText.height
//       clip: true
      Row {
        Layout.fillWidth: true
        anchors { horizontalCenter: parent.horizontalCenter}
        spacing: font.pixelSize
        TextField {
          id: beforeText
          placeholderText: qsTr("before")
          text: before
          horizontalAlignment: TextInput.AlignHCenter
          maximumLength: 20
        }
        Text { text: "->" }
        TextField {
          id: afterText
          placeholderText: qsTr("after")
          text: after
          horizontalAlignment: TextInput.AlignHCenter
          maximumLength: 20
        }
        Button {
          id: addButton
          Image {
            source: "qrc:/icons/add.png"
            sourceSize.height: parent.height * 0.75
            anchors.centerIn: parent
          }
          onClicked: replaceModel.insert(index + 1, { "before": "", "after": "" })
        }
        Button {
          id: rmButton
          Image {
            source: "qrc:/icons/rm.png"
            sourceSize.height: parent.height * 0.75
            anchors.centerIn: parent
          }
          onClicked: replaceModel.remove(index)
        }
      }
      ListView.onAdd: SequentialAnimation {
        PropertyAction { target: delegateItem; property: "height"; value: 0 }
        NumberAnimation { target: delegateItem; property: "height"; to: 80; duration: 250; easing.type: Easing.InOutQuad }
      }
      ListView.onRemove: SequentialAnimation {
        PropertyAction { target: delegateItem; property: "ListView.delayRemove"; value: true }
        NumberAnimation { target: delegateItem; property: "height"; to: 0; duration: 250; easing.type: Easing.InOutQuad }
        PropertyAction { target: delegateItem; property: "ListView.delayRemove"; value: false }
      }
    }
  }

  model: ListModel {
    id: replaceModel
    ListElement {
      before: ""
      after: ""
    }
  }

  delegate: delegate
}
