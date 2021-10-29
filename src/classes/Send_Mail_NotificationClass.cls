public class Send_Mail_NotificationClass  {
@future public static void send_Mail_Notification(set<id> wdid,set<String> wdt)
{
    List<Workflow_details__c>wddata=new list<Workflow_details__c>();
    List<Workflow_Approval_History__c>appl=new list<Workflow_Approval_History__c>();
    List<Workflow_Notification_History__c>notl=new list<Workflow_Notification_History__c>();
    List<String> strToList =new List<String>();
    List<String> strListName= new List<String>();
    List<String> strListStatus = new List<String>();
    List<String> strListType =new List<String>();
    //set<id>wdid= new set<id>();
    //set<string>wdt= new set<string>();
    String wkflname ='';
    String link=label.Instance_Link;
    List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();
   
    wddata=[select id,Name, Atlas_or_P_DR__c,Opportunity_Number__c,Documentum__c,
    Customer_Name__c,Customer_SFDC_ID__c,Approval_status_for_Email_Template__c,Sales_K__c,X5_Year_Revenue_K__c,Front_End_Loss__c,
    Front_End_Loss_Max_Year__c,Exposed_Cost__c,Wokflow_Name__c,Exposed_Cost_Max_Year_K__c,ownerfullname__c,Opportunity_Lead_Owner__c,Approval_Level_in_Progress__c,
    Status__c,Opportunity_Name__c,OwnerEmail__c,Opportunity_Name_SFDC_ID__c,Opportunity_Namee__c,
(select id,Tier__c,Age__c,Workflow_Details__c,WorkFlow_Id__c,Atlas_or_P_DR_Number__c,Opportunity_Number__c,Documentum__c,
    Requester_s_Comments__c,Customer_Name__c,Customer_SFDC_ID__c,Sales_K__c,X5_Year_Revenue_K__c,Front_End_Loss__c,
    Front_End_Loss_Max_Year__c,Exposed_Cost__c,Exposed_Cost_Max_Year_K__c,ownerfullname__c,Opportunity_Lead_Owner__c,email__c,
    Approval_Status__c,Approver__c,Approver_Type__c,Workflow_Name__c ,Opportunity_Name__c,OwnerEmail__c,Opportunity_Name_SFDC_ID__c from WorkFlow_Approval_History__r where Tier__c IN:wdt),(select id,Workflow_Details__c,Email__c from Workflow_Notification_History__r) from Workflow_details__c where id IN:wdid];
   System.debug('Anu Testing1'+wddata); 
    for (Workflow_details__c wd1:wddata)
    {
        system.debug('AMMMMMINNNNNNN');
        //if (wd1.Status__c=='In progress')
       // {
            system.debug('INTO FIRST IF');
            appl.clear();
            notl.clear();
            appl.addAll(wd1.Workflow_Approval_History__r);
            System.debug('Anu Testing2'+wd1.Workflow_Approval_History__r);
            notl.addAll(wd1.Workflow_Notification_History__r);
            System.debug('Anu Testing3'+wd1.Workflow_Notification_History__r);
            if(notl.size()>0)
            {
                Integer count=0;
                strListName.clear();
                strListStatus.clear();
                strListType.clear();
                for(Workflow_Approval_History__c tempwdn:appl)
                {
                    system.debug('INNNNNN');
                    if(tempwdn.Tier__c==wd1.Approval_Level_in_Progress__c){
                        system.debug('8888888888');      
                        if(tempwdn.Approval_Status__c=='Pending Approval') 
                        {       
                        count=count+1;
                        system.debug('77777'+count);
                        }
                        strListName.add(tempwdn.approver__c);
                        strListStatus.add(tempwdn.Approval_Status__c);
                        strListType.add(tempwdn.Approver_Type__c);
                    }   ////if      
                }////////for
                wkflname = wd1.Name;
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();  
                String field1='';
                String field2='';
                String field3='';
                String field4='';
                String field5='';
                String field6='';
                String field7='';
                String field8='';
                String strTemp=''; 
                for(Integer i=0;i<strListName.size();i++)
                {
                    strTemp = strTemp + '<br>'+strListType[i]+' -- '+strListName[i]+' -- ' +strListStatus[i] ;
                }
                String htmlHeader  = '<html><head>'                                        
                +'<body><table>'                                         
                +'<h1 align="center"><font size="18" color="red" align ="center" family="Copper Black"></font> </h1>'                             +'<tr><hr width="800" color="red" height="25"/></tr>'; 
                String htmlbody='<p style="font-family:calibri;color:black;font-size:14.5px;">'
                +'Dear eGreensheet stakeholder,<br>' 
                +'An eGreensheet has been'+' '+wd1.Approval_status_for_Email_Template__c+' '+'for '+ wd1.Wokflow_Name__c +'</a>'+','+' '+' <a href="'+link+''+ wd1.Id +'">'+ wd1.Name+'</a>'
                +'<br>'
                +'This relates to Opportunity ';
                field1=htmlHeader+htmlbody;
                if(wd1.Opportunity_Number__c!=null)
                {
                    field1=htmlHeader+htmlbody+wd1.Opportunity_Number__c;
                }
                field2=field1+', ';
                if(wd1.Opportunity_Namee__c!=null)
                {
                    field2=field2+'<a href="'+link+''+wd1.Opportunity_Name_SFDC_ID__c+'">'+ wd1.Opportunity_Namee__c
 +'</a>';
                }
                field3=field2+' for '+'<a href="'+link+''+wd1.Customer_Name__c +'">' + wd1.Customer_SFDC_ID__c +'</a>'
                +'<br>The eGreensheet document can be read here: '
                +'<a href="'+ wd1.Documentum__c +'">' + wd1.Documentum__c  +'</a>'
                +'<br><br>'+'<i>'+'eGreensheet Approvers:'+'</i>'+'<i>'+strTemp+'</i>'
                +'<br>See current approval status at any time by accessing ' + '</a> '+ '<a href="'+link+''+ wd1.Id +'">'+ wd1.Name +'</a>'
                +'<br><br>* Sales (K$) - ' + '<b>'+wd1.Sales_K__c+'</b>'
                +';'+'&nbsp&nbsp'+
                +'5 Year Revenue (K$) - ' +'<b>'+ wd1.X5_Year_Revenue_K__c+'</b>'
                +'<br>' 
                +'* Front End Loss (K$) - ' + '<b>'+wd1.Front_End_Loss__c+'</b>'
                +';'+'&nbsp&nbsp'+  
                +'Front End Loss Max/Year (K$) - ' +'<b>'+wd1.Front_End_Loss_Max_Year__c+'</b>'
                +'<br>'
                +'* Exposed Cost (K$) - ' +'<b>'+wd1.Exposed_Cost__c+'</b>'
                +';'+'&nbsp&nbsp'+
                +'Exposed Cost Max/Year (K$) - '+'<b>'+wd1.Exposed_Cost_Max_Year_K__c+'</b>'
                +'<br><br>* Opportunity: ';
                if(wd1.Opportunity_Number__c!=null)
                {
                    field3=field3+wd1.Opportunity_Number__c;
                }
                field4=field3+', ';
                System.debug('Opp Line 114::::'+wd1.Opportunity_Namee__c);
                if(wd1.Opportunity_Namee__c!=null)
                {
                   System.debug('Opp Line 117::::'+wd1.Opportunity_Namee__c);
                    field4=field4+'<a href="'+link+''+wd1.Opportunity_Name_SFDC_ID__c+'">'+ wd1.Opportunity_Namee__c +'</a>';
                }
                System.debug('Opp Line 120::::'+field4);
                field5=field4+'<br>* Customer: '+'<a href="'+link+''+wd1.Customer_Name__c+'">' + wd1.Customer_SFDC_ID__c  +'</a>';
                field6=field5 +'<br><br>* Opportunity Owner - ';
                if(wd1.Opportunity_Lead_Owner__c!=null)
                {
                    field6=field6+wd1.Opportunity_Lead_Owner__c;
                }
                field7=field6+'<br>* Pricing Analyst - '+'<a href="mailto:'+wd1.OwnerEmail__c+'">'+wd1.ownerfullname__c +'</a>'
                +'<br><br>'
                +'<b><i>Need help with Salesforce.com or Documentum?</b></i>' 
                +'<b><a href="mailto:aeroapps.servicedesk@Honeywell.com">'+' '+'Contact Aero Application Service Desk</a></b>'
                +'<br>'+'Thank You!'+'</p>';
                OrgWideEmailAddress owa = [select id, Address, DisplayName from OrgWideEmailAddress where displayname like 'your%'] ;                            
    
                //List<string> strToAdd = new List<String>();
                //strToList.add('dhivya11.santhanakumar@nttdata.com');
                //strToList.add('akila.rajmahadev@nttdata.com');
                system.debug('6666666');
                for ( Workflow_Notification_History__c wn:notl)
                {
                    system.debug('9999999');
                    system.debug('3333333333'+notl.size());
                    strToList.add(wn.Email__c);  
                    system.debug('5555'+strToList);
                }   
    
                message.setHtmlBody(field7);
                message.setOrgWideEmailAddressId(owa.id);
                message.setToAddresses(strToList);
    
                if(count!=0 && count==appl.size())
                {
                    system.debug('hhhhhhh'+wd1.Opportunity_Namee__c);
                    system.debug('11111'+count);
                    system.debug('222222'+appl.size());
                    message.setSubject('FYI - eGreensheet initiated - '+ wd1.Customer_SFDC_ID__c+'');
                    bulkemails.add(message);
                }
                if(count==0 && appl.size()>0)
                {
                    system.debug('3333'+count);
                    system.debug('gggggg'+wd1.Opportunity_Namee__c);
                   // system.debug('hhhhh'+wd1.Customer_Name__r.Name);
                    message.setSubject('FYI - eGreensheet completed - '+ wd1.Customer_SFDC_ID__c+'');
                    bulkemails.add(message);
                }  
                system.debug(htmlbody);
                TriggerInactive.sendNotification = false;
            }
      
        //}///if status
    }///main for
    if(bulkEmails.size()>0)
        Messaging.sendEmail(bulkEmails);
    system.debug('PPPPPP mail sent'+bulkEmails.size());    
    }
}