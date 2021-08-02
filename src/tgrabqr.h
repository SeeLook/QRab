/***************************************************************************
 *   Copyright (C) 2016=2021 by Tomasz Bojczuk                             *
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
#include <QtCore/QMap>


class QPixmap;
class QTimer;


/**
 * This is wrapper around zbar library/executable.
 * Takes screenshot, saves it to temp,
 * then calls @p libzbar methods to decode QR code.
 */
class TgrabQR : public QObject
{

  Q_OBJECT

  Q_PROPERTY(QString qrText READ qrText WRITE setQRtext NOTIFY grabDone)
  Q_PROPERTY(QString clipText READ clipText)
  Q_PROPERTY(QString replacedText READ replacedText)
  Q_PROPERTY(QStringList replaceList READ replaceList WRITE setReplaceList)
  Q_PROPERTY(qreal conRun READ conRun NOTIFY conRunChanged)

public:
  explicit TgrabQR(QObject* parent = nullptr);

      /**
       * Invokes single scan or starts continuous scanning
       */
  Q_INVOKABLE void grab();

      /**
       * Stops continuous scanning
       */
  Q_INVOKABLE void stop();

  QString qrText() { return m_qrText; }
  void setQRtext(const QString& str) { m_qrText = str; }

  QString clipText() { return m_clipText; }
  QString replacedText() { return m_replacedText; }

  QStringList replaceList() { return m_replaceList; }
  void setReplaceList(QStringList& rl);

      /**
       * @p TRUE when continuous scanning is on
       */
  bool conRun() const;

  Q_INVOKABLE void setCells(const QList<int>& l);

  Q_INVOKABLE QString version() const;

signals:
  void grabDone();
  void conRunChanged();

protected:
  void delayedShot();
  void continuousScan();

private:
  QString callZBAR(const QPixmap& pix);
  void parseText(QString& str);

private:
  QString           m_qrText; /**< Currently detected text or empty */
  QString           m_replacedText; /** Text from QR replaced with strings from @p m_replaceList */
  QString           m_clipText; /**< Text copied to clipboard, or empty  */
  QStringList       m_replaceList;
  QStringList       m_conRowsList;
  QMap<int, int>    m_cellsMap;
  QTimer           *m_conTimer;
  int               m_conCounter = 0;
};

#endif // TGRABQR_H
