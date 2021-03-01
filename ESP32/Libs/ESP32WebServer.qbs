StaticLibrary {
    Export {
        Depends { name: "cpp" }

        Depends { name: "ESP32Core" }

        cpp.includePaths: [
            "libraries/WebServer/src",
        ]
    }

    Depends { name: "cpp" }

    Depends { name: "ESP32Core" }
    Depends { name: "ESP32WiFi" }
    Depends { name: "ESP32FS" }

    files: [
        "libraries/WebServer/src/**/*.h",
        "libraries/WebServer/src/**/*.c",
        "libraries/WebServer/src/**/*.cpp",
        "libraries/WebServer/src/**/*.s",
    ]
}
