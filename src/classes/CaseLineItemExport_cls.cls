/*
Created By : Vinod T
Created Date : March-26-2018
Usages : To Exoport Case Line Item object records which is in Case Related list       
*/
public with sharing class CaseLineItemExport_cls {
    
    public List<Case_Line_Item__c> voc{get; set;}
    list<Case_Line_Item__c> voclist;
    list<case> lstcs {get;set;}
    public string CaseNo{get;set;}
    id pgid;
    public CaseLineItemExport_cls() {
        system.debug('=======');
        pgid = ApexPages.currentPage().getParameters().get('id');
        lstcs = [select Id,CaseNumber,(Select id,Name,Product_Number__c,Part_Number__c,Product_Description1__c,CDA_Cage_Code1__c,Site1__c,D_S_Last_Sale_Entered1__c,SAP_Platform1__c,Product_Line_PAC1__c,Product_Line__c,Product_Line_Family1__c,Product_Number__r.Name from Case_Line_Items__r) from case where id =:pgid];
        voc = new List<Case_Line_Item__c>();
        for(case c : lstcs){
            CaseNo = c.CaseNumber;
            for (Case_Line_Item__c vc : c.Case_Line_Items__r) {       
                voc.add(vc);
            }
        }
     }
    
}