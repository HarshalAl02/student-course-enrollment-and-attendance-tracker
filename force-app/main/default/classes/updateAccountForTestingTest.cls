@isTest
public class updateAccountForTestingTest {
    @isTest
    public static void testUpdateAccount() {
        Account acc = new Account();
        acc.Name = 'Pramod';
        acc.Industry = 'Agriculture';
        insert acc;
        
        updateAccountForTesting.updateIndustry();
        
        Account updatedAcc = [
            SELECT Id, Name, Industry
            FROM Account
            WHERE Id = :acc.Id
        ];
        
        System.assertEquals('Education', updatedAcc.Industry);
    }
}