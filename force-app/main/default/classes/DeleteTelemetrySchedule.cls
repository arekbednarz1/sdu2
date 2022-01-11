/**
 * @author Arkadiusz Bednarz <arkadiusz.bednarz@accenture.com>
 * @date 31/12/2021
 * @description Apex class that implements interface Database.Batchables.
 */
global class DeleteTelemetrySchedule implements Schedulable {
    global void execute(SchedulableContext sc){
        DeleteTelemetryOlderThan3Month deleteTelemetry = new DeleteTelemetryOlderThan3Month();
        Database.executeBatch(deleteTelemetry);
    }
}