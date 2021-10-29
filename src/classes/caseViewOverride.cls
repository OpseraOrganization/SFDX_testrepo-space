public class caseViewOverride{
   case c{get;set;}
   Id profileId=userinfo.getProfileId();
    public caseViewOverride(ApexPages.StandardController controller) 
    {
      c=(Case)Controller.getRecord();
    }
  public pagereference redirectpage()
  {
    PageReference returnURL;
     if(c.recordtypeid==label.TechnicalIssue_RecordTypeID && (ProfileId==Label.Sys_Admin_Profile_Id || ProfileId==Label.Honeywell_System_Administrator_US || ProfileId==Label.Honeywell_System_Administrator_Non_US))
     {
        returnURL = new PageReference('/apex/TechnicalIssue_DetailPage?id='+c.id);
     }
     else
     returnURL = new PageReference('/'+c.id+'?nooverride=1');
     return returnURL;
  }
}