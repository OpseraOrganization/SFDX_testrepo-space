public class SAPContractFlowdownEmailController {
 public String Casid{ get; set; }
    public string Contrid;
    public list<Performing_Site__c> perfms{
        public get {
            if(Casid!= null){
            perfms = new list<Performing_Site__c>();
            Case cs =[Select id, Serv_Contract__c from Case where id=: Casid];
            if((cs.Serv_Contract__c)!= null){
            perfms = [Select Plant_Code_Master__r.name, Plant_Code__c, Sales_Office__c, Type__c, SAP_Contract_Number__c, SAP_Contract_Type__c, Sold_To__c, Other__c from Performing_Site__c where Contract_Number__r.id = :cs.Serv_Contract__c];
            }
            }
        System.debug('perfms'+perfms);
        return perfms;
        }
        public set;}
   }