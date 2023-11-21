#Requires -Version 3.0
function Test-MrParameterSet {

<#
.SYNOPSIS
    Tests if a given parameter is part of a specified parameter set for a cmdlet.

.DESCRIPTION
    This function checks if the specified parameter belongs to the given parameter set of a cmdlet.
    It uses a comparison method to determine the validity of the parameter within the specified parameter set.

.PARAMETER Cmdlet
    The name of the cmdlet to check the parameter set for.

.PARAMETER Parameter
    The parameter to test for its presence in the specified parameter set.

.PARAMETER ParameterSet
    The name of the parameter set to check the parameter against.

.EXAMPLE
    Test-MrParameterSet -Cmdlet Get-Item -Parameter Path -ParameterSet Path

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
        [string]$Parameter,

        [Parameter(Mandatory)]
        [string]$ParameterSet
    )

    # Retrieve parameters for the specified cmdlet and parameter set
    $params = Get-MrParameter -Name $Cmdlet |
              Where-Object ParameterSet -eq $ParameterSet

    # Compare the provided parameter with the retrieved parameter set
    $results = Compare-Object -ReferenceObject $Parameter -DifferenceObject $params.Parameter -IncludeEqual |
               Where-Object {$_.SideIndicator -eq '==' -or $_.SideIndicator -eq '<='}

    # Process and output results
    foreach ($result in $results) {
        $isValid = $false
        if ($result.SideIndicator -eq '==') {
            $isValid = $true
        }

        [pscustomobject]@{
            Cmdlet = $cmdlet
            Parameter = $result.InputObject
            Valid = $isValid
        }
    }
}
