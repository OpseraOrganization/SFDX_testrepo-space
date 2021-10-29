/**
 * Created by Satya Mohanty on 11/21/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
@isTest
public class sObjectLookupControllerTest{
    static testMethod void testMethodOne() {
        Account objAccount = new Account();
        objAccount.Name = 'Test';
        Insert objAccount;

        List<string> lstExtraFields = new List<string>();
        lstExtraFields.add('Phone');

        List<string> lstWhere = new List<string>();
        //lstWhere.add('Id != Null');

        //LookupController.search('Account', 'test',lstWhere,lstExtraFields);
        //LookupController.getRecentlyViewed('Account',lstWhere, lstExtraFields);
        test.startTest();
        sObjectLookupController.searchRecord('Account','Phone',lstWhere,'name',2);
        test.stopTest();
    }

}