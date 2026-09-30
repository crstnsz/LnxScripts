#!/usr/bin/env dotnet-cake
using System;
using System.IO;
using System.Linq;
using System.Reflection.PortableExecutable;

// Captura o parâmetro "path" da linha de comando, com um fallback padrão
var targetPath = Argument("path", "./");

Task("CheckDllArchitecture")
    .Does(() =>
{
    if (!DirectoryExists(targetPath))
    {
        Error($"Pasta não encontrada: {targetPath}");
        return;
    }

    CheckAllFiles(targetPath, ".dll");
    CheckAllFiles(targetPath, ".exe");
});

// Funções auxiliares declaradas no script
void CheckAllFiles(string path, string searchPattern)
{
    var files = GetFiles($"{path}/*{searchPattern}").ToList();

    if (!files.Any())
    {
        Warning($"Nenhuma {searchPattern} encontrada na pasta.");
        return;
    }

    Information($"Analisando {files.Count} arquivo(s) {searchPattern}...");
    Information(string.Format("{0,-50} {1}", "Arquivo", "Arquitetura"));
    Information(new string('-', 70));

    foreach (var file in files)
    {
        string architecture = "Desconhecido";
        try
        {
            using var stream = System.IO.File.OpenRead(file.FullPath);
            using var peReader = new PEReader(stream);

            architecture = GetArchitectureDescription(
                peReader.PEHeaders.CoffHeader.Machine,
                peReader.PEHeaders.CorHeader?.Flags);
        }
        catch (BadImageFormatException)
        {
            architecture = "Não é um executável/DLL .NET válido (ex: biblioteca nativa)";
        }
        catch (Exception ex)
        {
            architecture = $"Erro: {ex.Message}";
        }

        Information(string.Format("{0,-50} {1}", file.GetFilename().ToString(), architecture));
    }
}

string GetArchitectureDescription(Machine machine, CorFlags? corFlags)
{
    if (corFlags == null)
    {
        return machine switch
        {
            Machine.I386 => "x86 - No Core flags (32 bits)",
            Machine.Amd64 => "x64 - No Core flags (64 bits)",
            Machine.Arm64 => "ARM64 - No Core flags",
            _ => $"Outra ({machine}) - No Core flags",
        };
    }

    bool isILOnly = (corFlags & CorFlags.ILOnly) != 0;
    bool is32BitRequired = (corFlags & CorFlags.Requires32Bit) != 0;
    bool is32BitPreferred = (corFlags & CorFlags.Prefers32Bit) != 0;

    return machine switch
    {
        Machine.I386 => isILOnly
            ? (is32BitRequired 
                ? "x86 (com Requires32Bit / 32-Bit Required)"
                : is32BitPreferred
                    ? "Any CPU (com Prefer 32-Bit)"
                    : "Any CPU (64-bit e 32-bit compatível)")
            : "x86 Nativo / C++ CLI (32 bits)",
        Machine.Amd64 => "x64 Nativo (64 bits)",
        Machine.Arm64 => "ARM64",
        _ => $"Outra ({machine})",
    };
}

// Ponto de entrada do script
RunTarget("CheckDllArchitecture");
