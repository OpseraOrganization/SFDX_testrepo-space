/*******************************************************************************
Name         : OppBeforeUpdateHelperClass
Created By   : Anusuya Murugiah
Company Name : NTT Data
Project      : <Phase-II>, <HealthCheck - Sprint3> 
Created Date : 16 Jan 2014
Usages       : This Class is to consolidate the Beforedelete functionality of opportunity which
               splited across in different triggers.               
*******************************************************************************/
public class OppBeforedeleteHelperClass
{
    public static void beforedeleteMethod(Map<id,Opportunity> oldMap)
    {
        List<Opportunity> lstopp= oldMap.Values();
        List<ID> idlist = new List<ID>();
        List<ID> pmidlist = new List<ID>();
        List<Planned_Meeting_Attendee__c> p = new List<Planned_Meeting_Attendee__c>();
        List<Planned_Meeting_Attendee__c> pm = new List<Planned_Meeting_Attendee__c> ();        
        Map<ID,ID> m1 = new MAp<ID,ID>();
        List<Opportunity_Gate__c> og  = new List<Opportunity_Gate__c> ();
        
        for(integer i=0;i<lstopp.size();i++)
        {
            if(lstopp[i].record_type_name__c!= 'BGA OE' && lstopp[i].record_type_name__c!= 'BGA AM')
            
            idlist.add(lstopp[i].Id);
        }
        if(idlist.size()>0)
        og = [select Planned_Meeting__c,Opportunity__c from Opportunity_Gate__c where Opportunity__c in :idlist and Planned_Meeting__C != null];
        
        for(integer i=0;i<og.size();i++)
        {
            pmidlist.add(og[i].Planned_Meeting__c);
            m1.put(og[i].Opportunity__c, og[i].Planned_Meeting__c);
        }
        if(pmidlist.size()>0)
        {
            pm = [select Planned_Meeting__c,Opportunity__c from Planned_Meeting_Attendee__c where Planned_Meeting__c in :pmidlist ];
        }
        for(integer i=0;i<pm.size();i++)
        { 
            for(integer k=0;k<lstopp.size();k++)
            {
               if(lstopp[k].Id == pm[i].Opportunity__c)
               {
                p.add(pm[i]);
               }
            }
        }
        if(p.size()>0)
        {
        delete p;
        }
    }
}