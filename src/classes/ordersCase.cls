public class ordersCase{

    string caseNum = '';
    string partNum = '';
    List<case> caseList = new List<case>(); 
    public void updateCaseNumber(List<case> newCase, Id devRecordTypeId ){
    
        for(Case cas : newCase){
         system.debug('cas.DESCRIPTION' +cas.DESCRIPTION);
            if(cas.subject == 'Webform;Place an Order; RFQ' && cas.recordtypeId ==  devRecordTypeId && cas.DESCRIPTION !='' ){
            system.debug('******inside');
                for(string description : cas.DESCRIPTION.split('\n')){
                system.debug('******description'+ description);
                    if(description.contains('Quote Case Number')){
                    
                        caseNum = description.split(':',2)[1]; 
                        system.debug('******caseNum '+caseNum );
                    }
                    if(description.contains('Part/Product #')){
                    
                        partNum = description.split(':',2)[1]; 
                        system.debug('******partNum '+partNum );
                    }                
                }    
            } 
        
        }
        
        if(caseNum != null && caseNum != ''){
    
                caseNum = caseNum.trim();
                caseList = [select Id from case where caseNumber=:caseNum ];
                system.debug('***caseList' + caseList );
       }
       
       for(Case cs : newCase){
           if(caseList.size() > 0){
        
               cs.ParentId = caseList[0].id;
           }
           if(partNum != null && partNum != ''){
               partNum = partNum.trim(); 
               cs.Part_Number__c = partNum; 
           }
            
        }        
        
    } 


}