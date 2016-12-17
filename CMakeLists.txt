cmake_minimum_required(VERSION 3.1.0)

project(qrab)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt5Gui REQUIRED)
if (Qt5Gui_FOUND)
    if (Qt5Gui_VERSION VERSION_LESS 5.7.0)
        message(FATAL_ERROR "Minimum supported Qt5 version is 5.7.0")
    endif()
else()
    message(SEND_ERROR "The Qt5Gui library could not be found!")
endif(Qt5Gui_FOUND)

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
