/** * File Name: Discretionary_Mass_Closer
* Description Class to update Approval Status of Discretionary Requests 
*of the current fiscal year to Closed when the current month is 12 
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
global class  Discretionary_Mass_Closer implements Schedulable 
{   
     global void execute(SchedulableContext SC)
      {
        
        Integer currentMonth = System.Today().month();
        Integer yr = System.Today().Year();
        
        System.debug('currentMonth-- > ' + currentMonth);
            System.debug('yr-- > ' + yr);
            String year=String.valueOf(yr);
            System.debug('yr to String -- > ' + yr);
              List <Discretionary__c>disLst=new List<Discretionary__c>();
        if (currentMonth==12)
        {
         
       // List <Discretionary__c>disLst=new List<Discretionary__c>();
        
        for (Discretionary__c  dis :[Select d.Id, d.Fiscal_Year__c, d.Approval_Status__c From Discretionary__c d where d.Approval_Status__c<>'Approved' and d.Approval_Status__c <>'Rejected' and
                                    d.Approval_Status__c <>'Closed' and d.Fiscal_Year__c=:year ])
            {
                    Discretionary__c disretionaryUpdate=new Discretionary__c(Id=dis.Id);
                    disretionaryUpdate.Approval_Status__c='Closed';
                    disLst.add(disretionaryUpdate);
            }
       /* if (disLst.size()>0)
             {
                 update disLst;
             }*/
        }
          if (disLst.size()>0)
             {
                 update disLst;
             }
     }
     

}


/*global class  Discretionary_Mass_Closer implements Schedulable 
{  
   global void execute(SchedulableContext SC)
    {
     List <Discretionary__c>disLst=new List<Discretionary__c>();
     
    for (Discretionary__c  dis :[Select d.Id, d.Fiscal_Year__c, d.Approval_Status__c From Discretionary__c d where d.Approval_Status__c<>'Approved' and d.Approval_Status__c <>'Rejected' and
                  d.Approval_Status__c <>'Closed' and d.Fiscal_Year__c='2010' and id='a06Q0000003EWtw'])
      {
          Discretionary__c disretionaryUpdate=new Discretionary__c(Id=dis.Id);
          disretionaryUpdate.Approval_Status__c='Closed';
          disLst.add(disretionaryUpdate);
      }
    if (disLst.size()>0)
       {
         update disLst;
       }
   }
   

}*/