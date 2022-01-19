/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 29/12/2021
 * @description trigger: delete an Telemetry__c record when the related object has been deleted
 */

trigger DeleteVehicle on Vehicle__c(before delete) {
  if (Trigger.isBefore) {
    if (Trigger.isDelete) {
      VehicleHandler.deleteTelemetry(Trigger.Old);
    }
  }
}
