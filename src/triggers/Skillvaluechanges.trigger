/** * File Name: BGArolecontactupdate
* Description :Trigger is used send email to contact email and contact manager when skill values add or change or delete.
* Copyright : NTTDATA Copyright (c) 2013 *
 * @author : NTTDATA
 * Modification Log =============================================================== **/
trigger Skillvaluechanges  on Skills2__c (after insert,after update,after delete) 
{   
    if (Trigger.Isupdate)
    {
        set<id> skillid=new set<id>(); 
        set<id> contactid=new set<id>();
        boolean bgacheck;
        String htmlBody2='';
        for (Skills2__c  skill : Trigger.new) 
        {
            if(Trigger.newMap.get(skill .id).Skill_Type__c!=Trigger.oldMap.get(skill .id).Skill_Type__c
            || Trigger.newMap.get(skill .id).Skill_Value_Comments__c!=Trigger.oldMap.get(skill .id).Skill_Value_Comments__c
            || Trigger.newMap.get(skill .id).Skill_Value__c!=Trigger.oldMap.get(skill .id).Skill_Value__c)
            {
                skillid.add(skill.id);
                system.debug('venkat11111---->'+skillid); 
                bgacheck=skill.BGA_Skill_Value_Change__c;              
                contactid.add(skill.Contact__c);                
            }
            if(Trigger.newMap.get(skill .id).Skill_Type__c!=Trigger.oldMap.get(skill .id).Skill_Type__c)
            {
                htmlBody2='<font  style="font-family:Times New Roman">&nbsp;&nbsp;&nbsp;&nbsp;o I changed Skill Type from</font> '+Trigger.newMap.get(skill .id).Skill_Type__c+'&nbsp;to&nbsp;'+Trigger.oldMap.get(skill .id).Skill_Type__c+'<br/>';                    
            }
            if(Trigger.newMap.get(skill .id).Skill_Value_Comments__c!=Trigger.oldMap.get(skill .id).Skill_Value_Comments__c)
            {
                htmlBody2+='<font  style="font-family:Times New Roman">&nbsp;&nbsp;&nbsp;&nbsp;o    I changed Skill Value Comments from</font> '+Trigger.newMap.get(skill .id).Skill_Value_Comments__c+'&nbsp;to&nbsp;'+Trigger.oldMap.get(skill .id).Skill_Value_Comments__c+'<br/>';                    
            }
            if(Trigger.newMap.get(skill .id).Skill_Value__c!=Trigger.oldMap.get(skill .id).Skill_Value__c)
            {
                htmlBody2+='<font  style="font-family:Times New Roman">&nbsp;&nbsp;&nbsp;&nbsp;o    I changed Skill Value from</font> '+Trigger.newMap.get(skill .id).Skill_Value__c+'&nbsp;to&nbsp;'+Trigger.oldMap.get(skill .id).Skill_Value__c+'<br/>';                    
            }                       
        } 
        if(skillid.size()>0 && bgacheck == true)
        {                
            system.debug('venkat22222---->'+skillid); 
            Skills2__c  skill1=[select id,name,BGA_Skill_Value_Change__c from skills2__c where id=:skillid];
            skill1.BGA_Skill_Value_Change__c =false;
            update skill1;
            contact con;
            if(contactid.size()>0)
            {           
                con=[select id,name,email,Mobile_App_Role__c,firstname,Employee_Manager_Name__c from contact where id=:contactid];
            }           
            //system.debug('venkat33333---->'+con.email);             
            if(con.email != null)
            {                                             
                if((con.Mobile_App_Role__c=='Customer Support Manager' || con.Mobile_App_Role__c=='Area Sales Manager' || con.Mobile_App_Role__c=='Field Service Engineer - Mechanical' || con.Mobile_App_Role__c=='Field Service Engineer - Electrical') )
                {
                    String htmlBody='';
                    String htmlBody1='<font  style="font-family:Times New Roman">&nbsp;&nbsp;&nbsp;&nbsp;o Email : <a href="aeroapps.servicedesk@honeywell.com">aeroapps.servicedesk@honeywell.com.</a><br/>&nbsp;&nbsp;&nbsp;&nbsp;o   Phone:  1-866-469-5237 (toll free US & Canada) / 781-350-1965 (International)<br/></font>';
                    htmlbody = '<font  style="font-family:Times New Roman">Dear </font>  ' +'<font  style="font-family:Times New Roman">'+con.firstname+'</font>'+','
                    +'<font  style="font-family:Times New Roman"><br/><br/>This email notification is to inform you that a change was made to your SFDC contact record information.  Please verify that the “Direct Access” app (directory for business aviation) contact information for you is updated correctly in SFDC.  Please refer to the following link for the impacted fields and process steps:  <a href="http://teamsites.honeywell.com/sites/eBizCCT/Documents for the Web Site/ICR WEB/Aero CRM Tips and Tricks/BGA Mobile Directory App - SFDC Data Management for FSEs_ASMs_CSMs.pptx">Direct Access - Contact Data Management</a></font><br/>'
                    +'<br/>'+htmlBody2
                    +'<font  style="font-family:Times New Roman"><br/>If you have questions, please contact the Aero Application Help Desk and request SFDC support.<br/></font>'
                    +htmlBody1
                    +'<font  style="font-family:Times New Roman"><br/><br/>Thank you!</></font>'
                    +'<font  style="font-family:Times New Roman"><br/><br/>Direct Access Quality Control</font>';   
                    
                    if(con.Employee_Manager_Name__c != null)
                    {
                        contact con1=[select id,name,email from contact where id=:con.Employee_Manager_Name__c ];               
                        if(con1.email != null)
                        {
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            String[] toAddresses = new String[] {con.email};                      
                            mail.setToAddresses(toAddresses);
                            String[] ccAddresses = new String[] {con1.email};  
                            mail.setCcAddresses(ccAddresses);
                            mail.setSubject('<font  style="font-family:Times New Roman">Direct Access App – Request to update SFDC Contact data</font>');
                            mail.setHtmlBody(htmlBody);
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
                        }
                    }
                    else
                    {
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        String[] toAddresses = new String[] {con.email};                      
                        mail.setToAddresses(toAddresses);
                        mail.setSubject('<font  style="font-family:Times New Roman">Direct Access App – Request to update SFDC Contact data</font>');
                        mail.setHtmlBody(htmlBody);
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
                    }
                }               
            }           
        }      
    }     
}