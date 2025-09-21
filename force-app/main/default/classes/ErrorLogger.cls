public with sharing class ErrorLogger {
    public static void log(Exception ex, String context, Id relatedId) {
        try {
            if (ex == null) return;

            Error_Log__c logRec = new Error_Log__c();

            if (context != null && context.length() > 255) {
                logRec.Context__c = context.substring(0, 255);
            } else {
                logRec.Context__c = context;
            }

            String msg = ex.getMessage();
            if (msg != null && msg.length() > 32000) msg = msg.substring(0, 32000);
            logRec.Exception_Message__c = msg;

            String stack = ex.getStackTraceString();
            if (stack != null && stack.length() > 32000) stack = stack.substring(0, 32000);
            logRec.Stack_Trace__c = stack;

            if (relatedId != null) logRec.Related_Record_Id__c = String.valueOf(relatedId);

            insert logRec;
        } catch (Exception loggingEx) {
            System.debug('ERROR LOGGER FAILED: ' + loggingEx.getMessage());
            if (ex != null) System.debug('Original Exception: ' + ex.getMessage());
        }
    }
}