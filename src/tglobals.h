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
  Q_PROPERTY(bool keepOnTop READ keepOnTop WRITE setKeepOnTop NOTIFY keepOnTopChanged)
  Q_PROPERTY(bool conEnable READ conEnable WRITE setConEnable NOTIFY continuousChanged)
  Q_PROPERTY(int conInterval READ conInterval WRITE setConInterval NOTIFY continuousChanged)
  Q_PROPERTY(int conRows READ conRows WRITE setConRows NOTIFY continuousChanged)
  Q_PROPERTY(bool conCount READ conCount WRITE setConCount NOTIFY continuousChanged)

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

  bool keepOnTop() const { return m_keepOnTop; }
  void setKeepOnTop(bool keepOn);

      /**
       * Continuous scanning - @p TRUE if enabled
       */
  bool conEnable() const { return m_conEnable; }
  void setConEnable(bool conE);

  int conInterval() const { return m_conInterval; }
  void setConInterval(int conI);

  int conRows() const { return m_conRowsToShow; }
  void setConRows(int conR);

  bool conCount() const { return m_conCountOccur; }
  void setConCount(bool conC);

  Q_INVOKABLE void setContinuous(bool enb, int intv, int rw, bool cnt);

signals:
  void dummySignal();
  void grabDelayChanged();
  void copyToClipBChanged();
  void keepOnTopChanged();
  void continuousChanged();

private:
  static Tglobals            *m_instance;

  QSettings                  *m_config;

  QRect                       m_geometry;
  int                         m_grabDelay;
  bool                        m_copyToClipB;
  bool                        m_keepOnTop;

  bool                        m_conEnable;
  int                         m_conInterval;
  int                         m_conRowsToShow;
  bool                        m_conCountOccur;
};

#endif // TGLOBALS_H
