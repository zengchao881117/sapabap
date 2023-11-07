@EndUserText.label: 'Dynamic parameter'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZGCA_C_PARAMETER as projection on ZGCA_I_PARAMETER
{
    key Guid,
    ModuleId,
    ModuleName,
    Application,
    ApplicationName,
    Parameterid,
    ParameterName,
    Notes,
    Createdby,
    Createdat,
    Lastchangedby,
    Lastchangedat,
    Locallastchangedat,
    /* Associations */
    _item:redirected to composition child ZGCA_C_PARAMETERITEM
}
