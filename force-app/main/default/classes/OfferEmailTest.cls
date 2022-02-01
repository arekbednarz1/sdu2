/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 30/12/2021
 * @description Test class fo OfferEmail class.
 */

@isTest
public class OfferEmailTest {
  /**
   * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
   * @date 30/12/2021
   * @description method checks how many emails are sent when creating many offers
   */
  @isTest
  public static void test1MailManyOffers() {
    List<Salon__c> salons = TestCreateRecords.addSalons(1);
    List<Vehicle__c> vehicles = TestCreateRecords.addVehicles(200);
    List<Offer__c> offers = new List<Offer__c>();

    for (Integer i = 0; i < vehicles.size(); i++) {
      Offer__c offer = new Offer__c(
        Name = Constants.TEST_WORD + i,
        Vehicle__c = vehicles[i].Id,
        Offer_type__c = Constants.OFFER_TYPE,
        Salon__c = salons[0].Id
      );
      offers.add(offer);
    }

    Test.startTest();
    Database.SaveResult[] insertResults = database.insert(offers);
    Integer methodEmailCall = Limits.getFutureCalls();
    Test.stopTest();

    for (Database.SaveResult result : insertResults) {
      System.assert(result.isSuccess());
    }
    System.assertEquals(1, methodEmailCall);
  }
}
