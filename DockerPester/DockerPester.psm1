#Generated at 02/15/2020 12:34:00 by Kevin Bates
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
        $PathToTests 
    )

    $Location = Get-Location

    DockerPesterRun -ContainerName $ContainerName -Image $Image -InputFolder $InputFolder -PathOnContainer $PathOnContainer $PathToTests

    $PassThruObject = Get-DockerPesterPassthruPbject -Location $Location

    return $PassThruObject

}