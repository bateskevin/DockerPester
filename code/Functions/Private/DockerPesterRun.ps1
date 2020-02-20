Function DockerPesterRun {
    param(
        $ContainerName = "DockerPester",
        $Image,
        $InputFolder,
        $PathOnContainer = "/var",
        $PathToTests,
        $Executor,
        [String[]]$PrerequisiteModule
    )

    if($Executor -eq "WIN"){

        Write-DockerPesterHost -Message "Executor is set to 'WIN'"

        $Location = Get-Location

        Write-DockerPesterHost -Message "Location is set to $Location"

        if(!($PathToTests)){
            $TestPath = "$PathOnContainer/$(split-path $InputFolder -Leaf)/Tests"
        }else{
            $TestPath = "$PathOnContainer/$(split-path $InputFolder -Leaf)/$PathToTests"
        }

        Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "Starting Container $ContainerName with image $Image"

        docker run -d -t --name $ContainerName $Image

        Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "Checking if $PathOnContainer exists on Container $ContainerName"

        docker exec $ContainerName powershell -command "if(!(Test-Path $PathOnContainer)){mkdir $PathOnContainer}"

        Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "Downloading latest Nuget Pakage Provider on container $ContainerName"
        docker exec $ContainerName powershell -command "$ProgressPreference = SilentlyContinue"

        docker exec $ContainerName powershell -command "try{Install-PackageProvider -Name NuGet -RequiredVersion 2.8.5.201 -Force -erroraction Stop}catch{throw 'Could not install packageprovider'}"

        $CPString = "$($ContainerName):$($PathOnContainer)"

        Write-DockerPesterHost -ContainerName $ContainerName -Image $Image -Message "Copy Sources $InputFolder to $PathOnContainer on Container $ContainerName"

        docker cp $InputFolder $CPString

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
        docker cp $CPString2 $CPString3 
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
