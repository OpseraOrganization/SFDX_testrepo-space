global with sharing class CalculateAircraftMaintenanceEvent 
{
    
    
    /******************************************************************************************************
    Calculation for event C
    ******************************************************************************************************/
    
    
    public static boolean gen_C_EventData(set<id> platfrmId)
    {
        integer errLoc = 0;
        Map<Id,Fleet_Asset_Detail__c> airList = new Map<Id,Fleet_Asset_Detail__c>([
                                        select  Id,
                                                Entry_into_service_EIS__c,
                                                Platform_Name__c,
                                                Previous_C_Check_Event_Date__c,
                                                Platform_Name__r.C_Event_Duration__c,
                                                Platform_Name__r.CCHK_NUM__c,
                                                Platform_Name__r.Avg_Flying_Hors_Per_Year__c 
                                        from    Fleet_Asset_Detail__c 
                                        where   
                                        (
                                                    (Platform_Name__r.C_Event_Duration__c != null And Platform_Name__r.C_Event_Duration__c != 0)
                                                    OR
                                                    (   
                                                        (Platform_Name__r.CCHK_NUM__c != null And Platform_Name__r.CCHK_NUM__c != 0) 
                                                        AND 
                                                        (Platform_Name__r.Avg_Flying_Hors_Per_Year__c != null And Platform_Name__r.Avg_Flying_Hors_Per_Year__c != 0)
                                                    )
                                        )
                                        And (Entry_into_service_EIS__c != null Or Previous_C_Check_Event_Date__c != null)
                                        And Platform_Name__c in :platfrmId                  ]);
                                        system.debug('C-FFFFFFFFFleet PLatformmmmID'+platfrmId);
                                        system.debug('C-FFFFFFFFFleet Aseet Details'+airList.size());
                
                                
                
                /*****************Delete Existing Event Data*****************/
                
                List<Maintenance_Events__c> delMaintData = 
                                                           [
                                                                Select Id From Maintenance_Events__c 
                                                                Where 
                                                                Aircraft__r.Platform_Name__c in :platfrmId 
                                                                And Check_Name__c = 'C'
                                                           ]; 
                                                           system.debug('C-MMMMaintenance Events Deleted'+delMaintData.size());
                //Delete statement is written in the last
                if(airList.size() == 0)
                {
                    delete delMaintData;
                    return false;
                }                   
                
                /***************** Delete Existing Event Data **************************/
                
                
                                List<Maintenance_Events__c> mainListEvent = new List<Maintenance_Events__c>();          
                                                
                                for(String key:airList.keySet()) 
                                {   
                                    
                                        Date lastEventDate =
                                        (
                                            airList.get(key).Previous_C_Check_Event_Date__c != null ?
                                            airList.get(key).Previous_C_Check_Event_Date__c
                                            :
                                            airList.get(key).Entry_into_service_EIS__c  
                                        ) ;
                                        
                                        Date[] evntDt   = getNextEventDates
                                                                        (
                                                                            lastEventDate,
                                                                            airList.get(key).Platform_Name__r.CCHK_NUM__c,
                                                                            airList.get(key).Platform_Name__r.C_Event_Duration__c,
                                                                            airList.get(key).Platform_Name__r.Avg_Flying_Hors_Per_Year__c,
                                                                            5
                                                                        );
                            
                                        mainListEvent.add(mainEventRecord(airList.get(key).Id,evntDt,'C'));
                                                         
                                            
                                }
                                
                                if(mainListEvent.size() > 0)
                                {
                                    try{
                                    delete delMaintData;
                                    insert mainListEvent;
                                    }catch(Exception e)
                                        {
                                            utilClass.createErrorLog
                                                  (
                                                      'CalculateAircraftMaintenanceEvent',
                                                      'gen_C_EventData',
                                                      'errLoc - ' + errLoc + ' - ' + e.getMessage()
                                                  );
    
                                        }
                                    addApplicableRMUWithMaint(mainListEvent,'C',airList);
                                }
                                
            return true;                    
    }
        
    /******************************************************************************************************
    Calculation for event B
    ******************************************************************************************************/
    
    public static  boolean gen_B_EventData(set<id> platfrmId)
    {
        integer errLoc = 1;
        Map<Id,Fleet_Asset_Detail__c> airList = new Map<Id,Fleet_Asset_Detail__c>([
                                        select  Id,
                                                Entry_into_service_EIS__c,
                                                Previous_B_Check_Event_Date__c,
                                                Platform_Name__c,
                                                Platform_Name__r.B_Event_Duration__c,
                                                Platform_Name__r.BCHK_NUM__c,
                                                Platform_Name__r.Avg_Flying_Hors_Per_Year__c 
                                        from    Fleet_Asset_Detail__c 
                                        where       
                                        (
                                                    (Platform_Name__r.B_Event_Duration__c != null and Platform_Name__r.B_Event_Duration__c != 0) 
                                                    OR
                                                    (   
                                                        (Platform_Name__r.BCHK_NUM__c != null And Platform_Name__r.BCHK_NUM__c != 0) 
                                                        AND 
                                                        (Platform_Name__r.Avg_Flying_Hors_Per_Year__c != null And Platform_Name__r.Avg_Flying_Hors_Per_Year__c!=0)
                                                    )
                                        )
                                        And (Entry_into_service_EIS__c != null Or Previous_B_Check_Event_Date__c != null)
                                        And Platform_Name__c IN :platfrmId   
                                    ]);
                                    system.debug('B-FFFFFFFFFleet Aseet Details'+airList.size());
                
                                
                /* **************** Delete Existing Event Data **************** */
                                
                List<Maintenance_Events__c> delMaintData = [
                                                                Select Id From Maintenance_Events__c 
                                                                Where
                                                                Aircraft__r.Platform_Name__c = :platfrmId  
                                                                And Check_Name__c = 'B'
                                                            ]; 
                                                            system.debug('B-MMMMaintenance Events Deleted'+delMaintData.size());
                if(airList.size() == 0)
                {
                    delete delMaintData;
                    return false;
                }                   
                                    
                                    //Delete statement is written in the last
                                
                                /***************** Delete Existing Event Data **************************/
                                                            
                                List<Maintenance_Events__c> mainListEvent = new List<Maintenance_Events__c>();          
                                                
                                for(String key:airList.keySet()) 
                                {   
                                        Date lastEventDate =
                                        (
                                            airList.get(key).Previous_B_Check_Event_Date__c != null ?
                                            airList.get(key).Previous_B_Check_Event_Date__c
                                            :
                                            airList.get(key).Entry_into_service_EIS__c  
                                        ) ;
                                    
                                        Date[] evntDt   = getNextEventDates
                                                                        (
                                                                            lastEventDate,
                                                                            airList.get(key).Platform_Name__r.BCHK_NUM__c,
                                                                            airList.get(key).Platform_Name__r.B_Event_Duration__c,
                                                                            airList.get(key).Platform_Name__r.Avg_Flying_Hors_Per_Year__c,
                                                                            5
                                                                        );
                            
                                        mainListEvent.add(mainEventRecord(airList.get(key).Id,evntDt,'B'));
                                                         
                                            
                                }
                                
                                if(mainListEvent.size() > 0)
                                {
                                    try{
                                    delete delMaintData;
                                    insert mainListEvent;
                                    }catch(Exception e)
                                        {
                                            utilClass.createErrorLog
                                                  (
                                                      'CalculateAircraftMaintenanceEvent',
                                                      'gen_B_EventData',
                                                      'errLoc - ' + errLoc + ' - ' + e.getMessage()
                                                  );
    
                                        }
                                    addApplicableRMUWithMaint(mainListEvent,'B',airList);
                                }
                                
            return true;                    
    }
    /******************************************************************************************************
    Calculation for event A
    ******************************************************************************************************/
    public static   boolean gen_A_EventData(set<id> platfrmId)
    {
        integer errLoc = 2;
        Map<Id,Fleet_Asset_Detail__c> airList = new Map<Id,Fleet_Asset_Detail__c>([
                                        select  Id,
                                                Entry_into_service_EIS__c,
                                                Previous_A_Check_Event_Date__c,
                                                Platform_Name__c,
                                                Platform_Name__r.A_Event_Duration__c,
                                                Platform_Name__r.ACHK_NUM__c,
                                                Platform_Name__r.Avg_Flying_Hors_Per_Year__c 
                                        from    Fleet_Asset_Detail__c 
                                        where   
                                        (
                                                    (Platform_Name__r.A_Event_Duration__c != null and Platform_Name__r.A_Event_Duration__c != 0) 
                                                    OR
                                                    (   
                                                        (Platform_Name__r.ACHK_NUM__c    != null And Platform_Name__r.ACHK_NUM__c    != 0)
                                                        AND 
                                                        (Platform_Name__r.Avg_Flying_Hors_Per_Year__c != null And Platform_Name__r.Avg_Flying_Hors_Per_Year__c != 0)
                                                    )
                                        )
                                        And (Entry_into_service_EIS__c != null Or Previous_A_Check_Event_Date__c != null)   
                                        And Platform_Name__c in :platfrmId   
                                    ]);
                                    system.debug('A-FFFFFFFFFleet Aseet Details'+airList.size());
                
                                
                /***************** Delete Existing Event Data **************** */
                                
                List<Maintenance_Events__c> delMaintData = [
                                                                Select Id From Maintenance_Events__c 
                                                                Where 
                                                                Aircraft__r.Platform_Name__c = :platfrmId  
                                                                And Check_Name__c = 'A'
                                                            ]; 
                                                            system.debug('A-MMMMaintenance Events Deleted'+delMaintData.size());
                                    
                                    //Delete statement is written in the last
                if(airList.size() == 0)
                {
                    delete delMaintData;
                    return false;
                }                   
                                
                                /***************** Delete Existing Event Data **************************/
                                                            
                                List<Maintenance_Events__c> mainListEvent = new List<Maintenance_Events__c>();          
                                                
                                for(String key:airList.keySet()) 
                                {   
                                        Date[] evntDt   = getNextEventDates
                                                                        (
                                                                            (
                                                                                airList.get(key).Previous_A_Check_Event_Date__c != null ?
                                                                                airList.get(key).Previous_A_Check_Event_Date__c
                                                                                :
                                                                                airList.get(key).Entry_into_service_EIS__c  
                                                                            ),
                                                                            airList.get(key).Platform_Name__r.ACHK_NUM__c,
                                                                            airList.get(key).Platform_Name__r.A_Event_Duration__c,
                                                                            airList.get(key).Platform_Name__r.Avg_Flying_Hors_Per_Year__c,
                                                                            5
                                                                        );
                            
                                        mainListEvent.add(mainEventRecord(airList.get(key).Id,evntDt,'A'));
                                                         
                                            
                                }
                                
                                if(mainListEvent.size() > 0)
                                {
                                    try{
                                    delete delMaintData;
                                    insert mainListEvent;
                                    }catch(Exception e)
                                        {
                                            utilClass.createErrorLog
                                                  (
                                                      'CalculateAircraftMaintenanceEvent',
                                                      'gen_B_EventData',
                                                      'errLoc - ' + errLoc + ' - ' + e.getMessage()
                                                  );
    
                                        }
                                    addApplicableRMUWithMaint(mainListEvent,'A',airList);
                                }
                                
            return true;                    
    }
    
    /******************************************************************************************************
    Add RMU Mapper with RMU
    ******************************************************************************************************/
    
    static Integer addApplicableRMUWithMaint
                                    (
                                        List<Maintenance_Events__c> pMaintEvent,
                                        String eventName,
                                        Map<Id,Fleet_Asset_Detail__c> airList
                                    )
    {
        integer errLoc = 3;
        List<String> pltfrmId = new List<String>();
        for(String key:airList.keySet()) 
        {
            pltfrmId.add(airList.get(key).Platform_Name__c);
        }
        List<OFFERING_MAPPER__c> lstOfferingMapper = null;
        
        if(eventName.equals('A'))
        {
                lstOfferingMapper                       = [ Select  Id,
                                                                        Aircraft_Platform__c 
                                                                From    OFFERING_MAPPER__c 
                                                                Where   Aircraft_Platform__c in :pltfrmId 
                                                                And     
                                                                        Valid_For_Check_A__c = true
                                                                        // And EIS_DT__c >= Syste.Today()
                                                            ];
                                                            system.debug('A-RRRRMUS'+lstOfferingMapper.size());
        }
        else if(eventName.equals('B'))
        {
                lstOfferingMapper                       = [ Select  Id,
                                                                        Aircraft_Platform__c 
                                                                From    OFFERING_MAPPER__c 
                                                                Where   Aircraft_Platform__c in :pltfrmId 
                                                                And     
                                                                        Valid_For_Check_B__c = true
                                                                        // And EIS_DT__c >= Syste.Today()
                                                          ];
                                                          system.debug('B-RRRRMUS'+lstOfferingMapper.size());
        }
        else if(eventName.equals('C'))
        {
                lstOfferingMapper                       = [ Select  Id,
                                                                        Aircraft_Platform__c 
                                                                From    OFFERING_MAPPER__c 
                                                                Where   Aircraft_Platform__c in :pltfrmId 
                                                                And     
                                                                        Valid_For_Check_C__c = true
                                                                        // And EIS_DT__c >= Syste.Today()
                                                            ];
                                                            system.debug('C-RRRRMUS'+lstOfferingMapper.size());
        }
        
        List<Event_Rmu_Opp__c> eroList = new List<Event_Rmu_Opp__c>();
        
        
        for(integer i=0;i<pMaintEvent.size();i++)
        {
            List<String> rmuNames = rmuMaperList(lstOfferingMapper,airList.get(pMaintEvent[i].Aircraft__c).Platform_Name__c);
            
            for(integer k=0;k<rmuNames.size();k++)
            {       
                Event_Rmu_Opp__c eroRec     = new Event_Rmu_Opp__c();
                eroRec.Maintenance_Event__c = pMaintEvent[i].Id;
                eroRec.Offering_Mapper__c   = rmuNames[k];
                eroList.add(eroRec);
            }
            system.debug('EVENT RMU OPPTY'+eroList.size());
        }
        
        try{
        insert eroList;
        }catch(Exception e){
             utilClass.createErrorLog
             (
                  'CalculateAircraftMaintenanceEvent',
                  'EVENT RMU OPPTY',
                  'errLoc - ' + errLoc + ' - ' + e.getMessage()
             );
         }
         
        return eroList.size(); 
    }
    
    
    /******************************************************************************************************
    * End here with add RMU Mapper
    ******************************************************************************************************/
    static List<String> rmuMaperList(List<OFFERING_MAPPER__c> oferMaper,String platFrmId)
    {
        List<String> rmuNames = new List<String>();
        
        for(integer i=0;i<oferMaper.size();i++)
        {
            if(((String)oferMaper[i].Aircraft_Platform__c).equals(platFrmId))
            {
                rmuNames.add(oferMaper[i].Id);
            }
        }
        system.debug('RMU NAMES'+rmuNames);
        
        return rmuNames;
    }
    
    static  Date[] getNextEventDates
                    (
                        Datetime purchaseDate,
                        Decimal chkHours,
                        Decimal chkMonths,
                        Decimal avgFlingHrs,
                        Integer eventCnt
                     )
                     {
                        
                            return getNextEventDates
                            (
                                purchaseDate.date(),
                                chkHours,
                                chkMonths,
                                avgFlingHrs,
                                eventCnt
                             );
                        
                     }
                     
    static Date[] getNextEventDates
                    (
                        Date purchaseDate,
                        Decimal chkHours,
                        Decimal chkMonths,
                        Decimal avgFlingHrs,
                        Integer eventCnt
                     )
    {
        Date[] retDt = new Date[eventCnt];
        integer j=0;
        Date prevDate = null;
        for(Integer i=0;i<100;i++)
        {
            Date calDate = getEventDate
                    (
                         (prevDate == null ? purchaseDate : prevDate),
                         chkHours,
                         chkMonths,
                         avgFlingHrs,
                         (prevDate == null ? i+1 : 1)
                     );
            
            if(calDate >= System.today())
            {
                retDt[j] = calDate;
                prevDate = retDt[j];
                if(j==4){
                    break;
                }
                j++;
            }        
                     
        }
        
        return retDt;
    }
    
    static Date getEventDate(
                        Date purchaseDate,
                        Decimal chkHours,
                        Decimal chkMonths,
                        Decimal avgFlingHrs,
                        Integer eventNumber
                     )
    {
                    Date retVal = null;
                        
                    if( purchaseDate != null )
                    {
                            retVal  = purchaseDate;
                            
                            if
                            (   
                                (chkHours != null && chkHours !=0)
                                &&
                                (
                                    (chkMonths == null || chkMonths == 0)
                                    ||
                                    (   addY(purchaseDate,(1/avgFlingHrs)*chkHours)
                                        <
                                        purchaseDate.addMonths(Math.round(chkMonths))
                                    )
                                )
                            ) 
                             {
                                    if
                                    (
                                        System.today() 
                                        <=
                                        (addY(purchaseDate,((1/avgFlingHrs)* chkHours)*eventNumber))
                                    )
                                    {
                                        
                                        retVal = addY(purchaseDate,(((1/avgFlingHrs)*chkHours)*eventNumber));
                                    }
                                
                             }
                             else
                             {
                                    if
                                    (
                                        System.today() 
                                        <=
                                        purchaseDate.addMonths(Math.round(chkMonths)*eventNumber)
                                    )
                                    {
                                        retVal = purchaseDate.addMonths(Math.round(chkMonths)*eventNumber);
                                    }
                             }
            }
            
            return retVal;
    }
    
    /**********************************************************************************************
    * Add Main Event Record
    **********************************************************************************************/
    
    static Maintenance_Events__c mainEventRecord(String airId,Date[] eDates,String checkName)
    {
                    Maintenance_Events__c mainEvent = new Maintenance_Events__c();
                    
                    mainEvent.Aircraft__c       =  airId;
                    mainEvent.Check_Name__c     =  checkName;
                    mainEvent.Event_Date__c     =  eDates[0];
                    mainEvent.Event_Date_2__c   =  eDates[1];
                    mainEvent.Event_Date_3__c   =  eDates[2];
                    mainEvent.Event_Date_4__c   =  eDates[3];
                    mainEvent.Event_Date_5__c   =  eDates[4];
                    mainEvent.Name              =  mainEvent.Check_Name__c + ' Check';
                    
                    return mainEvent;
    }
    
    static Date addY(Date inputDate,Decimal inputY)
    {
        return inputDate.addYears(inputY.intValue()).addDays(Math.round(365*(inputY - inputY.intValue())));
    }
    
    static testMethod void myunitTest2()
    {
        //CalculateAircraftMaintenanceEvent came = new CalculateAircraftMaintenanceEvent();
    }
    
}