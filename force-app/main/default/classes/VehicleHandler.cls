/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 29/12/2021
 * @description validation for Vehicle__c object. deletes all Telemetry__c objects that are in the deleted Vehicle__c object
 */
public class VehicleHandler {
    
    /**
     * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
     * @date 28/12/2021
     * @description method removes all telemetry related to deleted vehicles
     * @param inDeletedVehicles - trigger entry list
	 */
    public static void deleteTelemetry(List<Vehicle__c> inDeletedVehicles){
        if(inDeletedVehicles==null || inDeletedVehicles.isEmpty()){
            return;
        }
        List<Telemetry__c> telemetries = [SELECT Id FROM Telemetry__c WHERE Vehicle__c IN :inDeletedVehicles];    
        delete telemetries;
    }
}


