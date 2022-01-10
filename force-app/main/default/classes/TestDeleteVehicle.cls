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
         Account account = new Account(Name='TEST');
         insert account;
        
         Salon__c salon = new Salon__c(Name = 'Test ', Zip_Code__c = 32321,Street__c = 'test'+1, Province__c = 'mazowieckie',Account__c = account.Id);
         insert salon;
         
         Vehicle__c vehicle = new Vehicle__c(Serial_Number__c = 00001,Salon__c =salon.Id,Model__c = 'Opel',Brand__c = 'Astra');
         insert vehicle;
         
    
         Telemetry__c telemetry = new Telemetry__c(Name='testTelemetry1',Vehicle__c = vehicle.Id);
         insert telemetry;
         
         List<Telemetry__c> telemetryBeforeDelete = [SELECT Id FROM Telemetry__c WHERE Vehicle__c  =:vehicle.Id];         

         Test.startTest();
         Database.DeleteResult result = database.delete(vehicle);
         Test.stopTest();
         
         List<Telemetry__c> telemetryAfterDelete = [SELECT Id FROM Telemetry__c WHERE Vehicle__c  =:vehicle.Id];
         System.assert(result.isSuccess());
         System.debug(telemetryBeforeDelete.size());
         System.assert(telemetryBeforeDelete.size()==1);
         System.assert(telemetryAfterDelete.size()==0);
           
        }
    }