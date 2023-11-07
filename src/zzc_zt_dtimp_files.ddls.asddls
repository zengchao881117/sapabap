@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZZR_ZT_DTIMP_FILES'
define root view entity ZZC_ZT_DTIMP_FILES
  provider contract transactional_query
  as projection on ZZR_ZT_DTIMP_FILES
{
  key UUID,
      UuidConf,
      _configuration.Objectname,
      MimeType,
      Attachment,
      FileName,
      LocalLastChangedAt,
      JobCount,
      JobName,
      LogHandle,
      Status,
      _configuration : redirected to ZZC_ZT_DTIMP_CONF

}
