public class QFDFieldsAutoPopulation 
{
    public static void populateQFDFieldsData( List<Service_Request__c> newRecList, Boolean isBeforeExecute, Boolean isAfterExecute )
    { 
       Set<Id> SerReqID = new Set<Id> ();
       List<Service_Request__c> SRList = new List <Service_Request__c> ();
        
        for(Service_Request__c serRec : newRecList ){
           SerReqID.add(serRec.Id);
        }

        system.debug('SerReqID=========>'+SerReqID);
        
        if(SerReqID.size() > 0 && isAfterExecute) 
        {
            SRList = [Select id, Atr__c, QFD_Entry_Logic__c,Legacy_Siebel_Account_Id__c,Count_Of_SRD_Supported__c , QFD_Entry_Logic_History__c, Criteria_Score__c, CUS_IFSD_21_3_FMS__c, X1st_18Mth_EIS__c,Previous_Inv__c,Override__c,
                      Financial_12mth__c,Cust_Impact__c,Reliability__c,Prod_Maturity__c,Previous_Inv_Score__c,Aircraft_Type__r.SRD_Supported__c, Investigate__c, CreatedDate, Date_Initiated__c, Customer_Due_Date__c,Date_Closed__c,sr_owner__c, Status__c,
                      Problem_Description__c, Deliverable__c, Status_Resolution__c,RecordType.Name,Platforms_Affected__c from Service_Request__c where ID IN : SerReqID  AND (RecordType.Name='Service Request' OR RecordType.Name ='SR(General)')];           
           
        }
        if(isBeforeExecute && !isAfterExecute)        
        {
          System.debug('Inside of Before Upadte');
          QFDFieldsAutoPopulation.formulateQFDData(newRecList, isBeforeExecute, isAfterExecute);
        }
        if(!isBeforeExecute && isAfterExecute)
        {
          System.debug('Inside of After Insert');
          QFDFieldsAutoPopulation.formulateQFDData(SRList, isBeforeExecute, isAfterExecute);
        } 
    }
    
