public class sendmailclass_detail1
{  

    EmailMessage em = new emailMessage();
    id pageid;
    EmailMessage emssg = new EmailMessage();

    public sendmailclass_detail1() {
    }
    {
pageid =  System.currentPageReference().getParameters().get('Id');
   
if(PageId !=null)

 emssg = [Select status,ToAddress,FromAddress,subject,ParentId,BccAddress,HtmlBody,
 INCOMING,textbody from EmailMessage
   where id=:Pageid];

    }    
    
    
id caseid=System.currentPageReference().getParameters().get('caseid');
 String userName = UserInfo.getUserName();
User activeUser = [Select Email From User where Username = : userName limit 1];
case caseRec=[select casenumber,subject from case where id=:caseid];
String HtmlemailBody;



public EmailMessage getemssg()
{
return emssg;
}



}