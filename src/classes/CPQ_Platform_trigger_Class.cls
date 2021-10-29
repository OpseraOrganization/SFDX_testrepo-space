public class CPQ_Platform_trigger_Class {
    public static void Process_Order_Licence_Key_Linked(list<CPQ_Platform__c> newCPQs,Map<ID,CPQ_Platform__c> oldCPQs,list<product2> newProds,Map<ID,product2> oldProds){

        set<id> liids= new set<id>();
        
        if(newCPQs!=null){//From CPQ Trigger
            for(CPQ_Platform__c CPQp :newCPQs){
                if(oldCPQs==null){//for update
                    liids.add(CPQp.Order_Line_Item__c);
                }else if(oldCPQs.get(CPQp.id).License_Status__c != CPQp.License_Status__c){
                    liids.add(CPQp.Order_Line_Item__c);
                }  
            }
        }
        system.debug('liids'+liids);
       
        //Main logic
        set<id> oids=new set<id>();
        list<Apttus_Config2__OrderLineItem__c> updateolis= new list<Apttus_Config2__OrderLineItem__c>();
        for(Apttus_Config2__OrderLineItem__c olis :[select id,License_Required_and_Linked__c,Apttus_Config2__OrderId__r.Licence_Key_Linked__c,Apttus_Config2__OptionId__r.Is_License_Required__c,(select id,License_Status__c from CPQ_Platforms__r ) from Apttus_Config2__OrderLineItem__c where  id in:liids and Apttus_Config2__LineType__c!='Product/Service']){
                          
            boolean statusupdate=true;
            
            for(CPQ_Platform__c p:olis.CPQ_Platforms__r){
            
                 system.debug('Final updateolis=='+p);
               
                If(p.License_Status__c == 'Activation Key-Linked' && olis.Apttus_Config2__OptionId__r.Is_License_Required__c == True && olis.License_Required_and_Linked__c != 'Yes')
                {
                  olis.License_Required_and_Linked__c = 'Yes';
                   updateolis.add(olis); 
                  oids.add(olis.Apttus_Config2__OrderId__c);
                }
                else  if(olis.Apttus_Config2__OptionId__r.Is_License_Required__c = False )
                {
                  olis.License_Required_and_Linked__c = 'Not Applicable'; 
                   system.debug('Final updateolis=='+p);
                  updateolis.add(olis); 
                }
            }
            
        }
        if(updateolis.size()>0){ 
            system.debug('Final updateolis=='+updateolis);
            update updateolis;
        }
        
        List<Apttus_Config2__Order__c> updateords= new List<Apttus_Config2__Order__c>();
        Integer CountofNoStatus;
        Integer CountofYesStatus;
        
        system.debug('orderlineBefore =='+updateolis);
        for(Apttus_Config2__Order__c ord:[select id,Licence_Key_Linked__c,Count_of_License_Status_Yes__c,Count_of_License_Status_No__c, (select id,License_Required_and_Linked__c from Apttus_Config2__OrderLineItems__r where Apttus_Config2__LineType__c!='Product/Service') from Apttus_Config2__Order__c where id in:oids]){
           system.debug('orderlineAfter =='+ord);
            CountofNoStatus= 0;
            CountofYesStatus= 0;
           
            for(Apttus_Config2__OrderLineItem__c p : ord.Apttus_Config2__OrderLineItems__r){ 
                 
                
                if(p.License_Required_and_Linked__c =='Yes')
                {
                   CountofYesStatus  = CountofYesStatus + 1;
                    system.debug('CountofYesStatus =='+CountofYesStatus );
                }
                Else if(p.License_Required_and_Linked__c =='No')
                {
                   CountofNoStatus = CountofNoStatus + 1;
                   system.debug('CountofNoStatus =='+CountofNoStatus );
                } 
                
            }
            system.debug('CountofYesStatus1 =='+CountofYesStatus );
            system.debug('CountofNoStatus1 =='+CountofNoStatus );
            
            ord.Count_of_License_Status_Yes__c = CountofYesStatus;
            ord.Count_of_License_Status_No__c = CountofNoStatus;
            
            
            if(ord.Count_of_License_Status_Yes__c != 0 && ord.Count_of_License_Status_No__c == 0)
            {
               ord.Licence_Key_Linked__c = True; 
                updateords.Add(ord);
            }
        }
        system.debug('updateords =='+updateords);
        if(updateords.size()>0){
            update updateords;
        }
    }   
}