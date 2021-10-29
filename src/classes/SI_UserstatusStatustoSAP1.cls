/*******************************************************************************
Name            :   UserstatusstatustoSAP
Created By      :   NTTDATA
Company Name    :   NTT Data
Project         :   SI 
Created Date    :   01-08-2016
Usages          :   Sending New Userstatus Details & Updated Z Task Details.         
*******************************************************************************/
global class SI_UserstatusStatustoSAP1{
    @future(callout=true)
    webservice static void SendTaskStatus(List<id> Userstatusid){
        Boolean taskupdate = false;
        system.debug('taskupdate-------'+taskupdate);       
        if(taskupdate == false)
        {
            /*system.debug('==== '+Userstatusid); 
            String Uids = Userstatusid.replace('\'','');
            String[] st = Uids.split(',');
            system.debug('----- '+st);
            set<id> ids = new set<id>();
            for(String s:st){
                Id i = Id.valueOf(s);
                ids.add(i);
            }*/
            //system.debug('==== '+ids);
            //user u=[select id,name from user where id='005a0000007vvzm'];
            //System.runAs(u) 
            //{
                try{
                    //Preparing SOAP envelope
                    List<Activitiy_Line_Item__c> Userstatus1=[select id,name__c,Case__c,Notification_Number__c,CaseNumber__c,ChangeNumber__c,Email_flag__c,Email_Status__c,name,ParentObjectNo__c,ParentRoot__c,SAPUserStatusObjectNumber__c,Status__c,Task_Activities__c from Activitiy_Line_Item__c where id IN:Userstatusid];
                    system.debug('+++++ '+Userstatus1);
                    String EventType='';
                    String Status='';
                    String Owner='';
                    String Type='';
                    String caseno='';
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
                    List<Activitiy_Line_Item__c> Userstatus3=new List<Activitiy_Line_Item__c>();
                    if(Userstatus1.size()>0)
                    {
                        for(Activitiy_Line_Item__c Userstatus:Userstatus1)
                        {               
                            system.debug('inside loop');
                            if(Userstatus.status__c == 'open')
                            {
                                Userstatus.status__c='Closed';
                                Userstatus3.add(Userstatus);
                            }
                            if(Userstatus.Status__c == 'closed')
                            {
                                EventType='STATUS_CLOSED';
                            }
                            else
                            {
                                EventType='STATUS_CLOSED';
                            }
                            Status='Closed';
                            TaskobjectNumber=Userstatus.ChangeNumber__c;
                            TaskNo=Userstatus.ParentObjectNo__c;
                            TASKID=Userstatus.SAPUserStatusObjectNumber__c;
                            Owner=Userstatus.ParentRoot__c;               
                            Type=Userstatus.name__c;
                            //Type=null;
                            caseno=null;
                            notificationno=Userstatus.Notification_Number__c;
                            SalesOrder=null;                    
                            shorttext=null;
                            Longtext=null;
                            LanguageKey=null;
                            ChangedDateTime=null;
                            ChangedBy=null;
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
                        string envelope= '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:task="http://hnwl.com/INFOC00074_3/SFDC/Task">'+
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
                                       
                        }
                    }
                    if(Userstatus3.size()>0)
                    {
                        upsert Userstatus3;
                    }               
                }
                catch(Exception e){
                    system.debug('Userstatus - exception occurs while sending data to SAP'+e.getMessage());
                }
            //}
            taskupdate = true;
            system.debug('taskupdate-------'+taskupdate);       
        } 
    }   
}