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

/**
 * This is wrapper around zbar library/executable.
 * Takes screenshot, saves it to temp,
 * then calls zbar to decode QR code.
 */
class TgrabQR : public QObject
{

  Q_OBJECT

  Q_PROPERTY(bool copyToClipboard READ copyToClipboard WRITE setCopyToClipboard)
  Q_PROPERTY(int grabDelay READ grabDelay WRITE setGrabDelay)
  Q_PROPERTY(QString qrText READ qrText WRITE setQRtext NOTIFY grabDone)


public:
  explicit TgrabQR(QObject* parent = nullptr);

  Q_INVOKABLE void grab();

  bool copyToClipboard() { return m_copyToClipB; }
  void setCopyToClipboard(bool copyTo) { m_copyToClipB = copyTo; }

  QString qrText() { return m_qrText; }
  void setQRtext(const QString& str) { m_qrText = str; }

  int grabDelay() { return m_grabDelay; }
  void setGrabDelay(int gd) { m_grabDelay = gd; }

signals:
  void grabDone();

protected:
  void delayedShot();

private:
  QString callZBAR(const QPixmap& pix);
  void parseText(QString& str);

private:
  bool              m_copyToClipB;
  QString           m_qrText; /**< Currently detected text or info that no QR code was found */
  int               m_grabDelay;
};

#endif // TGRABQR_H
