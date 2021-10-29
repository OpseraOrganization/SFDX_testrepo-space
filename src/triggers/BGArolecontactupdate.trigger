/** * File Name: BGArolecontactupdate
* Description :Trigger is used send email to contact email and contact manager
* Copyright : NTTDATA Copyright (c) 2013 *
 * @author : NTTDATA
 * Modification Log ===============================================================
 1.1         452372 / INC000005600780      Commented the code to send email notification to contact's manager.
 ==================================================================================*/
 
trigger BGArolecontactupdate  on contact (after insert,after update,after delete) 
{
    if (Trigger.Isupdate)
    {
        set<id> contactid=new set<id>();
        set<id> contactid1=new set<id>();
        set<id> contactid2=new set<id>();       
        String htmlBody2='';        
        for (contact  con : Trigger.new) 
        {
            
            if((con.Mobile_App_Role__c=='Customer Support Manager' || con.Mobile_App_Role__c=='Area Sales Manager' || con.Mobile_App_Role__c=='Field Service Engineer - Mechanical' || con.Mobile_App_Role__c=='Field Service Engineer - Electrical') )
            {                    
                if(Trigger.newMap.get(con.id).Job_Title__c!=Trigger.oldMap.get(con.id).Job_Title__c
                || Trigger.newMap.get(con.id).SBU_Contact__c!=Trigger.oldMap.get(con.id).SBU_Contact__c
                || (Trigger.newMap.get(con.id).Contact_Status__c!=Trigger.oldMap.get(con.id).Contact_Status__c 
                    && Trigger.newMap.get(con.id).Mobile_Directory_App__c==Trigger.oldMap.get(con.id).Mobile_Directory_App__c))
                {
                    contactid.add(con.id);                  
                }
                if(Trigger.newMap.get(con.id).Job_Title__c!=Trigger.oldMap.get(con.id).Job_Title__c)
                {
                    htmlBody2='<font  style="font-family:Times New Roman">&nbsp;&nbsp;&nbsp;&nbsp;o I changed Job Title from</font> '+Trigger.oldMap.get(con.id).Job_Title__c +'&nbsp;to&nbsp;'+Trigger.newMap.get(con.id).Job_Title__c+'<br/>';                    
                }
                if(Trigger.newMap.get(con.id).SBU_Contact__c!=Trigger.oldMap.get(con.id).SBU_Contact__c)
                {
                    htmlBody2+='<font  style="font-family:Times New Roman">&nbsp;&nbsp;&nbsp;&nbsp;o    I changed SBU from</font> '+Trigger.oldMap.get(con.id).SBU_Contact__c +'&nbsp;to&nbsp;'+Trigger.newMap.get(con.id).SBU_Contact__c+'<br/>'; 
                }
                if(Trigger.newMap.get(con.id).Contact_Status__c!=Trigger.oldMap.get(con.id).Contact_Status__c)
                {
                    htmlBody2+='<font  style="font-family:Times New Roman">&nbsp;&nbsp;&nbsp;&nbsp;o    I changed contact status from</font> '+Trigger.oldMap.get(con.id).Contact_Status__c +'&nbsp;to&nbsp;'+Trigger.newMap.get(con.id).Contact_Status__c+'<br/>'; 
                }
                if(Trigger.newMap.get(con.id).Contact_Status__c!=Trigger.oldMap.get(con.id).Contact_Status__c && Trigger.newMap.get(con.id).Contact_Status__c =='active')
                {
                    contactid1.add(con.id);
                }
                if(Trigger.newMap.get(con.id).Contact_Status__c!=Trigger.oldMap.get(con.id).Contact_Status__c && Trigger.newMap.get(con.id).Contact_Status__c =='inactive')
                {
                    contactid2.add(con.id);
                }               
            }           
        } 
        if(contactid.size()>0)
        {                
            contact c1=[select id,Mobile_Directory_App__c,name,email,firstname,Employee_Manager_Name__c from contact where id=:contactid];
            
            String htmlBody='';
            
            String htmlBody1='<font  style="font-family:Times New Roman">&nbsp;&nbsp;&nbsp;&nbsp;o Email : <a href="aeroapps.servicedesk@honeywell.com">aeroapps.servicedesk@honeywell.com.</a><br/>&nbsp;&nbsp;&nbsp;&nbsp;o   Phone:  1-866-469-5237 (toll free US & Canada) / 781-350-1965 (International)<br/></font>';
            htmlbody = '<font  style="font-family:Times New Roman">Dear </font>'+'<font  style="font-family:Times New Roman">'+c1.firstname+'</font>'+','
            +'<font  style="font-family:Times New Roman"><br/><br/>This email notification is to inform you that a change was made to your SFDC contact record information.&nbsp;&nbsp;Please verify that the “Direct Access” app (directory for business aviation) contact information for you is updated correctly in SFDC.&nbsp;&nbsp;Please refer to the corresponding Aerospace Guideline (AG-5673) for details:  <a href=" http://businesscontrols.honeywell.com/policies/Aerospace/Guidelines/AG-5673.htm"> http://businesscontrols.honeywell.com/policies/Aerospace/Guidelines/AG-5673.htm</a></font>.<br/>'
            +'<br/>'+htmlBody2
            +'<font  style="font-family:Times New Roman"><br/>If you have questions, please contact the Aero Application Help Desk and request SFDC support.<br/></font>'
            +htmlBody1
            +'<font  style="font-family:Times New Roman"><br/><br/>Thank you!</></font>'
            +'<font  style="font-family:Times New Roman"><br/><br/>Direct Access Quality Control</font>';  
            
            /* commented the Lines for SR 452372  - to remove email notification for Manager
            if(c1.Employee_Manager_Name__c != null)
            {                                   
                contact con1=[select id,name,email from contact where id=:c1.Employee_Manager_Name__c ];                
                if(con1.email != null)
                {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String[] toAddresses = new String[] {c1.email};                      
                    mail.setToAddresses(toAddresses);
                    String[] ccAddresses = new String[] {con1.email};  
                    mail.setCcAddresses(ccAddresses);
                    mail.setSubject('Direct Access App – Request to update SFDC Contact data');
                    mail.setHtmlBody(htmlBody);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
                }
            }
            else */
            If(c1.email != null)
            {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {c1.email};                      
                mail.setToAddresses(toAddresses);
                mail.setSubject('Direct Access App – Request to update SFDC Contact data');
                mail.setHtmlBody(htmlBody);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
            }
            if(contactid1.size()>0)
            {
                c1.Mobile_Directory_App__c=true;
                update c1;
            }
            if(contactid2.size()>0)
            {
                c1.Mobile_Directory_App__c=false;
                update c1;
            }           
        }       
    }
}