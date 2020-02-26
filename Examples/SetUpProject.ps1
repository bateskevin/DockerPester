$Param1 = @{
    InputFolder = "C:\code\PSHarmonize"
    Image = "mcr.microsoft.com/powershell:preview-nanoserver-1803"
    Context = "default"
    Executor = "WIN"
}

Add-DockerPesterProject @Param1

$Param2 = @{
    InputFolder = "C:\code\PSHarmonize"
    Image = "mcr.microsoft.com/powershell:7.0.0-rc.3-alpine-3.8"
    Context = "default"
    Executor = "LNX"
}

Add-DockerPesterProject @Param2