---
external help file: AleroPS-help.xml
Module Name: AleroPS
online version:
schema: 2.0.0
---

# Remove-RAVendor

## SYNOPSIS
This functions removes a vendor from the Alero portal.

## SYNTAX

```
Remove-RAVendor [-Authn] <SecureString> [[-VendorId] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function removes the vendor associated to the vendor ID from Alero.

## EXAMPLES

### Example 1
```
PS C:\> Remove-RAVendor -Authn $auth -VendorId j234f3dadw65sd76aj2k3423j4h
```

This command removes the vendor from Alero.

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

### -VendorId
The unique ID of the vendor

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs. The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
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
