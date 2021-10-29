trigger RandOFieldUpdates on Case (After insert){
/*commenting inactive trigger code to improve code coverage-----
 for(Case c: Trigger.New){
    if(c.Origin == 'Email-R&O MechComponents' && c.lastmodifiedby.Profile.Name !='SFDC Admin' 
        && c.Mail_Box_Name__c == 'Email-R&O MechComponents')      
     {
        Case objCase1 = new Case(id = c.id);
        objCase1.Government_Compliance_SM_M_Content__c = 'Undetermined';
        objCase1.Export_Compliance_Content_ITAR_EAR__c = 'Undetermined';
        objCase1.Origin = 'Email';
        objCase1.Classification__c = 'CSO Repair/Overhaul';
        objCase1.Ownerid = '00G30000002YnysEAC';
        objCase1.Type = 'Repair Inquiry';
        objCase1.Sub_class__c = 'Mech Components';
        update objCase1;
    }
     else if (c.Origin == 'Email-R&O Avionics' &&  c.lastmodifiedby.Profile.Name !='SFDC Admin' 
         && c.Mail_Box_Name__c == 'Email-R&O Avionics')
     {
        Case objCase = new Case(id = c.id);
        system.debug('&&&&&'+c.id);
        system.debug('&&&&&'+objCase.id);
        objCase.Government_Compliance_SM_M_Content__c = 'Undetermined';
        objCase.Export_Compliance_Content_ITAR_EAR__c = 'Undetermined';
        objCase.Ownerid = '00G30000002YnyT';
        objCase.Type = 'Repair Inquiry';
        update objCase;
    }
   }*/
}