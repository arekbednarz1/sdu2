/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 29/12/2021
 * @description trigger: create new renevation case when Salon__c status is 'close'
 */

trigger SalonUpdate on Salon__c(after insert, after update) {
  if (Trigger.isAfter) {
    if (Trigger.isInsert || Trigger.isUpdate) {
      SalonHandler.checkSalonStatus(Trigger.New);
    }
  }
}
