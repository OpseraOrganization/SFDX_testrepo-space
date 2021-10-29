public class SendEmailAlerts 
{
       integer errLoc=0;
   public String    recId        {get; set;}
   public String    recName      {get; set;}
   public String    objectName      {get; set;}
        String   recIdForErrMsg; 
        Boolean    isCodeCobverageTesting = false;
   string serverUrl   =         'https://na6.salesforce.com/'; 
                     //'https://cs1.salesforce.com/';
  string htmlHeader  =           '<html><head>'
                  +     '<style>.tableborder{  border-bottom:3px solid #e39321;}.fontlabel{  font-family:Arial, Helvetica, sans-serif;  color:#333;  font-size:100%;}</style>'
                     +     '</head><body class=fontlabel>';
  string htmlFotter  =         '</body></html>';
   
   public void codeCovTest()
   {
     isCodeCobverageTesting = true;
     PageReference pageRefTest = autoRun();
   }
   public PageReference autoRun()
   {
        try
        {
          if(isCodeCobverageTesting == false)
          {
            errLoc  =  10;
            
            recId               =  ApexPages.currentPage().getParameters().get('recId');
            recName             =  ApexPages.currentPage().getParameters().get('recName');
            objectName             =  ApexPages.currentPage().getParameters().get('objectName');
          }
          
          recIdForErrMsg          =  recId;   
          
          errLoc  =  20;
          String [] emailList = new String[1];
          emailList[0] = 'varun.nirala@honeywell.com';
          
          errLoc  =  30;
          String htmlBdy = 'Dear SFDC Admin,<br><br>Following <b>'+objectName+'</b>, is having duplicate record/data. Please review.<br><br>';
          htmlBdy = htmlBdy + '<li><a href=\'' + serverUrl + recId+'\'>'+recName+'</a></li><br/><br/><br/>';
          htmlBdy = htmlBdy + 'Thank you,';
          
          errLoc  =  40;
          sendEmail.SendSimpleEmailNotification
                              (
                                emailList,
                                'Duplicate '+objectName+' record for - '+recName,
                                htmlHeader + htmlBdy + htmlFotter
                              );
        errLoc  =  50;                      
          PageReference pageRef = new PageReference('/' + recId);
        pageRef.setRedirect(true);
        return pageRef;
        }
      catch(Exception e)
      {
        
                        utilClass.createErrorLog
                                     (
                                     'SendEmailAlerts.autoRun',
                                      objectName,
                                     'errLoc - ' + errLoc + ' - ' + recIdForErrMsg + ' - ' + e.getMessage()
                                     );
                                     
          return null;
      }   
    }
   
   static testMethod void myunitTest1()
  {
    SendEmailAlerts test = new SendEmailAlerts();
    test.codeCovTest();
  }
   
   
}