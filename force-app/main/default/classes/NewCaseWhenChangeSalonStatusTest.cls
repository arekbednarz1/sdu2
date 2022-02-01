/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 17/01/2022
 * @description Test class for NewCaseSender, NewCaseWhenSalonWasClosed classes.
 */

@isTest
public class NewCaseWhenChangeSalonStatusTest {
  /**
   * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
   * @date 17/01/2022
   * @description helping method to create closed salons .
   */
  public static List<Salon__c> createClosed() {
    List<Salon__c> salons = TestCreateRecords.addSalons(100);
    List<Salon__c> updatedSalons = new List<Salon__c>();
    for (Integer i = 0; i < salons.size(); i++) {
      Salon__c salon = salons[i];
      salon.Salon_status__c = Constants.SALON_CLOSED_STATUS;
      updatedSalons.add(salon);
    }
    update updatedSalons;
    return updatedSalons;
  }

  /**
   * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
   * @date 17/01/2022
   * @description test method to check status when response is correct.
   */
  @isTest
  static void testMethodWhenResponseIsCorrect() {
    MockNewCaseWhenChangeSalonStatusTest.setTestMockResponse(201);
    List<Salon__c> closedSalons = createClosed();

    List<Case> newCases = new List<Case>();

    for (Integer i = 0; i < closedSalons.size(); i++) {
      newCases.add(
        new Case(
          Status = 'New',
          Subject = Constants.RENOVATION_CASE + closedSalons[i].Name,
          Salon__c = closedSalons[i].id
        )
      );
    }
    insert newCases;

    NewCaseSender nc = new NewCaseSender(newCases);
    System.debug(newCases.size());

    Test.startTest();
    HttpResponse response = nc.sendRequest();
    id jobId = System.enqueueJob(nc);
    Test.stopTest();

    System.assert(jobId != null);
    String contentType = response.getHeader(Constants.CONTENT_TYPE);
    System.assert(contentType == Constants.JSON_TYPE);
    for (Case createdCase : newCases) {
      System.assert(createdCase.Status.equals(Constants.CASE_CLOSED_STATUS));
    }
    System.assertEquals(201, response.getStatusCode());
  }

  /**
   * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
   * @date 17/01/2022
   * @description test method to check status when response faild.
   */
  @isTest
  static void testMethodWhenFaild() {
    MockNewCaseWhenChangeSalonStatusTest.setTestMockResponse(123);
    List<Salon__c> closedSalons = createClosed();

    List<Case> newCases = new List<Case>();

    for (Integer i = 0; i < closedSalons.size(); i++) {
      newCases.add(
        new Case(
          Status = 'New',
          Subject = Constants.RENOVATION_CASE + closedSalons[i].Name,
          Salon__c = closedSalons[i].id
        )
      );
    }
    insert newCases;

    NewCaseSender nc = new NewCaseSender(newCases);

    Test.startTest();
    HttpResponse response = nc.sendRequest();
    Test.stopTest();

    String contentType = response.getHeader(Constants.CONTENT_TYPE);
    System.assert(contentType == Constants.JSON_TYPE);
    for (Case createdCase : newCases) {
      System.assert(createdCase.Status.equals(Constants.CASE_FAILD_STATUS));
      System.assertEquals(123, response.getStatusCode());
    }
  }
}
