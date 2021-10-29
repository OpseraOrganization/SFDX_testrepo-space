Public class VF_Template_Controller{
    List<Opportunity> Opps = new List<Opportunity>();
    List<String> optyOwner=new List<String>();
    List<Id> oppIds=new List<Id>();
    Public List<Opportunity> getClosedYest(){
        Date yest=System.today()-1;
Opps=[Select SBU__c,StageName,Opportunity_Number__c,Description,Close_Date_Formula__c,Name,Amount,Account_name_formula__c,opportunity_owner_formula__c,Platform_Name_Formula__c,Product_line_Product_group__c,(Select title,IsPrivate from NotesAndAttachments) from Opportunity where SBU__c=:'ATR' and CloseDate=:yest and StageName=:'Closed Won'];
        /*for(Integer i=0;i<Opps.size;i++)
            Opps[i].Amount*/
        System.debug('Closed yest'+opps);
        if(opps.size()>0)
            return opps;
        else
            return null;
    }
}