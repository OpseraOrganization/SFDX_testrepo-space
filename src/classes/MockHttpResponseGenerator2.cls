@isTest
global class MockHttpResponseGenerator2 implements HttpCalloutMock 
{
    global HTTPResponse respond(HTTPRequest req) 
    {
        HTTPResponse res=new HTTPResponse();
        
        /* string envelope= '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:task="http://hnwl.com/INFOC00074_3/SFDC/Task"><soapenv:Header/><soapenv:Body><task:MT_Task><Task><Event_Type>TASK CLOSE</Event_Type><Status>Closed</Status><Task_Owner></Task_Owner><Type>Z105 Review Repeat Return Candidate</Type><SFDC_Case_Number>12020922</SFDC_Case_Number><Notification_Number>000323960454</Notification_Number><Sales_Order>0006660995</Sales_Order><Task_object_Number>0010</Task_object_Number><Task_Activity_ID>a8n5600000097HAAAY</Task_Activity_ID><Task_Short_Text>Test</Task_Short_Text><Task_Long_Text></Task_Long_Text><Task_Modified_By>Venkatesh Athanti</Task_Modified_By><Task_Modified_DateTime>2016-12-01 01:44:44</Task_Modified_DateTime><Language_Key>null</Language_Key></Task></task:MT_Task></soapenv:Body></soapenv:Envelope>';                       
        System.debug('envelope--->'+envelope);
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
        res = http.send(req); */
        string envelope= '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:task="http://hnwl.com/INFOC00074_3/SFDC/Task"><soapenv:Header/><soapenv:Body><task:MT_Task><Task><Event_Type>TASK CLOSE</Event_Type><Status>Closed</Status><Task_Owner></Task_Owner><Type>Z105 Review Repeat Return Candidate</Type><SFDC_Case_Number>12020922</SFDC_Case_Number><Notification_Number>000323960454</Notification_Number><Sales_Order>0006660995</Sales_Order><Task_object_Number>0010</Task_object_Number><Task_Activity_ID>a8n5600000097HAAAY</Task_Activity_ID><Task_Short_Text>Test</Task_Short_Text><Task_Long_Text></Task_Long_Text><Task_Modified_By>Venkatesh Athanti</Task_Modified_By><Task_Modified_DateTime>2016-12-01 01:44:44</Task_Modified_DateTime><Language_Key>null</Language_Key></Task></task:MT_Task></soapenv:Body></soapenv:Envelope>';                       
        //string envelope='<SOAP:Envelope ><SOAP:Header/><SOAP:Body ><ns0:MT_Task_Ack ><Task><Notification>000323960454</Notification><Sales_Order>0003239604540010</Sales_Order><Case_Number>12020922</Case_Number><Status>Closed</Status><Message/><Task_Object_Number>0010</Task_Object_Number><Activity_id>a8n5600000097HAAAY</Activity_id><Task_text>Test</Task_text></Task><Task><Notification>000323960454</Notification><Sales_Order>0003239604540011</Sales_Order><Case_Number>12020922</Case_Number><Status>Open</Status><Message>null</Message><Task_Object_Number>0011</Task_Object_Number><Activity_id>a8n5600000097HFAAY</Activity_id><Task_text>Test</Task_text></Task></ns0:MT_Task_Ack></SOAP:Body></SOAP:Envelope>';
        res.setStatusCode(200);
        res.setStatus('ok');
        res.SetBody(envelope);              
        return res;
    }
}