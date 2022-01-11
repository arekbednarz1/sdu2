/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 10/01/2021
 * @description Test class fo OfferEmail class.
 */

@isTest
public class OfferEmailTest {
    
    @isTest
    public static void test1MailManyOffers(){
        Account account = new Account(Name='Test');
        insert account;

        List<Salon__c> salons = TestCreateRecords.addSalons(8);
        for(Salon__c s : salons){
            s.Account__c = account.Id;
        }
        insert salons;
        
        
        List <Vehicle__c> vehicles = TestCreateRecords.addVehicles(10);
        for(Vehicle__c v: vehicles){
            v.Salon__c=salons[0].Id;
        }
        insert vehicles;
        
        List<Offer__c> offers = new List<Offer__c>();
        
        Offer__c offer1 = new Offer__c(Name='Test1',Vehicle__c=vehicles[0].Id,Salon__c=salons[0].Id,Offer_type__c='physical');
       	offers.add(offer1);
        Offer__c offer2 = new Offer__c(Name='Test2',Vehicle__c=vehicles[1].Id,Salon__c=salons[0].Id,Offer_type__c='physical');
        offers.add(offer2);
        Offer__c offer3 = new Offer__c(Name='Test3',Vehicle__c=vehicles[2].Id,Salon__c=salons[0].Id,Offer_type__c='physical');
        offers.add(offer3);
        
        
        Test.startTest();
        Database.SaveResult[] result = database.insert(offers);
        Integer methodEmailCall = Limits.getFutureCalls();
        Test.stopTest();
        
        for(Database.SaveResult res : result){
            System.assert(res.isSuccess());
        }
        System.assertEquals(1,methodEmailCall);
    }
}