/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 10/01/2021
 * @description Test class fo DeleteTelemetrySchedule class.
 */

@isTest
public class TelemetryScheduleTest {
  @isTest
  static void runScheduler() {
    Test.startTest();
    String jobId = System.schedule(
      'Test',
      Constants.CRON,
      new DeleteTelemetrySchedule()
    );
    Test.stopTest();

    CronTrigger cronTrigger = [
      SELECT Id, CronExpression, TimesTriggered, NextFireTime
      FROM CronTrigger
      WHERE Id = :jobId
    ];
    System.assertEquals(Constants.CRON, cronTrigger.CronExpression);
  }
}
