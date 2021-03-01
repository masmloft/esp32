import qbs

Project {
    references: [
        "Libs/ESP32Core.qbs",
        "Libs/ESP32WiFi.qbs",
        "Libs/ESP32FS.qbs",
        "Libs/ESP32WebServer.qbs",
        "Libs/ESP32Update.qbs",
    ]
}
