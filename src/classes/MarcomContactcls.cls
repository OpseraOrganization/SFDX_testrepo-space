public class MarcomContactcls {

    public String filedata { get; set; }
    
          public void setfiledata(String filedata)
          {
           this.filedata= filedata;
          }

    public String filename { get; set; }
    
          public void setfilename(String filename )
          {
           this.filename = filename ;
          }
    public MarcomContactcls() {
    }
          public string descrption{get;set;} 
         
          public void setdescrption(String descrption)
          {
           this.descrption= descrption;
          }
          public string firstname{get;set;}  
          
         
          public void setfirstname(String firstname)
          {
           this.firstname = firstname;
          }
          
          public string lastname{get;set;}  
         
          public void setlastname(String lastname)
          {
           this.lastname= lastname;
          }
          public string email{get;set;} 
         
          public void setemail(String email)
          {
           this.email= email;
          } 
          public string phonenumber{get;set;}  
           
          public void setphonenumber(String phonenumber)
          {
           this.phonenumber= phonenumber;
          }
      public PageReference save() {  
           String email1=Label.Marcom_Contact_Us;
           String email2=Label.Marcom_ContactUs_Email;
           system.debug(email1+email2);
           PageReference pr = new pagereference('/apex/Marcom_Contactus_Form?'); 
           Messaging.SingleemailMessage Mail=new Messaging.SingleemailMessage();
           mail.setSubject('Contact Request From '+firstname);
           mail.setToAddresses(new String[]{Label.Marcom_Contact_Us,Label.Marcom_ContactUs_Email});
           mail.setHtmlBody('<b> New Contact Request From&nbsp;&nbsp;'+firstname   +' </b><br/><br/><b>What can you help?:&nbsp;&nbsp;&nbsp;&nbsp;</b>'+ descrption +'<br/><b>First name:&nbsp;&nbsp;&nbsp;&nbsp;</b>'+firstname+'<br/><b>Last name:&nbsp;&nbsp;&nbsp;&nbsp;</b>'+lastname+'<br/><b>Email:&nbsp;&nbsp;&nbsp;&nbsp;</b>'+email+'<br/><b>Phone Number:&nbsp;&nbsp;&nbsp;&nbsp;</b>'+phonenumber); 
           messaging.sendEmail(new Messaging.singleemailmessage[] {mail});  
           pr.setRedirect(true);
           return pr;  
    }  
}