/*
*File Name :updateContactToolAccess
*Description :Purpose of this Trigger is updating Contact Tool Access Row when administrator Approve/denied the Case
*Company : Honeywell
*/
/**********************************Change Log***********************************
SR#404095 
Description: Delete the Web Portal Contact Tool Access record for the case if it gets cancelled.
Test class - updateContactToolAccess_Test
SR#432896
Description:Update the SFDC Workflow so that a Web Portal Registration Cases will only update the Contact’s 
‘Web Portal Contact Tool Access’ object when the Case status is “Open”, “Approved”, or “Denied”.
********************************************************************************/
trigger updateContactToolAccess on Case (after update){
    /*commenting inactive trigger code to improve code coverage-----
    try{
        List<Case> lstCases=Trigger.new;
        //List<Contact_Tool_Access__c> listDeleteCTA = new List<Contact_Tool_Access__c>();
        DateTime currDate = System.Now();
        System.debug('lstCntToolAccess1======== ');
          if(lstCases.get(0)!=null){
        System.debug('lstCntToolAccess2======== ');
            if(lstCases.get(0).Type =='WEB Portal Registration'){
        System.debug('lstCntToolAccess3======== ');            
                List<Portal_Tools_Master__c> toolMaster=[select id from Portal_Tools_Master__c where name=:lstCases.get(0).Tool_Name__c];
                List<Contact> contacts=[select id,Is_Portal_Super_User__c from contact where id=:lstCases.get(0).ContactId];
                List<Contact_Tool_Access__c> lstCntToolAccess=[select name,CRM_Contact_ID__c,Portal_Tool_Master__c,Request_Status__c, CreatedById from Contact_Tool_Access__c where CRM_Contact_ID__c=:contacts.get(0).id and Portal_Tool_Master__c=:toolMaster.get(0).id];
                System.debug('lstCntToolAccess4======== '+lstCntToolAccess);
                for(Contact_Tool_Access__c current:lstCntToolAccess){
                        System.debug('lstCntToolAccess5======== ');
                    if(lstCases.get(0).Status=='Open'){
                        current.Request_Status__c='Pending';
                        if(lstCases.get(0).Tool_Name__c.trim()=='Company Administrator'){
                            contacts.get(0).Is_Portal_Super_User__c=false;
                        }

                    }else{
                        if(lstCases.get(0).Status == 'Approved' ){
                            current.Access_Granted_Date__c=currDate;

                        }
                        /**
                        //SR#404095
                        else if(lstCases.get(0).Status=='Cancelled'){ 
                            if(current.CreatedById == Label.API_User_MyAerospace_Portal)
                                listDeleteCTA.add(current);
                            //system.debug('listDeleteCTA ' + listDeleteCTA);
                        }//End SR#404095
                      
                      // SR#432896
                       if(lstCases.get(0).Status=='Open' || lstCases.get(0).Status=='Approved' || lstCases.get(0).Status=='Denied') 
                        current.Request_Status__c=lstCases.get(0).Status;
                        if(lstCases.get(0).Tool_Name__c.trim()=='Company Administrator' && lstCases.get(0).Status=='Denied'){
                            contacts.get(0).Is_Portal_Super_User__c=false;
                        }else if(lstCases.get(0).Tool_Name__c.trim()=='Company Administrator' && lstCases.get(0).Status=='Approved'){ 
                            contacts.get(0).Is_Portal_Super_User__c=true;
                        }
                    }
                }  
              /**   
                 //SR#404095
                if(listDeleteCTA.size()>0){
                    delete listDeleteCTA;
                }// End SR#404095
                
                if(lstCntToolAccess!=null && lstCntToolAccess.size()>0){
                    Database.update(lstCntToolAccess); 
                }
                if(contacts!=null && contacts.size()>0){
                    Database.update(contacts); 
                }
                
                    
            }
        }
    }
    catch(Exception e){
    System.debug('Exception occured '+e);
    }
*/
}
/*
select id,(select Portal_Tool_Master__c,Request_Status__c from Contact_Tool_Access__r   ) from contact where id in ('003e0000002lsP8','003e000000BKGDh' )
*/