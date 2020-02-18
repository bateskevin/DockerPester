Function Add-DockerPesterProject {
    param(
        $ConfigPath = "$Home/DockerPester",
        $Name,
        $ContainerName = "DockerPester",
        $Image,
        $InputFolder,
        $PathOnContainer,
        $PathToTests,
        $Executor,
        [String[]]$PrerequisiteModule
    )

    $InputFolder = (Get-Item $InputFolder).FullName

    if(!($Executor) -and $PSVersionTable.PSVersion.Major -gt 5){
        if($IsLinux -or $IsMacOS){
            $Executor = "LNX"
        }elseif($IsWindows){
            $Executor = "WIN"
        }
    }

    if(!($PathOnContainer)){
        Switch ($Executor) {

            "WIN" {$PathOnContainer = "C:/Temp"}
            "LNX" {$PathOnContainer = "/var"}
        }
    }

    if(!($Name)){
        $Name = Split-Path $InputFolder -Leaf 
    }

    if(!($PathToTests)){
        $PathToTests = "Tests"
    }
    
    [PSCustomObject]$ConfigObj = @{
        ContainerName = $ContainerName
        Image = $Image
        InputFolder = $InputFolder
        PathOnContainer = $PathOnContainer
        PathToTests = $PathToTests
        Executor = $Executor
        PrerequisiteModule = $PrerequisiteModule

    }

    $ConfigFileName = "$ConfigPath/$Name.json"

    if(!(Test-Path $ConfigPath)){
        $null = New-Item $ConfigPath -Force -ItemType Directory
    }

    if(!(Test-Path $ConfigFileName)){
        $null = New-Item $ConfigFileName -ItemType File
    }
    
    $CurrentJSON = Get-Content $ConfigFileName | ConvertFrom-Json -Depth 7

    $arr = @()

    foreach($instance in $CurrentJSON){
        $arr += $instance
    }

    $arr += $ConfigObj

    $arr | ConvertTo-Json -Depth 7 | Out-File -FilePath $ConfigFileName


}