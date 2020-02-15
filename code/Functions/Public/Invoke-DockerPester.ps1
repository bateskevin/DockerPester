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
