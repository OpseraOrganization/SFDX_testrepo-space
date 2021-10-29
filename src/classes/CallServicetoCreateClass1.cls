global class CallServicetoCreateClass1{
    @future(Callout=true)
    public static void classService(Set<id> lstcaseid){        
        List<opportunity> lstopp = new List<opportunity>();
        List<opportunity> updatecas = new List<opportunity>();
        List<opportunity> updateopp = new List<opportunity>();       
        account acc;
        string accinfo='';
        lstopp = [select id,Name,Opportunity_Owner_Email_Address__c,CBT_HIPI__c,CBT_Team_HIPI__c,Corp_HIPI_Opportunity_Number__c,Business_Contact__c,Opportunity_Number__c,Probability,RecordTypeID,If_Licensor_Other_Please_Specify__c,ATP_Approval_Date__c,If_Restated_Prior_Contract_Number__c,ATN_Approval_Date__c,Are_Patents_Involved__c,Is_TLC_Approval_required__c,List_All_Patent_s_Country_i_e_US__c,Received_TLC_Approvals__c,Brand__c,Agmt_Subject_to_Export_Control__c,If_Brand_Other_Please_Specify__c,Agmts_Contains_Export_Controlled_Data__c,StageName,Attorney_SBG__c,Licensee__c,Request_Contract_Number__c,Licensor__c,OwnerId,contract_sub_type__c,Comments__c, HON_Lead_IP_Attorney__c,Contract_Type__c, If_Other_Enter_the_Name_of_Attorney__c,Contract_Title__c, Contract_Number__c,AccountId,DOS_Approval_Required__c,Deal_Status__c,DOS_Expiration_Date__c,CloseDate,DOS_Number__c,Automatic_Renewal__c,Country__c,Region1__c,Owner_SBG__c,LICENSEE_ADDRESS__c,PRICING_APPROVAL_ON_FILE__c,OTHER_LICENSEE_ADDRESS__c,OTHER_PRICING_APPROVAL_ON_FILE__c,HON_DEVICE_TYPE__c,CUSTOMER_DEVICE_TYPE__c,OTHER_HON_DEVICE_TYPE__c,OTHER_CUSTOMER_DEVICE_TYPE__c,CUSTOMER_POC__c,SIM_DEVICE_OWNER__c,SIM_DEVICE_OWNER_ADDRESS__c,SIM_DEVICE_OPERATOR__c,SIM_DEVICE_OPERATOR_ADDRESS__c,DEVICE_IDENTIFIER__c,PROJ_JOB_SER__c,QTY_OF_DEVICES__c,HON_POC__c,PRICING_APPROVAL_FILE_LINK__c,CUSTOMER_LICENSE_NEED_DATE__c,A_C_Product_Status__c,OTHER_A_C_Product_Status__c,LICENSE_FEE__c,License_fee_Breakdown__c,AGREEMENT_TYPE__c,LICENSE_CATEGORY__c,OTHER_AGREEMENT_TYPE__c,OTHER_LICENSE_CATEGORY__c,DEVICE__c,Simulator_HW_Config__c,OTHER_DEVICE__c,OTHER_Simulator_HW_Config__c,EGPWSim_details__c,OTHER_EGPWSim_details__c,LICENSE_PO_DATE__c,PRODUCT_DESCRIPTION__c,SOFTWARE_LOAD_VERSION__c,PART_NUMBER__c,TECHNICAL_SUPPORT_Hrs__c,TS_Agreement_License__c,HIPI_CONTRACT_NUMBER__c,EXPIRATION_DATE__c,SBU__c,TYPE_OF_INVOICE__c,OTHER_TYPE_OF_INVOICE__c,A_LICENSED_SW__c,B_LICENSED_DATA__c,C_CONFIG_LIST__c,D_other__c,Total_Value_of_Agmt_K_Text__c,Value_in_Q1_K_Text__c,Contract_Term_In_Years__c,Value_in_Q2_K_Text__c,License_Fee_Waived_K_Text__c,Value_in_Q3_K_Text__c,Value_in_Current_Year_Jan_Dec_K__c,Value_in_Q4_K_Text__c,Commission_K_Text__c,Year_2__c,Commission_Agency__c,Year_4__c,Closed_Out_by_IP_Finance__c,Year_3__c,Year_5__c,Revenue_Structure__c,HIPI_Accounts__c from opportunity where id in :lstcaseid];
        
        if(lstopp[0].accountid != null)
        {
            acc=[select id,name,Report_Address_Line_1__c,Report_Address_Line_2__c,Report_Address_Line_3__c,Report_City_Name__c,Report_State_Code__c,Report_Postal_Code__c,Report_Country_Name__c,CBT__c,CBT_Team__c from account where id=:lstopp[0].accountid];
            
            if(acc.name != null)
            accinfo+='Account Name:'+acc.name+'&&&';
            if(acc.CBT__c != null)
            accinfo+='CBT :'+acc.CBT__c+'&&&';
            if(acc.CBT_Team__c != null)
            accinfo+='CBT Team:'+acc.CBT_Team__c+'&&&';
            if(acc.Report_Address_Line_1__c != null)
            accinfo+='Address Line1:'+acc.Report_Address_Line_1__c+'&&&';
            if(acc.Report_Address_Line_2__c != null)
            accinfo+='Address Line2:'+acc.Report_Address_Line_2__c+'&&&';
            if(acc.Report_Address_Line_3__c != null)
            accinfo+='Address Line3:'+acc.Report_Address_Line_3__c+'&&&';
            if(acc.Report_City_Name__c != null)
            accinfo+='City Name:'+acc.Report_City_Name__c+'&&&';
            if(acc.Report_State_Code__c != null)
            accinfo+='State Code:'+acc.Report_State_Code__c+'&&&';
            if(acc.Report_Postal_Code__c != null)
            accinfo+='Postal Code:'+acc.Report_Postal_Code__c+'&&&';
            if(acc.Report_Country_Name__c != null)
            accinfo +='Country Name:'+acc.Report_Country_Name__c+'';
        }
                
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
            resBody = '{"access_token":"00Dc0000003kOJt!ARIAQAm6ceQGeloxsMyLmmPPj_ZM3VOVkR8mVR7jR03ML1jq.YV9iU3AMwk94Gnfqx4EaFBjgOpIHyoLfbc9o7CjaqYH.Hhx","instance_url":"https://cs42.salesforce.com","id":"https://test.salesforce.com/id/00Dc0000003kOJtEAQ/005a0000009Lhn6AAC","token_type":"Bearer","issued_at":"1453358389670","signature":"OkGVCiTOySRyf6hJ5A8rfoauHsZCGse4AGQkQZtqRq4="}';
            resMsg = 'ok';
        }
        OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(resBody, OAuth2.class);         
        HttpRequest req1 = new HttpRequest();
        Map<string,RestAPIEndPoint__c> mapEndPointURLs = new Map<String,RestAPIEndPoint__c>();
        mapEndPointURLs = RestAPIEndPoint__c.getAll();        
        if(mapEndPointURLs.size()>0)
        {
            
            req1.setEndpoint(mapEndPointURLs.get('CreateOpportunityEndPointURL1').EndPointURL__c); 
        }
        req1.setHeader('Content-Type','application/json;charset=UTF-8');
        req1.setHeader('Authorization','Bearer '+objAuthenticationInfo.access_token);        
        req1.setMethod('POST');
        HttpResponse res1 = new HttpResponse();
        Http httpCall1 = new Http();             
        for(opportunity opp:lstopp){
            
            boolean RequestContractNumber;
            string contracttype='';
            string subtype='';
            string AttorneySBG='';
            string HONLeadIPAttorney='';
            string IsTLCApprovalRequired='NO';
            string ArePatentsInvolved ='';
            string DealPhase='';
            string DealStatus='';
            string Country='';
            string Region='';
            string Licensee='';
            string ContractTitle='';
            string BusinessContact='';
            string Licensor='';
            string closeddate;
            //string oppowneremail='';
            string OpportunityNumber='';
            string TotalValueofAgmtKText='';
            string ContractTermInYears='';
            string CorpHIPIOpportunityNumber='';
            string ValueinCurrentYear ='';
            string ValueinQ1KText='';
            string ValueinQ2KText='';
            string ValueinQ3KText='';
            string ValueinQ4KText='';
            string Year2='';
            string Year3='';
            string Year4='';
            string Year5='';
            string comments='';
            string account='';
            string CBT='';
            string CBTTeam='';
            string HIPICONTRACTNUMBER='';
            if(opp.Request_Contract_Number__c == true)
            {
                RequestContractNumber=opp.Request_Contract_Number__c;
            }
            else
            {
                RequestContractNumber=false;
            }
            if(opp.HIPI_CONTRACT_NUMBER__c != null)
            HIPICONTRACTNUMBER=opp.HIPI_CONTRACT_NUMBER__c;
            if(opp.Contract_Type__c != null)
            contracttype=opp.Contract_Type__c;
            if(opp.contract_sub_type__c != null)
            subtype=opp.contract_sub_type__c;
            system.debug('contractsubtype------>'+subtype);
            /*if(opp.Attorney_SBG__c != null)
            AttorneySBG=opp.Attorney_SBG__c;
            if(opp.HON_Lead_IP_Attorney__c != null)
            HONLeadIPAttorney=opp.HON_Lead_IP_Attorney__c;*/
            
            if(opp.StageName != null)
            DealPhase=opp.StageName;
            if(opp.Deal_Status__c != null)
            DealStatus=opp.Deal_Status__c;
            if(opp.Country__c != null)
            Country=opp.Country__c;
            if(opp.Region1__c != null)
            Region=opp.Region1__c;
            if(opp.Business_Contact__c != null)
            BusinessContact=opp.Business_Contact__c;
            if(opp.Contract_Title__c != null)
            ContractTitle=opp.Contract_Title__c;
            if(opp.Licensee__c != null)
            Licensee=opp.Licensee__c;
            if(opp.Are_Patents_Involved__c != null)
            ArePatentsInvolved=opp.Are_Patents_Involved__c;
            if(opp.Licensor__c != null)
            Licensor=opp.Licensor__c;
            if(opp.Opportunity_Number__c != null)
            OpportunityNumber=opp.Opportunity_Number__c;
            /*if(opp.Opportunity_Owner_Email_Address__c != null)
            oppowneremail=opp.Opportunity_Owner_Email_Address__c;*/
            if(opp.Corp_HIPI_Opportunity_Number__c != null)
            CorpHIPIOpportunityNumber=opp.Corp_HIPI_Opportunity_Number__c;
            if(opp.Total_Value_of_Agmt_K_Text__c != null)
            TotalValueofAgmtKText=opp.Total_Value_of_Agmt_K_Text__c;
            if(opp.Contract_Term_In_Years__c != null)
            ContractTermInYears=string.valueof(opp.Contract_Term_In_Years__c);
            if(opp.Value_in_Current_Year_Jan_Dec_K__c != null)
            ValueinCurrentYear=opp.Value_in_Current_Year_Jan_Dec_K__c;
            if(opp.Value_in_Q1_K_Text__c != null)
            ValueinQ1KText=opp.Value_in_Q1_K_Text__c;
            if(opp.Value_in_Q2_K_Text__c != null)
            ValueinQ2KText=opp.Value_in_Q2_K_Text__c;
            if(opp.Value_in_Q3_K_Text__c != null)
            ValueinQ3KText=opp.Value_in_Q3_K_Text__c;
            if(opp.Value_in_Q4_K_Text__c != null)
            ValueinQ4KText=opp.Value_in_Q4_K_Text__c;
            if(opp.Year_2__c != null)
            Year2=string.valueof(opp.Year_2__c);
            if(opp.Year_3__c != null)
            Year3=string.valueof(opp.Year_3__c);
            if(opp.Year_4__c != null)
            Year4=string.valueof(opp.Year_4__c);
            if(opp.Year_5__c != null)
            Year5=string.valueof(opp.Year_5__c);
            if(opp.CloseDate != null)
            closeddate=string.valueof(opp.CloseDate);
            if(opp.Comments__c != null)
            comments=opp.Comments__c; 
            if(opp.HIPI_Accounts__c != null)
            account=opp.HIPI_Accounts__c;
            if(opp.CBT_HIPI__c!= null)
            CBT=opp.CBT_HIPI__c;
            if(opp.CBT_Team_HIPI__c!= null)
            CBTTeam=opp.CBT_Team_HIPI__c;
            
            String body = '{"Name":"'+opp.name +'","ContractType":"'+contracttype+'","CBT":"'+CBT+'","CBTTeam":"'+CBTTeam+'","ArePatentsInvolved":"'+ArePatentsInvolved+'","Country":"'+Country+'","Region":"'+Region+'","BusinessContact":"'+BusinessContact+'","ContractTitle":"'+ContractTitle+'","Licensee":"'+Licensee+'","RequestContractNumber":"'+RequestContractNumber+'","DealPhase":"'+DealPhase+'","DealStatus":"'+DealStatus+'","Licensor":"'+Licensor+'","OpportunityNumber":"'+OpportunityNumber+'","CorpHIPIOpportunityNumber":"'+CorpHIPIOpportunityNumber+'","TotalValueofAgmtKText":"'+TotalValueofAgmtKText+'","ContractTermInYears":"'+ContractTermInYears+'","ValueinCurrentYear":"'+ValueinCurrentYear+'","ValueinQ1KText":"'+ValueinQ1KText+'","ValueinQ2KText":"'+ValueinQ2KText+'","ValueinQ3KText":"'+ValueinQ3KText+'","ValueinQ4KText":"'+ValueinQ4KText+'","Year2":"'+Year2+'","Year3":"'+Year3+'","Year4":"'+Year4+'","Year5":"'+Year5+'","closeddate":"'+closeddate+'","comments":"'+comments+'","subtype":"'+subtype+'","account":"'+account+'","HIPICONTRACTNUMBER":"'+HIPICONTRACTNUMBER+'"}';
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
                List<string> FileNames = new List<String>();
                string Filename1;
                string Filename2;
                string Filename3;
                JSONParser parser = JSON.createParser(res1.getBody());   //Pass your response string here    
                System.debug('parser>>>>>>'+ parser);
                while(parser.nextToken() != null) 
                {
                    System.debug('Parser1>>');
                    System.debug('parser.getCurrentToken>>'+parser.getCurrentToken());
                    System.debug('JSONToken.FIELD_NAME>>'+JSONToken.FIELD_NAME);
                    System.debug('JSONToken.VALUE_STRING>>'+JSONToken.VALUE_STRING);              
                    String fieldName1 = parser.getText();
                    System.debug('BeforeFields1>>'+fieldName1);
                    if (parser.getCurrentToken() == JSONToken.START_ARRAY){ 
                        String fieldName2 = parser.getText();
                        System.debug('BeforeFields2>>'+fieldName2);  
                        while(parser.nextToken() != null){
                            String fieldName3 = parser.getText();
                            System.debug('BeforeFields3>>'+fieldName3);                                
                            String fieldName = parser.getText();
                            if (fieldName3 == 'Opportunity_Number__c') {
                                parser.nextToken();
                                Filename1 = parser.getText();
                                FileNames.add(FileName1);                    
                                System.debug('Filename Type>>'+Filename1);
                                System.debug('FileNames1>>'+FileNames); 
                                if(FileName1!=Null){
                                    opp.Corp_HIPI_Opportunity_Number__c=FileName1;                                  
                                    updateopp.add(opp);
                                    update updateopp;
                                }
                            }                           
                        }
                    }    
                }                
            }            
        }
        JSONParser parser = JSON.createParser(resBody1);           
    }    
}