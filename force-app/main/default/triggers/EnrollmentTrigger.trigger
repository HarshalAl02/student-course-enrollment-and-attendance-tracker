trigger EnrollmentTrigger on Enrollment__c (after insert, after update, after delete) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) EnrollmentTriggerHandler.afterInsert(Trigger.new);
        if (Trigger.isUpdate) EnrollmentTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        if (Trigger.isDelete) EnrollmentTriggerHandler.afterDelete(Trigger.old);
    }
}