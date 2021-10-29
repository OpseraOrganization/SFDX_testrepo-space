@RestResource(urlMapping='/MKTOEmailOptIn/*')
global with sharing class MKTO_Email_Optin_Callout
{
    @HttpPost
    global static string updateOptInLeads(String email, String St) 
    {
        String Temp2;
        String Temp;
        
        string em_ail2 = email;
        string st2 = St;    
        
        system.debug('+++++++++++++em_ail2++++++++++++'+em_ail2);
        
        String MKTO_ClientID = Label.MKTO_ClientID;
        String MKTO_Secret = Label.MKTO_Secret;
        String MKTO_BaseURL = Label.MKTO_BaseURL;

        Http http = new Http();
        Httprequest req=new Httprequest();
        req.setEndPoint(MKTO_BaseURL+'identity/oauth/token?grant_type=client_credentials&client_id='+MKTO_ClientID+'&client_secret='+MKTO_Secret);
        req.setMethod('GET');                
        req.setHeader('Content-Encoding','gzip');  
        req.setCompressed(true);            
        HTTPResponse res;        
        String Body;
        if (!Test.isRunningTest()) 
        {
            res = http.send(req);
            System.debug(res.toString());
            System.debug('STATUS:'+res.getStatus());
            System.debug('STATUS_CODE:'+res.getStatusCode());                    
            Body=res.getBody();
            System.debug('resBody>>>:'+ Body);
        }
        else
        {
             MockHttpResponse_MKTOEmailOptin mc = new MockHttpResponse_MKTOEmailOptin();
             res = mc.respond(req);             
             Body=res.getBody();
        }
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(body);
        String actoken = String.Valueof(m.get('access_token'));
        System.debug('++actoken+++'+actoken);
  
        String part;
        string EmailOptin = 'Email_Opt_In__c';

        Http http2 = new Http();
        HttpRequest req2 = new HttpRequest(); 
        req2.setEndpoint(MKTO_BaseURL+'rest/v1/leads.json?access_token='+actoken+'&filterType=email&filterValues='+em_ail2+'&fields=leadPartitionId,'+EmailOptin);
        req2.setMethod('GET');
        req2.setHeader('Content-Encoding','gzip');  
        req2.setCompressed(true); 
        HTTPResponse res2;        
        String Body2;
        if(!Test.isRunningTest())
        {   
            res2 = http2.send(req2);
            System.debug(res2.toString());
            body2 = res2.getBody();
        }
        else
        {
            MockHttpResponse_MKTOEmailOptin mc = new MockHttpResponse_MKTOEmailOptin();
            res2 = mc.respond2(req2);             
            body2  =res2 .getBody();
        }
        System.debug('+++++++++++++Body+++++++++++'+res2.getBody());
         
        fromJSON CS = (fromJSON)JSON.deserialize(body2.replace('"'+EmailOptin+'"','"sub"'),fromJSON.class);
        
        Set<String> leadids = new Set<String>();
        for(cls_result c:CS.result)
        {
            leadids.add(String.valueof(c.id));
        }
        if(leadids.size()>0)
        {
            String ss = '';
            for(String s : leadids)
            {
                ss = ss + '{  "Id":"'+s+'","'+EmailOptin+'":"'+st2+'"} , ';
            }
            Temp = ss.removeEnd(' , ');
            Temp2 = '{"action":"updateOnly","lookupField": "id","input":['+Temp+']}';
            system.debug('++Temp2++++++'+Temp2);
        
        
            Http http4 = new Http();
            HttpRequest request1 = new HttpRequest();
            request1.setEndpoint(MKTO_BaseURL+'rest/v1/leads.json?access_token='+actoken);
            request1.setMethod('POST');
            request1.setHeader('Content-Type', 'application/json;charset=UTF-8');
            if(!Test.isRunningTest())
            { 
                request1.setBody(Temp2);
                HttpResponse response1 = http.send(request1); //error
                System.debug('++++++++++Final Response++++++'+response1.getBody());
                string tempResponse1 = response1.getBody().replace('\\"','"');
                system.debug('+++++++tempResponse1++++++'+tempResponse1);
            }
            else
            {
                MockHttpResponse_MKTOEmailOptin mc = new MockHttpResponse_MKTOEmailOptin();
                HttpResponse response1 = mc.respond3(request1);          
            }
            return 'Records updated';
        }
        return 'No records to update';
    }

    public class fromJSON
    {
        public String requestId;    //685e#15ebdc2a093
        public list<cls_result> result;
        public boolean success;
        
        public fromJSON(String requestId,list<cls_result> result,boolean success )
        {
            this.requestId = requestId;
            this.result = result;
            this.success = success;
        }
        
    }

    Public class cls_result
    {
        public Integer id;  //155100
        public String email;    //maheshbabu11.kayala@nttdata.com
        public Integer leadPartitionId; //1
        public String sub;
        
        Public cls_result(Integer id,String email,Integer leadPartitionId,String Sub)
        {
            this.id = id;
            this.email = email;
            //this.leadPartitionId = leadPartitionId;
            this.Sub = Sub;
        }
    }

}