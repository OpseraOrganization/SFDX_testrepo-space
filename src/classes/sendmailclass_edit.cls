public class sendmailclass_edit
{  
    List<Attachment> finalattach=new List<Attachment>(); 
    List<Attachment> finalattach1=new List<Attachment>(); 
    id pageid;
    public Boolean isHTML{ get; set; }
    public Boolean isText{ get; set; }
    public Boolean selectTemp { get; set; }
    public Boolean selectattach { get; set; }
    public Boolean isTemplate{ get; set; }
    String CClist=System.currentPageReference().getParameters().get('CClist');
    String Tolist=System.currentPageReference().getParameters().get('Tolist');
    String AddCClist=System.currentPageReference().getParameters().get('AddCClist');
    String BCClist=System.currentPageReference().getParameters().get('BCClist');
    String HtmlemailBody=System.currentPageReference().getParameters().get('HtmlemailBody');
    String templateId =System.currentPageReference().getParameters().get('templateId');
    String   subject=System.currentPageReference().getParameters().get('subject');
    EmailMessage emssg = new EmailMessage();
    String isHTMLval=System.currentPageReference().getParameters().get('isHTMLval');
    String flg,frwd;
    List<EmailTemplate> emailTemplates=new List<EmailTemplate>();
    String EmailTemplate=null;
    List<SelectOption> optionsTemp = new List<SelectOption>();
    EmailTemplate e;
    List<Folder> emailTempList=new List<Folder>();
    List<Attachment> attachments=new List<Attachment>();
    List<Attachment> att = new List<Attachment>();
    List<id> emailid = new List<ID>();
    List<id> emailid1 = new List<ID>();
    
public PageReference doref(){
 System.debug('*********'+HtmlemailBody);
 if(templateId==null){
 textemailBody=HtmlemailBody.replace('amp;','');
 textemailBody=textemailBody.replace('&nbsp;',' ');
  textemailBody = textemailBody.replace('&&ndash;','–');
  
  
  
  
  
  
  
  
  
  
  
while(    textemailBody.contains('<') && textemailBody.contains('>'))
 {
 integer i1=textemailBody.indexof('<');
 system.debug('**********'+textemailBody);
  system.debug('**********'+i1);

 integer i2=textemailBody.indexof('>');
    system.debug('**********'+i2); 
 String substr=textemailBody.substring(i1,i2+1);
  textemailBody=textemailBody.replace(substr,'');
 }
 }
  isHTML=false;
 isText=true;
 //String ht='false';                                                         
 //PageReference p= new  PageReference('/apex/SendmailPage?caseid='+caseid+'&AddCClist='+AddCClist+'&BCClist='+BCClist+'&Tolist='+Tolist+'&CCList='+CCList+'&isHTMLval='+ht+'&HtmlemailBody='+HtmlemailBody+'&subject='+subject);
 return null;
 // return(p);
 }
 
  public PageReference doref1(){
 System.debug('*********'+HtmlemailBody);
  isHTML=true;
 isText=false;
 //String ht='true';                                                         
 //PageReference p= new  PageReference('/apex/SendmailPage?caseid='+caseid+'&AddCClist='+AddCClist+'&BCClist='+BCClist+'&Tolist='+Tolist+'&CCList='+CCList+'&isHTMLval='+ht+'&HtmlemailBody='+HtmlemailBody+'&subject='+subject);
 // return(p);
 return null;
 }
   
    
    public sendmailclass_edit(ApexPages.StandardController controller) 
    {
     if(templateId==null)
     isTemplate=true;
         isHTML=true; 
         isText=false;
         if(isHTMLval=='true'){
         isHTML=true;
         isText=false;
         }
         if(isHTMLval=='false'){
         isHTML=false;
         isText=true;
         }
         
  if(templateId !=null){
 
  e=[Select  id, body, markup, htmlvalue, templatestyle, 
      templatetype,subject from EmailTemplate where Id=:templateId];
    if(isHTML==true && e.htmlvalue!=null)
HtmlemailBody=e.htmlvalue+activeUser.signature1__c;
else
  HtmlemailBody=e.body+activeUser.signature1__c;
  //HtmlemailBody=e.htmlvalue+activeUser.signature1__C+HtmlemailBody;
  if(HtmlemailBody!=null)
  {
     HtmlemailBody = HtmlemailBody.replace('<![CDATA[','');
     HtmlemailBody = HtmlemailBody.replace(']]','');
    //  HtmlemailBody = HtmlemailBody.replace('nbsp;','');
      // HtmlemailBody = HtmlemailBody.replace('&&ndash;','–');
           //   HtmlemailBody = HtmlemailBody.replace('&amp;','');
     }
     
     System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'+HtmlemailBody );
     
   textemailBody=e.body;
   
   
   if(textemailBody != null){
   
    while( textemailBody.contains('{!Case.') && textemailBody.contains('}'))
   {
    integer i11t=textemailBody.indexof('{!Case.'); 
    integer i22t=textemailBody.indexof('}');
    String substr1t=textemailBody.substring(i11t,i22t+1);
    String substrt=substr1t;
    substrt=substrt.replace('{!Case.','');
    substrt=substrt.replace('}','');
        if(substrt!=null){
        String string_limitt=   ' select ' + substrt + ' from Case where id = \'' + caseid+ '\'';
        Case caseDatat = Database.query(string_limitt);
        string valueof_fieldt  =String.valueOf ( caseDatat.get(substrt ));  
        if(valueof_fieldt!=null)
        textemailBody=textemailBody.replace(substr1t,valueof_fieldt);
        else
        textemailBody=textemailBody.replace(substr1t,' ');
        }
    }
    }
    
    
    
 if(HtmlemailBody != null)
 { 
  while( HtmlemailBody.contains('{!Case.') && HtmlemailBody.contains('}'))
   {
   
     System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$entered loop');
    integer i11=HtmlemailBody.indexof('{!Case.'); 
    integer i22=HtmlemailBody.indexof('}');
   
    String substr1=HtmlemailBody.substring(i11,i22+1);
    String substr=substr1;     
    substr=substr.replace('{!Case.','');
    substr=substr.replace('}','');

if(substr !=null){
 String string_limit=   ' select ' + substr + ' from Case where id = \'' + caseid+ '\'';

    System.debug('&&&&&&&&&&&&&&&string_limit'+string_limit);
    Case caseData = Database.query(string_limit);
    System.debug('&&&&&&&&&&&&&&&caseData'+caseData);
    string valueof_field  =String.valueOf ( caseData.get(substr ));
  
    if(valueof_field!=null)
    HtmlemailBody=HtmlemailBody.replace(substr1,valueof_field);
    else
    HtmlemailBody=HtmlemailBody.replace(substr1,' ');
    }
    }
    }
      
    
    
    System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$after   '+HtmlemailBody);
   // HtmlemailBody=activeUser.signature1__C+HtmlemailBody;
    
    
    
   
  // to replace merge fields in templates 
     integer flag=0;
     subject=e.subject;
     
     if(subject.contains('{!Case.Subject}'))
     flag=1;
     
     
     
     
     
    while(    subject.contains('{!') && subject.contains('}')       && subject.contains('Case'))
         {
         integer i1=subject.indexof('{!');   
         integer i2=subject.indexof('}');
         String substr=subject.substring(i1,i2+1);
         subject=subject.replace(substr,'');
         }
         
  if(flag==1)
  subject=subject+' '+caseRec.Subject+' '+caserec.CaseNumber+' '+caserec.Case_Ref_ID__c;
  else
  subject=subject+' '+caserec.CaseNumber+' '+caserec.Case_Ref_ID__c;
 
   
   
 }
     
      selectTemp=false;    
     emailTempList=[Select Id,Name from folder where type='email' and 
   ((  name  like 'CSO%') or (  name  like 'GTO%') )
     ];
                    optionsTemp = new List<SelectOption>();
                     optionsTemp.add(new SelectOption('My Personnel Folder','My Personnel Folder'));
                    for(integer i=0;i<emailTempList.size();i++){
                    //adding into select option
                    if(emailTempList[i].Name !=null)
                    optionsTemp.add(new SelectOption(emailTempList[i].Id,emailTempList[i].Name));
                    }//end of for                     
  emailTemplates=[Select Id,Name,description,templatetype,folderid,body,htmlvalue 
  from EmailTemplate where folderid= :Userinfo.getuserid()];             
         
         
    }
    {
pageid =  System.currentPageReference().getParameters().get('Id');
flg =  System.currentPageReference().getParameters().get('toall');
frwd =  System.currentPageReference().getParameters().get('forward');
if(Pageid!=null)
emssg = [Select FromName,ToAddress,FromAddress,subject,ParentId,BccAddress,CcAddress,HtmlBody,INCOMING,TextBody  
from EmailMessage  where id=:Pageid];
} 
    
id caseid=System.currentPageReference().getParameters().get('caseid');
String userName = UserInfo.getUserName();
User activeUser = [Select Email,name,signature1__C From User where Username = : userName limit 1];
case caseRec=[select casenumber,subject,Case_Ref_ID__c from case where id=:caseid];
//String HtmlemailBody,textemailbody;
String textemailBody;
public case getcaseRecord()
{
return caseRec;
}
public void attachtemplate(){
selectTemp=true;
}

public string getsubject()
{
  System.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!subject'+subject);
  System.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!caserec.subject'+caserec.subject);
  subject = emssg.subject;
  if(subject==null)
  {
  subject=caserec.subject;
  if(caserec.subject == null)
  {
   System.debug('11111111111111');
  subject=caserec.Case_Ref_ID__c;
  }
  else
   {
    System.debug('222222222222222');
   subject=caserec.subject+caserec.Case_Ref_ID__c;
   }
   }
   else
   {
   
 
    System.debug('333333333333333'+subject);
    if(!(subject.contains(caserec.Case_Ref_ID__c))){
      System.debug('333333333333333In loop');

   if(frwd=='False')
  {
   subject='RE:'+subject +' '+caserec.CaseNumber+' '+ caserec.Case_Ref_ID__c;
   }
   else{
 
   subject='FW:'+subject +' '+caserec.CaseNumber+' '+ caserec.Case_Ref_ID__c;
   }
   
  
   
   }
   
   }
   
       if(templateId ==null){
            if(frwd=='False'){
                if(!(subject.contains('RE:')))
                subject='RE:'+subject;
               if((subject.contains('FW:')))
                subject=subject.replace('FW:','');
            }
            else{
                if(!(subject.contains('FW:')))
                subject='FW:'+subject;
                if((subject.contains('RE:')))
                subject=subject.replace('RE:','');
            }
        }

/*
    if(templateId !=null){
  e=[Select  id, body, markup, htmlvalue, templatestyle, 
      templatetype,subject from EmailTemplate where Id=:templateId];
   subject=e.subject+ caserec.Case_Ref_ID__c;
   }
   */
   
   
 
   
   
  return subject;
}
public void setsubject(string subject)
{
  
  this.subject=subject;
  
} 


  //get set method for selected deviation
    public Id getPageId() {
        return PageId;
    }    
public void setPageid(string PageId)
{
  
  this.PageId=PageId;
  
} 



public void cancelTemplate(){
selectTemp=false;
}

    //get set method for selected deviation
    public String getEmailTemplate() {
        return EmailTemplate;
    }    
    public void setEmailTemplate(String EmailTemplate) {
        this.EmailTemplate = EmailTemplate;
    }

    //get set method for selected deviation
    public String gettemplateId() {
        return templateId;
    }    
    public void settemplateId(String templateId) {
        this.templateId = templateId;
    }
   //Select option for template             
     public List<SelectOption> getTempList() {
     return optionsTemp;
    }
//get templates            
     public List<EmailTemplate> getemailTemplates() {
     return emailTemplates;
    }

public void ViewDetails(){
 if(EmailTemplate == 'My Personnel Folder')
  emailTemplates=[Select Id,Name,description,templatetype,folderid from EmailTemplate where folderid=:Userinfo.getuserid()]; 
 else
 emailTemplates=[Select Id,Name,description,templatetype,folderid from EmailTemplate where folderid=:EmailTemplate]; 

}


public PageReference ViewTemplateDetails(){
isTemplate=false;
      EmailTemplate e=[Select  id, body, markup, htmlvalue, templatestyle, 
      templatetype,subject from EmailTemplate where Id=:templateId];
      //templatetype,subject from EmailTemplate where Id='00X30000001AEu6'];
      HtmlemailBody=e.htmlvalue;
      selectTemp=false; 
      subject=e.subject;
      HtmlemailBody = HtmlemailBody.replace('&nbsp;','');
         HtmlemailBody = HtmlemailBody.replace('&amp;','');
          HtmlemailBody = HtmlemailBody.replace('&&ndash;','–');
      PageReference p= new  PageReference('/apex/SendmailPage_Edit?caseid='+caseid+'&HtmlemailBody='+HtmlemailBody+'&subject='+subject);
  return(p);
}


String userEmail = activeUser.Email;
  //*************CODE EXECUTED WHEN SEND MAIL BUTTON IS CLICKED****************
 public pagereference send()
 {
 /*
  if(subject==null){
 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Subject is empty. Please enter Subject')); 
  return null; 
  }
  else{
  
    if(!(subject.contains(caserec.CaseNumber)))
 subject=   subject +' '+caserec.CaseNumber;
  
      if(!(subject.contains(caserec.Case_Ref_ID__c)))
 subject=   subject +' '+caserec.Case_Ref_ID__c;
  
  }
 
 */
  integer j=0;
 integer j1 = 0;
 if(textemailBody!= null)
 {
 j = textemailBody.length();
 textemailbody = textemailbody.replace('&nbsp;',' ');
 textemailbody = textemailbody.replace('&amp;','');
  textemailBody = textemailBody.replace('&&ndash;','–');
 }
 if(HtmlemailBody!= null)
 {
  j1 = HtmlemailBody.length();
  //HtmlemailBody = HtmlemailBody.replace('nbsp;','');
   //HtmlemailBody = HtmlemailBody.replace('&amp;','');
    //HtmlemailBody = HtmlemailBody.replace('&&ndash;','–');
  }
  if(Tolist!='' && j<32000 && j1<32000)
  {
      if(isHTML==true  && templateId==null){
     textemailBody=HtmlemailBody.replace('&amp;','');
     textemailBody=textemailBody.replace('nbsp;',' ');
     textemailBody = textemailBody.replace('&&ndash;','–');
      while(    textemailBody.contains('<') && textemailBody.contains('>'))
     {
     integer i1=textemailBody.indexof('<');
     system.debug('**********'+textemailBody);
      system.debug('**********'+i1);
    
     integer i2=textemailBody.indexof('>');
        system.debug('**********'+i2); 
     String substr=textemailBody.substring(i1,i2+1);
      textemailBody=textemailBody.replace(substr,'');
     }
     }
 
 
 
 
 
 
     String[] strto =new String[]{};
     if(Tolist!='')
     strto =Tolist.split(';');
     
   String[] straddcc = new String[]{};
   if(AddCClist!='')
   straddcc = AddCClist.split(';');
   
   String[] strbcc = new String[]{};
   if(BCClist!='')
   strbcc = BCClist.split(';');

  //**********CONSTRUCTIONG MESSAGE OBJECT**********************
 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
 if(strto.size()>0)
 mail.setToAddresses(strto);
 if(straddcc.size()>0)
 mail.setCcAddresses(straddcc);
 if(strbcc.size()>0)
 mail.setBCcAddresses(strbcc);
 
 mail.setsubject(subject);
 mail.setUseSignature(true);
 mail.setPlainTextBody(textemailbody);
 mail.sethtmlbody(HtmlemailBody);
  mail.setReplyTo(Frmlst);
  
   //mail.setSenderDisplayName(Frmlst);
   String mailBox;
try{
mailBox=[Select MailBox_Id__c from  Email_address__c where   MailBox_Name__c=:Frmlst].MailBox_Id__c;
}
catch(exception e){}
if(mailBox!=null)
 mail.setOrgWideEmailAddressId(mailBox);
  
 Messaging.EmailFileAttachment[] fileAttachments = new Messaging.EmailFileAttachment[finalattach.size()];
   System.debug('sumiiiiiiiiiiiiiiiiifinalattach.size()  '+finalattach.size());
//finalattach=[Select Id,name,ParentId,body from Attachment where Id in :emailId1];
            finalattach=[Select Id,name,ParentId,body from Attachment where Id in :emailId1];
System.debug('sumiiiiiiiiiiiiiiiiifinalattach.size()  '+finalattach.size());
  for(integer i=0;i<finalattach.size();i++)
  {
     Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
     efa.setFileName(finalattach[i].name);
/*
System.debug('###########################before decryption'+finalattach[i].body );
string newkey='11111111111111111111111111111111';
      Blob cryptoKey=blob.valueof(newkey);
      Blob decryptedData = Crypto.decryptWithManagedIV('AES256', cryptoKey, finalattach[i].body);       
     
System.debug('###########################after decryption'+decryptedData  );
     efa.setBody(decryptedData);*/
     efa.setBody(finalattach[i].body);
     fileAttachments[i]=efa;
   }  
 System.debug('sumiiiiiiiiiiiiiiiiifileAttachments '+fileAttachments);  
  mail.setFileAttachments(fileattachments);

 Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

// ********************INSERTING EMAIL MESSAGE ONCE THE MAIL IS SENT*************

EmailMessage emsg = new EmailMessage();
emsg.ToAddress = Tolist;
emsg.FromAddress = Frmlst;
emsg.parentid = caseid;
emsg.ccaddress = CClist;
emsg.subject = subject ; 
emsg.bccaddress = bcclist;
emsg.htmlbody = HtmlemailBody;
emsg.textbody =textemailbody;
emsg.fromName = activeuser.Name;
insert emsg;
 
// ********************INSERTING ATTACHMENT OBJECT ONCE THE MAIL IS SENT*************
List<Attachment_Object__c> aobjlist = new List<Attachment_Object__c>();
for(integer i=0;i<finalattach.size();i++)
{
Attachment_Object__c aobj = new Attachment_Object__c();
aobj.case_id__c = caseid;
aobj.Email_Message_ID__c = emsg.id;
aobj.Attachment_Id__c = finalattach[i].Id;
aobjlist.add(aobj);
}
insert aobjlist;


//************************CREATING TASK FOR THE MAIL SENT***********************
Task t =new Task();
t.subject = emsg.subject ;
t.priority = 'Normal';
t.whatid= caseid;
t.status = 'Completed';
t.description = textemailbody;
t.whoid = emsg.createdbyid;
t.activitydate = System.today();
if(frwd=='True')
insert t;
else
 {
String str = 'Email: '+ emssg.subject;
system.debug('#########################'+str);
try{
Task t1 = [select id,status from Task where subject = :str];
t1.status = 'Completed';
update t1;
}
catch(Exception e){}
 }
//***********************CODE FOR ENCRYPTION*************************************  


/*
for(integer i=0;i<finalattach1.size();i++){
 string newkey='11111111111111111111111111111111';
            Blob cryptoKey=blob.valueof(newkey);
            string    cryptoKeytext;
           cryptoKeytext=string.valueof(cryptoKey); 
           Blob encryptedData = Crypto.encryptWithManagedIV('AES256', cryptoKey, finalattach1[i].Body);
          finalattach1[i].Body =encryptedData;
}           
           update finalattach1;
           
    */       

Pagereference pg=new Pagereference('/'+caseid);
      return pg;
      }
      
      
      
      
      else{
      if(Tolist=='' )
      {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'To value is empty. Please Enter To')); 
      return null;
      }
       else if(j<32000 || j1<32000 )
     {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Size of the message is more than 32000. Please enter message within the Limit')); 
      return null;
     }
       else
      return null;
      }
      
      
      
      
      
      
      
 }
  //******************END OF SEND MAIL FUNCTION***********************
 public void template()
 {
 }
 
 
  public pagereference cancel()
 {
 Pagereference pg=new Pagereference('/'+caseid);
      return pg;
 }
  //******************CODE CALLED WHEN USER CLICKS TO UPLOAD DOCS FROM SYSTEM
 
   List<attachment> myatt = new List<attachment>();
    
    public boolean showdoc {get;set;}
    
    public boolean showlist{get;set;} 
    
     public void attachfile()
         {
          showdoc = true;
         }
         public void nodisp()
         {
         showdoc = false;
         }
 
  public string fileName   
     {    get;set;    }  
       
     public Blob fileBody   
     {    get;set;    }  
     
     public void UploadFile()  
     {  
        
          if(fileBody != null && fileName != null)  
         { 
 //******************INSERTING ATTACHMENT *******************************         
           Attachment myAttachment  = new Attachment();  
           System.debug('###########################filebody'+filebody);
           myAttachment.Body =filebody;                   
           myAttachment.Name = fileName;  
           myAttachment.ParentId = caseId;  
           insert myAttachment;     
           myattachment.body=null;
           
           /*
          Attachment attnew= new Attachment();
          attnew=[Select Id,body from Attachment where Id =:myattachment.Id];
            string newkey='11111111111111111111111111111111';
            Blob cryptoKey=blob.valueof(newkey);
            string    cryptoKeytext;
            cryptoKeytext=string.valueof(cryptoKey); 
            Blob encryptedData;

try{
encryptedData = Crypto.encryptWithManagedIV('AES256', cryptoKey, fileBody);
}
catch(Exception e){ 
System.debug('&&&&&&&&&&&&&&&&&error'+e);
}

            System.debug('###########################encryptedData' +encryptedData );

            attnew.body=encryptedData;
              update attnew;
              attnew= new Attachment();
*/

                                              
           emailid.add(myattachment.Id);
           emailid1.add(myattachment.Id);
           system.debug('+++++++++++++++++++++'+myattachment.Id);
          // finalattach.add(myAttachment);
          // finalattach1.add(myAttachment);
           hasattachments =True;
   
              List<attachment> finalattach2= new List<attachment>();
             List<ID> lid = new List<ID>();
             for(integer i =0;i<finalattach.size();i++)
             {
             lid.add(finalattach[i].Id);
             }
            finalattach2=[Select Id,name,ParentId from Attachment where Id in :emailId1];
            finalattach1=[Select Id,name,ParentId from Attachment where Id in :emailId];
            for(integer i=0;i<finalattach2.size();i++){
           
           for(integer j=0;j<lid.size();j++)
           {
           if(lid[j]==finalattach2[i].Id)
           {
           finalattach2.remove(i);
           }
           }
           }
             for(integer i=0;i<finalattach2.size();i++){
              finalattach.add(finalattach2[i]);

                }

           // myattachment.body=null;
            filebody=null;
            
         }  
         
     }   
     
     
     
        

