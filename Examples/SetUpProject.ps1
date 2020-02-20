$Param1 = @{
    InputFolder = "/Users/kevin/code/PSAtlas"
    Image = "mcr.microsoft.com/windows/servercore:ltsc2019"
    Context = "2019-box"
    Executor = "WIN"
}

Add-DockerPesterProject @Param1

$Param2 = @{
    InputFolder = "/Users/kevin/code/PSAtlas"
    Image = "mcr.microsoft.com/powershell:7.0.0-rc.2-alpine-3.10"
    Context = "default"
    Executor = "LNX"
}

Add-DockerPesterProject @Param2