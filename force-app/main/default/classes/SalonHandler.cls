/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 10/01/2022
 * @description Handler class for SalonUpdate trigger.
 */
public class SalonHandler {

    public static void checkSalonStatus(List<Salon__c> salons){
        List<Salon__c> closedSalons = new List<Salon__c>();
        for(Salon__c sal : salons){
            if(sal.Salon_status__c =='close'){
                closedSalons.add(sal);
            }
        }
        NewCaseWhenSalonWasClosed req = new NewCaseWhenSalonWasClosed(closedSalons);
        System.enqueueJob(req);
    }
}