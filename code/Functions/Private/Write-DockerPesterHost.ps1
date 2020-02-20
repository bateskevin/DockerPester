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