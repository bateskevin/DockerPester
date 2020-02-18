Function Get-LatestDockerPesterResults {
    param(
        $Project
    )

    $Jobs = Get-Content "$HOME/DockerPester/$($Project).json" | ConvertFrom-Json -Depth 7

    $LatestCount = $Jobs.Count 

    $ProjectResults = Get-ChildItem "$HOME/DockerPester/$($Project)_Tests"

    $LatestTests = $ProjectResults | Sort-Object Name -Descending | select -first $LatestCount

    $Arr = @()

    Foreach($Result in $LatestTests){

        $Passthru = Get-Content $Result.FullName | ConvertFrom-Json -Depth 7 

        $ImageNameWithJson = $Result.Name.split('_')[1]

        [PSCustomObject]$PassthruObject = @{
            DateOfTest = $Result.Name.split('_')[0]
            Image = $ImageNameWithJson.TrimEnd('.json')
            PassThru = $Passthru
        }

        $Arr += $PassthruObject
    }

    return $Arr
}