{
if(emssg.INCOMING==True)
{
 if(frwd=='False')
 Tolist=emssg.FromAddress;
 system.debug('^^^^^^^^^^^'+Tolist);
}
else
{
system.debug('Heloooooooooooo'+emssg.ToAddress);
if(frwd=='False')
Tolist=emssg.ToAddress;
}
}
public string getTolist()
{
 for(integer i=0;i<selectedcontacts.size();i++)
  {
  if(Tolist!=''  && Tolist!=null)
  {
  Tolist = Tolist+';';
  //Tolist = Tolist+',';
  }
  if(Tolist!=null)
  Tolist = Tolist+ selectedcontacts[i];
  else
  Tolist = selectedcontacts[i];
  
  
  }
  selectedcontacts.clear();
  return Tolist;
  
}
public void setTolist(string Tolist)
{
  
  this.Tolist=Tolist;
} 

public string getHtmlemailBody()
{ 







String CC=emssg.CcAddress;
String FrmName=emssg.Fromname;
String FrmAddr=emssg.FromAddress;
String ToAddr=emssg.ToAddress;
String bod=emssg.HtmlBody;
if(CC==null)
CC='';
if( FrmName==null)
FrmName='';
if(FrmAddr==null)
FrmAddr='';
if( ToAddr==null)
ToAddr='';
if( bod==null)
bod='';
System.debug('&&&&&&&&&&&&&&&&&&step1'+bod);
if(templateId==null){
HtmlemailBody =activeuser.signature1__c;
HtmlemailBody =HtmlemailBody+ '<br/>--------------- Original Message ---------------  <br/>From :  ';
HtmlemailBody =HtmlemailBody +FrmName;
HtmlemailBody =HtmlemailBody +'['+ FrmAddr + ']'+'<br/> To :  ' ;
HtmlemailBody =HtmlemailBody +ToAddr +' <br/> Cc :  ' + CC + '<br/> Subject :  ' + emssg.subject ;
HtmlemailBody =HtmlemailBody + '<br/> <br/>';



HtmlemailBody =HtmlemailBody +emssg.HtmlBody;

//HtmlemailBody =HtmlemailBody +bod;
 //HtmlemailBody = activeuser.signature1__c+'<br/>'+ HtmlemailBody;
 
 
// HtmlemailBody =HtmlemailBody+bod;
 }
  ////HtmlemailBody = 'Thanks & Regards <br/> '+ emssg.Fromname + '<br/>--------------- Original Message ---------------  <br/>From :  '+emssg.Fromname+ '['+ emssg.FromAddress + ']'+'<br/> To :  ' + emssg.ToAddress +' <br/> Cc :  ' + emssg.CcAddress + '<br/> Subject :  ' + emssg.subject + ' <br/> <br/>'+ emssg.HtmlBody;
 //HtmlemailBody = activeuser.signature1__c+'<br/>'+ HtmlemailBody;
  

 /* if(templateId !='' && templateId !=null){
  e=[Select  id, body, markup, htmlvalue, templatestyle, 
      templatetype,subject from EmailTemplate where Id=:templateId];
  HtmlemailBody=e.htmlvalue+activeUser.signature1__C+'<br/>--------------- Original Message ---------------  <br/>From :  '+FrmName+ '['+ FrmAddr+ ']'+'<br/> To :  ' + ToAddr +' <br/> Cc :  ' + CC + '<br/> Subject :  ' + emssg.subject + ' <br/> <br/>'+ bod;
 
 }*/
 
 if(templateId!=null){
 
 System.debug('**************************entering');
   //HtmlemailBody=HtmlemailBody+'<br/>--------------- Original Message ---------------  <br/>From :  '+FrmName+ '['+ FrmAddr+ ']'+'<br/> To :  ' + ToAddr +' <br/> Cc :  ' + CC + '<br/> Subject :  ' + emssg.subject + ' <br/> <br/>';
 
 
 HtmlemailBody =HtmlemailBody+activeuser.signature1__c;
HtmlemailBody =HtmlemailBody+ '<br/>--------------- Original Message ---------------  <br/>From :  ';
HtmlemailBody =HtmlemailBody +FrmName;
HtmlemailBody =HtmlemailBody +'['+ FrmAddr + ']'+'<br/> To :  ' ;
HtmlemailBody =HtmlemailBody +ToAddr +' <br/> Cc :  ' + CC + '<br/> Subject :  ' + emssg.subject ;
HtmlemailBody =HtmlemailBody + '<br/> <br/>';
 
 

    HtmlemailBody=HtmlemailBody+emssg.HtmlBody;
    
      //HtmlemailBody = HtmlemailBody.replace('<![CDATA[','');
    // HtmlemailBody = HtmlemailBody.replace(']]','');
    }
    
    
     HtmlemailBody=HtmlemailBody.replace('null','   ');

    
    
    
    
  return HtmlemailBody;
}
public void setHtmlemailBody(string HtmlemailBody)
{
  
  this.HtmlemailBody=HtmlemailBody;
}
public string gettextemailBody()
{
  textemailBody = 'Thanks & Regards <br/> '+ emssg.Fromname + '<br/>--------------- Original Message ---------------  <br/>From :  '+emssg.Fromname+ '['+ emssg.FromAddress + ']'+'<br/> To :  ' + emssg.ToAddress +' <br/> Cc :  ' + emssg.CcAddress + '<br/> Subject :  ' + emssg.subject + ' <br/> <br/>'+ emssg.textBody;
 
 
 
 
  return textemailBody;
}
public void settextemailBody(string textemailBody)
{
  
  this.textemailBody=textemailBody;
} 
String Frmlst;
{
if(emssg.INCOMING==True)
{

 Frmlst=emssg.ToAddress;
 system.debug('^^^^^^^^^^^'+Frmlst);
}
else
{
Frmlst=emssg.FromAddress;
}
}


