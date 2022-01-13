/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 28/12/2021
 * @description test class for Create_offer trigger.
 */
@isTest
public class TestCreateOffer {
    
     
/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 28/12/2021
 * @description method checks the creation of new offers and blocking the creation of 2 physical offers for 1 Vehicle__c
 */
    @isTest 
    static void TestAddPhysicalOfferWhereOfferExist(){
        List<Salon__c> salons = TestCreateRecords.addSalons(2);
        List<Vehicle__c> vehicles = TestCreateRecords.addVehicles(200);
        List<Offer__c> offers = new List<Offer__c>();
        List<Offer__c> offersDuplicate = new List<Offer__c>();

         for(Integer i=0;i<=199;i++){
             Offer__c offer = new Offer__c(Name=Constants.TEST_OFFER_NAME,Vehicle__c=vehicles[i].Id,Salon__c=salons[0].Id,Offer_type__c=Constants.PHYSICAL_OFFER);
             offers.add(offer);
        }
        insert offers;
        
        for(Integer i=0;i<=199;i++){
            Offer__c offer = new Offer__c(Name=Constants.TEST_OFFER_NAME,Vehicle__c=vehicles[i].Id,Salon__c=salons[1].Id,Offer_type__c=Constants.PHYSICAL_OFFER);
            offersDuplicate.add(offer);
        }
        
        Test.startTest();
        Database.SaveResult[] result = Database.insert(offersDuplicate, false);
        Test.stopTest();    
        
        for(Integer i = 0 ; i<offers.size(); i++){
            System.assert(!result[i].isSuccess());
            System.assertEquals('Vehicle is available in ' + salons[0].Name + ' salon',result[i].getErrors()[0].getMessage());
            }
        }
}