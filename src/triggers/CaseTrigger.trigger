/**
* @author Luis Camacho
* @date 10/30/2017
*
* @description - Case trigger
*/
trigger CaseTrigger on Case (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
if(CaseServiceForCommonMethods.isEmailSent == false){
CaseServiceForCommonMethods.isEmailSent = false;
}else
CaseServiceForCommonMethods.isEmailSent = true;
System.debug('TEST ISEMAILSENT : '+ CaseServiceForCommonMethods.isEmailSent);
system.debug('Case-->'+trigger.new);
    if(userinfo.getProfileId() !=Label.API_Data_load_profile_Id){   
     If (TriggerInactive.testTrigger) //trigger should not be run for test classes: CaseServiceOnInsertTest,CaseServiceOnUpdateTest and CaseServiceforCommonmethodstest
      {    
       Id devRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('One-Off Discount').getRecordTypeId();
         Boolean skipTrigger = false;         
         if(trigger.new != null){
              for(case cas: trigger.new )
              {                
                  if (cas.recordtypeId ==  devRecordType){
                      skipTrigger = true;
                      break;
                  }
             }
         }
       if(!skipTrigger){    
      
        CaseHandler handler = new CaseHandler(Trigger.isExecuting, Trigger.size);
        //Profile check added from MainCaseTrigger
        string profileId = userinfo.getProfileId();
        string customLabel = Label.Data_Loading_Profile;
        if(profileId.substring(0,profileId.length()-3) != customLabel){ 
            if(Trigger.isInsert && Trigger.isBefore){           
                handler.OnBeforeInsert(Trigger.new);
                }        
            else if(Trigger.isInsert && Trigger.isAfter){ 
                if(TriggerInactive.avoidRecursionCaseInsert){ 
                   TriggerInactive.avoidRecursionCaseInsert= false;             
                    handler.OnAfterInsert(Trigger.new); 
                  }                
                }
            else if(Trigger.isUpdate && Trigger.isBefore){
                //if(TriggerInactive.avoidRecursionCaseBeforeUpdate){ 
                    //TriggerInactive.avoidRecursionCaseBeforeUpdate = false;            
                    handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap,Trigger.oldMap);
               // }
            }
            else if(Trigger.isUpdate && Trigger.isAfter){  
                if(TriggerInactive.avoidRecursionCaseUpdate){ 
                    system.debug('@@insidetrigger');
                    TriggerInactive.avoidRecursionCaseUpdate = false;        
                    handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap,Trigger.oldMap);
                    }           
                }
        }
      } 
       else{
            CaseHandler handler = new CaseHandler(Trigger.isExecuting, Trigger.size);
            //Profile check added from MainCaseTrigger
            string profileId = userinfo.getProfileId();
            system.debug('@@@@profileId'+profileId );
            string customLabel = Label.Data_Loading_Profile;
            if(profileId.substring(0,profileId.length()-3) != customLabel){ 
                if(Trigger.isInsert && Trigger.isBefore){           
                    handler.onBeforeInsert_OneOffCase(Trigger.new);
                }
             }
         }   
      /* 
       If survey is already submitted(i.e feedback record is already created) and after that user submits the form(to create case) then 
       case Id should get updated in feedback record. TechPubFeedbackUpdate method will be called
      */
      if(Trigger.IsInsert && Trigger.isAfter){
          Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Tech Pubs').getRecordTypeId();
          List<case> casLst = new List<case>();
          TechPubFeedbackUpdate tbp = new TechPubFeedbackUpdate(); 
          for(case cas: trigger.new){
              if (cas.recordtypeId ==  devRecordTypeId){
                  casLst.add(cas) ;
              }        
          }
          if(casLst != null && !casLst.isEmpty() ){
              tbp.TechPubFeedbackUpdate(casLst); 
          }   
      }
      
    if(Trigger.IsInsert && Trigger.isBefore){
        ordersCase ordC = new ordersCase();
        Boolean goTrigger = false;
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Orders').getRecordTypeId();
        for(case cas: trigger.new){
        system.debug('******cas'+ cas);
        system.debug('******devRecordTypeId '+ devRecordTypeId );
            if(cas.subject == 'Webform;Place an Order; RFQ' && cas.recordtypeId ==  devRecordTypeId ){
                goTrigger = true;
                break;   
            } 
        }
    
        if(goTrigger ){
            ordC.updateCaseNumber(trigger.new, devRecordTypeId );    
        } 
    }
      
     }  
     }   
}