Import-Module Pester
Import-Module "$PSScriptRoot/../../DockerPester/DockerPester.psd1" -Force

Describe "Testing Base Funcionality" {
    $res = Invoke-DockerPester -Image "mcr.microsoft.com/windows/servercore:ltsc2019" -InputFolder "$PSScriptRoot/../TestModule/" -PathOnContainer "C:/Temp" -Executor WIN
    it "Result should contain PassThru Object from Pester" {
        $res.TestResult | Should -Not -BeNullOrEmpty
    }
}