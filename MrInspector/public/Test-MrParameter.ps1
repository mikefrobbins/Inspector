function Test-MrParameter {
    [CmdletBinding()]
    param (
        $Cmdlet,
        $Parameter
    )

    foreach ($Command in $Cmdlet) {
        $cmd = ''
        try {
            $cmd = Get-Command -Name $Command -ErrorAction Stop
            $CommandType = $cmd.CommandType
        } catch {
            $CommandType = 'NotFound'
        }

        foreach ($Param in $Parameter) {
            switch ($Param) {
                {$_ -in $cmd.parameters.values.name} {$ParamType = 'Parameter'}
                {$_ -in $cmd.parameters.values.aliases} {$ParamType = 'Alias'}
                Default {$ParamType = 'Unknown'}
            }

            [pscustomobject]@{
                Name = $Command
                CommandType = $CommandType
                Parameter = $Param
                ParameterName = if ($CommandType -ne 'Alias') {
                                    $Param
                                } else {
                                    $cmd.parameters.values.Where({$_.Aliases -eq $Param}).name
                                }
                ParameterType = $ParamType
                PSTypeName = 'Mr.TestParameter'
            }

        }

    }

}