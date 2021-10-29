public class sendmailclass_detail
{  

    EmailMessage em = new emailMessage();
    id pageid;
    EmailMessage emssg = new EmailMessage();

    public sendmailclass_detail(ApexPages.StandardController controller) {
    }
    {
pageid =  System.currentPageReference().getParameters().get('Id');
   
   system.debug('IIIIIIII'+pageid);
 emssg = [Select status,ToAddress,FromAddress,subject,ParentId,BccAddress,HtmlBody,INCOMING,textbody from EmailMessage
   where id=:Pageid];
    system.debug('OOOOOOOOOOO'+emssg);
    system.debug('***********'+emssg.ToAddress);
    system.debug('111***********'+emssg.FromAddress);
    }    
id caseid=System.currentPageReference().getParameters().get('caseid');
 String userName = UserInfo.getUserName();
User activeUser = [Select Email From User where Username = : userName limit 1];
case caseRec=[select casenumber,subject from case where id=:caseid];
String HtmlemailBody;

public case getcaseRecord()
{
return caseRec;
}

public EmailMessage getEmailRec()
{
return emssg;
}

String userEmail = activeUser.Email;
  
 public void send()
 {
   String[] strto =new String[]{};
   strto=Tolist.split(',');
  String[] strcc = new String[]{};
   strcc = CClist.split(',');
 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
 mail.setToAddresses(strto);
 //mail.setCcAddresses(strcc);
 mail.setsubject(caserec.subject);
 mail.setUseSignature(true);
 //mail.setPlainTextBody(
 mail.sethtmlbody(HtmlemailBody);
 List<Attachment_Object__c> objlist = [select Case_Id__c,Attachment_Id__c,Flag__c from Attachment_Object__c where Case_Id__c = :caserec.Id and Flag__C = False];
  
  
  
  
  
  
  
Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
if(objlist.size()>0)
{
Attachment att = [select name,Body from Attachment where id= :objlist[0].Attachment_Id__c];
  efa.setFileName(att.name);
   efa.setBody(att.body);
   objlist[0].Flag__c = True;
   update objlist[0];
   
 }  
mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
 Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

 

 }
 
 
    public Id getcaseid() 
     {  
     return caseid;
       } 
 
 
 public void template()
 {
 }
 public void attachfile()
 {
 
 }
 public void preview()
 {
 }
 public void spelling()
 {
 }
  public void cancel()
 {
 }
  public string fileName   
     {    get;set;    }  
       
     public Blob fileBody   
     {    get;set;    }  
     
     
String Tolist;
{
if(emssg.INCOMING==True)
{

 Tolist=emssg.FromAddress;
 system.debug('^^^^^^^^^^^'+Tolist);
}
else
{
system.debug('Heloooooooooooo'+emssg.ToAddress);
Tolist=emssg.ToAddress;
}
}
public string getTolist()
{
  
  return Tolist;
}
public void setTolist(string Tolist)
{
  
  this.Tolist=Tolist;
} 
String CClist;
public string getCClist()
{
  
  return CClist;
}
public void setCClist(string CClist)
{
  
  this.CClist=CClist;
} 

public string getHtmlemailBody()
{
  
  return HtmlemailBody;
}
public void setHtmlemailBody(string HtmlemailBody)
{
  
  this.HtmlemailBody=HtmlemailBody;
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
options1.add(new SelectOption('CPSQuotesCOEANNTMPTUC@honeywell.com','CPSQuotesCOEANNTMPTUC@honeywell.com'));

return options1;
} 


List<Attachment> alist = new List<Attachment>();
public List<attachment> getalist()
{
List<Attachment_Object__c> obj = new List<Attachment_Object__c>();
STring st = '';
List<Id> stids = new List<Id>();
if(emssg.INCOMING == True)
{
system.debug('^^^^^^^^^^^looooooooooooop');
Id cid = emssg.parentid;
obj = [select Attachment_Id__c,Case_Id__c from Attachment_Object__c where Email_Message_ID__c = :pageid and Case_Id__c = :cid ] ;
system.debug('^^^^^^^^^^^looooooooooooopobj'+obj);
}
else
{
obj= [select Attachment_Id__c,Case_Id__c from Attachment_Object__c where Email_Message_ID__c = :pageid];
}
for(integer i=0;i<obj.size();i++)
{
stids.add(obj[i].Attachment_Id__c);
}
alist  = [select name from Attachment where id in :stids];

return alist;
}   
 
}