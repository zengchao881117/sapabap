@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Parameter Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGCA_I_PARAMETERITEM
  as select from zgca_t0002 as item
  association to parent zgca_i_parameter as _parameter on _parameter.guid = $projection.guid
{
  key  item.itemguid           as Itemguid,
       item.guid               as Guid,
       item.itemno             as Itemno,
       item.sign               as Sign,
       item.zoption            as Zoption,
       item.low                as Low,
       item.lowdesc            as Lowdesc,
       item.high               as High,
       item.highdesc           as Highdesc,
       item.notes              as Notes,
       @Semantics.user.createdBy: true
       item.createdby          as Createdby,
       @Semantics.systemDateTime.createdAt: true
       item.createdat          as Createdat,
       @Semantics.user.lastChangedBy: true
       item.lastchangedby      as Lastchangedby,
       @Semantics.systemDateTime.lastChangedAt: true
       item.lastchangedat      as Lastchangedat,
       @Semantics.systemDateTime.localInstanceLastChangedAt: true
       item.locallastchangedat as Locallastchangedat,

       _parameter
}
