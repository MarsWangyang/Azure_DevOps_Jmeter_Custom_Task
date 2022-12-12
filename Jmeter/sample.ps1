<#
    .SYNOPSIS
    This script generates a password
    .DESCRIPTION
    A password is generated that contains at least one  non-capital, one capital, one number and one special character.
    It will than removes the similar characters (like I & l)
    .PARAMETER length
    The length of the password
    .NOTES
    Written by Barbara Forbes
    @Ba4bes
    https://4bes.nl
    #>

[CmdletBinding]

Import-Module "./ps_modules/*"

Trace-VstsEnteringInvocation $MyInvocation
Import-VstsLocStrings $(Join-Path $PSScriptRoot -ChildPath "task.json")

# Get task variables.
[bool]$debug = Get-VstsTaskVariable -Name System.Debug -AsBool

# Get the input
[string]$jmeterExeLocation = Get-VstsInput -Name jmeterExeLocation -Require
[string]$jmeterScriptLocation = Get-VstsInput -Name jmeterScriptLocation -Require
[string]$jmeterJtlReport = Get-VstsInput -Name jmeterJtlReport 
[bool]$needJtl = [System.Convert]::ToBoolean($jmeterJtlReport)
[string]$jmeterJtlReportLocation = Get-VstsInput -Name jmeterJtlReportLocation
[string]$jmeterHTMLReport = Get-VstsInput -Name jmeterHTMLReport 
[bool]$needHTML = [System.Convert]::ToBoolean($jmeterHTMLReport)
[string]$jmeterHTMLReportLocation = Get-VstsInput -Name jmeterHTMLReportLocation
[string]$jmeterLog = Get-VstsInput -Name jmeterLog 
[bool]$needLog = [System.Convert]::ToBoolean($jmeterLog)
[string]$jmeterLogLocation = Get-VstsInput -Name jmeterLogLocation

# Initialize Jmeter command
[string]$baseCommand = "$jmeterExeLocation -n -t $jmeterScriptLocation"

try {
    # Set Command 
    if ($needLog) {
        [string]$logCommand = "-j $jmeterLogLocation"
    }
    if ($needJtl) {
        [string]$JtlCommand = "-l $jmeterJtlReportLocation"
    }
    if ($needHTML) {
        [string]$htmlCommand = "-e -o $jmeterHTMLReportLocation"
    }
    # Execute Jmeter
    "$baseCommand $JtlCommand $logCommand $htmlCommand" | Invoke-Expression

}
catch {
    throw "Check your command again. ======Jmeter Command Error======"
}
finally {
    Write-Host "======Jmeter execution finished======"
    # list last 20 lines of .log 
    Get-Content $jmeterLogLocation -tail 20
}
