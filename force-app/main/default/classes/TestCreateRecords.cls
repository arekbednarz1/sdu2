/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 29/12/2021
 * @description records factory class for tests.
 */

@isTest 
public class TestCreateRecords {
    public static List<Salon__c> addSalons(Integer numbers){
        List<Salon__c> salons = new List<Salon__c>();
        if(numbers !=null){
            for(Integer i = 0; i < numbers; i++){
                Salon__c salon = new Salon__c(Name = 'Test '+i, Zip_Code__c = 32321,Street__c = 'test'+1, Province__c = 'mazowieckie',Account__c = new Account(Name='TEST').Id);
                salons.add(salon);
            }
        }
        return salons;
    }    
    public static List<Vehicle__c> addVehicles(Integer numbers){   
        List<Vehicle__c> vehicles = new List<Vehicle__c>();
        for(Integer i = 0; i < numbers; i++){
            if(i<100){
                Vehicle__c vehicle = new Vehicle__c(Serial_Number__c = 0000+i,Model__c = 'Opel'+i,Brand__c = 'Astra'+i);
                vehicles.add(vehicle);
            }
            else if(i>=100){
                Vehicle__c vehicle = new Vehicle__c(Serial_Number__c =i,Model__c = 'Opel'+i,Brand__c = 'Astra'+i);
                vehicles.add(vehicle);
            }
            else{
                break;
            }
        }
        return vehicles;
    }
      
    public static List<Telemetry__c> createTelemetries(Integer telemetryNumbers){
        List<Telemetry__c> telemetries = new List<Telemetry__c>();
        for(Integer i = 0; i < telemetryNumbers; i++){
            Telemetry__c telemetry = new Telemetry__c(Name = 'Test'+i);
            telemetries.add(telemetry);
        }
        return telemetries;
    }
}