/**
* @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
* @date 29/12/2021
* @description trigger: create new renevation case when Salon__c status is 'close'
*/

trigger SalonUpdate on Salon__c (before insert, before update, after insert, after update) {
 
    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUpdate){
            SalonHandler.checkSalonStatus(Trigger.New);
        }
    }
}