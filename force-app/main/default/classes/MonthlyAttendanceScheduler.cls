global class MonthlyAttendanceScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new BatchRecalculateAttendance(), 200);
    }
}