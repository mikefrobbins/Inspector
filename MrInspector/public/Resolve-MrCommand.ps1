#Requires -Version 3.0
function Resolve-MrCommand {

<#
.SYNOPSIS
Resolves PowerShell commands and their aliases to their original cmdlets.

.DESCRIPTION
The Resolve-MrCommand function takes one or more command names (or aliases) as input and resolves them to their original cmdlet names. It outputs the cmdlet information if found, or a warning message if the command is not found.

.PARAMETER Name
An array of command names (or aliases) that you want to resolve.

.EXAMPLE
Resolve-MrCommand -Name gps, dir

.EXAMPLE
'Restart-Computer', 'gps' | Resolve-MrCommand

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

          Write-Output $cmdlet
      }
  }
}
