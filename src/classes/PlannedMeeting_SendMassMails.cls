/** * File Name: PlannedMeeting_SendMassMails
* Description Trigger to send emails to event coordinators when the status of the Planned Meeting is Approved
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 

public class PlannedMeeting_SendMassMails
{
public static void sendemail(List<Planned_Meeting__c> plist,List<id> eidlist)
{
List<Event_Team__c> et = new List<Event_Team__c> ();
List<Event__c> e = new List<EVent__C>();
if(plist.size()>0 && eidlist.size()>0)
{
 et = [select id,name,User__c,Contact__c,Email__c from Event_Team__c where Event__c =:eidlist[0] and Event_Coordinator_Flag__c=true];
 e= [select name from Event__c where id in : eidlist];
system.debug('Event team members***************'+et);
if(et.size()>0)
{
String[] toAddresses = new String[]{};
EmailTemplate emailTemplate;
List<ID> culist = new List<ID>();
List<ID> plmlist = new List<ID>();
for(Integer i=0;i<plist.size();i++)
{
plmlist.add(plist[i].id);
}
 toAddresses.add(plist[0].CreatedByEmail__c);
for(Integer i=0;i<et.size();i++)
        {
          
            toAddresses.add(et[i].Email__c);
           
            
        }  
  
        system.debug('toAddresses***************'+toAddresses); 
  //Code to send email through code            
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
 mail.setSubject('Meeting Approved:' + plist[0].name + ' on ' + plist[0].Start__c + ' to ' + plist[0].End__c );
         mail.setToAddresses(toAddresses);
     
            mail.setSaveAsActivity(false);
        system.debug('plist...........'+plist);  
Document d = [select body from document where DEVELOPERNAME = 'Honeywell_Logo'];
system.debug('Document Id'+d);
/*String str = '<img src= "https://tapp0.salesforce.com/"';*/
string serverUrl = URL.getSalesforceBaseUrl().toExternalForm() +'/';
String str = '<img src= " '+serverUrl+'"';
// mail.setHTMLBody( '<img src= "https://cs3.salesforce.com/081S00000008YlC" /> <br/><br/><font size=2.5 >The following meeting has been “Approved”: <br/><br/>Meeting Event: '   +  e[0].name +'<br/><br/> Meeting Name:  '+   plist[0].Name + '<br/> <br/>Meeting Date & Time: '+   plist[0].Start__c + ' to '+ plist[0].End__c+ '<br/><br/> Meeting Status:  '+   plist[0].Meeting_Status__c + '<br/><br/> Meeting Last Updated Date: '+   plist[0].LastModifiedDate + '<br/><br/> Meeting Last Updated by User Name:  '+plist[0].LastmodifiedByName__c + '<br/><br/> Meeting Owner (for add’l questions):'+plist[0].CreatedByName__c + '<br/><br/>  '+ '<br/><br/><a href=https://cs3.salesforce.com/'+ plist[0].Id+ '> Click Here to  View the Planned Meeting Details</a></font>' )  ;
    /*mail.setHTMLBody( str+d.body+' /> <br/><br/><font size=2.5 >The following meeting has been “Approved”: <br/><br/>Meeting Event: '   +  e[0].name +'<br/><br/> Meeting Name:  '+   plist[0].Name + '<br/> <br/>Meeting Date & Time: '+   plist[0].Start__c + ' to '+ plist[0].End__c+ '<br/><br/> Meeting Status:  '+   plist[0].Meeting_Status__c + '<br/><br/> Meeting Last Updated Date: '+   plist[0].LastModifiedDate + '<br/><br/> Meeting Last Updated by User Name:  '+plist[0].LastmodifiedByName__c + '<br/><br/> Meeting Owner (for add’l questions):'+plist[0].CreatedByName__c + '<br/><br/>  '+ '<br/><br/><a href=https://tapp0.salesforce.com/'+ plist[0].Id+ '> Click Here to  View the Planned Meeting Details</a></font>' )  ;*/     
    mail.setHTMLBody( str+d.body+' /> <br/><br/><font size=2.5 >The following meeting has been “Approved”: <br/><br/>Meeting Event: '   +  e[0].name +'<br/><br/> Meeting Name:  '+   plist[0].Name + '<br/> <br/>Meeting Date & Time: '+   plist[0].Start__c + ' to '+ plist[0].End__c+ '<br/><br/> Meeting Status:  '+   plist[0].Meeting_Status__c + '<br/><br/> Meeting Last Updated Date: '+   plist[0].LastModifiedDate + '<br/><br/> Meeting Last Updated by User Name:  '+plist[0].LastmodifiedByName__c + '<br/><br/> Meeting Owner (for add’l questions):'+plist[0].CreatedByName__c + '<br/><br/>  '+ '<br/><br/><a href='+serverUrl+ plist[0].Id+ '> Click Here to  View the Planned Meeting Details</a></font>' )  ;    
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        System.debug('Sent');
}
}
}
}