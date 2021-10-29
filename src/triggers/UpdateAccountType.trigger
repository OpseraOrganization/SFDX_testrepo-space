trigger UpdateAccountType on Contact_Tool_Access__c (After Insert) {
    /*Commenting Code for no longer being used
    set<id> ctaid = new set<id>();
    List<Contact_Tool_Access__c> ctalist = new List<Contact_Tool_Access__c>();
    List<Contact_Tool_Access__c> ctalistupdate = new List<Contact_Tool_Access__c>();
    for(Contact_Tool_Access__c cta:Trigger.new){
        ctaid.add(cta.id);
    }
    if(ctaid.size()>0){
        ctalist = [select id,Name,CRM_Contact_ID__c,CRM_Contact_ID__r.Account.Type,Account_Name__c,MyMaintainer_Roles__c,Portal_Tool_Master__c from Contact_Tool_Access__c where id =:ctaid and Name =:'Fault Analyser Services (MyMaintainer)' and Portal_Tool_Master__c=:label.MyMaintainer_Tool_ID];
    }
    if(ctalist.size()>0){
        for(Contact_Tool_Access__c ct:ctalist){
            if(ct.CRM_Contact_ID__r.Account.Type == 'Honeywell')
                ct.MyMaintainer_Roles__c = 'Honeywell Admin';
            else if(ct.CRM_Contact_ID__r.Account.Type == 'Owner/Operator')
                ct.MyMaintainer_Roles__c = 'Operator Admin';
            else if(ct.CRM_Contact_ID__r.Account.Type == 'OEM')
                ct.MyMaintainer_Roles__c = 'OEM Admin';
            else if(ct.CRM_Contact_ID__r.Account.Type == 'Service Center')
                ct.MyMaintainer_Roles__c = 'Operator Admin';
            else if(ct.CRM_Contact_ID__r.Account.Type == 'Repair Shop')
                ct.MyMaintainer_Roles__c = 'Operator Admin';
            else if(ct.CRM_Contact_ID__r.Account.Type == 'Commercial Airline')
                ct.MyMaintainer_Roles__c = 'Operator Admin';
            ctalistupdate.add(ct);
        }
        if(ctalistupdate.size()>0){
            try{
                Update ctalistupdate;
            }Catch(DMLException e){
                system.debug('Exception occures Contact Tool---->'+e);
            }
        }
    }*/
}