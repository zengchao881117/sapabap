@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dynamic parameter'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGCA_R_PARAMETER as select from zgca_t0001 as t
left outer join zgca_t0002 as v on t.guid = v.guid
{   
  key t.guid as Guid,
  key v.itemguid as Itemguid,
  t.moduleid as Moduleid,
  t.modulename as Modulename,
  t.application as Application,
  t.applicationname as Applicationname,
  t.parameterid as Parameterid,
  t.parametername as Parametername,
  t.notes as Notes,
  v.itemno as Itemno,
  v.sign as Sign,
  v.zoption as zoption,
  v.low as Low,
  v.lowdesc as Lowdesc,
  v.high as High,
  v.highdesc as Highdesc,
  v.notes as valueNotes,
  t.createdby as Createdby,
  t.createdat as Createdat,
  t.lastchangedby as Lastchangedby,
  t.lastchangedat as Lastchangedat,
  t.locallastchangedat as Locallastchangedat
  
}
