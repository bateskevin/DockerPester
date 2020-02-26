Import-Module Pester
Import-Module "$PSScriptRoot/../../DockerPester/DockerPester.psd1" -Force

Describe "Testing Base Funcionality" {
    $res = Invoke-DockerPester -Image "mcr.microsoft.com/powershell:7.0.0-rc.3-windowsservercore-1803-kb4537762-amd64" -InputFolder "$PSScriptRoot/../TestModule/" -Executor WIN -PathToTests "Tests" -PathOnContainer "c:/Temp"
    it "Result should contain PassThru Object from Pester" {
        $res.TestResult | Should -Not -BeNullOrEmpty
    }
}