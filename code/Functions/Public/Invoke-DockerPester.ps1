Function Invoke-DockerPester {
    param(
        $ContainerName = "DockerPester",
        $Image,
        $InputFolder,
        $PathOnContainer = "/var",
        $PathToTests 
    )

    If($IsWindows){
        $Executor = "WIN"
    }else{
        $Executor = "LNX"
    }

    $Location = Get-Location

    DockerPesterRun -ContainerName $ContainerName -Image $Image -InputFolder $InputFolder -PathOnContainer $PathOnContainer $PathToTests -Executor $Executor

    $PassThruObject = Get-DockerPesterPassthruPbject -Location $Location

    return $PassThruObject

}
