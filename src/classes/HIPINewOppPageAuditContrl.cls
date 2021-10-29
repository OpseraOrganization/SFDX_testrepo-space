/********************
Created By: NTTDATA
Use : This controller is used for creating Opportunity Page.
*********************/
public with sharing class HIPINewOppPageAuditContrl {
    public HIPINewOppPageAuditContrl() {
    }
    public Opportunity Opp {get;set;} 
    Public String recordtypename{set;get;}
    public String GetKeyPrefix {get;set;}
    public Boolean isOtherOEM {get;set;}
    
    String OppyId= ApexPages.currentPage().getParameters().get('id');         
    public HIPINewOppPageAuditContrl(ApexPages.StandardController controller) { 
        isOtherOEM = false;      
        Opp = new Opportunity();
        Opportunity opp1 = new Opportunity();        
        try
        { 
            ID recid = Opp1.RecordTypeID;
            Recordtype Rectype =[Select id,name,developername from RecordType where sObjecttype='Opportunity' AND  id =: ApexPages.currentPage().getParameters().get('recTypeId') ];
            User u = [select id,firstname from user where id=:userinfo.getuserid()];            
            recordtypename = Rectype.Name;         
            Opp.RecordTypeID = ApexPages.currentPage().getParameters().get('recTypeId');  
            Opp.Name = null;
            Opp.Probability = null ;       
            Opp.If_Licensor_Other_Please_Specify__c= null ;
            Opp.Attorney_SBG__c='AER' ;
            Opp.Licensee__c=null ;
            Opp.LICENSEE_ADDRESS__c=null;
            Opp.HON_Lead_IP_Attorney__c= 'Abeyta A.';
            Opp.Contract_Type__c= '' ;
            Opp.If_Other_Enter_the_Name_of_Attorney__c= null ;
            Opp.Contract_Title__c=null ;
            //Opp.Account_Contact_Name__c= null ;
            Opp.ATP_Approval_Date__c= null  ;
            Opp.If_Restated_Prior_Contract_Number__c= null   ;
            Opp.ATN_Approval_Date__c= null    ;
            Opp.Are_Patents_Involved__c = 'No' ;
            Opp.List_All_Patent_s_Country_i_e_US__c=null ;
            Opp.Brand__c='' ;
            Opp.Agmt_Subject_to_Export_Control__c='' ;
            Opp.If_Brand_Other_Please_Specify__c=null ;
            Opp.Agmts_Contains_Export_Controlled_Data__c='' ;
            Opp.DOS_Approval_Required__c= false ;
            Opp.DOS_Expiration_Date__c= null  ;
            Opp.DOS_Number__c= null  ;
            Opp.Automatic_Renewal__c='' ;
            Opp.Country__c='';
            Opp.Notice_Period_in_Days__c= null;
            Opp.Licensee_URL__c= null    ;
            Opp.Owner_SBG__c='AER' ;
            Opp.Include_in_Weekly_Updates__c='' ;
            Opp.Comments__c= null ;                
            Opp.Revenue_Structure__c= null;
            Opp.Value_in_Q1_K_Text__c=null;
            Opp.Value_in_Q2_K_Text__c=null;
            Opp.Value_in_Q3_K_Text__c=null;
            Opp.Contract_Term_In_Years__c=null;
            Opp.Value_in_Q4_K_Text__c=null;
            Opp.License_Fee_Waived_K_Text__c= null  ;
            Opp.Value_in_Current_Year_Jan_Dec_K__c= null ;
            Opp.Commission_K_Text__c= null ;
            Opp.Commission_Agency__c=null  ;         
            opp.Deal_Status__c='';
            opp.SBG__c='AERO';
            opp.HIPI_SBU__c='BGA';
            opp.Allocation_13__c=100;
            opp.Type_13__c='Ground Support Solutions';
            opp.Line_13__c='Ground Support Solutions';
            //opp.Request_Credit_Review__c=false;
            opp.Request_Contract_Number__c=true;
            opp.Received_TLC_Approvals__c=null;
            opp.Credit_Rating_Comments__c='';
            opp.Closed_Out_by_IP_Finance__c=null;
            opp.Contract_Number__c='';
            opp.StageName='';
            opp.Deal_Status__c='';
            opp.CloseDate=Null;
            opp.Licensor__c='HII';
            opp.ownerid=u.id;
            opp.BusinessContact__c=u.id;
            system.debug('inside change deal status------>'+Opp.StageName); 
        }
        Catch(Exception e){}
    }         
    //This Method is for getting Unique Licensee Names
    public Void changelicensee() {   
        Opp.Licensee__c = opp.HIPI_Accounts__c;
        system.debug('----->Main Class: '+opp.HIPI_Accounts__c);
        system.debug('----->Main Class: '+opp.Licensee__c);
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
            resBody = '{"access_token":"00Dc0000003kOJt!ARIAQAm6ceQGeloxsMyLmmPPj_ZM3VOVkR8mVR7jR03ML1jq.YV9iU3AMwk94Gnfqx4EaFBjgOpIHyoLfbc9o7CjaqYH.Hhx","instance_url":"https://cs14.salesforce.com","id":"https://test.salesforce.com/id/00Dc0000003kOJtEAQ/005a0000009Lhn6AAC","token_type":"Bearer","issued_at":"1453358389670","signature":"OkGVCiTOySRyf6hJ5A8rfoauHsZCGse4AGQkQZtqRq4="}';
            resMsg = 'ok';
        }
        OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(resBody, OAuth2.class);         
        HttpRequest req1 = new HttpRequest();
        Map<string,RestAPIEndPoint__c> mapEndPointURLs = new Map<String,RestAPIEndPoint__c>();
        mapEndPointURLs = RestAPIEndPoint__c.getAll();        
        if(mapEndPointURLs.size()>0)
        {
            
            req1.setEndpoint(mapEndPointURLs.get('CreateOpportunityEndPointURL2').EndPointURL__c); 
        }
        req1.setHeader('Content-Type','application/json;charset=UTF-8');
        req1.setHeader('Authorization','Bearer '+objAuthenticationInfo.access_token);        
        req1.setMethod('POST');
        HttpResponse res1 = new HttpResponse();
        Http httpCall1 = new Http();             
        if(opp.HIPI_Accounts__c!=null || Test.isRunningTest()){
            
            string accname='';           
            accname=opp.HIPI_Accounts__c;           
            String body = '{"HIPIAccountName":"'+opp.HIPI_Accounts__c +'"}';
            system.debug('body----->'+body);
            req1.setBody(body);                    
            try{
                if(!Test.isRunningTest()){
                    res1 = httpCall1.send(req1);
                    resBody1 = res.getbody();
                }
                else{
                    resBody1 = '[{"attributes":{"type":"HIPI_Account_Address__c","url":"/services/data/v36.0/sobjects/HIPI_Account_Address__c/a4t14000000g8LlAAI"},"Address_Name__c":"351 CLIFF ROAD","Address_Line_1__c":"-","Address_Line_2__c":"-","City__c":"BURNSVILLE","State__c":"Minnesota","Telephone__c":"952-894-4694","Type__c":"Legal","Account__c":"0011400001dI2CxAAK","Id":"a4t14000000g8LlAAI"}]';
                }
            }
            catch(exception ex){
                system.debug('inside exceptiom'+ex.getMessage());               
            }
            if(resMsg =='ok')
            {
                String FileNames ='';
                string Filename1;
                string Filename2;
                string Filename3;
                string Filename4;
                string Filename5;
                string Filename6;
                string Filename7;
                JSONParser parser;
                system.debug('res1body---'+res1.getBody());              
                if(!Test.isRunningTest()){
                    parser = JSON.createParser(res1.getBody());   //Pass your response string here    
                }
                else{
                    parser = JSON.createParser(resBody1);   //Pass your response string here    
                }
                
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
                                if (fieldName == 'Address_Name__c') {
                                    parser.nextToken();                                   
                                    Filename1 = parser.getText();
                                    if(Filename1!=null && Filename1!='' )
                                    FileNames+= Filename1+',';                   
                                    System.debug('Filename Type>>'+Filename1);
                                    System.debug('FileNames1>>'+FileNames);
                                    }
                                    else if (fieldName == 'Address_Line_1__c') {
                                        parser.nextToken();
                                        Filename2 = parser.getText();
                                        if(Filename2!=null && Filename2!='' )
                                        System.debug('Filename Type>>'+Filename2);
                                        FileNames+= Filename2+',';
                                        }
                                        else if (fieldName == 'Address_Line_2__c') {
                                            parser.nextToken();
                                            Filename3 = parser.getText();
                                            if(Filename3!=null && Filename3!='' )
                                            System.debug('Filename Type>>'+Filename3);
                                            FileNames+= Filename3+',';
                                            }
                                            else if (fieldName == 'City__c') {
                                                parser.nextToken();
                                                Filename4 = parser.getText();
                                                if(Filename4!=null && Filename4!='' )
                                                FileNames+= Filename4+',';
                                                System.debug('Filename Type>>'+Filename4);
                                                }
                                                else if (fieldName == 'State__c') {
                                                    parser.nextToken();
                                                    Filename5 = parser.getText();
                                                    if(Filename5!=null && Filename5!='' )
                                                    FileNames+= Filename5+',';
                                                    System.debug('Filename Type>>'+Filename5);
                                                    }
                                                    else if (fieldName == 'Telephone__c') {
                                                         parser.nextToken();
                                                         Filename6 = parser.getText();
                                                         if(Filename6!=null && Filename6!='' )
                                                         FileNames+= Filename6+',';
                                                         System.debug('Filename Type>>'+Filename6);
                                                         }
                                                         else if (fieldName == 'Type__c') {
                                                             parser.nextToken();
                                                             Filename7 = parser.getText();
                                                             if(Filename7!=null && Filename7!='' )
                                                             FileNames+= Filename7;
                                                             System.debug('FileNames>>'+ Filename7);
                                                             System.debug('FileNames>>'+ FileNames);
                                                             opp.LICENSEE_ADDRESS__c=FileNames;
                                                             System.debug('FileNames>>'+ FileNames);                                                              
                                                            }
    
                        }   
                    }
                }    
            } 
        JSONParser parser = JSON.createParser(resBody1);                       
        }            
    }
    public String OEM {get;set;}
    public string setOEM() {
        Opp.OEM__c = OEM;
        return OEM;
    }
    public Void changelicenseePlatform() {
        //Opp.OEM__c = opp.Platform__c;
        /*Platform__c pl=[select id,name,OEM_Name__c,OEM_Name__r.name from Platform__c where id=:opp.Platform__c];
        OEM=pl.OEM_Name__r.name;   
        */
        isOtherOEM = false;
        string Name =opp.Aircraft_Platform__c;      
        OEM = MPMAircraftPlatform__c.getvalues(Name).OEM__c;  
        if(opp.Aircraft_Platform__c != null && opp.Aircraft_Platform__c.containsIgnoreCase('Other'))
        {
            isOtherOEM = true;  
        }
    }   
    public Void changedealstatus() {
        system.debug('inside change deal status$$'+Opp.StageName);    
        if(Opp.StageName == 'Closed Won' || Opp.StageName == 'Closed Lost')
        {
            system.debug('inside change deal status'+Opp.StageName);
            try{                                                
                Opp.Deal_Status__c = Opp.StageName;
                system.debug('dealstatus'+Opp.Deal_Status__c);
            }
            Catch(Exception e){} 
        }       
    }
    Date today1 = date.valueof(system.today()); 
    //Public string AircraftName; 
    public pagereference CustomSave()
    {       
        string RecordTypeId = ApexPages.currentPage().getParameters().get('recTypeId');
        system.debug('Record Type Id ' +  RecordTypeId );
        string RecTypName =  [Select Name From RecordType Where ID =: RecordTypeId][0].Name;
        system.debug('Record Type Name ' +  RecTypName );
        
        opp.recordtypeid =  RecordTypeId ;
        system.debug('inside custom save ' +  Opp);
         system.debug('inside custom save stage name' +  Opp.StageName);
        if(Opp.StageName == 'Closed Won' || Opp.StageName == 'Closed Lost')
        {                                                
            Opp.Deal_Status__c = Opp.StageName;
        }
        string name='';
        /*if(Opp.Platform__c!=null )
        {
            Platform__c pl=[select id,name,OEM_Name__c,OEM_Name__r.name from Platform__c where id=:opp.Platform__c];
            if(pl.name != null)
            {
               Name+=pl.name;
            }
            Opp.OEM__c = pl.OEM_Name__r.name;   
        }  
        */
        if(opp.Aircraft_Platform__c !=null ){      
        string AircraftName =opp.Aircraft_Platform__c;      
        OEM = MPMAircraftPlatform__c.getvalues(AircraftName).OEM__c; 
        Opp.OEM__c =OEM; 
        //if(opp.Aircraft_Platform__c !='Other'){
        if(!opp.Aircraft_Platform__c.contains('Other')){
        Name+=opp.Aircraft_Platform__c+'_';
        }
        } 
        if(opp.OTHER_Aircraft_Platform__c!=null){
        Name+=opp.OTHER_Aircraft_Platform__c+'_';
        }   
            
        if(opp.CUSTOMER_DEVICE_TYPE__c!=null && opp.CUSTOMER_DEVICE_TYPE__c!= '')
        {
            if(Name != null)
            {
                Name+= '_'+opp.CUSTOMER_DEVICE_TYPE__c; 
            }
            else
            {
                Name+= opp.CUSTOMER_DEVICE_TYPE__c;
            }
        }   
        /* if(opp.PRODUCT_DESCRIPTION__c!=null && opp.PRODUCT_DESCRIPTION__c!= '')
        {
            if(Name != null)
            {
                Name+= '_'+opp.PRODUCT_DESCRIPTION__c; 
            }
            else
            {
                Name+=opp.PRODUCT_DESCRIPTION__c; 
            }
        }   */     
        if(opp.Products__c !=null && opp.Products__c != '')
        {
            if(Name != null)
            {
                //if(opp.Products__c != 'Other'){
                if(!opp.Products__c.contains('Other')){
                    Name+= '_'+opp.Products__c ;
                }                
            }
            else
            {
                Name+=opp.Products__c; 
            }
        }  
         if(opp.Other_Products__c!=null && opp.Other_Products__c!= '')
        {
          if(Name != null)
            {
                Name+= '_'+opp.Other_Products__c; 
            }
            else
            {
                Name+=opp.Other_Products__c; 
            }
        }  
        if(opp.EPIC__c !=null && opp.EPIC__c != '')
        {
            if(Name != null)
            {
                if(!opp.EPIC__c.contains('Other')){
                    Name+= '_'+opp.EPIC__c;
                }                
            }
            else
            {
                Name+=opp.EPIC__c; 
            }
        } 
         if(opp.Other_category_of_IP__c !=null && opp.Other_category_of_IP__c != '')
        {
          if(Name != null)
            {
                Name+= '_'+opp.Other_category_of_IP__c ; 
            }
            else
            {
                Name+=opp.Other_category_of_IP__c; 
            }
        }  
              
        if(opp.EGPWSim_details__c !=null && opp.EGPWSim_details__c!= '')
        {
            if(Name != null)
            {
                Name+= '_'+opp.EGPWSim_details__c; 
            }
            else
            {
                Name+=opp.EGPWSim_details__c; 
            }
        }       
        if(opp.SIM_DEVICE_OWNER__c!=null && opp.SIM_DEVICE_OWNER__c!= '')
        {
            if(Name != null)
            {
                Name+= '_'+opp.SIM_DEVICE_OWNER__c; 
            }
            else
            {
                Name+=opp.SIM_DEVICE_OWNER__c; 
            }
        }     
        if(opp.PROJ_JOB_SER__c !=null && opp.PROJ_JOB_SER__c != '')
        {
            if(Name != null)
            {
                Name+= '_'+opp.PROJ_JOB_SER__c; 
            }
            else
            {
                Name+=opp.PROJ_JOB_SER__c; 
            }
        }
        if(opp.TS_Agreement_License__c !=null && opp.TS_Agreement_License__c != '')
        {
            if(Name != null)
            {
                Name+= '_'+opp.TS_Agreement_License__c; 
            }
            else
            {
                Name+=opp.TS_Agreement_License__c+'';
            }
        }       
        if(Name!= null && Name!= ''){
            opp.name = Name;
        }
        else
        {
            apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Info,'Deal Description Name will includes Platform,Customer Device type, Product Description, EGPWSim,Sim Device Owner,QTY of Devices,Proj/Job/Ser#,TS Agreement Number from deal descrption , Please select values');
            apexpages.addmessage(msg);
        }
        if(opp.BusinessContact__c != null)
        {
            user u=[select id,name from user where id=:opp.BusinessContact__c];
            if(u.name != null)
            opp.Business_Contact__c=u.name;
        }
        if(opp.Record_Data_Owner__c != null)
        {
            contact con=[select id,name from contact where id=:opp.Record_Data_Owner__c];
            if(con.name != null)
            opp.Appendix_Review_Engineer_Name__c=con.name;
        }
        if(opp.LicenseDraft__c == true)
        {
            opp.License_Draft__c = today1;
        }
        if(opp.Final_Review__c == true)
        {
            opp.License_Review__c = today1;
        }
        if(opp.Engineer_Manager_Review__c == true)
        {
            opp.Engineer_Manager_Review_Date__c = today1;
        }
        if(opp.WorkbookComplete__c == true)
        {
            opp.Workbook_Complete__c = today1;
        }
        if(opp.Account_manager_review__c == true)
        {
            opp.Account_manager_review_Date__c = today1;
        }
        if(opp.Revenue_Recognized__c == true)
        {
            opp.Revenue_Recognized_Date__c = today1;
        }
        if(opp.Workstop_Issue_Cleared__c == true )
        {
            opp.Workstop_Issue_Cleared_date__c=today1;
        }
        if(opp.InvoiceRequested__c == true )
        {
            opp.Invoice_Requested_date__c=today1;
        } 
        /*if(opp.CUSTOMER_LICENSE_NEED_DATE__c != null && opp.License_Need_date_per_PO__c == Null){
        opp.License_Need_date_per_PO__c = opp.CUSTOMER_LICENSE_NEED_DATE__c;
        } */
        if(opp.License_Need_date_per_PO__c != null && opp.CUSTOMER_LICENSE_NEED_DATE__c == Null){
        opp.CUSTOMER_LICENSE_NEED_DATE__c = opp.License_Need_date_per_PO__c ;   
        }
        try{
        insert Opp;
        }
        catch(Exception e){
        ApexPages.addMessages(e);
        return null;
        }
        return new PageReference('/'+Opp.id);
    }  
    public pagereference saveandnew()
    {   if(Opp.StageName == 'Closed Won' || Opp.StageName == 'Closed Lost')
        {                                                
            Opp.Deal_Status__c = Opp.StageName;
        }
        string name='';
        /*if(Opp.Platform__c!=null )
        {
            Platform__c pl=[select id,name,OEM_Name__c,OEM_Name__r.name from Platform__c where id=:opp.Platform__c];
            if(pl.name != null)
            {
               Name+=pl.name;
            }
            Opp.OEM__c = pl.OEM_Name__r.name;   
        }   
        */
        if(opp.Aircraft_Platform__c !=null){
        Name+=opp.Aircraft_Platform__c+'_';
        string AircraftName =opp.Aircraft_Platform__c;      
        OEM = MPMAircraftPlatform__c.getvalues(AircraftName).OEM__c; 
        Opp.OEM__c =OEM; 
        }       
        if(opp.CUSTOMER_DEVICE_TYPE__c!=null && opp.CUSTOMER_DEVICE_TYPE__c!= '')
        {
            if(Name != null)
            {
                Name+= '_'+opp.CUSTOMER_DEVICE_TYPE__c; 
            }
            else
            {
                Name+= opp.CUSTOMER_DEVICE_TYPE__c;
            }
        }       
      /*  if(opp.PRODUCT_DESCRIPTION__c !=null && opp.PRODUCT_DESCRIPTION__c != '')
        {
            if(Name != null)
            {
                Name+= '_'+opp.PRODUCT_DESCRIPTION__c; 
            }
            else
            {
                Name+=opp.PRODUCT_DESCRIPTION__c; 
            }
        }  */
        if(opp.Products__c !=null && opp.Products__c != '')
        {
            if(Name != null)
            {
                Name+= '_'+opp.Products__c; 
            }
            else
            {
                Name+=opp.Products__c; 
            }
        }  
         if(opp.Other_Products__c!=null && opp.Other_Products__c!= '')
        {
          if(Name != null)
            {
                Name+= '_'+opp.Other_Products__c; 
            }
            else
            {
                Name+=opp.Other_Products__c; 
            }
        }  
        if(opp.EPIC__c !=null && opp.EPIC__c != '')
        {
            if(Name != null)
            {
                if(!opp.EPIC__c.contains('Other')){
                    Name+= '_'+opp.EPIC__c;
                }                
            }
            else
            {
                Name+=opp.EPIC__c; 
            }
        } 
         if(opp.Other_category_of_IP__c !=null && opp.Other_category_of_IP__c != '')
        {
          if(Name != null)
            {
                Name+= '_'+opp.Other_category_of_IP__c ; 
            }
            else
            {
                Name+=opp.Other_category_of_IP__c; 
            }
        }              
        if(opp.EGPWSim_details__c !=null && opp.EGPWSim_details__c!= '')
        {
            if(Name != null)
            {
                Name+= '_'+opp.EGPWSim_details__c; 
            }
            else
            {
                Name+=opp.EGPWSim_details__c; 
            }
        }       
        if(opp.SIM_DEVICE_OWNER__c!=null && opp.SIM_DEVICE_OWNER__c!= '')
        {
            if(Name != null)
            {
                Name+= '_'+opp.SIM_DEVICE_OWNER__c; 
            }
            else
            {
                Name+=opp.SIM_DEVICE_OWNER__c; 
            }
        }      
        if(opp.PROJ_JOB_SER__c !=null && opp.PROJ_JOB_SER__c != '')
        {
            if(Name != null)
            {
                Name+= '_'+opp.PROJ_JOB_SER__c; 
            }
            else
            {
                Name+=opp.PROJ_JOB_SER__c; 
            }
        }
        if(opp.TS_Agreement_License__c !=null && opp.TS_Agreement_License__c != '')
        {
            if(Name != null)
            {
                Name+= '_'+opp.TS_Agreement_License__c; 
            }
            else
            {
                Name+=opp.TS_Agreement_License__c+'';
            }
        }      
        if(Name!= null && Name!= ''){
            opp.name = Name;
        }
        else
        {
            apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Info,'Deal Description Name will includes Platform,Customer Device type, Product Description, EGPWSim,Sim Device Owner,QTY of Devices,Proj/Job/Ser#,TS Agreement Number from deal descrption , Please select values');
            apexpages.addmessage(msg);
        }
        if(opp.BusinessContact__c != null)
        {
            user u=[select id,name from user where id=:opp.BusinessContact__c];
            if(u.name != null)
            opp.Business_Contact__c=u.name;
        }
        if(opp.Record_Data_Owner__c != null)
        {
            contact con=[select id,name from contact where id=:opp.Record_Data_Owner__c];
            if(con.name != null)
            opp.Appendix_Review_Engineer_Name__c=con.name;
        }
        if(opp.LicenseDraft__c == true)
        {
            opp.License_Draft__c = today1;
        }
        if(opp.Final_Review__c == true)
        {
            opp.License_Review__c = today1;
        }
        if(opp.Engineer_Manager_Review__c == true)
        {
            opp.Engineer_Manager_Review_Date__c = today1;
        }
        if(opp.WorkbookComplete__c == true)
        {
            opp.Workbook_Complete__c = today1;
        }
        if(opp.Account_manager_review__c == true)
        {
            opp.Account_manager_review_Date__c = today1;
        }
        if(opp.Revenue_Recognized__c == true)
        {
            opp.Revenue_Recognized_Date__c = today1;
        }
        if(opp.Workstop_Issue_Cleared__c == true )
        {
            opp.Workstop_Issue_Cleared_date__c=today1;
        }     
        if(opp.InvoiceRequested__c == true )
        {
            opp.Invoice_Requested_date__c=today1;
        }      
        try
        {
        insert Opp;
        }
        catch(Exception e){
        ApexPages.addMessages(e);
        return null;
        }                 
        PageReference pageRef = new PageReference(label.M_PM_Page_Reference);       
        pageRef.setRedirect(true);
        return pageRef;
    }
    public void reset(){
        Opp = new Opportunity();
    }  
    public pagereference Cancel(){                 
        return new pagereference(label.M_PM_Cancel_Page_Reference);       
    }
    
     
}