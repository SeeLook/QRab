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

#include "tgrabqr.h"
#include "qrabconfig.h"
#include "tglobals.h"

#include <QtGui/QGuiApplication>
#include <QtGui/QScreen>
#include <QtGui/QWindow>
#include <QtGui/QPixmap>
#include <QtGui/QClipboard>
#include <QtCore/QTimer>

#include <QtCore/QDebug>

#include <zbar.h>


QString toCell(int nr) {
  if (nr == 0)
    return QStringLiteral("A");
  if (nr < 26)
    return QString(QChar(nr + 65));
  return QString(QChar(nr / 26 + 64)) + QString(QChar(nr % 26 + 65));
}


TgrabQR::TgrabQR(QObject* parent) :
  QObject(parent)
{
  qDebug() << "QRab version" << version();
  m_conTimer = new QTimer(this);
  connect(m_conTimer, &QTimer::timeout, this, &TgrabQR::continuousScan);
}


void TgrabQR::grab() {
  auto screen = QGuiApplication::primaryScreen();
  if (!screen) {
    qDebug() << "No screen to grab QR";
    m_qrText.clear();
    m_clipText.clear();
    return;
  }

  if (GLOB->conEnable()) {
      m_conRowsList.clear();
      m_conCounter = 0;
      m_clipText.clear();
      m_conTimer->setInterval(GLOB->conInterval());
      m_conTimer->start();
      emit conRunChanged();
  } else {
      if (qApp->allWindows().size())
        qApp->allWindows().first()->hide();

      QTimer::singleShot(GLOB->grabDelay(), [=]{ delayedShot(); });
  }
}


void TgrabQR::stop() {
  if (GLOB->conEnable()) {
    m_conTimer->stop();
    emit conRunChanged();
  }
}


void TgrabQR::setReplaceList(QStringList& rl) {
  m_replaceList = rl;
}


bool TgrabQR::conRun() const {
  return m_conTimer->isActive();
}


void TgrabQR::setCells(const QList<int>& l) {
  m_cellsMap.clear();
  if (!l.isEmpty()) {
    for (int i = 0; i < l.size(); ++i) {
      if (l[i]) // ignore 0 - those texts are disabled by user
        m_cellsMap[l[i] - 1] = i;
    }
    // TODO: below code is for debug only
//     QMap<int, int>::iterator i;
//     for (i = m_cellsMap.begin(); i != m_cellsMap.end(); ++i) {
//       int k = i.key();
//       qDebug() << k << toCell(k) << m_cellsMap[k];
//     }
  }
}


QString TgrabQR::version() const {
  return QStringLiteral(QRAB_VERSION);
}


//#################################################################################################
//###################              PROTECTED           ############################################
//#################################################################################################
void TgrabQR::delayedShot() {
  auto screen = QGuiApplication::primaryScreen();
  m_qrText = callZBAR(screen->grabWindow(0));
  m_replacedText.clear();
  m_clipText.clear();
  if (!m_qrText.isEmpty()) {
    if (GLOB->copyToClipB()) {
      m_clipText = m_qrText;
      parseText(m_clipText);
      qApp->clipboard()->setText(m_clipText, QClipboard::Clipboard);
    }
  }

  if (!GLOB->conEnable()) {
    if (qApp->allWindows().size())
      qApp->allWindows().first()->show();
  }

  emit grabDone();
}


void TgrabQR::continuousScan() {
  auto screen = QGuiApplication::primaryScreen();

  auto qrT = callZBAR(screen->grabWindow(0));
  if (qrT.isEmpty())
    qrT = tr("none");

  if (qrT != m_clipText) {
      m_conCounter = 1;
      if (m_conRowsList.size() >= GLOB->conRows())
        m_conRowsList.removeFirst();
  } else {
      m_conCounter++;
      if (!m_conRowsList.isEmpty())
        m_conRowsList.removeLast();
  }
  m_conRowsList << qrT + (GLOB->conCount() ? QString(" (%1)<br>").arg(m_conCounter) : QLatin1String("<br>"));
  m_qrText = m_conRowsList.join(QString());
  // Let's use m_clipText to store Qr text - no clipboard call here
  m_clipText = qrT;

  emit grabDone();
}


//#################################################################################################
//###################              PRIVATE             ############################################
//#################################################################################################
QString TgrabQR::callZBAR(const QPixmap& pix) {
  if (!pix.isNull()) {
    auto qImage = pix.toImage();
    unsigned bpl = qImage.bytesPerLine();
    unsigned width = bpl / 4;
    unsigned height = qImage.height();
    zbar::Image zbarImage;
    zbarImage.set_size(width, height);
    zbarImage.set_format('B' | ('G' << 8) | ('R' << 16) | ('4' << 24));
    unsigned long datalen = qImage.sizeInBytes();
    zbarImage.set_data(qImage.bits(), datalen);
    zbar::Image imgToScan = zbarImage.convert(*(long*)"Y800");

    zbar::ImageScanner scanner;
    scanner.set_config(zbar::ZBAR_NONE, zbar::ZBAR_CFG_ENABLE, 0); // disable all first
    scanner.set_config(zbar::ZBAR_QRCODE, zbar::ZBAR_CFG_ENABLE, 1); // enable only QR codes
    scanner.scan(imgToScan);
    zbar::SymbolSet symbol = scanner.get_results();
    if (symbol.get_size() == 0) // No scanned data found in pixmap
      return QString();

    QString QRtext;
    for (zbar::SymbolIterator iterator = symbol.symbol_begin(); iterator != symbol.symbol_end();	++iterator)
      QRtext += QString::fromUtf8((*iterator).get_data().c_str());
    zbarImage.set_data(NULL, 0); // clean image
    imgToScan.set_data(NULL, 0);
    return QRtext;
  }
  return QString();
}


void TgrabQR::parseText(QString& str) {
  if (!m_replaceList.isEmpty()) {
    int c = 0;
    while (c < m_replaceList.size()) {
      if (c + 1 >= m_replaceList.size()) {
        qDebug() << "Wrong pair number of find-replace texts in 'replace list'";
        return;
      }
      str.replace(m_replaceList[c], m_replaceList[c + 1]);
      c += 2;
    }
  }
  m_replacedText = str;

  QString tab = QStringLiteral("\t");
  if (!m_cellsMap.isEmpty() && str.contains(tab)) {
    int lastKey = 0;
    QStringList chunks = str.split(tab);
    QString sheetText;
    QMap<int, int>::iterator i;
    for (i = m_cellsMap.begin(); i != m_cellsMap.end(); ++i) {
      int k = i.key();
      int tabsToAdd = k - lastKey;
      for (int t = 0; t < tabsToAdd; ++t)
        sheetText += tab;
      if (m_cellsMap[k] < chunks.size())
        sheetText += chunks[m_cellsMap[k]];
      else
        qDebug() << "[TgrabQR] no text corresponding with cell" << toCell(k) << m_cellsMap[k];
      lastKey = k;
    }
    str = sheetText;
  }
}




