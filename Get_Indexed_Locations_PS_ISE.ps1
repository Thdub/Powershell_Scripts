$InteropDLL = "$PSScriptRoot\Microsoft.Search.Interop.dll"
Add-Type -Path ($InteropDLL)
$Search = New-Object Microsoft.Search.Interop.CSearchManagerClass
$Catalog = $Search.GetCatalog("SystemIndex")
$ScopeManager = $Catalog.GetCrawlScopeManager()
$ScopeRules = @()
$FirstLoop = $True
[Microsoft.Search.Interop.CSearchScopeRule]$CurrentScope = $null
$Enumeration = $ScopeManager.EnumerateScopeRules()
Do 
    {
    $Enumeration.Next(1,[ref]$CurrentScope,[ref]$null)
    $Firstloop = $False
    $ScopeRules +=$CurrentScope
    }
While ($CurrentScope -NE $Null -OR $FirstLoop)
$Filter = @{FilterScript = {$_.IsIncluded},{$_.IsDefault}}
$ScopeRules