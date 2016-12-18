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


#ifndef TGRABQR_H
#define TGRABQR_H

#include <QtCore/QObject>


class QPixmap;

class TgrabQR : public QObject
{

  Q_OBJECT

  Q_PROPERTY(QString QRtext READ grab)
  Q_PROPERTY(bool copyToClipboard READ copyToClipboard WRITE setCopyToClipboard)

public:
  explicit TgrabQR(QObject* parent = nullptr);

  Q_INVOKABLE QString grab();

  bool copyToClipboard() { return m_copyToClipB; }
  void setCopyToClipboard(bool copyTo) { m_copyToClipB = copyTo; }

private:
  QString callZBAR(const QPixmap& pix);
  void parseText(QString& str);

private:
  bool              m_copyToClipB;
};

#endif // TGRABQR_H
