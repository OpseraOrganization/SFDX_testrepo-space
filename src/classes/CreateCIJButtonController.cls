public class CreateCIJButtonController {

    public List<SelectOption> opts {get;set;} 
    public Id recTypeId  {get;set;}
    public string recordId  {get;set;}
    public boolean isCIJRecord {get;set;}         
    public List < Commercial_Item_Justification__c > listCLJObj {get;set;}   
    public Case_Line_Item__c cij {get;set;}   
    public String accName {get;set;}
    public String cliName {get;set;}
    public String oproName {get;set;}    
    public Id accId {get;set;}
    public Id cliId {get;set;}
    public Id oproId {get;set;}
    public list < RecordType > rtList {get;set;}
    
    public CreateCIJButtonController(ApexPages.StandardController controller) {        
        
       recordId = ApexPages.CurrentPage().getparameters().get('id');
       rtList = [Select Id, Name From RecordType Where sObjectType =: 'Commercial_Item_Justification__c']; 
       accName = '';
       oproName= '';
       if(recordId != null){
       
            cij = [SELECT Id,Name,Product_Number__c, RecordType.Name, Case_Number__r.RecordType.Name, Case_Number__r.Opportunity__c, Case_Number__r.Opportunity_Proposal__c, Case_Number__r.Account.Id FROM Case_Line_Item__c WHERE Id =: recordId AND RecordType.Name =: 'DS Clearing House Proposal'
                   AND Case_Number__r.RecordType.Name =: 'D&S Clearing House Proposal'];      
    
             accId =  cij.Case_Number__r.Account.Id;    
             oproId = cij.Case_Number__r.Opportunity_Proposal__c;  
             cliId =  cij.Id;               
                          
            if(accId != null){
                 Account acc = [Select id, Name from account where id =:accId];
                 accName = acc.Name;
             }
            if(oproId != null){ 
                Opportunity_Proposal__c  opName= [Select id, Name from Opportunity_Proposal__c where id =:oproId];           
                oproName= opName.Name;  
               } 
            cliName = cij.Name;           
            
            listCLJObj = [SELECT Id, Name, OPRO_Num__c, Customer__c, Case_Line_Item__r.Case_Number__r.Account.Id, Case_Line_Item__r.Case_Number__r.Opportunity__c FROM Commercial_Item_Justification__c WHERE Case_Line_Item__c =: recordId];
       
        for (RecordType rt: rtList) { 
            if (cij.Product_Number__c == null && (rt.name == 'OPRO CIJ' || rt.name == 'Transactional CIJ')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Product information on the CLI record is mandatory before creating a CIJ record.'));
                isCIJRecord = false;
                
            } else if (!listCLJObj.isEmpty() && listCLJObj.size() > 0 && (rt.name == 'OPRO CIJ' || rt.name == 'Transactional CIJ')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You can\'t create more than one Commercial Item Justification record.'));
                isCIJRecord = false;
            } else {
                isCIJRecord = true;
            }
         }
      }
    }
    public List < SelectOption > getRecTypeOptions() {

        opts = new List < SelectOption > ();
                   
        for (RecordType rt: rtList) {
            if (rt.name == 'OPRO CIJ' || rt.name == 'Transactional CIJ'){
                opts.add(new SelectOption(rt.id, rt.name));
            }
        }
        return opts;
    }
    
    public PageReference continueBtn() {
        PageReference pageRef;
        Schema.DescribeSObjectResult res = Commercial_Item_Justification__c.SObjectType.getDescribe();      
        String cseLineName=label.RDF_CLI_Name;
        String cseLineLkup=label.RDF_CLI_Name_Lkup;  
                
       /* if(accId != null && accName != '' && oproId != null && oproName != '' ){
            pageRef = new PageReference('/' + res.getKeyPrefix() + '/e?RecordType=' + recTypeId + '&CF00N2D000000Lcyh_lkid='+cliId + '&CF00N2D000000Lcyh='+cliName + '&CF00N1B00000BUxVk_lkid='+oproId + '&CF00N1B00000BUxVk='+oproName + '&CF00N1B00000BUxVZ_lkid=' +accId + '&CF00N1B00000BUxVZ='+accname );
        }
        else if(accId != null && accName != ''){
            pageRef = new PageReference('/' + res.getKeyPrefix() + '/e?RecordType=' + recTypeId + '&CF00N2D000000Lcyh_lkid='+cliId + '&CF00N2D000000Lcyh='+cliName +  '&CF00N1B00000BUxVZ_lkid=' +accId + '&CF00N1B00000BUxVZ='+accname );
        }
        else if(oproId != null && oproName != ''){
            pageRef = new PageReference('/' + res.getKeyPrefix() + '/e?RecordType=' + recTypeId + '&CF00N2D000000Lcyh_lkid='+cliId + '&CF00N2D000000Lcyh='+cliName + '&CF00N1B00000BUxVk_lkid='+oproId + '&CF00N1B00000BUxVk='+oproName );
        }*/
        if(accId != null && accName != '' && oproId != null && oproName != '' ){
            pageRef = new PageReference('/' + res.getKeyPrefix() + '/e?RecordType=' + recTypeId + cseLineLkup +cliId + cseLineName +cliName + '&CF00N1B00000BUxVk_lkid='+oproId + '&CF00N1B00000BUxVk='+oproName + '&CF00N1B00000BUxVZ_lkid=' +accId + '&CF00N1B00000BUxVZ='+accname );
        }
        else if(accId != null && accName != ''){
            pageRef = new PageReference('/' + res.getKeyPrefix() + '/e?RecordType=' + recTypeId + cseLineLkup +cliId + cseLineName +cliName +  '&CF00N1B00000BUxVZ_lkid=' +accId + '&CF00N1B00000BUxVZ='+accname );
        }
        else if(oproId != null && oproName != ''){
            pageRef = new PageReference('/' + res.getKeyPrefix() + '/e?RecordType=' + recTypeId + cseLineLkup +cliId + cseLineName +cliName + '&CF00N1B00000BUxVk_lkid='+oproId + '&CF00N1B00000BUxVk='+oproName );
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