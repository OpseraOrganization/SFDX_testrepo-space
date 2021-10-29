public without sharing class TSS_Community_CaseCreate_Cont {

    //Case creation fields
    public string Inquiry_Type_Details_var{get;set;}
    public string Aircraft_TypeId_var{get;set;}
    public string ATA_Chapter_var{get;set;}
    public string Product_TypeId_var{get;set;}
    public string Part_Number_var{get;set;}
    public string Subject_Id_var{get;set;}
    public string Description_Id_var{get;set;}
    
    public attachment Case_Attachment{get;set;}
    
    
    public TSS_Community_CaseCreate_Cont(){
        Case_Attachment = new Attachment();
    }
    
    public Pagereference CreateCase() {  
    
        system.debug('Inquiry_Type_Details_var--->'+ Inquiry_Type_Details_var);  
        system.debug('Aircraft_TypeId_var--->'+ Aircraft_TypeId_var);  
        system.debug('ATA_Chapter_var--->'+ ATA_Chapter_var);  
        system.debug('Product_TypeId_var--->'+ Product_TypeId_var);  
        system.debug('Part_Number_var--->'+ Part_Number_var);  
        system.debug('Subject_Id_var--->'+ Subject_Id_var);  
        system.debug('Description_Id_var--->'+ Description_Id_var);  
    
        Case c = new case();
        List<Case> CaseList = new list<Case>();
        id mechid;
        id Elecid;  
        
        user u = [select id,contactid,User.Profile.Name from user where id =:userinfo.getUserId() limit 1];
        
        if(!u.Profile.Name.contains('System Administrator')) {
            contact con = [select id,accountid from contact where id =:u.contactid Limit 1];
            // Fetching Account team begins
            if (string.valueOf(con.accountid) != '') {
               List<AccountTeamMember> actmem = [select id,userid,AccountId,TeamMemberRole from AccountTeamMember where accountid =:con.accountid];
                for(AccountTeamMember act: actmem) {
                    if (string.valueOf(act.TeamMemberRole).contains('Field Service Engineer (FSE) - Mech')) {
                        mechid = act.userid;                   
                    }
                    if (string.valueOf(act.TeamMemberRole).contains('Field Service Engineer (FSE) - Elect')) {
                        Elecid = act.userid;
                    }
                }            
            }
            // Fetching Account team ends
        }
        if(Product_TypeId_var != null && Product_TypeId_var != '' && Product_TypeId_var != 'undefined') {
            Supported_Products__c sp = [select id,Product_type__c from Supported_Products__c where id =: Product_TypeId_var limit 1];
            
            if(sp.Product_type__c != null && sp.Product_type__c != '') {  
                if (string.valueOf(SP.Product_type__c).contains('Electrical')) {
                    c.Sub_Class__c = 'Electrical(GTO)';
                   // c.Supported_Products__c = Product_TypeId_var;
                    system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@Electrical(GTO)'+c.Sub_Class__c);
                }
                else if(string.valueOf(SP.Product_type__c).contains('Mechanical')) {
                    c.Sub_Class__c = 'Mechanical(GTO)';
                    c.Supported_Products__c = Product_TypeId_var;
                    system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@Mechanical(GTO)'+c.Sub_Class__c);
                }
                c.Supported_Products__c = Product_TypeId_var;
            }
        }
        c.RecordtypeId = Label.SSCommunity_Technical_Issue;
        c.Classification__c = 'GTO Field Service'; 
        if(!u.Profile.Name.contains('System Administrator')) {
            c.ContactID = u.contactId;
            system.debug('1111111111111111111111111111'+c.ContactID);
        }
        if(Part_Number_var != null && Part_Number_var != '' && Part_Number_var != 'undefined') {
            c.Part_Number__c = Part_Number_var;
        }
        if(Subject_Id_var != null && Subject_Id_var != '' && Subject_Id_var != 'undefined') {
            c.Subject = Subject_Id_var;
        }
        if(Description_Id_var != null && Description_Id_var != '' && Description_Id_var != 'undefined') {
            c.Description = Description_Id_var;
        }
        c.Origin = 'Web';
        
        
        // Assigning Owner begins
        if(c.Sub_Class__c != null && c.Sub_Class__c != '') {
            if(c.Sub_Class__c == 'Electrical(GTO)') {
                    if(string.valueOf(elecid) != '' && string.valueOf(elecid) != null && !u.Profile.Name.contains('System Administrator')) {
                        c.ownerid = elecid;
                        system.debug('22222222222222222222222222222222222222 c.ContactID '+c.ContactID);
                    }
                else {
                    c.ownerid = Label.SSCommunity_TOC_Elect_Team_ID;   //TOC Elect Team
                    system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! TOC Elect Team');
                }
            }
            if(c.Sub_Class__c == 'Mechanical(GTO)') {
                    if (string.valueOf(mechid) != '' && string.valueOf(mechid) != null && !u.Profile.Name.contains('System Administrator')) {
                        c.ownerid = mechid;
                    }           
               else {
                   c.ownerid = Label.SSCommunity_TOC_Mech_Team_ID;    //TOC Mech Team
               } 
            }
        }
        else {
            c.ownerid = Label.SSCommunity_TOC_Team_ID;
        }
        // Assigning Owner ends
        
        c.Detail_Class__c = Inquiry_Type_Details_var;
        if(Aircraft_TypeId_var != null && Aircraft_TypeId_var != '' && Aircraft_TypeId_var != 'undefined'){
            c.Aircraft_Type__c = Aircraft_TypeId_var;
        }
        c.ATA_Chapter__c = ATA_Chapter_var;
        
        Savepoint spt = Database.setSavepoint();
        
        try{
            if(Case_Attachment.Name == null && Case_Attachment.Body == null) {
                system.debug('RRRRRRRRRRRRRRRRRRRRRRR');
                insert c;
            }
            else if(Case_Attachment.Name != null && Case_Attachment.Body != null){ 
                if(Case_Attachment.Body.size() < 10000000) { 
                    insert c;
                    Case_Attachment.parentid = c.id;
                    insert Case_Attachment;     
                    Case_Attachment = null;
                }
                else {
                    PageReference errorOnPage = new PageReference('/apex/TSSCCreateCase?error=2');
                    errorOnPage.setRedirect(true);
                }
            }
        
           /* insert c;
            if(Case_Attachment.Name != null && Case_Attachment.Body != null){       
                Case_Attachment.parentid = c.id;
                insert Case_Attachment;     
                Case_Attachment = null;
            }
            */
        }catch(Exception ex){
            Database.rollback(spt);
            PageReference errorOnPage = new PageReference('/apex/TSSCCreateCase?error=1');
            errorOnPage.setRedirect(true);
            return errorOnPage;
        }
        PageReference pageCases = new PageReference('/apex/TSSCommunityCases');
        pageCases.setRedirect(true);
        
        return pageCases;
    }

    // Get inquiry type method
    @RemoteAction
    Public static List<SelectOption> GetInquiryTypeVal() {
        string selectVal = 'Technical Inquiry';
        List<SS_Community_Case_Setting__c> Inquirylist = [select Inquiry_Type_Detail__c,Webform_Inquiry_Type__c,Web_Product_Type__c from SS_Community_Case_Setting__c where Webform_Inquiry_Type__c=: selectVal];
        set<string>it= new set<string>();
        set<string>pt= new set<string>();
        map<string,set<string>>itdmap= new map<string,set<string>>();
        for(SS_Community_Case_Setting__c ecs: Inquirylist) {
            it.add(ecs.Webform_Inquiry_Type__c);
            pt.add(ecs.Web_Product_Type__c);
            set<string>temp= new set<string>();
            if(itdmap.containskey(ecs.Webform_Inquiry_Type__c))
            temp=itdmap.get(ecs.Webform_Inquiry_Type__c);
            temp.add(ecs.Inquiry_Type_Detail__c);
            itdmap.put(ecs.Webform_Inquiry_Type__c,temp);
       }    
       List<SelectOption> options = new List<SelectOption>();
        for(string s: it)
        {
            options.add(new SelectOption(s,s));
        }
       return options;
    }
    
    // Get Inquiry type details method
    @RemoteAction
    Public static List<SelectOption> GetInquiryDetails() {
        string selectVal = 'Technical Inquiry';
        List<SS_Community_Case_Setting__c> Inquirylist = [select Inquiry_Type_Detail__c,Webform_Inquiry_Type__c,Web_Product_Type__c from SS_Community_Case_Setting__c where Webform_Inquiry_Type__c=: selectVal];
        set<string>it= new set<string>();
        set<string>pt= new set<string>();
        map<string,set<string>>itdmap= new map<string,set<string>>();
        for(SS_Community_Case_Setting__c ecs: Inquirylist) {
            it.add(ecs.Webform_Inquiry_Type__c);
            pt.add(ecs.Web_Product_Type__c);
            set<string>temp= new set<string>();
            if(itdmap.containskey(ecs.Webform_Inquiry_Type__c))
            temp=itdmap.get(ecs.Webform_Inquiry_Type__c);
            temp.add(ecs.Inquiry_Type_Detail__c);
            itdmap.put(ecs.Webform_Inquiry_Type__c,temp);
       } 
       List<SelectOption> Newoptions = new List<SelectOption>();
        if(itdmap.get(selectVal)!=null)
        for(string s: itdmap.get(selectVal))
        {
             Newoptions.add(new SelectOption(s,s));
        }
        return Newoptions;      
    }
    
    // Platform Autofill method
    @RemoteAction
    Public Static List<Platform__c> SearchAircraft(string searchTerm) {
        List<Platform__c> PlatformList = Database.Query('Select Id,name from platform__c where Name Like \'%' + String.escapeSingleQuotes(searchTerm) + '%\' ORDER BY Name ASC LIMIT 1000'); 
        return PlatformList;    
    }
    
    // Product Autofill method
    @RemoteAction
    Public static List<Supported_Products__c> SearchProduct(string searchTerm) {
        system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!!'+searchTerm);
        List<Supported_Products__c> SProducts = Database.Query('Select Name,Id,Catalog_Product_Group__c,Comments__c,Contact__c,InActivated_Date__c,Primary__c,Product_Type__c,Product_Type_PAC__c,Secondary__c,Status__c from Supported_Products__c where Name like \'%' + String.escapeSingleQuotes(searchTerm) + '%\' ORDER BY Name ASC LIMIT 1000');
        return SPRoducts;      
    }
    
    // Get ATA Chapter Picklist values method
    @RemoteAction
    public static List<SelectOption> GetATA_Chapter() {
        List<SelectOption> options = new List<SelectOption>();       
        Schema.DescribeFieldResult fieldResult = Case.ATA_Chapter__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple) {
           options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        system.debug(options);
        return options;
    }
    
    // Case Create Method
    /*@RemoteAction
    Public static Case CreateCase(string Inquiry_Type_Details_var,string Product_TypeId_var,string Part_Number_var,
                                  string Subject_Id_var,string Description_Id_var,string Aircraft_TypeId_var,string ATA_Chapter_var) {    
    Case c = new case();
    List<Case> CaseList = new list<Case>();
        id mechid;
        id Elecid;  
        
        user u = [select id,contactid,User.Profile.Name from user where id =:userinfo.getUserId() limit 1];
        
        if(!u.Profile.Name.contains('System Administrator')) {
            contact con = [select id,accountid from contact where id =:u.contactid Limit 1];
            // Fetching Account team begins
            if (string.valueOf(con.accountid) != '') {
               List<AccountTeamMember> actmem = [select id,userid,AccountId,TeamMemberRole from AccountTeamMember where accountid =:con.accountid];
                for(AccountTeamMember act: actmem) {
                    if (string.valueOf(act.TeamMemberRole).contains('Field Service Engineer (FSE) - Mech')) {
                        mechid = act.userid;                   
                    }
                    if (string.valueOf(act.TeamMemberRole).contains('Field Service Engineer (FSE) - Elect')) {
                        Elecid = act.userid;
                    }
                }            
            }
            // Fetching Account team ends
        }
        if(Product_TypeId_var != null) {
            Supported_Products__c sp = [select id,Product_type__c from Supported_Products__c where id =: Product_TypeId_var limit 1];
            if (string.valueOf(SP.Product_type__c).contains('Electrical')) {
                c.Sub_Class__c = 'Electrical(GTO)';
                c.Supported_Products__c = Product_TypeId_var;
                system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@Electrical(GTO)'+c.Sub_Class__c);
            }
            else if(string.valueOf(SP.Product_type__c).contains('Mechanical')) {
                c.Sub_Class__c = 'Mechanical(GTO)';
                c.Supported_Products__c = Product_TypeId_var;
                system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@Mechanical(GTO)'+c.Sub_Class__c);
            }
        }
        c.RecordtypeId = Label.SSCommunity_Technical_Issue;
        c.Classification__c = 'GTO Field Service'; 
        if(!u.Profile.Name.contains('System Administrator')) {
            c.ContactID = u.contactId;
            system.debug('1111111111111111111111111111'+c.ContactID);
        }
        c.Part_Number__c = Part_Number_var;
        c.Subject = Subject_Id_var;
        c.Description = Description_Id_var;
        
        
        // Assigning Owner begins
        if(c.Sub_Class__c == 'Electrical(GTO)') {
                if(string.valueOf(elecid) != '' && string.valueOf(elecid) != null && !u.Profile.Name.contains('System Administrator')) {
                    c.ownerid = elecid;
                    system.debug('22222222222222222222222222222222222222 c.ContactID '+c.ContactID);
                }
            else {
                c.ownerid = Label.SSCommunity_TOC_Elect_Team_ID;   //TOC Elect Team
                system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! TOC Elect Team');
            }
        }
        if(c.Sub_Class__c == 'Mechanical(GTO)') {
                if (string.valueOf(mechid) != '' && string.valueOf(mechid) != null && !u.Profile.Name.contains('System Administrator')) {
                    c.ownerid = mechid;
                }           
           else {
               c.ownerid = Label.SSCommunity_TOC_Mech_Team_ID;    //TOC Mech Team
           } 
        }
        // Assigning Owner ends
        
        c.Detail_Class__c = Inquiry_Type_Details_var;
        c.Aircraft_Type__c = Aircraft_TypeId_var;
        c.ATA_Chapter__c = ATA_Chapter_var;

        insert c;       
        return c;
    }*/
    
    public string fileName {get;set;}
    public blob fileBody {get;set;}
    
     /*End point Url to web service callout*/
    /*private final static String ENP_POINT_URL = 'https://test.salesforce.com/services/oauth2/token';
    //For development and production https://login.salesforce.com/services/oauth2/token
    //And for sandbox https://test.salesforce.com/services/oauth2/token
    private final static String REQUEST_BODY = 'grant_type=password&client_id={0}&client_secret={1}&username={2}&password={3}';
    private final static String USERNAME = 'gsa.apiuser@honeywell.com.qa';
    private final static String PASSWORD = 'gsaapi@2014EFeR2acaUzlsSwPWCzzdQAXc0';
    private final static String CONSUMER_KEY = '3MVG9Y6d_Btp4xp7PGqmkD3T9iA9YrK1xKBhqvy.kbV1l.t5p7DD.Gd27rzoyctl1kS5E7xcSRvkUeUUr7PAB';
    private final static String CONSUMER_SECRET = '3184479236341752248';
    */
    /*@RemoteAction
    public static String getAccessToken(){
        try{
        System.Debug('Inside Get Access Token'+UserInfo.getSessionId());
            HttpRequest req = new HttpRequest();
            req.setEndpoint(ENP_POINT_URL);
            req.setMethod('POST');          
            Blob headerValue = Blob.valueOf(USERNAME + ':' + PASSWORD);
            String authorizationHeader = 'BASIC ' +
            EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader); 
            req.setBody(String.format(REQUEST_BODY ,new string[]{CONSUMER_KEY,CONSUMER_SECRET,
                                                                 USERNAME,PASSWORD}));
            req.setTimeout(60000);
            Http http = new Http();
            HttpResponse res = http.send(req);
            OAuth objAuthenticationInfo = (OAuth)JSON.deserialize(res.getbody(), OAuth.class);
            return objAuthenticationInfo.access_token;
        }catch(CallOutException ce){
            throw ce;
        }
        return null;
    }*/
    
   
    /*To get aouthentication detail Wrapper*/
    /*public class OAuth{
        public String id{get;set;}
        public String issued_at{get;set;}
        public String instance_url{get;set;}
        public String signature{get;set;}
        public String access_token{get;set;}   
         
    }*/  
    /*public void uploadFile(){
        string endPoint  = 'https://cs15.salesforce.com/services/data/v29.0/sobjects/Attachment';
        
        http ht = new http();
        
        HttpRequest req = new HttpRequest();
        req.setEndPoint(endPoint);
        req.setMethod('POST');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        req.setHeader('Content-Type','application/json');
        req.setTimeout(120000);
        req.setBody('{"ParentId":"500e0000003OcqHAAS","Name":"Test.txt","Body":"dGVzdHR0dHR0dHR0dHR0dHR0dHR0dHR0dHR0dA=="}');
        
        HttpResponse res = ht.send(req);
        System.debug('-------------->' + res.getBody());
    }*/

}