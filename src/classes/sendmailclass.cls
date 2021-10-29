public class sendmailclass
{ 
List<Attachment> finalattach=new List<Attachment>(); 
List<Attachment> finalattach1=new List<Attachment>(); 
public Boolean selectTemp { get; set; }
public Boolean selectattach { get; set; }
public Boolean isHTML{ get; set; }
public Boolean isText{ get; set; }
public Boolean isTemplate{ get; set; }
List<SelectOption> optionsTemp = new List<SelectOption>();
List<Folder> emailTempList=new List<Folder>();
List<EmailTemplate> emailTemplates=new List<EmailTemplate>();
List<Attachment> attachments=new List<Attachment>();
String EmailTemplate=null;
EmailMessage emsg = new EmailMessage();
EmailMessage em = new emailMessage();
List<Attachment> att = new List<Attachment>(); 
id caseid=System.currentPageReference().getParameters().get('caseid');
//String HtmlemailBody;
String HtmlemailBody=System.currentPageReference().getParameters().get('HtmlemailBody');
String userName = UserInfo.getUserName();
User activeUser = [Select Email,Name,signature1__c From User where Username = : userName limit 1];
case   caseRec=[select casenumber,subject,Case_Ref_ID__c,Contactid from case where id=:caseid];
//String HtmlemailBody,textemailBody;
//String textemailBody;
Contact cot;
String Tolist=System.currentPageReference().getParameters().get('Tolist');


{
if(caseRec.Contactid!=null)
 cot = [select email from Contact where id  = :caseRec.Contactid];
     if(cot !=null   && Tolist==null ){
     
     if(cot.email!=null)
     Tolist = cot.email;}
     }
 
 
String textemailBody=System.currentPageReference().getParameters().get('textemailBody');
String   subject=System.currentPageReference().getParameters().get('subject');
String templateId =System.currentPageReference().getParameters().get('templateId');
String CClist=System.currentPageReference().getParameters().get('CClist');

String AddCClist=System.currentPageReference().getParameters().get('AddCClist');
String BCClist=System.currentPageReference().getParameters().get('BCClist');
String isHTMLval=System.currentPageReference().getParameters().get('isHTMLval');
EmailTemplate e;
List<id> emailid = new List<ID>();
List<id> emailid1 = new List<ID>();
 public PageReference doref(){

     System.debug('*********'+HtmlemailBody);
     if(templateId==null){
     textemailBody=HtmlemailBody.replace('amp;','');
     textemailBody=textemailBody.replace('&nbsp',' ');
     
    textemailBody = textemailBody.replace('&ndash;','–');
     
     
     
     
     
     
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
 
 
 public sendmailclass(ApexPages.StandardController controller) {  
 if(templateId==null)
 isTemplate=true;
 
 
   System.debug('&&&&&&&&&&&&&&&HtmlemailBody'+HtmlemailBody);
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
 System.debug('&&&&&&&&&&&&&&&templateId'+templateId);
if(templateId !=null){
  e=[Select  id, body, markup, htmlvalue, templatestyle, 
      templatetype,subject from EmailTemplate where Id=:templateId];
    //    HtmlemailBody=e.+activeUser.signature1__c;
    if(isHTML==true && e.htmlvalue!=null)
HtmlemailBody=e.htmlvalue+activeUser.signature1__c;
else
  HtmlemailBody=e.body+activeUser.signature1__c;
  
              HtmlemailBody = HtmlemailBody.replace('<![CDATA[','');
              HtmlemailBody = HtmlemailBody.replace(']]','');
              //HtmlemailBody = HtmlemailBody.replace('nbsp;','');
              //HtmlemailBody = HtmlemailBody.replace('&ndash;','–');
              //HtmlemailBody = HtmlemailBody.replace('&amp;','');
              textemailBody=e.body;
  
   if(textemailBody  !=null){
  while( textemailBody.contains('{!Case.') && textemailBody.contains('}'))
   {
    integer i11t=textemailBody.indexof('{!Case.'); 
    integer i22t=textemailBody.indexof('}');
    String substr1t=textemailBody.substring(i11t,i22t+1);
    String substrt=substr1t;
    substrt=substrt.replace('{!Case.','');
    substrt=substrt.replace('}','');
      System.debug('&&&&&&&&&&&&&&& substrt'+ substrt);
    if(substrt!=null){
    
          System.debug('entered loop');
        String string_limitt=   ' select ' + substrt + ' from Case where id = \'' + caseid+ '\'';
        System.debug('&&&&&&&&&&&&&&& string_limitt'+  string_limitt);
        Case caseDatat = Database.query(string_limitt);
        string valueof_fieldt  =String.valueOf ( caseDatat.get(substrt ));  
        if(valueof_fieldt!=null)
        textemailBody=textemailBody.replace(substr1t,valueof_fieldt);
        else
        textemailBody=textemailBody.replace(substr1t,' ');
    }
    }
    
    }
  
  
  if(HtmlemailBody  != null){
  
  while( HtmlemailBody.contains('{!Case.') && HtmlemailBody.contains('}'))
   {
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
    System.debug('&&&&&&&&&&&&&&&valueof_field'+valueof_field);
    if(valueof_field!=null)
    HtmlemailBody=HtmlemailBody.replace(substr1,valueof_field);
    else
     HtmlemailBody=HtmlemailBody.replace(substr1,' ');
    }
    }
    
    }
    
    
   integer flag=0;
  // to replace merge fields in templates 
     subject=e.subject;
     
     if(subject.contains('{!Case.Subject}'))
     flag=1;
     
     
    while(    subject.contains('{!') && subject.contains('}')    && subject.contains('Case') )
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
    //from EmailTemplate where folderid=:emailTempList[0].Id];  
}

  
public void attachtemplate(){
selectTemp=true;
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

public case getcaseRecord(){
    if(subject !=null)
    caseRec.subject=subject; 
    return caseRec;
}

public void cancelTemplate(){
selectTemp=false;
}

public void ViewDetails(){
emailTemplates=[Select Id,Name,description,templatetype,folderid from EmailTemplate where folderid=:EmailTemplate]; 
if(EmailTemplate == 'My Personnel Folder')
  emailTemplates=[Select Id,Name,description,templatetype,folderid from EmailTemplate where folderid=:Userinfo.getuserid()]; 
 else
 emailTemplates=[Select Id,Name,description,templatetype,folderid from EmailTemplate where folderid=:EmailTemplate]; 

}


public PageReference ViewTemplateDetails(){
//userName = UserInfo.getUserName();
//activeUser = [Select Email,Name,signature1__c From User where Username = : userName limit 1];
isTemplate=false;
      EmailTemplate e=[Select  id, body, markup, htmlvalue, templatestyle, 
      templatetype,subject from EmailTemplate where Id=:templateId];
      //templatetype,subject from EmailTemplate where Id='00X30000001AEu6'];
      //HtmlemailBody=e.htmlvalue;
      HtmlemailBody=e.body;
            selectTemp=false; 
      subject=e.subject;
      String plainbdy=e.body;
      textemailBody=e.body;
      HtmlemailBody = HtmlemailBody.replace('nbsp;','');
      HtmlemailBody = HtmlemailBody.replace('&amp;','');
      HtmlemailBody = HtmlemailBody.replace('&ndash;','-');
     // PageReference p= new  PageReference('/apex/SendmailPage?caseid='+caseid+'&HtmlemailBody='+HtmlemailBody+'&subject='+subject);
 PageReference p= new  PageReference('/apex/SendmailPage?caseid='+caseid+'&textemailBody='+textemailBody+'&HtmlemailBody='+HtmlemailBody+'&subject='+subject);
 
    
  return(p);
}


public PageReference ViewTemplateDetails1(){
      EmailTemplate e=[Select  id, body, markup, htmlvalue, templatestyle, 
      templatetype,subject from EmailTemplate where Id=:templateId];
      //templatetype,subject from EmailTemplate where Id='00X30000001AEu6'];
      HtmlemailBody=e.body;
      selectTemp=false; 
      subject=e.subject;
        HtmlemailBody = HtmlemailBody.replace('&nbsp;','');
         HtmlemailBody = HtmlemailBody.replace('&amp;','');
         HtmlemailBody = HtmlemailBody.replace('&ndash;','-');
      PageReference p= new  PageReference('/apex/SendmailPageHTML?caseid='+caseid+'&HtmlemailBody='+HtmlemailBody+'&subject='+subject);
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
 textemailbody = textemailbody.replace('&ndash;','-');
 }
 if(HtmlemailBody!= null)
 {
  j1 = HtmlemailBody.length();
 // HtmlemailBody = HtmlemailBody.replace('nbsp;','');
 //  HtmlemailBody = HtmlemailBody.replace('&amp;','');
  // HtmlemailBody = HtmlemailBody.replace('&ndash;','-');
  }
 if(Tolist!='' && j<32000 && j1<32000){
 
 
      if(isHTML==true  && templateId==null){
     textemailBody=HtmlemailBody.replace('&amp;','');
     textemailBody=textemailBody.replace('&nbsp;',' ');
     textemailBody = textemailBody.replace('&ndash;','-');
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
 mail.setUseSignature(false);
 
System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@textemailbody'+textemailbody);
 mail.setPlainTextBody(textemailbody);
System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@HtmlemailBody'+HtmlemailBody);
 mail.sethtmlbody(HtmlemailBody);


System.debug('&&&&&&&&&&&&&&&&&&&&&&&&Frmlst'+Frmlst);
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

finalattach=[Select Id,name,ParentId,body from Attachment where Id in :emailId1];
            finalattach1=[Select Id,name,ParentId,body from Attachment where Id in :emailId];









  
  for(integer i=0;i<finalattach.size();i++)
  {
     Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
     efa.setFileName(finalattach[i].name);


/*
string newkey='11111111111111111111111111111111';
      Blob cryptoKey=blob.valueof(newkey);
      Blob decryptedData = Crypto.decryptWithManagedIV('AES256', cryptoKey, finalattach[i].body);       
     
System.debug('###########################after decryption'+decryptedData  );
     efa.setBody(decryptedData);*/
     
     system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&sending');
     
      efa.setBody(finalattach[i].body);
     
     fileAttachments[i]=efa;
   }  
  mail.setFileAttachments(fileattachments);
try
{
 
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}
catch(Exception e)
{
System.debug('EXception in sending mail'+e);
}
// ********************INSERTING EMAIL MESSAGE ONCE THE MAIL IS SENT*************
emsg.ToAddress = Tolist;
emsg.FromAddress = Frmlst;
emsg.parentid = caseid;
emsg.ccaddress = AddCClist;
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
insert t;

//***********************CODE FOR ENTION*************************************

/*

for(integer i=0;i<finalattach1.size();i++)
    {
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
 
        //set method for property
      public void setPropertyNew(EmailMessage emsg ) {
        this.emsg  = emsg ;
    }

    //Getting the Newproperty Object    
    public EmailMessage getemsg (){
    return emsg ;
    }
 
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
    
  public string fileName   
     {    get;set;    }  
       
     public Blob fileBody   
     {    get;set;    }  
     public boolean showlist{get;set;} 
     
     public void attachfile()
         {
          showdoc = true;
         }
         public void nodisp()
         {
         showdoc = false;
         }
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
            finalattach2=[Select Id,name,ParentId from Attachment where Id in :emailId1 ];
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
  /*   public List<attachment> getfile1()
     {
     if(emailId.size()>0)
     {
      system.debug('+++++++++++++++++++++**********8'+emailId);
     List<Attachment> a = [select body,name,parentid,bodylength from Attachment where id in :emailid];
    system.debug('+++++++++++++++++++++------------'+a);
     return a;
     }
     else
     {
     return null;
     }
     } */


public string getsubject()
{
  if(subject==null ){
  subject=caserec.subject;
    if(subject==null)
    subject='';

  subject=subject+' '+caserec.CaseNumber+' '+caserec.Case_Ref_ID__c;
}
  return subject;
}
public void setsubject(string subject)
{
  
  this.subject=subject;
  
} 


public string getTolist()
{
   //if(cot !=null)
   //Tolist = cot.email;
  for(integer i=0;i<selectedcontacts.size();i++)
  {
  if(Tolist!=''  && Tolist!=null)
  {
  //Tolist = Tolist+',';
  Tolist = Tolist+';';
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



public string getAddCClist()
{
  for(integer i=0;i<selectedcontactscc.size();i++)
  {
  if(AddCClist!=''  && AddCClist!=null)
  {
  //AddCClist = AddCClist+',';
  AddCClist = AddCClist+';';
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

public string getBCClist()
{
  for(integer i=0;i<selectedcontactsbcc.size();i++)
  {
  if(BCClist!=''  && BCClist!=null )
  {
  BCClist = BCClist+';';
  //BCClist = BCClist+',';
  }
  
 // BCClist = BCClist+ selectedcontactsbcc[i];
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
public string getHtmlemailBody()
{
  if(HtmlemailBody==null)
  HtmlemailBody=activeUser.signature1__c;
  
  
  return HtmlemailBody;
}
public void setHtmlemailBody(string HtmlemailBody)
{
  
  this.HtmlemailBody=HtmlemailBody;
} 
public string gettextemailBody()
{  
  return textemailBody;
}
public void settextemailBody(string textemailBody)
{
  
  this.textemailBody=textemailBody;
} 
String Frmlst;
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
public List<Account> Accresults = new List<Account>();
List<ID> accidlist = new List<ID>();
public void query()
{
conresults.clear();
if(aname!='')
{
aname = aname.trim();

Accresults = [select Name,Id from Account where name  like :aname + '%'];
}
for(integer i=0;i<Accresults.size();i++)
{
accidlist.add(Accresults[i].Id);
}
if(fname!='' && lname !=''&& aname !='')
conresults = [select  firstname,lastname,email from Contact where firstname = :fname and lastname = :lname and accountid in :accidlist Limit 50];
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

public List<contactwrapper> contactList= new List<contactwrapper>();
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
Accresultscc = [select Name,Id from Account where name like :aname + '%'];
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
Accresultsbcc = [select Name,Id from Account where name like :aname + '%'];
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
public List<attachmentwrapper> attachmentList= new List<attachmentwrapper>();
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
    selattach = [select name,Body from Attachment where id in :selectedattachments and id not in :ilist];
        for(integer i=0;i<selattach.size();i++)
        {
      /*string newkey='11111111111111111111111111111111';
      Blob cryptoKey=blob.valueof(newkey);
      Blob decryptedData = Crypto.decryptWithManagedIV('AES256', cryptoKey, selattach[i].body);       
      selattach[i].body=decryptedData;*/
     
       finalattach.add(selattach[i]); 
       emailId1.add(selattach[i].Id);
        
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
  // ********************************End of code    *****************
  
}