public string getBCClist()
{
 
 if(frwd=='False')
  BCClist = emssg.bccaddress;
  for(integer i=0;i<selectedcontactsbcc.size();i++)
  {
  if(BCClist!=''  && BCClist!=null )
  {
  BCClist = BCClist+';';
  //BCClist = BCClist+',';
  }
  if(BCClist!=null)
  BCClist = BCClist+ selectedcontactsbcc[i];
  else
 BCClist = selectedcontactsbcc[i];
  }
  selectedcontactsbcc.clear();
  return BCClist;
}
public void setBCClist(string BCClist)
{
  
  this.BCClist=BCClist;
} 



public string getAddCClist()
{
   if(flg=='True' && frwd=='False')
  AddCClist = emssg.ccaddress;
    for(integer i=0;i<selectedcontactscc.size();i++)
  {
  if(AddCClist!=''   && AddCClist!=null)
  {
  AddCClist = AddCClist+';';
  //AddCClist = AddCClist+',';
  }
  
  if(AddCClist!=null)
  AddCClist = AddCClist+ selectedcontactscc[i];
  else
  AddCClist =  selectedcontactscc[i];
 
  }
  selectedcontactscc.clear();
  
  return AddCClist;
}
public void setAddCClist(string AddCClist)
{
  
  this.AddCClist=AddCClist;
} 



