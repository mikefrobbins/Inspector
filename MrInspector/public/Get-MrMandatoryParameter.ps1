function Get-MrMandatoryParameter {

<#
.SYNOPSIS
    Retrieves mandatory parameters for a specified PowerShell command.

.DESCRIPTION
    The Get-MrMandatoryParameter function fetches all the mandatory parameters
    of a given PowerShell command. This can be helpful for understanding the
    required inputs for using the command effectively.

.PARAMETER Name
    The name of the PowerShell command for which mandatory parameters are to be retrieved.

.EXAMPLE
    Get-MrMandatoryParameter -Name Set-Location

.NOTES
    Author:  Mike F. Robbins
    Website: https://mikefrobbins.com/
    Twitter: @mikefrobbins
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Name
    )

    try {
        $commandParamSets = Get-MrParameter -Name $Name -ErrorAction Stop
    } catch {
        Write-Error "Command '$Name' not found."
        return
    }

    $mandatoryParams = $commandParamSets | Where-Object Mandatory -eq $true

    if ($mandatoryParams) {
        Write-Output $mandatoryParams
    } else {
        Write-Verbose "No mandatory parameters found for command '$Name'."
    }
}
