Function Invoke-DockerPester {
    param(
        $ContainerName = "DockerPester",
        $Image,
        $InputFolder,
        $PathOnContainer = "/var",
        $PathToTests,
        $Executor,
        [String[]]$PrerequisiteModule,
        $Project,
        $Context = "default"
    )
 
    if($Project){

        $Location = Get-Location
    
        $ParamSets = Get-DockerPesterProject -Name $Project 

        foreach($ParamSet in $ParamSets){

            Write-DockerPesterHost -Message "Starting run for Image $($ParamSet.Image)"
            Write-Host ""
            Write-Host ""

            if(!($ParamSet.Context)){
                $Context = "default"

                $Hash = @{
                    ContainerName = $ParamSet.ContainerName
                    Image = $ParamSet.Image
                    InputFolder = $ParamSet.InputFolder
                    PathOnContainer = $ParamSet.PathOnContainer
                    PathToTests = $ParamSet.PathToTests
                    Executor = $ParamSet.Executor
                    PrerequisiteModule = $ParamSet.PrerequisiteModule
                    Context = $Context
                }
            }else{

                $Context = $ParamSet.Context

                $Res = get-DockerPesterContext
                $Executor = ($Res | ?{$_.Context -eq $Context}).Executor
                
                $Hash = @{
                    ContainerName = $ParamSet.ContainerName
                    Image = $ParamSet.Image
                    InputFolder = $ParamSet.InputFolder
                    PathOnContainer = $ParamSet.PathOnContainer
                    PathToTests = $ParamSet.PathToTests
                    Executor = $Executor
                    PrerequisiteModule = $ParamSet.PrerequisiteModule
                    Context = $Context
                }
            }
            
            DockerPesterRun @Hash

            $PassThruObject = Get-DockerPesterPassthruPbject -Location $Location

            [PSCustomObject]$Object = @{
                TagFilter = $PassThruObject.TagFilter
                ExcludeTagFilter = $PassThruObject.ExcludeTagFilter
                TestNameFilter = $PassThruObject.TestNameFilter
                ScriptBlockFilter = $PassThruObject.ScriptBlockFilter
                TotalCount = $PassThruObject.TotalCount
                PassedCount = $PassThruObject.PassedCount
                FailedCount = $PassThruObject.FailedCount
                SkippedCount = $PassThruObject.SkippedCount
                PendingCount = $PassThruObject.PendingCount
                InconclusiveCount = $PassThruObject.InconclusiveCount
                Time = $PassThruObject.Time
                TestResult = $PassThruObject.TestResult
            }

            $Date = Get-Date -f yyyyMMddhhmmss

            $ImageName = $ParamSet.Image.Replace('/','')
            $ImageName = $Imagename.Replace(':','')
            
            if(!(Test-Path "$HOME/DockerPester/$($Project)_Tests/")){
                $null = New-Item "$HOME/DockerPester/$($Project)_Tests/" -ItemType Directory
            }

            $Object | ConvertTo-Json -Depth 7 | Out-File -FilePath "$HOME/DockerPester/$($Project)_Tests/$($Date)_$($ImageName).json"
        }

        Write-DockerPesterHost -Message "Find your Test Results at '$HOME/DockerPester/$($Project)_Tests/' or use 'Get-LatestDockerPesterResults -Project $Project' to retrieve the result as an object."

    }else{

        if(!($Context)){
            $Context = "default"
        }

        Write-DockerPesterHost -Message "Starting run for Image $($Image)"

        $Location = Get-Location

        DockerPesterRun -ContainerName $ContainerName -Image $Image -InputFolder $InputFolder -PathOnContainer $PathOnContainer -PathToTests $PathToTests -Executor $Executor -PrerequisiteModule $PrerequisiteModule -Context $Context

        $PassThruObject = Get-DockerPesterPassthruPbject -Location $Location

        return $PassThruObject
    }

}
