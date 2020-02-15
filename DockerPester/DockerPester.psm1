#Generated at 02/16/2020 00:30:01 by Kevin Bates
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
Function Get-DockerPesterPassthruPbject {
    param(
        $Location,
        $FileName = "Output.json"
    )

    $File = Join-Path $Location $FileName

    $PassThru = Get-Content $File | ConvertFrom-Json

    Remove-Item $File

    return $PassThru

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
Function Invoke-DockerPester {
    param(
        $ContainerName = "DockerPester",
        $Image,
        $InputFolder,
        $PathOnContainer = "/var",
        $PathToTests,
        $Executor
    )

    $Location = Get-Location

    DockerPesterRun -ContainerName $ContainerName -Image $Image -InputFolder $InputFolder -PathOnContainer $PathOnContainer -PathToTests $PathToTests -Executor $Executor

    $PassThruObject = Get-DockerPesterPassthruPbject -Location $Location

    return $PassThruObject

}
