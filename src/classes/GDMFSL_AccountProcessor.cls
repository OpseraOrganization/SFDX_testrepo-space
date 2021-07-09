/*******************************************************************************************
Name       :    GDMFSL_AccountProcessor
Purpose    :    Business Logic for Account object . See method descriptions for proper context for calling each method
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Udbhav                  2020-Nov-05   Created
**********************************************************************************************/


public without sharing class GDMFSL_AccountProcessor {


    private static Map<Id, Account> theAccounts = new Map<Id, Account>();

    /**
    * Method to fetch Account
    *
    * @param recIds set  of AccountIds
    *
    * @return returns Map of Account Id and Account
    **/
    public static Map<Id, Account> getRecords(Set<Id> recIds) {


        if (recIds != null && !recIds.isEmpty()) {

            Set<Id> newRecIds = new Set<Id>();

            if (theAccounts.isEmpty()) {
                newRecIds.addAll(recIds);
            } else {
                for (Id thisRecId : recIds) {
                    if (!theAccounts.containsKey(thisRecId)) {
                        newRecIds.add(thisRecId);
                    }
                }
            }

            if (!newRecIds.isEmpty()) {

                Map<Id, Account> theRecs = new Map<Id, Account>([
                        SELECT Id,
                                SAP_Account_Types__c,
                                Region__c, (SELECT Id,Status,AppointmentNumber FROM ServiceAppointmentAccount)
                        FROM Account
                        WHERE Id IN :newRecIds

                ]);

                theAccounts.putAll(theRecs);
                System.debug('Retrieved Accounts: ' + theAccounts);
            }
        }

        return theAccounts;
    }


}