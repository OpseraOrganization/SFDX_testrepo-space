global class CallServicetoCreateClass{
    @future(Callout=true)
    public static void classService(Set<id> lstcaseid){        
        List<case> lstcase = new List<case>();
        List<Case> updatecas = new List<Case>();
        List<Case> updatecas1 = new List<Case>();
        List<Contact> con = new  List<Contact>();        
        lstcase = [select id,OwnerId__r.email,Contactid,Region__c,Sub_Region__c,CBT__c,CBT_Team__c,casenumber,Account.name,Description,Resolution__c,Account_Name__c,Account_Type__c,Account_Address__c,Contact_Name__c,Primary_Work_Number__c,Primary_Cell_Number__c,Primary_Email_Address__c from case where id in :lstcaseid];
        con = [select Primary_Email_Address__c from Contact where id=:lstcase[0].Contactid];
        system.debug('contactemail'+con);
        string contactemail='';
        if(con[0].Primary_Email_Address__c != null)
        contactemail=con[0].Primary_Email_Address__c;
        //lstcase[0].Primary_Email_Address__c= email;
        string caseemail='';
        caseemail=lstcase[0].Primary_Email_Address__c;
        ////////////////////////////////////
        List<S2SFRestService__c> restAPIProps = new List<S2SFRestService__c>();
        restAPIProps = S2SFRestService__c.getALL().values() ;
        S2SFRestService__c objS2SF = new S2SFRestService__c();
        if(restAPIProps.size()>0)
        {
            objS2SF = restAPIProps[0];
        }           
        String clientId =objS2SF.client_Id__c;
        String clientSecret = objS2SF.Secret_Id__c;
        String username=objS2SF.User_Name__c;
        String password=objS2SF.Password__c;   
        String reqbody = 'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password;           
        HttpRequest req = new HttpRequest();
        req.setBody(reqbody);
        req.setMethod('POST');  
        req.setTimeout(120000);  
        req.setEndpoint(objS2SF.OAuth2End_Point__c);       
        Http h = new Http();
        HttpResponse res = new HttpResponse();
        String resBody;
        String resMsg;
        String resBody1;      
        if(!Test.isRunningTest())       
        {
            res = h.send(req);
            resBody = res.getbody();
            resMsg = res.getStatus();
        }
        else{
            resBody = '{"access_token":"00D560000008mxZ!ARIAQAm6ceQGeloxsMyLmmPPj_ZM3VOVkR8mVR7jR03ML1jq.YV9iU3AMwk94Gnfqx4EaFBjgOpIHyoLfbc9o7CjaqYH.Hhx","instance_url":"https://cs42.salesforce.com","id":"https://test.salesforce.com/id/00D560000008mxZEAQ/005a0000009Lhn6AAC","token_type":"Bearer","issued_at":"1453358389670","signature":"OkGVCiTOySRyf6hJ5A8rfoauHsZCGse4AGQkQZtqRq4="}';
            resMsg = 'ok';
        }
        OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(resBody, OAuth2.class);      
        /////////////////////////////////////   
        HttpRequest req1 = new HttpRequest();
        Map<string,RestAPIEndPoint__c> mapEndPointURLs = new Map<String,RestAPIEndPoint__c>();
        mapEndPointURLs = RestAPIEndPoint__c.getAll();        
        if(mapEndPointURLs.size()>0)
        {
            
            req1.setEndpoint(mapEndPointURLs.get('CreateOpportunityEndPointURL').EndPointURL__c); 
        }
        //req1.setEndpoint(objCreateCaseURL.CreateCase_EndPoint__c);
        //req1.setEndpoint('https://cs14.salesforce.com/services/apexrest/GeneralCase');
        req1.setHeader('Content-Type','application/json;charset=UTF-8');
        req1.setHeader('Authorization','Bearer '+objAuthenticationInfo.access_token);        
        req1.setMethod('POST');
        HttpResponse res1 = new HttpResponse();
        Http httpCall1 = new Http();             
        for(case cs:lstcase){
         // cs.Primary_Email_Address__c= contactemail;
            string primarycellno='';
            string primaryworknumberextension='';
            string accounttype='';
            string description='';
            if(cs.Primary_Cell_Number__c != null)
            primarycellno=cs.Primary_Cell_Number__c;
            if(cs.Primary_Work_Number__c != null)
            primaryworknumberextension=cs.Primary_Work_Number__c;
            if(cs.Account_Type__c != null)
            accounttype=cs.Account_Type__c;
            if(cs.Description != null)
            {
            string description1=cs.Description;
            String repl = description1.replaceAll('\\r\\n|\\r|\\n','nnn');
            description = repl;
            }
            //description=cs.Description;
            
            String body = '{"Name":"(SC-04) MSC '
                +cs.casenumber
                +'","StageName":"Phase 0: Ideation Concept","Contracttitle":"'+description+'","casenumber":"'+cs.casenumber+'","Region":"'+cs.Sub_Region__c+'","ProfitCen":"2001000129","Type":"Technical Publications","SBEFamily":"Aero Services","Group1":"Maintenance Services","Line":"Ground Support Solutions","ArePatentsInvolved":"No","Description":"test","Licensor":"HII","Licensee":"'+cs.Account.name+'","ContractType":"Tech Pub","AttorneySBG":"AER","DealStatus":"Red [0-49%]","Country":"'+cs.Region__c+'","SRO":"No","CBT":"'+cs.CBT__c+'","CBTTeam":"'+cs.CBT_Team__c+'","AccountName":"'+cs.Account_Name__c+'","AccountType":"'+accounttype+'","ContactName":"'+cs.Contact_Name__c+'","PrimaryWorkNumberExtension":"'+primaryworknumberextension+'","PrimaryCellNumber":"'+primarycellno+'","AccountAddress":"'+cs.Account_Address__c+'","PrimaryEmailAddress":"'+contactemail+'"}';
           // ,"ContactName":"'+cs.Contact_Name__c+'","PrimaryWorkNumberExtension":"'+cs.Primary_Work_Number__c+'","PrimaryCellNumber":"'+cs.Primary_Cell_Number__c+'","PrimaryEmailAddress":"'+cs.Primary_Email_Address__c+'"
            system.debug('body----->'+body);
            req1.setBody(body);                    
            try{
                if(!Test.isRunningTest()){
                    res1 = httpCall1.send(req1);
                    resBody1 = res.getbody();
                }
                else{
                    resBody1 = '[{"attributes":{"type":"Opportunity","url":"/services/data/v35.0/sobjects/Opportunity/006e000000BhdttAAB"},"Id":"006e000000BhdttAAB","Name":"(SC-04) MSC CASE-11892500","Contract_Type__c":"Tech Pub","Contract_Title__c":"Test Take 5 UAT","Description":"test","Comments__c":"Account Name:DUNCAN AVIATION INC - LINCOLN\nAccount Type:Dealer\nAccount Address:3701 Aviation Rd  Lincoln Airport  , Lincoln, NE, USA\nContactName:Venkatesh Athanti\nPrimary Work Number:128806558\nPrimary Email Address:venkatesh.athanti@honeywell.com.qa"}]';
                }
            }
            catch(exception ex){
                system.debug('inside exceptiom'+ex.getMessage());               
            }
            if(resMsg =='ok')
            {
                if(cs.Is_Case_Owner_a_queue__c=true)
                {
                    cs.ownerid=userinfo.getuserid();
                    cs.Export_Compliance_Content_ITAR_EAR__c='NO';
                    cs.Government_Compliance_SM_M_Content__c='NO';
                    
                }               
                cs.status='Closed';
                updatecas.add(cs);
                system.debug('venkattest000000---->'+cs.status);
                update updatecas;
                system.debug('venkattest1111---->'+cs.status);                                                  
            }            
        }
        List<string> FileNames = new List<String>();
        string Filename1;
        string Filename2;
        string Filename3;
        string Filename4;
        JSONParser parser = JSON.createParser(resBody1);   //Pass your response string here          
    }    
}