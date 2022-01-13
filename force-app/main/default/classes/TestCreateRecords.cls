/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 28/12/2021
 * @description records factory class for tests.
 */
@isTest 
public class TestCreateRecords {
    
    
   /**
    * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
    * @date 13.01.2022
    * @description helping method for creating an accounts to tests
    * @return list containing created account
    */
    private static List<Account> createTestAccount(){
        List<Account> testAccounts = [SELECT Id FROM Account WHERE Name = :Constants.TEST_ACCOUNT];
        if(testAccounts.size() == 0){
            Account testAccount = new Account(Name = Constants.TEST_ACCOUNT);
            testAccounts = new List<Account>{testAccount};     
                }
        insert testAccounts;
        return testAccounts;
    }
    
    
   /**
    * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
    * @date 28/12/2021
    * @description method for creating salons for tests
    * @param inSalonNumbers number of salons to create
    * @return list of created salons
    */
    public static List<Salon__c> addSalons(Integer inSalonNumbers){
        List<Salon__c> salons = new List<Salon__c>();
        List<Account> accounts = createTestAccount();
        if(inSalonNumbers !=null){
            for(Integer i = 0; i < inSalonNumbers; i++){
                Salon__c salon = new Salon__c(Name = Constants.TEST_SALON+i,Account__c = accounts[0].Id);
                salons.add(salon);
            }
        }
        insert salons;
        return salons;
    }    
    
    
   /**
    * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
    * @date 28/12/2021
    * @description method for creating Vehicles for tests
    * @param inVehiclesNumbers number of vehicles to create
    * @return list of created vehicles
    */
    public static List<Vehicle__c> addVehicles(Integer inVehiclesNumbers){   
        List<Vehicle__c> vehicles = new List<Vehicle__c>();
        Vehicle__c vehicle = new Vehicle__c();
        for(Integer i = 0; i < inVehiclesNumbers; i++){
            if(i<100){
                vehicle = new Vehicle__c(Serial_Number__c = 0000+i,Model__c = Constants.TEST_VEHICLE_MODEL+i,Brand__c = Constants.TEST_VEHICLE_BRAND+i);
            }else{
                vehicle = new Vehicle__c(Serial_Number__c = i,Model__c = Constants.TEST_VEHICLE_MODEL+i,Brand__c = Constants.TEST_VEHICLE_BRAND+i);
            }
            vehicles.add(vehicle);
        }
        insert vehicles;
        return vehicles;
    }
    
    
   /**
    * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
    * @date 28/12/2021
    * @description method for creating Telemetries for tests
    * @param inTelemetryNumbers number of telemetries to create
    * @return list of created telemetries
    */
   
    public static List<Telemetry__c> createTelemetries(Integer inTelemetryNumbers){
        List<Telemetry__c> telemetries = new List<Telemetry__c>();
        List<Vehicle__c> vehicles = addVehicles(1);
        for(Integer i = 0; i < inTelemetryNumbers; i++){
            Telemetry__c telemetry = new Telemetry__c(Name = Constants.TEST_TELEMETRY_NAME+i,Vehicle__c = vehicles[0].Id );
            telemetries.add(telemetry);
        }
        insert telemetries;
        return telemetries;
    }
}