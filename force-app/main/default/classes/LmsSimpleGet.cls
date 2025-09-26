public with sharing class LmsSimpleGet {

    @AuraEnabled
    public static String getCourses() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:LMS_Named_Cred/courses'); // relative path
        req.setMethod('GET');

        Http http = new Http();
        HttpResponse res = http.send(req);

        return res.getBody();
    }

}