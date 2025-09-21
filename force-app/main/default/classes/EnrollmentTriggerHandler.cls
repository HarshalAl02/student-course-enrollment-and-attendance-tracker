public with sharing class EnrollmentTriggerHandler {

    public static void afterInsert(List<Enrollment__c> newList) {
        updateStudentCourseCounts(newList);
    }

    public static void afterUpdate(List<Enrollment__c> newList, Map<Id, Enrollment__c> oldMap) {
        updateStudentCourseCounts(newList);
    }

    public static void afterDelete(List<Enrollment__c> oldList) {
        updateStudentCourseCounts(oldList);
    }

    private static void updateStudentCourseCounts(List<Enrollment__c> enrolls) {
        try {
            Set<Id> studentIds = new Set<Id>();
            for (Enrollment__c e : enrolls) {
                if (e.Student__c != null) studentIds.add(e.Student__c);
            }

            if (studentIds.isEmpty()) return;

            List<AggregateResult> aggs = [
                SELECT Student__c sId, COUNT(Id) cnt
                FROM Enrollment__c
                WHERE Student__c IN :studentIds AND Status__c = 'Active'
                GROUP BY Student__c
            ];

            for (AggregateResult ar : aggs) {
                Id sid = (Id) ar.get('sId');
                Integer cnt = (Integer) ar.get('cnt');
                System.debug('Student Id: ' + sid + ' has ' + cnt + ' active enrollments');
            }

        } catch (Exception ex) {
            ErrorLogger.log(ex, 'EnrollmentTriggerHandler.updateStudentCourseCounts', null);
            throw ex;
        }
    }
}