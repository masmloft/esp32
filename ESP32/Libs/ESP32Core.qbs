StaticLibrary {

    Depends { name: "cpp" }
    Depends { name: "ESP32Cfg" }

    cpp.includePaths: [
        "./cores/esp32",
        "./variants/esp32",

        "tools/sdk/include/config",
        "tools/sdk/include/app_trace",
        "tools/sdk/include/app_update",
        "tools/sdk/include/asio",
        "tools/sdk/include/bootloader_support",
        "tools/sdk/include/bt",
        "tools/sdk/include/coap",
        "tools/sdk/include/console",
        "tools/sdk/include/driver",
        "tools/sdk/include/efuse",
        "tools/sdk/include/esp-tls",
        "tools/sdk/include/esp32",
        "tools/sdk/include/esp_adc_cal",
        "tools/sdk/include/esp_event",
        "tools/sdk/include/esp_http_client",
        "tools/sdk/include/esp_http_server",
        "tools/sdk/include/esp_https_ota",
        "tools/sdk/include/esp_https_server",
        "tools/sdk/include/esp_ringbuf",
        "tools/sdk/include/esp_websocket_client",
        "tools/sdk/include/espcoredump",
        "tools/sdk/include/ethernet",
        "tools/sdk/include/expat",
        "tools/sdk/include/fatfs",
        "tools/sdk/include/freemodbus",
        "tools/sdk/include/freertos",
        "tools/sdk/include/heap",
        "tools/sdk/include/idf_test",
        "tools/sdk/include/jsmn",
        "tools/sdk/include/json",
        "tools/sdk/include/libsodium",
        "tools/sdk/include/log",
        "tools/sdk/include/lwip",
        "tools/sdk/include/mbedtls",
        "tools/sdk/include/mdns",
        "tools/sdk/include/micro-ecc",
        "tools/sdk/include/mqtt",
        "tools/sdk/include/newlib",
        "tools/sdk/include/nghttp",
        "tools/sdk/include/nimble",
        "tools/sdk/include/nvs_flash",
        "tools/sdk/include/openssl",
        "tools/sdk/include/protobuf-c",
        "tools/sdk/include/protocomm",
        "tools/sdk/include/pthread",
        "tools/sdk/include/sdmmc",
        "tools/sdk/include/smartconfig_ack",
        "tools/sdk/include/soc",
        "tools/sdk/include/spi_flash",
        "tools/sdk/include/spiffs",
        "tools/sdk/include/tcp_transport",
        "tools/sdk/include/tcpip_adapter",
        "tools/sdk/include/ulp",
        "tools/sdk/include/unity",
        "tools/sdk/include/vfs",
        "tools/sdk/include/wear_levelling",
        "tools/sdk/include/wifi_provisioning",
        "tools/sdk/include/wpa_supplicant",
        "tools/sdk/include/xtensa-debug-module",
        "tools/sdk/include/esp-face",
        "tools/sdk/include/esp32-camera",
        "tools/sdk/include/esp-face",
        "tools/sdk/include/fb_gfx",
    ]

    files: [
        "cores/**/*.h",
        "cores/**/*.c",
        "cores/**/*.cpp",
        "cores/**/*.s",

        "tools/**/*.ld",
    ]

    Export {
        Depends { name: "cpp" }

        Depends { name: "ESP32Cfg" }

        cpp.includePaths: product.cpp.includePaths

        cpp.libraryPaths:
        [
            "./tools/sdk/lib",
        ]

        cpp.linkerScripts: [
            "tools/sdk/ld/esp32_out.ld",
            "tools/sdk/ld/esp32.project.ld",
            "tools/sdk/ld/esp32.rom.ld",
            "tools/sdk/ld/esp32.peripherals.ld",
            "tools/sdk/ld/esp32.rom.libgcc.ld",
            "tools/sdk/ld/esp32.rom.spiram_incompatible_fns.ld",
        ]

        cpp.staticLibraries:
        [
            "gcc",
            "app_trace",
            "libsodium",
            "bt",
            "esp-tls",
            "mdns",
            "console",
            "jsmn",
            "esp_ringbuf",
            "pthread",
            "driver",
            "detection",
            "soc",
            "c",
            "mesh",
            "wpa2",
            "json",
            "dl",
            "wear_levelling",
            "micro-ecc",
            "coexist",
            "face_detection",
            "nvs_flash",
            "wifi_provisioning",
            "fr",
            "nghttp",
            "esp32",
            "net80211",
            "esp_http_server",
            "tcp_transport",
            "log",
            "espnow",
            "hal",
            "mqtt",
            "esp_websocket_client",
            "esp_http_client",
            "vfs",
            "btdm_app",
            "app_update",
            "pe",
            "protocomm",
            "wps",
            "sdmmc",
            "esp_adc_cal",
            "wpa",
            "efuse",
            "coap",
            "smartconfig",
            "image_util",
            "spiffs",
            "ulp",
            "unity",
            "face_recognition",
            "esp_https_server",
            "ethernet",
            "spi_flash",
            "pp",
            "expat",
            "fatfs",
            "tcpip_adapter",
            "lwip",
            "cxx",
            "freertos",
            "esp32-camera",
            "mbedtls",
            "detection_cat_face",
            "m",
            "c_nano",
            "esp_event",
            "newlib",
            "core",
            "openssl",
            "smartconfig_ack",
            "wpa_supplicant",
            "bootloader_support",
            "asio",
            "esp_https_ota",
            "od",
            "espcoredump",
            "heap",
            "rtc",
            "protobuf-c",
            "fb_gfx",
            "freemodbus",
            "fd",
            "phy",
            "xtensa-debug-module",
            "stdc++",
        ]
    }
}
