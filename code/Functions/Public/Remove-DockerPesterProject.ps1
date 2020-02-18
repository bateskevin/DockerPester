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