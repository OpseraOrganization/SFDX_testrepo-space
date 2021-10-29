/************************************************************************
Name            :   updateCPN
Created By      :   Shanthi
Company Name    :   NTTData
Created Date    :   01-JAN-2020
Usages          :   To Update CPN form after insertion of an attachment.
*************************************************************************/
public class updateCPN {
Public static void updateCheckAttachmentOnCPN(list<Attachment> lstAttachments){
              set<id> setCPNId  = new set<id>();
             list<Channel_Partner_Nomination__c> lstCPN = new list<Channel_Partner_Nomination__c>();
              for(Attachment Att:lstAttachments){
              system.debug('==========>'+att.ParentId.getSObjectType().getDescribe().getName());
              if(att.ParentId.getSObjectType().getDescribe().getName().equalsIgnoreCase('Channel_Partner_Nomination__c')){
                       setCPNId.add(att.ParentId);
                  }
                  system.debug('setCPNId is:'+ setCPNId);
                  if(!setCPNId.isEmpty()){
                  Channel_Partner_Nomination__c objCPN ;
                  for(id objid : setCPNId){
                    objCPN = new Channel_Partner_Nomination__c(id=objid);
                    objCPN.Check_Attachment__c = false;
                  
                    lstCPN.add(objCPN);
                   }
          }
          if(lstCPN!=null && lstCPN.size() > 0){
          update lstCPN;
          }
}
}
}