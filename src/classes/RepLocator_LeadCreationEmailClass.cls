/*
Class Name : RepLocator_LeadCreationEmailClass
Functionality: This class is used to send email to leads once the are created from Bullseye platform in Rep Locator Project.
Created by: Nagarajan Varadarajan
Created on: 27/6/2017
*/
public class RepLocator_LeadCreationEmailClass {
 public static void sendEmailtoLeads(Lead leads) {
  try {
   List < Messaging.SingleEmailMessage > emailsForLeads;
   emailsForLeads = new List < Messaging.SingleEmailMessage > ();

   //Lead creation Email to channel partner and marketing team
   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

    String formattedDate = leads.CreatedDate.format('MMM dd, YYYY');
    String Other;
    String Description;
    String Platform; 
    String AccCountry;
    String Phone;
    String Email;
    String Company;
    String LastName;
    String FirstName;
    String LeadMarket;
    
    String ChannelPartName;
    String ChannelPartAdd1;
    String ChannelPartAdd2;
    String ChannelPartCity;
    String ChannelPartState;
    String ChannelPartZip;
    String ChannelPartCountry;
    String ChannelPartEmail;
    String ChannelPartSource;
    String honrepemail;
    if(leads.Other__c == NULL || leads.Other__c == '')
    {
      Other = '';
    }
    else
    {
      Other = leads.Other__c;
    }
    if(leads.Lead_Description__c == NULL || leads.Lead_Description__c == '')
    {
      Description = '';
    }
    else
    {
      Description = leads.Lead_Description__c;
    }
    
    if(leads.Type_of_Platform__c == NULL || leads.Type_of_Platform__c == '')
    {
      Platform = '';
    }
    else
    {
      Platform  = leads.Type_of_Platform__c;
    }
    if(leads.Account_Country__c == NULL || leads.Account_Country__c == '')
    {
      AccCountry = '';
    }
    else
    {
      AccCountry = leads.Account_Country__c;
    }
    if(leads.Primary_Work_Number__c == NULL || leads.Primary_Work_Number__c == '')
    {
      Phone = '';
    }
    else
    {
      Phone = leads.Primary_Work_Number__c;
    }
    if(leads.Email == NULL || leads.Email == '')
    {
      Email = '';
    }
    else
    {
      Email = leads.Email;
    }
    if(leads.Company == NULL || leads.Company == '')
    {
      Company = '';
    }
    else
    {
      Company = leads.Company;
    }
    if(leads.LastName== NULL || leads.LastName == '')
    {
      LastName = '';
    }
    else
    {
      LastName = leads.LastName;
    }
    if(leads.FirstName== NULL || leads.FirstName == '')
    {
      FirstName = '';
    }
    else
    {
      FirstName = leads.FirstName;
    }
    if(leads.Lead_Market__c== NULL || leads.Lead_Market__c == '')
    {
      LeadMarket = '';
    }
    else
    {
      LeadMarket = leads.Lead_Market__c;
    }
    
    if(leads.Channel_Partner_Name__r.BGAMob_Customer_Name__c == NULL || leads.Channel_Partner_Name__r.BGAMob_Customer_Name__c == '')
    {
      ChannelPartName = '';
    }
    else
    {
      ChannelPartName = leads.Channel_Partner_Name__r.BGAMob_Customer_Name__c;
    }
    
    if(leads.Channel_Partner_Name__r.BGAMob_Address_1__c == NULL || leads.Channel_Partner_Name__r.BGAMob_Address_1__c == '')
    {
      ChannelPartAdd1 = '';
    }
    else
    {
      ChannelPartAdd1 = leads.Channel_Partner_Name__r.BGAMob_Address_1__c;
    }
    if(leads.Channel_Partner_Name__r.BGAMob_Address_2__c == NULL || leads.Channel_Partner_Name__r.BGAMob_Address_2__c == '')
    {
      ChannelPartAdd2 = '';
    }
    else
    {
      ChannelPartAdd2 = leads.Channel_Partner_Name__r.BGAMob_Address_2__c;
    }
    if(leads.Channel_Partner_Name__r.BGAMob_City_Name__c == NULL || leads.Channel_Partner_Name__r.BGAMob_City_Name__c == '')
    {
      ChannelPartCity = '';
    }
    else
    {
      ChannelPartCity = leads.Channel_Partner_Name__r.BGAMob_City_Name__c;
    }
    
    if(leads.Channel_Partner_Name__r.BGAMob_State_Province__c == NULL || leads.Channel_Partner_Name__r.BGAMob_State_Province__c == '')
    {
      ChannelPartState = '';
    }
    else
    {
      ChannelPartState = leads.Channel_Partner_Name__r.BGAMob_State_Province__c;
    }
    if(leads.Channel_Partner_Name__r.BGAMob_Postal_Code__c== NULL || leads.Channel_Partner_Name__r.BGAMob_Postal_Code__c== '')
    {
      ChannelPartZip = '';
    }
    else
    {
      ChannelPartZip = leads.Channel_Partner_Name__r.BGAMob_Postal_Code__c;
    }
    if(leads.Channel_Partner_Name__r.BGAMob_Country_Nm__c == NULL || leads.Channel_Partner_Name__r.BGAMob_Country_Nm__c == '')
    {
      ChannelPartCountry = '';
    }
    else
    {
      ChannelPartCountry = leads.Channel_Partner_Name__r.BGAMob_Country_Nm__c;
    }
    
    if(leads.Channel_Partner_Name__r.BGAMob_Contact_Email__c == NULL || leads.Channel_Partner_Name__r.BGAMob_Contact_Email__c == '')
    {
      ChannelPartEmail = '';
    }
    else
    {
      ChannelPartEmail = leads.Channel_Partner_Name__r.BGAMob_Contact_Email__c;
    }
    if(leads.Lead_Source_Other__c == NULL || leads.Lead_Source_Other__c == '')
    {
      ChannelPartSource = '';
    }
    else
    {
      ChannelPartSource = leads.Lead_Source_Other__c;
    }
    if(leads.HONEYWELL_ID__c == NULL || leads.HONEYWELL_ID__c == '')
    {
      honrepemail = '';
    }
    else
    {
      honrepemail = leads.HONEYWELL_ID__c;
    }
    
      String Message;
   if (leads.Lead_Source_Other__c == 'Channel Partner') {
   mail.setOrgWideEmailAddressId(label.replocator_fromaddress);
    List <String> ChannelPartnerToId = new List <String> ();
    List <String> ChannelPartnerCcId = new List <String> ();
   // ChannelPartnerCcId.add(System.Label.RepLocator_ChannelPartnerToEmailId);
    ChannelPartnerToId = System.Label.RepLocator_ChannelPartnerToEmailId.split(',');
    if (leads.Channel_Partner_Name__r.BGAMob_Contact_Email__c != null && leads.Channel_Partner_Name__r.BGAMob_Contact_Email__c != '') {
     ChannelPartnerToId.add(leads.Channel_Partner_Name__r.BGAMob_Contact_Email__c);
     mail.setSubject('Honeywell Aerospace Inquiry from ' + leads.name);
    }else{
    mail.setSubject('Honeywell Aerospace Inquiry From ' + leads.name +' - Missing Channel Partner Email');
    }
    mail.setToAddresses(ChannelPartnerToId);
    
    Message = '<html> <p>Congratulations! You’ve received a new lead from Honeywell’s marketing team. Please review the customer’s information below and follow-up with them at your earliest convenience. You will be contacted by a Honeywell marketing manager in 5-7 business days to follow-up on the status of this lead. Happy selling!</p> <table> <tr><td> </td></tr>  <tr><td><strong>Created On:</strong></td> <td style="margin-left:0.3%">' + formattedDate + ' </td></tr>       <tr> <td> </td></tr>       <tr><td><strong>To:</strong> </td><td> ' + ChannelPartName + '</td>   <tr><td></td><td>' + ChannelPartAdd1 + '</td>  </tr>     <tr><td></td><td>' + ChannelPartAdd2 + '</td> </tr>   <tr><td></td><td>' + ChannelPartCity + ', ' + ChannelPartState + ' ' + ChannelPartZip  + '</td> </tr>    <tr><td></td><td>' + ChannelPartCountry + '</td></tr>         <tr><td><strong>Email:</strong></td><td><a href="mailto:' + ChannelPartEmail + '">' + ChannelPartEmail + '</a></td> </tr>       <tr><td><strong>Type:</strong></td> <td>' + ChannelPartSource + ' </td></tr>         <tr><td><strong>Market:</strong></td><td>' + LeadMarket + ' </td></tr>   <tr><td></td>        <tr><td><strong>From: </strong> </td><td>' + FirstName + ' ' + LastName + ' </td></tr>       <tr> <tr ><strong>Company:</strong> </td><td>' + Company + '</td></tr>    <tr><td><strong>Email: </strong> </td><td>' + Email + ' </td></tr>   <tr><td><strong>Phone: </strong> </td><td>' + Phone + '</td></tr>      <tr><td><strong>Country:</strong></td><td>' + AccCountry + ' </td></tr>   <tr><td><strong>Platform:</strong> </td><td>' + Platform + '</td></tr>      <tr><td> </td></tr>        <tr><td><strong>Area of Interest:</strong> </td><td>' + Description + '</td></tr>        <tr><td> </td> </tr>       <tr><td><strong>Referring URL: </strong></td><td>' + Other + '</td></tr>    </table>  <p> Best Regards,<p/><p> Honeywell Marketing Team</p>  </html>';
   }
   if (leads.Lead_Source_Other__c == 'Honeywell Rep') {
   mail.setOrgWideEmailAddressId(label.AeroNo_Reply_email_ID);
    List < String > HonRepsToId = new list<string>();  //System.Label.RepLocator_HoneywellRepToEmailId.split(',');
    HonRepsToId.add(leads.HONEYWELL_ID__c);
    mail.setToAddresses(HonRepsToId);
    mail.setSubject('Honeywell Aerospace Inquiry From ' + leads.name);
    Message = '<html> <p>A new inquiry has been sent to you from the Aerospace Directory. Please follow up with the customer within 24 to 48 hours.</p>'+
    '<p>If this is a lead, our marketing team will assign a lead to you in Salesforce.com. If this is not a lead, please follow your standard customer support process for assisting the customer with their needs.</p>'+
    '<p>Note: If your data in the Aerospace Directory isn’t correct, please make the correction through your standard Salesforce.com administrative update process.</p>'+
    '<table> <tr><td> </td></tr>  <tr><td><strong>Created On:</strong></td> <td style="margin-left:0.3%">' + formattedDate + ' </td></tr>    <tr> <td> </td></tr>       <tr><td><strong>Honeywell Rep:</strong> </td><td> ' + honrepemail + '</td>   <tr><td><strong>Market:</strong></td><td>' + LeadMarket + ' </td></tr>  <tr><td></td>        <tr><td><strong>From: </strong> </td><td>' + FirstName + ' ' + LastName + ' </td></tr>    <tr> <tr ><strong>Company:</strong> </td><td>' + Company + '</td></tr>   <tr><td><strong>Email: </strong> </td><td>' + Email + ' </td></tr>  <tr><td><strong>Phone: </strong> </td><td>' + Phone + '</td></tr>      <tr><td><strong>Country:</strong></td><td>' + AccCountry + ' </td></tr>  <tr><td><strong>Platform:</strong> </td><td>' + Platform + '</td></tr>   <tr><td> </td></tr>     <tr><td><strong>Area of Interest:</strong> </td><td>' + Description + '</td></tr> <tr><td> </td> </tr>        <tr><td><strong>Referring URL: </strong></td><td>' + Other + '</td></tr>    </table>  <p> Best Regards,<p/><p> Honeywell Aerospace Customer Support</p>  </html>';
   }
   mail.setHTMLBody(Message);

   emailsForLeads.add(mail);
   system.debug('emailsForLeads ########:' + emailsForLeads);
   if (emailsForLeads.size() > 0) {
     Messaging.sendEmail(emailsForLeads);
   }

  
  //Confirmation Email to end user
  List < Messaging.SingleEmailMessage > emailsForLeads1;
  emailsForLeads1 = new List < Messaging.SingleEmailMessage > ();
  Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
  List < String > emailIds = new List < String > ();
  //emailIds = System.Label.RepLocator_ChannelPartnerToEmailId.split(',');
  if (leads.email != null) {
   emailIds.add(leads.email);
  }
  mail1.setToAddresses(emailIds);
  //mail1.setOrgWideEmailAddressId(label.replocator_fromaddress);
  String Message1;
  if (leads.Lead_Source_Other__c == 'Channel Partner') {
   mail1.setOrgWideEmailAddressId(label.replocator_fromaddress);
   mail1.setSubject('Honeywell Aerospace Inquiry Confirmation');
   Message1 = '<html> <p>Thank you for sending a message! We have routed your message directly to the Dealer, Distributor or Service Center listed below and they will be in touch with you as soon as possible.</p> <table> <tr><td> </td></tr>  <tr><td><strong>Created On:</strong></td> <td style="margin-left:0.3%">' + formattedDate + ' </td></tr>       <tr> <td> </td></tr>       <tr><td><strong>To:</strong> </td><td> ' + ChannelPartName + '</td>   <tr><td></td><td>' + ChannelPartAdd1 + '</td>  </tr>     <tr><td></td><td>' + ChannelPartAdd2 + '</td> </tr>   <tr><td></td><td>' + ChannelPartCity + ', ' + ChannelPartState + ' ' + ChannelPartZip + '</td> </tr>    <tr><td></td><td>' + ChannelPartCountry + '</td></tr>         <tr><td><strong>Email:</strong></td><td><a href="mailto:' + ChannelPartEmail + '">' + ChannelPartEmail + '</a></td> </tr>       <tr><td><strong>Type:</strong></td> <td>' + ChannelPartSource + ' </td></tr>         <tr><td><strong>Market:</strong></td><td>' + LeadMarket + ' </td></tr>   <tr><td></td>        <tr><td><strong>From: </strong> </td><td>' + FirstName + ' ' + LastName + ' </td></tr>       <tr> <tr ><strong>Company:</strong> </td><td>' + Company + '</td></tr>    <tr><td><strong>Email: </strong> </td><td>' + Email + ' </td></tr>   <tr><td><strong>Phone: </strong> </td><td>' + Phone + '</td></tr>      <tr><td><strong>Country:</strong></td><td>' + AccCountry + ' </td></tr>   <tr><td><strong>Platform:</strong> </td><td>' + Platform + '</td></tr>      <tr><td> </td></tr>        <tr><td><strong>Area of Interest:</strong> </td><td>' + Description + '</td></tr>        <tr><td> </td> </tr>       <tr><td><strong>Referring URL: </strong></td><td>' + Other + '</td></tr>    </table>  <p> Best Regards,<p/><p> Honeywell Marketing Team</p>  </html>';
  }
  if (leads.Lead_Source_Other__c == 'Honeywell Rep') {
   mail1.setOrgWideEmailAddressId(label.AeroNo_Reply_email_ID);
   mail1.setSubject('Honeywell Aerospace Inquiry Confirmation');
    Message1 = '<html> <p>Thank you for sending a message! A Honeywell Representative will be in touch with you as soon as possible.</p> <table><tr><td> </td></tr><tr><td><strong>Created On:</strong></td><td style="margin-left:0.3%">' + formattedDate + ' </td></tr>    <tr><td><strong>Honeywell Rep:</strong> </td><td> ' + honrepemail + '</td><tr><td><strong>Market:</strong></td><td>' + LeadMarket + ' </td></tr> <tr><td><strong>From: </strong> </td><td>' + FirstName + ' ' + LastName + ' </td></tr>  <tr> <td><strong>Company:</strong> </td><td>' + Company + '</td></tr>  <tr><td><strong>Email: </strong> </td><td>' + Email + ' </td></tr>  <tr><td><strong>Phone: </strong> </td><td>' + Phone + '</td></tr><tr><td><strong>Country:</strong></td><td>' + AccCountry + ' </td></tr><tr><td><strong>Platform:</strong> </td><td>' + Platform + '</td></tr><tr><td><strong>Area of Interest:</strong> </td><td>' + Description + '</td></tr><tr><td><strong>Referring URL: </strong></td><td>' + Other + '</td></tr>   </table><p> Best Regards,<p/><p> Honeywell Aerospace Customer Support</p>  </html>';
  }
  mail1.setHTMLBody(Message1);
  emailsForLeads1.add(mail1);

  if (emailsForLeads1.size() > 0) {
   Messaging.sendEmail(emailsForLeads1);
  }
 }
  catch (exception e) {
  system.debug('exception in RepLocator_LeadCreationEmailClass: ' + e + e.getStackTraceString());
  //Failure notice to Channel partner mailbox
  List < Messaging.SingleEmailMessage > emailsForLeads1;
  emailsForLeads1 = new List < Messaging.SingleEmailMessage > ();
  Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
  List < String > emailIds = new List < String > ();
  emailIds.add(label.RepLocator_ChannelPartnerCCEmailId);
  mail1.setToAddresses(emailIds);
  mail1.setOrgWideEmailAddressId(label.replocator_fromaddress);
  String Message1;
  mail1.setSubject('Rep Locator Lead Email Notification Failed');
  Message1 = '<html> <p>Email notification for a lead submitted via Rep Locator if failed with below error. Please contact System Adminstrator.</p><p>Lead ID:'+Leads.id+
   '<p>Error:'+e+ e.getStackTraceString()+' <p/>   <p> Best Regards,<p/><p> SFDC Admin</p>  </html>';
 
  mail1.setHTMLBody(Message1);
  emailsForLeads1.add(mail1);
  Messaging.sendEmail(emailsForLeads1);
  }
 }
}