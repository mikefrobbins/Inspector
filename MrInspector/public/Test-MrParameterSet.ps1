function Test-MrParameterSet {
    [CmdletBinding()]
    param (
        $Cmdlet,
        $Parameter,
        $ParameterSet
    )

    $Params = Get-MrParameterSet -Name $Cmdlet | Where-Object ParameterSet -eq $ParameterSet



    $Results = Compare-Object -ReferenceObject $Parameter -DifferenceObject $Params.Parameter -IncludeEqual | Where-Object {$_.SideIndicator -eq '==' -or $_.SideIndicator -eq '<='}

    foreach ($Result in $Results) {
        [pscustomobject]@{
            Cmdlet = $Cmdlet
            Parameter = $Result.InputObject
            Valid = if ($Result.Where({$_.SideIndicator -eq '=='})) {
                $true
            } elseif ($Result.Where({$_.SideIndicator -eq '<='})) {
                $false
            }
        }
    }

}