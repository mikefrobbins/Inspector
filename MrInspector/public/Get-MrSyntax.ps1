#Requires -Version 3.0
function Get-MrSyntax {

<#
.SYNOPSIS
    List PowerShell commands and parameters in the specified PowerShell script.

.DESCRIPTION
    Get-MrSyntax is a PowerShell function that uses the Abstract Syntax Tree (AST) to determine the
    commands and parameters within a PowerShell script.

.PARAMETER Path
    Path to one of more PowerShell PS1 or PSM1 script files.

.EXAMPLE
    Get-MrSyntax -Path C:\Scripts\MyScript.ps1

.EXAMPLE
    Get-ChildItem -Path C:\Scripts\*.ps1 | Get-MrSyntax

.EXAMPLE
    Get-MrSyntax -Path (Get-ChildItem -Path C:\Scripts\*.ps1)

.NOTES
    Author:  Mike F. Robbins
    Website: https://mikefrobbins.com/
    Twitter: @mikefrobbins
#>

    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [ValidateScript({
            If (Test-Path -Path $_ -PathType Leaf -Include *.ps1, *.psm1) {
                $True
            } else {
                Throw "'$_' is not a valid PowerShell PS1 or PSM1 script file."
            }
        })]
        [string[]]$Path
    )

    PROCESS {

        foreach ($file in $Path) {
            $AST = [System.Management.Automation.Language.Parser]::ParseFile($File, [ref]$null, [ref]$null)

            $AST.FindAll({$args[0].GetType().Name -like 'CommandAst'}, $true) |
            ForEach-Object {
                [pscustomobject]@{
                    Cmdlet = $_.CommandElements[0].Value
                    Parameters = $_.CommandElements.ParameterName
                    File = $file
                }
            }
        }
    }
}
