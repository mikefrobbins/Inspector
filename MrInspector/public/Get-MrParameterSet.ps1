#Requires -Version 4.0
function Get-MrParameterSet {

<#
.SYNOPSIS
    List parameters by parameter sets, parameter aliases, and whether parameters are mandatory.

.DESCRIPTION
    Get-MrParameterSet is a PowerShell function that lists detailed information about a command's parameter set including parameter set names, parameter names, parameter aliases, and if parameters are mandatory.

.PARAMETER Name
    Name of one or more PowerShell commands.

.EXAMPLE
    Get-MrParameterSet -Name Get-Alias, Get-Command

.EXAMPLE
    'Get-Alias', 'Get-Command' | Get-MrParameterSet

.NOTES
    Author:  Mike F Robbins
    Website: https://mikefrobbins.com
    Twitter: @mikefrobbins
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                   ValueFromPipeline)]
        [string[]]$Name
    )

    PROCESS {

        foreach ($n in $Name) {

            $Cmdlet = Get-Command -Name $n

            if ($Cmdlet.CommandType -eq 'Alias') {
                $Cmdlet = Get-Command -Name $Cmdlet.ResolvedCommand
            }

            $ParameterSets = $Cmdlet.ParameterSets.Name

            foreach ($ParameterSet in $ParameterSets){

                $Parameters = $Cmdlet.ParameterSets.Where({$_.Name -eq $ParameterSet}).Parameters

                foreach ($Parameter in $Parameters){

                    [pscustomobject]@{
                        Name = $n
                        CmdletName = $Cmdlet.Name
                        ParameterSet = $ParameterSet
                        Parameter = $Parameter.Name
                        Alias = $Parameter.Aliases
                        Mandatory = $Parameter.IsMandatory
                        PSTypeName = 'Mr.GetParameterSet'
                    }

                }

            }

        }

    }

}