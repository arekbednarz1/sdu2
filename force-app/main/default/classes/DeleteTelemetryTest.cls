/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 31/12/2021
 * @description Test class fo DeleteTelemetrySchedule class.
 */

@isTest
public class DeleteTelemetryTest {

    @isTest
    static void deleteOldTelemetry(){
        DateTime date4MonthAgo = DateTime.now().addDays(-121);

        Telemetry__c telemetry = new Telemetry__c(Name='TEST');
        insert telemetry;
        Test.setCreatedDate(telemetry.id, date4MonthAgo);
        List<Telemetry__c> telemetries = [SELECT Id FROM Telemetry__c];
        System.assert(telemetries.size()==1);
        
        Test.startTest();
        DeleteTelemetryOlderThan3Month deleteTelemetry = new DeleteTelemetryOlderThan3Month();
        Id batch = Database.executeBatch(deleteTelemetry);
        Test.stopTest();
        
        System.assert(batch != null);
        List<Telemetry__c> telemetryAfterDelete = [Select Id from Telemetry__c];
        System.debug(telemetryAfterDelete.size());
        System.assert(telemetryAfterDelete.size()==0); 
    }
}