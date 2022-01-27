/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 24/01/2022
 * @description class for sending request to renovation team when a salon is being closed .
 */
public class NewCaseSender implements Queueable, Database.AllowsCallouts {
  private List<Case> cases;

  public NewCaseSender(List<Case> cases) {
    this.cases = cases;
  }

  public void execute(QueueableContext context) {
    sendRequest();
  }

  public HttpResponse sendRequest() {
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
        newCase.Status = Constants.CASE_FAILD_STATUS;
      }
    }
    update cases;
    return response;
  }
}
