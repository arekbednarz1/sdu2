/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 23/12/2021
 * @description trigger: check availability of Vehicle__c record
 */

trigger Create_Offer on Offer__c (before insert, before update, after insert) {
    if(trigger.isBefore){
        if(trigger.isInsert || trigger.isUpdate){
            CreateOffer_Handler.checkAv(Trigger.New);
            for(Offer__c offerToAdd : Trigger.New){
               Id vehicleToAddId = offerToAdd.Vehicle__c;
               Vehicle__c vehicleWithNoSalon = [SELECT Id, Name, Salon__c FROM Vehicle__c WHERE Id =: vehicleToAddId];
               vehicleWithNoSalon.Salon__c = offerToAdd.Salon__c;
               update vehicleWithNoSalon;
            }
        }
    }
}
  