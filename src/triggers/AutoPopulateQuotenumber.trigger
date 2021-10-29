/** File Name: AutoPopulateQuotenumber
*Description Trigger is to auto populate the quote number,account name,sales order number.
* 8/5/2014 - added code  for activity days past due date caliculation support
**@author : NTTData
**/ 
trigger AutoPopulateQuotenumber on Task (before insert, before update)
{
    Map<String,String> caseMap = new Map<String,String>();
    List<Case> listCase = new List<Case>();
    Set<Id> caseIds = new Set<Id>();
    Set<Id> caseIds1 = new Set<Id>();
        for (Task a : Trigger.new)
        {
        //start code for activity days past due date caliculation support//
        if(Trigger.isInsert || (Trigger.isUpdate && (Trigger.oldMap.get(a.id).activitydate != a.activitydate)))
        {
        a.Due_Date_Custom__c = a.activitydate;
        
        if(Trigger.IsInsert && a.Start_Date__c == null){
        a.Start_Date__c = System.now();
        }
        
        }
        if(Trigger.isInsert || (Trigger.isUpdate && (Trigger.oldMap.get(a.id).Description != a.Description))){
        if(a.Description != null && a.Description.Length() > 255)
        a.Comment_History__c = a.Description.left(252)+'...';
        else
        a.Comment_History__c = a.Description;
        }
        //IF(LEN(Description)>255,LEFT(Description,252)&"...",Description)
        
        //end code for activity days past due date caliculation support//
        
            caseIds.add(a.WhatId);
            //taskholdageupdate changes
            if (Trigger.IsInsert)
            {
                String parent=a.whatId;  
                if (parent!=null)
                {
                    parent=parent.substring(0,3);
                    if (parent=='500')
                    {  
                        system.debug('##case1');
                        caseIds1.add(a.Whatid);
                    }
                }                   
            }
            if(a.status == 'On Hold' && (Trigger.isinsert || (Trigger.isupdate && (Trigger.OldMap.get(a.Id).status != a.status))))
            {
                a.On_Hold_start_time__c = System.now();
            } 
            else if(Trigger.isupdate && a.status != 'On Hold' && Trigger.OldMap.get(a.Id).status != a.status && Trigger.OldMap.get(a.Id).status == 'On Hold')
            {
               a.On_Hold_time_temp__c = Trigger.OldMap.get(a.Id).Total_Cumulative_OnHold_Time__c;           
               a.On_Hold_start_time__c = null;
            }
        }
        try
        {
            listCase= [Select id,Account.Name,Sales_Order_Number__c,Origin,Quote_Number__c,Status from Case where id in:caseIds];
        }
        catch(QueryException e){}
        
        for(Case objCase: listCase)
        {
            if(!caseMap.containsKey(objCase.Id)  && objCase.AccountId != null)
                caseMap.put(objCase.Id,objCase.AccountId);
        }
        for(case c:listCase)
        {
            for (Task a : Trigger.new)
            {
                if(caseMap.containsKey(a.WhatId) && (a.PO_Quote_Number__c== null || a.Account_Name__c==null || a.SO_Number__c==null))
                {
                     a.PO_Quote_Number__c=c.Quote_Number__c;
                     a.Account_Name__c=c.Account.Name;
                     a.SO_Number__c=c.Sales_Order_Number__c;   
                }
                //Code changes for SR#400323 starts here
                if(Trigger.isinsert && a.RecordTypeId ==label.Task_Quote_Defects_Recordtype_Id)
                {
                    Datetime datecal;
                    Date duedate;
                    datecal = System.Now() + 2;
                    duedate = datecal.date();
                    a.ActivityDate = duedate;    
                } 
                //Code changes for SR#400323 ends here  
                
                if(caseIds1.size()>0)
                {
                    a.Case_Origin__c = c.Origin;
                }
                                            
            }           
        }
}