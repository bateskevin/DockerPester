Function Set-DockerPesterContext {
    param(
        $Context,
        $Executor
    )

    $ContextJSON = "$HOME/DockerPester/Context.json"

    [PSCustomObject]$Object = @{
        Context = $Context
        Executor = $Executor

    }

    $CurrentJSON = Get-Content $ContextJSON | ConvertFrom-Json -Depth 7

    $arr = @()

    foreach($instance in $CurrentJSON){
        $arr += $instance
    }

    $arr += $Object

    $arr | ConvertTo-Json -Depth 7 | Out-File -FilePath $ContextJSON

    Write-DockerPesterHost -Message "Set Context $($Context):$($executor)"

}