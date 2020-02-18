Function Get-DockerPesterProject {
    param(
        [Switch]$List,
        $Name
    )

    if($List){
        (Get-ChildItem $HOME/DockerPester -File).Name.TrimEnd(".json")
    }elseif($Name){
        $Obj = Get-Content "$HOME/DockerPester/$($Name).json" | ConvertFrom-Json
        return $Obj
    }else{
        throw "Please specify one of the parameters ('List','Name')"
    }



}