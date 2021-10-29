trigger SatcomProbabilityChange on Opportunity (before insert, before update) {
    try{
        
     for(Opportunity oppty : Trigger.new){
        if(oppty.Satcom_Direct_Customer__c=='Yes' ){
            
            oppty.probability=0.00;
        }
    }
    }
     catch(Exception e) {
        /*utilClass.createErrorLog
         (
         'SatcomProbabilityChange',
         'SatcomProbabilityChange',
         'errLoc - ' + errLoc + ' - '  + e.getMessage()
         );   */                                 
        
    }
}