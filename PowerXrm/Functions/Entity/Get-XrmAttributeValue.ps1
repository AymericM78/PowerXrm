<#
    .SYNOPSIS
    Read entity attribute.
#>
function Get-XrmAttributeValue {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Entity]
        $Record,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        [Parameter(Mandatory = $false)]
        [Switch]
        $FormattedValue,

        [Parameter(Mandatory = $false)]
        [bool]
        $RaiseErrorIfMissing = $false
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {

        if (-not $Record.Contains($Name)) {
            if ($RaiseErrorIfMissing) {
                throw "Attribute '$Name' is not in given record.";
            } 
            return $null;
        }
        
        if ($FormattedValue -and $Record.FormattedValues.ContainsKey($Name)) {
            return $Record.FormattedValues[$Name];
        }

        return $Record[$Name];                
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Set-Alias GetAttributeValue Get-XrmAttributeValue;
Export-ModuleMember -Function Get-XrmAttributeValue -Alias *;

Register-ArgumentCompleter -CommandName Get-XrmAttributeValue -ParameterName "Name" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $record = $null;
    if (-not ($FakeBoundParameters.ContainsKey("Record"))) {
        # TODO : Search record  for logicalname in Pipeline
        return @();
    }
    else {
        $record = $FakeBoundParameters.Record;         
    }

    $validAttributeNames = @($record.Attributes.Keys);
    return $validAttributeNames | Where-Object { $_ -like "$wordToComplete*" };
}