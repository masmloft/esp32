import qbs
import qbs.FileInfo
import qbs.TextFile

Module {
    property string serialPort: "COM1"

    Depends { name: "cpp" }

    cpp.assemblerFlags: [
    ]

    cpp.cFlags: [
        '-DESP_PLATFORM',
        '-DMBEDTLS_CONFIG_FILE=\"mbedtls/esp_config.h\"',
        '-DHAVE_CONFIG_H',
        '-DGCC_NOT_5_2_0=0',
        '-DWITH_POSIX',

        '-std=gnu99',
        '-Os',
        '-g3',
        '-fstack-protector',
        '-ffunction-sections',
        '-fdata-sections',
        '-fstrict-volatile-bitfields',
        '-mlongcalls',
        '-nostdlib',
        '-Wpointer-arith',
        '-Wall',
        '-Werror=all',
        '-Wextra',
        '-Wno-maybe-uninitialized',
        '-Wno-unused-function',
        '-Wno-unused-but-set-variable',
        '-Wno-unused-variable',
        '-Wno-deprecated-declarations',
        '-Wno-unused-parameter',
        '-Wno-sign-compare',
        '-Wno-old-style-declaration',
        '-MMD',
        '-DF_CPU=160000000L',
        '-DARDUINO=10813',
        '-DARDUINO_ESP32_DEV',
        '-DARDUINO_ARCH_ESP32',
        '-DARDUINO_BOARD=ESP32_DEV',
        '-DARDUINO_VARIANT=esp32',
        '-DESP32',
        '-DCORE_DEBUG_LEVEL=0',
    ]

    cpp.cxxFlags: [
        '-DESP_PLATFORM',
        '-DMBEDTLS_CONFIG_FILE=\"mbedtls/esp_config.h\"',
        '-DHAVE_CONFIG_H',
        '-DGCC_NOT_5_2_0=0',
        '-DWITH_POSIX',

        '-std=gnu++11',
        '-Os',
        '-g3',
        '-Wpointer-arith',
        '-fexceptions',
        '-fstack-protector',
        '-ffunction-sections',
        '-fdata-sections',
        '-fstrict-volatile-bitfields',
        '-mlongcalls',
        '-nostdlib',
        '-Wall',
        '-Werror=all',
        '-Wextra',
        '-Wno-error=maybe-uninitialized',
        '-Wno-error=unused-function',
        '-Wno-error=unused-but-set-variable',
        '-Wno-error=unused-variable',
        '-Wno-error=deprecated-declarations',
        '-Wno-unused-parameter',
        '-Wno-unused-but-set-parameter',
        '-Wno-missing-field-initializers',
        '-Wno-sign-compare',
        '-fno-rtti',
        '-MMD',
        '-DF_CPU=160000000L',
        '-DARDUINO=10813',
        '-DARDUINO_ESP32_DEV',
        '-DARDUINO_ARCH_ESP32',
        '-DARDUINO_BOARD=ESP32_DEV',
        '-DARDUINO_VARIANT=esp32',
        '-DESP32',
        '-DCORE_DEBUG_LEVEL=0',
    ]

    cpp.driverLinkerFlags: [
        "-nostdlib",

        "-u","esp_app_desc",
        "-u","ld_include_panic_highint_hdl",
        "-u","call_user_start_cpu0",

        "-Wl,--gc-sections",
        "-Wl,-static",
        "-Wl,--undefined=uxTopUsedPriority",
        "-Wl,-EL",

        "-u","__cxa_guard_dummy",
        "-u","__cxx_fatal_exception",
    ]

    Rule
    {
        name: "info"
        condition: true
        inputs: ["application.elf"]
        Artifact
        {
            filePath: input.baseName + ".info"
            fileTags: "application.info"
        }
        prepare:
        {
            var app = product.cpp.toolchainInstallPath + (product.cpp.toolchainPrefix ? "/" + product.cpp.toolchainPrefix : "/") + "size";

            var cmd = new Command(app, [input.filePath ]);
            cmd.description = "***Info: " + output.filePath;
            cmd.highlight = "linker";

            var cmdFile = new Command(app, [ input.filePath ]);
            cmdFile.stdoutFilePath = output.filePath;
            cmdFile.description = "***Info: " + output.filePath;
            cmdFile.highlight = "linker";

            return [cmd, cmdFile];
        }
    }

    Rule
    {
        name: "application.bin"
        condition: true
        inputs: ["application.elf"]
        Artifact
        {
            filePath: input.baseName + ".bin"
            fileTags: "application.bin"
        }
        prepare:
        {
            var esptool = project.path + "/ESP32/ESP32Arduino/tools/esptool_py/3.0.0/esptool.exe";
            //var eboot = project.path + "/ESP8266/Bootloaders/eboot/eboot.elf";
            var args = [
                        "--chip","esp32","elf2image",
                        "--flash_mode","dio",
                        "--flash_freq","80m",
                        "--flash_size","4MB",
                        "-o",output.filePath,
                        input.filePath,
                    ];
            var cmd = new Command(esptool, args);
            cmd.description = "***Generate: " + output.filePath;
            cmd.highlight = "linker";
            return [cmd];
        }
    }

    FileTagger {
        patterns: ["*.csv"]
        fileTags: ["csv"]
    }

    Rule
    {
        name: "partitions.bin"
        multiplex: true
        condition: true
        inputs: ["csv"]
        Artifact
        {
            filePath: input.baseName + ".partitions.bin"
            fileTags: "partitions.bin"
        }
        prepare:
        {
            var app = project.path + "/ESP32/ESP32Arduino/tools/gen_esp32part.exe";
            var args = [
                        "-q",input.filePath,
                        output.filePath,
                    ];
            var cmd = new Command(app, args);
            cmd.description = "***Generate: " + output.filePath;
            cmd.highlight = "linker";
            return [cmd];
        }
    }


    Rule
    {
        name: "flash.bat"
        condition: true
        multiplex: true
        inputs: ["application.bin", "partitions.bin", "application.info"]
        Artifact
        {
            filePath: product.name + ".flash.bat"
            fileTags: "application"
        }
        prepare:
        {
            //throw inputs["application.bin"][0].filePath + inputs["partitions.bin"][0].filePath;

            var cmd = new JavaScriptCommand();
            cmd.description = "***Generate: " + output.filePath;
            cmd.sourceCode = function() {
                var upload_speed = 921600;
                var flash_mode = "dio";
                var flash_freq = "80m";
                var build_boot = "qio"

                var ofile = new TextFile(output.filePath, TextFile.WriteOnly);

                ofile.write(project.path + "/ESP32/ESP32Arduino/tools/esptool_py/3.0.0/esptool.exe");
                ofile.write(" --chip esp32");
                ofile.write(" --port " + product.ESP32BuildConfig.serialPort);
                ofile.write(" --baud " + upload_speed);
                ofile.write(" --before default_reset");
                ofile.write(" --after hard_reset write_flash");
                ofile.write(" -z");
                ofile.write(" --flash_mode " + flash_mode);
                ofile.write(" --flash_freq " + flash_freq);
                ofile.write(" --flash_size detect");
                ofile.write(" 0xe000 " + project.path + "/ESP32/ESP32Arduino/tools/partitions/boot_app0.bin");
                ofile.write(" 0x1000 " + project.path + "/ESP32/ESP32Arduino/tools/sdk/bin/bootloader_" + build_boot + "_" + flash_freq + ".bin");
                ofile.write(" 0x10000 " + inputs["application.bin"][0].filePath);
                ofile.write(" 0x8000 " + inputs["partitions.bin"][0].filePath);

                ofile.close();
            }
            return [cmd];
        }
    }
}
