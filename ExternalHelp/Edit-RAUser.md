---
external help file: RAps-help.xml
Module Name: RAps
online version:
schema: 2.0.0
---

# Edit-RAUser

## SYNOPSIS
This function edits the status of an existing Alero user.

## SYNTAX

```
Edit-RAUser [-Authn] <SecureString> [-UserId] <String> [-Status] <String> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
So far only the status of the specified Alero user can be edited.

## EXAMPLES

### Example 1
```
PS C:\> Edit-RAUser -Authn $auth -UserId 23j4h4k21h23k1j34hh2134hjkhkh32 -Status Deactivated
```

This command changes the status of the specified user from 'Activated' to 'Deactivated'.

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

### -Status
The updated status of the user's account.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Deactivated, Activated

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserId
The unique ID of the user

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
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
