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

pragma Singleton
import QtQuick 2.7
import Qt.labs.settings 1.0


/**
 * Single instance object with all QRab settings
 * shared between other objects
 */
Item {
  property int grabDelay: 100
  property bool copyToClipboard: true
  property bool keepOnTop: true

  Settings {
    id: settings
    category: "QRab"
    property bool copyToClipboard: true
    property bool keepOnTop: true
    property int grabDelay: 100
  }

  Component.onCompleted: {
    grabDelay = settings.grabDelay
    copyToClipboard = settings.copyToClipboard
    keepOnTop = settings.keepOnTop
  }

  Component.onDestruction: {
    settings.grabDelay = grabDelay
    settings.copyToClipboard = copyToClipboard
    settings.keepOnTop = keepOnTop
  }
}

