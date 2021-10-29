/** * File Name: Account_UpdateOwner
* Description :formats the request received from the daily and weekly batch jobs and 
                sends it to pi
* Copyright : Wipro Technologies Limited Copyright (c) 2001 *
 * @author : Wipro
 * Modification Log ========================== Ver Date Author Modification --- ---- ------ -------------* */ 


public class DeniedPartyRequest{
    public static void SendRequest(List<account_address__c> alist){
    
        string fstaddr='';
        if(alist.size()>0)
        fstaddr='first address :'+alist[0].name+'<-->';
        String end_point=label.Denied_Party_Endpoint;
        String unampass =label.Denied_Party_UserNameAndPass;
        String envelope ;
        DeniedPartyRequest cobj=new DeniedPartyRequest();
        envelope = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dps="http://hnwl.com/INFCA00104/DPScreening">'+
           '<soapenv:Header/>'+
           '<soapenv:Body>'+
              '<dps:MT_SFDC_ScreeningRequest>';
          for(Account_address__c a:alist)
          {    
              
           envelope =envelope +'<ADDRESS>'+
                    '<ADDRNUMBER>'+(a.name+'').replace('&','&amp;')+'</ADDRNUMBER>'+
                    '<NAME1>'+(a.AccountNameFormula__c+'').replace('&','&amp;')+'</NAME1>'+
                    '<CITY1>'+(a.ACCOUNT_CITY_NAME__C+'').replace('&','&amp;')+'</CITY1>'+
                    '<POSTCODE1>'+(a.ADDRESS_POSTAL_CODE__C+'').replace('&','&amp;')+'</POSTCODE1>'+
                    '<STREET>'+(a.Address_LineFormulae1__c+'').replace('&','&amp;')+'</STREET>'+
                    '<COUNTRY>'+(a.COUNTRY_CODE__C+'').replace('&','&amp;')+'</COUNTRY>'+
                    '<TELNUMBER>'+(a.Address_Work_Phone__c+'').replace('&','&amp;')+'</TELNUMBER>'+
                    '<FAXNUMBER>'+(a.Address_Fax__c+'').replace('&','&amp;')+'</FAXNUMBER>'+
                 '</ADDRESS>';
           }      
            envelope =envelope +'</dps:MT_SFDC_ScreeningRequest>'+
           '</soapenv:Body>'+
        '</soapenv:Envelope>';
        
       
        

        HttpRequest req = new HttpRequest();        

       // req.setEndpoint('https://axdwas.honeywell.com/XISOAPAdapter/MessageServlet?channel=:BCP_SFDC:CC_INFCA00104_SFDC_PI_DPScreening_SND&namespace=http%3A//hnwl.com/INFCA00104/DPScreening&interface=SI_INFCA00104_DPScreening_ASYN_OB&QOS=EO');
       //
        req.setEndpoint(end_point);
        req.setMethod('POST');
        req.setHeader('SOAPAction', 'http://sap.com/xi/WebService/soap1.1');
        req.setHeader('Content-Type', 'text/xml');
        //req.setHeader('Accept-Encoding','gzip,deflate');

        Blob headerValue = Blob.valueOf(unampass);
       
        
        String authorizationHeader ='Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
                
        req.setBody(envelope);
        
        req.setTimeout(120000);

        Http http = new Http();
        System.debug('$$$$ + req.getBody() = :'+req.getBody());
        HTTPResponse res = new HTTPResponse();
        Integer sCode;
        IF(!TEST.isRunningTest())
        {
        res = http.send(req);
        System.debug('$$$$ + res.getBody() = :'+res.getBody());
        sCode = res.getStatusCode();
        }
        else
        {
        sCode=300;
        }
        
        if(sCode == 200) {
        DP_Error_Log__c elog = new DP_Error_Log__c(time__c = datetime.now(),status__c = 'Success',description__c = fstaddr+res.getBody());
            insert elog;
        }
        else {
            DP_Error_Log__c elog = new DP_Error_Log__c();
            elog.time__c = datetime.now();
            elog.status__c = 'Failed';
            string descp = res.getBody();
            if(string.valueof(descp).length()>32766) {  
            elog.description__c = fstaddr+string.valueof(descp.substring(0,32766));
            }
            else {
            elog.description__c = fstaddr+ res.getBody();
            }
            insert elog;
        }
        
        System.debug('$$$$ + sCode = :'+sCode);
        String responseCode =  res.toString();
        System.debug('$$$$ + responseCode = :'+responseCode);
    }
        
}