public string getFrmlst()
{
  
  return Frmlst;
}
public void setFrmlst(string Frmlst)
{
  
  this.Frmlst=Frmlst;
}

public list<SelectOption> getFrmAdd()
{
List<SelectOption> options1 = new List<SelectOption>();
options1.add(new SelectOption(userEmail,userEmail));
options1.add(new SelectOption('act@honeywell.com','act@honeywell.com'));
options1.add(new SelectOption('aog@honeywell.com','aog@honeywell.com'));
options1.add(new SelectOption('aeroredirecttoc@honeywell.com','aeroredirecttoc@honeywell.com'));
options1.add(new SelectOption('apacactinternal@honeywell.com','apacactinternal@honeywell.com'));
options1.add(new SelectOption('aerorepairs@honeywell.com','aerorepairs@honeywell.com'));
options1.add(new SelectOption('aerospacewarranty@honeywell.com','aerospacewarranty@honeywell.com'));
options1.add(new SelectOption('aerotechsupport@honeywell.com','aerotechsupport@honeywell.com'));
options1.add(new SelectOption('anniston.rfq@honeywell.com','anniston.rfq@honeywell.com'));
options1.add(new SelectOption('avionics@honeywell.com','avionics@honeywell.com'));
options1.add(new SelectOption('bga-orders@honeywell.com','bga-orders@honeywell.com'));
options1.add(new SelectOption('bkparts@honeywell.com','bkparts@honeywell.com'));
options1.add(new SelectOption('brgacssolathe@honeywell.com','brgacssolathe@honeywell.com'));
options1.add(new SelectOption('cassd@honeywell.com','cassd@honeywell.com'));
options1.add(new SelectOption('cpsquotescoe@honeywell.com','cpsquotescoe@honeywell.com'));
options1.add(new SelectOption('cpsquotescoeanntmptuc@honeywell.com','cpsquotescoeanntmptuc@honeywell.com'));
options1.add(new SelectOption('cpsquotescoedvcr@honeywell.com','cpsquotescoedvcr@honeywell.com'));
options1.add(new SelectOption('cpsquotescoephx@honeywell.com','cpsquotescoephx@honeywell.com'));
options1.add(new SelectOption('crc-airtransport@honeywell.com','crc-airtransport@honeywell.com'));
options1.add(new SelectOption('crc-edi@honeywell.com','crc-edi@honeywell.com'));
options1.add(new SelectOption('crc-spex@honeywell.com','crc-spex@honeywell.com'));
options1.add(new SelectOption('crc-toronto@honeywell.com','crc-toronto@honeywell.com'));
//options1.add(new SelectOption('d&sorders@honeywell.com','d&sorders@honeywell.com')); commented for incident INC000008714992
//options1.add(new SelectOption('d&squotes@honeywell.com','d&squotes@honeywell.com')); commented for incident INC000008714992
//options1.add(new SelectOption('deferredordersweb@honeywell.com','deferredordersweb@honeywell.com'));
options1.add(new SelectOption('disputes@honeywell.com','disputes@honeywell.com'));
options1.add(new SelectOption('emeaactinternal@honeywell.com','emeaactinternal@honeywell.com'));
options1.add(new SelectOption('enginerentals@honeywell.com','enginerentals@honeywell.com'));
options1.add(new SelectOption('gbs-aes-pubsaccess@honeywell.com','gbs-aes-pubsaccess@honeywell.com'));
options1.add(new SelectOption('gbs-aes-repair@honeywell.com','gbs-aes-repair@honeywell.com'));
options1.add(new SelectOption('gcc-als@honeywell.com','gcc-als@honeywell.com'));
options1.add(new SelectOption('gccoem@honeywell.com','gccoem@honeywell.com'));
options1.add(new SelectOption('hw-flame-sensors@honeywell.com','hw-flame-sensors@honeywell.com'));
options1.add(new SelectOption('iss@honeywell.com','iss@honeywell.com'));
//options1.add(new SelectOption('issweb@honeywell.com','issweb@honeywell.com'));
options1.add(new SelectOption('orderchanges@honeywell.com','orderchanges@honeywell.com'));
options1.add(new SelectOption('orderstatus@honeywell.com','orderstatus@honeywell.com'));
options1.add(new SelectOption('orders@honeywell.com','orders@honeywell.com'));
//options1.add(new SelectOption('ordersweb@honeywell.com','ordersweb@honeywell.com'));
options1.add(new SelectOption('pubs@honeywell.com','pubs@honeywell.com'));
//options1.add(new SelectOption('pubsweb@honeywell.com','pubsweb@honeywell.com'));
options1.add(new SelectOption('quotes@honeywell.com','quotes@honeywell.com'));
//options1.add(new SelectOption('quotesweb@honeywell.com','quotesweb@honeywell.com'));
//options1.add(new SelectOption('reach.aeroweb@honeywell.com','reach.aeroweb@honeywell.com'));
options1.add(new SelectOption('roquoteescalation@honeywell.com','roquoteescalation@honeywell.com'));
options1.add(new SelectOption('returns@honeywell.com','returns@honeywell.com'));
options1.add(new SelectOption('spex_emea@honeywell.com','spex_emea@honeywell.com'));
//options1.add(new SelectOption('warrantyweb@honeywell.com','warrantyweb@honeywell.com'));
options1.add(new SelectOption('websupport@honeywell.com','websupport@honeywell.com'));
//options1.add(new SelectOption('websupportweb@honeywell.com','websupportweb@honeywell.com'));
//options1.add(new SelectOption('yourresponse@honeywell.com','yourresponse@honeywell.com'));
//options1.add(new SelectOption('aerodonotreply@honeywell.com','aerodonotreply@honeywell.com'));
return options1;
}



 
// ************************ Code for search functionality for to *****************************

