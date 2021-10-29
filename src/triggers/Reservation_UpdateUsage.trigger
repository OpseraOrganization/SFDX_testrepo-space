/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : Reservation_UpdateUsage 
* Description           : Trigger to update the Number of Seats, Usage Count in Entitlement and 
*                         Attended in Reservation 
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 26-Oct-2012      1.00           Anusuya NTTData       Initial Version
***********************************************************************************************************/

trigger Reservation_UpdateUsage on Reservation__c (after insert,after update,before delete) 
{
   
    List<Entitlement__c> entlist        = new List<Entitlement__c>();
    List<Entitlement__c> entlistnodate  = new List<Entitlement__c>();
    List<Reservation__c > reservlist    = new List<Reservation__c>();
    List<id> clslist                    = new List<ID>();
    List<class__c > clslst              = new List<class__c>();
    List<class__c > clslst1              = new List<class__c>();
    List<id> accntlist                  = new List<ID>();
    Integer intStatus                   = 0;
    List<Class__c> classlist            = new List<Class__c>();
    List<Contact> acclist               = new List<Contact>();
    List<id> acctlist                   = new List<ID>();
    List<Contract> conlist              = new List<Contract>();
    String strCourseName                = null;
    Date dtDate                     = null;
            
    if(Trigger.isDelete) 
    {
        for(Reservation__c objReserv: Trigger.Old)
        {
            clslist.add(objReserv.Class_Name__c);
            accntlist.add(objReserv.Student__c);       
        }
    }
    else
    {
        for (Reservation__c objReserv: Trigger.New)
        {
           clslist.add(objReserv.Class_Name__c);
           accntlist.add(objReserv.Student__c);       
        }    
    }  
    
    
    if(TriggerCheck.firstAtrRun){
        // Added Code for INC000005613746
        if(clslist.size() > 0){
           clslst = [SELECT id,ATR_Flag__c,Has_Reservation__c,( select id from Reservations__r ) FROM Class__c WHERE id =:clslist AND SBU__c = 'ATR' ];
        
            
            for(Class__c cls : clslst){
                System.debug('11111'+cls.Has_Reservation__c);
                 System.debug('11111'+cls.Reservations__r.size());
                
                if(cls.Reservations__r.size() > 5 && cls.ATR_Flag__c == false && (trigger.isinsert || trigger.isupdate) ){
                 cls.ATR_Flag__c  = true;
                 clslst1.add(cls);
                }
                else if (cls.Reservations__r.size() < 6 && cls.ATR_Flag__c == true && (trigger.isinsert || trigger.isupdate)){
                cls.ATR_Flag__c  = false;
                 clslst1.add(cls);
                }
                
                if(trigger.isdelete && cls.Reservations__r.size() <= 6){
                 cls.ATR_Flag__c  = false;
                 clslst1.add(cls);
                }
            }
          
        }   
        // End Code for INC000005613746
        
        if(clslist.size() > 0)
        {
           strCourseName = [select Course_Name__c from class__c where Id in :clslist][0].Course_Name__c ;
           dtDate        = [select Start_Date__c from class__c where Id in :clslist][0].Start_Date__c ;
           System.debug('Course Name'+strCourseName);
        }
        if(accntlist.size() > 0)
        {
           String strAccountId = [select AccountId from Contact where Id in :accntlist][0].AccountId ;
           //DateTime dtStart  = [select CreatedDate from Contract where AccountId = :strAccountId  order by CreatedDate][0].CreatedDate;
           // System.debug('dtStart'+dtStart);
           //conlist   = [select Id from Contract where AccountId = :strAccountId and status='Active' order by StartDate];
           conlist   = [select Id from Contract where AccountId = :strAccountId  and Record_Type_Name__c ='Training Contracts' order by StartDate];
          // System.debug('Contract Name'+conlist[0].Id);

           System.debug('Contract Size'+conlist.size());
        }
        if(conlist.size() > 0)
        {   
            entlist = [select Id,Usage_Cap__c,Usage_Count__c,Number_Of_Seats__c,IsMultiple__c,Comments__c,Course__c,Contract_Number__c  from Entitlement__c where Status__c='Active' and Contract_Number__c in :conlist and Entitlement_Start_Date__c <= :dtDate and (End_Date__C = null or End_Date__c >= :dtDate) and Course__c = :strCourseName order by Entitlement_Start_Date__c ];
            System.debug('Ent Size'+entlist.size());
            
            entlistnodate = [select Id,Usage_Cap__c,Usage_Count__c,Number_Of_Seats__c,IsMultiple__c,Comments__c,Course__c,Contract_Number__c  from  Entitlement__c where Status__c = 'Active' and Contract_Number__c in :conlist  and Course__c = :strCourseName order by Entitlement_Start_Date__c ];
            System.debug('Ent without date Size'+entlistnodate .size());
        }
         TriggerCheck.firstAtrRun = false;
    }
    if(clslst1.size() > 0)
        update clslst1;
       
    
    if(Trigger.isDelete) 
    {
        for(Reservation__c objReserv: Trigger.Old)
        {       
            for(integer inCnt=0;inCnt<conlist.size();inCnt++)
            {
                for(integer intCnt=0;intCnt<entlist.size();intCnt++)
                {    
                    if(intStatus == 0 && conlist[inCnt].Id ==  entlist[intCnt].Contract_Number__c
                        && objReserv.Attended__c <> 'No Show/Confirmed' && objReserv.Reservation_Status__c == 'Confirmed'
                        && entlist[intCnt].IsMultiple__c ==  False && entlist[intCnt].Course__c <> null)
                    {
                        entlist[intCnt].Usage_Count__c     = entlist[intCnt].Usage_Count__c - 1;
                        entlist[intCnt].Number_Of_Seats__c = entlist[intCnt].Number_Of_Seats__c + 1;  
                    }
                }
            }              
        }
        update entlist;
    }
    else
    {
        if (Trigger.isAfter)
        {  
            if(TriggerCheck.firstRun)
            {
                for(Reservation__c objReserv: Trigger.New)
                {
                    //for(integer inCnt=0;inCnt<conlist.size();inCnt++)
                   // {
                        if(entlist.size() > 0)
                        {
                        for(integer intCnt=0;intCnt<entlist.size();intCnt++)
                        {
                           // if(intStatus == 0 && conlist[inCnt].Id ==  entlist[intCnt].Contract_Number__c  && (entlist[intCnt].Usage_Cap__c > entlist[intCnt].Usage_Count__c || (Trigger.isUpdate && objReserv.Attended__c <> 'No Show/Confirmed'  && (System.Trigger.OldMap.get(objReserv.Id).Reservation_Status__c == 'Confirmed' && System.Trigger.NewMap.get(objReserv.Id).Reservation_Status__c == 'Cancel' || (System.Trigger.OldMap.get(objReserv.Id).Reservation_Status__c == 'Confirmed' && System.Trigger.NewMap.get(objReserv.Id).Reservation_Status__c == 'Registered'))) || (Trigger.isUpdate &&  objReserv.Reservation_Status__c == 'Confirmed' && objReserv.Attended__c == 'No Show/Confirmed' && System.Trigger.OldMap.get(objReserv.Id).Attended__c != System.Trigger.NewMap.get(objReserv.Id).Attended__c  && entlist[intCnt].IsMultiple__c ==  False && entlist[intCnt].Course__c <> null)))
                            if(intStatus == 0 &&  (entlist[intCnt].Usage_Cap__c > entlist[intCnt].Usage_Count__c || (Trigger.isUpdate && objReserv.Attended__c <> 'No Show/Confirmed'  && (System.Trigger.OldMap.get(objReserv.Id).Reservation_Status__c == 'Confirmed' && System.Trigger.NewMap.get(objReserv.Id).Reservation_Status__c == 'Cancel' || (System.Trigger.OldMap.get(objReserv.Id).Reservation_Status__c == 'Confirmed' && System.Trigger.NewMap.get(objReserv.Id).Reservation_Status__c == 'Registered'))) || (Trigger.isUpdate &&  objReserv.Reservation_Status__c == 'Confirmed' && objReserv.Attended__c == 'No Show/Confirmed' && System.Trigger.OldMap.get(objReserv.Id).Attended__c != System.Trigger.NewMap.get(objReserv.Id).Attended__c  && entlist[intCnt].IsMultiple__c ==  False && entlist[intCnt].Course__c <> null)))
                            {
                                if ((Trigger.isInsert && objReserv.Reservation_Status__c == 'Confirmed' && objReserv.Attended__c <> 'No Show/Confirmed' && entlist[intCnt].IsMultiple__c ==  False && entlist[intCnt].Course__c <> null) || (Trigger.isUpdate && (System.Trigger.OldMap.get(objReserv.Id).Reservation_Status__c != System.Trigger.NewMap.get(objReserv.Id).Reservation_Status__c || System.Trigger.OldMap.get(objReserv.Id).Attended__c != System.Trigger.NewMap.get(objReserv.Id).Attended__c) && objReserv.Attended__c <> 'No Show/Confirmed' && entlist[intCnt].IsMultiple__c ==  False && entlist[intCnt].Course__c <>  null)) 
                                {
                                    if(Trigger.isInsert  || (Trigger.isUpdate && ((objReserv.Attended__c <> 'No Show/Confirmed' && ((System.Trigger.OldMap.get(objReserv.Id).Reservation_Status__c == 'Cancel' && System.Trigger.NewMap.get(objReserv.Id).Reservation_Status__c == 'Confirmed') || (System.Trigger.OldMap.get(objReserv.Id).Reservation_Status__c == 'Registered' && System.Trigger.NewMap.get(objReserv.Id).Reservation_Status__c == 'Confirmed') )) || (objReserv.Reservation_Status__c == 'Confirmed' && System.Trigger.OldMap.get(objReserv.Id).Attended__c == 'No Show/Confirmed' && (System.Trigger.NewMap.get(objReserv.Id).Attended__c == 'Yes'  || System.Trigger.NewMap.get(objReserv.Id).Attended__c == 'No Show' )))))
                                    {
                                        System.debug('Line 106 Inside Insert or Update');
                                        if(entlist[intCnt].Usage_Count__c!= null)
                                        {
                                            entlist[intCnt].Usage_Count__c     = entlist[intCnt].Usage_Count__c + 1;
                                        }
                                        else
                                        {
                                            entlist[intCnt].Usage_Count__c     = 1;
                                        }
                                        if(entlist[intCnt].Number_Of_Seats__c != null)
                                        {
                                            entlist[intCnt].Number_Of_Seats__c = entlist[intCnt].Number_Of_Seats__c-1; 
                                        }
                                        else
                                        {
                                            entlist[intCnt].Number_Of_Seats__c = -1;
                                        }        
                                        Reservation__c objRsev   = [select Entitlement__c  from Reservation__c where id= :objReserv.id];
                                        objRsev.Entitlement__c = entlist[intCnt].Id;
                                        reservlist.add(objRsev);
                                        intStatus   = 1;
                                    }
                                    else if(Trigger.isUpdate && objReserv.Attended__c <> 'No Show/Confirmed'  && (System.Trigger.OldMap.get(objReserv.Id).Reservation_Status__c == 'Confirmed' && System.Trigger.NewMap.get(objReserv.Id).Reservation_Status__c == 'Cancel' || (System.Trigger.OldMap.get(objReserv.Id).Reservation_Status__c == 'Confirmed' && System.Trigger.NewMap.get(objReserv.Id).Reservation_Status__c == 'Registered')))
                                    {
                                        System.debug('Line 135 Inside Update');
                                        if(entlist[intCnt].Usage_Count__c!= null)
                                        {
                                            entlist[intCnt].Usage_Count__c     = entlist[intCnt].Usage_Count__c - 1;
                                        }
                                        else
                                        {
                                            entlist[intCnt].Usage_Count__c     = -1;
                                        }
                                        if(entlist[intCnt].Number_Of_Seats__c != null)
                                        {
                                            entlist[intCnt].Number_Of_Seats__c = entlist[intCnt].Number_Of_Seats__c + 1; 
                                        }
                                        else
                                        {
                                            entlist[intCnt].Number_Of_Seats__c = 1;
                                        }                         
                                        Reservation__c objRsev   = [select Entitlement__c  from Reservation__c where id= :objReserv.id];
                                        objRsev.Entitlement__c = entlist[intCnt].Id;
                                        reservlist.add(objRsev);
                                         intStatus   = 1;
                                    }
                                    System.debug('intStatus'+intStatus);     
                                }
                                else if (Trigger.isUpdate &&  objReserv.Reservation_Status__c == 'Confirmed' && objReserv.Attended__c == 'No Show/Confirmed' && System.Trigger.OldMap.get(objReserv.Id).Attended__c != System.Trigger.NewMap.get(objReserv.Id).Attended__c  && entlist[intCnt].IsMultiple__c ==  False && entlist[intCnt].Course__c <> null) 
                                {
                                        System.debug('Line 175 Inside Update');
                                        if(entlist[intCnt].Usage_Count__c!= null)
                                        {
                                            entlist[intCnt].Usage_Count__c     = entlist[intCnt].Usage_Count__c - 1;
                                        }
                                        else
                                        {
                                            entlist[intCnt].Usage_Count__c     = -1;
                                        }
                                        if(entlist[intCnt].Number_Of_Seats__c != null)
                                        {
                                            entlist[intCnt].Number_Of_Seats__c = entlist[intCnt].Number_Of_Seats__c + 1; 
                                        }
                                        else
                                        {
                                            entlist[intCnt].Number_Of_Seats__c = 1;      
                                        }
                                        
                                        Reservation__c objRsev   = [select Entitlement__c  from Reservation__c where id= :objReserv.id];
                                        objRsev.Entitlement__c = entlist[intCnt].Id;
                                        reservlist.add(objRsev);                                 
                                        intStatus   = 1;
                                        System.debug('intStatus'+intStatus);
                                }                       
                           }
                           //else if (conlist[inCnt].Id ==  entlist[intCnt].Contract_Number__c && entlist[intCnt].Usage_Cap__c == entlist[intCnt].Usage_Count__c)
                           else if ( entlist[intCnt].Usage_Cap__c == entlist[intCnt].Usage_Count__c)
                           {
                               System.debug('Line 206 Inside Next Contract');
                               continue;
                           }           
                        }
                        }
                        else if(conlist.size()>0)
                        {
                            //entlistnodate = [select Id,Usage_Cap__c,Usage_Count__c,Number_Of_Seats__c,IsMultiple__c,Comments__c,Course__c,Contract_Number__c  from  Entitlement__c where Status__c = 'Active' and Contract_Number__c in :conlist  and Course__c = :strCourseName order by Entitlement_Start_Date__c ];
                            //System.debug('Ent without date Size'+entlistnodate .size());
                            
                            if(entlistnodate.size()>0)
                            {
                                System.debug('Entitlement is there but Date exceed, Revenue need to be calculated');
                            }
                            else if(intStatus  == 0 && (Trigger.isInsert || (Trigger.isUpdate && objReserv.Reservation_Status__c == 'Cancel' )))
                            {
                                Reservation__c objRsev   = [select Entitlement__c  from Reservation__c where id= :objReserv.id];
                                objRsev.Attended__c      = 'Attended/Update';
                                reservlist.add(objRsev);
                                intStatus   = 1;
                            }
                        }
                   //}  
                  }
             TriggerCheck.firstRun = false;
            }
            update entlist;
            if(reservlist.size() > 0)
            {
                update reservlist;
                System.debug('$$$$$#####'+reservlist);
            }
        }
    }
   return;
}