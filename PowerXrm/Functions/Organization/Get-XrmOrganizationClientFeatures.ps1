<#
    .SYNOPSIS
    Get Organization Client Features
#>
function Get-XrmOrganizationClientFeatures {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $organization = $XrmClient | Get-XrmOrganization -Columns "clientfeatureset";
        $features = @{};

        if($organization.clientfeatureset)
        {
            $featuresXml = [xml] $organization.clientfeatureset;
            if($Name)            {
                $feature = $featuresXml.clientfeatures.clientfeature | where-object -Property name -eq $Name;   
                if($feature)
                {
                    $features[$feature.name] = $feature.value;
                }
            }
            else {
                foreach($feature in $featuresXml.clientfeatures.clientfeature)
                {
                    $features[$feature.name] = $feature.value;
                }                
            }
        }
        return $features;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmOrganizationClientFeatures -Alias *;