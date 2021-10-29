/*******************************************************************************
Name            :   ZtaskstatustoSAP
Created By      :   NTTDATA
Company Name    :   NTT Data
Project         :   SI 
Created Date    :   21-04-2016
Usages          :   Sending New Ztask Details & Updated Z Task Details.         
*******************************************************************************/
public class SI_ZtaskStatustoSAP implements Queueable, Database.AllowsCallouts {
    Set<id> ztaskid = new set<id>();
    public SI_ZtaskStatustoSAP(Set<id> ztaskid) {
        this.ztaskid = ztaskid;
        
    }
    
    public void execute(QueueableContext qc) {
         Boolean taskupdate = false;
         SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput();  //Added for RAPD 3343
          List<Z_Task__c> Upsertztasklst=new List<Z_Task__c>();
           String caseno='';
        system.debug('taskupdate-------'+taskupdate);       
        if(taskupdate == false)
        {
               //List<Z_Task__c> ZTask1=[select id,Case__c,CaseNumber__c,ChangeNumber__c,Email_flag__c,Email_Status__c,name,ParentObjectNo__c,ParentRoot__c,SAPUserStatusObjectNumber__c,Status__c,Task_Activities__c from Z_Task__c where id IN:Userstatusid];
                List<Z_Task__c> ZTask1=[select id,Short_Text2__c,Followuptask__c,New_Long_Text__c,Other_Short_Text__c,LastModifiedById,LastModifiedBy.name,name,LastModifiedDate,Event_Type__c,OwnerId,owner.name,Type__c,Sub_Type__c,CaseNumber__c,RelatedTo__c,RelatedTo__r.Repair_Notification_Number__c,RelatedTo__r.Sales_Order_Number__c,Language_Key__c,Long_Text__c,Task_Closed_Date_Time__c,Task_Created_Date_Time__c,Task_Changed_Date_Time__c,Task_Created_By__c,Task_Changed_By__c,Task_Closed_By__c,SAP_ZTask_Number__c,Status__c from Z_Task__c where id=:ztaskid];
                system.debug('+++++ '+ZTask1);
                String EventType='';
                String Status='';
                String Owner='';
                String Type='';
                 string envelope ='';
                 
               
                String caseno1='';
                String notificationno='';
                String SalesOrder='';
                String TaskobjectNumber='';
                String TaskNo='';
                String TASKID='';
                String shorttext='';
                String Longtext='';
                String ChangedBy='';
                string ChangedDateTime;
                String LanguageKey='';
                
                string Field1='';
                string Field2='';
                string Field3='';
                string Field4='';
                string Field5='';
                string Field6='';
                string Field7='';
                string Field8='';
                string Task='';
                List<Z_Task__c> Userstatus3=new List<Z_Task__c>();
                map<id,Z_Task__c> Tempztask=new map<id,Z_Task__c>();
                set<string> restaskid=new set<string>();
                           try{
 
                if(ZTask1.size()>0)
                {
                    for(Z_Task__c ZTask:ZTask1)
                    {               
                         system.debug('inside loop');
                        if(ZTask.Event_Type__c != '')
                        EventType=ZTask.Event_Type__c;
                        system.debug('inside EventType'+EventType);
                        if(ZTask.Status__c != '')
                        Status=ZTask.Status__c;
                        system.debug('inside Status'+Status);
                        system.debug('inside Owner'+ZTask.Owner.name);
                        if(ZTask.owner.name  != '')
                        Owner=ZTask.owner.name; 
                        if(Owner != '' && Owner.contains('&'))
                        {
                            Owner=Owner.replaceall('&','&amp;');
                        }                       
                        system.debug('inside Owner'+Owner);
                        if(ZTask.Type__c != '')
                        Type=ZTask.Type__c;
                        system.debug('inside Type'+Type);
                        if(ZTask.CaseNumber__c != '')
                        caseno1=ZTask.CaseNumber__c;
                        caseno=caseno1.replaceAll('CASE-', '');
                        system.debug('inside caseno'+caseno);
                        if(ZTask.RelatedTo__r.Repair_Notification_Number__c != '')
                        notificationno=ZTask.RelatedTo__r.Repair_Notification_Number__c;
                        system.debug('inside notificationno'+notificationno);
                        if(ZTask.RelatedTo__r.Sales_Order_Number__c != '')
                        SalesOrder=ZTask.RelatedTo__r.Sales_Order_Number__c;
                        system.debug('inside SalesOrder'+SalesOrder);
                        if(ZTask.SAP_ZTask_Number__c != '')
                        TaskobjectNumber=ZTask.SAP_ZTask_Number__c;
                        if(ZTask.Name != '')
                        TaskNo=ZTask.name;
                        system.debug('inside TaskNo'+TaskNo);
                        if(ZTask.Name != '')
                        TASKID=ZTask.id;
                        system.debug('inside TASKID'+TASKID);
                        system.debug('inside sub type----->'+ZTask.Sub_Type__c);
                        if(ZTask.Sub_Type__c != '' && ZTask.Sub_Type__c != null)
                        {
                            if(ZTask.Short_Text2__c != '')
                            {
                                shorttext=ZTask.Short_Text2__c;
                            }
                            else
                            {
                                if(ZTask.Sub_Type__c != 'Other')
                                {
                                    shorttext=ZTask.Sub_Type__c;
                                    system.debug('inside shorttext'+shorttext);
                                }
                                else
                                {
                                    shorttext=ZTask.Other_Short_Text__c;
                                    system.debug('inside Other shorttext'+shorttext);
                                }
                            }
                            system.debug('inside shorttext----->'+shorttext);
                            if(shorttext != '' && shorttext != null)
                            {
                                system.debug('inside shorttext1----->'+shorttext);
                                if(shorttext.contains('&'))
                                {
                                shorttext=shorttext.replaceall('&','&amp;');
                                }
                                if(shorttext.contains('<'))
                                shorttext=shorttext.replaceall('<','&lt;');
                                if(shorttext.contains('>'))
                                shorttext=shorttext.replaceall('>','&gt;');
                                if(shorttext.contains('"'))
                                shorttext=shorttext.replaceall('"','&quot;');                               
                            } 
                        }
                        system.debug('inside Longtext------>'+ZTask.New_Long_Text__c);
                        if(ZTask.New_Long_Text__c != ''&& ZTask.New_Long_Text__c != null && ZTask.Followuptask__c == false)
                        {
                            Longtext=ZTask.New_Long_Text__c;
                            system.debug('inside Longtext'+Longtext);
                            if(Longtext != '' && Longtext != null)
                            {
                                system.debug('inside Longtext'+Longtext);
                                if(Longtext.contains('&'))
                                {
                                Longtext=Longtext.replaceall('&','&amp;');
                                }
                                if(Longtext.contains('<'))
                                Longtext=Longtext.replaceall('<','&lt;');
                                if(Longtext.contains('>'))
                                Longtext=Longtext.replaceall('>','&gt;');
                                if(Longtext.contains('"'))
                                Longtext=Longtext.replaceall('"','&quot;');                             
                            } 
                        }
                        if(ZTask.Language_Key__c != '')
                        LanguageKey=ZTask.Language_Key__c;
                        system.debug('inside LanguageKey'+LanguageKey);
                        if(ZTask.LastModifiedBy.name != '')
                        {
                            ChangedBy=ZTask.LastModifiedBy.name;
                            String timeZone = 'America/Phoenix';
                            Datetime dateGMT=ZTask.LastModifiedDate;
                            ChangedDateTime=dateGMT.format('yyyy-MM-dd HH:mm:ss',timeZone);
                        }
                        system.debug('taskid-----'+taskid);
                        
                        Task= Task +='<Task>'+
                        '<Event_Type>'+EventType+'</Event_Type>'+
                        '<Status>'+Status+'</Status>'+
                        '<Task_Owner>'+Owner+'</Task_Owner>'+
                        '<Type>'+Type+'</Type>'+
                        '<SFDC_Case_Number>'+caseno+'</SFDC_Case_Number>'+
                        '<Notification_Number>'+notificationno+'</Notification_Number>'+
                        '<Sales_Order>'+SalesOrder+'</Sales_Order>'+
                        '<Task_object_Number>'+TaskobjectNumber+'</Task_object_Number>'+
                        '<Task_Activity_ID>'+TASKID+'</Task_Activity_ID>'+               
                        '<Task_Short_Text>'+shorttext+'</Task_Short_Text>'+                
                        '<Task_Long_Text>'+Longtext+'</Task_Long_Text>'+               
                        '<Task_Modified_By>'+ChangedBy+'</Task_Modified_By>'+
                        '<Task_Modified_DateTime>'+ChangedDateTime+'</Task_Modified_DateTime>'+
                        '<Language_Key>'+LanguageKey+'</Language_Key>'+                 
                        '</Task>';
                    }
                    envelope= '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:task="http://hnwl.com/INFOC00074_3/SFDC/Task">'+
                        '<soapenv:Header/>'+
                        '<soapenv:Body>'+
                        '<task:MT_Task>'+Task +'</task:MT_Task></soapenv:Body></soapenv:Envelope>';
                        
                    System.debug('envelope--->'+envelope);
                    HttpRequest req = new HttpRequest();
                    req.setEndpoint(label.SI_SAP_Endpoint_ARD_ARQ); //Service URL
                    req.setMethod('POST');
                    Blob headerValue = Blob.valueOf(label.UFR_UserName_and_Pass);
                    String authorizationHeader = 'Basic '+ EncodingUtil.base64Encode(headerValue);
                    req.setHeader('Authorization', authorizationHeader);
                    req.setHeader('Content-Type','application/xml');
                    req.setTimeout(120000);
                    req.setHeader('SOAPAction', 'http://sap.com/xi/WebService/soap1.1');
                    req.setBody(envelope);                  
                    Http http = new Http();
                    HTTPResponse res = http.send(req);
                    System.debug('res--->'+res);                    
                    String resMsg;
                    resMsg = res.getStatus();
                    System.debug('resMsg--->'+resMsg);
                    System.debug('resMsgcode--->'+res.getStatusCode());
                    System.debug('restostring'+res.toString());
                    String xml = res.getBody();
                    System.debug('xml-----'+xml);

                    if(resMsg =='ok')
                    {                    
                        //dom=new XMLDom(xml);
                        Dom.Document docu=res.getBodyDocument();
                        Dom.XMLNode node=docu.getRootElement();
                        System.debug('docu>>'+docu); 
                        System.debug('node>>'+node); 
                        /*System.debug('node0>>'+node.getChildElements()[0]); 
                        System.debug('node1>>'+node.getChildElements()[1].getChildElements()[0]); 
                        System.debug('node2>>'+node.getChildElements()[1].getChildElements()[0].getChildElements()[0]); 
                        System.debug('node3>>'+node.getChildElements()[1].getChildElements()[0].getChildElements()[0].getChildElements()[0]);  */                     
                        Field1=node.getChildElements()[1].getChildElements()[0].getChildElements()[0].getChildElements()[0].getText();
                        Field2=node.getChildElements()[1].getChildElements()[0].getChildElements()[0].getChildElements()[1].getText();
                        Field3=node.getChildElements()[1].getChildElements()[0].getChildElements()[0].getChildElements()[2].getText();
                        Field4=node.getChildElements()[1].getChildElements()[0].getChildElements()[0].getChildElements()[3].getText();
                        Field5=node.getChildElements()[1].getChildElements()[0].getChildElements()[0].getChildElements()[4].getText();
                        Field6=node.getChildElements()[1].getChildElements()[0].getChildElements()[0].getChildElements()[5].getText();
                        Field7=node.getChildElements()[1].getChildElements()[0].getChildElements()[0].getChildElements()[6].getText();
                        Field8=node.getChildElements()[1].getChildElements()[0].getChildElements()[0].getChildElements()[7].getText();
                        System.debug('Field1>>'+Field1);
                        System.debug('Field2>>'+Field2);
                        System.debug('Field3>>'+Field3);
                        System.debug('Field4>>'+Field4);
                        System.debug('Field5>>'+Field5);
                        System.debug('Field6>>'+Field6);
                        System.debug('Field7>'+Field7);
                        System.debug('Field8>>'+Field8); 
                        dom.XmlNode lsttasks = node.getChildElements()[1].getChildElements()[0]; 
                        system.debug('lsttasks-----'+lsttasks);
                        dom.XmlNode lsttasks1 = node.getChildElements()[1]; 
                        system.debug('lsttasks1-----'+lsttasks1);
                        for (dom.XmlNode currentAccount1:lsttasks1.getChildElements()) 
                        {
                            for (dom.XmlNode taskDetails1:currentAccount1.getChildElements()) 
                            {
                               system.debug('taskDetails1-----'+taskDetails1.getName());
                                system.debug('taskDetails1-----'+taskDetails1.gettext());
                            }
                        }
                        list<string> taskIds=new list<string>();
                        //List<Z_Task__c> Tempztask=new List<Z_Task__c>();
                        
                        for (dom.XmlNode currentAccount:lsttasks.getChildElements()) 
                        {
                            Z_Task__c Tempztask1=new Z_Task__c();
                            for (dom.XmlNode taskDetails:currentAccount.getChildElements()) 
                            {
                                system.debug('taskDetails-----'+taskDetails.getName());
                                system.debug('taskDetails-----'+taskDetails.gettext());
                                if(taskDetails.getName()=='Activity_id')
                                {
                                    system.debug('inside activity id-----'+taskDetails);
                                    system.debug('inside activity id1-----'+string.valueOf(taskDetails));
                                    system.debug('inside activity id1-----'+taskDetails.gettext());
                                    Tempztask1.id=taskDetails.gettext();
                                    restaskid.add(taskDetails.gettext());
                                }
                                if(taskDetails.getName()=='Task_Object_Number')
                                {
                                    Tempztask1.SAP_ZTask_Number__c=taskDetails.gettext();
                                }
                                if(taskDetails.getName()=='Sales_Order')
                                {
                                    Tempztask1.SAPTaskObjectNo__c=taskDetails.gettext();
                                }                                                               
                            }
                            //map<id,Z_Task__c> Tempztask=new map<string,Z_Task__c>();
                            Tempztask.put(Tempztask1.id,Tempztask1);
                        }                   
                    }
                }
                System.debug('Tempztask>>'+Tempztask);
                System.debug('Tempztask size>>'+Tempztask.size());
                System.debug('restaskid size>>'+restaskid);
                if(Tempztask.size()>0)
                {
                    List<Z_Task__c> ztasklst=new List<Z_Task__c>();
                    ztasklst=[select id,SAP_ZTask_Number__c,SAPTaskObjectNo__c from Z_Task__c where id=:restaskid]; 
                    System.debug('ztasklst size>>'+ztasklst.size());
                    if(ztasklst.size()>0)
                    {
                        for(Z_Task__c ztask2:ztasklst)
                        {
                            if(ztask2.id==Tempztask.get(ztask2.id).id)
                            {
                                ztask2.SAP_ZTask_Number__c=Tempztask.get(ztask2.id).SAP_ZTask_Number__c;
                                ztask2.SAPTaskObjectNo__c=Tempztask.get(ztask2.id).SAPTaskObjectNo__c;
                                Upsertztasklst.add(ztask2);
                            }
                        }
                    }
                }
                System.debug('Upsertztasklst size>>'+Upsertztasklst.size());
                if(Upsertztasklst.size()>0)
                {
                    try
                    {
                    upsert Upsertztasklst;
                    }
                    catch(exception e)
                    {
                    system.debug('exception'+e.getmessage());
                    MainCaseTriggerUtility.handleException(e);
                    }
                }                            
            }
            catch(Exception e){
                 system.debug('ZTask - exception occurs while sending data to SAP'+e.getMessage());
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
                List<String> mailToAddresses = new List<String>(); 
                String[] emailAddressArr = (label.SI_ExceptionEmails).split(',');        
                if(emailAddressArr.size() > 0){            
                    for(String i : emailAddressArr){
                        mailToAddresses .add(i);
                    }
                }        
                mail.setToAddresses(mailToAddresses );
                mail.setSubject('Exception on Ztask Creation /Update from SFDC to SAP.');
                String bodyText = 'Case Details : ';
                if(!Test.isRunningTest())
                {
                    bodyText +='\n\n' +'Task Activity creation/Updates has failed with the following error message at the Line Number:\t' + e.getLineNumber()
                        + '\n' + e.getMessage() 
                        + '\n\n of Exception Type ' + e.getTypeName() 
                        + '\n\nStacktrace: ' + e.getStacktraceString()
                        + '\n\nActivyty Id: ' + ztaskid;
                }
                mail.setPlainTextBody(bodyText);
                if(!(Test.isRunningTest()))
                {
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });               
                }
                 /* Added for RAPD - 3343 */
                string truncateIP = '';
        truncateIP = envelope;
         if(truncateIP.length() > 131072){
        truncateIP = truncateIP.subString(0,131072);
        }
               
                 SApInterface.sapException='ZTask - exception occurs while sending data to SAP'+e.getMessage();
                     SApInterface.Name = 'SI_ZtaskStatustoSAP';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                         SApInterface.caseNumber = 'CASE- '+caseno;
                          SApInterface.taskID =ZTask1[0].id;
                          SApInterface.taskType = string.valueOf(ZTask1[0].Type__c);
                          // SApInterface.inputValue =envelope;
                          SApInterface.outputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                /* Ended */
                
            }
            taskupdate = true;
            system.debug('taskupdate-------'+taskupdate);       
        } 
    }   

}