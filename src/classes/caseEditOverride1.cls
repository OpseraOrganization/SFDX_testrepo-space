public class caseEditOverride1 {
   case c{get;set;}
    public caseEditOverride1(ApexPages.StandardController controller) 
    {
      c=(Case)Controller.getRecord();
    }
    List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
String MyProflieName = PROFILE[0].Name;
  public pagereference redirectpage1()
  {
    PageReference returnURL;
     if(c.recordtypeid=='012a0000001ZPNj' && MyProflieName =='GTO FSE/PSE/CSPM/FT/EIS(RO) (Non US)')
     {
    ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You do not have the level of access necessary to perform the operation you requested. Please contact the owner of the record or your administrator if access is necessary.'));
     return null;
//returnURL = new PageReference(ApexPages.addMessage(myMsg));
       // returnURL = new PageReference('/apex/viewpageoverride?id='+c.id);
     }
     else
     returnURL = new PageReference('/'+c.id+'/e?nooverride=1'+'&retURL=/'+c.id);
     return returnURL;
  }
}