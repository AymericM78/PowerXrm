# Command : `Get-XrmMultipleRecords` 

## Description

**Retrieve multiple records with QueryExpression.** : Get rows from Microsoft Dataverse table with specified query (QueryBase). 
This command use pagination to pull all records.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Query|QueryBase|2|true||Query that select and filter data from Microsoft Dataverse table. (QueryBase)
PageSize|Int32|3|false|1000|Specify row count per page to pull. (Default: 1000)
ShowProgress|SwitchParameter|named|false|False|

## Outputs
Custom Objects array. Rows (= Entity records) are converted to custom object to simplify data operations.

## Usage

```Powershell 
Get-XrmMultipleRecords [[-XrmClient] <ServiceClient>] [-Query] <QueryBase> [[-PageSize] <Int32>] [-ShowProgress] [<CommonParameters>]
``` 

## Examples

```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
$queryAccounts = New-XrmQueryExpression -LogicalName "account" -Columns "*" `
                | Add-XrmQueryCondition -Field "name" -Condition Like -Values "D%" `
                | Add-XrmQueryCondition -Field "createdon" -Condition LastXMonths -Values 20;
$accounts = Get-XrmMultipleRecords -XrmClient $xrmClient -Query $queryAccounts;
``` 

## More informations

System.Object[]


