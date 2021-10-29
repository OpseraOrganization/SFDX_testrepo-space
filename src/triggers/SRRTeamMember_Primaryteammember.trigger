/** * File Name: SRRTeamMember_Primaryteammember
* Description :To update the primary team member in  Service Recovery Report
* when any of Service Recovery Report Team Member is selected as primary
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger SRRTeamMember_Primaryteammember on Service_Recovery_Report_Team_Members__c (after delete,  before insert, before update) {
//declaring the variables
  Map<Id,Service_Recovery_Report_Team_Members__c>memberDetails=new Map<Id,Service_Recovery_Report_Team_Members__c>();
  List <Id>delRecords=new List <Id>();
  List <Service_Recovery_Report__c>serviceUpdateList=new List <Service_Recovery_Report__c> ();
  List <Service_Recovery_Report__c>serviceUpdateNew=new List <Service_Recovery_Report__c> ();
  List <Service_Recovery_Report__c>serviceUpdateDataList=new List <Service_Recovery_Report__c> ();
  List <Service_Recovery_Report_Team_Members__c>serviceMemUpdateList=new List <Service_Recovery_Report_Team_Members__c> ();
 Service_Recovery_Report__c serviceUpdate=null;
 //for insert and update
 if (trigger.isInsert || trigger.isUpdate)
  {
    for (Service_Recovery_Report_Team_Members__c serviceMember: Trigger.new)
    {
        //if  primary team member was made false
      if(trigger.isUpdate){
       if(System.Trigger.NewMap.get(serviceMember.Id).Is_Primary_Team_member__c ==false && System.Trigger.OldMap.get(serviceMember.Id).Is_Primary_Team_member__c==true)
          delRecords.add(serviceMember.Service_Recovery_Report__c);
          }
       //selecting the data having primary team member as true
         if(serviceMember.Is_Primary_Team_member__c==true ){
            if(memberDetails.containsKey(serviceMember.Service_Recovery_Report__c)){
              serviceMember.addError('Primary Member is already existing in the list');
            //duplicate records
            }
            else {
            // Keep the record in valid section
          memberDetails.put(serviceMember.Service_Recovery_Report__c,serviceMember);
          serviceMemUpdateList.add(serviceMember);
            }
        }   
    }
}
//for deletion
if (Trigger.isDelete)
  {  
    for (Service_Recovery_Report_Team_Members__c serviceDel: Trigger.old)    {
     //checking the records that are having the primary member ticked to be removed
      if (serviceDel.Is_Primary_Team_member__c){
          delRecords.add(serviceDel.Service_Recovery_Report__c);
          }    
    }  
}//end of delete trigger           
// for updating primary team member field
if (delRecords.size()>0){  
  for (Integer z=0 ;z<delRecords.size();z++){
          serviceUpdate=new Service_Recovery_Report__c(Id=delRecords[z]);
              serviceUpdate.Primary_Team_member__c = '';
              serviceUpdate.Primary_Contact__C=null;
          serviceUpdateList.add(serviceUpdate);
        }
        if (serviceUpdateList.size()>0)      {
        try
        {update serviceUpdateList;
        }
        catch (Exception e)
        {
          System.debug('Exception in Updating Service Recovery Report'+e);
        }
      }
  
  }
// if any records are there for primary member checkbox as true         
if (memberDetails.size()>0){      
serviceUpdateDataList=[Select Id,Primary_Team_member__c,Primary_Contact__c from Service_Recovery_Report__c where Id in :memberDetails.keyset()];
System.debug('&&&&&&&&&&&&&&&'+serviceUpdateDataList);

for(integer i=0;i<serviceUpdateDataList.size();i++){
      for(integer j=0;j<serviceMemUpdateList.size();j++){
      
     if( serviceUpdateDataList[i].Id==serviceMemUpdateList[j].Service_Recovery_Report__c ){
      
      //if already the service report has primary member updated
        if(serviceUpdateDataList[i].Primary_Contact__C!=null   ){
           if(serviceUpdateDataList[i].Primary_Contact__C==serviceMemUpdateList[j].Contact_Name__c){
           }
           else{
            serviceMemUpdateList[j].addError('A Primary Member already exists for this Service Recovery Report.');
           }
        }
          //if already the service report has primary member not updated
        else{
        serviceUpdateDataList[i].Primary_Contact__C=serviceMemUpdateList[j].Contact_Name__c;
        serviceUpdateNew.add(serviceUpdateDataList[i]);
        }
        
       } 
        
        
    }//end of for
 }// end of for         
  
//updating if any service recovery report is there for primary member updation
  if(serviceUpdateNew.size()>0)
  update serviceUpdateNew;         
}
}//end of trigger