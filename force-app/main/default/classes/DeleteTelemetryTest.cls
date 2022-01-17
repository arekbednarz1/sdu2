/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 31/12/2021
 * @description Test class fo DeleteTelemetrySchedule class.
 */

@isTest
public class DeleteTelemetryTest {
  /**
   * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
   * @date 31/12/2021
   * @description method test deleting old telemetries.
   */
  @isTest
  static void deleteOldTelemetry() {
    DateTime date4MonthAgo = DateTime.now().addDays(-121);
    List<Telemetry__c> telemetries = TestCreateRecords.createTelemetries(1);
    System.assert(telemetries.size() == 1);

    Test.startTest();
    DeleteTelemetryOlderThan3Month deleteTelemetry = new DeleteTelemetryOlderThan3Month();
    Id batch = Database.executeBatch(deleteTelemetry);
    Test.stopTest();

    System.assert(batch != null);
    List<Telemetry__c> telemetryAfterDelete = [SELECT Id FROM Telemetry__c];
    System.assert(telemetryAfterDelete.size() == 0);
  }
}
