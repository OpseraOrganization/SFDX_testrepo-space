trigger updatetooloncontactnew on Contact_Tool_Access__c (after insert,after update) {


public string mastertoolname;
public string mastertoolname1;
public string mastertoolname2;


string profileId = userinfo.getProfileId();
        string customLabel = Label.Data_Loading_Profile;
        if(profileId.substring(0,profileId.length()-3) != customLabel){ 


set<ID> toolid =new set<ID>();
set<ID> toolid1 =new set<ID>();
set<ID> toolid3 =new set<ID>();
list<contact> contactlist=new List<contact>();

List<contact> updatecontactlist=new List<contact>();
//Commented by Swastika-IBM on 08-Dec-2017 SOQL inside a loop<Start>
/*for(Contact_Tool_Access__c co:Trigger.new){
system.debug('tool id is '+co.id);
toolid3.add(co.id);

  list<Contact_Tool_Access__c> tooldata=  [SELECT ID,Portal_Tool_Master__r.Tool_Description__c, Portal_Tool_Master__r.Name,Portal_Tool_Master__r.Tool_Image__c, Name, Request_Status__c FROM Contact_Tool_Access__c where ID IN :toolid3];
   system.debug('Master tool name is'+tooldata[0].Portal_Tool_Master__r.Name); 
    mastertoolname=tooldata[0].Portal_Tool_Master__r.Name;
    mastertoolname1=tooldata[0].Portal_Tool_Master__r.Tool_Image__c;
    mastertoolname2=tooldata[0].Portal_Tool_Master__r.Tool_Description__c;
  
    system.debug('Master Image name is'+tooldata[0].Portal_Tool_Master__r.Tool_Image__c); 
if(Trigger.isInsert){   
if(co.CRM_Contact_ID__c!=Null && co.Request_Status__c!=null)
{
toolid.add(co.CRM_Contact_ID__c);
//toolid1.add(co.id);
}
}
if(Trigger.isUpdate){   
if(co.CRM_Contact_ID__c!=Null && Trigger.oldmap.get(co.id).Request_Status__c!= Trigger.newmap.get(co.id).Request_Status__c)
{
toolid.add(co.CRM_Contact_ID__c);
system.debug('contact id is '+co.CRM_Contact_ID__c);
//toolid1.add(co.id);
}
}
}
*/
//Commented by Swastika-IBM on 08-Dec-2017 SOQL inside a loop<End>

//Added by Swastika-IBM on 08-Dec-2017 to remove SOQL inside a loop<Start>
for(Contact_Tool_Access__c co:Trigger.new){
   
    if(Trigger.isInsert){   
        if(co.CRM_Contact_ID__c!=Null && co.Request_Status__c!=null)
        {
         toolid3.add(co.id);
        toolid.add(co.CRM_Contact_ID__c);
        }
    }
    if(Trigger.isUpdate){   
        if(co.CRM_Contact_ID__c!=Null && Trigger.oldmap.get(co.id).Request_Status__c!= Trigger.newmap.get(co.id).Request_Status__c)
        {
         toolid3.add(co.id);
        toolid.add(co.CRM_Contact_ID__c);
        }
    }
  }  
  
    list<Contact_Tool_Access__c> tooldata=  [SELECT AutoApproveFlag__c,ID,CRM_Contact_ID__r.firstname,CRM_Contact_ID__r.lastname,CRM_Contact_ID__r.Phone_1__c ,
CRM_Contact_ID__r.Birth_City__c,
CRM_Contact_ID__r.Contact_Birth_Country__c ,
CRM_Contact_ID__r.Is_US_Citizen__c ,
CRM_Contact_ID__r.Permanent_USA_Resident__c  ,
CRM_Contact_ID__r.Permanent_Resident_Expiration_Date__c  ,
CRM_Contact_ID__r.State_Code__c,
CRM_Contact_ID__r.City_Name__c,
CRM_Contact_ID__r.Postal_Code__c,
CRM_Contact_ID__r.Address_Line_2__c,
CRM_Contact_ID__r.Country_Name__c,CRM_Contact_ID__r.Address_Line_1__c,CRM_Contact_ID__r.Contact_Function__c, CRM_Contact_ID__r.AccountId, CRM_Contact_ID__r.Account.Name,CRM_Contact_ID__r.Honeywell_ID__c, CRM_Contact_ID__r.Phone_5__c,CRM_Contact_ID__r.Citizenship_Country__c, CRM_Contact_ID__r.Primary_Email_Address__c, Portal_Tool_Master__r.Tool_Description__c, Portal_Tool_Master__r.Name,Portal_Tool_Master__r.Tool_Image__c, Name, Request_Status__c FROM Contact_Tool_Access__c where ID IN :toolid3];
    if(tooldata != null && tooldata.size() > 0 ) {
    mastertoolname=tooldata[0].Portal_Tool_Master__r.Name;
    mastertoolname1=tooldata[0].Portal_Tool_Master__r.Tool_Image__c;
    mastertoolname2=tooldata[0].Portal_Tool_Master__r.Tool_Description__c;
  
    
 /* Code to sent mail when Request Status 'Approved' and Master tool name = Technical Publications  ,'pubs@honeywell.com'*/ 
 if(mastertoolname != '' && mastertoolname =='Technical Publications' && tooldata[0].Request_Status__c=='Approved' && tooldata[0].AutoApproveFlag__c == True){
    system.debug('Inside'+tooldata[0].AutoApproveFlag__c);

    Contact_Tool_Access__c tooldatanew = tooldata[0];
    system.debug('Inside1'+tooldatanew .CRM_Contact_ID__r.Phone_5__c);
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
    List<String> requester=new List<String>();
    mail.setToAddresses(new List<String>{Label.Pubs_Email_Id});   
  
                      

//Send Email Body
String subjectStr=    'New User Registered for Technical Publications';
/*    
String mailCnt = 'Hi Tech Pubs Admin,<BR><BR> This is to inform that a new user has been approved for TechPubs access.<Br> \tUser details are as follows,<br>'
               +' <BR>\t<B>Honeywell ID:</B> ' + tooldatanew .CRM_Contact_ID__r.Honeywell_ID__c
                + '<br>\t<B>Name : </B>' + tooldatanew .CRM_Contact_ID__r.firstname + ' ' + tooldatanew .CRM_Contact_ID__r.lastname
                + '<br>\t<B>Email : </B>' + tooldatanew .CRM_Contact_ID__r.Primary_Email_Address__c 
                + '<br>\t<B>Mob No : </B>' + tooldatanew .CRM_Contact_ID__r.Phone_5__c 
                + '<BR>\t<B>Company : </B>' + tooldatanew .CRM_Contact_ID__r.Account.Name 
                +'<br>\t <B>Address : </B>' + tooldatanew .CRM_Contact_ID__r.Address_Line_1__c  
                +'<BR>\t<B>Job Title : </B>' + tooldatanew .CRM_Contact_ID__r.job_Title__c  
                +'<BR>\t<B>Citizenship Country : </B>' + tooldatanew.CRM_Contact_ID__r.Citizenship_Country__c;

 
                String sMailFooter=  '<BR><br>\tThank you, '
                
                +'<BR>\tMyAerospace Portal Team' 

                +'<BR><br>\tTerms Conditions |Privacy Statement '

                +'<BR>\tCopyright Honeywell International Inc 2004-2008';
                
                String body =mailCnt +sMailFooter;
  */
  string phone1;
  if(tooldatanew .CRM_Contact_ID__r.Phone_5__c !=null)
                {
                phone1=tooldatanew .CRM_Contact_ID__r.Phone_5__c;
                }
                else
                {
                phone1='';
                }
     string hon1;
  if(tooldatanew .CRM_Contact_ID__r.Honeywell_ID__c!=null)
                {
                hon1=tooldatanew .CRM_Contact_ID__r.Honeywell_ID__c;
                }
                else
                {
                hon1='';
                } 
                
                string fname;
  if(tooldatanew .CRM_Contact_ID__r.firstname !=null)
                {
                fname=tooldatanew .CRM_Contact_ID__r.firstname ;
                }
                else
                {
                fname='';
                }      
                string lname;
  if(tooldatanew .CRM_Contact_ID__r.lastname!=null)
                {
                lname=tooldatanew .CRM_Contact_ID__r.lastname;
                }
                else
                {
                lname='';
                } 
                string pemailaddress;
  if(tooldatanew .CRM_Contact_ID__r.Primary_Email_Address__c !=null)
                {
                pemailaddress=tooldatanew .CRM_Contact_ID__r.Primary_Email_Address__c ;
                }
                else
                {
                pemailaddress='';
                }        
                string phone2;
  if(tooldatanew .CRM_Contact_ID__r.Phone_1__c !=null)
                {
                phone2=tooldatanew .CRM_Contact_ID__r.Phone_1__c ;
                }
                else
                {
                phone2='';
                }        
                string company;
  if(tooldatanew .CRM_Contact_ID__r.Account.Name!=null)
                {
                company=tooldatanew .CRM_Contact_ID__r.Account.Name;
                }
                else
                {
                company='';
                }        
                string add1;
  if(tooldatanew .CRM_Contact_ID__r.Address_Line_1__c  !=null)
                {
                add1=tooldatanew .CRM_Contact_ID__r.Address_Line_1__c  ;
                }
                else
                {
                add1='';
                }       
                string add2;
  if(tooldatanew .CRM_Contact_ID__r.Address_Line_2__c!=null)
                {
                add2=tooldatanew .CRM_Contact_ID__r.Address_Line_2__c;
                }
                else
                {
                add2='';
                }   
                string city;
  if(tooldatanew .CRM_Contact_ID__r.City_Name__c  !=null)
                {
                city=tooldatanew .CRM_Contact_ID__r.City_Name__c  ;
                }
                else
                {
                city='';
                }        
                string state;
  if(tooldatanew .CRM_Contact_ID__r.State_Code__c  !=null)
                {
                state=tooldatanew .CRM_Contact_ID__r.State_Code__c  ;
                }
                else
                {
                state='';
                }  
                string zip;
  if(tooldatanew .CRM_Contact_ID__r.Postal_Code__c  !=null)
                {
                zip=tooldatanew .CRM_Contact_ID__r.Postal_Code__c  ;
                }
                else
                {
                zip='';
                }   
                 string country;
  if(tooldatanew .CRM_Contact_ID__r.Country_Name__c  !=null)
                {
                country=tooldatanew .CRM_Contact_ID__r.Country_Name__c  ;
                }
                else
                {
                country='';
                }      
                string confun;
  if(tooldatanew .CRM_Contact_ID__r.Contact_Function__c!=null)
                {
                confun=tooldatanew .CRM_Contact_ID__r.Contact_Function__c;
                }
                else
                {
                confun='';
                }        
                string bircoun;
  if(tooldatanew .CRM_Contact_ID__r.Contact_Birth_Country__c  !=null)
                {
                bircoun=tooldatanew .CRM_Contact_ID__r.Contact_Birth_Country__c  ;
                }
                else
                {
                bircoun='';
                }   
                string bircity;
  if(tooldatanew .CRM_Contact_ID__r.Birth_City__c  !=null)
                {
                bircity=tooldatanew .CRM_Contact_ID__r.Birth_City__c  ;
                }
                else
                {
                bircity='';
                }      
                boolean citizen;
  if(tooldatanew .CRM_Contact_ID__r.Is_US_Citizen__c==true)
                {
                citizen=true  ;
                }
                else
                {
                citizen=false;
                }        
                 string citizencountry;
  if(tooldatanew .CRM_Contact_ID__r.Citizenship_Country__c!=null)
                {
                citizencountry=tooldatanew .CRM_Contact_ID__r.Citizenship_Country__c;
                }
                else
                {
                citizencountry='';
                }    
                boolean resident;
                system.debug('Permanent_USA_Resident__c'+tooldatanew .CRM_Contact_ID__r.Permanent_USA_Resident__c);
  if(tooldatanew .CRM_Contact_ID__r.Permanent_USA_Resident__c  ==true)
                {
                resident=true ;
                }
                else
                {
                resident=false;
                }        
                date date1;
  if(tooldatanew .CRM_Contact_ID__r.Permanent_Resident_Expiration_Date__c  !=null)
                {
                date1=tooldatanew .CRM_Contact_ID__r.Permanent_Resident_Expiration_Date__c ;
                }
                else
                {
                date1=null;
                }        
                
  
          String mailCnt = 'Hi Tech Pubs Adminw,<BR><br>'
                +'Note: This is an system generated email. <BR><br>'
               + ' <BR> This is to inform you that a new user has been auto-approved for Technical Publications application access<Br> \tUser details are as follows,<br>'
               +' <BR>\t<B>Honeywell ID:</B> ' + hon1
                + '<br>\t<B>Name : </B>' + fname + ' ' + lname
                
                + '<br>\t<B>Email : </B>' + pemailaddress
                + '<br>\t<B>Phone No : </B>' + phone2
                
                + '<br>\t<B>Mob No : </B>' + phone1
                
                + '<BR>\t<B>Company : </B>' + company 
                +'<br>\t <B>Address1 : </B>' + add1
                +'<br>\t <B>Address2 : </B>' + add2
                +'<br>\t <B>City : </B>' + city  
                +'<br>\t <B>State : </B>' + state
                +'<br>\t <B>Zip : </B>' + zip 
                +'<br>\t <B>Country : </B>' + country  
                    
                
                +'<BR>\t<B>Job Title : </B>' + confun
                
                +'<br>\t <B>Birth Country : </B>' + bircoun
                +'<br>\t <B>Birth City : </B>' + bircity
                +'<br>\t <B>Is US Citizen : </B>' + citizen
                +'<BR>\t<B>Citizenship Country : </B>' + citizencountry
                +'<br>\t <B>Is Permanent USA Resident : </B>' + resident
                +'<br>\t <B>Permanent Resident Expiration Date : </B>' + date1  
                +'<br><br>\t <B>Please review the user information and complete your validation process.</B>';

                String sMailFooter=  '<BR><br>\tThank you, '
                
                +'<BR>\tMyAerospace Team' ;

                             
                String body =mailCnt +sMailFooter;              
               
                //sMailHeader+sHeading+sMailHeaderExtra+mailCnt+sEnd+sMailFooter;
                //OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'myaerospace@honeywell.com'];
                //Updated on 09/13/19 on request of Phani Raj
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'aerodonotreply@honeywell.com'];
             
                if ( owea.size() > 0 ) {
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }    
                mail.setSubject(subjectStr);
                mail.setHtmlBody(body); 
                system.debug('*****body*****'+body);
                //mail.setOrgWideEmailAddressId('0D2a00000008QDT');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
     
 }   
}

//Added by Swastika-IBM on 08-Dec-2017 to remove SOQL inside a loop<End>

if(toolid.size()>0)
{


contactlist = [SELECT id,(SELECT ID,Name,Request_Status__c  FROM Contact_Tool_Access__r  ) FROM contact WHERE ID IN :toolid];
system.debug('Main tool name is'+contactlist);
system.debug('Master tool name is'+mastertoolname);
system.debug('List is'+contactlist );
    for (contact opp : contactlist){
    system.debug('contact id is '+opp.id);
        for (Contact_Tool_Access__c fob:Trigger.new){
        system.debug('tool id is '+fob.id);
            opp.ToolId__c = fob.ID;
             system.debug('mastertoolname---'+mastertoolname);
            opp.TOOLNAME1__c= mastertoolname;
             system.debug('fob status is--- '+fob.Request_Status__c);
         opp.ToolStatus__c = fob.Request_Status__c;
          system.debug('mastertoolname2is ----'+mastertoolname2);
          opp.Tool_Description__c=mastertoolname2;
           system.debug('mastertoolname1---- '+mastertoolname1);
            opp.Tool_Image__c =mastertoolname1;
            
            
        }
        updatecontactlist.add(opp);
    }
update updatecontactlist;
}
}
}