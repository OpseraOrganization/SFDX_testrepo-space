/***********************************************************************************************

Name      :    AeroSFtoSAPOnInsertNdUpdate Class
Purpose   :    Case handler Class to trigger Callout 'AEROSfToSAPCallout'


History   :
------------------------------------------------------------------------------------------- 
VERSION         AUTHOR                          DATE             DETAIL 
1.0             TCS                         1/12/2019        

*******************************************************************************************/
public class AeroSFtoSAPOnInsertNdUpdate {
    
    public static void afterUpdateofFscm(List<Case> newCase, Map<Id,Case> oldMap){
        if(AEROSAPtoSF.triggerNotRunningFromAPI){
            Map<String,Invoices_for_fscmCase__c> invoicesMap = new Map<String,Invoices_for_fscmCase__c>([SELECT  FSCM_ID__c,Parent_Case__c From Invoices_for_fscmCase__c  where Parent_Case__c in :newCase]);
            Map<String,List<Invoices_for_fscmCase__c>> caseToInvoiceListMap = new Map<String,List<Invoices_for_fscmCase__c>>();
            Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.label.Invoice_FSCM_Disputes).getRecordTypeId();            
            for(Invoices_for_fscmCase__c invoice: invoicesMap.values()){
                if(!caseToInvoiceListMap.containsKey(invoice.Parent_Case__c)){
                    caseToInvoiceListMap.put(invoice.Parent_Case__c,new List<Invoices_for_fscmCase__c>());
                }
                caseToInvoiceListMap.get(invoice.Parent_Case__c).add(invoice);
            }
            for(Case cs : newCase) {
                list<Id> l_recordIdChanged = new list<Id>();
                list<String> l_FSCM_ID = new list<String>();
                list<Case>  updatedRecord= new list<case>();
                AeroCaseDataToSap abc= new AeroCaseDataToSap();
                System.debug('cs.OwnerId '+cs.OwnerId);
                System.debug('oldMap.get(cs.Id).OwnerId  '+oldMap.get(cs.Id).OwnerId );
                if(cs.RecordTypeId== devRecordTypeId && ((cs.OwnerId != oldMap.get(cs.Id).OwnerId )||(cs.Estimated_Resolution_Date__c != oldMap.get(cs.Id).Estimated_Resolution_Date__c )||(cs.status != oldMap.get(cs.iD).status && cs.status== 'Closed')||(cs.Notes__c !=  oldMap.get(cs.Id).Notes__c )||(cs.Resolution__c != oldMap.get(cs.Id).Resolution__c ))){
                    for(Invoices_for_fscmCase__c i :caseToInvoiceListMap.get(cs.Id)){
                        l_FSCM_ID.add(i.FSCM_ID__c);
                    }
                    string FscmId = string.Join(l_FSCM_ID,',');
                    abc.FSCMId = FscmId;
                    
                    if(cs.OwnerId != oldMap.get(cs.Id).OwnerId ) {
                      
                        abc.CaseOwner =Cs.OwnerName__c;
                        abc.Estimated_Resolution_Date = Null;
                        
                        
                        abc.CaseID = cs.CaseNumber;
                        abc.status = Null;
                        abc.Notes = null;
                        Map<String,Object> MapOfCaseWrap1 = new Map<String,Object>();
                        MapOfCaseWrap1.put('CaseResult',abc);
                        String json1 = JSON.serializePretty(MapOfCaseWrap1);
                        AEROSfToSAPCallout.PostDataToSAP(json1);
                        
                        
                    }
                    if(cs.Estimated_Resolution_Date__c != oldMap.get(cs.Id).Estimated_Resolution_Date__c ){
                        abc.Estimated_Resolution_Date = cs.Estimated_Resolution_Date__c;
                        
                        abc.CaseOwner = null;
                        
                        
                        abc.CaseID = cs.CaseNumber;
                        abc.status = Null;
                        abc.Notes = null;
                        Map<String,Object> MapOfCaseWrap2 = new Map<String,Object>();
                        MapOfCaseWrap2.put('CaseResult',abc);
                        String json2 = JSON.serializePretty(MapOfCaseWrap2);
                        AEROSfToSAPCallout.PostDataToSAP(json2);
                        
                    }
                    if(cs.status != oldMap.get(cs.iD).status && cs.status== 'Closed'){
                        abc.status= cs.status;
                        abc.CaseID = cs.CaseNumber;
                        abc.Estimated_Resolution_Date = Null;
                        abc.CaseOwner = null;
                        abc.Notes = null;
                        Map<String,Object> MapOfCaseWrap3 = new Map<String,Object>();
                        MapOfCaseWrap3.put('CaseResult',abc);
                        String json3 = JSON.serializePretty(MapOfCaseWrap3);
                        AEROSfToSAPCallout.PostDataToSAP(json3);
                        
                    }
                    if((cs.Notes__c !=  oldMap.get(cs.Id).Notes__c )&&(cs.Resolution__c != oldMap.get(cs.Id).Resolution__c )){
                        String Nt;
                        String ResolutionNote;
                        if(String.isNotBlank(oldMap.get(cs.Id).Notes__c)){
                            Nt= cs.Notes__c.remove( oldMap.get(cs.Id).Notes__c);
                            //abc.Notes= Nt;
                        }
                        else{
                            //abc.Notes=cs.Notes__c;
                            Nt= cs.Notes__c;
                        }
                        if(string.isNotBlank(oldMap.get(cs.Id).Resolution__c)){
                            ResolutionNote= cs.Resolution__c.remove( oldMap.get(cs.Id).Resolution__c);
                            //abc.Notes= ResolutionNote;
                        }
                        else{
                            ResolutionNote=cs.Resolution__c;
                            //abc.Notes=cs.Resolution__c;
                        }
                        abc.Notes= Nt+'\n'+ResolutionNote;
                        abc.Estimated_Resolution_Date = Null;
                        
                        abc.CaseOwner = null;
                        abc.CaseID = cs.CaseNumber;
                        abc.status = Null;
                        Map<String,Object> MapOfCaseWrap4 = new Map<String,Object>();
                        MapOfCaseWrap4.put('CaseResult',abc);
                        String json4 = JSON.serializePretty(MapOfCaseWrap4);
                        AEROSfToSAPCallout.PostDataToSAP(json4);
                    }
                    else if((cs.Notes__c !=  oldMap.get(cs.Id).Notes__c )||(cs.Resolution__c != oldMap.get(cs.Id).Resolution__c )){
                        if(cs.Notes__c !=  oldMap.get(cs.Id).Notes__c ){
                            if(String.isNotBlank(oldMap.get(cs.Id).Notes__c)){
                                String Nt= cs.Notes__c.remove( oldMap.get(cs.Id).Notes__c);
                                abc.Notes= Nt;
                            }
                            else{
                                abc.Notes=cs.Notes__c;
                            }
                            abc.Estimated_Resolution_Date = Null;
                            
                            abc.CaseOwner = null;
                            abc.CaseID = cs.CaseNumber;
                            abc.status = Null;
                            Map<String,Object> MapOfCaseWrap4 = new Map<String,Object>();
                            MapOfCaseWrap4.put('CaseResult',abc);
                            String json4 = JSON.serializePretty(MapOfCaseWrap4);
                            AEROSfToSAPCallout.PostDataToSAP(json4);
                        } 
                        if(cs.Resolution__c != oldMap.get(cs.Id).Resolution__c ){
                            if(string.isNotBlank(oldMap.get(cs.Id).Resolution__c)){
                                String ResolutionNote= cs.Resolution__c.remove( oldMap.get(cs.Id).Resolution__c);
                                abc.Notes= ResolutionNote;
                            }
                            else{
                                abc.Notes=cs.Resolution__c;
                            }
                            abc.Estimated_Resolution_Date = Null;
                            abc.CaseOwner = null;
                            abc.CaseID = cs.CaseNumber;
                            abc.status = Null;
                            Map<String,Object> MapOfCaseWrap5 = new Map<String,Object>();
                            MapOfCaseWrap5.put('CaseResult',abc);
                            String json5 = JSON.serializePretty(MapOfCaseWrap5);
                            
                            AEROSfToSAPCallout.PostDataToSAP(json5);
                            
                        }
                    }
                }
            }
            
        }
    }
}