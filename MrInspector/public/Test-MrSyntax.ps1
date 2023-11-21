#Requires -Version 4.0
function Test-MrSyntax {

<#
.SYNOPSIS
    Analyzes PowerShell scripts for syntax and parameter compliance.

.DESCRIPTION
    The Test-MrSyntax function analyzes PowerShell script files for compliance with syntax and parameter standards. It checks if full parameter names are used, validates parameter sets, and ensures all mandatory parameters are specified.

.PARAMETER Path
    Specifies the path(s) of the PowerShell script files to be analyzed. Supports pipeline input.

.EXAMPLE
    Test-MrSyntax -Path C:\Scripts\SampleScript.ps1

.NOTES
    Author:  Mike F. Robbins
    Website: https://mikefrobbins.com/
    Twitter: @mikefrobbins

#>

    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [ValidateScript({
            If (Test-Path -Path $_) {
                $True
            } else {
                Throw "'$_' is not a valid path."
            }
        })]
        [string[]]$Path
    )

    PROCESS {
        foreach ($file in $Path) {
            $Commands = Get-MrSyntax -Path $file

            foreach ($command in $commands) {
                $commandType = 'NotFound'

                try {
                    $cmdlet = Get-Command -Name $command.Cmdlet -ErrorAction Stop
                    $commandType = $cmdlet.CommandType

                    if ($cmdlet.CommandType -eq 'Alias') {
                        $cmdlet = Get-Command -Name $cmdlet.ResolvedCommand
                    }
                } catch {
                    continue
                }

                if ($null -ne $command.Parameters) {
                    #Verify that full parameter names are specified (no aliases)
                    $parameters = Test-MrParameter -Cmdlet $command.Cmdlet -Parameter $command.Parameters

                    #Determine parameter set
                    $ParamSet = Resolve-MrParameterSet -Cmdlet $cmdlet.Name -Parameter $parameters.ParameterName

                    #Verify that only parameters in one parameter set are specified
                    $ValidateParamSet = Test-MrParameterSet -Cmdlet $command.Cmdlet -Parameter $command.Parameters -ParameterSet $paramSet.ParameterSet

                    #Verify that all mandatory parameters in the parameter set are specified
                    $MandatoryParams = Test-MrMandatoryParameter -Cmdlet $cmdlet.Name -Parameter $parameters.ParameterName -ParameterSet $paramSet.ParameterSet

                    foreach ($parameter in $parameters) {
                        [pscustomobject]@{
                            Name = $command.Cmdlet
                            CommandType = $commandType
                            Parameter = $parameter.Parameter
                            ParameterType = $parameter.ParameterType
                            Valid = $validateParamSet.Where({$_.Parameter -eq $parameter.Parameter}).Valid
                            Missing = $mandatoryParams.Where({$_.Cmdlet -eq $command.Cmdlet}).Missing
                            File = $file
                            PSTypeName = 'Mr.TestSyntax'
                        }
                    }


                }
            }
        }
    }

}
