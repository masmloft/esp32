StaticLibrary {
    Export {
        Depends { name: "cpp" }
        Depends { name: "ESP32BuildConfig" }
        Depends { name: "ESP32Core" }

        cpp.includePaths: [
            "src",
        ]
    }

    Depends { name: "cpp" }
    Depends { name: "ESP32BuildConfig" }
    Depends { name: "ESP32Core" }
    Depends { name: "ESP32WiFi" }
    Depends { name: "ESP32FS" }

    files: [
        "src/**/*.h",
        "src/**/*.c",
        "src/**/*.cpp",
        "src/**/*.s",
    ]
}
