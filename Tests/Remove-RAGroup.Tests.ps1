Describe "Remove-RAGroup" {
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
        )
        It "<Parameter> is mandatory" -TestCases $mandatoryParameter {
            param($Parameter)
            $functionMeta = Get-Command -Name Remove-RAGroup
            $functionMeta.Parameters[$Parameter].Attributes.Mandatory | Should -BeTrue
        }
    }
    Context "Verify the output" {
        BeforeEach {
            $auth = New-RAToken -Path $configPath -Datacenter $configFile.Datacenter -TenantID $configFile.TenantID -AsSecureString
        }
        It "Remove an Alero group" {
            $groupName = "GRP-$(Get-Random -Maximum 10000)"
            $proxyGroup = New-RAGroup -Authn $auth -Name $groupName -Description "Test description"
            $output = Remove-RAGroup -Authn $auth -GroupId $proxyGroup.Id
            $output | Should -BeNullOrEmpty
            $output | Should -BeOfType [string]
        }
        It "Remove multiple Alero groups" {
            $groupOne = "GRP-$(Get-Random -Maximum 10000)"
            $groupTwo = "GRP-$(Get-Random -Maximum 10000)"
            $groupThree = "GRP-$(Get-Random -Maximum 10000)"
            $output = $groupOne, $groupTwo, $groupThree |  New-RAGroup -Authn $auth
            $result = $output[0].Id, $output[1].Id, $output[2].Id | Remove-RAGroup -Authn $auth
            $result | Should -BeNullOrEmpty
        }
    }
}