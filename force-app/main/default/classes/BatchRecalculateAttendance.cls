global class BatchRecalculateAttendance implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('Batch started...');
        return Database.getQueryLocator([SELECT Id FROM Student__c]);
    }

    global void execute(Database.BatchableContext bc, List<Student__c> scope) {
        System.debug('Processing students: ' + scope);

        Set<Id> studentIds = new Set<Id>();
        for (Student__c s : scope) studentIds.add(s.Id);

        List<Attendance__c> attList = [
            SELECT Id, Status__c, Enrollment__r.Student__c
            FROM Attendance__c
            WHERE Enrollment__r.Student__c IN :studentIds
        ];
        System.debug('Attendance records found: ' + attList.size());

        Map<Id, Integer> totalCount = new Map<Id, Integer>();
        Map<Id, Integer> presentCount = new Map<Id, Integer>();

        for (Attendance__c att : attList) {
            Id sid = att.Enrollment__r.Student__c;
            if (sid == null) continue;

            totalCount.put(sid, (totalCount.containsKey(sid) ? totalCount.get(sid) : 0) + 1);

            if (att.Status__c == 'Present') {
                presentCount.put(sid, (presentCount.containsKey(sid) ? presentCount.get(sid) : 0) + 1);
            }
        }

        List<Student__c> updates = new List<Student__c>();
        for (Id sid : studentIds) {
            Integer total = totalCount.containsKey(sid) ? totalCount.get(sid) : 0;
            Integer present = presentCount.containsKey(sid) ? presentCount.get(sid) : 0;
            Decimal percent = (total > 0) ? ((Decimal.valueOf(present) / Decimal.valueOf(total)) * 100).setScale(2) : 0;
            updates.add(new Student__c(Id = sid, Total_Attendance__c = percent));
            System.debug('Student ' + sid + ' attendance % = ' + percent);
        }

        if (!updates.isEmpty()) {
            update updates;
            System.debug('Updated ' + updates.size() + ' students');
        } else {
            System.debug('No students to update this scope');
        }
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('Attendance batch completed.');
    }
}