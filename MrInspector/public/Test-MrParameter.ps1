#Requires -Version 4.0
function Test-MrParameter {

<#
.SYNOPSIS
Tests the presence and type of parameters in specified cmdlets.

.DESCRIPTION
The Test-MrParameter function checks whether the given parameters are present in the specified cmdlets and determines their type (Parameter or Alias). It returns an object with the cmdlet name, command type, parameter name, parameter type, and an additional PSTypeName for each parameter.

.PARAMETER CmdletName
Specifies one or more cmdlets to check for the presence of parameters.

.PARAMETER ParameterName
Specifies one or more parameters to check in the specified cmdlets.

.EXAMPLE
Test-MrParameter -CmdletName Get-Process, Get-Service -ParameterName Id, Name

.NOTES
    Author:  Mike F. Robbins
    Website: https://mikefrobbins.com/
    Twitter: @mikefrobbins
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string[]]$CmdletName,

        [Parameter(Mandatory)]
        [string[]]$ParameterName
    )

    foreach ($cmdlet in $CmdletName) {
        try {
            $cmd = Get-Command -Name $cmdlet -ErrorAction Stop
            $commandType = $cmd.CommandType
        } catch {
            Write-Error -Message "Cmdlet '$Cmdlet' not found."
            continue
        }

        foreach ($param in $ParameterName) {
            switch ($param) {
                {$_ -in $cmd.parameters.keys} {$paramType = 'Parameter'}
                {$_ -in $cmd.parameters.Values.aliases} {$paramType = 'Alias'}
                Default {$paramType = 'Unknown'}
            }

            [pscustomobject]@{
                Name = $Cmdlet
                CommandType = $commandType
                Parameter = $param
                ParameterName = if ($paramType -ne 'Alias') {$param}
                                else {$cmd.parameters.Values.Where({$_.Aliases -contains $param}).Name}
                ParameterType = $paramType
                PSTypeName = 'Mr.TestParameter'
            }
        }
    }
}
