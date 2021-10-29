public class discardLightningController{
 /* ApexPages.StandardController controller;
    public discardLightningController(ApexPages.StandardController controller) {
            this.controller = controller;
    }*/
    public static String selectedCasesS {get; set;}
    public static List<Id> selectedCases{set;get;}
    Public Boolean PBFlag{get;set;}
    Public Boolean PBFFlag{get;set;}
    Public Boolean PBNFlag{get;set;}
    List<Id>selectedCaseIds = new List<Id>();
    ApexPages.StandardSetController setCon;
    
    public discardLightningController(ApexPages.StandardSetController controller)
    {
        setCon = controller; 
       List<Case> casess =  (Case[])setCon.getSelected();
      
       System.debug('selectedCases>>'+casess.size());
       System.debug('selectedCases>>'+casess.isEmpty()); 
        if(casess.isEmpty() || casess.size()<1){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please select at least one record to update.'));
        }else if (!casess.isEmpty() && casess.size() > 5)
        {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please select less than or equal to 5 records to update.'));
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Are you sure you want to Discard the below selected Cases?'));
        }
        PBFlag = false;
        PBNFlag = true;
        PBFFlag = true;
              
    }
    
  public PageReference selectCases(){
      PBNFlag = false;
      PBFFlag = false;
        set<Id>caseIds = new set<Id>();
        list<Case> casesToUpdate = new list<Case>();
      
       for ( Case c : (Case[])setCon.getSelected() )
        {
                selectedCaseIds.add(c.id);
                System.debug('CaseIdSelected = ' + c.Id);
        }
        if(!selectedCaseIds.isEmpty() && selectedCaseIds.size() > 0 && selectedCaseIds.size() < 5){
               
               List<Case> solno= [Select Id, Export_Compliance_Content_ITAR_EAR__c,Customer_PO_RO_WONumber__c, Government_Compliance_SM_M_Content__c, Supported_Products__c, ContactId , Type, Classification__c from Case where Id in :selectedCaseIds];
               Supported_Products__c sprod = [Select Id from Supported_Products__c where Name = 'Dummy' limit 1];
              
                   for(Case update_Case:solno){
                        
                        update_Case.Status = 'Discard';
                        //alert(solno[a].Export_Compliance_Content_ITAR_EAR__c);
                        if(update_Case.Export_Compliance_Content_ITAR_EAR__c == 'Undetermined') {
                            update_Case.Export_Compliance_Content_ITAR_EAR__c='NO';
                        }
                        //alert(solno[a].Government_Compliance_SM_M_Content__c);
                        if(update_Case.Government_Compliance_SM_M_Content__c == 'Undetermined') {
                            update_Case.Government_Compliance_SM_M_Content__c='NO';
                        }
                        if(update_Case.Supported_Products__c == null) {
                            System.debug('SP11>>>'+update_Case.Supported_Products__c == null);
                            if(null != sprod){
                                update_Case.Supported_Products__c = sprod.Id;
                            }
                        }

                        if( update_Case.ContactId == null) {
                        //Contact contId = [Select Id, Name from Contact where Name = 'No Contact Required' limit 1];
                        //var con = contId.getArray('records');
                        //update_Case.ContactId=con[0].Id;
                        }
                        //alert(solno[a].Type);
                        if(update_Case.Type == 'Invoice Disputes' && update_Case.Customer_PO_RO_WONumber__c == '' || update_Case.Customer_PO_RO_WONumber__c == null) {
                        update_Case.Customer_PO_RO_WONumber__c='12345';
                        }
                        //alert(solno[a].Classification__c);
                        if(update_Case.Classification__c == '' || update_Case.Classification__c == null) {
                        update_Case.Classification__c='Hand-Off NON-AERO';
                        }

                        casesToUpdate.add(update_Case);
                }
               if(casesToUpdate.size()>0){
                  try {
                   update casesToUpdate;
                      //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Records updated successfully'));
                     // PBFlag = true;
                  }catch(DmlException e) {
                              PBFlag = false;
                               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Valid Data')); 
                       }                   
               }
        }
      PageReference pageRef = new PageReference('/lightning/o/Case/list?filterName=Recent');

      return pageRef;
    }
}