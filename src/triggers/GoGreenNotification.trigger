/** * File Name: GoGreenNotification
* Description :Trigger to send GGP Notification to CBM
* Copyright : NTTDATA 2015 *
 * @author : NTTDATA
 * Modification Log 
 Version    Date         Author         Modification 
 1.1        7/16/2015    NTTDATA        INC000008843002 - Notify only for GGP Account Owner 
 * */ 

trigger GoGreenNotification on Go_Green_Plan__c (after insert) {    
    set<id> ggpid=new set<id>();
    set<id> ggpaccid=new set<id>();
    string ggpname;
    String htmlBody='',htmlBody1='', ggpaccname;
    String[] toAddresses1;    
    
    List<Messaging.SingleEmailMessage> UFRbulkEmails = new List<Messaging.SingleEmailMessage>();  
    /*for(Go_Green_Plan__c ggp : Trigger.New){
        //INC000008436952---changes start
        if(ggp.Feedback_Record_Number__c != null && ggp.Account__c != null)        
        {
            ggpid.add(ggp.id);
            ggpaccid.add(ggp.Account__c);
            ggpname=ggp.name; 
        }
    }
    List<AccountTeamMember> atmlist = new List<AccountTeamMember>();   
    List<Messaging.SingleEmailMessage> UFRbulkEmails = new List<Messaging.SingleEmailMessage>();   
    if(ggpid.size()>0 && ggpaccid.size()>0)
    {
     Account a = [select id,ownerid,Owner.isactive,Name,Owner.email from Account where id=:ggpaccid];
     system.debug('---GGP'+a.Owner.isactive);
     ggpaccname = a.Name;
     if(a.Owner.isactive == true)
        toAddresses1 = new String[] {a.owner.email};          
     else
        toAddresses1 = new String[] {'michelle.dawn@honeywell.com'}; 
     system.debug('----GGP'+toAddresses1);  
     atmlist = [SELECT UserId,user.email,user.name,AccountId,account.name,TeamMemberRole FROM AccountTeamMember WHERE AccountId =:ggpaccid AND TeamMemberRole='Customer Business Manager (CBM)' limit 1];
        //List<Messaging.SingleEmailMessage> UFRbulkEmails = new List<Messaging.SingleEmailMessage>();                
        if(atmlist.size()>0)
        {              
            //Go_Green_Plan__c ggp1=[select id,name from Go_Green_Plan__c where id=:lstggp[0].id limit 1];
            for(AccountTeamMember atm:atmlist)
            {
                   htmlBody='<html><center ><table id="topTable" height="450" width="500" cellpadding="0" cellspacing="0" ><tr valign="top" ><td  style=" vertical-align:top; height:60; text-align:right; background-color:#FFFFFF; bLabel:header; bEditID:r1st1;"><img id="r1sp1" bLabel="headerImage" border="0" bEditID="r1sp1" src="https://c.na1.content.force.com/servlet/servlet.ImageServer?id=015300000018fo4&oid=00D30000000dWxY" ></img></td></tr><tr valign="top" ><td  style=" height:5; background-color:#FF0000; bLabel:accent1; bEditID:r2st1;"></td></tr><tr valign="top" ><td styleInsert="1" height="300"  style=" color:#000000; font-size:12pt; background-color:#FFFFFF; font-family:arial; bLabel:main; bEditID:r3st1;"><table height="400" width="550" cellpadding="5" border="0" cellspacing="5" ><tr height="400" valign="top" ><td style=" color:#000000; font-size:12pt; background-color:#FFFFFF; font-family:arial; bLabel:main; bEditID:r3st1;" tEditID="c1r1" locked="0" aEditID="c1r1" > Airbus survey results from '+atm.account.name+' indicate that they are dissatisfied with Honeywell for one or more attributes.  A Go Green Plan record has been created for you to use in identifying actions and results in addressing these red and yellow areas.<br><br>'+ggpname+'  has been assigned to you.  Please use the Deliverable Items section of the Go Green Plan to capture your actions.<br><br><br><br><br><br><br></td></tr></table></td></tr><tr valign="top" ><td  style=" height:5; background-color:#FF0000; bLabel:accent2; bEditID:r4st1;"></td></tr><tr valign="top" ><td  style=" vertical-align:top; height:60; text-align:left; background-color:#FFFFFF; bLabel:footer; bEditID:r5st1;"></td></tr><tr valign="top" ><td  style=" height:5; background-color:#FF0000; bLabel:accent3; bEditID:r6st1;"></td></tr></table></center></html>';
                   
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {atm.user.email};          
                mail.setToAddresses(toAddresses);               
                mail.setSubject('Actions Required for '+ atm.account.name +' Airbus Survey');
                mail.setHtmlBody(htmlBody);
                UFRbulkEmails.add(mail);
            }
        }
        */
        // added code by hari
        system.debug('----GGP');
        for(Go_Green_Plan__c ggp : Trigger.New){            
            if( ggp.Account__c != null)        
            {
                //ggpid.add(ggp.id);
                ggpaccid.add(ggp.Account__c);
                //ggpname=ggp.name; 
            }
        }
         MAp<id,Account> mapAcc = new Map<id,Account>();
        if( ggpaccid.size()>0)
        {
           
            mapAcc = new Map<id,Account>([select id,ownerid,Owner.isactive,Name,Owner.email,owner.name from Account where id in:ggpaccid]);
            system.debug('Account size'+mapAcc.size());
        }
        
        Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
        for(Go_Green_Plan__c ggp : Trigger.New){           
                if(ggp.Account__c!=null && mapAcc.get(ggp.Account__c) !=null
                    && mapAcc.get(ggp.Account__c).Owner != null && mapAcc.get(ggp.Account__c).Owner.isactive == true
                    && !((mapAcc.get(ggp.Account__c).owner.name).contains('API User'))){                    
                    toAddresses1 = new String[] {mapAcc.get(ggp.Account__c).Owner.email};          
                }else{
                    toAddresses1 = new String[] {label.APIUser_Account_Owner};
                }
                system.debug(ggp.Account__c);
                htmlBody1 = '<html><center ><table id="topTable" height="450" width="500" cellpadding="0" cellspacing="0" ><tr valign="top" ><td  style=" vertical-align:top; height:60; text-align:right; background-color:#FFFFFF; bLabel:header; bEditID:r1st1;"><img id="r1sp1" bLabel="headerImage" border="0" bEditID="r1sp1" src="https://c.cs23.content.force.com/servlet/servlet.ImageServer?id=015300000018fo4&oid=00D30000000dWxY" ></img></td></tr><tr valign="top" ><td  style=" height:5; background-color:#FF0000; bLabel:accent1; bEditID:r2st1;"></td></tr><tr valign="top" ><td styleInsert="1" height="300"  style=" color:#000000; font-size:12pt; background-color:#FFFFFF; font-family:arial; bLabel:main; bEditID:r3st1;"><table height="400" width="550" cellpadding="5" border="0" cellspacing="5" ><tr height="400" valign="top" ><td style=" color:#000000; font-size:12pt; background-color:#FFFFFF; font-family:arial; bLabel:main; bEditID:r3st1;" tEditID="c1r1" locked="0" aEditID="c1r1" >'+ ggp.SurveyType__C+' Survey results from '+mapAcc.get(ggp.account__C).name+' indicate that they are dissatisfied with Honeywell for one or more attributes. An ATR VOC Go Green Plan record has been created for you to use in identifying actions and results in addressing these red and yellow areas.<br><br> <a href="'+ggp.id+'">'+ggp.name+'</a> <br><br> The above GGP Number has been assigned to you. Please use the Deliverable Items section of the ATR VOC Go Green Plan to capture your actions.<br><br> Thank You!<br><br><br><br><br></td></tr></table></td></tr><tr valign="top" ><td  style=" height:5; background-color:#FF0000; bLabel:accent2; bEditID:r4st1;"></td></tr><tr valign="top" ><td  style=" vertical-align:top; height:60; text-align:left; background-color:#FFFFFF; bLabel:footer; bEditID:r5st1;"></td></tr><tr valign="top" ><td  style=" height:5; background-color:#FF0000; bLabel:accent3; bEditID:r6st1;"></td></tr></table></center></html>';
                mail1 = new Messaging.SingleEmailMessage();
                mail1.setToAddresses(toAddresses1);               
                mail1.setSubject('Actions Required for '+ mapAcc.get(ggp.Account__c).name+ ' '+ggp.SurveyType__c+' Survey');
                mail1.setHtmlBody(htmlBody1);
                UFRbulkEmails.add(mail1);
            
        }
        if(UFRbulkEmails.size()>0)
        {
            Messaging.sendEmail(UFRbulkEmails);            
        }           
    //}
 }