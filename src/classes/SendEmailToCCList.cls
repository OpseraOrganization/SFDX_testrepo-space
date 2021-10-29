// test class DiscretionaryLineItem_UpdtEmalFieldsTest //
public class SendEmailToCCList{

public void sendEmail(Discretionary_Line_Item__c dli){
       List<id> contactIds=new List<id>();
        //String plantCode='';
        //List<User> user=[select name from User where id=:dr.OwnerId];
        List<DR_CC_List_Junction_Object__c> drCCList=[select Id,Contact__c,Contact__r.Email from DR_CC_List_Junction_Object__c where Discretionary_Request__c=:dli.Discretionary_Request__c];
        for(DR_CC_List_Junction_Object__c drCC:drCCList){
            if(drCC.Contact__r.Email!=null && drCC.Contact__r.Email!=''){
                contactIds.add(drCC.Contact__r.id);
                }
        }
        
        List<DLI_Site_CC_List__c> dliSiteCCList=[select Id,Contact__c,Contact__r.Email from DLI_Site_CC_List__c where Discretionary_Line_Item__c=:dli.Id];
        for(DLI_Site_CC_List__c dliSiteCC:dliSiteCCList){
            if(dliSiteCC.Contact__r.Email!=null && dliSiteCC.Contact__r.Email!=''){
                contactIds.add(dliSiteCC.Contact__r.id);
             }
        }
        
       system.debug(contactIds+'contactIdsdebug');
       
        List<EmailTemplate> temp=[select id,name,HtmlValue from EmailTemplate where DeveloperName='Discretionary_Closed_Email' 
        or DeveloperName='Discretionary_Finished_Email'];
         List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();
       for (id  cid: contactIds){ 
        if(dli!=null && dli.Approval_Status__c!=null && dli.Approval_Status__c=='Close' && contactIds!=null && contactIds.size()>0 ){ 
          
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
            mail.setTargetObjectId(cid);
            mail.setTemplateId(temp[0].id);
            mail.setWhatId(dli.Id);
            mail.setOrgWideEmailAddressId('0D2300000008P9e');
            mail.setSaveAsActivity(false);
            bulkEmails.add(mail);
        }else {
        if(dli!=null && dli.Approval_Status__c!=null && dli.Approval_Status__c=='Open' && dli.Discretionary_Account__c!=null
         && contactIds!=null && contactIds.size()>0 ){       
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
            mail.setTargetObjectId(cid);
            mail.setTemplateId(temp[1].id);
            mail.setWhatId(dli.Id);
            mail.setOrgWideEmailAddressId('0D2300000008P9e');
            mail.setSaveAsActivity(false);
            bulkEmails.add(mail);
          }
        } 
      }
      system.debug(bulkEmails+'bulkEmailsdebug');
      if(bulkEmails.size()>0){
      Messaging.sendEmail( bulkEmails );
      }
    }
  
}