public boolean noquery{get;set;} 
public boolean noresults{get;set;} 
public boolean showresults{get;set;}
public boolean success{get;set;}
public void search()
{
showresults = true ;
}
public List<Contact> conresults = new List<Contact>();
List<Account> Accresults = new List<Account>();
List<ID> accidlist = new List<ID>();
public void query()
{
conresults.clear();
if(aname!='')
{

aname = aname.trim();
Accresults = [select Name,Id from Account where name = :aname ];
}
for(integer i=0;i<Accresults.size();i++)
{
accidlist.add(Accresults[i].Id);
}
if(fname!='' && lname !=''&& aname !='')
conresults = [select firstname,lastname,email from Contact where firstname = :fname and lastname = :lname and accountid in :accidlist  Limit 50];
else if(fname!='' && lname ==''&& aname =='')
conresults = [select firstname,lastname,email from Contact where firstname = :fname  Limit 50];
else if(fname=='' && lname !=''&& aname =='')
conresults = [select firstname,lastname,email from Contact where lastname = :lname  Limit 50];
else if(fname!='' && lname ==''&& aname !='')
conresults = [select firstname,lastname,email from Contact where firstname = :fname and accountid in :accidlist  Limit 50];
else if(fname=='' && lname !=''&& aname !='')
conresults = [select firstname,lastname,email from Contact where lastname = :lname and accountid in :accidlist  Limit 50];
else if(fname=='' && lname ==''&& aname !='')
conresults = [select firstname,lastname,email from Contact where accountid in :accidlist  Limit 50];
if(fname!='' && lname !=''&& aname =='')
conresults = [select firstname,lastname,email from Contact where firstname = :fname and lastname = :lname  Limit 50];

if(conresults.size()>0)
{
noresults = false;
noquery = false;
success =true;
}
else
{
if(fname!='' || lname !='' || Aname!= '')
{
noquery = false;
noresults = true;
}
else if(fname=='' && lname =='' && Aname == '')
{
noquery = true;
noresults = false;
}
}
}

