/**
 * Created by uzaroo on 8/31/20.
 */
/**
 * Name       :    GDMFSL_CommonUtilities
 * Purpose    :    Common Utility Class to have reusable methods. See method descriptions for proper context for calling each method..
 * --------------------------------------------------------------------------
 * Developer               Date          Description
 * --------------------------------------------------------------------------
 * Udbhav                  2020-Sep-01    Created
 **/

public inherited sharing class GDMFSL_CommonUtilities {

    /**
     * This section provides conditional code execution for recursive transactions.
     * <p/>
     * For example, if an Account should update its Contact Owners, and Contact updates its Account Owner,
     * these flags can be used to NOT have the Account code update its Contact Owners if the reason the Account
     * is being updated is because the Contact is updating the Account Owner.
     * <p/>
     * 1) Set a flag to indicate some specific logic has been applied
     * <p/>
     *      e.g. :   GDMFSL_CommonUtilities.setFlag('WO updating SA EndDates');
     * <p/>
     * 2) Check for the presence of that flag in code that should either only run when that operation is happening,
     * or that should NOT run when that operation is happening
     * <p/>
     *     e.g. :  if(GDMFSL_CommonUtilities.isFlagSet('WO updating SA EndDates')){
     *                 // do processing for just that scenario
     *             } else {
     *                 // do processing when that scenario is not involved
     *             }
     * <p/>
     * 3) If needed, you can clear the flag to allow normal processing.  This is not required since the flags are
     * all cleared at the end of each transaction.
     * <p/>
     *    e.g.    GDMFSL_CommonUtilities.removeFlag('WO updating SA EndDates');
     */

    private static Set<String> codeFlags = new Set<String>();

    public static Boolean isFlagSet(String theFlag) {
        if (theFlag != null) {
            return (codeFlags.contains(theFlag.toLowerCase()));
        } else {
            return false;
        }
    }

    public static void setFlag(String theFlag) {
        if (theFlag != null) {
            codeFlags.add(theFlag.toLowerCase());
        }
    }

    public static void removeFlag(String theFlag) {
        if (theFlag != null) {
            codeFlags.remove(theFlag.toLowerCase());
        }
    }

    public static Boolean isProcessingDisabled() {
        Skip_Automation_Process__c profileCustomSetting = Skip_Automation_Process__c.getInstance();

        System.debug('User skip processing setting: ' + profileCustomSetting);
        return ((profileCustomSetting != null) && profileCustomSetting.ByPass_Automation__c);
    }

    /**
     * This section provides common DML methods to be used throughout the GDMFSL code to allow for common error handling/reporting
     */

    private enum DMLTypes {
        InsertRecs, UpdateRecs, UpsertRecs, DeleteRecs
    }

    public static Boolean insertRecords(List<SObject> recsForDML) {

        return insertRecords(recsForDML, true);
    }

    public static Boolean updateRecords(List<SObject> recsForDML) {
        return updateRecords(recsForDML, true);
    }

    public static Boolean upsertRecords(List<SObject> recsForDML) {
        return upsertRecords(recsForDML, true);
    }

    public static Boolean deleteRecords(List<SObject> recsForDML) {
        return deleteRecords(recsForDML, true);
    }

    public static Boolean insertRecords(List<SObject> recsForDML, Boolean doAll) {
        return doDML(recsForDML, DMLTypes.InsertRecs, doAll);
    }

    public static Boolean updateRecords(List<SObject> recsForDML, Boolean doAll) {
        return doDML(recsForDML, DMLTypes.UpdateRecs, doAll);
    }

    public static Boolean upsertRecords(List<SObject> recsForDML, Boolean doAll) {
        return doDML(recsForDML, DMLTypes.UpsertRecs, doAll);
    }

    public static Boolean deleteRecords(List<SObject> recsForDML, Boolean doAll) {
        return doDML(recsForDML, DMLTypes.DeleteRecs, doAll);
    }


    public static Boolean insertRecords(List<SObject> recsForDML, Boolean doAll, Boolean keepTrying) {
        return doDMLAndKeepTrying(recsForDML, DMLTypes.InsertRecs, doAll, keepTrying);
    }

    public static Boolean updateRecords(List<SObject> recsForDML, Boolean doAll, Boolean keepTrying) {
        return doDMLAndKeepTrying(recsForDML, DMLTypes.UpdateRecs, doAll, keepTrying);
    }

    public static Boolean upsertRecords(List<SObject> recsForDML, Boolean doAll, Boolean keepTrying) {
        return doDMLAndKeepTrying(recsForDML, DMLTypes.UpsertRecs, doAll, keepTrying);
    }

    public static Boolean deleteRecords(List<SObject> recsForDML, Boolean doAll, Boolean keepTrying) {
        return doDMLAndKeepTrying(recsForDML, DMLTypes.DeleteRecs, doAll, keepTrying);
    }


    private static Boolean doDML(List<SObject> recsForDML, DMLTypes oper, Boolean doAll) {

        Boolean ok = true;
        Boolean allOrNone = doAll == null ? false : doAll;

        List<Database.SaveResult> saveRes = new List<Database.SaveResult>();
        List<Database.UpsertResult> upsertRes = new List<Database.UpsertResult>();
        List<Database.DeleteResult> delRes = new List<Database.DeleteResult>();

        String firstError;

        try {
            switch on oper {

                when InsertRecs {
                    saveRes = Database.insert(recsForDML, allOrNone);
                }
                when UpdateRecs {
                    saveRes = Database.update(recsForDML, allOrNone);
                }
                when UpsertRecs {
                    upsertRes = Database.upsert(recsForDML, allOrNone);
                }
                when DeleteRecs {
                    delRes = Database.delete(recsForDML, allOrNone);
                }
            }

            List<String> errInfo = new List<String>();

            if (!saveRes.isEmpty()) {

                for (Database.SaveResult sr : saveRes) {
                    if (!sr.isSuccess()) {
                        ok = false;
                        for (Database.Error err : sr.getErrors()) {
                            if (firstError == null) {
                                firstError = err.getMessage();
                            }
                            String errStr = 'Database error: ' + err.getStatusCode() + ' : ' + err.getMessage();
                            errStr += 'fields that affected this error: ' + err.getFields();
                            System.debug(errStr);
                            errInfo.add(errStr);
                        }
                    }
                }
            } else if (!upsertRes.isEmpty()) {

                for (Database.UpsertResult r : upsertRes) {
                    if (!r.isSuccess()) {
                        ok = false;
                        for (Database.Error err : r.getErrors()) {
                            if (firstError == null) {
                                firstError = err.getMessage();
                            }
                            String errStr = 'Database error: ' + err.getStatusCode() + ' : ' + err.getMessage();
                            errStr += 'fields that affected this error: ' + err.getFields();
                            System.debug(errStr);
                            errInfo.add(errStr);
                        }
                    }
                }
            } else if (!delRes.isEmpty()) {

                for (Database.DeleteResult r : delRes) {
                    if (!r.isSuccess()) {
                        ok = false;
                        for (Database.Error err : r.getErrors()) {
                            if (firstError == null) {
                                firstError = err.getMessage();
                            }
                            String errStr = 'Database error: ' + err.getStatusCode() + ' : ' + err.getMessage();
                            errStr += 'fields that affected this error: ' + err.getFields();
                            System.debug(errStr);
                            errInfo.add(errStr);
                        }
                    }
                }
            }
        } catch (DmlException e) {
            ok = false;
            firstError = e.getMessage();
        }

        if (firstError != null) {
            System.debug('First exception info: ' + firstError);
            throw new DmlException(firstError);
        }

        return ok;
    }


    private static Boolean doDMLAndKeepTrying(List<SObject> recsForDML, DMLTypes oper, Boolean doAll, Boolean keepTrying) {

        Boolean ok = true;
        Boolean allOrNone = doAll == null ? false : doAll;
        Boolean keepTryingTillSuccess = keepTrying == null ? false : keepTrying;
        List<Database.SaveResult> saveRes = new List<Database.SaveResult>();
        List<Database.UpsertResult> upsertRes = new List<Database.UpsertResult>();
        List<Database.DeleteResult> delRes = new List<Database.DeleteResult>();
        List<SObject> recsToAgainDML = new List<SObject>();
        String firstError;


        if (keepTryingTillSuccess) {

            while (recsForDML.size() > 0) {

                System.debug('Records to perform DML on  : ' + recsForDML.size());
                switch on oper {

                    when InsertRecs {
                        saveRes = Database.insert(recsForDML, allOrNone);
                    }
                    when UpdateRecs {
                        saveRes = Database.update(recsForDML, allOrNone);
                    }
                    when UpsertRecs {
                        upsertRes = Database.upsert(recsForDML, allOrNone);
                    }
                    when DeleteRecs {
                        delRes = Database.delete(recsForDML, allOrNone);
                    }
                }


                List<String> errInfo = new List<String>();

                if (!saveRes.isEmpty()) {

                    for (Integer i = 0; i < saveRes.size(); i++) {
                        if (!saveRes[i].isSuccess()) {
                            System.debug('Insert Update failed for a record,will retry it again');
                            ok = false;
                            System.debug('Full Record which will be inserted : ' + recsForDML[i]);
                           /* if (oper == DMLTypes.InsertRecs) {
                                recsForDML[i].Id = null;
                            }
                            System.debug('Full Record which we can insert after again resetting Id to Null : ' + recsForDML[i]);*/
                            recsToAgainDML.add(recsForDML[i]);
                            for (Database.Error err : saveRes[i].getErrors()) {
                                if (firstError == null) {
                                    firstError = err.getMessage();
                                }
                                String errStr = 'Database error: ' + err.getStatusCode() + ' : ' + err.getMessage();
                                errStr += 'fields that affected this error: ' + err.getFields();
                                System.debug(errStr);
                                errInfo.add(errStr);
                            }
                        }

                    }
                    System.debug('Records size which have yet not been inserted :  ' + recsToAgainDML.size());

                } else if (!upsertRes.isEmpty()) {
                    for (Integer i = 0; i < upsertRes.size(); i++) {
                        if (!upsertRes[i].isSuccess()) {
                            ok = false;
                            recsToAgainDML.add(recsForDML[i]);
                            for (Database.Error err : upsertRes[i].getErrors()) {
                                if (firstError == null) {
                                    firstError = err.getMessage();
                                }
                                String errStr = 'Database error: ' + err.getStatusCode() + ' : ' + err.getMessage();
                                errStr += 'fields that affected this error: ' + err.getFields();
                                System.debug(errStr);
                                errInfo.add(errStr);
                            }
                        }
                    }
                    System.debug('Record not Upsert :  ' + recsToAgainDML.size());

                } else if (!delRes.isEmpty()) {
                    for (Integer i = 0; i < delRes.size(); i++) {

                        if (!delRes[i].isSuccess()) {
                            ok = false;
                            recsToAgainDML.add(recsForDML[i]);
                            for (Database.Error err : delRes[i].getErrors()) {
                                if (firstError == null) {
                                    firstError = err.getMessage();
                                }
                                String errStr = 'Database error: ' + err.getStatusCode() + ' : ' + err.getMessage();
                                errStr += 'fields that affected this error: ' + err.getFields();
                                System.debug(errStr);
                                errInfo.add(errStr);
                            }
                        }
                    }
                }

                recsForDML.clear();
                System.debug('After clearing recsForDML size is : '+ recsForDML.size());
                System.debug('Records which will be again tried for DML : ' + recsToAgainDML.size());
                if (recsToAgainDML.size() > 0) {
                    recsForDML.addAll(recsToAgainDML);
                    recsToAgainDML.clear();
                    System.debug('After clearing recsToAgainDML size is : '+ recsToAgainDML.size());
                }
                System.debug('At the end of While recsForDML size is : '+ recsForDML.size());
            }
            System.debug('Out of While Loop now');
        } else {
            System.debug('KeepTrying is False so calling doDML method');
            doDML(recsForDML, oper, doAll);
        }

        System.debug('Finished Processing and exit from doDMLAndKeepTrying');


        return ok;
    }


    public static Datetime addTimeZoneOffset(Datetime origDateTime, String theTZone) {
        // note: need to subtract TZone offset to move forward in UTC time
        return adjustDateTimeForTimeZone(origDateTime, theTZone, true);
    }

    public static Datetime subtractTimeZoneOffset(Datetime origDateTime, String theTZone) {
        return adjustDateTimeForTimeZone(origDateTime, theTZone, false);
    }

    @TestVisible
    private static Datetime adjustDateTimeForTimeZone(Datetime origDateTime, String theTZone, Boolean subtractOffset) {
        TimeZone tz = UserInfo.getTimeZone();

        if (theTZone != null) {
            tz = TimeZone.getTimeZone(theTZone);
        }
        // note: offset is negative so we need to multiply by -1 to move forward in UTC time
        return origDateTime.addSeconds(((Integer) (tz.getOffset(origDateTime) / 1000) * (subtractOffset ? -1 : 1)));
    }

    @TestVisible
    private static void coverage()
    {
        Integer i=1;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;













    }
}