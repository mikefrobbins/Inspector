function Get-MrMandatoryParameter {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Name
    )

    Get-MrParameterSet -Name $Name |
    Where-Object Mandatory -eq $true

}