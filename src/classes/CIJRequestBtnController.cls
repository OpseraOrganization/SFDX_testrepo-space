/*******************************************************************************
Name         : CIJRequestBtnController
Created By   : Ravi Bodepalli
Company Name : NTT Data
Project      : Honeywell Aero  
Created Date : 25/2/2019
Usages       : This Class is used in creating CIJ Records from case Button  
*******************************************************************************/
public class CIJRequestBtnController{
   
    public List<SelectOption> opts {get;set;} 
    public Id recTypeId  {get;set;}
    public string recordId  {get;set;}
    public Case cse {get;set;}
    public String accName {get;set;}
    public String csNumber {get;set;}
    public String oproName {get;set;}    
    public Id accId {get;set;}
    public Id csId {get;set;}
    public Id oproId {get;set;}
    public list < RecordType > rtList {get;set;}
    
    public CIJRequestBtnController(ApexPages.StandardController controller) {
       recordId = ApexPages.CurrentPage().getparameters().get('id');
       rtList = [Select Id, Name From RecordType Where sObjectType =: 'Commercial_Item_Justification__c']; 
       accName = '';
       oproName= '';
       if(recordId != null){       
            cse = [SELECT Id,CaseNumber,Account.Id, Opportunity_Proposal__c FROM Case WHERE Id =: recordId AND RecordType.Name =: 'D&S Clearing House Proposal'];      
    
             accId =  cse.Account.Id;    
             oproId = cse.Opportunity_Proposal__c;  
             csId =  cse.Id;               
                          
            if(accId != null){
                 Account acc = [Select id, Name from account where id =:accId];
                 accName = acc.Name;
             }
            if(oproId != null){ 
                Opportunity_Proposal__c  opName= [Select id, Name from Opportunity_Proposal__c where id =:oproId];           
                oproName= opName.Name;  
            } 
            csNumber = cse.CaseNumber; 
      } 
    }
    
    public List < SelectOption > getRecTypeOptions() {
        opts = new List < SelectOption > ();
        for (RecordType rt: rtList) {
             if (rt.name == 'OPRO CIJ' || rt.name == 'Transactional CIJ' ){
                opts.add(new SelectOption(rt.id, rt.name));
             }
        } 
        return opts;
    }
    
    public PageReference continueBtn() {
       
        PageReference pageRef;               
      
        Schema.DescribeSObjectResult res = Commercial_Item_Justification__c.SObjectType.getDescribe();
        String csNumLkId = label.RDF_CIJ_CaseNumber;
        String csLkup   = label.RDF_CIJ_CaseNumber_Lkup;        
        
       
        if(accId != null && accName != '' && oproId != null && oproName != '' ){
           system.debug('inside one'+csNumLkId );
           //pageRef = new PageReference('/' + res.getKeyPrefix() + '/e?RecordType=' + recTypeId + '&CF00N2C000001AWxs_lkid='+csId+ '&CF00N2C000001AWxs='+csNumber + '&CF00N1B00000BUxVk_lkid='+oproId + '&CF00N1B00000BUxVk='+oproName +'&CF00N1B00000BUxVZ_lkid=' +accId + '&CF00N1B00000BUxVZ='+accname );
           pageRef = new PageReference('/' + res.getKeyPrefix() + '/e?RecordType=' + recTypeId + csLkup +csId +csNumLkId +csNumber + '&CF00N1B00000BUxVk_lkid='+oproId + '&CF00N1B00000BUxVk='+oproName +'&CF00N1B00000BUxVZ_lkid=' +accId + '&CF00N1B00000BUxVZ='+accname );
           
        }
        else if(accId != null && accName != ''){
           // pageRef = new PageReference('/' + res.getKeyPrefix() + '/e?RecordType=' + recTypeId + '&CF00N2C000001AWxs_lkid='+csId+ '&CF00N2C000001AWxs='+csNumber +  '&CF00N1B00000BUxVZ_lkid=' +accId + '&CF00N1B00000BUxVZ='+accname );
          pageRef = new PageReference('/' + res.getKeyPrefix() + '/e?RecordType=' + recTypeId + csLkup +csId +csNumLkId +csNumber +  '&CF00N1B00000BUxVZ_lkid=' +accId + '&CF00N1B00000BUxVZ='+accname );
          
        }
        else if(oproId != null && oproName != ''){
           // pageRef = new PageReference('/' + res.getKeyPrefix() + '/e?RecordType=' + recTypeId + '&CF00N2C000001AWxs_lkid='+csId+ '&CF00N2C000001AWxs='+csNumber + '&CF00N1B00000BUxVk_lkid='+oproId + '&CF00N1B00000BUxVk='+oproName );
          pageRef = new PageReference('/' + res.getKeyPrefix() + '/e?RecordType=' + recTypeId + csLkup +csId +csNumLkId +csNumber + '&CF00N1B00000BUxVk_lkid='+oproId + '&CF00N1B00000BUxVk='+oproName ); 
          
        }          
        system.debug('pageRef=====>'+pageRef);
        pageRef.setRedirect(true);                    
         
        return pageRef ;
    }
    
    public PageReference cancel() {
        PageReference p = new PageReference('/' + recordId);
        return p;
    }

}