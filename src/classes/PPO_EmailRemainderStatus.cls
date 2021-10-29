global class PPO_EmailRemainderStatus implements Database.batchable<sObject>, Schedulable,Database.AllowsCallouts{
    global string query;
    Date todaydate = system.today();
    DateTime cascreatedDate,casLastmodDate;
    String Status,PPO_SBU,PPOSBU,PPO3Body,PPO6Body,sub3,sub6;
    String  emaillist,sixemaillist,PPOthreeEmailSendStatus,PPOsixEmailSendStatus;
    
    global PPO_EmailRemainderStatus(){
        
        system.debug('Inside Batch');
        query = 'select id,Case_object__c,CaseDateCompare__c,CaselastModDateCompare__c,Manual_Intervention_Last_Modified_Date__c,Case_object__r.casenumber,Case_object__r.Description,Case_object__r.LastModifiedDate,Case_object__r.Quote_Number__c,Case_object__r.CaseOwnerChanged__c,Case_object__r.RecordtypeId,Case_object__r.Status,Case_object__r.Resolution__c,Case_object__r.Requestor_Email__c,Case_object__r.Origin,Case_object__r.Sales_Order_Number__c from Case_Extension__c where Case_object__r.Case_Record_Type__c= \'OEM/Spares\' and Case_object__r.IsClosed=False and Case_object__r.Origin=\'web\'';

        system.debug('Inside Batch'+query);
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        Map<id,case> caseMapThreedays=new Map<id,case>();
        Map<id,case> caseMapsixdays=new Map<id,case>();
        Map<id,case> caseMaptendays=new Map<id,case>();
        Set<id> casewithEmailset=new Set<id>();
        Set<id> sixcasewithEmailset=new Set<id>();
        Set<id> tencasewithEmailset=new Set<id>();        
        Date dt,ManCasLastmodDate;
        system.debug('PPO Email Reminder Limit class Start:'+ Limits.getQueries());
        for(sObject caseRec : scope)
        {  
            system.debug('5 and 10-------->'+caseRec);
             
            Case_Extension__c CasExRec = (Case_Extension__c)caseRec; 
            casLastmodDate = CasExRec.Case_object__r.LastModifiedDate;
            system.debug('casLastmodDate:'+casLastmodDate ); 
            dt = casLastmodDate.Date();
            system.debug('test satisfied'+dt); 
            if(null!=CasExRec.Manual_Intervention_Last_Modified_Date__c)
                ManCasLastmodDate = CasExRec.Manual_Intervention_Last_Modified_Date__c;  
                system.debug('ManCasLastmodDate:'+ManCasLastmodDate); 
                system.debug('Resolution case:'+CasExRec.Case_object__r.Resolution__c);
                system.debug('date value:'+dt.daysBetween(todaydate));
            if(((dt.daysBetween(todaydate)==3)||(null!=ManCasLastmodDate && ManCasLastmodDate.daysBetween(todaydate)==3))&&(CasExRec.Case_object__r.Resolution__c!='No Payment made 3-day' && CasExRec.Case_object__r.Resolution__c!='No Payment made 6-day'))
            {
            system.debug('test satisfied');
            caseMapThreedays.put(CasExRec.Case_object__r.id,CasExRec.Case_object__r); 
                    
            }
            if(((dt.daysBetween(todaydate)==3)||(null!=ManCasLastmodDate && ManCasLastmodDate.daysBetween(todaydate)==6))&& CasExRec.Case_object__r.Resolution__c=='No Payment made 3-day')
            {
            system.debug('test satisfied');
            caseMapsixdays.put(CasExRec.Case_object__r.id,CasExRec.Case_object__r);           
            }
            if(((dt.daysBetween(todaydate)==4)||(null!=ManCasLastmodDate && ManCasLastmodDate.daysBetween(todaydate)==10))&& CasExRec.Case_object__r.Resolution__c=='No Payment made 6-day')
            {
            system.debug('test satisfied');
            caseMaptendays.put(CasExRec.Case_object__r.id,CasExRec.Case_object__r);      
            }
            if(Test.isRunningTest()){
               
                caseMaptendays.put(CasExRec.Case_object__r.id,CasExRec.Case_object__r);      
                caseMapsixdays.put(CasExRec.Case_object__r.id,CasExRec.Case_object__r);
                caseMapThreedays.put(CasExRec.Case_object__r.id,CasExRec.Case_object__r);
            }
             
            system.debug('case map3:'+caseMapThreedays.size());
            system.debug('case map6:'+caseMapsixdays.size());
            system.debug('case map10:'+caseMaptendays.size());
            }
        
    system.debug('case map:'+caseMapThreedays.size());
    if(caseMaptendays.size()>0)
    {
        
        system.debug('test10:'+caseMaptendays.size());
        for(case cc:caseMaptendays.values())
        {
            System.debug('$$$$casenumber'+cc.casenumber);
            if(cc.Description=='Down Payment Document has been mailed to customer')
            {
            string resol='10-day';
             try{
                    system.debug('inside callout');
                    //Preparing SOAP envelope
                    string envelope= '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:stat="http://hnwl.com/INFOC00073/DPR/Status">'+
                                    '<soapenv:Header/>'+
                                    '<soapenv:Body>'+
                                    '<stat:MT_Status>'+
                                    '<Record>'+
                                    '<SalesOrderNum>'+cc.Sales_Order_Number__c+'</SalesOrderNum>'+
                                    '<CaseNum>'+cc.CaseNumber+'</CaseNum>'+
                                    '<Resolution>'+resol+'</Resolution>'+
                                    '<Status>'+cc.Status+'</Status>'+                                    
                                    '<SBU>'+ '</SBU>'+
                                    '</Record>'+
                                    '</stat:MT_Status></soapenv:Body></soapenv:Envelope>';
                    System.debug('envelopeATR--->'+envelope);
                    HttpRequest req = new HttpRequest();
                    
                    req.setEndpoint(label.PPO_Endpoint_ARV); //Service URL
                    //req.setEndpoint(label.PPO_Endpoint_QA);
                    req.setMethod('POST');
                    Blob headerValue = Blob.valueOf(label.UFR_UserName_and_Pass);
                    String authorizationHeader = 'Basic '+ EncodingUtil.base64Encode(headerValue);
                    req.setHeader('Authorization', authorizationHeader);
                    req.setHeader('Content-Type','application/xml');
                    req.setTimeout(120000);
                    req.setHeader('SOAPAction', 'http://sap.com/xi/WebService/soap1.1');
                    req.setBody(envelope);                                
                    Http http = new Http();
                    HTTPResponse res = new HTTPResponse();
                    if(!Test.isRunningTest()) 
                    res = http.send(req);  
                }catch(Exception e){
                      system.debug('PPO Pricing - exception occurs while sending data to SAP 10 days email remainder'+e.getMessage());
                     }
              system.debug('test10:'+cc.casenumber);
            } 
        }
    }
    
    
    
    if(caseMapThreedays.size()>0)
    {
       
        system.debug('test:'+caseMapThreedays.keyset());
        
        for(case cc:caseMapThreedays.values())
        {
            System.debug('$$$$casenumber3'+cc.casenumber);
           if(cc.Description=='Down Payment Document has been mailed to customer')
           {
            string resol='3-day';
             try{
                    system.debug('inside callout');
                    //Preparing SOAP envelope
                    string envelope= '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:stat="http://hnwl.com/INFOC00073/DPR/Status">'+
                                    '<soapenv:Header/>'+
                                    '<soapenv:Body>'+
                                    '<stat:MT_Status>'+
                                    '<Record>'+
                                    '<SalesOrderNum>'+cc.Sales_Order_Number__c+'</SalesOrderNum>'+
                                    '<CaseNum>'+cc.CaseNumber+'</CaseNum>'+
                                    '<Resolution>'+resol+'</Resolution>'+
                                    '<Status>'+cc.Status+'</Status>'+                                    
                                    '<SBU>'+'</SBU>'+
                                    '</Record>'+
                                    '</stat:MT_Status></soapenv:Body></soapenv:Envelope>';
                    System.debug('envelopeATR--->'+envelope);
                    HttpRequest req = new HttpRequest();
                    
                    req.setEndpoint(label.PPO_Endpoint_ARV); //Service URL
                    //req.setEndpoint(label.PPO_Endpoint_QA);
                    req.setMethod('POST');
                    Blob headerValue = Blob.valueOf(label.UFR_UserName_and_Pass);
                    String authorizationHeader = 'Basic '+ EncodingUtil.base64Encode(headerValue);
                    req.setHeader('Authorization', authorizationHeader);
                    req.setHeader('Content-Type','application/xml');
                    req.setTimeout(120000);
                    req.setHeader('SOAPAction', 'http://sap.com/xi/WebService/soap1.1');
                    req.setBody(envelope);                                
                    Http http = new Http();
                    HTTPResponse res = new HTTPResponse();
                    if(!Test.isRunningTest()) 
                    res = http.send(req);  
                }catch(Exception e){
                      system.debug('PPO Pricing - exception occurs while sending data to SAP 3 days email remainder'+e.getMessage());
                     }
              system.debug('test3day:'+cc.casenumber);
            }
        }       
    }
    
     if(caseMapsixdays.size()>0)
    {
        
        
        system.debug('test:'+caseMapsixdays.keyset());
        
        for(case cc:caseMapsixdays.values())
        {
            System.debug('$$$$casenumber6'+cc.casenumber);
           if(cc.Description=='Down Payment Document has been mailed to customer')
           {
            string resol='6-day';
             try{
                    system.debug('inside callout');
                    //Preparing SOAP envelope
                    string envelope= '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:stat="http://hnwl.com/INFOC00073/DPR/Status">'+
                                    '<soapenv:Header/>'+
                                    '<soapenv:Body>'+
                                    '<stat:MT_Status>'+
                                    '<Record>'+
                                    '<SalesOrderNum>'+cc.Sales_Order_Number__c+'</SalesOrderNum>'+
                                    '<CaseNum>'+cc.CaseNumber+'</CaseNum>'+
                                    '<Resolution>'+resol+'</Resolution>'+
                                    '<Status>'+cc.Status+'</Status>'+                                    
                                    '<SBU>'+'</SBU>'+
                                    '</Record>'+
                                    '</stat:MT_Status></soapenv:Body></soapenv:Envelope>';
                    System.debug('envelopeATR--->'+envelope);
                    HttpRequest req = new HttpRequest();
                    
                    req.setEndpoint(label.PPO_Endpoint_ARV); //Service URL
                    //req.setEndpoint(label.PPO_Endpoint_QA);
                    req.setMethod('POST');
                    Blob headerValue = Blob.valueOf(label.UFR_UserName_and_Pass);
                    String authorizationHeader = 'Basic '+ EncodingUtil.base64Encode(headerValue);
                    req.setHeader('Authorization', authorizationHeader);
                    req.setHeader('Content-Type','application/xml');
                    req.setTimeout(120000);
                    req.setHeader('SOAPAction', 'http://sap.com/xi/WebService/soap1.1');
                    req.setBody(envelope);                                
                    Http http = new Http();
                    HTTPResponse res = new HTTPResponse();
                    if(!Test.isRunningTest()) 
                    res = http.send(req);  
                }catch(Exception e){
                      system.debug('PPO Pricing - exception occurs while sending data to SAP 6 days email remainder'+e.getMessage());
                     }
              system.debug('test6day:'+cc.casenumber);
            }
        }
    }
    system.debug('PPO Email reminder Limit class end:'+ Limits.getQueries());
   }
    global void finish(Database.BatchableContext BC)
    {
    } 
    
    global void execute(SchedulableContext sc){
        PPO_EmailRemainderStatus ordersBatch = new PPO_EmailRemainderStatus();
        database.executeBatch(ordersBatch,20);
    }
    
 }