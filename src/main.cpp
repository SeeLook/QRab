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
 *  You should have received a copy of the GNU General Public License      *
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.  *
 ***************************************************************************/

#include "tgrabqr.h"
#include "tglobals.h"

#include <QtCore/QTranslator>
#include <QtCore/QLibraryInfo>
#include <QtCore/QDir>
#include <QtCore/QDebug>
#include <QtGui/QGuiApplication>
#include <QtGui/QIcon>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlContext>
#include <QtCore/QLoggingCategory>


int main(int argc, char *argv[])
{
  // It mutes QML warnings about connections syntax introduced in Qt 5.15
  // TODO when Qt version requirements will rise to 5.15 or above, change syntax and remove that
  QLoggingCategory::setFilterRules(QStringLiteral("qt.qml.connections=false"));


  QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
  QGuiApplication a(argc, argv);

  QCoreApplication::setOrganizationName("QRab");
  QCoreApplication::setOrganizationDomain("qrab.sf.net");
  QCoreApplication::setApplicationName(QStringLiteral("qrab"));

  a.setWindowIcon(QIcon(QStringLiteral(":/icons/qrab.png")));

  auto gl = new Tglobals();

// Loading translations
  QTranslator qrabTranslator;

#if defined (Q_OS_MAC) || defined (Q_OS_WIN)
  QLocale loc(QLocale::system().uiLanguages().first());
#else
  QLocale loc(qgetenv("LANG"));
#endif
  QLocale::setDefault(loc);

  if (qrabTranslator.load(loc, QStringLiteral("qrab_"), QString(), QStringLiteral(":/lang")))
    a.installTranslator(&qrabTranslator);


  qmlRegisterType<TgrabQR>("TgrabQR", 1, 0, "TgrabQR");
  qmlRegisterSingletonType(QUrl("qrc:/QRabSettings.qml"), "QRab.settings", 1, 0, "QRabSettings");

//   QQuickStyle::setStyle(QStringLiteral("Material"));

  auto engine = new QQmlApplicationEngine();
  engine->rootContext()->setContextProperty(QStringLiteral("GLOB"), gl);
  engine->load(QUrl(QStringLiteral("qrc:/Main.qml")));

  int exCode = a.exec();

  delete engine;
  delete gl;

  return exCode;
}

