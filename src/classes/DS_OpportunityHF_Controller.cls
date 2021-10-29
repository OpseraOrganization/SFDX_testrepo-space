/*******************************************************************************
Name                :   DS_OpportunityHF_Controller
Created By          :   Suresh M
Company Name        :   NTT Data
Project             :   <Aero> 
Created Date        :   15-02-2021
Usages              :   RAPD-7951: Convert the D&S Clearing House Form to Lightning      
Modification History
*******************************************************************************/
public with sharing class DS_OpportunityHF_Controller {
    public static string caseId = '';    
    @AuraEnabled
    public static wrapperclass getWrapperDetails(String recordId){
        Opportunity opp = new Opportunity();
        if(!String.isEmpty(recordId)){
            opp = [select Name,opportunity_number__c,isClosed,accountid,Account.Name,Type,Description,Tech_Sales__c,Tech_Sales_Product_Area__c,Certification_Requirements__c,Platform__c,Platform__r.Name,
                   Bid_Type_Name__c,Site__c,Site__r.name,Received_Date_at_Clearing_House__c,HAPP_Email__c,Customer_Issue_Date__c,Contract_Type__c,prime_sub__c,Account_Contact_Name__c,Account_Contact_Name__r.Name,
                   Request_Type__c,Solicitation_No__c,Proposal_Due_Date__c,Type_of_Pricing__c,Proposal_Content__c,Revenue_Type__c,Estimated_Proposal_Value__c,
                   HW_SW__c,Comments__c,Account_Name_formula__c,Opportunity_Type__c,Record_Type_Name__c,recordtypeid,recordtype.name,RFP_Expected_Date__c,CBT_Team_Tier_3__c,CBT_Tier_2__c from Opportunity where id=:recordId]; 
        }
        if(opp.Request_Type__c == 'Unsolicited')
        {            
            opp.Solicitation_No__c = 'Unsolicited';
        }
        opp.Received_Date_at_Clearing_House__c=system.today();        
        opp.RFP_Expected_Date__c=null;
        opp.HW_SW__C='';
        opp.Customer_Issue_Date__c=null;
        List<Contact> conList = new List<Contact>();
        conList =[Select id,Name,lastname,AccountId,Account.Name From Contact Where Primary_Email_Address__c =: UserInfo.getUserEmail() limit 1];        
        wrapperclass wrap = new wrapperclass();
        wrap.contact=conlist.size()>0?conlist[0]:null;
        //wrap.email = UserInfo.getUserEmail();
        //wrap.accountName= UserInfo.getName();
        wrap.recordTypeList = getRecordTypeValues();
        wrap.siteMap = getRegions();
        wrap.opportunity = opp;        
        wrap.user = [select Id,Name,Email,Profile.Name from User where Id = :UserInfo.getUserId()];
        wrap.theme = UserInfo.getUiThemeDisplayed();
        return wrap;
    }
    @AuraEnabled
    public Static Opportunity getOpportunityRecord(String recordId){
        Opportunity opp = [select Name,opportunity_number__c,isClosed,accountid,Account.Name,Type,Description,Tech_Sales__c,Tech_Sales_Product_Area__c,Certification_Requirements__c,Platform__c,Platform__r.Name,
                           Bid_Type_Name__c,Site__c,Site__r.name,Received_Date_at_Clearing_House__c,HAPP_Email__c,Customer_Issue_Date__c,Contract_Type__c,prime_sub__c,Account_Contact_Name__c,Account_Contact_Name__r.Name,
                           Request_Type__c,Solicitation_No__c,Proposal_Due_Date__c,Type_of_Pricing__c,Proposal_Content__c,Revenue_Type__c,Estimated_Proposal_Value__c,
                           HW_SW__c,Comments__c,Account_Name_formula__c,Opportunity_Type__c,Record_Type_Name__c,recordtypeid,recordtype.name,RFP_Expected_Date__c,CBT_Team_Tier_3__c,CBT_Tier_2__c from Opportunity where id=:recordId];
        opp.Received_Date_at_Clearing_House__c=system.today();        
        opp.RFP_Expected_Date__c=null;
        opp.HW_SW__C='';
        opp.Customer_Issue_Date__c=null;
        if(opp.Request_Type__c == 'Unsolicited')
        {            
            opp.Solicitation_No__c = 'Unsolicited';
        }
        return opp;
    }
    @AuraEnabled
    public static string saveCaseRecord(String opp,String positions,String selectedSite, Boolean isFileAttached ){   
        Opportunity oppt = (Opportunity) System.JSON.deserialize(opp, Opportunity.Class);
        Case cse = createCase(oppt,positions,selectedSite);
        insertNewCaseRecord(cse);
        case caseRec = [Select Id,CaseNumber from case where Id=:caseId];
        if(!isFileAttached){
            emailsending(caseRec.Id,false);
        }
        return caseRec.Id+'_'+caseRec.CaseNumber ;
        
    }
    public static void insertNewCaseRecord(case newCase){
        try{
            insert newCase;
            caseId = newCase.Id;
        }catch(Exception ex){            
            throw new AuraHandledException(ex.getMessage());
        }
    }
    public static Case createCase(Opportunity opp,String positions,String selectedSite)
    {
        String tempdesc='';
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('D&S Clearing House Proposal').getRecordTypeId();
        List<Contact> conList = new List<Contact>();
        conList =[Select id,Name,lastname,AccountId,Account.Name From Contact Where Primary_Email_Address__c =: UserInfo.getUserEmail() limit 1];
        
        Case cse = new Case();
        cse.RecordTypeId =devRecordTypeId;
        cse.OwnerId = Label.D_S_Clearing_House;
        system.debug('===odevRecordTypeId====='+devRecordTypeId);        
        cse.Type_of_pricing__c =opp.Contract_Type__c;
        cse.Certification_Requirements__c =opp.Certification_Requirements__c;
        cse.Platform__c =opp.Platform__c;
        cse.Plant__c =selectedSite;
        cse.Opportunity__c =opp.Id;
        cse.Opportunity_Type__c=opp.Opportunity_Type__c;
        cse.Customer_issue_date__c=opp.Customer_Issue_Date__c;
        cse.Request_Type_Opp__c =opp.Request_Type__c;
        cse.Solicitation_Number__c=opp.Solicitation_No__c;
        cse.Proposal_Response_due_date__c=opp.RFP_Expected_Date__c;
        cse.Part_Number__c  = opp.HW_SW__c;
        if(UserInfo.getUITheme() == 'Theme4t'){
            cse.Method_Received__c='Mobile Form- DSClearingHouse';
        } 
        else
            cse.Method_Received__c='Form-DSClearingHouse';
        cse.origin='Form-DSClearingHouse';
        cse.Accountid=opp.accountid;
        cse.part_research__c='Normal';
        cse.Received_Date__c=opp.Received_Date_at_Clearing_House__c ;
        cse.comments__c=opp.comments__c;
        cse.Part_Number__c  = opp.HW_SW__c;
        if(opp.prime_sub__c=='Joint Venture')
            cse.Contractor_Status__c='Joint Venture';
        else if(opp.prime_sub__c=='Prime')
            cse.Contractor_Status__c='Prime';
        else if(opp.prime_sub__c=='Sub' || opp.prime_sub__c=='Subcontractor')
            cse.Contractor_Status__c='Subcontractor';
        cse.Program_Description__c=opp.description;
        cse.classification__c=opp.Bid_Type_Name__c;
        cse.Requestor_Email__c=userInfo.getUserEmail();
        if(conList.size()>0){
            cse.contactid=conList[0].id;  
        } 
        
        /*if(opp.Account_Contact_Name__c!=null){
cse.contactid=opp.Account_Contact_Name__c;  
}*/
        
        cse.proposal_content__c=opp.revenue_type__c;
        cse.estimated_proposal_value__c=opp.Estimated_Proposal_Value__c;
        cse.Tech_Sales__c=opp.tech_sales__c;
        cse.Tech_Sales_Product_area__c=opp.Tech_Sales_Product_area__c;
        //start : SCTASK4093642
        if(opp.CBT_Tier_2__c!=null || opp.CBT_Tier_2__c!=''){
            cse.CBT_1__c=opp.CBT_Tier_2__c;
        }
        if(opp.CBT_Team_Tier_3__c!=null || opp.CBT_Team_Tier_3__c!=''){
            cse.CBT_Team_1__c=opp.CBT_Team_Tier_3__c;
        }
        //End : SCTASK4093642
        if(opp.account.name!=null || opp.account.name!=''){
            tempdesc ='Account Name : '+opp.account.name +'\n';
        }
        
        if(opp.name!=null || opp.name!='')
        {            
            tempdesc = tempdesc + 'Opportunity Name : '+opp.name +'\n';
        }
        if(opp.Solicitation_No__c !=null || opp.Solicitation_No__c !='NULL')
        { 
            tempdesc = tempdesc + 'Solicitation No : '+ (opp.Solicitation_No__c == null ? '' : opp.Solicitation_No__c)  +'\n';           
        }
        if(opp.Opportunity_Number__c !=null || opp.Opportunity_Number__c !='')
        { 
            tempdesc = tempdesc + 'Opportunity No : '+opp.Opportunity_Number__c +'\n';           
        }
        
        if(positions  != null && positions  != '')
        {
            tempdesc = tempdesc +'Opportunity Type :'+positions  +'\n';        
        }
        if(opp.Tech_Sales__c != null && opp.Tech_Sales__c !=''){
            tempdesc = tempdesc +'Tech Sales :'+opp.Tech_Sales__c +'\n';
        }
        if(opp.Tech_Sales_Product_Area__c != null && opp.Tech_Sales_Product_Area__c !=''){
            tempdesc = tempdesc +'Tech Sales Product Area :'+opp.Tech_Sales_Product_Area__c +'\n';
        }
        if(opp.Received_Date_at_Clearing_House__c != null ){
            tempdesc = tempdesc +'Received Date at Clearing House :'+opp.Received_Date_at_Clearing_House__c +'\n';
        }
        if(opp.Customer_Issue_Date__c != null ){
            tempdesc = tempdesc +'Customer Issue Date :'+opp.Customer_Issue_Date__c +'\n';
        }
        
        if(opp.Request_Type__c != null && opp.Request_Type__c !='' && opp.Request_Type__c !='null'){
            tempdesc = tempdesc +'Request Type :'+opp.Request_Type__c +'\n';
        }
        
        
        if(opp.RFP_Expected_Date__c != null ){
            tempdesc = tempdesc +'Response Due Date :'+opp.RFP_Expected_Date__c +'\n';
        }
        if(opp.Contract_Type__c != null && opp.Contract_Type__c !=''){
            tempdesc = tempdesc +'Type of pricing :'+opp.Contract_Type__c +'\n';
        }
        if(opp.Certification_Requirements__c != null && opp.Certification_Requirements__c !=''){
            tempdesc = tempdesc +'Certification Requirements :'+opp.Certification_Requirements__c +'\n';
        }
        
        if(opp.Platform__c != null ){
            tempdesc = tempdesc +'Platform :'+([select id,Name from Platform__c where id =:opp.Platform__c]).name+'\n';   
            
        }
        if(opp.Bid_Type_Name__c != null && opp.Bid_Type_Name__c !=''){
            tempdesc = tempdesc +'Bid Type :'+opp.Bid_Type_Name__c +'\n';
        }
        if(String.isNotBlank(selectedSite)){
            tempdesc = tempdesc +'Site :'+([select id,Name from Plant_Code_Master__c where id =:selectedSite]).name +'\n';
        }
        if(opp.Revenue_Type__c != null && opp.Revenue_Type__c !=''){
            tempdesc = tempdesc +'Proposal Content :'+opp.Revenue_Type__c +'\n';
        }
        if(opp.Estimated_Proposal_Value__c != null && opp.Estimated_Proposal_Value__c !=''){
            tempdesc = tempdesc +'Estimated Proposal Value :'+opp.Estimated_Proposal_Value__c +'\n';
        }
        if(opp.Account_Contact_Name__c != null && opp.Account_Contact_Name__r != null && opp.Account_Contact_Name__r.Id != null){
            cse.New_Proposal_Manager1__c=opp.Account_Contact_Name__r.Id;
            
            tempdesc = tempdesc +'Name of Proposal Leader :'+opp.Account_Contact_Name__r.Name+'\n';
        }
        if(opp.HW_SW__c != null && opp.HW_SW__c !=''){
            tempdesc = tempdesc +'Hardware :'+opp.HW_SW__c +'\n';
        }
        
        tempdesc = tempdesc +'Name of Requestor :'+userinfo.getName() +'\n';
        
        if(opp.Comments__c != null && opp.Comments__c !=''){
            tempdesc = tempdesc +'Comments :'+opp.Comments__c +'\n';
        }        
        tempdesc=tempdesc.replaceAll(' 00:00:00','');
        // emailDescription=emailDescription.replaceAll(' 00:00:00','');
        cse.Description =tempdesc;
        cse.SuppliedEmail =UserInfo.getUserEmail();
        
        String subject='';
        
        if(opp.Solicitation_No__c != null && opp.Solicitation_No__c !=''){           
            subject = 'Solicitation No. :'+opp.Solicitation_No__c + '\n';
        }
        subject = subject+ 'Opportunity No. :'+opp.Opportunity_Number__c + '\n';
        
        if(opp.Name  != null && opp.Name !=''){            
            subject = subject +'Opportunity Name. :'+opp.Name + '\n';
        }
        cse.subject=subject;
        cse.Agent_Contact_Flag__c=true;
        system.debug('==========caseeeee==='+cse);
        return cse;
    }
    Private static List<String> getRecordTypeValues(){
        List<String> reclist = new List<String>(); 
        List<String> recordList = new List<String>(); 
        String[] reclst = (label.Opportunity_Recordtypes).split(',');       
        if(reclst.size() > 0){            
            for(String i : reclst){
                reclist.add(i);                 
            }
        }
        for (list<RecordType> rts : [SELECT ID, name FROM RecordType WHERE SObjectType = 'Opportunity' and name != 'None'  and Name =:reclist  ORDER BY Name ]) {
            for (RecordType rt : rts) {               
                recordList.add(rt.Name);
            } 
        }      
        return recordList;
    }
    private static Map<String,String> getRegions(){
        
        List<PlantCodeMaster__c> mcs = PlantCodeMaster__c.getall().values();
        mcs.sort();
        Map<String,String> siteMap = new Map<String,String>();
        for(PlantCodeMaster__c acc : mcs) {           
            siteMap.put(acc.SiteID__c,acc.name);
        }
        
        return siteMap;    
    }
    
    public class wrapperclass{
        @AuraEnabled
        public Opportunity opportunity= new Opportunity();
        @AuraEnabled
        public Contact contact= new Contact();
        @AuraEnabled
        public List<String> recordTypeList= new List<String>();
        @AuraEnabled
        public Map<String,String> siteMap= new Map<String,String> ();
        /*@AuraEnabled
        public String accountName='';
        @AuraEnabled
        public String email=''; */
        @AuraEnabled
        public User user = new User();
        @AuraEnabled
        public String theme = '';
    }
    //@future
    @AuraEnabled
    public static void emailsending(Id caseId,Boolean isFilesDelete)
    {   
        if(isFilesDelete){
            DSFileUploadController.deleteAllFiles(String.valueOf(caseId));
        }
        string emsubject='';
        string emailDescription='';
        string casedesc='';
        string hwswvalue='';
        string oppType='';
        List<Attachment> attList = new List<Attachment>();
        List<EmailMessage> listInsertEmailMessage = new List<EmailMessage>();
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        List<Messaging.EmailFileAttachment> efa = new List<Messaging.EmailFileAttachment>();
        List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();
        String[] toaddress = new String[]{};        
            
        EmailTemplate em= [Select id,Name,HTMLValue,Subject,Body from EmailTemplate WHERE id=:label.D_SClearingHouseFormEmailTemp ];    
        string emailsub = em.Subject;
        string emailhtmlbody=em.HTMLValue;
        
        case c = [SELECT id,casenumber,subject,Case_Ref_ID__c,Description,SuppliedEmail,Opportunity__r.Opportunity_Number__c,
               Opportunity__r.Name,Opportunity__r.recordtype.name,Platform__c,Opportunity__r.account.name,Plant__c,Tech_Sales__c,Tech_Sales_Product_area__c,
               Received_Date__c,Request_Type_Opp__c,Type_of_pricing__c,Certification_Requirements__c,classification__c,proposal_content__c,estimated_proposal_value__c,Part_Number__c,comments__c,New_Proposal_Manager1__r.name,Customer_issue_date__c,Proposal_Response_due_date__c,Solicitation_Number__c    
               FROM case WHERE Id=:caseId];
        
        
        casedesc=c.Description;
        
        if(casedesc.contains('Hardware :')){   
            hwswvalue=casedesc.substringAfter('Hardware :');
            hwswvalue=hwswvalue.substringBefore('\n');
        }
        else{
            hwswvalue='';   
        }
        if(casedesc.contains('Opportunity Type :')){
            oppType = casedesc.substringBetween('Opportunity Type :', '\n');
        }
        system.debug('hwswvalue is ::'+hwswvalue);
        system.debug('oppType is ::'+oppType);
        
        
        if(c.subject != null && c.subject != ''){
            emailsub = emailsub.replace('{!Case.Subject}',c.subject);
            emailhtmlbody = emailhtmlbody.replace('{!Case.Subject}','<br/>' + emsubject);
        }
        else{
            emailsub = emailsub.replace('{!Case.Subject}','');
            emailhtmlbody = emailhtmlbody.replace('{!Case.Subject}','');
        }
        if(c.CaseNumber != null && c.CaseNumber != '')  {
            emailsub = emailsub.replace('{!Case.CaseNumber}',c.CaseNumber);
            emailhtmlbody = emailhtmlbody.replace('{!Case.CaseNumber}',c.CaseNumber);
        }
        else{
            emailsub = emailsub.replace('{!Case.CaseNumber}','');
            emailhtmlbody = emailhtmlbody.replace('{!Case.CaseNumber}','');
        }
        if(c.Case_Ref_ID__c != null && c.Case_Ref_ID__c != ''){
            emailsub = emailsub.replace('{!Case.Case_Ref_ID__c}',c.Case_Ref_ID__c);
            emailhtmlbody = emailhtmlbody.replace('{!Case.Case_Ref_ID__c}',c.Case_Ref_ID__c);
        }
        else{
            emailsub = emailsub.replace('{!Case.Case_Ref_ID__c}','');
            emailhtmlbody = emailhtmlbody.replace('{!Case.Case_Ref_ID__c}','');
        }
        if(c.Description != null && c.Description != ''){
            emailhtmlbody = emailhtmlbody.replace('{!Case.Description}',emailDescription);
        }
        else{
            emailhtmlbody = emailhtmlbody.replace('{!Case.Description}','');
        }
        if(c.Opportunity__r.Opportunity_Number__c != null)
            emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Opportunity_Number__c}',c.Opportunity__r.Opportunity_Number__c);
        if(c.Opportunity__r.Name != null)
            emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Name}',c.Opportunity__r.Name);
        if(c.Opportunity__r.account.name != null)
            emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Account}',c.Opportunity__r.account.name);
        if(c.Type_of_pricing__c != null)
            emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Contract_Type__c}',c.Type_of_pricing__c);
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Contract_Type__c}','');
        if(c.Opportunity__r.recordtype.name != null)
            emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Type}', oppType);
        if(c.Plant__c != NULL)
            emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Site__c}',getsitedetails(c.Plant__c).name);
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Site__c}','');
        if(c.Certification_Requirements__c != null)
            emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Certification_Requirements__c}',c.Certification_Requirements__c);
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Certification_Requirements__c}','');
        if(c.Received_Date__c != NULL)
            emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Received_Date_at_Clearing_House__c}',String.valueOf(c.Received_Date__c));
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Received_Date_at_Clearing_House__c}', '');
        if( c.Request_Type_Opp__c != NULL)
            emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Request_Type__c}',c.Request_Type_Opp__c);
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Request_Type__c}', '');
        if( c.Tech_Sales__c != NULL)
            emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Tech_Sales__c}',c.Tech_Sales__c);
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Tech_Sales__c}','');        
        if(c.Tech_Sales_Product_area__c != NULL)
            emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Tech_Sales_Product_Area__c} ', c.Tech_Sales_Product_area__c);
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Tech_Sales_Product_Area__c} ', '');        
        if(getplatformdetails(c.Platform__c).name != NULL)
            emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Platform__c}',getplatformdetails(c.Platform__c).name);
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Platform__c}','');     
        if(c.classification__c != NULL)
            emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Bid_Type_Name__c}',c.classification__c);
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Bid_Type_Name__c}','');
        if(c.proposal_content__c != NULL)
            emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Revenue_Type__c}',c.proposal_content__c);
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Revenue_Type__c}','');
        if(c.estimated_proposal_value__c != NULL)
            emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Estimated_Proposal_Value__c}',c.estimated_proposal_value__c);
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Estimated_Proposal_Value__c}','');
        if(hwswvalue!= NULL)
            emailhtmlbody = emailhtmlbody.replace('{!Opportunity.HW_SW__c}', hwswvalue);
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.HW_SW__c}', '');
        if(c.New_Proposal_Manager1__c !=NULL && c.New_Proposal_Manager1__r.name != NULL)
            emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Account_Contact_Name__c}', c.New_Proposal_Manager1__r.name);
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Account_Contact_Name__c}', '');
        if(c.Customer_issue_date__c != NULL)
            emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Customer_Issue_Date__c}',string.valueOf(c.Customer_issue_date__c));
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Customer_Issue_Date__c}', '');
        if(c.Proposal_Response_due_date__c != NULL)
            emailhtmlbody = emailhtmlbody.replace('{!Opportunity.RFP_Expected_Date__c}', string.valueOf(c.Proposal_Response_due_date__c));
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.RFP_Expected_Date__c}', '');
        
        emailhtmlbody = emailhtmlbody.replace('{!User.Name}', userinfo.getName());
        //emailhtmlbody = emailhtmlbody.replace('{!User.Name}', '');
        if(c.Solicitation_Number__c != NULL)
            emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Solicitation_No__c}', c.Solicitation_Number__c);
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Solicitation_No__c}', '');
        if(c.comments__c != NULL)
            emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Comments__c}', c.comments__c);
        emailhtmlbody = emailhtmlbody.replace('{!Opportunity.Comments__c}', '');
        /*END*/
        
        EmailMessage emailToCase = new EmailMessage();
        emailToCase.Incoming = false;
        emailToCase.MessageDate = system.now();
        emailToCase.FromAddress = Label.D_S_Clearing_House_Email;
        emailToCase.FromName = 'Your response';
        emailToCase.ParentId = c.id;
        emailToCase.Status = string.valueof(3);
        emailToCase.ToAddress = c.SuppliedEmail ;
        emailToCase.Subject = emailsub;
        if(emailhtmlbody!=null && emailhtmlbody.length()>0 ){
            if(emailhtmlbody.length()<32000)
                emailToCase.Htmlbody =  emailhtmlbody.substring(0,emailhtmlbody.length());
            else
                emailToCase.HtmlBody =  emailhtmlbody.substring(0,32000);
        }
        
        listInsertEmailMessage.add(emailToCase);
        //attList=[SELECT id,name,body FROM attachment WHERE parentid=:c.id];
        /*for(Attachment a: attlist)
        {         
            Messaging.EmailFileAttachment e = new Messaging.EmailFileAttachment();
            e.setFileName(a.name);
            e.setBody(a.body);
            efa.add(e);
        }  */
        
        List<id> ContentDocumentids = new List<id>();
        
        for(contentDocumentLink CDLink : [SELECT LinkedEntityid, ContentDocumentid FROM contentDocumentLink WHERE LinkedEntityid=:c.id])
        {
            ContentDocumentids.add(CDLink.ContentDocumentid);  
        }
        for ( ContentVersion cversion : [SELECT title,PathOnClient, FileType,versiondata,FileExtension FROM contentversion WHERE ContentDocumentId IN :ContentDocumentids ])
        {
            blob Fbody = cversion.versiondata;
            //system.debug('body : '+Fbody+'-----------'+cversion.title);
            Messaging.Emailfileattachment ef = new Messaging.Emailfileattachment();
            ef.setFileName(cversion.PathOnClient);
            ef.setBody(Fbody);
            efa.add(ef); 
        }        
        
        //send email
        if(c.SuppliedEmail!=null && c.SuppliedEmail!='')
        {
            toaddress.add(c.SuppliedEmail);
        }
        msg.setToAddresses(toaddress);
        msg.setOrgWideEmailAddressId(label.D_S_Clearing_House_Id);
        msg.setSubject(emailsub);
        msg.setHTMLBody(emailhtmlbody);
        msg.setFileAttachments(efa);
        bulkEmails.add(msg);
        system.debug('bulkEmails-----'+bulkEmails.size());
        if(bulkEmails.size()>0)
        {
            if(!test.isrunningtest())
                Messaging.sendEmail(bulkEmails);
        }
        system.debug('listInsertEmailMessage-----'+listInsertEmailMessage);                       
        system.debug('listInsertEmailMessage-----'+listInsertEmailMessage.size());                       
        if(listInsertEmailMessage.size()>0)
        {
            try{
                insert listInsertEmailMessage;
            }
            catch(exception e)
            {
                system.debug('==Error=='+e);
            }
        }
        
    }
    public  static Platform__c getplatformdetails(string siteId) { 
        Platform__c site =[SELECT id,Name FROM Platform__c WHERE id =:Id.ValueOf(siteId)];        
        return site;
    }   
    public  static Plant_Code_Master__c getsitedetails(string siteId) { 
        Plant_Code_Master__c site =[SELECT id,Name FROM Plant_Code_Master__c WHERE id =:Id.ValueOf(siteId)];
        return site;
    } 
    
}