import qbs

Project {
    references: [
        "Arduino/ESP32Core.qbs",
        "Arduino/ESP32WiFi.qbs",
        "Arduino/ESP32FS.qbs",
        "Arduino/ESP32WebServer.qbs",
        "Arduino/ESP32Update.qbs",
    ]
}
