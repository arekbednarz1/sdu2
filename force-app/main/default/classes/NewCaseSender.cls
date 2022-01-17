/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 31/12/2021
 * @description This class sending a new case when Salon__c status is 'close' .
 */

public class NewCaseSender {
  private List<Case> cases;

  public NewCaseSender(List<Case> cases) {
    this.cases = cases;
  }

  public void execute(QueueableContext context) {
    sendRequest();
  }

  @TestVisible
  private HttpResponse sendRequest() {
    Http server = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(Constants.CASE_ENDPOINT);
    request.setMethod(Constants.CASE_METHOD);
    request.setBody(JSON.serialize(cases));
    HttpResponse response = server.send(request);
    if (response.getStatusCode() == 201) {
      for (Case newCase : cases) {
        newCase.Status = Constants.CASE_CLOSED_STATUS;
      }
    } else {
      for (Case newCase : cases) {
        newCase.Status = Constants.CASE_CLOSED_STATUS;
      }
      System.debug(LoggingLevel.ERROR, Constants.CONNECTION_FAILED_MESSAGE);
    }
    update cases;
    return response;
  }
}
