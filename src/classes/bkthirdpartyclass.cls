public class bkthirdpartyclass {
    public Case cas{get;set;}
    //public String selectedAccName { get; set; }
    public bkthirdpartyclass(ApexPages.StandardController controller) {
                this.cas= (Case)controller.getRecord();
                cas = new Case();
                //selectedAccName = '';                 
    }
Public PageReference savecase(){
            PageReference pageRef;
            List <Case> c;
            Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('BK Third Party Tech Issue').getRecordTypeId();
            cas.RecordtypeId = devRecordTypeId;
            cas.Origin='Web';
            //cas.CSM_Category__c = selectedAccName;
            //insert cas;
            
            Database.insert(cas, false);
            
            
          c = [select Id,CaseNumber,Description,Case_Ref_ID__c from Case where id=:cas.id LIMIT 1];
            System.debug('CaseNumber: '+cas.CaseNumber);
            if(c.size()>0) {
                for(Case c1: c){
                    system.debug('Case i class:'+c1);
                    pageRef = new PageReference('/apex/casesubmitBkthirdparty?casenumber='+c1.CaseNumber);
                    pageRef.setRedirect(true);
                }
            }    
            return pageRef; 
    }    
    public pagereference cancelform(){
        PageReference pageRef = new PageReference('/apex/BKThirdPartyTecIssueform');
        pageRef.setRedirect(true);
        return pageRef;
    }
    

}