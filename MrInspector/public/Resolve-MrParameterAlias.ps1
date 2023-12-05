#Requires -Version 3.0
function Resolve-MrParameterAlias {

<#
.SYNOPSIS
Resolves aliases for parameters of specified cmdlets.

.DESCRIPTION
This function takes a list of cmdlets and their parameters and resolves any aliases to their original parameter names.

.PARAMETER Cmdlet
Specifies the cmdlets for which to resolve parameter aliases. This parameter is mandatory.

.PARAMETER Parameter
Specifies the parameters to resolve. This parameter is mandatory.

.EXAMPLE
Resolve-MrParameterAlias -Cmdlet Get-ChildItem -Parameter GC

Resolves the alias 'GC' for the Get-ChildItem cmdlet.

.NOTES
    Author:  Mike F. Robbins
    Website: https://mikefrobbins.com/
    Twitter: @mikefrobbins
#>

  [CmdletBinding()]
  param (
      [Parameter(Mandatory)]
      [string[]]$Cmdlet,

      [Parameter(Mandatory)]
      [string[]]$Parameter
  )

  foreach ($cmd in $Cmdlet) {
      $cmdInfo = Get-Command -Name $cmd -ErrorAction SilentlyContinue

      if ($null -eq $cmdInfo) {
          Write-Warning "Command '$cmd' not found"
          continue
      }

      $paramAliases = Get-MrParameterAlias -Name $cmd

      foreach ($prm in $Parameter) {
          $alias = $paramAliases | Where-Object Aliases -contains $prm
          $resolvedParam = if ($null -eq $alias) { $prm } else { $alias.Name }

          [pscustomobject]@{
              Command = $cmd
              Parameter = $resolvedParam
          }
      }
  }
}
