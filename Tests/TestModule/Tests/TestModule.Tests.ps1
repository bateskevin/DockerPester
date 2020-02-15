Import-Module Pester
Import-Module $PSScriptRoot/../TestModule/TestModule.psm1

Describe "Testing TestModule" {
    it "Execution should not throw" {
        { Test-Date } | Should -Not -Throw 
    }
}