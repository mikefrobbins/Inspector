function Resolve-MrParameterSet {
    [CmdletBinding()]
    param (
        $Cmdlet,
        $Parameter
    )

    foreach ($Command in $Cmdlet) {
        $ParameterSets = Get-MrParameterSet -Name $Command

        if (Get-MrParameterAlias -Name $Command | Where-Object aliases -eq $Parameter) {
            $Parameter = (Get-MrParameterAlias -Name $Command | Where-Object aliases -eq $Parameter).Name
        }

        $Results = foreach ($Param in $Parameter) {
            if ($Param -in $ParameterSets.Parameter) {
                $ParameterSets | Where-Object Parameter -eq $Param
            }
        }

        [pscustomobject]@{
            Command = $Command
            ParameterSet = ($Results | Group-Object -Property ParameterSet | Sort-Object -Property Count -Descending | Select-Object -First 1).Name
        }

    }

}