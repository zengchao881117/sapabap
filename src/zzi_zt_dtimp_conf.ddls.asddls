@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED ZZT_DTIMP_CONF'
define root view entity ZZI_ZT_DTIMP_CONF
  as select from zzt_dtimp_conf as Configuration
{
  key uuid as UUID,
  object as Object,
  objectname as Objectname,
  fmname as Fmname,
  mimetype as Mimetype,
  sheetname as Sheetname,
  structname as Structname,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.lastChangedBy: true
  last_changed_by as LastChangedBy,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt
  
}
