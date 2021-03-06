param(
    [Parameter(Position=0, Mandatory=0)]
    [string]$taskName,
    [Parameter(Position=1, Mandatory=0)]
    [alias("to")]
    [string]$on,
    [Parameter(Position=2, Mandatory=0)]
    [System.Collections.Hashtable]$properties = @{},
    [Parameter(Position=3, Mandatory=0)]
    [switch]$docs = $false
)

$buildFile = "deploy.ps1"
$taskList = @($taskName)
$nologo = $true

# Set environment if specified
if($on) {
    $properties.env = $on
}

$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.path) 
remove-module unfold -ErrorAction SilentlyContinue

# First try local unfold
$import = join-path $scriptPath .\unfold\unfold.psm1

# Then from profile
If(-not (Test-Path $import)) {
    $import = "unfold"
}

import-module $import -ArgumentList $properties

invoke-psake $buildFile $taskList "4.0" $docs @{} $properties {
    Initialize-Configuration
} $nologo 

Remove-Sessions
remove-module unfold
