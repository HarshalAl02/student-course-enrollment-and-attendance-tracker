@isTest
private class ErrorLoggerTest {
    @isTest static void testLogCreatesRecord() {
        Test.startTest();
        try {
            Integer i = 1 / 0;
        } catch (Exception ex) {
            ErrorLogger.log(ex, 'UnitTestContext', null);
        }
        Test.stopTest();

        List<Error_Log__c> logs = [
            SELECT Id, Context__c, Exception_Message__c
            FROM Error_Log__c
            WHERE Context__c = 'UnitTestContext'
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];
        System.assert(!logs.isEmpty(), 'Error log should have been created.');
        System.assertEquals('UnitTestContext', logs[0].Context__c);
    }
}