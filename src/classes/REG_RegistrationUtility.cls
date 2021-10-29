/** * File Name: REG_RegistrationUtility 

* Description  Registration Utility Class for Joule Aero

* * @author : TCS 

Date 01/16/2019 

* */
public with sharing class REG_RegistrationUtility {
 
 Static String ADE_Case_Creation_Email_Template = Label.ADE_Case_creation_Email_template;   
    /**
*Method used to fetch all the countries and  State details
**/
    public static REG_Result GetAllCountries(){
        
        REG_Result result = new REG_Result();
        list<Country__c> lstCountries = new list<Country__c>();
        //list<REG_Country_API_Wrapper> countryWrapperList = new list<REG_Country_API_Wrapper>();
        try{                    
            lstCountries =  [SELECT Name, Telephonic_Country_Code__c, ISO_Country_Code__c, Isembargoed__c, Issanctioned__c,  (SELECT Name, StateCode__c FROM States_del__r  ) FROM Country__c ];
            if(lstCountries.isEmpty()){
                result.handleError(404, 'Country record not found', 'No data available in the country object');
            }            
            result.Data = lstCountries;
            
            
        }catch(Exception e){ 
            result.handleException(500, e.getMessage(), e);             
        }       
        
        return result;
        
    }//end of getAllCountries
    
    /**
*Method used to fetch Country & State details using ISO Country Code
**/
    public static REG_Result GetCountryState(String countryCode){
        
        REG_Result result = new REG_Result();
        List<Country__c> lstCountries = new list<Country__c>();
        
        try{    
            if(countryCode==null ||String.isBlank(countryCode)) 
                throw new System.StringException();
            lstCountries =  [SELECT Name, Telephonic_Country_Code__c, ISO_Country_Code__c, Isembargoed__c, Issanctioned__c,   (SELECT Name, StateCode__c FROM States_del__r  ) FROM Country__c where ISO_Country_Code__c =:countryCode];
            if(lstCountries.isEmpty()){
                result.handleError(404, 'Country record not found', 'Country record not found with given Country Code');
            }
            result.Data = lstCountries;
            
            
        }catch(System.StringException e){
            result.handleException(400, 'Param: CountryCode is not a valid code', e);
            
        }catch(Exception e){ 
            result.handleException(500,  e.getMessage(), e); 
            
            
        }       
        
        return result;
        
    }//end of getCountryState   
    
    /*Method to get domain type*/
    public static REG_Result getdomainType(String domain,String lastId){
        REG_Result result = new REG_Result();
        list<Account_Email_Domains__c> results = new list<Account_Email_Domains__c>();
        //list<domainWrapper> wrapperResultlist = new list<domainWrapper>();
     
        try{
            if(String.isNotBlank(domain)){
                if(domain.equalsIgnoreCase('internal')){
                    results = [SELECT Account_Email_Domain__c,Internal_Email_Domain__c,Name   FROM Account_Email_Domains__c   where Internal_Email_Domain__c = true];    
                }else
                    if(domain.equalsIgnoreCase('external')){
                        
         
            if(String.isNotBlank(lastId)){
                        results = [SELECT Account_Email_Domain__c,Internal_Email_Domain__c,Name   FROM Account_Email_Domains__c   where Internal_Email_Domain__c = false AND id>:lastId order by id LIMIT 20000];
                        }else {
                            results = [SELECT Account_Email_Domain__c,Internal_Email_Domain__c,Name   FROM Account_Email_Domains__c   where Internal_Email_Domain__c = false order by id LIMIT 20000];
                        }
                        //results = [SELECT Account_Email_Domain__c,Internal_Email_Domain__c,Name   FROM Account_Email_Domains__c   where Internal_Email_Domain__c = false LIMIT 20000];
                        }else{
                        results = [SELECT Account_Email_Domain__c,Internal_Email_Domain__c,Name   FROM Account_Email_Domains__c   where Account_Email_Domain__c =: domain];
                        
                    }
                
                if(results.isEmpty()){
                    result.handleError(404,'Domain Type not found.','No data found for provided domain type.');
                    return result;
                }else{
                    result.data = results; 
                    
                }
            }else{
                throw new System.StringException();
                
            }
            
        }
        catch(System.StringException e){
            
            result.handleException(400, 'Input parameter is not a valid',e);
            
            
        }
        return result;
    }//end of getDomainType method.
    
    /*Method to get the list of all active tools*/
    public static REG_Result getAllActiveTools(){
        REG_Result result = new REG_Result();
        try{
            
            list<Portal_Tools_Master__c> results = [SELECT Id,Name,Lanch_URL__c,Tool_Image__c,Tool_Sort_Order__c,Tool_Authorization_Method__c,Auto_approve__c,  SendAlerts_Delete_HonId__c,Admin_Email__c   FROM Portal_Tools_Master__c WHERE Tool_Active__c = true    ORDER BY Tool_Sort_Order__c ASC];
            if(!results.isEmpty()){
                result.Data = results;
            }else{
                result.StatusCode = 204;             
                result.StatusMessage ='No data found';
            }
        }        
        catch(Exception e){
            result.handleException(500, e.getMessage(), e);
        }
        return result;
    }//end of getAllActiveTool Method
    public static list<String> getPickListVlaues(String sObjectName, String sFieldName){
        
        List<String> lstPickListValues = new List<String>();
        String[] types = new String[]{sObjectName};
            
            Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        
        if (results.size()>0){
            
            system.debug('lstresults.size(): ' + results.size());
            
            for(Schema.DescribeSobjectResult res : results) {
                System.debug('sObject Label: ' + res.getLabel());
                System.debug('Number of fields: ' + res.fields.getMap().size());
                
                if(res.fields.getMap().size()>0){
                    
                    system.debug('res.fields.getMap().size(): ' + res.fields.getMap().size());
                    
                    Map<String, Schema.SObjectField> fieldMap = res.fields.getMap();
                    Schema.SObjectField f = fieldMap.get(sFieldName);
                    
                    Schema.DescribeFieldResult dfr = f.getDescribe();
                    List<Schema.PicklistEntry> lstPLE = dfr.getPicklistValues();
                    
                    for(Schema.PicklistEntry pe:lstPLE){
                        
                        if(pe.isActive()){
                            lstPickListValues.add(pe.getValue());
                        }
                    }
                    system.debug('lstPickListValues.Count: ' + lstPickListValues.size());
                    system.debug('lstPickListValues: ' + lstPickListValues);
                    
                    
                }
            }
            
        }
        return lstPickListValues;
    }//getPickListVlaues
    
    //Generic email send code
    /*
public static void emailMessage(string conid,string setTemplateId,string setWhatId,string setOrgWideEmailAddressId, string toAddress, string ccAddresses1){   
Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>(); 
msg.setTargetObjectId('003m0000018NMqJ');
// msg.setTargetObjectId(conid);
msg.setsaveAsActivity(false);
msg.setTemplateId(setTemplateId);
msg.setWhatId(setWhatId);
msg.setOrgWideEmailAddressId(setOrgWideEmailAddressId);  
msgList.add(msg);
system.debug(msgList);
String[] toAddresses = new String[]{toAddress};
String[] ccAddresses = new String[]{ccAddresses1};
Savepoint sp = Database.setSavepoint();                 
if(msg.getTemplateId()!=null)
Messaging.sendEmail(msgList);
Database.rollback(sp);
if(msgList.size()>0){
for(Messaging.SingleEmailMessage email : msgList){
Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
emailToSend.setToAddresses(toAddresses);
emailToSend.setPlainTextBody(email.getPlainTextBody());
emailToSend.setHTMLBody(email.getHTMLBody());
emailToSend.setSubject(email.getSubject());
emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
if(emailToSend.getHTMLBody()!=null)
bulkEmails.add(emailToSend);
system.debug('Invalid--->bulkEmails'+bulkEmails);
}
}    

if(bulkEmails.size()>0)
{
Messaging.sendEmail(bulkEmails);
} 

}*/
    
    public static void emailMessage(string conid,string setTemplateId,string setWhatId,string setOrgWideEmailAddressId, List<string> toAddress, List<string> ccAddresses1){  
        //Changed for RDF - RAPD-7952
        SitecoreCaseType__c siteCoreType = SitecoreCaseType__c.getValues('PrecisionSensorsRMA');
        //Changed for RDF - RAPD-7952
        List <Case> cas = new List <Case> (); 
        String Subject ='';
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        
        List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>(); 
        msg.setTargetObjectId(conid);
        //msg.setTargetObjectId('003m0000018NMqJ');
        //Changed for RDF - RAPD-7952 added recordtypeId to the query
        cas = [Select Subject,recordtypeId from Case where Id = :setWhatId];
        //Changed for RDF - RAPD-7952
        Subject = cas[0].Subject;
        if( setTemplateId == ADE_Case_Creation_Email_Template)
        {
           msg.setsaveAsActivity(true);
        }
        else
        {
        msg.setsaveAsActivity(false);
        } 
        msg.setsaveAsActivity(false);
        msg.setTemplateId(setTemplateId);
        msg.setWhatId(setWhatId);
        msg.setOrgWideEmailAddressId(setOrgWideEmailAddressId);  
        msgList.add(msg);
        system.debug('msgList------'+msgList);
        Savepoint sp = Database.setSavepoint();                 
        if(msg.getTemplateId()!=null)
            Messaging.sendEmail(msgList);
        Database.rollback(sp);
        if(msgList.size()>0){
            //Changed for RDF - RAPD-7952
            List<string> bccAddresses = new list<string>(label.MyAerospace_RMA_BCC_Address.split(','));
            //Changed for RDF - RAPD-7952
            for(Messaging.SingleEmailMessage email : msgList){
                Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                emailToSend.setToAddresses(toAddress);
                //Added to Include GCC Dl Group - MT-912
                
                if(Subject != null && Subject == 'MyAerospace GCC Become a Member')
                {                   
                     ccAddresses1.Add('GCC@Honeywell.com');
                }
                
                system.debug('toAddress**'+toAddress);
                //TCS - CC Address added on demand of customer. Can be disabled in QA but should be there in Prod.
                system.debug('ccAddresses1**'+ccAddresses1);
                //Changed for RDF - RAPD-7952
                //if(bccAddresses.size()>0 && cas.RecordtypeId == Mapcasetype.get('PrecisionSensorsRMA').Case_Record_Type__c){
                if(bccAddresses.size()>0 && siteCoreType != null && siteCoreType.Case_Record_Type__c == cas[0].recordtypeId){
                        emailTosend.setBccAddresses(bccAddresses);
                    }
                //Changed for RDF - RAPD-7952
                if(!ccAddresses1.isEmpty())
                    emailToSend.setccAddresses(ccAddresses1);
                system.debug('ccAddresses2**'+ccAddresses1);
                emailToSend.setPlainTextBody(email.getPlainTextBody());
                emailToSend.setHTMLBody(email.getHTMLBody());
                emailToSend.setSubject(email.getSubject());
                emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                if(setTemplateId == ADE_Case_Creation_Email_Template || setTemplateId =='00X1B000001zesWUAQ')
                {
                    emailToSend.setsaveAsActivity(true);
                    emailToSend.setWhatId(setWhatId);
                }
                
                
                system.debug('emailToSend***'+emailToSend);
                if(emailToSend.getHTMLBody()!=null)
                    bulkEmails.add(emailToSend);
                system.debug('Invalid--->bulkEmails'+bulkEmails);
            }
        }    
        
        system.debug('bulkEmails***'+bulkEmails);
        system.debug('bulkEmails.size()'+bulkEmails.size());
        if(bulkEmails.size()>0)
        {
            Messaging.sendEmail(bulkEmails);
        } 
        
    }
    
    // prepare email body and other params for sending mail during email change, delete contact and update contact(registration)
    public static List<Messaging.SingleEmailMessage> getEmailMetaData(Contact con,List<Contact_Tool_Access__c> conToolAcc,string Input,string exHid){
        system.debug('Contact con Honeywell_ID__c******'+con.Honeywell_ID__c);
        system.debug('Contact con Honeywell_ID__c******'+exHid);
        // REG_Admin_Email__mdt admEmail = [select HTML_Version__c, Text_version__c, DeveloperName, Subject__c from REG_Admin_Email__mdt where DeveloperName =: Input  ];
        EmailTemplate admEmail =[select HtmlValue,body,DeveloperName,Subject FROM EmailTemplate where DeveloperName =: Input];
        system.debug('admEmail******'+admEmail);
        set<string> adminEmailSet = new set<string>();
        List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
        List<string> relatedAccName = new List<string>();
        List<string> sapAccSoldTo = new List<string>();
        List<Object> parameters = new List<Object>();
        Map<string, List<string>> toolNameMap = new Map<string, List<string>>();
        Map<string, string> toolNameMapUnOrdered = new Map<string, string>();
        //string HTMLver = admEmail.HTML_Version__c;
        //string subject = admEmail.Subject__c;
        string HTMLver = admEmail.HtmlValue;
        string subject = admEmail.Subject;
        string relAccUnOrderedList = '';
        string sapConSoldToUnorderedList = '';
        string conSoldToUnOrderedList = '';
        system.debug(logginglevel.info,'HTML'+HTMLver);
        system.debug(logginglevel.info,'conTool.Portal_Tool_Master__r.Admin_Email__c'+conToolAcc);
        //to put the tools associated to contact in list
        if(!conToolAcc.isEmpty()){
            for(Contact_Tool_Access__c conTool : conToolAcc){
                
                system.debug(logginglevel.info,'conToolAcc'+conTool);
                if(toolNameMap.containsKey(conTool.Portal_Tool_Master__r.Admin_Email__c)){
                    List<string> soldToList = toolNameMap.get(conTool.Portal_Tool_Master__r.Admin_Email__c);
                    soldToList.add(conTool.Portal_Tool_Master__r.Name);
                    toolNameMap.put(conTool.Portal_Tool_Master__r.Admin_Email__c, soldToList);                
                }else{
                    toolNameMap.put(conTool.Portal_Tool_Master__r.Admin_Email__c,new List<string> {conTool.Portal_Tool_Master__r.Name});    
                }
                adminEmailSet.add(conTool.Portal_Tool_Master__r.Admin_Email__c);
            }
            for(string str :toolNameMap.keySet() ){
                conSoldToUnOrderedList = convertIntoUnorderedList(toolNameMap.get(str)); 
                toolNameMapUnOrdered.put(str, conSoldToUnOrderedList);
            }
        }
        
        if((input=='Honeywell_ID_di_association') || (input=='Email_Change_Activate')){            
            
            //for related accounts
            if(!con.Account_Contacts1__r.isEmpty()){
                for(Account_Contact__c acc :con.Account_Contacts1__r ){    
                    relatedAccName.add(acc.Account_Name__r.Name);
                }
                relAccUnOrderedList =  convertIntoUnorderedList(relatedAccName);   
            }
            system.debug(logginglevel.info,'relatedAccName' +relatedAccName);
            system.debug(logginglevel.info,'relAccUnOrderedList ' +relAccUnOrderedList );
            //for contct sold to
            if(!con.SAP_Contact_Sold_To__r.isEmpty()){
                for(SAP_Contact_Sold_To__c sapCon : con.SAP_Contact_Sold_To__r){
                    string name = sapCon.Name;
                    string sapAccSoldToStr = sapCon.SAP_Account_Sold_To__c;
                    string conCaString = name + '(' +sapAccSoldToStr+ ')';
                    system.debug(logginglevel.info,'conCaString'+conCaString);
                    sapAccSoldTo.add(conCaString);
                    
                }
                sapConSoldToUnorderedList = convertIntoUnorderedList(sapAccSoldTo);
            }
        }
        system.debug(logginglevel.info,'sapAccSoldTo' +sapAccSoldTo);
        system.debug(logginglevel.info,'adminEmailSet'+adminEmailSet);
        for(string admE: adminEmailSet){
            system.debug(logginglevel.info,'con.Account_Contacts1__r'+con.Account_Contacts1__r);
            system.debug(logginglevel.info,'con.SAP_Contact_Sold_To__r'+con.SAP_Contact_Sold_To__r);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            system.debug('input*****'+Input);
            if(input=='Honeywell_ID_di_association'){
                parameters = new List<Object> {toolNameMapUnOrdered.get(admE),con.Honeywell_ID__c,con.Name,con.Primary_Email_Address__c,con.Portal_Temp_Primary_Email__c,sapConSoldToUnorderedList,relAccUnOrderedList,con.Id,exHid };
                
                /*parameters.add(toolNameMapUnOrdered.get(admE)==null ? '' : toolNameMapUnOrdered.get(admE));
                parameters.add(con.Honeywell_ID__c==null ? '' : con.Honeywell_ID__c);
                
                parameters.add(String.isBlank(con.Name) ? '' : con.Name);*/

            }
            else if(input=='Email_Change_Activate'){
                //parameters = new List<Object> {toolNameMapUnOrdered.get(admE),con.Honeywell_ID__c,con.Name,con.Primary_Email_Address__c,con.Portal_Temp_Primary_Email__c,sapConSoldToUnorderedList,relAccUnOrderedList };
                // parameters = new List<Object> {toolNameMapUnOrdered.get(admE),con.Honeywell_ID__c,con.Name,con.Primary_Email_Address__c,con.Portal_Temp_Primary_Email__c!=null?con.Portal_Temp_Primary_Email__c:'',sapConSoldToUnorderedList,relAccUnOrderedList };  
                system.debug('inside email change activate');
                parameters.add(toolNameMapUnOrdered.get(admE));
                parameters.add(con.Honeywell_ID__c);
                parameters.add(con.Name);
                parameters.add(con.Primary_Email_Address__c);
                 parameters.add(String.isBlank(con.Portal_Temp_Primary_Email__c) ? '' : con.Portal_Temp_Primary_Email__c);
                parameters.add(sapConSoldToUnorderedList);
                parameters.add(relAccUnOrderedList);
                    }else{
                        parameters = new List<Object> {toolNameMapUnOrdered.get(admE),con.Honeywell_ID__c,con.Name,con.Primary_Email_Address__c};       
                            }
            String formatted = String.format(HTMLver, parameters);
            system.debug(logginglevel.info,'formatted'+formatted);
            message.toAddresses = new string[] {admE};
                system.debug('message.toAddresses '+message.toAddresses);
            message.subject =  subject;
            message.htmlbody= formatted;
            //message.setOrgWideEmailAddressId(Label.REG_UnidentifiedAccountFromAddress);
            message.setOrgWideEmailAddressId(Label.AeroNo_Reply_email_ID);

            msgList.add(message);
        }
        system.debug(logginglevel.info,'msgList'+msgList);
        return msgList;
    }
    // get the data from contact object to prepare email body sending mail during email change, delete contact and update contact(registration)
    public static contact getAdmilemailData(id conId){
        
        
        List<contact> conList = [SELECT Honeywell_ID__c, FirstName, LastName, Name, Primary_Email_Address__c, Portal_Temp_Primary_Email__c,Temp_Portal_Company_Name__c, 
                                 (SELECT Id,Name,Contact__c,Portal_Status__c,Primary_Honeywell_ID__c from Portal_Honeywell_ID__r WHERE Primary_Honeywell_ID__c = true),
                                 (SELECT Id,Portal_Honeywell_ID__c,Portal_Tool_Master__c,Request_Status__c,Portal_Tool_Master__r.Name,Portal_Tool_Master__r.Admin_Email__c from Contact_Tool_Access__r WHERE Request_Status__c = 'Approved' AND Portal_Tool_Master__r.SendAlerts_Delete_HonId__c = true),
                                 (SELECT Id,Name,Contact_Status__c,SAP_Account_Sold_To__c,SoldtoToolAccess__c from SAP_Contact_Sold_To__r),
                                 (SELECT Id,Account_Name__c,Account_Name__r.Name from Account_Contacts1__r) FROM contact WHERE
                                  /*start of SCTASK2679963 changed by saurabh
                                  Contact_Status__c != 'InActive' and 
                                   end of SCTASK2679963*/
                                  Id  = : conId];  
        return conList[0];        
    } 
    //convert sfdc list into unordered list
    public static string convertIntoUnorderedList(List<string> input){
        string unOrderedList = '';
        for(string str: input){
            unOrderedList = unOrderedList + '<li>'+ str + '</li>' ;    
        }
        
        return unOrderedList;
    } 
    
    //method for REG_API_EmailTemplate     
    public static REG_Result getEmailTemplate(String templateName){
        REG_Result result = new REG_Result();
        String id = '';
        //String templateName= '';
        String Subject = '';
        String HtmlValue = '';
        String Body = '';
        String DeveloperName='';
        try{
            if(String.isNotBlank(templateName)){
                List<EmailTemplate> templatedetails  =[select id,DeveloperName,Subject,HtmlValue,body FROM EmailTemplate where DeveloperName=: templateName];
                If(!templatedetails.isEmpty() ){               
                    REG_API_EmailTemplate emailTempWrap =new REG_API_EmailTemplate(templatedetails);
                    
                    result.data =  emailTempWrap;
                }
                else{
                    result.handleError(404, 'No data found', 'No record found for given Input');
                }
            }
            
        }catch(exception e){
            result.handleException(500, e.getMessage(), e);
        }
        return result;
    }    
    
}//end of REG_RegistrationUtility