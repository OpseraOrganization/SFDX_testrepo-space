global class AccountNotSetUpBatch implements Database.Batchable<SObject>,Schedulable{

global String query;
global string valemail='Y';
global integer todaydate=System.Today().year();

global AccountNotSetUpBatch(){

}
 
global Database.QueryLocator start(Database.BatchableContext bc){
Datetime dt1=System.now()-30;
Datetime dt2=System.now()-31;
System.debug('dt1 ==> '+dt1);
System.debug('dt2 ==> '+dt2);
 //Integer year=dt.year();
 //Integer month=dt.month();
 //Integer date1=dt.day();
query='select id,Honeywell_ID__c,Validating_Email__c, EmailAddress__c,Create_HoneywellId__c,Initial_Reg__c from Portal_User_Registration__c where (Created_Date__c>=:dt2 and Created_Date__c<=:dt1) and Validating_Email__c!=:valemail ';
//query='select id,Honeywell_ID__c,Validating_Email__c, EmailAddress__c,Create_HoneywellId__c,Initial_Reg__c from Portal_User_Registration__c where Created_Date__c>=:dt1';
System.debug('query'+query);
return Database.getQueryLocator(query);
}
global void execute(Database.batchableContext bc,List<SObject> scope){
Messaging.Email[] messages = new Messaging.Email[0];
    List<SObject> purNotValidatedUsers = new List<SObject>();
    for(Sobject s : scope){
      Portal_User_Registration__c newuser = (Portal_User_Registration__c) s;
        System.debug ('Type ' + newuser.EmailAddress__c ) ;
         if(newuser!=null && newuser.Initial_Reg__c == 'Y' && newuser.Create_HoneywellId__c != 'Y' && newuser.EmailAddress__c!=null ){
                           
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                  String[] toAddresses = new String[] {newuser.EmailAddress__c};
                  //List<String> toAddresses=new List<String>();
                    //toAddresses.add('phani.raj@honeywell.com');
                  //string emailTemplateId = Label.Account_not_set_up;   
                   
                    String subject='MyAerospace Account Not Set Up';
                   /* String body='<html><head >'+'<meta charset="UTF-8">'+
                       '<tr><td bgcolor="#ffffff" align="center">'+
                  '<img src="https://hon-aero--c.na68.content.force.com/servlet/servlet.ImageServer?id=0151B000003opN1&oid=00D30000000dWxY&lastMod=1524750822000"  class="img-responsive" align="left"/>'+
                  '<br>'+
                  '<br>'+
                  '<br>'+
                   '<br>'+
                   '<br>'+
                   '<br>'+
                   
                  
                    '</head><body><table width="700" border="0" cellpadding="0" cellspacing="0">'+
                       '<table width="700" border="0" cellpadding="0" cellspacing="0" >'+
                        '<tr><td height="50" align="left" style="padding-left:20px;font-family:Arial; font-size:16px;">'+
                        '<p><b>MyAerospace Account Not Setup</b></p>'+
                          '<p colspan="2" style="text-align:left;"><span style="color:#000000;">Your new Honeywell MyAerospace account was not activated within the 30 days activation </span><br>window and for security reasons your username: '+newuser.Honeywell_ID__c+' has been deleted from<br>our system.</p>'+
                             '<p>In order to take advantage of the online resources available on MyAerospace, you will need<br> to register again.</p>'+
                             '<p><b>Note: </b>This email is being sent from an unmonitored mailbox. If you need further assistance, please contact a Customer Support team member at:</p>'+
                             '<p ><span >1-(800) 601-3099</span> For US/Canada (Toll Free)<br><span >1-(602) 365-3099</span> International<br>Choose option 7 (Web Support).</p><b><p style="text-align:center;color:#CECECE;  font-family:Arial width:700px;">Thank you,<br>Honeywell Aerospace Customer Support Team</p></b></td></tr>'+
                          '</tr></table>'+
                          '<table width="700" align="left"  >'+
                       '<p align="center"><span><a href="https://myaerospace.honeywell.com/contact-us/"><img src="https://hon-aero--c.na68.content.force.com/servlet/servlet.ImageServer?id=0151B000003opN6&oid=00D30000000dWxY&lastMod=1524750874000"/></a></span>'+             
                      '<br>'+'<span style="color:#CECECE; font-size: 12px; font-family:Arial; text-align:center; padding-left:20px;">© '+ todaydate+' Honeywell International Inc.</span>'+
                      '<br>'+'<span style="color:#CECECE; font-size: 12px; font-family:Arial; text-align:center;width:700px;"><a style="color:#CECECE; margin-left:20px;" href="https://www.honeywell.com/terms-conditions\">Terms of Use</a> | <a style="color:#CECECE;" href="https://www.honeywell.com/privacy-statement\"> Privacy Policy</a> | <a style="color:#CECECE;" href="https://myaerospace.honeywell.com/contact-us/">Contact Us</a></span></p>'+'</table>'+
                     '</td>';
                    body=body+'</table></body></html>';  
                    */
                   String body='<html><head><style>body{background-color:#F7F7F7}</style></head>'+'<body bgcolor="#F7F7F7" style="background-color:#F7F7F7;"><div style="background-color:#F7F7F7;width:660px;margin:0 auto" ><br><table align="center" border="0" cellpadding="0" cellspacing="0" width="600">  <tr name="emailBody" bgcolor="#fff" style="background-color:#fff;"><td style="padding:10px;box-shadow: 0 -6px 0 #fff, 0 1px 3px rgba(0,0,0, .35);"><br><img src="https://hon-aero--qa--c.cs69.content.force.com/servlet/servlet.ImageServer?id=0152D0000000iff&oid=00D2D0000000Mtw&lastMod=1564128463000" width="200" class="header"><br><br><b style="font-family: Arial;font-size: 14px;color: #0B0000;text-align: left;line-height: 19px;">MyAerospace Account Not Setup</b><p style="font-family: Arial;font-size: 14px;color: #0B0000;text-align: left;line-height: 19px;">Your new Honeywell MyAerospace account was not activated within the 30 days activation </span><br>window and for security reasons your username: '+newuser.EmailAddress__c+' has been deleted from<br>our system.</p>'+
                    '<span style="font-family: Arial;font-size: 14px;color: #0B0000;text-align: left;line-height: 19px;">In order to take advantage of the online resources available on MyAerospace, you will need<br> to register again.</span><br>'+'<br></td></tr>'+'<tr  bgcolor="transparent" style="background-color:transparent !important;height:25px;" height="25px;" ><td height="25px;"><br></td></tr>'+'<tr name="emailFooter" bgcolor="#fff" style="background-color:#fff;"><td style="padding:10px;box-shadow: 0 -6px 0 #fff, 0 1px 3px rgba(0,0,0, .35);">'+'               <b style="font-family: Arial;font-weight:bold;font-size: 18px;color: #404040;text-align: left;line-height: 19px;">Note</b><br>'+'<p style="color:#404040;font-family: Arial;font-size: 14px;text-align: left;line-height: 19px;">This email is being sent from unmonitored mailbox. If you need further assistance, please contact a customer support team member at:</p>'+'<b><span style="font-size:14px;color:#3366FF;font-family: Arial;">1-800-601-3099</span></b><span style="font-size:14px;color:#404040;font-family: Arial;">  For US / Canada (Toll Free)</span><br>'+'<b><span style="font-size:14px;color:#3366FF;font-family: Arial;">1-602-365-3099</span></b><span style="font-size:14px;color:#404040;font-family: Arial;">  International</span><br>'+'                    <span style="font-size:14px;color:#404040;font-family: Arial;"> Choose Option 7 (Web Support)</span><br><br>'+'</td></tr>'+'<tr  bgcolor="transparent" style="background-color:transparent !important;height:25px;" height="25px;" ><td height="25px;"><br></td></tr>'+'<tr  bgcolor="#fff" style="background-color:#fff;"><td style="padding:10px;box-shadow: 0 -6px 0 #fff, 0 1px 3px rgba(0,0,0, .35);">'+'<p style="color:#707070;font-size:18px;text-align:center;font-family: Arial;">Thank You,<br>Honeywell Aerospace Customer Support Team</p><br>'+'  <table align="center" height="45" style="width: 590px;border: 1px solid #1792E5;height: 45px;"><tr align="center"><td><a style="color: #1792E5;text-decoration: none;cursor: pointer;width: 100%;font-size:14px;font-weight: bold; background: #fff;font-family: Arial" href="https://aerospace.honeywell.com/en/contact-us">CONTACT US </a></td></tr></table><br>'+'</td></tr>'+'<tr><td style="padding:10px;"><br><table align="center" border="0" style="width: 400px;height: 100px;">'+'<tr align="center"><td><span style="font-family: Arial;font-size: 11px;color: #808080;text-align: center;line-height: 19px;">&copy; <span id="year">2019</span> Honeywell International Inc.</span><br><br><span  align="center" style="font-size:11px;color:#323232;"><b><a href="https://www.honeywell.com/en-us/terms-and-conditions" style="text-decoration: none;color:#696969;font-family: Arial;">Terms of Use</a>&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;<a href="https://www.honeywell.com/en-us/privacy-statement" style="text-decoration: none;color:#696969;font-family: Arial;">Privacy Policy</a>&nbsp;&nbsp;|&nbsp; &nbsp;&nbsp;<a href="https://aerospace.honeywell.com/en/contact-us" style="text-decoration: none;color:#696969;font-family: Arial;">Contact Us</a></span></b></td></tr>'+'</table></td></tr></table></div>'+'</body></html>'; 
                        
                    mail.setHtmlBody(body);
                    
                    
                    mail.setToAddresses(toAddresses); 
                   //mail.setReplyTo('myaerospace@honeywell.com');
                   mail.setOrgWideEmailAddressId(Label.RegistrationAddress);
                    mail.setSubject(subject);
                    messages.add(mail);
                  //  mail.setSaveAsActivity(false);
                  //  mail.setTemplateId(emailTemplateId);
               /*   
                  try{
             Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }catch(exception e){
            apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
        }
                 */ 
                  
                   // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    
                purNotValidatedUsers.add(newuser);
         }
   }
   Messaging.sendEmail(messages);
   delete purNotValidatedUsers;
}



global void finish(Database.BatchableContext bc){

}

global void execute(SchedulableContext sc){
        AccountNotSetUpBatch  emailAccountNotSetUpBatch = new AccountNotSetUpBatch ();
        database.executeBatch(emailAccountNotSetUpBatch,200);
    }
}