---
external help file: RAps-help.xml
Module Name: RAps
online version:
schema: 2.0.0
---

# Get-RASite

## SYNOPSIS
This function returns all existing sites in the Alero portal.

## SYNTAX

```
Get-RASite [-Authn] <SecureString> [[-Limit] <Int32>] [[-Offset] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
You can return a number of sites from the Alero portal.

## EXAMPLES

### Example 1
```
PS C:\> Get-RASite -Authn $auth
```

This command returns the first 100 (default value of the $Limit parameter) sites from the Alero portal.

### Example 2
```
PS C:\> Get-RASite -Authn $auth -Limit 50 -Offset 25
```

This command returns 50 sites from the Alero portal, starting from the 25th site.

## PARAMETERS

### -Authn
Token to authenticate to Alero.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Limit
The maximum number of entries to return

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Offset
The number of entries to skip

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Security.SecureString
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
