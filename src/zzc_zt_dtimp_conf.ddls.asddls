@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZZI_ZT_DTIMP_CONF'
define root view entity ZZC_ZT_DTIMP_CONF
  provider contract transactional_query
  as projection on ZZI_ZT_DTIMP_CONF
{
  key UUID,
  Object,
  Objectname,
  Fmname,
  Mimetype,
  Sheetname,
  Structname,
  LocalLastChangedAt
  
}
