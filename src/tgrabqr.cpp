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

#include "tgrabqr.h"
#include <QtGui/QGuiApplication>
#include <QtGui/QScreen>
#include <QtGui/QWindow>
#include <QtGui/QPixmap>
#include <QtGui/QClipboard>
#include <QtCore/QTemporaryDir>
#include <QtCore/QProcess>
#include <QtCore/QTimer>
#include <QtCore/QDebug>


TgrabQR::TgrabQR(QObject* parent) :
  QObject(parent),
  m_copyToClipB(true),
  m_delay(300)
{
}


void TgrabQR::grab() {
  auto screen = QGuiApplication::primaryScreen();
//   if (const QWindow *window = QGuiApplication::windowHandle())
//     screen = window->screen();
  if (!screen) {
    qDebug() << "No screen to take screenshot";
    m_qrText.clear();
    return;
  }

  if (qApp->allWindows().size())
    qApp->allWindows().first()->hide();

  QTimer::singleShot(m_delay, [=]{ delayedShot(); });
}


//#################################################################################################
//###################              PROTECTED           ############################################
//#################################################################################################
void TgrabQR::delayedShot() {
  auto screen = QGuiApplication::primaryScreen();
  m_qrText = callZBAR(screen->grabWindow(0));
  if (!m_qrText.isEmpty()) {
      if (m_copyToClipB) {
        auto cpStr = m_qrText;
        parseText(cpStr);
        qApp->clipboard()->setText(cpStr, QClipboard::Clipboard);
      }
  }

  if (qApp->allWindows().size())
    qApp->allWindows().first()->show();

  emit grabDone();
}


//#################################################################################################
//###################              PRIVATE             ############################################
//#################################################################################################
QString TgrabQR::callZBAR(const QPixmap& pix) {
  if (!pix.isNull()) {
    QTemporaryDir tmp;
    QString pixTmpPath = tmp.path() + QLatin1String("/qrab_tmp.png");
    pix.save(pixTmpPath, "PNG");
    QProcess zbar;
    QStringList args;
    args << QStringLiteral("-q") << QStringLiteral("--raw") << pixTmpPath;
    zbar.start(QStringLiteral("zbarimg"), args);
    zbar.waitForFinished();
    return QString::fromUtf8(zbar.readAllStandardOutput().data());
  }
  return QString();
}


void TgrabQR::parseText(QString& str) {
  str.replace(QLatin1String("\n"), QLatin1String("\t"));
}




