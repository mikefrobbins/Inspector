#Requires -Version 3.0
function Resolve-MrParameterSet {

<#
.SYNOPSIS
Resolves and returns the parameter set currently in use for a given PowerShell cmdlet and a set of parameters.

.DESCRIPTION
The Resolve-MrParameterSet function analyzes one or more PowerShell cmdlets and determines which parameter set is being used based on the specified parameters. It resolves any parameter aliases and finds the matching parameter set for each cmdlet, returning a custom object containing the cmdlet name and the name of the parameter set in use. If no parameters match a specific set, the function defaults to the cmdlet's default parameter set.

.PARAMETER Cmdlet
Specifies one or more cmdlets to analyze. This parameter is mandatory and accepts an array of string values, each representing a cmdlet's name.

.PARAMETER Parameter
Specifies an array of parameters to resolve against the cmdlets' parameter sets. This parameter is optional.

.EXAMPLE
Resolve-MrParameterSet -Cmdlet Get-Process -Parameter Name

.EXAMPLE
Resolve-MrParameterSet -Cmdlet Get-Service, Get-Process -Parameter DisplayName, Id

.NOTES
    Author:  Mike F. Robbins
    Website: https://mikefrobbins.com/
    Twitter: @mikefrobbins

#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string[]]$Cmdlet,

        [string[]]$Parameter
    )

    foreach ($command in $Cmdlet) {
        $commandInfo = Get-Command -Name $command
        $parameterSetsInfo = $commandInfo.ParameterSets |
                            Select-Object -Property Name, @{label='Parameters';expression={$_.parameters.name}}

        # Resolve parameter alias
        $paramAliases = Get-MrParameterAlias -Name $command

        $resolvedParameters = foreach ($param in $Parameter) {
            $alias = $paramAliases | Where-Object Aliases -contains $param
            if ($null -eq $alias) {
            $param
            } else {
            $alias.Name
            }
        }

        # Determine the parameter set in use
        $inUseParamterSet = $null

        foreach ($set in $parameterSetsInfo) {
            $isMatch = $resolvedParameters | ForEach-Object {$_ -in $set.Parameters}
            if ($isMatch -notcontains $false) {
                $inUseParamterSet = $set.Name
                break
            }
        }

        if (-not $inUseParamterSet) {
            $inUseParamterSet = $commandInfo.ParameterSets | Where-Object IsDefault -eq $true | Select-Object -First 1 -ExpandProperty Name
        }

        [pscustomobject]@{
            Command = $Command
            ParameterSet = $inUseParamterSet
        }
    }
}
