import qbs

Project {
    references: [
        "ESP32Arduino/ESP32Core.qbs",
        "ESP32Arduino/libraries/WiFi/ESP32WiFi.qbs",
        "ESP32Arduino/libraries/FS/ESP32FS.qbs",
        "ESP32Arduino/libraries/WebServer/ESP32WebServer.qbs",
        "ESP32Arduino/libraries/Update/ESP32Update.qbs",
    ]
}
