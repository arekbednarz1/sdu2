/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 30/12/2021
 * @description This class sending email after adding an offer.
 */

public class OfferEmail {
  /**
   * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
   * @date 18/01/2022
   * @description method creating email with offer .
   * @param inOfferId - entry list from trigger
   */
  @future
  public static void createEmail(List<Id> inOfferId) {
    if (inOfferId == null || inOfferId.isEmpty()) {
      return;
    }
    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    List<String> addresses = new List<String>();
    addresses.add(Constants.EMAIL_SUBJECT);
    email.setToAddresses(addresses);
    email.setSubject(Constants.EMAIL_SUBJECT);
    String body = Constants.OFFER_NAME;
    List<Offer__c> offers = [SELECT Name FROM Offer__c WHERE Id IN :inOfferId];
    for (Offer__c ps : offers) {
      body += (' ' + ps.Name);
    }
    email.setPlainTextBody(body);
    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ email });
  }
}
