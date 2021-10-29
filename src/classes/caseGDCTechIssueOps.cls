/****************************************Log****************************
SR#405714
Test class - caseGDCTechIssueOpsTest
************************************************************************/

public class caseGDCTechIssueOps{

    // Update the Due Date when case is created - Step1
    public static void updateDueDateonInsert(List<Case> newCases){
        for(Case newCase : newCases){
            if(newCase.Case_Record_Type__c =='GDC Tech Issue' && newCase.status=='New'){
                system.debug('newCase.Priority------>' + newCase.Priority);
                if(newCase.Priority == 'Low' || newCase.Priority == 'Normal' || newCase.Priority == 'High'){
                    //DateTime dt = newCase.CreatedDate;
                    //newCase.Due_Date__c = date.newinstance(dT.year(), dT.month(), dT.day()) + 1;
                    newCase.Due_Date__c = system.today().adddays(1);
                    system.debug('newCase.Due_Date__c------>' + newCase.Due_Date__c);
                }else{
                    newCase.Due_Date__c = system.today();
                }
            }
            
        }
    }
    
    // Update the Due Date when status is chnaged to 'Assigned' - Step2,then to 'Open' Step3, then to 'Fixed' Step4
    public static void updateDueDateAfterAssigned(List<Case> newCases,Map<id,Case> oldCases){
        for(Case newCase : newCases){
            if(newCase.Case_Record_Type__c =='GDC Tech Issue' && newCase.status=='Assigned' && newCase.status != oldCases.get(newCase.id).status){
                if(newCase.Priority == 'Low'){
                    DateTime dt = system.now();
                    newCase.Due_Date__c = date.newinstance(dT.year(), dT.month(), dT.day()).adddays(3);
                }else
                if(newCase.Priority == 'Normal'){
                    DateTime dt = system.now();
                    newCase.Due_Date__c = date.newinstance(dT.year(), dT.month(), dT.day()).adddays(2);
                }else
                if(newCase.Priority == 'High'){
                    DateTime dt = system.now();
                    newCase.Due_Date__c = date.newinstance(dT.year(), dT.month(), dT.day()).adddays(1);
                }else{
                    newCase.Due_Date__c = system.today();
                }
            }else if(newCase.Case_Record_Type__c =='GDC Tech Issue' && newCase.status=='Open' && newCase.status != oldCases.get(newCase.id).status){
                newCase.DateSetForOpen__c = system.now();
                if(newCase.Priority == 'Low'){
                    DateTime dt = system.now();
                    newCase.Due_Date__c = date.newinstance(dT.year(), dT.month(), dT.day()).adddays(20);
                }else
                if(newCase.Priority == 'Normal'){
                    DateTime dt = system.now();
                    newCase.Due_Date__c = date.newinstance(dT.year(), dT.month(), dT.day()).adddays(15);
                }else
                if(newCase.Priority == 'High'){
                    DateTime dt = system.now();
                    newCase.Due_Date__c = date.newinstance(dT.year(), dT.month(), dT.day()).adddays(8);
                }else{
                    newCase.Due_Date__c = system.today();
                }
            }else if(newCase.Case_Record_Type__c =='GDC Tech Issue' && newCase.status=='Fixed' && newCase.status != oldCases.get(newCase.id).status){
                newCase.Due_Date__c = system.today();
            }
        }
    }
}