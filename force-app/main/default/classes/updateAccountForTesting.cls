public class updateAccountForTesting {
    public static void updateIndustry() {
        list<account> accountsToBeUpdated = new list<account>();
        list<account> accountlist = [select id,name,industry from account];
        for(account ac:accountlist) {
            ac.Industry='Education';
            accountsToBeUpdated.add(ac);
            
        }
        update accountsToBeUpdated;
    }
}