@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dynamic parameter'
define root view entity ZGCA_I_PARAMETER
  as select from zgca_t0001 as parameter
  composition [0..*] of ZGCA_I_PARAMETERITEM as _item
{
  key parameter.guid               as Guid,
      parameter.moduleid           as ModuleId,
      parameter.modulename         as ModuleName,
      parameter.application        as Application,
      parameter.applicationname    as ApplicationName,
      parameter.parameterid        as Parameterid,
      parameter.parametername      as ParameterName,
      parameter.notes              as Notes,
      @Semantics.user.createdBy: true
      parameter.createdby          as Createdby,
      @Semantics.systemDateTime.createdAt: true
      parameter.createdat          as Createdat,
      @Semantics.user.lastChangedBy: true
      parameter.lastchangedby      as Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      parameter.lastchangedat      as Lastchangedat,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      parameter.locallastchangedat as Locallastchangedat,

      _item // Make association public
}
