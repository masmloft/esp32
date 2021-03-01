Application {

    Depends { name: "cpp" }
    Depends { name: "FileRes" }

    Depends { name: "ESP32Core" }
    Depends { name: "ESP32WiFi" }
    Depends { name: "ESP32WebServer" }
    Depends { name: "ESP32Update" }

    ESP32Cfg.serialPort: "COM43"

    files: [
        "**/*.h",
        "**/*.c",
        "**/*.cpp",
        "**/*.fileres",
        "../ESP32/Libs/tools/partitions/default.csv",
    ]

    Group {
        qbs.install: true
        fileTagsFilter: product.type
    }

}
