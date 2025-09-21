public with sharing class AttendanceTriggerHandler {
    public static void afterChange(List<Attendance__c> attList) {
        if(attList == null || attList.isEmpty()) return;

        try {
            Set<Id> enrollmentIds = new Set<Id>();
            for(Attendance__c a : attList) {
                if(a.Enrollment__c != null) enrollmentIds.add(a.Enrollment__c);
            }
            if(enrollmentIds.isEmpty()) return;

            Map<Id, Id> enrollmentToStudent = new Map<Id, Id>();
            for(Enrollment__c en : [SELECT Id, Student__c FROM Enrollment__c WHERE Id IN :enrollmentIds]) {
                if(en.Student__c != null) enrollmentToStudent.put(en.Id, en.Student__c);
            }
            if(enrollmentToStudent.isEmpty()) return;

            Set<Id> studentIds = new Set<Id>(enrollmentToStudent.values());

            // Query all Attendance for these students
            List<Attendance__c> allAttendances = [
                SELECT Id, Status__c, Enrollment__c
                FROM Attendance__c
                WHERE Enrollment__c IN :enrollmentIds
            ];

            // Count attendance per student
            Map<Id, Integer> totalCountMap = new Map<Id, Integer>();
            Map<Id, Integer> presentCountMap = new Map<Id, Integer>();

            for(Attendance__c att : allAttendances) {
                Id studentId = enrollmentToStudent.get(att.Enrollment__c);
                if(studentId == null) continue;

                totalCountMap.put(studentId, (totalCountMap.containsKey(studentId) ? totalCountMap.get(studentId) : 0) + 1);
                if(att.Status__c == 'Present') {
                    presentCountMap.put(studentId, (presentCountMap.containsKey(studentId) ? presentCountMap.get(studentId) : 0) + 1);
                }
            }

            // Update Students
            List<Student__c> studentsToUpdate = new List<Student__c>();
            for(Id sId : studentIds) {
                Integer total = totalCountMap.containsKey(sId) ? totalCountMap.get(sId) : 0;
                Integer present = presentCountMap.containsKey(sId) ? presentCountMap.get(sId) : 0;
                Decimal percent = (total > 0) ? (Decimal.valueOf(present) / Decimal.valueOf(total) * 100).setScale(2) : 0;
                studentsToUpdate.add(new Student__c(Id = sId, Total_Attendance__c = percent));
            }

            if(!studentsToUpdate.isEmpty()) update studentsToUpdate;

        } catch(Exception ex) {
            System.debug('Error in AttendanceTriggerHandler: ' + ex.getMessage());
        }
    }
}