/***************************************************************************
 *   Copyright (C) 2021 by Tomasz Bojczuk                                  *
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


#include "tglobals.h"

#include <QtCore/QSettings>
#include <QtGui/QScreen>
#include <QtGui/QGuiApplication>

#include <QtCore/QDebug>


Tglobals*              Tglobals::m_instance = nullptr;


Tglobals::Tglobals(QObject* parent) :
  QObject(parent)
{
  m_instance = this;

#if defined(Q_OS_WIN) || defined(Q_OS_MACOS)
  m_config = new QSettings(QSettings::IniFormat, QSettings::UserScope, QStringLiteral("QRab"), qApp->applicationName());
#else
  m_config = new QSettings(this);
#endif

  m_geometry = m_config->value(QStringLiteral("geometry"), QRect()).toRect();
  if (m_geometry.isNull()) {
    m_geometry.setY(qApp->primaryScreen()->size().height() / 2);
    m_geometry.setX(2);
  }
  if (m_geometry.width() < 100 || m_geometry.height() < 100) {
    m_geometry.setWidth(qApp->primaryScreen()->size().width() / 3);
    m_geometry.setHeight(qApp->primaryScreen()->size().height() / 3);
  }

  m_config->beginGroup(QLatin1String("QRab"));
    m_grabDelay = m_config->value(QStringLiteral("grabDelay"), 100).toInt();
    m_copyToClipB = m_config->value(QStringLiteral("copyToClipboard"), true).toBool();
    m_keepOnTop = m_config->value(QStringLiteral("keepOnTop"), true).toBool();
    m_conEnable = m_config->value(QStringLiteral("cont_Scan"), true).toBool();
    m_conInterval = qBound(100, m_config->value(QStringLiteral("cont_Interval"), 500).toInt(), 10000);
    m_conRowsToShow = qBound(2, m_config->value(QStringLiteral("cont_Rows"), 2).toInt(), 10);
    m_conCountOccur = m_config->value(QStringLiteral("cont_CountOccu"), true).toBool();
  m_config->endGroup();
}


Tglobals::~Tglobals()
{
  m_config->setValue(QStringLiteral("geometry"), m_geometry);

  m_config->beginGroup(QLatin1String("QRab"));
    m_config->setValue(QStringLiteral("grabDelay"), m_grabDelay);
    m_config->setValue(QStringLiteral("copyToClipboard"), m_copyToClipB);
    m_config->setValue(QStringLiteral("keepOnTop"), m_keepOnTop);
    m_config->setValue(QStringLiteral("cont_Scan"), m_conEnable);
    m_config->setValue(QStringLiteral("cont_Interval"), m_conInterval);
    m_config->setValue(QStringLiteral("cont_Rows"), m_conRowsToShow);
    m_config->setValue(QStringLiteral("cont_CountOccu"), m_conCountOccur);
  m_config->endGroup();

  m_instance = nullptr;
}


void Tglobals::setGrabDelay(int gd) {
  if (gd != m_grabDelay) {
    m_grabDelay = gd;
    emit grabDelayChanged();
  }
}


void Tglobals::setCopyToClipB(bool ctb) {
  if (ctb != m_copyToClipB) {
    m_copyToClipB = ctb;
    emit copyToClipBChanged();
  }
}


void Tglobals::setKeepOnTop(bool keepOn) {
  if (keepOn != m_keepOnTop) {
    m_keepOnTop = keepOn;
    emit keepOnTopChanged();
  }
}


void Tglobals::setConEnable(bool conE) {
  if (conE != m_conEnable) {
    m_conEnable = conE;
  }
}


void Tglobals::setConInterval(int conI) {
  if (conI != m_conInterval) {
    m_conInterval = conI;
  }
}


void Tglobals::setConRows(int conR) {
  if (conR != m_conRowsToShow) {
    m_conRowsToShow = conR;
  }
}


void Tglobals::setConCount(bool conC) {
  if (conC != m_conCountOccur) {
    m_conCountOccur = conC;
  }
}


void Tglobals::setContinuous(bool enb, int intv, int rw, bool cnt) {
  bool emitAfter = enb != m_conEnable || intv != m_conInterval || rw != m_conRowsToShow || cnt != m_conCountOccur;
  setConEnable(enb);
  setConInterval(intv);
  setConRows(rw);
  setConCount(cnt);
  if (emitAfter)
    emit continuousChanged();
}
