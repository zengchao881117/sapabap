@EndUserText.label: 'Dynamic parameter Value'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZGCA_C_PARAMETERITEM as projection on ZGCA_I_PARAMETERITEM
{
    key Itemguid,
    Guid,
    Itemno,
    Sign,
    Zoption,
    Low,
    Lowdesc,
    High,
    Highdesc,
    Notes,
    Createdby,
    Createdat,
    Lastchangedby,
    Lastchangedat,
    Locallastchangedat,
    /* Associations */
    _parameter : redirected to parent ZGCA_C_PARAMETER
}
