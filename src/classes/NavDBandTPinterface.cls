global class NavDBandTPinterface {

    global class Result
    {
         webservice string Resultstatus;
         webservice list<AccountCorssRefdetails> lstAccountCorssRefdetails;
    }
    
    global class AccountCorssRefdetails {
        webservice string AccountNumber;
        webservice string XREFType;
               
    }
    
    webservice static Result NavDBandTPMethod(string Honid)
    {
        Result resobj= new Result();
        list<Account_Cross_Ref__c> Acrlst = new list<Account_Cross_Ref__c >();
        list<AccountCorssRefdetails> lstAcrd=new list<AccountCorssRefdetails>();
        
        if(Honid==null || Honid.trim().length()==0){
                resobj.Resultstatus='Invalid data:Please provide valid honeywell id';
                resobj.lstAccountCorssRefdetails=null;
        
        }
        if(Honid!=null && Honid.trim().length()>0)
        {
            
            list<contact> lstCon=[select id,Accountid from contact where Honeywell_ID__c=:Honid limit 1];
            
            if(lstCon==null || lstCon.isEmpty()){
                resobj.Resultstatus='No contact found with provided honeywell id';
                resobj.lstAccountCorssRefdetails=null;
            }
            
            
            if(lstCon!=null && !lstCon.isEmpty())
            {
                Acrlst = [select XREF_Type__c,External_Account_ID__c from Account_Cross_Ref__c where Account_Name__c=:lstCon[0].Accountid and XREF_Type__c = 'SAP_SOLD_TO'];
                
                for(Account_Cross_Ref__c acrs : Acrlst){
                    AccountCorssRefdetails acr = new AccountCorssRefdetails();
                    acr.AccountNumber = acrs.External_Account_ID__c;
                    acr.XREFType= acrs.XREF_Type__c;
                    lstAcrd.add(acr);
                
                }
                             
                if(lstAcrd!=null && !lstAcrd.isEmpty())
                {
                    
                    resobj.Resultstatus='Success';
                    resobj.lstAccountCorssRefdetails=lstAcrd;
                }
                else
                {
                    resobj.Resultstatus='No Account records found with provided honeywell id';
                    resobj.lstAccountCorssRefdetails=null;
                }
            }
            
        }
        return resobj;
    }
}