String fname;
public String getfname()
{
return fname;
}
public void setfname(String fname)
{
this.fname = fname;
}

 public string lname{get;set;}
  public string Aname{get;set;}
String[] options = new String[]{};
public String[] getoptions() {
return options;
}
public void setoptions(String[] options) {
this.options = options;
}

List<contactwrapper> contactList= new List<contactwrapper>();
List<String> selectedcontacts= new List<String>();

public List<contactwrapper> getresults()
    {
        contactList.clear();
        for(Contact a:conresults)
       contactList.add(new contactwrapper(a));
     return contactList;
    }


public PageReference getSelected()
     { 
        
         selectedcontacts.clear();
         for(contactwrapper cntwrapper : contactList)
        if(cntwrapper.selected == true)
        {
        if(cntwrapper.cnt.email!=null)
         selectedcontacts.add(cntwrapper.cnt.email);
        } 
         
        return null;
      }
    
   public List<String> GetSelectedContacts()
     {
        system.debug('&&&&&&&&&&&&&&&&&&&&&selectedcontacts'+selectedcontacts);
        if(selectedcontacts.size()>0)
        {
        system.debug('&&&&&&&&&&&&&&&&&&&&&selectedcontacts'+selectedcontacts);
       return selectedcontacts;
        }
       else
        return null;
    }    
    
    public class contactwrapper
     {
        public Contact cnt{get; set;}
       public Boolean selected {get; set;}
         public contactwrapper(contact a)
         {
            cnt= a;
           selected = false;
        }
    }
    
   // ************************ Code for search functionality for cc *****************************
   public boolean noquerycc{get;set;} 
