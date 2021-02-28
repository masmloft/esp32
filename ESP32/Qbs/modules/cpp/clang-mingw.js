var utils = require("utils.js");


function prepareCompiler(product, input, output)
{
    var args = [];
    if (input.cpp.debugInformation)
        args.push('-g');
    else
        args.push('-O2');

    if (product.cpp.sysroot)
        args.push('--sysroot=' + product.cpp.sysroot);

    if(product.cpp.driverFlags)
        Array.prototype.push.apply(args, product.cpp.driverFlags);
    args = args.concat(product.cpp.cxxFlags)
    if (input.cpp.defines)
        args = args.concat([].uniqueConcat(input.cpp.defines).map(function(item) { return "-D" + item; }));
    if (input.cpp.includePaths)
        args = args.concat([].uniqueConcat(input.cpp.includePaths).map(function(item) { return "-I" + item; }));
    args.push('-o', output.filePath);
    args.push('-c', input.filePath);

    var app = product.cpp.toolchainInstallPath + "/" + product.cpp.cxxCompilerName;
    var cmd = new Command(app, args);
    cmd.description = "***Compiling " + input.fileName;
    if(product.cpp.verbose)
        cmd.description = "\n" + cmd.description + "\n" + app + " " + args.join(" ");
    return cmd;
}

function prepareStaticLibrary(product, inputs, output)
{
    var args = [];
    args.push('rcs');
    args.push(output.filePath);
    for (i in inputs["obj"])
        args.push(inputs["obj"][i].filePath);

    var prg = product.cpp.toolchainInstallPath + "/" + product.cpp.staticLinkerName;

    var cmd = new Command(prg, args);
    cmd.description = "***Creating " + output.fileName;
    if(product.cpp.verbose)
        cmd.description = "\n" + cmd.description + "\n" + prg + " " + args.join(" ");
    cmd.highlight = "linker";
    return [cmd];
}

function linker_getFlags(product, inputs)
{
    var args = [];

    if(product.cpp.driverFlags)
        Array.prototype.push.apply(args, product.cpp.driverFlags);
    if(product.cpp.driverLinkerFlags)
        Array.prototype.push.apply(args, product.cpp.driverLinkerFlags);

    var linkerFlags = [];
    if(product.consoleApplication === false)
        linkerFlags.push("-subsystem", "windows");
    linkerFlags = linkerFlags.concat(product.cpp.linkerFlags)

    args = args.concat([["-Wl"].concat(linkerFlags).join(',')]);

    return args;
}

function linker_appendLibs(outputs, inputs, get)
{
    if(inputs)
    {
        var ret = [];
        for (i in inputs)
        {
            var item = get(inputs[i]);
            if (FileInfo.isAbsolutePath(item) || item.startsWith('@'))
                //ret.push(item);
                ret.unshift(item);
            else
                ret.unshift("-l" + item);
        }
        outputs = outputs.uniqueConcat(ret);
    }
    return outputs;
}

function prepareApplicationLinker(product, inputs, output)
{
    var args = [];

    args = args.concat(linker_getFlags(product, inputs));

    args.push('-o', output.filePath);
    for (i in inputs["obj"])
        args.push(inputs["obj"][i].filePath);

    args = linker_appendLibs(args, inputs.staticlibrary, function(a) { return a.filePath; });
    args = linker_appendLibs(args, inputs.dynamiclibrary_import, function(a) { return a.filePath; });

    args = args.uniqueConcat(product.cpp.libraryPaths.map(function(a) { return '-L' + a }));
    args = linker_appendLibs(args, product.cpp.staticLibraries, function(a) { return a; });
    args = linker_appendLibs(args, product.cpp.dynamicLibraries, function(a) { return a; });

    var app = product.cpp.toolchainInstallPath + "/" + product.cpp.linkerName;

    var cmd = new Command(app, args);
    cmd.description = "***Linking " + output.fileName;
    if(product.cpp.verbose)
        cmd.description = "\n" + cmd.description + "\n" + app + " " + args.join(" ");
    cmd.highlight = "linker";
    return [cmd];
}

function prepareDynamicLibrary(product, inputs, outputs)
{
    //utils.dumpObject(outputs.dynamiclibrary[0].filePath, "");
    var args = [];
    args = args.concat(product.cpp.linkerFlags)
    args.push("-shared");
    args.push('-o', outputs.dynamiclibrary[0].filePath);
    args.push("-Wl,--out-implib," + outputs.dynamiclibrary_import[0].filePath);
    for (i in inputs["obj"])
        args.push(inputs["obj"][i].filePath);
    for (i in inputs.staticlibrary)
        args.push(inputs.staticlibrary[i].filePath);

    var prg = product.cpp.toolchainInstallPath + "/" + product.cpp.linkerName;

    var cmd = new Command(prg, args);
    cmd.description = "***Linking " + outputs.dynamiclibrary[0].fileName;
    if(product.cpp.verbose)
        cmd.description = "\n" + cmd.description + "\n" + prg + " " + args.join(" ");
    cmd.highlight = "linker";
    return [cmd];
}
