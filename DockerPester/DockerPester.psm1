#Generated at 03/03/2020 17:57:54 by Kevin Bates
Function DockerPesterRun {
    param(
        $ContainerName = "DockerPester",
        $Image,
        $InputFolder,
        $PathOnContainer = "/var",
        $PathToTests,
        $Executor,
        [String[]]$PrerequisiteModule,
        $Context
    )

    
    if($PSVersionTable.PSVersion.Major -gt 5 -and $IsMacOS -or $IsLinux){
        Write-DockerPesterHost -Message "Context is set to $Context"
        docker context use $Context
    }elseif(Test-Path "$Env:ProgramFiles\Docker\Docker\DockerCli.exe"){
        if($Executor -eq "WIN"){
            Write-DockerPesterHost -Message "Daemon switching to Windows Containers. This takes a few seconds..."
            & $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchWindowsEngine
            #Start-Sleep -Seconds 15
        }elseif($Executor -eq "LNX"){
            Write-DockerPesterHost -Message "Daemon switching to Linux Containers. This takes a few seconds..."
            & $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchLinuxEngine
            #Start-Sleep -Seconds 15
        }
    }
    
    if($Executor -eq "WIN"){

        Write-DockerPesterHost -Message "Executor is set to 'WIN'"

        $Location = Get-Location

        Write-DockerPesterHost -Message "Location is set to $Location"

        if(!($PathToTests)){
            $TestPath = "$PathOnContainer/$(split-path $InputFolder -Leaf)/Tests"
        }else{
            $TestPath = "$PathOnContainer/$(split-path $InputFolder -Leaf)/$PathToTests"
        }

        $Repository = $Image.Split(":")[0]
        $Tag = $Image.Split(":")[1]

        if(!((Get-DockerImages).tag.contains("$Tag") -and (Get-DockerImages -erroraction SilentlyContinue).Repository.contains("$Repository"))){
            Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "Pulling image $Image because it is not available locally."
            docker pull $Image
        }

        Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "Starting Container $ContainerName with image $Image"

        docker run -d -t --name $ContainerName $Image

        Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "Checking if $PathOnContainer exists on Container $ContainerName"

        docker exec $ContainerName powershell -command "if(!(Test-Path $PathOnContainer)){mkdir $PathOnContainer}"

        Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "Downloading latest Nuget Pakage Provider on container $ContainerName"
        docker exec $ContainerName powershell -command "$ProgressPreference = SilentlyContinue"

        docker exec $ContainerName powershell -command "try{Install-PackageProvider -Name NuGet -RequiredVersion 2.8.5.201 -Force -erroraction Stop}catch{throw 'Could not install packageprovider'}"

        $CPString = "$($ContainerName):$($PathOnContainer)"

        if($PSVersionTable.PSVersion.Major -lt 6 -and !($IsMacOS) -or !($IsLinux)){

            Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "Copy Sources $InputFolder to $PathOnContainer on Container $ContainerName"
            docker stop $ContainerName
            docker cp $InputFolder $CPString
            docker start $ContainerName
        }else{
            Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "Copy Sources $InputFolder to $PathOnContainer on Container $ContainerName"

            docker cp $InputFolder $CPString
        }

        

        Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "Checking for Prerequisite Modules"
        docker exec $ContainerName powershell -command "$ProgressPreference = SilentlyContinue"

        if($PrerequisiteModule){
            foreach($Module in $PrerequisiteModule){
                Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "Installing Prerequisite Module $Module on Container $ContainerName"
                docker exec $ContainerName powershell -command "Install-Module $Module -Force | Out-Null" | Out-Null
            }
        }else{
            Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "No Prerequisite Modules defined"
        }
        
        Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "Installing Pester on Container $ContainerName"
        docker exec $ContainerName powershell -command "$ProgressPreference = SilentlyContinue"
        docker exec $ContainerName powershell -command "Install-Module Pester -Force -SkipPublisherCheck | Out-Null" | Out-Null
        docker exec $ContainerName powershell -command "ipmo pester"
        
        Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "Creating $PathOnContainer on Container $ContainerName"
        docker exec $ContainerName powershell -command "If(!(Test-Path $PathOnContainer)){New-Item $PathOnContainer -Recurse}"
        
        Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "Starting Pester Tests on Container $ContainerName"
        docker exec $ContainerName powershell -command "Invoke-Pester $TestPath -PassThru | Convertto-JSON | Out-File -FilePath $PathOnContainer/Output.json"
        
        $CPString2 = "$($ContainerName):$($PathOnContainer)/Output.json"
        $CPString3 = "$($Location)/Output.json"

        if($PSVersionTable.PSVersion.Major -lt 6 -and !($IsMacOS) -or !($IsLinux)){

            Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "Copy Sources $InputFolder to $PathOnContainer on Container $ContainerName"
            docker stop $ContainerName
            docker cp $CPString2 $CPString3
            docker start $ContainerName
        }else{
            Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "Copy Sources $InputFolder to $PathOnContainer on Container $ContainerName"

            docker cp $CPString2 $CPString3
        }

        #docker exec -it $ContainerName pwsh -command "Invoke-Pester $PathToTests -PassThru -Show None"
        #docker exec -it $ContainerName pwsh -command "$res | convertto-json"
    
        Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "Removing Container $ContainerName"
        docker  rm --force $ContainerName
    }else{
        Write-DockerPesterHost -Message "Executor is set to 'LNX'"
        
        $Location = Get-Location

        Write-DockerPesterHost -Message "Location is set to $Location"

        if(!($PathToTests)){
            $TestPath = "$PathOnContainer/$(split-path $InputFolder -Leaf)/Tests"
        }else{
            $TestPath = "$PathOnContainer/$(split-path $InputFolder -Leaf)/$PathToTests"
        }

        Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "Starting Container $ContainerName with image $Image"

        docker run -d -t --name $ContainerName $Image

        docker start $ContainerName

        $CPString = "$($ContainerName):$($PathOnContainer)"

        Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "Copy Sources $InputFolder to $PathOnContainer on Container $ContainerName"

        docker cp $InputFolder $CPString

        Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "Checking for Prerequisite Modules"
        docker exec $ContainerName pwsh -command "$ProgressPreference = SilentlyContinue"

        if($PrerequisiteModule){
            foreach($Module in $PrerequisiteModule){
                Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "Installing Prerequisite Module $Module on Container $ContainerName"
                docker exec $ContainerName pwsh -command "Install-Module $Module -Force | Out-Null" | Out-Null
            }
        }else{
            Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "No Prerequisite Modules defined"
        }
        
        docker exec $ContainerName pwsh -command "$ProgressPreference = SilentlyContinue"
        Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "Installing Pester on Container $ContainerName"
        docker exec $ContainerName pwsh -command "Install-Module Pester -Force | Out-Null" | Out-Null
        docker exec $ContainerName pwsh -command "ipmo pester"

        Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "Starting Pester Tests on Container $ContainerName"
        docker exec $ContainerName pwsh -command "Invoke-Pester $TestPath -PassThru | Convertto-JSON | Out-File -FilePath $PathOnContainer/Output.json"
        
        $CPString2 = "$($ContainerName):$($PathOnContainer)/Output.json"
        $CPString3 = "$($Location)/Output.json"
        docker cp $CPString2 $CPString3 
        #docker exec -it $ContainerName pwsh -command "Invoke-Pester $PathToTests -PassThru -Show None"
        #docker exec -it $ContainerName pwsh -command "$res | convertto-json"
    
        Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "Removing Container $ContainerName"
        docker rm --force $ContainerName
    }

    

}
Function Get-DockerPesterPassthruPbject {
    param(
        $Location,
        $FileName = "Output.json"
    )

    $File = "$Location/$FileName"

    $PassThru = Get-Content $File | ConvertFrom-Json

    Remove-Item $File

    return $PassThru

}
Function Write-DockerPesterHost {
    param(
        $Image,
        $ContainerName,
        $Message
    )

    if($ContainerName -and $Image){
        Write-Host "`n[DockerPester][$($ContainerName)][$($Image)]" -ForegroundColor Cyan
        Write-Host "$Message" -ForegroundColor DarkGray
        Write-Host ""
    }else{
        Write-Host "`n[DockerPester]"  -ForegroundColor Cyan
        Write-Host "$Message" -ForegroundColor DarkGray
        Write-Host ""
    }
    
}
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
        [String[]]$PrerequisiteModule,
        $Context
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
        Context = $Context

    }

    $ConfigFileName = "$ConfigPath/$Name.json"

    if(!(Test-Path $ConfigPath)){
        $null = New-Item $ConfigPath -Force -ItemType Directory
    }

    if(!(Test-Path $ConfigFileName)){
        $null = New-Item $ConfigFileName -ItemType File
    }
    
    if($PSVersionTable.PSVersion -gt 5){
        $CurrentJSON = Get-Content $ConfigFileName | ConvertFrom-Json -Depth 7
    }else{
        $CurrentJSON = Get-Content $ConfigFileName | ConvertFrom-Json
    }
    

    $arr = @()

    foreach($instance in $CurrentJSON){
        $arr += $instance
    }

    $arr += $ConfigObj

    if($PSVersionTable.PSVersion -gt 5){
        $arr | ConvertTo-Json -Depth 7 | Out-File -FilePath $ConfigFileName
    }else{
        $arr | ConvertTo-Json | Out-File -FilePath $ConfigFileName
    }

}
Function Get-Dockercontext {
    $Images = docker context ls

    $count = 0

    Foreach($Line in $Images){
        if($count -eq 0){
            $Arr = @()
        }else{

            $SplitLine = $Line.Split(" ")

            $PropertyCount = 0
            Foreach($Object in $SplitLine){
                if($Object.Length -gt 2){
                    Switch ($PropertyCount) {
                        0 {$Repository = $Object;$PropertyCount++}
                        1 {$Tag = $Object;$PropertyCount++}
                        2 {$ImageID = $Object;$PropertyCount++}
                        3 {$Created = $Object;$PropertyCount++}
                        4 {$Size = $Object;$PropertyCount++}
                    }                
                }
            }

            $Obj = [PSCustomObject]@{
                Repository = $Repository
                Tag = $Tag
                ImageID = $ImageID
                Created = $Created
                Size = $Size
            }

            $Arr += $Obj

        }

        $count++
    }
    Return $Arr
}
Function Get-DockerImages {
    $Images = docker images

    $count = 0

    Foreach($Line in $Images){
        if($count -eq 0){
            $Arr = @()
        }else{

            $SplitLine = $Line.Split(" ")

            $PropertyCount = 0
            Foreach($Object in $SplitLine){
                if($Object.Length -gt 2){
                    Switch ($PropertyCount) {
                        0 {$Repository = $Object;$PropertyCount++}
                        1 {$Tag = $Object;$PropertyCount++}
                        2 {$ImageID = $Object;$PropertyCount++}
                        3 {$Created = $Object;$PropertyCount++}
                        4 {$Size = $Object;$PropertyCount++}
                    }                
                }
            }

            $Obj = [PSCustomObject]@{
                Repository = $Repository
                Tag = $Tag
                ImageID = $ImageID
                Created = $Created
                Size = $Size
            }

            $Arr += $Obj

        }

        $count++
    }
    Return $Arr
}
Function Get-DockerPesterContext {

    $Context = Get-Content "$HOME/DockerPester/Context.json" | ConvertFrom-Json -Depth 7

    return $Context

}
Function Get-DockerPesterProject {
    param(
        [Switch]$List,
        $Name
    )

    if($List){
        (Get-ChildItem $HOME/DockerPester -File).Name.TrimEnd(".json")
    }elseif($Name){
        $Obj = Get-Content "$HOME/DockerPester/$($Name).json" | ConvertFrom-Json
        return $Obj
    }else{
        throw "Please specify one of the parameters ('List','Name')"
    }



}
Function Get-LatestDockerPesterResults {
    param(
        $Project
    )

    $Jobs = Get-Content "$HOME/DockerPester/$($Project).json" | ConvertFrom-Json -Depth 7

    $LatestCount = $Jobs.Count 

    $ProjectResults = Get-ChildItem "$HOME/DockerPester/$($Project)_Tests"

    $LatestTests = $ProjectResults | Sort-Object Name -Descending | select -first $LatestCount

    $Arr = @()

    Foreach($Result in $LatestTests){

        $Passthru = Get-Content $Result.FullName | ConvertFrom-Json -Depth 7 

        $ImageNameWithJson = $Result.Name.split('_')[1]

        [PSCustomObject]$PassthruObject = @{
            DateOfTest = $Result.Name.split('_')[0]
            Image = $ImageNameWithJson.TrimEnd('.json')
            PassThru = $Passthru
        }

        $Arr += $PassthruObject
    }

    return $Arr
}
Function Invoke-DockerPester {
    param(
        $ContainerName = "DockerPester",
        $Image,
        $InputFolder,
        $PathOnContainer = "/var",
        $PathToTests,
        $Executor,
        [String[]]$PrerequisiteModule,
        $Project,
        $Context = "default"
    )
 
    if($Project){

        $Location = Get-Location
    
        $ParamSets = Get-DockerPesterProject -Name $Project 

        foreach($ParamSet in $ParamSets){

            Write-DockerPesterHost -Message "Starting run for Image $($ParamSet.Image)"
            Write-Host ""
            Write-Host ""

            if(!($ParamSet.Context)){
                $Context = "default"

                $Hash = @{
                    ContainerName = $ParamSet.ContainerName
                    Image = $ParamSet.Image
                    InputFolder = $ParamSet.InputFolder
                    PathOnContainer = $ParamSet.PathOnContainer
                    PathToTests = $ParamSet.PathToTests
                    Executor = $ParamSet.Executor
                    PrerequisiteModule = $ParamSet.PrerequisiteModule
                    Context = $Context
                }
            }else{

                $Context = $ParamSet.Context

                $Res = get-DockerPesterContext
                if($PSVersionTable.PSVersion.Major -gt 5 -and $IsMacOS -or $IsLinux){
                    $Executor = ($Res | ?{$_.Context -eq $Context}).Executor
                }else{
                    $Executor = $ParamSet.Executor
                }
                
                $Hash = @{
                    ContainerName = $ParamSet.ContainerName
                    Image = $ParamSet.Image
                    InputFolder = $ParamSet.InputFolder
                    PathOnContainer = $ParamSet.PathOnContainer
                    PathToTests = $ParamSet.PathToTests
                    Executor = $Executor
                    PrerequisiteModule = $ParamSet.PrerequisiteModule
                    Context = $Context
                }
            }
            
            DockerPesterRun @Hash

            $PassThruObject = Get-DockerPesterPassthruPbject -Location $Location

            [PSCustomObject]$Object = @{
                TagFilter = $PassThruObject.TagFilter
                ExcludeTagFilter = $PassThruObject.ExcludeTagFilter
                TestNameFilter = $PassThruObject.TestNameFilter
                ScriptBlockFilter = $PassThruObject.ScriptBlockFilter
                TotalCount = $PassThruObject.TotalCount
                PassedCount = $PassThruObject.PassedCount
                FailedCount = $PassThruObject.FailedCount
                SkippedCount = $PassThruObject.SkippedCount
                PendingCount = $PassThruObject.PendingCount
                InconclusiveCount = $PassThruObject.InconclusiveCount
                Time = $PassThruObject.Time
                TestResult = $PassThruObject.TestResult
            }

            $Date = Get-Date -f yyyyMMddhhmmss

            $ImageName = $ParamSet.Image.Replace('/','')
            $ImageName = $Imagename.Replace(':','')
            
            if(!(Test-Path "$HOME/DockerPester/$($Project)_Tests/")){
                $null = New-Item "$HOME/DockerPester/$($Project)_Tests/" -ItemType Directory
            }

            $Object | ConvertTo-Json -Depth 7 | Out-File -FilePath "$HOME/DockerPester/$($Project)_Tests/$($Date)_$($ImageName).json"
        }

        Write-DockerPesterHost -Message "Find your Test Results at '$HOME/DockerPester/$($Project)_Tests/' or use 'Get-LatestDockerPesterResults -Project $Project' to retrieve the result as an object."

    }else{

        if(!($Context)){
            $Context = "default"
        }

        Write-DockerPesterHost -Message "Starting run for Image $($Image)"

        $Location = Get-Location

        DockerPesterRun -ContainerName $ContainerName -Image $Image -InputFolder $InputFolder -PathOnContainer $PathOnContainer -PathToTests $PathToTests -Executor $Executor -PrerequisiteModule $PrerequisiteModule -Context $Context

        $PassThruObject = Get-DockerPesterPassthruPbject -Location $Location

        return $PassThruObject
    }

}
Function Remove-DockerPesterProject {
    param(
        $Name
    )
    if(Test-Path "$Home/DockerPester/$($Name).json"){
        Remove-Item "$Home/DockerPester/$($Name).json"
    }
    
    if(Test-Path "$Home/DockerPester/$($Name)_Tests"){
        Remove-Item "$Home/DockerPester/$($Name)_Tests"
    }

}
Function Set-DockerPesterContext {
    param(
        $Context,
        $Executor
    )

    $ContextJSON = "$HOME/DockerPester/Context.json"

    [PSCustomObject]$Object = @{
        Context = $Context
        Executor = $Executor

    }

    $CurrentJSON = Get-Content $ContextJSON | ConvertFrom-Json -Depth 7

    $arr = @()

    foreach($instance in $CurrentJSON){
        $arr += $instance
    }

    $arr += $Object

    $arr | ConvertTo-Json -Depth 7 | Out-File -FilePath $ContextJSON

    Write-DockerPesterHost -Message "Set Context $($Context):$($executor)"

}
