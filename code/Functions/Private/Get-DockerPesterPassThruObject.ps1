Function Get-DockerPesterPassthruPbject {
    param(
        $Location,
        $FileName = "Output.json"
    )

    $File = "$Location/$FileName"

    $PassThru = Get-Content $File | ConvertFrom-Json

    Remove-Item $File

    return $PassThru

}
