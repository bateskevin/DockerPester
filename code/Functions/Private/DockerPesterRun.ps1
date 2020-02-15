Function DockerPesterRun {
    param(
        $ContainerName = "DockerPester",
        $Image,
        $InputFolder,
        $PathOnContainer = "/var",
        $PathToTests,
        $Executor 
    )

    if($Executor -eq "WIN"){
        $Location = Get-Location

        if(!($PathToTests)){
            $TestPath = "$(Join-Path $(join-path $PathOnContainer (split-path $InputFolder -Leaf)) "Tests")"
        }else{
            $TestPath = "$(Join-Path $(join-path $PathOnContainer (split-path $InputFolder -Leaf)) $PathToTests)"
        }

        winpty docker.exe run --tty --name $ContainerName $Image

        $CPString = "$($ContainerName):$($PathOnContainer)"

        winpty docker cp $InputFolder $CPString
        
        winpty docker.exe exec --tty $ContainerName pwsh -command "Install-Module Pester -Force"
        winpty docker.exe exec --tty $ContainerName pwsh -command "ipmo pester"
        winpty docker.exe exec --tty $ContainerName pwsh -command "If(!(Test-Path $PathOnContainer)){New-Item $PathOnContainer -Recurse}"
        winpty docker.exe exec --tty $ContainerName pwsh -command "Invoke-Pester $TestPath -PassThru | Convertto-JSON | Out-File $PathOnContainer/Output.json"
        
        $CPString2 = "$($ContainerName):$($PathOnContainer)/Output.json"
        $CPString3 = (Join-Path $Location Output.json)
        docker.exe cp $CPString2 $CPString3 
        #docker exec -it $ContainerName pwsh -command "Invoke-Pester $PathToTests -PassThru -Show None"
        #docker exec -it $ContainerName pwsh -command "$res | convertto-json"
    
        winpty docker.exe --tty rm --force $ContainerName
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
