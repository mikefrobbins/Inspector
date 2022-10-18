function Test-MrSyntax {
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

        foreach ($file in $path) {

            $Commands = Get-MrSyntax -Path $file

            foreach ($Command in $Commands){
                $cmd = ''
                try {
                    $Cmdlet = Get-Command -Name $command.cmdlet -ErrorAction Stop
                    $CommandType = $Cmdlet.CommandType
                } catch {
                    $CommandType = 'NotFound'
                    continue
                }

                if ($Cmdlet.CommandType -eq 'Alias') {
                    $Cmdlet = Get-Command -Name $Cmdlet.ResolvedCommand
                }

                if ($null -ne $Command.Parameters){
                    #Verify that full parameter names are specified (no aliases)
                    $Parameters = Test-MrParameter -Cmdlet $Command.Cmdlet -Parameter $Command.Parameters

                    #Determine parameter set
                    $ParamSet = Resolve-MrParameterSet -Cmdlet $Cmdlet.Name -Parameter $Parameters.ParameterName

                    #Verify that only parameters in one parameter set are specified
                    $ValidateParamSet = Test-MrParameterSet -Cmdlet $Command.Cmdlet -Parameter $Command.Parameters -ParameterSet $ParamSet.ParameterSet

                    #Verify that all mandatory parameters in the parameter set are specified
                    $MandatoryParams = Test-MrMandatoryParameter -Cmdlet $Cmdlet.Name -Parameter $Parameters.ParameterName -ParameterSet $ParamSet.ParameterSet

                    foreach ($Parameter in $Parameters) {
                        [pscustomobject]@{
                            Name = $Command.Cmdlet
                            CommandType = $CommandType
                            Parameter = $Parameter.Parameter
                            ParameterType = $Parameter.ParameterType
                            Valid = $ValidateParamSet.Where({$_.Parameter -eq $Parameter.Parameter}).Valid
                            Missing = $MandatoryParams.Where({$_.Cmdlet -eq $Command.Cmdlet}).Missing
                            File = $file
                            PSTypeName = 'Mr.TestSyntax'
                        }
                    }
                }

            }
        }
    }

}