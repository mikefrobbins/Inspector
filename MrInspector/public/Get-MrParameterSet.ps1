#Requires -Version 3.0
function Get-MrParameterSet {

<#
.SYNOPSIS
Retrieves parameter sets for specified PowerShell commands.

.DESCRIPTION
The Get-MrParameterSet function retrieves parameter set information for the specified PowerShell command names. It lists each parameter set along with its parameters and identifies the default parameter set.

.PARAMETER Name
Specifies an array of command names. This parameter is mandatory and accepts values from the pipeline.

.EXAMPLE
Get-MrParameterSet -Name Get-ChildItem, Set-Location

.NOTES
    Author:  Mike F. Robbins
    Website: https://mikefrobbins.com/
    Twitter: @mikefrobbins
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]]$Name
    )

    PROCESS {
        foreach ($n in $Name) {
            # Retrieve command information
            $commandInfo = Get-Command -Name $n -ErrorAction SilentlyContinue

            # Check if command exists
            if ($commandInfo) {
                # Iterate through each parameter set of the command
                foreach ($parameterSet in $commandInfo.ParameterSets) {
                    # Create and output custom object with parameter set details
                    [pscustomobject]@{
                        Name = $n
                        ParameterSets = $parameterSet.Name
                        Parameters = $parameterSet.Parameters
                        IsDefault = $parameterSet.IsDefault
                    }
                }
            }
            else {
                Write-Warning "Command '$n' not found."
            }
        }
    }
}
