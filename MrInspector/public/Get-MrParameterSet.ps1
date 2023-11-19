#Requires -Version 4.0
function Get-MrParameterSet {

    <#
    .SYNOPSIS
        Lists parameters by parameter sets, parameter aliases, and whether parameters are mandatory.

    .DESCRIPTION
        Get-MrParameterSet is a PowerShell function that lists detailed information about a command's
        parameter sets including parameter set names, parameter names, parameter aliases, and if
        parameters are mandatory.

    .PARAMETER Name
        Name of one or more PowerShell commands.

    .EXAMPLE
        Get-MrParameterSet -Name Get-Alias, Get-Command

    .EXAMPLE
        'Get-Alias', 'Get-Command' | Get-MrParameterSet

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
                $cmdlet = Get-Command -Name $n -ErrorAction SilentlyContinue

                if ($null -eq $cmdlet) {
                    Write-Warning "Command '$n' not found."
                    continue
                }

                if ($cmdlet.CommandType -eq 'Alias') {
                    $cmdlet = Get-Command -Name $cmdlet.ResolvedCommand
                }

                foreach ($parameterSet in $cmdlet.ParameterSets) {
                    foreach ($parameter in $parameterSet.Parameters) {
                        [pscustomobject]@{
                            Name = $n
                            CmdletName = $Cmdlet.Name
                            ParameterSet = $ParameterSet.Name
                            IsDefault = $ParameterSet.IsDefault
                            Parameter = $Parameter.Name
                            Alias = $Parameter.Aliases -join ', '
                            Mandatory = $Parameter.IsMandatory
                            PSTypeName = 'Mr.GetParameterSet'
                        }
                    }
                }
            }
        }
    }
