trigger updateAccountIndutry on Account (after update) {
    if (Trigger.isAfter && Trigger.isUpdate && apexRecursiveHandler.isFirstRun) {
        apexRecursiveHandler.isFirstRun = false;
        Set<Id> accIds = new Set<Id>();
        Map<Id, String> accIndMap = new Map<Id, String>();

        for (Account acc : Trigger.new) {
            Account oldAcc = Trigger.oldMap.get(acc.Id);
            if (acc.Industry != oldAcc.Industry) {
                accIds.add(acc.Id);
                accIndMap.put(acc.Id, acc.Industry);
            }
        }

        if (!accIds.isEmpty()) {
            List<Contact> conList = [SELECT Id, AccountId FROM Contact WHERE AccountId IN :accIds];
            for (Contact con : conList) {
                con.Description = accIndMap.get(con.AccountId);
            }
            if (!conList.isEmpty()) update conList;
        }
    }
}