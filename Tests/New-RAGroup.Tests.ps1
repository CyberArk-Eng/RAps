Describe "New-RAGroup" {
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
            @{ Parameter = "Name" }
        )
        It "<Parameter> is mandatory" -TestCases $mandatoryParameter {
            param($Parameter)
            $functionMeta = Get-Command -Name New-RAGroup
            $functionMeta.Parameters[$Parameter].Attributes.Mandatory | Should -BeTrue
        }
    }
    Context "Verify the output" {
        BeforeEach {
            $auth = New-RAToken -Path $configPath -Datacenter $configFile.Datacenter -TenantID $configFile.TenantID -AsSecureString
        }
        It "Create a new Alero group" {
            $groupName = "GRP-$(Get-Random -Maximum 10000)"
            $output = New-RAGroup -Authn $auth -Name $groupName -Description "Test description"
            $output | Should -Not -BeNullOrEmpty
            $output | Should -BeOfType [PSCustomObject]
            $output.Description | Should -BeExactly "Test description"
            $output.Name | Should -Be $groupName
            Remove-RAGroup -Authn $auth -GroupId $output.Id
        }
        It "Creating multiple Alero groups with an array of strings" {
            $groupOne = "GRP-$(Get-Random -Maximum 10000)"
            $groupTwo = "GRP-$(Get-Random -Maximum 10000)"
            $groupThree = "GRP-$(Get-Random -Maximum 10000)"
            $output = $groupOne, $groupTwo, $groupThree |  New-RAGroup -Authn $auth
            $output | Should -Not -BeNullOrEmpty
            $output | Should -BeOfType [PSCustomObject]
            $output | Should -HaveCount 3
            $output[0].name | Should -Be $groupOne
            $output[1].name | Should -Be $groupTwo
            $output[2].name | Should -Be $groupThree
            Remove-RAGroup -Authn $auth -GroupId $output[0].Id
            Remove-RAGroup -Authn $auth -GroupId $output[1].Id
            Remove-RAGroup -Authn $auth -GroupId $output[2].Id
        }
    }
}