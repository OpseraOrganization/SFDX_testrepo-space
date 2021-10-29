/***************************************************
**File Name: RedirectToConvertPage
** Description: The class is redirect the lead convert page and update the checkbox
**Company Name : Honeywell Aero
**Date Of Creation:2-Jan-2013
**Version No:0.01
**Created By:Manoj Kumar Jena
** 
*****************************************************/ 
Public class RedirectToConvertPage{
    public string leadid ;
    public  RedirectToConvertPage(ApexPages.StandardController controller){
        leadid =Apexpages.currentPage().getParameters().get('id');
    }
  public void redirctlead(){
        Lead ld= [select id,Lead_converted__c from lead where id=:leadid]; 
        system.debug('aaaaaaaa'+ld.Lead_converted__c);
        if(ld.Lead_converted__c==true){
        system.debug('bbbbbbbbbbbbbbbbbbbbbbbbbbbb');

            ld.Lead_converted__c=false;
           update ld;
                  }
            }
}