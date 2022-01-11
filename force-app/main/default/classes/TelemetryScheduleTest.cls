/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 10/01/2021
 * @description Test class fo DeleteTelemetrySchedule class.
 */


@isTest
public class TelemetryScheduleTest {
    
    @isTest
    static void runScheduler(){
        Test.startTest();
        String jobId = System.schedule('Test','0 0 0 1 7 ? *', new DeleteTelemetrySchedule());
        Test.stopTest();
        
        CronTrigger cronTrigger = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id =:jobId];
        System.debug('-----------------------');
        System.debug(cronTrigger.NextFireTime);
        System.debug(cronTrigger.CronExpression);
        
        System.assertEquals('0 0 0 1 7 ? *', cronTrigger.CronExpression);
    }
}