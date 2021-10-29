public with sharing class DSPC_ContactUs {
    public string enteredname{get;set;}
    public string Subject{get;set;}
    public string mailbody{get;set;}
    public string uname{get;set;}
    public DSPC_ContactUs () {
        enteredname = '';
        Subject = '';
        mailbody = ''; 
        uname = userinfo.getname();   
    } 
    public pagereference sendMail(){
        Messaging.SingleEmailMessage mailHandler = new Messaging.SingleEmailMessage();
        String[] emailRecipient = new String[]{Label.DSPC_Contact_Us_Mail_Id};
        //string LHead = '<img src="'+Label.DSPC_ServerName+'/servlet/servlet.ImageServer?id=015c0000000AUL6&oid=00Dc0000003s6iA&lastMod=1389005713000"/>';
        string LHead = '<img src="'+Label.DSPC_Contact_us_Letterhead_url+'"/>';
        string netmail = Lhead+'<br/>'+mailbody;
        mailHandler.setToAddresses(emailRecipient);
        mailHandler.setSenderDisplayName(uname);
        mailHandler.setSubject(Subject);
        mailHandler.setHtmlBody(netmail);
        Messaging.sendEmail(new Messaging.Email[] { mailHandler });
        pagereference pageref = new pagereference('/dspc/apex/D_S_Thank_You_mail_Box');
        pageref.setredirect(true);
        return pageref; 
    } 
    public pagereference closebox() {
        pagereference pageref = new pagereference('/dspc/home/home.jsp'); //apex/D_S_Portal_Communities_landing
        pageref.setredirect(true);
        return pageref;
    } 
}