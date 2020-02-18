Import-Module Pester
Import-Module "$PSScriptRoot/../../DockerPester/DockerPester.psd1" -Force

Describe "Testing Base Funcionality" {
    $res = Invoke-DockerPester -Image "mcr.microsoft.com/windows/servercore:ltsc2019" -InputFolder "$PSScriptRoot/../TestModule/" -Executor WIN -PathToTests "Tests" -PathOnContainer "c:/Temp"
    it "Result should contain PassThru Object from Pester" {
        $res.TestResult | Should -Not -BeNullOrEmpty
    }
}