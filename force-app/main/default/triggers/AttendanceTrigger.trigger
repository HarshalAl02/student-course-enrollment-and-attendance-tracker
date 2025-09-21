trigger AttendanceTrigger on Attendance__c (after insert, after update, after delete) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) AttendanceTriggerHandler.afterChange(Trigger.new);
        if (Trigger.isUpdate) AttendanceTriggerHandler.afterChange(Trigger.new);
        if (Trigger.isDelete) AttendanceTriggerHandler.afterChange(Trigger.old);
    }
}