public class LowAttendanceNotifier implements Queueable {
    private Set<Id> studentIds;

    public LowAttendanceNotifier(Set<Id> studentIds) {
        this.studentIds = studentIds;
    }

    public void execute(QueueableContext qc) {
        List<Student__c> studs = [
            SELECT Id, Name, Total_Attendance__c, Guardian__r.Email__c
            FROM Student__c
            WHERE Id IN :studentIds AND Total_Attendance__c < 75
        ];

        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for (Student__c s : studs) {
            if (s.Guardian__r != null && String.isNotBlank(s.Guardian__r.Email__c)) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[]{ s.Guardian__r.Email__c });
                mail.setSubject('Low Attendance Alert: ' + s.Name);
                mail.setPlainTextBody('Attendance for ' + s.Name + ' is below 75%. Please contact the school.');
                mails.add(mail);
            }
        }

        if (!mails.isEmpty()) Messaging.sendEmail(mails);
    }
}