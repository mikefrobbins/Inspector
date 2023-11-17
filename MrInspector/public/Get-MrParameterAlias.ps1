#Requires -Version 3.0
function Get-MrParameterAlias {

<#
.SYNOPSIS
    Retrieves the aliases for the parameters of a specified PowerShell command.

.DESCRIPTION
    The Get-MrParameterAlias function retrieves the names and aliases of parameters
    for a given PowerShell command. This can be useful for understanding and using
    the command more effectively.

.PARAMETER Name
    The name of the PowerShell command for which parameter aliases are to be retrieved.

.EXAMPLE
    Get-MrParameterAlias -Name Get-ChildItem

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
        $commandParameters = Get-Command -Name $Name -ErrorAction Stop
    } catch {
        Write-Error -Message "Command '$Name' not found."
        return
    }

    $parametersWithAliases = $commandParameters.Parameters.Values |
                             Where-Object {$null -ne $_.Aliases -and $_.Aliases.Count -gt 0}

    if ($parametersWithAliases) {
        $parametersWithAliases | Select-Object -Property Name, Aliases
    } else {
        Write-Output "No parameter aliases found for command '$Name'."
    }
}
