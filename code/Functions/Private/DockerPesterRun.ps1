Function DockerPesterRun {
    param(
        $ContainerName = "DockerPester",
        $Image,
        $InputFolder,
        $PathOnContainer = "/var",
        $PathToTests 
    )

    $Location = Get-Location

    if(!($PathToTests)){
        $TestPath = "$(Join-Path $(join-path $PathOnContainer (split-path $InputFolder -Leaf)) "Tests")"
    }else{
        $TestPath = "$(Join-Path $(join-path $PathOnContainer (split-path $InputFolder -Leaf)) $PathToTests)"
    }

    docker run -it -d -t --name $ContainerName $Image

    $CPString = "$($ContainerName):$($PathOnContainer)"

    docker cp $InputFolder $CPString
    
    docker exec $ContainerName pwsh -command "Install-Module Pester -Force"
    docker exec $ContainerName pwsh -command "ipmo pester"
    docker exec $ContainerName pwsh -command "cd $TestPath"
    docker exec -it $ContainerName pwsh -command "Invoke-Pester $TestPath -PassThru | Convertto-JSON | Out-File /var/Output.json"
    
    $CPString2 = "$($ContainerName):/var/Output.json"
    $CPString3 = (Join-Path $Location Output.json)
    docker cp $CPString2 $CPString3 
    #docker exec -it $ContainerName pwsh -command "Invoke-Pester $PathToTests -PassThru -Show None"
    #docker exec -it $ContainerName pwsh -command "$res | convertto-json"
 
    docker rm --force $ContainerName

}
