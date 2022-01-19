/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 31/12/2021
 * @description This class creating a new case when Salon__c status is 'close' .
 */

public class NewCaseWhenSalonWasClosed implements Queueable, Database.AllowsCallouts {
  private List<Case> cases = new List<Case>();
  private List<Salon__c> salons;

  public NewCaseWhenSalonWasClosed(List<Salon__c> salons) {
    this.salons = salons;
  }

  public void execute(QueueableContext context) {
    for (Salon__c salon : salons) {
      cases.add(
        new Case(
          Subject = Constants.RENOVATION_CASE + salon.Name,
          Salon__c = salon.id
        )
      );
    }
    insert cases;
    sendRequest(cases);
  }

  public List<Case> getCases() {
    return cases;
  }
  @TestVisible
  private HttpResponse sendRequest(List<Case> caseToSend) {
    Http server = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(Constants.CASE_ENDPOINT);
    request.setMethod(Constants.CASE_METHOD);
    request.setBody(JSON.serialize(caseToSend));
    HttpResponse response = server.send(request);
    if (response.getStatusCode() == 201) {
      for (Case newCase : caseToSend) {
        newCase.Status = Constants.CASE_CLOSED_STATUS;
      }
    } else {
      for (Case newCase : caseToSend) {
        newCase.Status = Constants.CASE_CLOSED_STATUS;
      }
      System.debug(LoggingLevel.ERROR, Constants.CONNECTION_FAILED_MESSAGE);
    }
    return response;
  }
}
