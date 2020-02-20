Function Get-DockerPesterContext {

    $Context = Get-Content "$HOME/DockerPester/Context.json" | ConvertFrom-Json -Depth 7

    return $Context

}