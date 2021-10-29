/*
Author: NTT Data
Created Date: 2/2/2016
Test Class: ServiceRequest_Aircraft_ClsTest
Description: Replacement for ServiceRequest_Aircraft_Cls. To add multiple Aircraft Platforms affected to Service Request object. 
             Used in New Aircrat/Platforms Affected cutom button and AddmultipleAircrafts vf page.
*/
public class AddmultipleAircraftsController
{
    public id id1;
    Aircraft_Platforms_Affected__c AP = new Aircraft_Platforms_Affected__c();
    public list<Aircraft_Platforms_Affected__c> listAPA{ get; set; }
    public String emsg{ get; set; }
    public AddmultipleAircraftsController() 
        {
        id1 = Apexpages.currentPage().getParameters().get('id');
        listAPA=new list<Aircraft_Platforms_Affected__c>();
        AP.Service_Request__c = id1;
        listAPA.add(AP);
        }

    Public void addAirPlaAff()
    {
        Aircraft_Platforms_Affected__c AirPla = new Aircraft_Platforms_Affected__c();
        AirPla.Service_Request__c = id1;
        listAPA.add(AirPla);
    }
    
    public PageReference saveAirPlaAff() 
    {
        list<Aircraft_Platforms_Affected__c> listAPA1 = new list<Aircraft_Platforms_Affected__c>();
        
        for(Integer i=0; i<listAPA.size(); i++)
        {
        if (listAPA[i].Aircraft_Platforms_Affected__c != null)
            {
            listAPA1.add(listAPA[i]);
            }
        }
        
        if(!listAPA1.isEmpty())
        {
            try
            {
                Upsert listAPA1;
            }
            catch(DmlException  e)
            {  
                emsg = 'Error:'+ e;
            }
        }
        
        PageReference pageRef = new PageReference('/'+id1);
        if (emsg == null)
        {
            return pageRef;
        }
        return null;
    }
    
    public PageReference CancelAirPlaAff() 
    {
        PageReference pageRef = new PageReference('/'+id1);
        return pageRef;
    }
}