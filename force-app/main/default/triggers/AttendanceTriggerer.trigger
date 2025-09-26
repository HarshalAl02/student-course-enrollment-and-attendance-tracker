trigger AttendanceTriggerer on Attendance__c (after insert, after update) {
    List<Id> toEnqueue = new List<Id>();
    for (Attendance__c a : Trigger.new) {
        if (a.Status__c != null && a.Enrollment__c != null) { // only if status & enrollment exist
            toEnqueue.add(a.Id);
        }
    }
    for (Id aid : toEnqueue) {
        System.enqueueJob(new AttendancePushJob(aid));
    }
}