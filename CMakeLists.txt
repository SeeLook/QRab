cmake_minimum_required(VERSION 2.8.12)

project(qrab)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOMOC ON)

find_package(Qt5Gui REQUIRED)
find_package(Qt5Qml REQUIRED)
find_package(Qt5Quick REQUIRED)
find_package(Qt5QuickControls2 REQUIRED)

set(qrab_SRC
  src/main.cpp
  src/tgrabqr.cpp
)

qt5_add_resources(qrab_SRC qrab.qrc)


add_executable(qrab ${qrab_SRC})


target_link_libraries(qrab 
    Qt5::Core
    Qt5::Gui
    Qt5::Qml
    Qt5::Quick
    Qt5::QuickControls2
)


install(TARGETS qrab DESTINATION bin)
