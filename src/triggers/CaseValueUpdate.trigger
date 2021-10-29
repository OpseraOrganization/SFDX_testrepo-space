/************* Trigger to update the Case Recordtype, Type, 
Repair Location and Classification based on the owner update *********/

trigger CaseValueUpdate on Case (Before Update) {
   /*commenting inactive trigger code to improve code coverage-----
    List<ID> caseownerlst = new List<ID>();
    List<Case> caselst = new List<Case>();
    List<Case_Matrix__c> casematrixlst = new List<Case_Matrix__c>();
    //Modifided By Praveen for Ticket No:362992
    //*******************starts here
    
        Schema.DescribeSObjectResult result = group.sObjectType.getDescribe();
        String key= result.getKeyPrefix();
        String dsorder= System.Label.D_S_Order;
        string QuotesTeamId=System.Label.D_S_PR_Quotes_Team;
        String ClearinghouseId=System.Label.D_S_Clearing_House;
        String dsclearhouse=System.Label.D_S_Clear_House_RecordTypeId_Case;
        
    //************************ends Here
    
    for(Case cas : trigger.new){
        if(System.Trigger.OldMap.get(cas.Id).OwnerId != System.Trigger.NewMap.get(cas.Id).OwnerId){
            if((System.Trigger.NewMap.get(cas.Id).OwnerId == label.R_O_Basingstoke_Quotes_Queue_ID) || 
               (System.Trigger.NewMap.get(cas.Id).OwnerId == label.R_O_Basingstoke_Order_Entry_Queue_ID) ||
               (System.Trigger.NewMap.get(cas.Id).OwnerId == label.R_O_Basingstoke_Shipping_Invoicing_Queue_ID) ||
               (System.Trigger.NewMap.get(cas.Id).OwnerId == label.R_O_Basingstoke_Customer_Services_Queue_ID) ||
               (System.Trigger.NewMap.get(cas.Id).OwnerId == label.R_O_UKSC_Faxes_Queue_ID) ||
               (System.Trigger.NewMap.get(cas.Id).OwnerId == label.R_O_Basingstoke_Tranship_Queue_ID) ||
               (System.Trigger.NewMap.get(cas.Id).OwnerId == label.R_O_Bournemouth_Customer_Service_Prague_Queue_ID) ||
               (System.Trigger.NewMap.get(cas.Id).OwnerId == label.R_O_Bournemouth_Quotes_Queue_ID) ||
               (System.Trigger.NewMap.get(cas.Id).OwnerId == label.R_O_Bournemouth_Customer_Service_BMTH_Queue_ID) ||
               (System.Trigger.NewMap.get(cas.Id).OwnerId == label.R_O_Toulouse_Order_Entry_Queue_ID) ||
               (System.Trigger.NewMap.get(cas.Id).OwnerId == label.R_O_Toulouse_Quotes_Queue_ID) ||
               (System.Trigger.NewMap.get(cas.Id).OwnerId == label.R_O_Toulouse_Shipping_Invoicing_Queue_ID) ||
               (System.Trigger.NewMap.get(cas.Id).OwnerId == label.R_O_Toulouse_Customer_Service) ||
               (System.Trigger.NewMap.get(cas.Id).OwnerId == label.R_O_Raunheim_Quotes_Queue_ID) ||
               (System.Trigger.NewMap.get(cas.Id).OwnerId == label.R_O_Raunheim_Order_Entry_Queue_ID) ||
               (System.Trigger.NewMap.get(cas.Id).OwnerId == label.R_O_Raunheim_Shipping_Invoicing_Queue_ID) ||
               (System.Trigger.NewMap.get(cas.Id).OwnerId == label.R_O_Raunheim_Customer_Services_Queue_ID) ||
               (System.Trigger.NewMap.get(cas.Id).OwnerId == label.R_O_Vendome_Order_Entry_Queue_ID)
            ){
                caseownerlst.add(cas.ownerid);
                caselst.add(cas);
                system.debug('CASEOWNERLIST : '+caseownerlst);
                system.debug('CASEIDLIST : '+caselst);
            }
        }
        
        
        //Modifided By Praveen for Ticket No:362992
        //*******************starts here
        
        String caseowner=cas.ownerId;
        String key2=caseowner.substring(0,3);
        if(Trigger.isupdate)
        {
           
            if(key==key2 && trigger.oldmap.get(cas.id).ownerId!=cas.ownerid && 
                cas.ownerId==ClearinghouseId && 
                trigger.oldmap.get(cas.id).ownerId==QuotesTeamId)
            {
                cas.RecordTypeId=dsclearhouse;
                cas.status='New';
                cas.Contractor_Status__c='Subcontractor';
                cas.Platform__c=label.Multiple_Military_Aircraft_Applications;
                cas.Opportunity_Type__c='Catalog';
                //cas.ownnerId=ClearinghouseId;
            }
            else if(key==key2 && trigger.oldmap.get(cas.id).ownerId!=cas.ownerid  && 
                trigger.oldmap.get(cas.id).ownerId==ClearinghouseId &&
                 cas.ownerId==QuotesTeamId)
            {
                cas.RecordTypeId=dsorder;
                cas.status='New';
                cas.Classification__c='CSO D&S Internal';
                cas.Type='Quotes/Availability';
                cas.Sub_Class__c='';
                cas.Detail_Class__c='';
                //cas.ownnerId=QuotesTeamId;
            }

        }
        //************************ends Here

    }
    
    Map<ID,Case_Matrix__c> casematrix = new Map<ID,Case_Matrix__c>(); 
    
    List<Case_Matrix__c> CaseMatrixList = new List<Case_Matrix__c>([select RecordTypeId__c,repair_location__c,Name,Classification__c, DetailClass__c,Owner__c,OwnerId__c,Record_Type__c,SubClass__c,Type__c from Case_Matrix__c where OwnerId__c in : caseownerlst]);
    if(CaseMatrixList.size()>0){
        for(Case_Matrix__c cm : CaseMatrixList){
            casematrix.put(cm.OwnerId__c,cm);
        }
 //   system.debug('WWWWWWW'+casematrix);
    }
    
    if(caselst.size()>0){
        for(Case cas : caselst){
            if(casematrix.size()>0){
                SYSTEM.debug('..............................');
                String recrdtypid = casematrix.get(cas.ownerid).RecordTypeId__c;
            //    system.debug('ZZZZZZZZZZZZ'+recrdtypid);
                cas.RecordtypeId = casematrix.get(cas.ownerid).RecordTypeId__c;
                cas.Type = casematrix.get(cas.ownerid).Type__c;
                cas.Repair_Location__c = casematrix.get(cas.ownerid).Repair_Location__c;
                cas.Classification__c = 'CSO Repair/Overhaul';
                if(cas.Repair_Location__c.contains('Vendome')){
                    cas.Repair_Location__c = 'Vendome';
                }
            }
      /*  system.debug('QQQQQQQ'+cas.RecordtypeId);
        system.debug('FFFFFFF'+cas.Type);
        system.debug('VVVVVVV'+cas.Repair_Location__c);
        system.debug('TTTTTTT'+cas.Classification__c);
        }    
    }*/
       
    
}