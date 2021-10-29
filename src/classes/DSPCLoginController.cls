/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class DSPCLoginController {
    global String username{get;set;}
    global String password{get;set;}
    //Email variables
    public string enteredname{get;set;}
    public string Subject{get;set;}
    public string mailbody{get;set;}
    global DSPCLoginController () {
        enteredname = '';
        Subject = '';
        mailbody = '';    
    }
    global PageReference forwardToDSPCAuthPage() {
        return new PageReference( '/dspc/D_S_Portal_CommunitiesLogin'); 
    }
    /*
    global PageReference login() {
        
        return Site.login(username, password, null);
    }
    */
    global PageReference forgotPassword() {
        return new PageReference( '/D_S_ForgotPassword');
    }
    // Send Email Method
    public void sendMail(){
        Messaging.SingleEmailMessage mailHandler = new Messaging.SingleEmailMessage();
        String[] emailRecipient = new String[]{Label.DSPC_Contact_Us_Mail_Id}; // DSPC_Contact_us_Letterhead_url
        string LHead = '<img src="'+Label.DSPC_Contact_us_Letterhead_url+'"/>';
        //string LHead = '<img src="'+Label.DSPC_ServerName+'/servlet/servlet.ImageServer?id=015c0000000AUL6&oid=00Dc0000003s6iA&lastMod=1389005713000"/>';
        string netmail = Lhead+'<br/>'+mailbody;
        mailHandler.setToAddresses(emailRecipient);
        mailHandler.setSenderDisplayName(enteredname);
        mailHandler.setSubject(Subject);
        mailHandler.setHtmlBody(netmail);
        Messaging.sendEmail(new Messaging.Email[] { mailHandler });
}

}