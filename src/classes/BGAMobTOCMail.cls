public without sharing class BGAMobTOCMail {
    public static List<Contact>con= New List<Contact>();
    public ApexPages.StandardController myAccountController {get; set;}
    public Attachment objattach{get; set;}
    public transient blob filedata{get; set;}
    public string filename{get; set;} 
    public BGAMobTOCMail(ApexPages.StandardController controller) 
    {
        objattach = new Attachment();
        myAccountController = new ApexPages.StandardController(objattach );
    }    
    public Case c { get; set; } 
    public Attachment attachment {get;set;}  
    public BGAMobTOCMail() 
    {
        c = new Case();
    }
    @RemoteAction
        Static public case insertCase(String RecordType,String phone,String Email,String Alter, String Description,String enc,String strname,string strusername)
        {
            if(Email!=null)
            {
            con=[select id,name,Primary_Email_Address__c from Contact where Primary_Email_Address__c=:Email];
            }
            Case objc = new Case();
            if(con.size()>0)
            {
            objc.ContactId=con[0].id;
            system.debug('&&&&'+objc.Contactid);
            }
            objc.suppliedphone = phone;
            objc.SuppliedEmail= Email;
            objc.App_Email__c= Alter;
            objc.Description= Description;
            if(RecordType == 'pilot')
            {
            objc.RecordTypeId  = label.Case_Flight_Ops_Issue_pilot;
            }
            else if (RecordType == 'toc')
            {
            objc.RecordTypeId  = label.Case_Technical_Issue_RecordType;
            }
            else if (RecordType == 'navdb')
            {
            objc.RecordTypeId  = label.Case_NavDB_Accts_RecordType;
            }
            objc.First_Call_Resolution__c=true;
            objc.Origin = 'BGAMobileApp';
            if (RecordType == 'toc')
            objc.OwnerId=label.Case_TOC_Owner;
            if (RecordType == 'navdb')
            objc.OwnerId=label.Case_NAVDB_Owner;//NAVDB ACCOUNTS
            if(RecordType == 'pilot')
            objc.OwnerId=label.Case_Flight_Ops_Issue_pilot_owner;//TALK FMS
            insert objc;
            Case objnew = [Select Id,RecordTypeId,CaseNumber,Contact.Id,CreatedDate,Case_Ref_ID__c from Case where Id=: objc.Id];
            Attachment attachment = new Attachment();
            
            String str = Alter ;
            List<String> str1 = str.split('@');
            system.debug('hiiii'+str1);
            String str2 = str1[0];
            system.debug('hey'+ str2);
            String str3 = str2.replace('.',' ');
            system.debug('hello'+ str3);
            if(objnew.RecordTypeId  == label.Case_Flight_Ops_Issue_pilot)
            {
                string html='<!DOCTYPE html><style>.col-left{width: 50%;font-size: 16px; font-weight: bold;font-family: Arial;}.col-right{width: 70%;font-size: 16px; font-family: Arial;}.col-desc{width: 100%;font-size: 16px; font-family: Arial;}</style><body><table border="0" cellpadding="5" cellspacing="0" width="700" style="position: absolute;left: 50px;border-right-width: 2px;border-right-style: solid;border-right-color: #E3E3E3;border-left-width: 2px;border-left-style: solid;border-left-color: #E3E3E3;border-bottom-width: 3px;border-bottom-style: solid;border-bottom-color: #ED2028;border-top-width: 2px;border-top-style: solid;border-top-color: #E3E3E3;"><tr><td align="left" valign="top"><table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td align="left" height="45" valign="top"><img src="https://c.cs14.content.force.com/servlet/servlet.ImageServer?id=015c0000000FC3o&amp;oid=00Dc0000003sFDB&amp;lastMod=1400587850000" alt="AircraftLogo" style="border:none;display:block;left: 20px;position: absolute;top: 14px;height: 24px;width: 126px;"/> <!-- </img> --></td></tr></table><table  border="0" cellpadding="0" cellspacing="0" width="100%" style="background-color: rgb(83, 89, 102);"><tr><td align="left" height="45" style="background-color: rgb(83, 89, 102);font-size: 16px; color: rgb(178, 214, 255); font-weight: bold;font-family: Arial;">Your Technical Support Submission</td><td align="center"></td><td  width="1"></td><td align="center"></td><td  width="1"></td><td align="center"></td><td width="1"></td><td align="center" height="45" style="background-color: rgb(83, 89, 102);font-size: 16px; color: rgb(178, 214, 255); font-weight: bold;font-family: Arial;"></td><td align="right" height="45" style="background-color: rgb(83, 89, 102);font-size: 16px; color: rgb(178, 214, 255); font-weight: bold;font-family: Arial;">Date:'+objnew.createddate+'</td></tr></table><table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td align="left" height="60" style="font-family:arial;font-size:16px;padding-left: 24px;" valign="middle">Dear  '+strusername+','+'</td><td align="right" valign="middle"></td></tr></table><table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td align="left" style="font-family:arial;font-size:16px;padding-left: 24px;" width="100%">Thank you for contacting Honeywell Aerospace Customer &amp; Product Support. Here are the details we have received from Direct Access.</td></tr></table><table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td height="20"></td></tr></table><table  border="0" cellpadding="0" cellspacing="0" width="100%" style="padding-left: 24px;"><tr><td class="col-left">Phone:</td><td class="col-right">'+phone+'</td></tr><tr><td height="15"></td></tr><tr><td class="col-left">Your Business Email Address:</td><td class="col-right">'+Email+'</td></tr><tr><td height="15"></td></tr><tr id="idAircraftDeliverydate"><td class="col-left">Alternative Email Address: </td><td class="col-right">'+Alter+'</td></tr><tr><td height="15"></td></tr><tr><td class="col-left">Problem Description:</td><td class="col-right"></td></tr><tr><td height="15"></td></tr><tr ><td class="col-desc" colspan="2">'+Description+'</td></tr><tr><td height="20"></td></tr><tr ><td class="col-desc" colspan="2"><span  style="font-size:16px; ">Your case tracking number for this inquiry is provided above. If you wish to communicate with us further about this inquiry, you may reply to this e-mail - please leave the Reference Case Number within the subject line for quicker responses.<br><br>Honeywell Aerospace<br>Customer &amp; Product Support<br></span><span  style="font-size:16px; text-decoration:underline; color:#679afa; ">www.MyAerospace.com</span><span  style="font-size:16px; text-decoration:underline; "><br></span><span  style="font-size:16px; ">1-800-601-3099 or internationally at 1-602-365-3099<br><br>ORIGINAL CORRESPONDENCE:<br><br>Sent from Honeywell Direct Access App<br><br>'+objnew.Case_Ref_ID__c+'<br></span></td></tr></table></td></tr></table></body></html>';            
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] { Alter };                                           
                mail.setToAddresses(toAddresses);            
                mail.setSubject('Honeywell - Your Technical Support Submission  '+objnew.CaseNumber+' '+objnew.Case_Ref_ID__c);
                mail.setHtmlBody(html);
                mail.setOrgWideEmailAddressId(label.PILOT_SUPP_OWD_ID);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
            }
            else if(objnew.RecordTypeId  == label.Case_NavDB_Accts_RecordType)
            {
                string html='<!DOCTYPE html><style>.col-left{width: 50%;font-size: 16px; font-weight: bold;font-family: Arial;}.col-right{width: 70%;font-size: 16px; font-family: Arial;}.col-desc{width: 100%;font-size: 16px; font-family: Arial;}</style><body><table border="0" cellpadding="5" cellspacing="0" width="700" style="position: absolute;left: 50px;border-right-width: 2px;border-right-style: solid;border-right-color: #E3E3E3;border-left-width: 2px;border-left-style: solid;border-left-color: #E3E3E3;border-bottom-width: 3px;border-bottom-style: solid;border-bottom-color: #ED2028;border-top-width: 2px;border-top-style: solid;border-top-color: #E3E3E3;"><tr><td align="left" valign="top"><table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td align="left" height="45" valign="top"><img src="https://c.cs14.content.force.com/servlet/servlet.ImageServer?id=015c0000000FC3o&amp;oid=00Dc0000003sFDB&amp;lastMod=1400587850000" alt="AircraftLogo" style="border:none;display:block;left: 20px;position: absolute;top: 14px;height: 24px;width: 126px;"/> <!-- </img> --></td></tr></table><table  border="0" cellpadding="0" cellspacing="0" width="100%" style="background-color: rgb(83, 89, 102);"><tr><td align="left" height="45" style="background-color: rgb(83, 89, 102);font-size: 16px; color: rgb(178, 214, 255); font-weight: bold;font-family: Arial;">Your Database Services Accounts Submission</td><td align="center"></td><td  width="1"></td><td align="center"></td><td  width="1"></td><td align="center"></td><td width="1"></td><td align="center" height="45" style="background-color: rgb(83, 89, 102);font-size: 16px; color: rgb(178, 214, 255); font-weight: bold;font-family: Arial;"></td><td align="right" height="45" style="background-color: rgb(83, 89, 102);font-size: 16px; color: rgb(178, 214, 255); font-weight: bold;font-family: Arial;">Date:'+objnew.createddate+'</td></tr></table><table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td align="left" height="60" style="font-family:arial;font-size:16px;padding-left: 24px;" valign="middle">Dear  '+strusername+','+'</td><td align="right" valign="middle"></td></tr></table><table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td align="left" style="font-family:arial;font-size:16px;padding-left: 24px;" width="100%">Thank you for contacting Honeywell Aerospace Customer &amp; Product Support. Here are the details we have received from Direct Access.</td></tr></table><table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td height="20"></td></tr></table><table  border="0" cellpadding="0" cellspacing="0" width="100%" style="padding-left: 24px;"><tr><td class="col-left">Phone:</td><td class="col-right">'+phone+'</td></tr><tr><td height="15"></td></tr><tr><td class="col-left">Your Business Email Address:</td><td class="col-right">'+Email+'</td></tr><tr><td height="15"></td></tr><tr id="idAircraftDeliverydate"><td class="col-left">Alternative Email Address: </td><td class="col-right">'+Alter+'</td></tr><tr><td height="15"></td></tr><tr><td class="col-left">Problem Description:</td><td class="col-right"></td></tr><tr><td height="15"></td></tr><tr ><td class="col-desc" colspan="2">'+Description+'</td></tr><tr><td height="20"></td></tr><tr ><td class="col-desc" colspan="2"><span  style="font-size:16px; ">Your case tracking number for this inquiry is provided above. If you wish to communicate with us further about this inquiry, you may reply to this e-mail - please leave the Reference Case Number within the subject line for quicker responses.<br><br>Honeywell Aerospace<br>Customer &amp; Product Support<br></span><span  style="font-size:16px; text-decoration:underline; color:#679afa; ">www.MyAerospace.com</span><span  style="font-size:16px; text-decoration:underline; "><br></span><span  style="font-size:16px; ">1-800-601-3099 or internationally at 1-602-365-3099<br><br>ORIGINAL CORRESPONDENCE:<br><br>Sent from Honeywell Direct Access App<br><br>'+objnew.Case_Ref_ID__c+'<br></span></td></tr></table></td></tr></table></body></html>';            
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] { Alter };                                           
                mail.setToAddresses(toAddresses);            
                mail.setSubject('Honeywell - Your Database Services Accounts Submission  '+objnew.CaseNumber+' '+objnew.Case_Ref_ID__c);
                mail.setHtmlBody(html);
                mail.setOrgWideEmailAddressId(label.AIS_ACC_OWD_ID);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
            }            
            if(enc != null)
            {
                attachment.name = strname;
                attachment.ParentId=objnew.id;
                attachment.body = EncodingUtil.base64Decode(enc);
                insert attachment;
                System.debug(enc);
            }
            System.debug(objnew.id);
            return objnew;
        } 
    private final static String ENP_POINT_URL = 'https://test.salesforce.com/services/oauth2/token';
    //For development and production https://login.salesforce.com/services/oauth2/token
    //And for sandbox https://test.salesforce.com/services/oauth2/token
    private final static String REQUEST_BODY = 'grant_type=password&client_id={0}&client_secret={1}&username={2}&password={3}';
    private final static String USERNAME = 'aero.default@honeywell.com.qa';
    private final static String PASSWORD = 'Honeywell4';
    private final static String CONSUMER_KEY = '3MVG9Y6d_Btp4xp7PGqmkD3T9iA9YrK1xKBhqvy.kbV1l.t5p7DD.Gd27rzoyctl1kS5E7xcSRvkUeUUr7PAB';
    private final static String CONSUMER_SECRET = '3184479236341752248';   
    @RemoteAction
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
    }  
    /*To get aouthentication detail Wrapper*/
    public class OAuth{
        public String id{get;set;}
        public String issued_at{get;set;}
        public String instance_url{get;set;}
        public String signature{get;set;}
        public String access_token{get;set;}            
    }   
    @RemoteAction
    Static public Case caseownerupdate(String caseid)
    {
        case ca=[select id,OwnerId,RecordTypeId  from case where id=:caseid];
        if(ca.RecordTypeId  == label.Case_Flight_Ops_Issue_pilot)
        {
            ca.OwnerId=label.Case_Flight_Ops_Issue_pilot_owner;
        }
        else if(ca.RecordTypeId  == label.Case_NavDB_Accts_RecordType)
        {
            ca.OwnerId=label.Case_NAVDB_Owner;
        }
        update ca;
        return ca;
    }    
}