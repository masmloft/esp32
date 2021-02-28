import qbs

Project {
    qbsSearchPaths: [ "./ESP32/Qbs" ]

    references: [
        "ESP32/ESP32.qbs",
        "kline/kline.qbs",
       ]
}