public boolean noresultscc{get;set;} 
public boolean showresultscc{get;set;}
public boolean successcc{get;set;}
public void searchcc()
{
showresultscc = true ;
}
public List<Contact> conresultscc = new List<Contact>();
List<Account> Accresultscc = new List<Account>();
List<ID> accidlistcc = new List<ID>();
public void querycc()
{
conresultscc.clear();
if(anamecc!='')
{
anamecc = anamecc.trim();
Accresultscc = [select Name,Id from Account where name = :aname ];
}
for(integer i=0;i<Accresultscc.size();i++)
{
accidlistcc.add(Accresultscc[i].Id);
}
if(fnamecc!='' && lnamecc !=''&& anamecc !='')
conresultscc = [select firstname,lastname,email from Contact where firstname = :fnamecc and lastname = :lnamecc and accountid in :accidlistcc];
else if(fnamecc!='' && lnamecc ==''&& anamecc =='')
conresultscc = [select firstname,lastname,email from Contact where firstname = :fnamecc];
else if(fnamecc=='' && lnamecc !=''&& anamecc =='')
conresultscc = [select firstname,lastname,email from Contact where lastname = :lnamecc];
else if(fnamecc!='' && lnamecc ==''&& anamecc !='')
conresultscc = [select firstname,lastname,email from Contact where firstname = :fnamecc and accountid in :accidlistcc];
else if(fnamecc=='' && lnamecc !=''&& anamecc !='')
conresultscc = [select firstname,lastname,email from Contact where lastname = :lnamecc and accountid in :accidlistcc];
else if(fnamecc=='' && lnamecc ==''&& anamecc !='')
conresultscc = [select firstname,lastname,email from Contact where accountid in :accidlistcc];
if(fnamecc!='' && lnamecc !=''&& anamecc =='')
conresultscc = [select firstname,lastname,email from Contact where firstname = :fnamecc and lastname = :lnamecc ];

if(conresultscc.size()>0)
{
noresultscc = false;
noquerycc = false;
successcc =true;
}
else
{
if(fnamecc!='' || lnamecc !=''|| anamecc !='')
{
noquerycc = false;
noresultscc = true;
}
else if(fnamecc=='' && lnamecc =='' && anamecc =='')
{
noquerycc = true;
noresultscc = false;
}
}
}

String fnamecc;
public String getfnamecc()
{
return fnamecc;
}
public void setfnamecc(String fnamecc)
{
this.fnamecc = fnamecc;
}
 
 public string lnamecc{get;set;}
 public string Anamecc{get;set;}
String[] optionscc = new String[]{};
public String[] getoptionscc() {
return optionscc;
}
public void setoptionscc(String[] optionscc) {
this.optionscc = optionscc;
}
    List<String> selectedcontactscc= new List<String>();
    List<contactwrappercc> contactListcc= new List<contactwrappercc>();
public List<contactwrappercc> getresultscc()
    {
        contactListcc.clear();
        for(Contact a:conresultscc)
       contactListcc.add(new contactwrappercc(a));
     return contactListcc;
    }
    public List<String> GetSelectedContactscc()
     {
        system.debug('&&&&&&&&&&&&&&&&&&&&&selectedcontacts'+selectedcontactscc);
        if(selectedcontactscc.size()>0)
        {
        system.debug('&&&&&&&&&&&&&&&&&&&&&selectedcontacts'+selectedcontactscc);
       return selectedcontactscc;
        }
       else
        return null;
    }  
    public PageReference getSelectedcc()
     { 
        
         selectedcontactscc.clear();
         for(contactwrappercc cntwrapper : contactListcc)
        if(cntwrapper.selectedcc == true)
        {
        if(cntwrapper.cntcc.email!=null)
         selectedcontactscc.add(cntwrapper.cntcc.email);
        } 
         
        return null;
      }
      public class contactwrappercc
     {
        public Contact cntcc{get; set;}
       public Boolean selectedcc {get; set;}
         public contactwrappercc(contact a)
         {
            cntcc= a;
           selectedcc = false;
        }
    }
    
  // ************************ Code for search functionality for bcc *****************************
   public boolean noquerybcc{get;set;} 
public boolean noresultsbcc{get;set;} 
public boolean showresultsbcc{get;set;}
public boolean successbcc{get;set;}
public void searchbcc()
{
showresultsbcc = true ;
}
public List<Contact> conresultsbcc = new List<Contact>();
List<Account> Accresultsbcc = new List<Account>();
List<ID> accidlistbcc = new List<ID>();
public void querybcc()
{
conresultsbcc.clear();
if(anamebcc!='')
{
anamebcc = anamebcc.trim();
Accresultsbcc = [select Name,Id from Account where name = :aname];
}
for(integer i=0;i<Accresultsbcc.size();i++)
{
accidlistbcc.add(Accresultsbcc[i].Id);
}
if(fnamebcc!='' && lnamebcc !=''&& anamebcc !='')
conresultsbcc = [select firstname,lastname,email from Contact where firstname = :fnamebcc and lastname = :lnamebcc and accountid in :accidlistbcc];
else if(fnamebcc!='' && lnamebcc ==''&& anamebcc =='')
conresultsbcc = [select firstname,lastname,email from Contact where firstname = :fnamebcc];
else if(fnamebcc=='' && lnamebcc !=''&& anamebcc =='')
conresultsbcc = [select firstname,lastname,email from Contact where lastname = :lnamebcc];
else if(fnamebcc!='' && lnamebcc ==''&& anamebcc !='')
conresultsbcc = [select firstname,lastname,email from Contact where firstname = :fnamebcc and accountid in :accidlistbcc];
else if(fnamebcc=='' && lnamebcc !=''&& anamebcc !='')
conresultsbcc = [select firstname,lastname,email from Contact where lastname = :lnamebcc and accountid in :accidlistbcc];
else if(fnamebcc=='' && lnamebcc ==''&& anamebcc !='')
conresultsbcc = [select firstname,lastname,email from Contact where accountid in :accidlistbcc];
if(fnamebcc!='' && lnamebcc !=''&& anamebcc =='')
conresultsbcc = [select firstname,lastname,email from Contact where firstname = :fnamebcc and lastname = :lnamebcc ];

if(conresultsbcc.size()>0)
{
noresultsbcc = false;
noquerycc = false;
successbcc =true;
}
else
{
if(fnamebcc!='' || lnamebcc !='')
{
noquerybcc = false;
noresultsbcc = true;
}
else if(fnamebcc=='' && lnamebcc =='')
{
noquerybcc = true;
noresultsbcc = false;
}
}
}

