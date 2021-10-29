trigger CaseUpdateDefaultContact on Case (after insert) {
/*commenting inactive trigger code to improve code coverage-----
    List<Case> lstCases = Trigger.new;
    List<Contact> cont = new List<Contact>();
    List<Case> cs = new List<Case>();
    if(lstCases != NULL && lstCases.size() == 1 ){
        //String rt = [select Id from RecordType where Name = 'Customer Master Data' and SObjectType = 'Case'].Id;
        System.debug('Case Origin : '+lstCases[0].Origin);
        if(lstCases[0].ContactId == NULL && (lstCases[0].Origin == 'Email-SAP_CustomerMaster' || lstCases[0].Origin == 'Email-SFDC_CustomerMaster')){
            cont = [select Id , Name, AccountId from Contact where Name = 'Honeywell Default Contact'];
            cs = [select Id , ContactId, AccountId from Case where Id = :lstCases[0].Id];
            cs[0].ContactId = cont[0].Id;
            cs[0].AccountId = cont[0].AccountId;
            //System.debug('Contact : '+cont );
            //System.debug('Case : '+cs );
            update cs;
         }
     }*/
}