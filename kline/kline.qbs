Application {
    type: ["application", "application.info"]
    //type: ["application.elf", "application.info"]

    Depends { name: "cpp" }
    Depends { name: "FileRes" }

    Depends { name: "ESP32BuildConfig" }
    Depends { name: "ESP32Core" }
    Depends { name: "ESP32WiFi" }
    Depends { name: "ESP32WebServer" }
    Depends { name: "ESP32Update" }

    ESP32BuildConfig.serialPort: "COM2"

    files: [
        "**/*.h",
        "**/*.c",
        "**/*.cpp",
        "**/*.fileres",
        "../ESP32/ESP32Arduino/tools/partitions/default.csv",
    ]

//    Group {
//        qbs.install: true
//        fileTagsFilter: product.type
//    }

}
