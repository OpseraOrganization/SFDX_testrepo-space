global class PPO_SAPtoSFDCCasCloseStatus{
   
    global class CaseDataSFDCtoSAP{
        webservice string caseNumber;        
        webservice string message;
       }  
    webservice static SAPtoSFDCServiceclass.CaseDataSFDCtoSAP  closeCase(SAPtoSFDCServiceclass.RnO_CASE_cls cs){
        String casnum = cs.CASENUMBER;
        String SONum = cs.SALES_ORDER_NUMBER;        
        Boolean isUpdated = false; 
        Boolean isNonpayment=false;
        /* Added for RAPD - 3343 */
               string truncateIP = '';
        truncateIP = string.valueOf(cs);
         if(truncateIP.length() > 131072){
        truncateIP = truncateIP.subString(0,131072);
        }
         SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput();   
        /* Ended */
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP cse = new SAPtoSFDCServiceclass.CaseDataSFDCtoSAP();
        
        //CasecloseSAP cse=new CasecloseSAP();
        Case cas = new Case();
        List<Case> casList = new List<Case>();
       
            if((casnum!=null && casnum!='') && (SONum!=null && SONum!='')){
                system.debug('------->inside');
                try{
                    cas = [SELECT id,Origin,RecordTypeId,Description,CaseNumber,Sales_Order_Number__c,Quote_Number__c,Status,Type,OwnerId,Resolution__c from Case where CaseNumber=:casnum and Sales_Order_Number__c=:SONum];
                    system.debug('------->inside'+cas);
                }catch(Exception e){
                    system.debug('No matches found for the given Case Number '+e.getMessage());
                    SApInterface.sapException=e.getMessage();
                     SApInterface.Name = 'PPO_SAPtoSFDCCasCloseStatus';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                     //To maintain case number consistency adding CASE
                         SApInterface.caseNumber = 'CASE- '+casnum;
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                }
            }
        
        if(cas!=null){
            
            system.debug('casenumber:'+cas.Casenumber);

            if(cas.Origin == 'web' && cas.RecordtypeId == Label.OEM_Spares )
            {
                          
                system.debug('@@@casenumber:'+cas.Casenumber);
                if(cs.RESOLUTION=='Cancelled due to non-payment')
                {
                    system.debug('Cancelled due to non-payment');
                    cas.OwnerId = Userinfo.getUserId();
                    cas.Resolution__c=cs.RESOLUTION;
                    cas.Status ='Closed'; 
                    cas.Description='Cancelled due to non-payment';                  
                    casList.add(cas);
                    isNonpayment=true;
                    system.debug('&&&&&&isNonpayment'+isNonpayment);
                    system.debug('&&&&&&cancelled'+casList);
                }
                else if(cs.RESOLUTION=='No Payment made 3-day')
                {
                    System.debug('No payment made 3-day');
                    cas.Resolution__c=cs.RESOLUTION;
                    casList.add(cas);
                    isNonpayment=true;
                    system.debug('isNonpayment'+isNonpayment);
                    system.debug('$$$$$$3day'+casList);
                }
                else if(cs.RESOLUTION=='No Payment made 6-day')
                {
                    System.debug('No payment made 3-day');
                    cas.Resolution__c=cs.RESOLUTION;
                    casList.add(cas);
                    isNonpayment=true;
                    system.debug('isNonpayment'+isNonpayment);
                    system.debug('$$$$$$6day'+casList);
                }
                else if(cs.RESOLUTION=='Down payment received')
                {
                    system.debug('&##$%');
                    cas.OwnerId = Userinfo.getUserId();
                    cas.Resolution__c=cs.RESOLUTION;
                    cas.Status ='Closed'; 
                    cas.Description='Down payment received';
                    casList.add(cas);
                    system.debug('&##cancelled'+casList);
                }
             /* else if(cs.RESOLUTION=='Partial payment received')
                {
                    system.debug('&##partial');
                    cas.Status = cs.STATUS;
                    cas.Resolution__c=cs.RESOLUTION;
                    cas.OwnerId = Label.CSO_OEM_Spares;
                    cas.Description='10 days has past and only partial payment received from customer - Please contact customer for further action';
                    casList.add(cas);
                }*/
            
          else{
                    system.debug('Case Resolution ');
               /* Added for RAPD - 3343 */
                    SApInterface.sapException='Check Case resolution';
                     SApInterface.Name = 'PPO_SAPtoSFDCCasCloseStatus';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                         //To maintain case number consistency adding CASE
                         SApInterface.caseNumber = 'CASE- '+casnum;
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
              /* Ended */
            }
            
            
            }
            else{
                system.debug('Case Origin ');
                 /* Added for RAPD - 3343 */
                    SApInterface.sapException='Case Origin should be Web and record type should be OEM Spares';
                     SApInterface.Name = 'PPO_SAPtoSFDCCasCloseStatus';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                         //To maintain case number consistency adding CASE
                         SApInterface.caseNumber = 'CASE- '+casnum;
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                /* Ended */
            }
        
            
            if(cas.RecordtypeId==Label.Repair_Overhaul_RT_ID && cs.RESOLUTION=='Down payment received')
            {
                system.debug('&##$% Repair and Overhaul');
                cas.OwnerId = Userinfo.getUserId();
                cas.Resolution__c=cs.RESOLUTION;
                cas.Status ='Closed'; 
                cas.Description='Down payment received';
                casList.add(cas);
                system.debug('&##closed'+casList);
            }
                
        
        }  
       
        if(casList.size()>0){
            try{
                system.debug('%%%%%%%%'+casList);                
                update casList;  
                isUpdated=true;              
            }catch(DMLException ee){
                 /* Added for RAPD - 3343 */
                system.debug('PPO Error updating Case '+ee.getMessage());
                 SApInterface.sapException=ee.getMessage();
                     SApInterface.Name = 'PPO_SAPtoSFDCCasCloseStatus';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                         //To maintain case number consistency adding CASE
                         SApInterface.caseNumber = 'CASE- '+casnum;
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                /* Ended */
                
            } 
        }
        if(isUpdated==true)
        {
        system.debug('%%$#IS');
             if(isNonpayment==true)
            {
                System.debug('#$@');
                PPO_CasecloseEMail.EmailSend(cas.id,cs.RESOLUTION);
            }
            cse.caseNumber=cas.CaseNumber;
            cse.message='Case Updated Successfully';
        }
        else{
            cse.caseNumber=cas.CaseNumber;
            cse.message='Case Update Failed';
             /* Added for RAPD - 3343 */
           SApInterface.sapException= cse.message;
                     SApInterface.Name = 'PPO_SAPtoSFDCCasCloseStatus';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                         //To maintain case number consistency adding CASE
                         SApInterface.caseNumber = 'CASE- '+casnum;
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
            /* Ended */
        }
            return cse;
        
    }    
}