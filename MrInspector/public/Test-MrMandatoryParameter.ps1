#Requires -Version 3.0
function Test-MrMandatoryParameter {

<#
.SYNOPSIS
Tests for missing mandatory parameters in a specified cmdlet and parameter set.

.DESCRIPTION
The Test-MrMandatoryParameter function checks whether all mandatory parameters for a given cmdlet and parameter set are provided. It returns the missing mandatory parameters, if any.

.PARAMETER Cmdlet
The name of the cmdlet to check for mandatory parameters.

.PARAMETER Parameter
The parameters to be checked against the cmdlet's mandatory parameters.

.PARAMETER ParameterSet
The specific parameter set of the cmdlet to check.

.EXAMPLE
Test-MrMandatoryParameter -Cmdlet Get-ChildItem -Parameter Path -ParameterSet Path

.NOTES
    Author:  Mike F. Robbins
    Website: https://mikefrobbins.com/
    Twitter: @mikefrobbins

#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Cmdlet,

        [Parameter(Mandatory)]
        [string[]]$Parameter,

        [Parameter(Mandatory)]
        [string]$ParameterSet
    )

    # Get the mandatory parameters for the specified cmdlet and parameter set
    $MandatoryParams = Get-MrMandatoryParameter -Name $Cmdlet |
                       Where-Object ParameterSet -eq $ParameterSet

    # Compare provided parameters with mandatory parameters
    $Results = Compare-Object -ReferenceObject $Parameter -DifferenceObject $MandatoryParams.Parameter

    # Create a custom object to return the results
    [pscustomobject]@{
        Cmdlet = $Cmdlet
        Parameter = $Results.InputObject
        Missing = if ($Results.Where({$_.SideIndicator -eq '=>'})) {$true} else {$false}
    }
}
