/************************************************************************
Name         : CSWIEmailsList
Created By   : NTTData
Created Date : 19-May-2016
Usages       : To get CSWI emails based on Customer Code and Plant Code           
*************************************************************************/
Public class CSWIEmailsList{
    public static String getEmailAddress(String siteCode,String plantCode){
        String pcmname,EmailMatch,EmailMatch1,NoEmailMatch;
        String email='';
        List<CSWI_Emails_List__c> cswilist = new List<CSWI_Emails_List__c>();
        String sicode = '\'%' + siteCode + '%\'';
        List<Plant_Code_Master__c> pcm = [Select ID,SAP_Plant_Code__c,UFR_SAP_Plant_Name__c from Plant_Code_Master__c where SAP_Plant_Code__c=:plantCode limit 1];
        if(pcm.size()>0){
            pcmname = pcm[0].UFR_SAP_Plant_Name__c;
        }
        system.debug('---PCMName '+pcmname);
        cswilist = Database.Query('SELECT id,Emails__c,Sold_To__c,Site_Code__c from CSWI_Emails_List__c where Sold_To__c LIKE '+sicode+' ORDER BY CreatedDate Nulls Last');        
        system.debug('cswilist------->'+cswilist);
        if(cswilist.size()>0){
            for(CSWI_Emails_List__c c:cswilist){
                if(pcmname!=null && c.Site_Code__c!=null && c.Site_Code__c.toUpperCase().contains(pcmname.toUpperCase())){
                    system.debug('-----Tru'+c.Emails__c);
                    EmailMatch = c.Emails__c;
                }
                else if(pcmname!=null && c.Site_Code__c!=null && c.Site_Code__c == 'AllSites'){
                    system.debug('-----Tru1'+c.Emails__c);
                    EmailMatch1 = c.Emails__c;
                }
                else if((c.Site_Code__c == null && pcmname == null) || (c.Site_Code__c == null && pcmname != null)){
                    system.debug('---Fal'+c.Emails__c);
                        NoEmailMatch = c.Emails__c;
                }
            }
            system.debug('---EmailMatch '+EmailMatch);
            system.debug('---EmailMatch1 '+EmailMatch1);
            system.debug('---NoEmailMatch '+NoEmailMatch);
            if(EmailMatch!=null)
                email = EmailMatch;
            else if(EmailMatch1!=null)
                email = EmailMatch1;
            else if(NoEmailMatch!=null)
                email = NoEmailMatch;
            system.debug('---Email '+email);
        }
        return email;
    }  
}