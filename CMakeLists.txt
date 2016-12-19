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


if(MINGW)
    add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/qrabico.o
                       COMMAND windres.exe -I${CMAKE_CURRENT_SOURCE_DIR} -i${CMAKE_CURRENT_SOURCE_DIR}/../icons/qrab-icon.rc
                            -o ${CMAKE_CURRENT_BINARY_DIR}/qrabico.o )
    set(qrab_SRCS ${qrab_SRC} ${CMAKE_CURRENT_BINARY_DIR}/qrabico.o)
    set(qrab_EXE_ICON qrabico.o)
endif(MINGW)


qt5_add_resources(qrab_SRC qrab.qrc)


add_executable(qrab WIN32 ${qrab_SRC} ${qrab_EXE_ICON})


target_link_libraries(qrab 
    Qt5::Core
    Qt5::Gui
    Qt5::Qml
    Qt5::Quick
    Qt5::QuickControls2
)

if(UNIX AND NOT APPLE)
    install(TARGETS qrab DESTINATION bin)
    install(FILES icons/qrab.png DESTINATION share/pixmaps)
    install(FILES icons/qrab.desktop DESTINATION share/applications)
else()
  get_target_property(QtCore_location_Release Qt5::Core LOCATION_Release)
  get_filename_component(QT_BINARY_DIR "${QtCore_location_Release}" DIRECTORY)
  if(WIN32)
    install(TARGETS qrab DESTINATION .)
    add_custom_target(deploy
      COMMAND echo "deploying..."
      COMMAND ${QT_BINARY_DIR}/windeployqt.exe --release --no-translations --no-svg --qmldir "${CMAKE_SOURCE_DIR}/src/qml"  "${CMAKE_INSTALL_PREFIX}/qrab.exe"
    )
  else()
    install(TARGETS qrab DESTINATION "${CMAKE_INSTALL_PREFIX}/qrab.app/Contents/MacOs")
    install(FILES "${CMAKE_SOURCE_DIR}/icons/qrab.icns" DESTINATION "${CMAKE_INSTALL_PREFIX}/qrab.app/Contents/Resources")
    install(FILES "${CMAKE_SOURCE_DIR}/icons/info.plist" DESTINATION "${CMAKE_INSTALL_PREFIX}/qrab.app/Contents")
    add_custom_target(deploy
      COMMAND echo "deploying..."
      COMMAND echo ${QT_BINARY_DIR}/../../bin
      COMMAND ${QT_BINARY_DIR}/../../bin/macdeployqt ${CMAKE_INSTALL_PREFIX}/qrab.app
    )
  endif(WIN32)
endif(UNIX AND NOT APPLE)


configure_file(
     "${CMAKE_CURRENT_SOURCE_DIR}/cmake_uninstall.cmake.in"
     "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
        IMMEDIATE @ONLY)

  add_custom_target(uninstall
   COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake
)
