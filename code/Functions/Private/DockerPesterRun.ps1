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
        $Location = Get-Location

        if(!($PathToTests)){
            $TestPath = "$PathOnContainer/$(split-path $InputFolder -Leaf)/Tests"
        }else{
            $TestPath = "$PathOnContainer/$(split-path $InputFolder -Leaf)/$PathToTests"
        }

        docker run -d -t --name $ContainerName $Image

        docker exec $ContainerName powershell -command "if(!(Test-Path $PathOnContainer)){mkdir $PathOnContainer}"

        docker exec $ContainerName powershell -command "try{Install-PackageProvider -Name NuGet -RequiredVersion 2.8.5.201 -Force -erroraction Stop}catch{throw 'Could not install packageprovider'}"

        $CPString = "$($ContainerName):$($PathOnContainer)"

        docker cp $InputFolder $CPString

        if($PrerequisiteModule){
            foreach($Module in $PrerequisiteModule){
                docker exec $ContainerName powershell -command "Install-Module $Module -Force"
            }
        }
        
        docker exec $ContainerName powershell -command "Install-Module Pester -Force -SkipPublisherCheck"
        docker exec $ContainerName powershell -command "ipmo pester"
        docker exec $ContainerName powershell -command "If(!(Test-Path $PathOnContainer)){New-Item $PathOnContainer -Recurse}"
        docker exec $ContainerName powershell -command "Invoke-Pester $TestPath -PassThru | Convertto-JSON | Out-File $PathOnContainer/Output.json"
        
        $CPString2 = "$($ContainerName):$($PathOnContainer)/Output.json"
        $CPString3 = (Join-Path $Location Output.json)
        docker cp $CPString2 $CPString3 
        #docker exec -it $ContainerName pwsh -command "Invoke-Pester $PathToTests -PassThru -Show None"
        #docker exec -it $ContainerName pwsh -command "$res | convertto-json"
    
        docker  rm --force $ContainerName
    }else{
        $Location = Get-Location

        if(!($PathToTests)){
            $TestPath = "$(Join-Path $(join-path $PathOnContainer (split-path $InputFolder -Leaf)) "Tests")"
        }else{
            $TestPath = "$(Join-Path $(join-path $PathOnContainer (split-path $InputFolder -Leaf)) $PathToTests)"
        }

        docker run -d -t --name $ContainerName $Image

        $CPString = "$($ContainerName):$($PathOnContainer)"

        docker cp $InputFolder $CPString

        if($PrerequisiteModule){
            foreach($Module in $PrerequisiteModule){
                docker exec $ContainerName pwsh -command "Install-Module $Module -Force"
            }
        }
        
        docker exec $ContainerName pwsh -command "Install-Module Pester -Force"
        docker exec $ContainerName pwsh -command "ipmo pester"
        docker exec $ContainerName pwsh -command "Invoke-Pester $TestPath -PassThru | Convertto-JSON | Out-File $PathOnContainer/Output.json"
        
        $CPString2 = "$($ContainerName):$($PathOnContainer)/Output.json"
        $CPString3 = (Join-Path $Location Output.json)
        docker cp $CPString2 $CPString3 
        #docker exec -it $ContainerName pwsh -command "Invoke-Pester $PathToTests -PassThru -Show None"
        #docker exec -it $ContainerName pwsh -command "$res | convertto-json"
    
        docker rm --force $ContainerName
    }

    

}