    public static void formulateQFDData(List<Service_Request__c> newRecList,Boolean isBeforeExecute, Boolean isAfterExecute)
    {
    
      // QFD fields population code
        Map<ID, Service_Request__c> SRMap = new Map <ID, Service_Request__c> ();        
        Integer cutOffScore = Integer.valueOf(Label.RDF_QFD_Cutoff_Score);
        List<Service_Request__c> UpdateQFDList = new List<Service_Request__c> ();
        String OverideString = '';
        String QFDEntryLogic = '';
    
       for(Service_Request__c SR : newRecList) 
            {
                System.debug('Inside of QFD Fields');                
                Service_Request__c srObj = new Service_Request__c ();
                String CriteriaScore = String.ValueOf(SR.Criteria_Score__c);
                system.debug('CriteriaScore ====>'+CriteriaScore );
                Boolean isNegValue = false;                                
                 system.debug('SR.Platforms_Affected__c' + SR.Platforms_Affected__c);
                if((SR.CUS_IFSD_21_3_FMS__c == null || SR.Previous_Inv__c == null|| SR.Financial_12mth__c == null
                  || SR.Cust_Impact__c == null || SR.Reliability__c == null || SR.Prod_Maturity__c == null || SR.X1st_18Mth_EIS__c == null) 
                  || (SR.Platforms_Affected__c==null && SR.RecordTypeId==Schema.sobjecttype.Service_request__c.getRecordtypeInfosbyname().get('SR(General)').getRecordtypeId()) )
                {
                  system.debug('inside of null' );
                  SR.QFD_Entry_Logic__c = '';
                 if(!isBeforeExecute)
                  UpdateQFDList.add(SR);
                }
                else 
                {                 
                    if(String.isNotBlank(CriteriaScore))
                         isNegValue = CriteriaScore.contains('-');
                      
                      system.debug('inside of else' );
                      
                    If(SR.Criteria_Score__c != null )
                     {
                       if(CriteriaScore.length() == 2 && isNegValue )
                       {
                          QFDEntryLogic = '-00'+CriteriaScore.substring(1,2);                      
                       }
                       else if(CriteriaScore.length() == 3 && isNegValue )
                       {
                            QFDEntryLogic = '-0'+CriteriaScore.substring(1,3);                      
                       }
                       else if(CriteriaScore.length() == 1 && !isNegValue )
                       {                   
                           QFDEntryLogic = '00'+CriteriaScore;                     
                       }
                       else if(CriteriaScore.length() == 2 && !isNegValue )
                       {
                          QFDEntryLogic = '0'+CriteriaScore;                      
                       }                   
                       else
                       {
                         QFDEntryLogic = CriteriaScore;                         
                       }
                    }
                    If(!String.isEmpty(QFDEntryLogic))
                     {
                        System.debug('Inside of QFDEntryLogic');
    
                        If(SR.CUS_IFSD_21_3_FMS__c != null && SR.CUS_IFSD_21_3_FMS__c == 'Yes') 
                        {
                            QFDEntryLogic = QFDEntryLogic + ', ' + 'IFSD,FMS,PVA';
                        }
                        else if (SR.X1st_18Mth_EIS__c != null && SR.X1st_18Mth_EIS__c == 'Yes') 
                        {
                            QFDEntryLogic = QFDEntryLogic + ', ' + 'EIS';
                        } 
                        else if (SR.Previous_Inv_Score__c != null && SR.Previous_Inv_Score__c < 0)
                        {
                            QFDEntryLogic = QFDEntryLogic + ', ' + 'Previous';
                        } 
                        else if (SR.Count_Of_SRD_Supported__c  == 0)
                        {
                            QFDEntryLogic = QFDEntryLogic + ', ' + 'Platform';
                        } 
                        else if (SR.Criteria_Score__c != null && SR.Criteria_Score__c < cutOffScore) 
                        {
                            QFDEntryLogic = QFDEntryLogic + ', ' + 'Below 40';
                        } 
                        else
                        {
                            QFDEntryLogic = QFDEntryLogic + ', ' + 'Above';
                        }
    
                        if (SR.Investigate__c != null && SR.Investigate__c != '' && SR.Investigate__c == 'NO') {
                            QFDEntryLogic = QFDEntryLogic + ', ' + 'Rejected';
                        } 
                        else 
                        {
                            QFDEntryLogic = QFDEntryLogic;
                        } 
                        // Queue Priority# value Assigmment 
                        if(String.isBlank(SR.Legacy_Siebel_Account_Id__c))
                        {
                            SR.Legacy_Siebel_Account_Id__c = QFDEntryLogic;
                        }
                        else if(String.isNotBlank(SR.Legacy_Siebel_Account_Id__c) && SR.Legacy_Siebel_Account_Id__c.contains('Override') && SR.Override__c == false)
                        {
                             SR.Legacy_Siebel_Account_Id__c = QFDEntryLogic.replace('Override','Rejected') ;                              
                        }
                        else if(String.isNotBlank(SR.Legacy_Siebel_Account_Id__c) && SR.Legacy_Siebel_Account_Id__c.contains('Rejected') && SR.Override__c == true)
                        {
                             SR.Legacy_Siebel_Account_Id__c = QFDEntryLogic.replace('Rejected','Override') ;                              
                        } 
                        else
                        {
                             SR.Legacy_Siebel_Account_Id__c = QFDEntryLogic;
                        }
                         
                        SR.QFD_Entry_Logic__c = QFDEntryLogic;
                    }                    
                    System.debug('Inside of final String ===>' + QFDEntryLogic);
                    if(isAfterExecute && !isBeforeExecute){ 
                        UpdateQFDList.add(SR);
                    }  
                }    
            }
        System.debug('UpdateQFDList ======>'+UpdateQFDList );
        if(!UpdateQFDList.isEmpty() && !isBeforeExecute) 
        {
            upsert UpdateQFDList;
        }
    
    }
}