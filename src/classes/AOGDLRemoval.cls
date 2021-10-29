public class AOGDLRemoval {

public string uemail{get;set;}
public string adEmail{get;set;}
public boolean result{get;set;}
public string DLName;

            public AOGDLRemoval() {
            this.DLName = ApexPages.currentPage().getParameters().get('DLName');
            result = true;
            }
            public String getUemail() {
                  return this.uemail;
            }

            public void setUemail(String uemail) {
                  this.uemail = uemail;
            }
            public String getAdEmail() {
                  return this.adEmail;
            }

            public void setAdEmail(String adEmail) {
                  this.adEmail = adEmail;
            }
            
        public String[] toAddresses = new String[] {system.label.AOGDLRemoval_Emails}; 
        public PageReference send() {
         DLName = ApexPages.currentPage().getParameters().get('DLName');
        string Body = '<!DOCTYPE html> <body><table border="0" cellpadding="0" cellspacing="0"'+
        ' width="950" style="position: absolute;right: 50px;">'+
        '<tr><td align="center" height="45" valign="top">'+
        '<img src="https://c.cs23.content.force.com/servlet/servlet.ImageServer?id=015300000018fo4&oid=00D180000000cAr"'+
        ' alt="Logo" style="border:none;display:block;right: 20px;position: absolute;top: 10px;height: 30px;"/>'+
        ' </td> </tr><br/> </table> <table border="0" cellpadding="5" cellspacing="0" width="600" style="position:'+
        'absolute;right: 50px;border-top-width: 4px;border-top-style: solid;border-top-color: #ED2028;border-bottom-width:'+
        '4px;border-bottom-style: solid;border-bottom-color: #ED2028;"> <tr> <td align="right" valign="top">'+
        '<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td align="left" height="60"'+
        ' style="font-family:Verdana;font-size:14px;padding-left: 24px;" valign="middle">';
        If(uemail.length()!=0 || adEmail.length() !=0){
        if(uemail.length()>0){ 
        Body = Body +'Please remove ' + uemail +' from the DL given in email subject.';
        }
        if(adEmail.length()>0){
        Body = Body +'<br/><br/>'+'Please add '+adEmail+' to the DL given in email subject.';
        }
        Body = Body +'<br/><br/>Thank You,<br/>SFDC Admin.';

        // Define the email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 

        // Sets the paramaters of the email
        email.setSubject('Please change distribution list: '+DLName);
        email.setToAddresses( toAddresses );
        email.sethtmlbody(Body);
        email.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
    
        // Sends the email
        Messaging.SendEmailResult [] r =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
        if (r.get(0).isSuccess()) {
        result = false;
        Apexpages.addMessage(new ApexPages.Message(ApexPages.severity.Confirm, 'Thank you for your submission.'));
        }
        if (!r.get(0).isSuccess()) {
        System.StatusCode statusCode = r.get(0).getErrors()[0].getStatusCode();
        String errorMessage = r.get(0).getErrors()[0].getMessage();
        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.error, errorMessage));
        }  
        }else{
        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.error, 'Please enter valid email address'));
        }
        return null;
    }

}