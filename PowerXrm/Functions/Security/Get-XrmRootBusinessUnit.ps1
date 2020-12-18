<#
    .SYNOPSIS
    Retrieve root business unit
#>
function Get-XrmRootBusinessUnit {
    [CmdletBinding()]    
    [OutputType("Microsoft.Xrm.Sdk.Query.QueryExpression")]
    param
    ( 
        [Parameter(Mandatory=$false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,        

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Columns = @("*")
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {
       $queryBusinessUnit = New-XrmQueryExpression -LogicalName "businessunit" -Columns $Columns;
       $queryBusinessUnit = $queryBusinessUnit | Add-XrmQueryCondition -Field "parentbusinessunitid" -Condition Null;
       $businessUnits = $XrmClient | Get-XrmMultipleRecords -Query $queryBusinessUnit;
       $businessUnit = $businessUnits | Select-Object -First 1;
       $businessUnit;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}
Export-ModuleMember -Function Get-XrmRootBusinessUnit -Alias *;