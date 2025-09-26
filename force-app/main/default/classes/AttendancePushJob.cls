public with sharing class AttendancePushJob implements Queueable, Database.AllowsCallouts {
    private Id attendanceId;
    public AttendancePushJob(Id attendanceId) {
        this.attendanceId = attendanceId;
    }

    public void execute(QueueableContext ctx) {
        
        Attendance__c a = [SELECT Id, Enrollment__c, Date__c, Status__c
                           FROM Attendance__c
                           WHERE Id = :attendanceId
                           LIMIT 1];

        
        Map<String, Object> payload = new Map<String, Object>{
            'enrollmentId' => a.Enrollment__c, 
            'date' => a.Date__c,
            'status' => a.Status__c,
            'attendanceId' => a.Id
        };
        String body = JSON.serialize(payload);

        // HTTP callout
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:LMS_Named_Cred/attendance');
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setBody(body);

        String responseBody;
        Integer statusCode = 0;
        String errorMessage;

        try {
            Http http = new Http();
            HttpResponse res = http.send(req);
            responseBody = res.getBody();
            statusCode = res.getStatusCode();
        } catch (Exception e) {
            responseBody = null;
            errorMessage = e.getMessage();
        }

        // Log integration attempt
        Integration_Log__c log = new Integration_Log__c(
            Direction__c = 'Outbound',
            Endpoint__c = req.getEndpoint(),
            Request_Body__c = body,
            Response_Body__c = responseBody,
            Status__c = statusCode == 0 ? 'ERROR' : String.valueOf(statusCode),
            Error_Message__c = errorMessage,
            Related_Record__c = a.Id
        );
        insert log;
    }
}