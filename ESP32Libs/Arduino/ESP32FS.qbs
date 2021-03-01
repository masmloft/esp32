StaticLibrary {
    Export {
        Depends { name: "cpp" }

        Depends { name: "ESP32Core" }

        cpp.includePaths: [
            "libraries/FS/src",
        ]
    }

    Depends { name: "cpp" }

    Depends { name: "ESP32Core" }

    files: [
        "libraries/FS/src/**/*.h",
        "libraries/FS/src/**/*.c",
        "libraries/FS/src/**/*.cpp",
        "libraries/FS/src/**/*.s",
    ]
}