String fnamebcc;
public String getfnamebcc()
{
return fnamebcc;
}
public void setfnamebcc(String fnamebcc)
{
this.fnamebcc = fnamebcc;
}
 public string Anamebcc{get;set;}
 public string lnamebcc{get;set;}
String[] optionsbcc = new String[]{};
public String[] getoptionsbcc() {
return optionsbcc;
}
public void setoptionsbcc(String[] optionsbcc) {
this.optionsbcc = optionsbcc;
}
    List<String> selectedcontactsbcc= new List<String>();
    List<contactwrapperbcc> contactListbcc= new List<contactwrapperbcc>();
public List<contactwrapperbcc> getresultsbcc()
    {
        contactListbcc.clear();
        for(Contact a:conresultsbcc)
       contactListbcc.add(new contactwrapperbcc(a));
     return contactListbcc;
    }
    public List<String> GetSelectedContactsbcc()
     {
        system.debug('&&&&&&&&&&&&&&&&&&&&&selectedcontacts'+selectedcontactsbcc);
        if(selectedcontactsbcc.size()>0)
        {
        system.debug('&&&&&&&&&&&&&&&&&&&&&selectedcontacts'+selectedcontactsbcc);
       return selectedcontactsbcc;
        }
       else
        return null;
    }  
    public PageReference getSelectedbcc()
     { 
        
         selectedcontactsbcc.clear();
         for(contactwrapperbcc cntwrapper : contactListbcc)
        if(cntwrapper.selectedbcc == true)
        {
        if(cntwrapper.cntbcc.email!=null)
         selectedcontactsbcc.add(cntwrapper.cntbcc.email);
        } 
         
        return null;
      }
      public class contactwrapperbcc
     {
        public Contact cntbcc{get; set;}
       public Boolean selectedbcc {get; set;}
         public contactwrapperbcc(contact a)
         {
            cntbcc= a;
           selectedbcc = false;
        }
    }   
// ************************ Code for attaching docs from cases*****************************   
List<attachmentwrapper> attachmentList= new List<attachmentwrapper>();
List<Id> selectedattachments= new List<Id>();
List<Id> ilist= new List<Id>();
List<Id> ilist1= new List<Id>();
public boolean noselectattach {get;set;}
 public List<Id> GetSelectedattachments()
     {
         if(selectedattachments.size()>0)
        {
        return selectedattachments;
        }
       else
        return null;
    } 
 public void attachfromcase()
 {
    for(attachmentwrapper attwrapper : attachmentList)
        if(attwrapper.selected1 == true)
        {
        if(attwrapper.att.name!=null)
        {
         selectedattachments.add(attwrapper.att.id);
        }
        }
    List<Attachment> selattach = new List<Attachment>();
    for(integer i=0;i<finalattach.size();i++)
    {
    ilist.add(finalattach[i].id);
    }
    
    /////////removed body
    selattach = [select name,id from Attachment where id in :selectedattachments and id not in :ilist];
        for(integer i=0;i<selattach.size();i++)
        {
     /*
        string newkey='11111111111111111111111111111111';
      Blob cryptoKey=blob.valueof(newkey);
      Blob decryptedData = Crypto.decryptWithManagedIV('AES256', cryptoKey, selattach[i].body);       
      selattach[i].body=decryptedData;
     */
     
         emailId1.add(selattach[i].Id);
       finalattach.add(selattach[i]); 
        
         }
           getshowatt();
           selectattach=false;
        
 }
 public void attachfileCase(){
 
for(integer i=0;i<finalattach.size();i++)
    {
    ilist1.add(finalattach[i].id);
    }
attachments = [Select Id,name from Attachment where parentId=:caseId and id not in :emailid and id not in :ilist1];
if(attachments.size()>0)
{
selectattach=true;
}
else
{
noselectattach = true;
}
}
public void hidemessage()
{
noselectattach = false;
}
//****************END OF FUNCTION
           
     public List<Attachment> getattachments() {
     return attachments;
    }
public void cancelAttachment(){
selectattach=false;
}

 
public List<attachmentwrapper> getresults1()
    {
        attachmentList.clear();
        for(Attachment a:attachments)
        attachmentList.add(new attachmentwrapper(a));
        return attachmentList;
    }
    public void getSelected1()
     {
     /*     for(attachmentwrapper attwrapper : attachmentList)
        if(attwrapper.selected1 == true)
        {
        if(attwrapper.att.name!=null)
        {
         selectedattachments.add(attwrapper.att.id);
        }
        } */
         
      }
     
    public class attachmentwrapper
     {
        public Attachment att{get; set;}
       public Boolean selected1 {get; set;}
         public attachmentwrapper(Attachment a)
         {
            att= a;
           selected1 = false;
        }
    }
  // ********************************End of code    *****************
   //************************Code to show the list of attachmnets ***********
  public boolean isfrwd {get;set;}
  public Boolean hasattachments {get;set;}
   public List<Attachment> getshowatt()
  {
  if(finalattach.size()>0)
  {
  hasattachments = true;
  return finalattach;
  }
  else
  return null;
  }
  
  public id testassign {get; set;}
 
  public void del()
  {
   for(integer i=0;i< finalattach.size();i++)
   {
   if(finalattach[i].id == testassign)
   finalattach.remove(i);
   }
  
  if(finalattach.size()==0)
  hasattachments = false;
  }
  {
  if(frwd=='True')
  {
  List<Attachment_Object__c> aoj = new List <Attachment_Object__c> ();
  List<ID> ili = new List <Id> ();
  aoj = [select name,Attachment_Id__c from Attachment_Object__c where Email_Message_ID__c = :pageid ];
  for(integer i=0;i< aoj.size();i++)
   {
   ili.add(aoj[i].Attachment_Id__c);
   }
   
    List<Attachment> showfirst = [select id,name from Attachment where id  in : ili];
 // List<Attachment> showfirst = [select name,body from Attachment where id  in : ili];
  for(integer i=0;i< showfirst.size();i++)
   {
   
         emailId1.add(showfirst[i].Id);
    finalattach.add(showfirst[i]);
   }
  }
  }
}