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
    Salon__c salon = TestCreateRecords.addSalons(1)[0];
    salon.Salon_status__c = Constants.SALON_CLOSED_STATUS;
    update salon;
    List<Salon__c> salons = new List<Salon__c>();
    salons.add(salon);
    return salons;
  }

  /**
   * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
   * @date 17/01/2022
   * @description test method to check status when response is correct.
   */
  @isTest
  static void testMethodWhenResponseIsCorrect() {
    MockNewCaseWhenChangeSalonStatusTest.setTestMockResponse(201);
    List<Salon__c> salons = createClosed();
    NewCaseWhenSalonWasClosed nc = new NewCaseWhenSalonWasClosed(salons);
    List<Case> cases = nc.getCases();
    NewCaseSender caseSender = new NewCaseSender(cases);

    Test.startTest();
    HttpResponse response = caseSender.sendRequest();
    id jobId = System.enqueueJob(caseSender);
    Test.stopTest();

    System.assert(jobId != null);
    String contentType = response.getHeader(Constants.CONTENT_TYPE);
    System.assert(contentType == Constants.JSON_TYPE);
    for (Case newCase : cases) {
      System.assert(newCase.Status.equals(Constants.CASE_CLOSED_STATUS));
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
    List<Salon__c> salons = createClosed();

    NewCaseWhenSalonWasClosed nc = new NewCaseWhenSalonWasClosed(salons);
    List<Case> cases = nc.getCases();
    NewCaseSender caseSender = new NewCaseSender(cases);

    Test.startTest();
    HttpResponse response = caseSender.sendRequest();
    Test.stopTest();

    String contentType = response.getHeader(Constants.CONTENT_TYPE);
    System.assert(contentType == Constants.JSON_TYPE);
    for (Case case : cases) {
      System.assert(case.Status.equals(Constants.CASE_FAILD_STATUS));
      System.assertEquals(123, response.getStatusCode());
    }
  }
}
