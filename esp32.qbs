import qbs

Project {
    qbsSearchPaths: [
        "./Qbs",
        "./ESP32/Qbs",
	]

    references: [
        "ESP32/ESP32.qbs",
        "kline/kline.qbs",
       ]
}
