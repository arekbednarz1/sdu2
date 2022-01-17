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
    NewCaseSender request = new NewCaseSender(cases);
  }

  public List<Case> getCases() {
    return cases;
  }
}
