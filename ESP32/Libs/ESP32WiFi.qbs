StaticLibrary {
    Export {
        Depends { name: "cpp" }

        Depends { name: "ESP32Core" }

        cpp.includePaths: [
            "libraries/WiFi/src",
        ]
    }

    Depends { name: "cpp" }

    Depends { name: "ESP32Core" }

    files: [
        "libraries/WiFi/src/**/*.h",
        "libraries/WiFi/src/**/*.c",
        "libraries/WiFi/src/**/*.cpp",
        "libraries/WiFi/src/**/*.s",
    ]
}
