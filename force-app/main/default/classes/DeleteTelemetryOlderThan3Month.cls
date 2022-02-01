/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 31/12/2021
 * @description Batchable class. Used to run thousands records.
 */

public class DeleteTelemetryOlderThan3Month implements Database.Batchable<sObject> {
  public Database.QueryLocator start(Database.BatchableContext context) {
    return Database.getQueryLocator(
      'SELECT Id FROM Telemetry__c WHERE CreatedDate < LAST_N_MONTHS:3'
    );
  }
  public void execute(
    Database.BatchableContext context,
    List<sObject> records
  ) {
    if (records.size() > 0) {
      delete records;
    }
  }
  public void finish(Database.BatchableContext context) {
    System.debug(LoggingLevel.INFO, Constants.DELETED_TELEMETRY);
  }
}
