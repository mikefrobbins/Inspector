function Test-MrMandatoryParameter {
    [CmdletBinding()]
    param (
        $Cmdlet,
        $Parameter,
        $ParameterSet
    )
    $MandatoryParams = Get-MrMandatoryParameter -Name $Cmdlet | Where-Object ParameterSet -eq $ParameterSet

    $Results = Compare-Object -ReferenceObject $Parameter -DifferenceObject $MandatoryParams.Parameter

    [pscustomobject]@{
        Cmdlet = $Cmdlet
        Parameter = $Results.InputObject
        Missing = if ($Results.Where({$_.SideIndicator -eq '=>'})) {$true} else {$false}
    }
}