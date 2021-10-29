/* Trigger to update Plant Code field based on the Plant Code Master field in Discretionary Line Item 
This trigger is created for the Certido ticket# 262436
Modification History  :
Date            Version No.     Modified by     Brief Description of Modification
02 Dec 2014     1.1             NTTDATA         INC000007060255-Avoid duplicate DLI entry with same plant code for same DR
*/
trigger DiscretionaryLineItem_UpdatePlantCode on Discretionary_Line_Item__c (before insert,before update) {

//Variable Declaration
List<Id> PlntCdeMstrId=new List<Id>();
list<id> DisReqstid= new list<id>();
List<Plant_Code_Del__c> PlntCdelist=new List<Plant_Code_Del__c>();
list<Discretionary__c>DisReqstlist=new list<Discretionary__c>();
set<id> drid = new set<id>();

//INC000007060255-Avoid duplicate DLI entry with same plant code for same DR - Start
List<Discretionary_Line_Item__c> dliList = new List<Discretionary_Line_Item__c>();
List<ID> DRIDlist =new List<ID>();
List<Discretionary__c> drlist = new List<Discretionary__c>();

//INC000007060255-Avoid duplicate DLI entry with same plant code for same DR - End

//fetching all te Plant code master ids
 for(Discretionary_Line_Item__c dli:trigger.new){
        drid.add(dli.Discretionary_Request__c);
    }
    
  if(drid.size()>0 && drid.size()!=null)
        drlist = [select Approval_Status__c,id,GBE__c,DR_Approver_ID__c, OpportunityName__c, Opportunity__r.Sales_Lead__r.Email, Opportunity__r.Owner.PS_Manager_Name__c,
         Opportunity__r.Owner.PS_Manager_EID__c, Opportunity__r.Owner.Email, Name, OwnerId,Type__c, CBT__c, SBU__c, Program__c,
          Account__r.Name, Total_Request_Amount_rollup__c, Engineering_lead_Contact__r.Name, CC_List__r.Name, Current_Approver__c, 
          Total_Approved_Amount__c, Owner__r.Name, Engineering_Lead_User__r.Name, Approver_EmailId__c, sr_number__c, 
          Program_key_code__c,  Current_UserManagerApprove_Email__c,Current_UserManagerApprove_Username__c,Service_request__c,
          CurrentUserManagerBackupEmail__c,Current_UserManagerBackup_Username_Formu__c from Discretionary__c where id IN:drid];   

for(Discretionary_Line_Item__c DiscNew : Trigger.new)
{
    for(Discretionary__c dr:drlist){
      if(dr.sr_number__c != null){
            DiscNew.Account_Opener_GTO__c = dr.Current_UserManagerApprove_Username__c;
            DiscNew.Account_Opener_Email__c = dr.Current_UserManagerApprove_Email__c; 
            DiscNew.Account_Opener_Backup_GTO__c = dr.Current_UserManagerBackup_Username_Formu__c;
            DiscNew.Account_Opener_Backup_Email__c = dr.CurrentUserManagerBackupEmail__c;
       }
    
    }
    if(Trigger.isinsert || (Trigger.isupdate && (Trigger.newMap.get(DiscNew .id).Plant_Code_Master__c!=Trigger.oldMap.get(DiscNew .id).Plant_Code_Master__c)))
        if(null != DiscNew.Plant_Code_Master__c ){
        PlntCdeMstrId.add(DiscNew.Plant_Code_Master__c);}
     if (discNew.Discretionary_Request__c!=null && (Trigger.isinsert || (Trigger.isupdate && (Trigger.newMap.get(DiscNew .id).Plant_Code_Master__c!=Trigger.oldMap.get(DiscNew .id).Plant_Code_Master__c))))     
        DRIDlist.add(DiscNew.Discretionary_Request__c);
  
}
system.debug('PlntCdeMstrId.isempty()'+PlntCdeMstrId.isempty() + ' '+PlntCdeMstrId);
//Querying the Plant code records with the specified plant code master id
if(null!=PlntCdeMstrId && PlntCdeMstrId.size()>0 )
    PlntCdelist=[Select Id,Plant_Code_Master__c,SBU__c,CBT__c from Plant_Code_Del__c where Plant_Code_Master__c in:PlntCdeMstrId];

//INC000007060255-Avoid duplicate DLI entry with same plant code for same DR - Start
//Get all the DLIs of the DRs in a list
if (null!= DRIDlist && DRIDlist.size()>0){
    dliList = [select id,Plant_Code_Master__c,Discretionary_Request__c from Discretionary_Line_Item__c where Discretionary_Request__c =: DRIDlist];    
}
//INC000007060255-Avoid duplicate DLI entry with same plant code for same DR - End

/* Update the Plant Code field */

for(Discretionary_Line_Item__c  Disc: Trigger.new)
   {
    
       for(integer i=0;i<PlntCdelist.size();i++)
         {
           if(Disc.Plant_Code_Master__c==PlntCdelist[i].Plant_Code_Master__c)
            {
              if(Disc.SBU__c==PlntCdelist[i].SBU__c && Disc.CBT__c==PlntCdelist[i].CBT__c)
               Disc.Plant_Code__c=PlntCdelist[i].id;
            }
        }
        //INC000007060255-Avoid duplicate DLI entry with same plant code for same DR - Start                
        for (integer j=0;j<dliList.size();j++) 
        {   
            if( Disc.Plant_Code_Master__c != null &&Disc.Discretionary_Request__c == dliList[j].Discretionary_Request__c && disc.id!=dliList[j].id && Disc.Plant_Code_Master__c == dliList[j].Plant_Code_Master__c )
            {
                IF(!TEST.isRunningTest()){
                    Disc.Plant_Code_Master__c.addError('DLI entry for the chosen Plant Code Master already exists in this Discretionary Request record. Make necessary updates to the same.');   
                }
            }
        } 
        //INC000007060255-Avoid duplicate DLI entry with same plant code for same DR - End
        
   }
}//end of the trigger