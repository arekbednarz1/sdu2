/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 31/12/2021
 * @description Handler class for SalonUpdate trigger.
 */
public class SalonHandler {
  /**
   * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
   * @date 30/12/2021
   * @description method checks salon status
   */
  public static void checkSalonStatus(List<Salon__c> inSalons) {
    List<Salon__c> closedSalons = new List<Salon__c>();
    if (inSalons != null || !closedSalons.isEmpty()) {
      for (Salon__c salon : inSalons) {
        if (salon.Salon_status__c == Constants.SALON_CLOSED_STATUS) {
          closedSalons.add(salon);
        }
      }
      if (closedSalons == null || closedSalons.isEmpty()) {
        return;
      }
    }
    NewCaseWhenSalonWasClosed req = new NewCaseWhenSalonWasClosed(closedSalons);
    System.enqueueJob(req);
  }
}
