/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 23/12/2021
 * @description trigger: check availability of Vehicle__c record
 */

trigger Create_Offer on Offer__c(before insert, before update, after insert) {
  if (Trigger.isBefore) {
    if (Trigger.isInsert || Trigger.isUpdate) {
      CreateOffer_Handler.checkAv(Trigger.New);
      CreateOffer_Handler.updateSalonOffer(Trigger.New);
    }
  }
  if (Trigger.isAfter && Trigger.isInsert) {
    List<Id> offers = new List<Id>();
    for (Offer__c record : Trigger.new) {
      offers.add(record.Id);
    }
    OfferEmail.email(offers);
  }
}
