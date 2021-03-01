StaticLibrary {
    Export {
        Depends { name: "cpp" }

        Depends { name: "ESP32Core" }

        cpp.includePaths: [
            "libraries/Update/src",
        ]
    }

    Depends { name: "cpp" }

    Depends { name: "ESP32Core" }
    Depends { name: "ESP32WiFi" }
    Depends { name: "ESP32FS" }

    files: [
        "libraries/Update/src/**/*.h",
        "libraries/Update/src/**/*.c",
        "libraries/Update/src/**/*.cpp",
        "libraries/Update/src/**/*.s",
    ]
}
