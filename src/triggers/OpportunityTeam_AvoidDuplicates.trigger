/*** File Name: OpportunityTeam_AvoidDuplicates
* Description Trigger to avoid duplicates for the Opportunity Team Members 
* Modification Log =============================================================== 
* 19/8/2010 - Modified query to limit the number of rows fetched so that list will have to hold only 1000 rows at a time
* Apr 18, 2019 - SCTASK1943581: Changes made to give exception for Sales Administrator profile for updating Push User Functional Role
***/ 
//////////////////////////Change Log//////////////////////////////
//SR#437524 - To populate the Opportunity Team Role for all Opportunity Team Records
//////////////////////////////////////////////////////////////////
trigger OpportunityTeam_AvoidDuplicates on Opportunity_Sales_Team__c (before insert,before update)
{
    String prof = Userinfo.getProfileId();
    String profname = [Select name from Profile where Id=:prof].name;
    profname = profname.tolowercase();

    Map<String, Opportunity_Sales_Team__c> campMap = new Map<String,Opportunity_Sales_Team__c>();
    Map<String, Opportunity_Sales_Team__c> campMap2 = new Map<String,Opportunity_Sales_Team__c>();

    Map<String, id> campMap1 = new Map<String,id>();  
    Map<String, String> campMapR = new Map<String,String>();  
    set<id> oppIdSet = new set<id>();
    for (Opportunity_Sales_Team__c ct : System.Trigger.New)
    {
        if(profname != 'sales admin' && profname != 'sales analyst' && profname != 'sales developer' && profname != 'System Administrator' && ct.Push_User_Functional_Role__c)
        {
            ct.Push_User_Functional_Role__c = false;
            ct.addError('Your profile don’t have access to change the User Functional Role.');
        }
        oppIdSet.add(ct.Opportunity__c);
        //Checking for User duplicate in the list of users to be loaded
        if ((ct.record_type_name__c !='BGA') && (ct.User__c !=null) && (System.Trigger.isInsert || (ct.User__c != System.Trigger.oldMap.get(ct.Id).User__c) || (ct.Opportunity_team_role__c != System.Trigger.oldMap.get(ct.Id).Opportunity_team_role__c))) 
        {
            if(ct.Opportunity__c == campMap1.get(ct.User__c)&& ct.Opportunity_team_role__c == campMapR.get(ct.User__c))
            {
                ct.User__c.addError('This User is already a Opportunity Team Member with this role');
            } 
            else
            {
                campMap.put(ct.User__c, ct);
                campMap2.put(ct.Opportunity__c, ct);
                campMap1.put(ct.User__c, ct.Opportunity__c);
                campMapR.put(ct.User__c, ct.Opportunity_team_role__c);
            }
        }
        //Checking for Contact duplicate in the list of Contacts to be loaded
        if ((ct.record_type_name__c !='BGA') && (ct.Contact__c !=null) && (System.Trigger.isInsert || (ct.Contact__c != System.Trigger.oldMap.get(ct.Id).Contact__c)|| (ct.Opportunity_team_role__c != System.Trigger.oldMap.get(ct.Id).Opportunity_team_role__c))) 
        {
            if(ct.Opportunity__c == campMap1.get(ct.Contact__c) && ct.Opportunity_team_role__c == campMapR.get(ct.Contact__c))
            {
                ct.Contact__c.addError('This Contact is already a Opportunity Team Member with this Role');
            }
            else
            {
                campMap.put(ct.Contact__c, ct);
                campMap2.put(ct.Opportunity__c, ct);
                campMap1.put(ct.Contact__c, ct.Opportunity__c);
                campMapR.put(ct.Contact__c, ct.Opportunity_team_role__c);
            }
        }
    }
    //Checking for User duplicate from the database
    for (Opportunity_Sales_Team__c ct : [SELECT Push_User_Functional_Role__c,User__c,Email_Formula__c,Opportunity__c, Opportunity_team_role__c FROM Opportunity_Sales_Team__c WHERE User__c IN :campMap.KeySet() and Opportunity__c IN :campMap2.KeySet() limit 1000])
    {
        if(Trigger.isUpdate){
            if(ct.Opportunity__c == campmap1.get(ct.User__c) && ct.Opportunity_team_role__c == campMapR.get(ct.User__c) && !ct.Push_User_Functional_Role__c)
            {
                Opportunity_Sales_Team__c newct=campMap.get(ct.User__c);
                newct.User__c.addError('This User is already an Opportunity Team Member');
            }
        }

        if(Trigger.isInsert){
            if(ct.Opportunity__c == campmap1.get(ct.User__c))
            {
                Opportunity_Sales_Team__c newct=campMap.get(ct.User__c);
                newct.User__c.addError('This User is already an Opportunity Team Member');
            }
        }
    }

    //Checking for Contact duplicate from the database
    for (Opportunity_Sales_Team__c ct : [SELECT Contact__c,Email_Formula__c,Opportunity__c, Opportunity_team_role__c FROM Opportunity_Sales_Team__c WHERE Contact__c IN :campMap.KeySet() and Opportunity__c IN :campMap2.KeySet() limit 1000 ])
    {
        if(ct.Opportunity__c == campmap1.get(ct.Contact__c) && ct.Opportunity_team_role__c == campMapR.get(ct.Contact__c))
        {
            Opportunity_Sales_Team__c newct=campMap.get(ct.Contact__c);
            newct.Contact__c.addError('This Contact is already an Opportunity Team Member with this Role');
        }
    }

    //////////////////////////SR#437524//////////////////////////////
    map<id,Opportunity> oppMap = new map<id,Opportunity>([select id,isClosed from Opportunity where id in :oppIdSet]);
    system.debug('oppMap value:'+oppMap);
    for (Opportunity_Sales_Team__c oppSalesTeam : System.Trigger.New)
    {
        if ((oppSalesTeam.record_type_name__c =='ATR' || oppSalesTeam.record_type_name__c =='D&S' || oppSalesTeam.record_type_name__c =='BGA') && (oppSalesTeam.User__c !=null))
        {
            if(oppSalesTeam.Functional_Role__c!= null && (oppSalesTeam.Opportunity_Team_Role__c == null || oppSalesTeam.Opportunity_Team_Role__c == '')){
                oppSalesTeam.Opportunity_Team_Role__c = oppSalesTeam.Functional_Role__c;
            }
    ///////////////////Added code for ticket# 185////////////////////////
            if(oppMap.get(oppSalesTeam.Opportunity__c) != null && !oppMap.get(oppSalesTeam.Opportunity__c).isClosed && oppSalesTeam.Functional_Role__c!= null){
                //Added logic to push the User Functional Role to User object.
                if(((profname == 'system administrator')||(profname == 'sales admin')||(profname == 'sales analyst')||(profname == 'sales developer')) && oppSalesTeam.Push_User_Functional_Role__c){
                    //Do nothing
                }else{
                    oppSalesTeam.Opportunity_Team_Role__c = oppSalesTeam.Functional_Role__c;
                }
            }               
        }else if((oppSalesTeam.record_type_name__c =='ATR' || oppSalesTeam.record_type_name__c =='D&S' || oppSalesTeam.record_type_name__c =='BGA') && (oppSalesTeam.contact__c !=null)){
            if(oppSalesTeam.Functional_Role__c!= null && (oppSalesTeam.Opportunity_Team_Role__c == null || oppSalesTeam.Opportunity_Team_Role__c == '')){
                oppSalesTeam.Opportunity_Team_Role__c = oppSalesTeam.Functional_Role__c;
            }
        }
    }
    //////////////////////////SR#437524///////////////////////////////
}