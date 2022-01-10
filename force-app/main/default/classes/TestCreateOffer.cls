/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 29/12/2021
 * @description test class for Create_offer trigger.
 */
@isTest
public class TestCreateOffer {
    
     /**
      * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
      * @date 29/12/2021
      * @description method checks the creation of new offers and blocking the creation of 2 physical offers for 1 Vehicle__c
      */
      @isTest 
      static void TestAddPhysicalOfferWhereOfferExist(){
          Account account = new Account(Name='Test');
          insert account;
          
          List<Salon__c> salons = TestCreateRecords.addSalons(3);
          List<Vehicle__c> vehicles = TestCreateRecords.addVehicles(2);
          
          Salon__c salon1 = salons[1];
          salon1.Account__c=account.Id;
          insert salon1;
        
          Vehicle__c vehicle = vehicles[0];
          vehicle.Salon__c = salon1.Id;
          insert vehicle;
        
          Vehicle__c vehicle2 = vehicles[1];
          vehicle2.Salon__c = salon1.Id;
          insert vehicle2;
    
          Salon__c salon = salons[0];
          salon.Account__c=account.Id;
          insert salon;
        
          Salon__c salon2 = salons[2];
          salon2.Account__c=account.Id;
          insert salon2;

          Offer__c offer = new Offer__c(Name='Test1',Vehicle__c=vehicle.Id,Salon__c=salon1.Id,Offer_type__c='physical');
          insert offer;
               
        
          Test.startTest();
          Offer__c offer2 = new Offer__c(Name='Test2',Vehicle__c=vehicle.Id,Salon__c=salon2.Id,Offer_type__c='physical');
          Database.SaveResult result = Database.insert(offer2, false);
          System.debug(result);
          Test.stopTest();    
        
      
          for(Database.Error err : result.getErrors()){
            System.assert(!result.isSuccess());
            System.assertEquals('Vehicle is available in ' + salon1.Name + ' salon',err.getMessage());
        }
    }
}