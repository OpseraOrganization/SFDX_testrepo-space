public with sharing class Send_MailClass  {
@future public static void send_Mail(set<id> wdid,set<id> whid)
{
list<Workflow_Approval_History__c>wahlist=new list<Workflow_Approval_History__c>();
//list<Workflow_Approval_History__c>wahdata=new list<Workflow_Approval_History__c>();
map<Workflow_Approval_History__c,list<Workflow_Approval_History__c>>wahmap= new map<Workflow_Approval_History__c,list<Workflow_Approval_History__c>>();
wahlist=[select id,Age__c,Workflow_Details__c,WorkFlow_Id__c,Atlas_or_P_DR_Number__c,Opportunity_Number__c,Documentum__c,
Requester_s_Comments__c,OPRO_Number__c,OPRO_Number_SFDC_ID__c,Customer_Name__c,Customer_SFDC_ID__c,Sales_K__c,X5_Year_Revenue_K__c,Front_End_Loss__c,
Front_End_Loss_Max_Year__c,Exposed_Cost__c,Exposed_Cost_Max_Year_K__c,Opportunity_Lead_Owner__c,email__c,
Approval_Status__c,Approver__c,Approver_Type__c,Workflow_Name__c,Summary__c,Opportunity_Name__c,Workflow_Details__r.Opportunity_Description__r.Name,Opportunity_Name_SFDC_ID__c ,OwnerEmail__c, ownerfullname__c from Workflow_Approval_History__c where Workflow_Details__c IN:wdid];
List<Workflow_Approval_History__c>tempid=new List<Workflow_Approval_History__c>();
list<Workflow_Approval_History__c>wahdata=new list<Workflow_Approval_History__c>();

wahdata=[select id,Age__c,Workflow_Details__c,WorkFlow_Id__c,Atlas_or_P_DR_Number__c,Opportunity_Number__c,Documentum__c,
Requester_s_Comments__c,OPRO_Number__c,OPRO_Number_SFDC_ID__c,Customer_Name__c,Customer_SFDC_ID__c,Sales_K__c,X5_Year_Revenue_K__c,Front_End_Loss__c,
Front_End_Loss_Max_Year__c,Exposed_Cost__c,Exposed_Cost_Max_Year_K__c,Opportunity_Lead_Owner__c,email__c,
Approval_Status__c,Approver__c,Approver_Type__c,Workflow_Name__c,Summary__c,Opportunity_Name__c,Workflow_Details__r.Opportunity_Description__r.Name,Opportunity_Name_SFDC_ID__c,OwnerEmail__c,  ownerfullname__c  from Workflow_Approval_History__c where Id IN:whid];
for(Workflow_Approval_History__c outerforWAH : wahdata)
{
    System.debug('Hello Testing');
    tempid=new List<Workflow_Approval_History__c>();
    System.debug('Hello Testing123'+(!wahmap.containskey(outerforWAH)));
    if((wahmap.size()==0) ||(!wahmap.containskey(outerforWAH)))
    {
        System.debug('Hello Testing456');
        for(Workflow_Approval_History__c innerforWAH: wahlist)
        {
            if(outerforWAH.Workflow_Details__c == innerforWAH.Workflow_Details__c)
            {           
                if(null!=wahmap && wahmap.containskey(outerforWAH)) 
                {
                    if(null!=wahmap.get(outerforWAH) && wahmap.get(outerforWAH).size()>0)
                    {
                        
                        tempid=wahmap.get(outerforWAH);
                        tempid.add(innerforWAH);
                        wahmap.put(outerforWAH,tempid);
                        
                    }
                    /*else
                    {
                        tempid.add(innerforWAH);
                        wahmap.put(outerforWAH,tempid);
                    } */
                }
                else
                {
                    tempid.add(innerforWAH);
                    wahmap.put(outerforWAH,tempid);         
                }           
            }
    
        }
    }
}
System.debug('&&&&&&&&&&&&&&&&&&&&&&&'+wahmap);
List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();
List<String> strListName= new List<String>();
  List<String> strListStatus = new List<String>();
  List<String> strListType =new List<String>();
    List<String> strToList =new List<String>();
for(Workflow_Approval_History__c tempwdn : wahmap.keyset())
{
system.debug('33333333'+tempwdn);
                List<String> ApproverListadd = new List<String>();
                
  strListName= new List<String>();
  strListStatus = new List<String>();
  strListType =new List<String>();
  strToList  =new List<String>();
//System.debug('3333-33333'+wahmap.get(tempwdn));
  String wkflname ='';
  String link=label.Instance_Link;
  String hw=label.Honeywell_Site;
  
  for(Workflow_Approval_History__c wh:wahmap.get(tempwdn))
  {
             
        if(wh.Approval_Status__c=='Pending Approval' && tempwdn.id==wh.id ) 
        {       
            system.debug('Inside For ###'+wh);
            strToList.add(wh.email__c);
            system.debug('Inside For $$$'+strToList);
        }
        strListType.add(wh.Approver_Type__c);
        strListName.add(wh.approver__c);
        strListStatus.add(wh.Approval_Status__c);
  }
   system.debug('Outside For $$$'+strToList);
  wkflname = tempwdn.Workflow_Name__c;

       system.debug('222222222'+tempwdn.Summary__c);
       system.debug('00000000'+tempwdn.Documentum__c);
        
      Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();  
             String field1='';
              String field2='';
              String field3='';
              String field4='';
              String field5='';
              String field6='';
              String field7='';
              String field8='';
              String field9='';
              String field10='';
              String field11='';
              
            String strTemp=''; 
             for(Integer i=0;i<strListName.size();i++)
            {
                strTemp = strTemp + '<br>'+strListType[i]+'-----'+strListName[i]+'------'+strListStatus[i];
            }
            String htmlHeader  = '<html><head>'                                        
            +'<body><table>'                                         
            +'<h1 align="center"><font size="18" color="red" align ="center" family="Copper Black"></font> </h1>'                                         +'<tr><hr width="800" color="red" height="25"/></tr>';    
             String htmlbody='<p style="font-family:calibri;color:black;font-size:14.5px;">'
            +'Dear Approver,<br>' 
            +'Your formal eGreensheet approval is requested for '+ tempwdn.Workflow_Name__c +','+' '+'<a href="'+link+''+ tempwdn.Workflow_Details__c+'">'+ tempwdn.WorkFlow_Id__c +'</a>'
            +'<br>'+'<b><a href="' 
            +hw+'/1?WFAppRec='
            + tempwdn.Id +'&WFAccepted=True" style="color:green;font-size:18.5;font-family:calibri">Accept</a></b>'+'  '+'<b>/</b>'+' '
            +'<b><a href="' 
            +hw+'1?WFAppRec='
            + tempwdn.Id +'&WFRejected=True" style="color:red;font-size:18.5;font-family:calibri">Reject</a></b>'
            +'<br> The eGreensheet document can be read here'+':'+' '
            +'<a href="'+ tempwdn.Documentum__c +'">' + tempwdn.Documentum__c  +'</a>'
            +'<br><br>  Requester&#39s Comments - ';
            field1=htmlheader+htmlbody;
            if(tempwdn.Requester_s_Comments__c!=null)
            {
            field1= htmlHeader + htmlbody+tempwdn.Requester_s_Comments__c ;
            }
            field2=field1+'<br>Summary - ';
            if(tempwdn.Summary__c!=null)
            {
              field2=field2+tempwdn.Summary__c;
              }
     field3= field2 +'<br><br>* Sales (K$) - ' + '<b>'+tempwdn.Sales_K__c+'</b>'
            +'&#59;'+'&nbsp;&nbsp;'+'5 Year Revenue (K$) - ' + '<b>'+tempwdn.X5_Year_Revenue_K__c+'</b>'
            +'<br>' 
            +'* Front End Loss (K$) - ' + '<b>'+tempwdn.Front_End_Loss__c+'</b>'
            +'&#59;'+'&nbsp;&nbsp;'+'Front End Loss Max/Year (K$) - ' +'<b>'+tempwdn.Front_End_Loss_Max_Year__c+'</b>'
            +'<br>'
            +'* Exposed Cost (K$) - ' +'<b>'+tempwdn.Exposed_Cost__c+'</b>'
            +';'+'&nbsp;&nbsp;'+'Exposed Cost Max/Year (K$) - '+'<b>'+tempwdn.Exposed_Cost_Max_Year_K__c+'</b>'
           + '<br><br>'+ '* Opportunity: ';
        field4=field3;
if(tempwdn.Opportunity_Number__c!=null)
          {
          field4=field4+tempwdn.Opportunity_Number__c;
          }
          field5= field4+',';
          field6=field5;
          if(tempwdn.Workflow_Details__r.Opportunity_Description__r.Name!=null)
          {
          field6=field6 +' '+'<a href="'+link+''+tempwdn.Opportunity_Name_SFDC_ID__c+'">'+ tempwdn.Workflow_Details__r.Opportunity_Description__r.Name +'</a>';
          }
          field10=field6 +'<br>* OPRO Number: '+'<a href="'+link+''+tempwdn.OPRO_Number_SFDC_ID__c+'">' + tempwdn.OPRO_Number__c  +'</a>';

          field7=field10 +'<br>* Customer: '+'<a href="'+link+''+tempwdn.Customer_SFDC_ID__c+'">' + tempwdn.Customer_Name__c  +'</a>'
           +'<br><br>* Opportunity Owner - ';
           field8=field7;
            if(tempwdn.Opportunity_Lead_Owner__c!=null)
            {
            field8=field8+tempwdn.Opportunity_Lead_Owner__c;
            }
            field9= field8+'<br>* Pricing Analyst - '+'<a href="mailto:'+tempwdn.OwnerEmail__c+'">'+tempwdn.ownerfullname__c +'</a>'
            +'<br><br>'+'<i>'+'eGreensheet Approvers:'+'</i>'+'<i>'+strTemp+'</i>'
            +'<br><br>'
            +'<b><i>Need help with Salesforce.com or Documentum?</i></b>'+' '+
            +'<b><a href="mailto:aeroapps.servicedesk@Honeywell.com">'+'Contact Aero Application Service Desk</a></b>'
            +'<br>'
            +'Thank You!'+'</p>';
            
                 
  List<string> strToAdd = new List<String>();
  //strToList.add('kayalvizhi.kandasamy@nttdata.com');
  OrgWideEmailAddress owa = [select id, Address, DisplayName from OrgWideEmailAddress where displayname like 'your%'] ;  
  message.setHtmlBody(field9);
  message.setOrgWideEmailAddressId(owa.id);
  message.setToAddresses(strToList);
  message.setSubject('eGreensheet Approval Requested - '+tempwdn.Age__c +' '+'days Pending - '+ tempwdn.Customer_Name__c + ' - '+tempwdn.OPRO_Number__c);
  system.debug(htmlbody);
  TriggerInactive.sendMail = false;
  bulkemails.add(message);
}
if( bulkEmails.size()>0){
system.debug('YYYYYYYYYY'+bulkEmails.size());
    if(!test.isRunningTest())
    Messaging.sendEmail(bulkEmails);
    }


}
}