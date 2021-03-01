import qbs

Project {
    qbsSearchPaths: [
        "./Qbs",
        "./ESP32Libs/Qbs"
	]

    references: [
        "ESP32Libs/ESP32Libs.qbs",
        "kline/kline.qbs",
       ]
}
