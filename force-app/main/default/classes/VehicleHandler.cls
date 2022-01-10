/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 29/12/2021
 * @description validation for Vehicle__c object. deletes all Telemetry__c objects that are in the deleted Vehicle__c object
 * @param vehicles - trigger entry list
 * @param telemetries - list of Telemetry__c records where Vehicle__c is included in the list vehicles
 */

 public class VehicleHandler {
     public static void deleteTelemetry(List<Vehicle__c> vehicles){
         if(vehicles.size()>0){
             List<Telemetry__c> telemetries = [SELECT Id FROM Telemetry__c WHERE Vehicle__c IN :vehicles];
             delete telemetries;
            }
            else{
                System.debug('Nothing to delete');
            }
        }
    }