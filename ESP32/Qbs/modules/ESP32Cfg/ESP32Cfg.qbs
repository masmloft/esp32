import qbs
import qbs.FileInfo
import qbs.TextFile

Module {

    property string serialPort: "COM1"
    property string serialPortSpeed: "921600"
    property string flashMode: "dio"
    property string flashFreq: "80m"
    property string flashSize: "4MB"
    property string bootloaderMode: "qio"

    property path toolsPath: path + "./../../../Libs/"
    property path gen_esp32part: toolsPath + "/tools/gen_esp32part.exe"
    property path esptool: toolsPath + "/tools/esptool_py/3.0.0/esptool.exe"
    property path bootApp: toolsPath + "/tools/partitions/boot_app0.bin"
    property path bootloader: toolsPath + "/tools/sdk/bin/bootloader_" + bootloaderMode + "_" + flashFreq + ".bin"

    Depends { name: "cpp" }

    cpp.assemblerFlags: [
    ]

    cpp.commonCompilerFlags: [
        '-Os',
        '-g3',

        '-nostdlib',
        '-fstack-protector',
        '-ffunction-sections',
        '-fdata-sections',
        '-fstrict-volatile-bitfields',
        '-mlongcalls',
        '-MMD',

        '-Wall',
        '-Werror=all',
        '-Wextra',
        '-Wpointer-arith',
        '-Wno-unused-parameter',
        '-Wno-sign-compare',

        '-DESP_PLATFORM',
        '-DMBEDTLS_CONFIG_FILE=\"mbedtls/esp_config.h\"',
        '-DHAVE_CONFIG_H',
        '-DGCC_NOT_5_2_0=0',
        '-DWITH_POSIX',

        '-DF_CPU=160000000L',
        '-DARDUINO=10813',
        '-DARDUINO_ESP32_DEV',
        '-DARDUINO_ARCH_ESP32',
        '-DARDUINO_BOARD=ESP32_DEV',
        '-DARDUINO_VARIANT=esp32',
        '-DESP32',
        '-DCORE_DEBUG_LEVEL=0',

    ]

    cpp.cFlags: [
        '-std=gnu99',
        '-Wno-maybe-uninitialized',
        '-Wno-unused-function',
        '-Wno-unused-but-set-variable',
        '-Wno-unused-variable',
        '-Wno-deprecated-declarations',
        '-Wno-old-style-declaration',
    ]

    cpp.cxxFlags: [
        '-std=gnu++11',
        '-fexceptions',
        '-fno-rtti',
        '-Wno-error=unused-function',
        '-Wno-error=maybe-uninitialized',
        '-Wno-error=unused-but-set-variable',
        '-Wno-error=unused-variable',
        '-Wno-error=deprecated-declarations',
        '-Wno-unused-but-set-parameter',
        '-Wno-missing-field-initializers',
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
        name: "application.info"
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
            cmd.description = "***Info: " + output.fileName;
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
        name: "elf->bin"
        condition: true
        inputs: ["application.elf"]
        Artifact
        {
            filePath: input.baseName + ".bin"
            fileTags: "application.bin"
        }
        prepare:
        {
            var app = product.ESP32Cfg.esptool;
            var args = [
                        "--chip","esp32","elf2image",
                        "--flash_mode", product.ESP32Cfg.flashMode,
                        "--flash_freq", product.ESP32Cfg.flashFreq,
                        "--flash_size", product.ESP32Cfg.flashSize,
                        "-o", output.filePath,
                        input.filePath
                    ];
            var cmd = new Command(app, args);
            cmd.description = "***Generate: " + output.fileName;
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
            var app = product.ESP32Cfg.gen_esp32part;
            var args = [ "-q", input.filePath, output.filePath ];
            var cmd = new Command(app, args);
            cmd.description = "***Generate: " + output.fileName;
            cmd.highlight = "linker";
            return [cmd];
        }
    }


    Rule
    {
        name: "gen-flash.bat"
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
            var cmd = new JavaScriptCommand();
            cmd.description = "***Generate: " + output.fileName;
            cmd.sourceCode = function() {
                var ofile = new TextFile(output.filePath, TextFile.WriteOnly);

                ofile.write(product.ESP32Cfg.esptool);
                ofile.write(" --chip esp32");
                ofile.write(" --port " + product.ESP32Cfg.serialPort);
                ofile.write(" --baud " + product.ESP32Cfg.serialPortSpeed);
                ofile.write(" --before default_reset");
                ofile.write(" --after hard_reset write_flash");
                ofile.write(" -z");
                ofile.write(" --flash_mode " + product.ESP32Cfg.flashMode);
                ofile.write(" --flash_freq " + product.ESP32Cfg.flashFreq);
                ofile.write(" --flash_size detect");
                ofile.write(" 0xe000 " + product.ESP32Cfg.bootApp);
                ofile.write(" 0x1000 " + product.ESP32Cfg.bootloader);
                ofile.write(" 0x10000 " + inputs["application.bin"][0].filePath);
                ofile.write(" 0x8000 " + inputs["partitions.bin"][0].filePath);

                ofile.close();
            }
            return [cmd];
        }
    }
}
