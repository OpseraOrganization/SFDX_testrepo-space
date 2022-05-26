/****************************************
 * Class Name : OrderIntakeAllocationCreation
 * Created Date: 30 Aug 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date:  
 * Description : Handle from Opportunity Contract sign entity change 
 * Test Class: 
 *****************************************/
 
 

public with sharing class OrderIntakeAllocationCreation{


Public static  Set<ID> Productid= new Set<ID>();
Public static  Map<ID,product2> Productmap =new Map<ID,product2>();
Public static  Map<ID,Order_Intake_Forecast__c> OIFMap =new Map<ID,Order_Intake_Forecast__c>();

Public static List<Order_Intake_Forecast__c> OIFAllocationlines = new List<Order_Intake_Forecast__c>();


   /********************
	*Method Name: beforeOperation
	*Parameter: Order_Intake_Forecast__c List
	*Description: Used to update current period based Intake Forecast List 
	*******************/
	
	public static void OIFAlloctionCreate(set<ID> Oppid){  

		List<Order_Intake_Forecast__c> OIFlines = new List<Order_Intake_Forecast__c>();


		 //collecting the Allocation BL OIF lines
  try{
		 for(Order_Intake_Forecast__c  OIFRec:[Select id,POPlanReceipt__c,Rev_RecPlan_Receipt__c,BusinessLine__c,
											   CurrencyIsoCode ,BusinessLine__r.Allocated_BL_1__c,BusinessLine__r.Allocated_BL_2__c,
											   BusinessLine__r.Allocated_BL_3__c,Forecast_Category__c,Exclude_Reason__c,Allocation_Clone__c,
											   Allocation_Line_1__c,Allocation_Line_2__c,Allocation_Line_3__c,Allocation_Sequence__c,Business_Group__c,
											   Notes__c,Business_Unit__c,Cloned_From__c,OIF_Value__c,Opportunity__c,Allocation__c,Software__c,
											   Total_BL_Allocation__c,BusinessLine2__c from Order_Intake_Forecast__c where Total_BL_Allocation__c >0 and Opportunity__c=:Oppid  LIMIT:Limits.getLimitQueryRows()] )
		  {
			if(OIFRec.Total_BL_Allocation__c>0 && OIFRec.Cloned_From__c==Null)
			 {
			   OIFlines.add(OIFRec);
			   Productid.add(OIFRec.BusinessLine__c);
			   OIFMap.put(OIFRec.ID,OIFRec);
  
			}

		 }

		  // Collecting the product with allocation information

		 for(product2 Productinfo:[Select id,Business_Group__c,Family,Allocated_BL_1__c,Allocated_BL_2__c,
								   Allocated_BL_3__c,Allocated_BL_1__r.Business_Group__c,Allocated_BL_1__r.Family,Post_Allocation_1__c,Allocated_BL_1__r.Business_Line2__c,
								   Allocated_BL_2__r.Business_Group__c,Allocated_BL_2__r.Family,Post_Allocation_2__c,Allocated_BL_2__r.Business_Line2__c,
								   Allocated_BL_3__r.Business_Group__c,Allocated_BL_3__r.Family,Post_Allocation_3__c,Allocated_BL_3__r.Business_Line2__c from product2  where id=:Productid limit:Productid.size()] )

		 Productmap.put(Productinfo.id,Productinfo);



	   for(Order_Intake_Forecast__c createallocation :OIFlines)

	   {
		  // Allocation BL3 Not equals to Zero
		  if(createallocation.BusinessLine__r.Allocated_BL_3__c<>Null && createallocation.Allocation__c==False)
		  {
		  System.debug('Allocaton3');
		   Integer count=0;
			 if(count==0){
			  OIFAllocationlines.add(OrderIntakeAllocationCreation.AlloctionCreate(0,createallocation));
			  count=1;
			  }
			  
			  if(count==1){
			  OIFAllocationlines.add(OrderIntakeAllocationCreation.AlloctionCreate(0,createallocation));
			  count=2;
			  }
			  if(count==2){
			  OIFAllocationlines.add(OrderIntakeAllocationCreation.AlloctionCreate(0,createallocation));
			  count=3;
			  }
			  if(count==3){
			  OIFAllocationlines.add(OrderIntakeAllocationCreation.AlloctionCreate(0,createallocation));
			  count=3;
			  }  
		   }
		   
		   // Allocation BL2 Not equals to Zero
		 else if(createallocation.BusinessLine__r.Allocated_BL_2__c<>Null && createallocation.Allocation__c==False)
		  {
		  System.debug('Allocaton2');
		   Integer count=0;
			 if(count==0){
			  OIFAllocationlines.add(OrderIntakeAllocationCreation.AlloctionCreate(0,createallocation));
			  count=1;
			  }
			  
			  if(count==1){
			  OIFAllocationlines.add(OrderIntakeAllocationCreation.AlloctionCreate(1,createallocation));
			  count=2;
			  }
			  if(count==2){
			  OIFAllocationlines.add(OrderIntakeAllocationCreation.AlloctionCreate(2,createallocation));
			  count=3;
			  }
			   
		  }
		  
		  
		  // Allocation BL1 Not equals to Zero
		 else if(createallocation.BusinessLine__r.Allocated_BL_1__c<>Null && createallocation.Allocation__c==False)
		  {
		  System.debug('Allocaton1');
		   Integer count=0;
			 if(count==0){
			  OIFAllocationlines.add(OrderIntakeAllocationCreation.AlloctionCreate(0,createallocation));
			  count=1;
			  }
			  
			  if(count==1){
			  
			  OIFAllocationlines.add(OrderIntakeAllocationCreation.AlloctionCreate(1,createallocation));
			  count=2;
			  }
		   }

 
	   }
  
	System.debug('OIFAllocationlines ----->'+OIFAllocationlines.size());
 
	 if(OIFAllocationlines.size()>0)
	 {
	   List<Database.saveResult> Result = Database.insert(OIFAllocationlines,false);
	   System.debug('OIF Allocation Lines Status'+Result);
   
	 }
  }
  catch (Exception ex) 
		   { ExceptionHandler.addException(ex, GlobalConstants.ORDERINTAKE_HANDLER, GlobalConstants.BEFORE_INSERT);
		 } 

 }
 

public static  Order_Intake_Forecast__c AlloctionCreate(Integer i ,Order_Intake_Forecast__c createallocation){  

	Order_Intake_Forecast__c OIFinsert = new Order_Intake_Forecast__c();

  try{

		OIFinsert.Opportunity__c=createallocation.Opportunity__c;
	   OIFinsert.CurrencyIsoCode=createallocation.CurrencyIsoCode;
	   if(i==0)
	   {
		  
		  if(createallocation.BusinessLine__c<>Null)
		 OIFinsert.BusinessLine__c=createallocation.BusinessLine__c;
		 OIFinsert.OIF_Value__c=0-((createallocation.OIF_Value__c*createallocation.Total_BL_Allocation__c)/100);
		 if(createallocation.Business_Group__c<>Null)
		 OIFinsert.Business_Group__c=createallocation.Business_Group__c;
		 if(createallocation.Business_Unit__c<>Null)
		 OIFinsert.Business_Unit__c=createallocation.Business_Unit__c;
		 //Changes Start AP2021
		 if(createallocation.BusinessLine2__c<>Null)
		 OIFinsert.BusinessLine2__c=createallocation.BusinessLine2__c;
		 //Change End AP2021
		 OIFinsert.Cloned_From__c=createallocation.id;

	   }
	  if(i==1)
	  {
	  
		if(Productmap.get(createallocation.BusinessLine__c).Allocated_BL_1__c<>Null)
		OIFinsert.BusinessLine__c=Productmap.get(createallocation.BusinessLine__c).Allocated_BL_1__c;
		OIFinsert.OIF_Value__c=((createallocation.OIF_Value__c*(Productmap.get(createallocation.BusinessLine__c).Post_Allocation_1__c))/100);
		 if(Productmap.get(createallocation.BusinessLine__c).Allocated_BL_1__r.Business_Group__c<>Null)
		OIFinsert.Business_Group__c=Productmap.get(createallocation.BusinessLine__c).Allocated_BL_1__r.Business_Group__c;
		if(Productmap.get(createallocation.BusinessLine__c).Allocated_BL_1__r.Family<>NUll)
		OIFinsert.Business_Unit__c=Productmap.get(createallocation.BusinessLine__c).Allocated_BL_1__r.Family;
		//Changes Start AP2021
		if(Productmap.get(createallocation.BusinessLine__c).Allocated_BL_1__r.Business_Line2__c<>NUll)
		OIFinsert.BusinessLine2__c=Productmap.get(createallocation.BusinessLine__c).Allocated_BL_1__r.Business_Line2__c;
		//Changes End AP2021
		OIFinsert.Allocation_Sequence__c=i;
		OIFinsert.Cloned_From__c=createallocation.id;
	  }
	  
	   if(i==2)
	  {
	  
		if(Productmap.get(createallocation.BusinessLine__c).Allocated_BL_2__c<>Null)
		OIFinsert.BusinessLine__c=Productmap.get(createallocation.BusinessLine__c).Allocated_BL_2__c;
		OIFinsert.OIF_Value__c= ((createallocation.OIF_Value__c*Productmap.get(createallocation.BusinessLine__c).Post_Allocation_2__c)/100);
		if(Productmap.get(createallocation.BusinessLine__c).Allocated_BL_2__r.Business_Group__c<>NUll)
		OIFinsert.Business_Group__c=Productmap.get(createallocation.BusinessLine__c).Allocated_BL_2__r.Business_Group__c;
		if(Productmap.get(createallocation.BusinessLine__c).Allocated_BL_2__r.Family<>Null)
		OIFinsert.Business_Unit__c=Productmap.get(createallocation.BusinessLine__c).Allocated_BL_2__r.Family;
		//Changes Start AP2021
		if(Productmap.get(createallocation.BusinessLine__c).Allocated_BL_2__r.Business_Line2__c<>Null)
		OIFinsert.BusinessLine2__c=Productmap.get(createallocation.BusinessLine__c).Allocated_BL_2__r.Business_Line2__c;
		//Changes End AP2021
		OIFinsert.Allocation_Sequence__c=i;
		OIFinsert.Cloned_From__c=createallocation.id;
	  }
	  
	   if(i==3)
	  {
	  
		 if(Productmap.get(createallocation.BusinessLine__c).Allocated_BL_3__c<>Null)
		OIFinsert.BusinessLine__c=Productmap.get(createallocation.BusinessLine__c).Allocated_BL_3__c;
	   OIFinsert.OIF_Value__c=((createallocation.OIF_Value__c*Productmap.get(createallocation.BusinessLine__c).Post_Allocation_3__c)/100);
	   if(Productmap.get(createallocation.BusinessLine__c).Allocated_BL_3__r.Business_Group__c<>Null)
	   OIFinsert.Business_Group__c=Productmap.get(createallocation.BusinessLine__c).Allocated_BL_3__r.Business_Group__c;
		if(Productmap.get(createallocation.BusinessLine__c).Allocated_BL_3__r.Family<>Null)
		OIFinsert.Business_Unit__c=Productmap.get(createallocation.BusinessLine__c).Allocated_BL_3__r.Family;
		//Changes Start AP2021
		if(Productmap.get(createallocation.BusinessLine__c).Allocated_BL_3__r.Business_Line2__c<>Null)
		OIFinsert.BusinessLine2__c=Productmap.get(createallocation.BusinessLine__c).Allocated_BL_3__r.Business_Line2__c;
		//Changes End AP2021
		OIFinsert.Allocation_Sequence__c=i;
		OIFinsert.Cloned_From__c=createallocation.id;
	   }
	   
	   OIFinsert.Exclude_Reason__c=createallocation.Exclude_Reason__c;
	   OIFinsert.Forecast_Category__c=createallocation.Forecast_Category__c;
	   OIFinsert.Notes__c=createallocation.Notes__c;
	   if(createallocation.Rev_RecPlan_Receipt__c<>Null)
	   OIFinsert.Rev_RecPlan_Receipt__c=createallocation.Rev_RecPlan_Receipt__c;
	   OIFinsert.POPlanReceipt__c=createallocation.POPlanReceipt__c;
	   OIFinsert.Software__c=createallocation.Software__c;
	   
	   System.debug('Allocation OIF --->'+OIFinsert);

	   
	   }
	   catch (Exception ex) 
		   { ExceptionHandler.addException(ex, GlobalConstants.ORDERINTAKE_HANDLER, GlobalConstants.BEFORE_INSERT);
		 } 
		 
		return OIFinsert;  

 }



}