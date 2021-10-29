/** * File Name: OpportunityTeam_UpdatePrimaryManager
* Description Trigger to avoid duplicates for the Opportunity Team Members
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log ===============================================================
* 19/8/2010 - Modified query to limit the number of rows fetched so that list will have to hold only 1000 rows at a time
* 21/5/2013- Update for SR # 367308
Ver Date Author Modification --- ---- ------ -------------
* */

trigger OpportunityTeam_UpdatePrimaryManager  on Opportunity_Sales_Team__c (after delete,  after insert,after update) {
List<Id> oppList= new List<Id>();
List<Opportunity> oppListUpdate= new List<Opportunity>();
List<Opportunity_Sales_Team__c> oppTeamLt= new List<Opportunity_Sales_Team__c>();
String teamName;
//for insert and update
if (trigger.isInsert || trigger.isUpdate){
    for (Opportunity_Sales_Team__c oppTeamMember: Trigger.new){
        //if  program manager is present for updation
        if(trigger.isUpdate){
            system.debug('Team Role old value :'+System.Trigger.oldMap.get(oppTeamMember.Id).Opportunity_Team_Role__c);
            system.debug('Team Role new value :'+System.Trigger.NewMap.get(oppTeamMember.Id).Opportunity_Team_Role__c);
            if(System.Trigger.oldMap.get(oppTeamMember.Id).Opportunity_Team_Role__c!='Program Mgr' && System.Trigger.NewMap.get(oppTeamMember.Id).Opportunity_Team_Role__c=='Program Mgr')
                oppList.add(oppTeamMember.Opportunity__c);
            if(System.Trigger.oldMap.get(oppTeamMember.Id).Opportunity_Team_Role__c=='Program Mgr' && System.Trigger.NewMap.get(oppTeamMember.Id).Opportunity_Team_Role__c!='Program Mgr')
                oppList.add(oppTeamMember.Opportunity__c);
            //if Engineer is present for updation
            if(System.Trigger.oldMap.get(oppTeamMember.Id).Opportunity_Team_Role__c!='Engineering' && System.Trigger.NewMap.get(oppTeamMember.Id).Opportunity_Team_Role__c=='Engineering')
                oppList.add(oppTeamMember.Opportunity__c);
            if(System.Trigger.oldMap.get(oppTeamMember.Id).Opportunity_Team_Role__c=='Engineering' && System.Trigger.NewMap.get(oppTeamMember.Id).Opportunity_Team_Role__c!='Engineering')
                oppList.add(oppTeamMember.Opportunity__c);
            //if ISC is present for updation
            if(System.Trigger.oldMap.get(oppTeamMember.Id).Opportunity_Team_Role__c!='ISC' && System.Trigger.NewMap.get(oppTeamMember.Id).Opportunity_Team_Role__c=='ISC')
                oppList.add(oppTeamMember.Opportunity__c);
            if(System.Trigger.oldMap.get(oppTeamMember.Id).Opportunity_Team_Role__c=='ISC' && System.Trigger.NewMap.get(oppTeamMember.Id).Opportunity_Team_Role__c!='ISC')
                oppList.add(oppTeamMember.Opportunity__c);
            //if Pricing is present for updation
            if(System.Trigger.oldMap.get(oppTeamMember.Id).Opportunity_Team_Role__c!='Pricing' && System.Trigger.NewMap.get(oppTeamMember.Id).Opportunity_Team_Role__c=='Pricing')
                oppList.add(oppTeamMember.Opportunity__c);
            if(System.Trigger.oldMap.get(oppTeamMember.Id).Opportunity_Team_Role__c=='Pricing' && System.Trigger.NewMap.get(oppTeamMember.Id).Opportunity_Team_Role__c!='Pricing')
                oppList.add(oppTeamMember.Opportunity__c);
            //if Technical Sales is present for updation
            if(System.Trigger.oldMap.get(oppTeamMember.Id).Opportunity_Team_Role__c!='Technical Sales' && System.Trigger.NewMap.get(oppTeamMember.Id).Opportunity_Team_Role__c=='Technical Sales')
                oppList.add(oppTeamMember.Opportunity__c);
            if(System.Trigger.oldMap.get(oppTeamMember.Id).Opportunity_Team_Role__c=='Technical Sales' && System.Trigger.NewMap.get(oppTeamMember.Id).Opportunity_Team_Role__c!='Technical Sales')
                oppList.add(oppTeamMember.Opportunity__c);
            //Code Added for SR # 367308 Starts
            //if Tech Sales Secondary is present for updation
            if(System.Trigger.oldMap.get(oppTeamMember.Id).Opportunity_Team_Role__c!='Tech Sales Secondary' && System.Trigger.NewMap.get(oppTeamMember.Id).Opportunity_Team_Role__c=='Tech Sales Secondary')
                oppList.add(oppTeamMember.Opportunity__c);
            if(System.Trigger.oldMap.get(oppTeamMember.Id).Opportunity_Team_Role__c=='Tech Sales Secondary' && System.Trigger.NewMap.get(oppTeamMember.Id).Opportunity_Team_Role__c!='Tech Sales Secondary')
                oppList.add(oppTeamMember.Opportunity__c);
            //if Sales Lead is present for updation
            if(System.Trigger.oldMap.get(oppTeamMember.Id).Opportunity_Team_Role__c!='Sales Lead' && System.Trigger.NewMap.get(oppTeamMember.Id).Opportunity_Team_Role__c=='Sales Lead')
                oppList.add(oppTeamMember.Opportunity__c);
            if(System.Trigger.oldMap.get(oppTeamMember.Id).Opportunity_Team_Role__c=='Sales Lead' && System.Trigger.NewMap.get(oppTeamMember.Id).Opportunity_Team_Role__c!='Sales Lead')
                oppList.add(oppTeamMember.Opportunity__c);
            if(System.Trigger.oldMap.get(oppTeamMember.Id).Opportunity_Team_Role__c!='Co-Owner' && System.Trigger.NewMap.get(oppTeamMember.Id).Opportunity_Team_Role__c=='Co-Owner')
                oppList.add(oppTeamMember.Opportunity__c);
            if(System.Trigger.oldMap.get(oppTeamMember.Id).Opportunity_Team_Role__c=='Co-Owner' && System.Trigger.NewMap.get(oppTeamMember.Id).Opportunity_Team_Role__c!='Co-Owner')
                oppList.add(oppTeamMember.Opportunity__c);
            if(System.Trigger.oldMap.get(oppTeamMember.Id).Opportunity_Team_Role__c!='Co-Owner2' && System.Trigger.NewMap.get(oppTeamMember.Id).Opportunity_Team_Role__c=='Co-Owner2')
                oppList.add(oppTeamMember.Opportunity__c);
            if(System.Trigger.oldMap.get(oppTeamMember.Id).Opportunity_Team_Role__c=='Co-Owner2' && System.Trigger.NewMap.get(oppTeamMember.Id).Opportunity_Team_Role__c!='Co-Owner2')
                oppList.add(oppTeamMember.Opportunity__c);
            //Code Added for SR # 367308 Ends
        }
        //if  program manager is present for insertion
        if(trigger.isInsert){
            if(oppTeamMember.Opportunity_Team_Role__c=='Program Mgr')
                oppList.add(oppTeamMember.Opportunity__c);
            //if  Engineering is present for insertion
            if(oppTeamMember.Opportunity_Team_Role__c=='Engineering')
                oppList.add(oppTeamMember.Opportunity__c);
            //if  ISC is present for insertion
            if(oppTeamMember.Opportunity_Team_Role__c=='ISC')
                oppList.add(oppTeamMember.Opportunity__c);
            //if  Pricing is present for insertion
            if(oppTeamMember.Opportunity_Team_Role__c=='Pricing')
                oppList.add(oppTeamMember.Opportunity__c);
            //if  Technical Sales is present for insertion
            if(oppTeamMember.Opportunity_Team_Role__c=='Technical Sales')
                oppList.add(oppTeamMember.Opportunity__c);
            //Code Added for SR # 367308 Starts
            //if  Tech Sales Secondary is present for insertion
            if(oppTeamMember.Opportunity_Team_Role__c=='Tech Sales Secondary')
                oppList.add(oppTeamMember.Opportunity__c);
            //Code Added for SR # 367308 Ends
            //if  Sales Lead is present for insertion
            if(oppTeamMember.Opportunity_Team_Role__c=='Sales Lead')
                oppList.add(oppTeamMember.Opportunity__c);
            //if  Co-Owner is present for insertion
            if(oppTeamMember.Opportunity_Team_Role__c=='Co-Owner')
                oppList.add(oppTeamMember.Opportunity__c);
            if(oppTeamMember.Opportunity_Team_Role__c=='Co-Owner2')
                oppList.add(oppTeamMember.Opportunity__c);
        }
    }// end of for
}// end of if
//for deletion
if (Trigger.isDelete){
    for (Opportunity_Sales_Team__c oppTeamMembers: Trigger.old)    {
        //checking the records that are having the primary member ticked to be removed
        if(oppTeamMembers.Opportunity_Team_Role__c=='Program Mgr')
            oppList.add(oppTeamMembers.Opportunity__c);
        if(oppTeamMembers.Opportunity_Team_Role__c=='Engineering')
            oppList.add(oppTeamMembers.Opportunity__c);
        if(oppTeamMembers.Opportunity_Team_Role__c=='ISC')
            oppList.add(oppTeamMembers.Opportunity__c);
        if(oppTeamMembers.Opportunity_Team_Role__c=='Pricing')
            oppList.add(oppTeamMembers.Opportunity__c);
        if(oppTeamMembers.Opportunity_Team_Role__c=='Technical Sales')
            oppList.add(oppTeamMembers.Opportunity__c);
        //Code Added for SR # 367308 Starts
        if(oppTeamMembers.Opportunity_Team_Role__c=='Tech Sales Secondary')
            oppList.add(oppTeamMembers.Opportunity__c);
        //Code Added for SR # 367308 Ends
        if(oppTeamMembers.Opportunity_Team_Role__c=='Sales Lead')
            oppList.add(oppTeamMembers.Opportunity__c);
        if(oppTeamMembers.Opportunity_Team_Role__c=='Co-Owner')
            oppList.add(oppTeamMembers.Opportunity__c);
        if(oppTeamMembers.Opportunity_Team_Role__c=='Co-Owner2')
            oppList.add(oppTeamMembers.Opportunity__c);

    }  // end of for
}
system.debug('oppList values:'+oppList);
if(oppList.size()>0){
    oppListUpdate=[Select Id,Programme_Manager__c,Engineering__c,ISC__c,Pricing__c,Tech_Sales1__c,Tech_Sales2__c, Sales_Lead_Reporting__c,Co_Owner_Reporting__c from Opportunity where Id in :oppList];
    oppTeamLt=[Select Id,User__c,Team_Member_Full_Name__c,Opportunity__c,Opportunity_Team_Role__c  from Opportunity_Sales_Team__c  where Opportunity__c in
            :oppList and Opportunity_Team_Role__c in ('Engineering','Program Mgr','Pricing','ISC','Technical Sales','Tech Sales Secondary', 'Sales Lead', 'Co-Owner','Co-Owner2') order by createddate desc];
}


if(oppListUpdate.size()>0)
{
    for (integer i=0;i<oppListUpdate.size();i++){
        oppListUpdate[i].Engineering__c='';
        oppListUpdate[i].Programme_Manager__c='';
        oppListUpdate[i].Pricing__c='';
        oppListUpdate[i].ISC__c='';
        oppListUpdate[i].Tech_Sales1__c='';
        oppListUpdate[i].Tech_Sales2__c='';
        oppListUpdate[i].Sales_Lead_Reporting__c='';
        oppListUpdate[i].Co_Owner_Reporting__c='';
        oppListUpdate[i].Co_Owner__c=null;
        oppListUpdate[i].Co_Owner2_Reporting__c='';
        oppListUpdate[i].Co_Owner2__c=null;
        oppListUpdate[i].Sales_Lead__c=null;
    }
    if(oppListUpdate.size()>0)
        update oppListUpdate;
}

if(oppTeamLt!=null && oppTeamLt.size()>0)
{
    for (integer i=0;i<oppListUpdate.size();i++){
        for(integer j=0;j<oppTeamLt.size();j++){
            if(oppListUpdate[i].Id==oppTeamLt[j].Opportunity__c  ){
                if(oppTeamLt[j].Opportunity_Team_Role__c=='Engineering')
                    oppListUpdate[i].Engineering__c=oppTeamLt[j].Team_Member_Full_Name__c;

                if(oppTeamLt[j].Opportunity_Team_Role__c=='Program Mgr')
                    oppListUpdate[i].Programme_Manager__c=oppTeamLt[j].Team_Member_Full_Name__c;

                if(oppTeamLt[j].Opportunity_Team_Role__c=='Pricing')
                    oppListUpdate[i].Pricing__c=oppTeamLt[j].Team_Member_Full_Name__c;

                if(oppTeamLt[j].Opportunity_Team_Role__c=='ISC')
                    oppListUpdate[i].ISC__c=oppTeamLt[j].Team_Member_Full_Name__c;

                if(oppTeamLt[j].Opportunity_Team_Role__c=='Technical Sales')
                    oppListUpdate[i].Tech_Sales1__c=oppTeamLt[j].Team_Member_Full_Name__c;

                if(oppTeamLt[j].Opportunity_Team_Role__c=='Tech Sales Secondary')
                    oppListUpdate[i].Tech_Sales2__c=oppTeamLt[j].Team_Member_Full_Name__c;

                if(oppTeamLt[j].Opportunity_Team_Role__c=='Sales Lead'){
                    if(oppTeamLt[j].User__c != null){
                        oppListUpdate[i].Sales_Lead__c=oppTeamLt[j].User__c;
                    }
                    oppListUpdate[i].Sales_Lead_Reporting__c=oppTeamLt[j].Team_Member_Full_Name__c;
                }
                if(oppTeamLt[j].Opportunity_Team_Role__c=='Co-Owner'){
                    if(oppTeamLt[j].User__c != null){
                        oppListUpdate[i].Co_Owner__c=oppTeamLt[j].User__c;
                    }
                    oppListUpdate[i].Co_Owner_Reporting__c=oppTeamLt[j].Team_Member_Full_Name__c;
                }
                if(oppTeamLt[j].Opportunity_Team_Role__c=='Co-Owner2'){
                    if(oppTeamLt[j].User__c != null){
                        oppListUpdate[i].Co_Owner2__c=oppTeamLt[j].User__c;
                    }
                    oppListUpdate[i].Co_Owner2_Reporting__c=oppTeamLt[j].Team_Member_Full_Name__c;
                }
                system.debug('oppTeamLt[j].Opportunity_Team_Role__c value:'+oppTeamLt[j].Opportunity_Team_Role__c);
            }// end of if
        }// end of for
    }
    if(oppListUpdate.size()>0)
        update oppListUpdate;
}


}// end of trigger