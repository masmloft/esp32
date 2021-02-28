import qbs.File
import qbs.FileInfo
import qbs.ModUtils
import qbs.PathTools
import qbs.Probes
import qbs.Process
import qbs.TextFile
import qbs.Utilities
import qbs.UnixUtils
import qbs.WindowsUtils

import "mingw.js" as mingw

CppBase {
    condition: qbs.toolchain && qbs.toolchain.contains("mingw")
    priority: 10

    //property bool test: {
        //throw "test"
    //}

    //binutilsPath: toolchainInstallPath

    cxxCompilerName: "g++"
    linkerName: "g++"
    staticLinkerName: "ar"

    defines: [
        "NDEBUG",
        "UNICODE",
        "_UNICODE",
        "WIN32",
//        "QT_NO_DEBUG",
    ]

    cxxArgs: {
        var args = [];
        return args;
    }

    cxxFlags: [
        "-pipe",
        //"-g",
        "-Wall",
        "-Wextra",
    ]

    Rule {
        name: "compiler"
        inputs: ["cpp"]
        Artifact {
            fileTags: ["obj"]
            //filePath: "" + input.fileName + ".o"
            filePath: FileInfo.joinPaths(Utilities.getHash(input.baseDir), input.fileName + ".o")
        }
        prepare: {
            return mingw.prepareCompiler(product, input, output);
        }
    }

    Rule {
        name: "ApplicationLinker"
        multiplex: true
        inputs: ['obj']
        inputsFromDependencies: ["staticlibrary", "dynamiclibrary_import"]
        Artifact {
            fileTags: ["application"]
            filePath: product.name + ".exe"
        }
        prepare: {
            return mingw.prepareApplicationLinker(product, inputs, output);
        }
    }

    Rule {
        name: "DynamicLibraryLinker"
        multiplex: true
        inputs: ['obj']
        inputsFromDependencies: ["staticlibrary", "dynamiclibrary_import"]
        outputFileTags: [ "dynamiclibrary", "dynamiclibrary_import" ]
        outputArtifacts: {
            var artifacts = []
            artifacts.push({
                fileTags: ["dynamiclibrary"],
                filePath: product.name + ".dll"
            });
            artifacts.push({
                fileTags: ["dynamiclibrary_import"],
                filePath: product.name + ".dll.a",
                alwaysUpdated: false
            });
            return artifacts;
        }

        prepare: {
            return mingw.prepareDynamicLibrary(product, inputs, outputs);
        }
    }

    Rule {
        name: "StaticLibraryLinker"
        multiplex: true
        inputs: ['obj']
        Artifact {
            fileTags: ["staticlibrary"]
            filePath: product.name + ".a"
        }
        prepare: {
            return mingw.prepareStaticLibrary(product, inputs, output);
        }
    }


}
