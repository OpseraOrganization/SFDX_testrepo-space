public class DevelopmentactionEditableGrid {
    Map<id,Account> updateAccounts;
    Map<id,Development_Action__c> updateDevAction;
    List<accWrapper> accounts;
    List<accWrapper> SalesCompetencies;
    public String saveId{get;set;}
    public String strSCId{get;set;}
    public Boolean refreshPage {get; set;}
    public Boolean savecalled= false;
    //public Boolean refreshPage {get; set;}
    //public id OpportunityId{get; set;}
    
    public Sales_Competency__c SC;
    private ApexPages.StandardController controller;
    
    Public DevelopmentactionEditableGrid(ApexPages.StandardController Controller)
    {
    this.controller=controller; 
    SC=(Sales_Competency__c)controller.getRecord();
    //OpportunityId=opp.id;
    refreshPage=false;
     }
    
       public List<accWrapper> getSalesCompetencies() {
        if(SalesCompetencies == null || savecalled==true)
        {
            SalesCompetencies=new List<accWrapper>();
            updateDevAction = new Map<id,Development_Action__c>([select id,name,Competency__c,Action_Steps__c,Actual_Completion_Date__c,Target_Completion_Date__c,Requires_Follow_up__c,Follow_Up_Date__c,Action_Accepted__c,Comments__c from Development_Action__c Where Sales_Competency_Assessment__c =: SC.Id order by Name]);
            
            for(Development_Action__c a : updateDevAction.values())
                {
                 SalesCompetencies.add(new accWrapper(a.id, a));
                }
             savecalled= false;
        }
        return SalesCompetencies;
    }
    
        public class accWrapper {
        public string id{get;set;}
        public Development_Action__c DA{get;set;}
        public Boolean edit{get;set;}
                
        accWrapper(String id, Development_Action__c DA)
        {
            this.id=id;
            this.DA=DA;
            this.edit=False;
        }
    }
    
    public void saveRecord()
    {
        Development_Action__c DA;            
            try
            {
            String ErrorMessage='';
            
            DA = updateDevAction.get(saveId);
            update DA;
            
            savecalled= true;  
            refreshPage=true;
            }          
            catch(DMLException ex){
            savecalled= true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getDmlMessage(0)));
            //DA.Requires_Follow_up__c.adderror(ex);
           }
      }
      
public Void cancel()
    { }
   
    }