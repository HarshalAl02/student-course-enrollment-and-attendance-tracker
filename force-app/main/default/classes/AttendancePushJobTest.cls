@IsTest
private class AttendancePushJobTest {

    // Mock callout response
    class MockResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type','application/json');
            res.setBody('{"status":"ok","lmsId":"LMS123"}');
            res.setStatusCode(200);
            return res;
        }
    }

    @IsTest static void testAttendancePushTrigger() {

        // Step 1: Create Course (required for Enrollment)
        Course__c c = new Course__c(
            Name = 'Test Course'
        );
        insert c;

        // Step 2: Create Guardian
        Guardian__c g = new Guardian__c(
            First_Name__c = 'TestG',
            Last_Name__c = 'Guardian',
            Email__c = 'guardian' + String.valueOf(Math.round(Math.random()*1000000)) + '@example.com',
            Phone__c = '9999999999' // required
        );
        insert g;

        // Step 3: Create Student linked to Guardian
        Student__c s = new Student__c(
            First_Name__c = 'TestS',
            Last_Name__c = 'Student',
            Student_ID__c = 'S' + String.valueOf(Math.round(Math.random()*1000000)),
            Guardian__c = g.Id,
            Guardian_Contact__c = g.Phone__c // required field
        );
        insert s;

        // Step 4: Create Enrollment (must link to Course!)
        Enrollment__c e = new Enrollment__c(
            Student__c = s.Id,
            Course__c = c.Id, // link to course
            Enrollment_Date__c = Date.today(),
            Status__c = 'Enrolled'
        );
        insert e;

        // Step 5: Create Attendance
        Attendance__c a = new Attendance__c(
            Enrollment__c = e.Id,
            Date__c = Date.today(),
            Status__c = 'Present'
        );

        // Step 6: Set mock and insert Attendance (fires trigger & Queueable)
        Test.setMock(HttpCalloutMock.class, new MockResponse());
        Test.startTest();
            insert a;
        Test.stopTest();

        // Step 7: Verify Integration_Log__c
        Integration_Log__c[] logs = [SELECT Id, Status__c, Response_Body__c 
                                     FROM Integration_Log__c 
                                     ORDER BY CreatedDate DESC 
                                     LIMIT 1];

        System.assert(logs.size() > 0, 'Integration log should be created');
        System.assertEquals('200', logs[0].Status__c, 'Status should be 200 from mock response');
        System.assert(logs[0].Response_Body__c.contains('ok'), 'Response body should contain "ok"');
    }
}