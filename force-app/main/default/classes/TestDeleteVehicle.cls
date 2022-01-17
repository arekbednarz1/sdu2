/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 30/12/2021
 * @description test class for DeleteVehicle trigger.
 */
@isTest
public class TestDeleteVehicle {

    
    

    /**
     * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
     * @date 30/12/2021
     * @description method checks for deletion telemetry associated with the deleted vehicle
     */
    
    @isTest 
    static void deleteTelemetryWhenDeleteVehicle(){
    
        List<Telemetry__c> telemetryToDelete= TestCreateRecords.createTelemetries(200);
        Id vehicleToDeleteId = telemetryToDelete.get(0).Vehicle__c;

        Test.startTest(); 
        Database.DeleteResult result = database.delete(vehicleToDeleteId); 
        Test.stopTest();

        List<Telemetry__c> telemetryAfterDelete = [SELECT Id FROM Telemetry__c WHERE Vehicle__c  =:vehicleToDeleteId];
        System.assert(result.isSuccess());
        System.assert(telemetryToDelete.size()==200);
        System.assert(telemetryAfterDelete.size()==0); 
     }
}