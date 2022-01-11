/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 10/01/2021
 * @description This class sending email after adding an offer.
 */

public class OfferEmail {
    
    @future
    public static void email(List <Id> offerId){
        if(offerId.size()>0){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            List<String>addresses = new List<String>();
            addresses.add('arkadiusz_bednarz@o2.pl');
            email.setToAddresses(addresses);
            email.setSubject('Nowa oferta ');
            String body='nazwa oferty:';
            List<Offer__c> offers = [Select Name FROM Offer__c WHERE Id In: offerId];
            for(Offer__c ps : offers){
                System.debug('-------++++++++-----------');
                System.debug(ps.Name);
                body+=(' '+ps.Name); 
            }
            email.setPlainTextBody(body);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        }
    }