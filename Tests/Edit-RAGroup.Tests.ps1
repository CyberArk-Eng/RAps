Describe "Edit-RAGroup" {
    BeforeAll {
        #region Importing the module
        $dir = Split-Path (Split-Path $PSScriptRoot -Parent) -Leaf
        Import-Module -Name $dir
        #endregion
        #region Importing configuration file
        $moduleDir = Split-Path -Path $PSScriptRoot -Parent
        $configFile =  Get-Content -Path "$(Split-Path -Path $moduleDir -Parent)\config.json" | ConvertFrom-Json
        $configPath = "$(Split-Path -Path $moduleDir -Parent)\$($configFile.PrivateKey)"
        #endregion
    }
    Context "Verifying parameters" {
        $mandatoryParameter = @(
            @{ Parameter = "Authn" }
            @{ Parameter = "GroupId" }
            @{ Parameter = "Description" }
        )
        It "<Parameter> is mandatory" -TestCases $mandatoryParameter {
            param($Parameter)
            $functionMeta = Get-Command -Name Edit-RAGroup
            $functionMeta.Parameters[$Parameter].Attributes.Mandatory | Should -BeTrue
        }
    }
    Context "Verify the output" {
        BeforeEach {
            $auth = New-RAToken -Path $configPath -Datacenter $configFile.Datacenter -TenantID $configFile.TenantID -AsSecureString
        }
        It "Editing the Alero group" {
            $random = "New Description $(Get-Random -Maximum 1000)"
            $output = Edit-RAGroup -Authn $auth -GroupId $configFile.GroupID -Description $random
            $check = Get-RAGroups -Authn $auth -GroupId $configFile.GroupID
            $output | Should -BeNullOrEmpty
            $output | Should -BeOfType [string]
            $check.Description | Should -BeExactly $random
        }
    }
}