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

#ifndef TGLOBALS_H
#define TGLOBALS_H


#include <QtCore/QObject>
#include <QtCore/QRect>


#define   GLOB     Tglobals::instance()

class QSettings;


/**
 * @class Tglobals
 */
class Tglobals : public QObject
{

  Q_OBJECT

  Q_PROPERTY(QRect geometry READ geometry WRITE setGeometry NOTIFY dummySignal)
  Q_PROPERTY(int grabDelay READ grabDelay WRITE setGrabDelay NOTIFY grabDelayChanged)
  Q_PROPERTY(bool copyToClipB READ copyToClipB WRITE setCopyToClipB NOTIFY copyToClipBChanged)

public:
  Tglobals(QObject* parent = nullptr);
  ~Tglobals() override;

  static Tglobals* instance() { return m_instance; }

  QRect geometry() const { return m_geometry; }
  void setGeometry(const QRect& g) { m_geometry = g; }

  int grabDelay() const { return m_grabDelay; }
  void setGrabDelay(int gd);

  bool copyToClipB() const { return m_copyToClipB; }
  void setCopyToClipB(bool ctb);

signals:
  void dummySignal();
  void grabDelayChanged();
  void copyToClipBChanged();

private:
  static Tglobals            *m_instance;

  QSettings                  *m_config;

  QRect                       m_geometry;
  int                         m_grabDelay;
  bool                        m_copyToClipB;

};

#endif // TGLOBALS_H
