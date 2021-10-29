public class calculateAOP 
{
   private final AOP_For_Sales_Manger__c aoprec;
   Id i;
   AOP_For_Sales_Manger__c aop;
   List<opportunity> opplst = new List<opportunity>();
   List<opportunity> opplst1 = new List<opportunity>();
   List<opportunitylineitem> olilst = new List<opportunitylineitem>();
   List<opportunitylineitem> olilst1 = new List<opportunitylineitem>();
   List<OpportunityLineItemSchedule> revlst = new List<OpportunityLineItemSchedule>();
   Map<OpportunityLineItemSchedule,Id> mp = new Map<OpportunityLineItemSchedule,Id>();
   List<Id> oppidlst1 = new List<Id>();
   List<Id> lineidlst = new List<Id>();
   integer count =0;
   integer CurrentYear;
   DEcimal closedwonamt4rmu = 0,revfromprdt =0,rmutotalrev =0, rmurevfromprdt =0,rmufactfromprdt= 0,rmufactrev= 0,bgaamtotalrev =0,bgaamtotalrevfrmprdt = 0,bgaamfactrevfrmprdt = 0,bgaamfctrev = 0;
    public calculateAOP(Id i ,Integer yr)
    {
       system.debug('*************Inside constructor of calculateAOP');
       aop = [select    AOP_BGA_AM__c,Balance_AOP__c,Balance_RMU_AOP__c,Dealer_Amount1__c,Dealer_Factored__c,AOP_RMU__c,Flag__c,Pipeline_BGA_AM_Factored__c,Pipeline_BGA_AM__c,Pipeline_RMU_Factored__c,Pipeline_RMU__c,AOP_Year__c,sales_manager__c,Opp_Closed_Won_Amount_for_RMU__c from AOP_For_Sales_Manger__c where id = :i];
       System.debug('iiiiiiiiiiiiiiiiiiiiii'+i);   
       system.debug('*************aop'+aop);
       CurrentYear = yr;
       
    }
     public void calculate()
   {
      //Integer CurrentYear = datetime.now().year();
      system.debug('*************Inside calculate function of calculateAOP');
      system.debug('*************!!!!!!!!!!!!!!!!CurrentYear'+CurrentYear);
      //Intializing variables to zero
      aop.Opp_Closed_Won_Amount_for_RMU__c = 0;
      aop.Pipeline_BGA_AM_Factored__c = 0;
      aop.Pipeline_BGA_AM__c = 0;
      aop.Pipeline_RMU__c = 0;
      aop.Pipeline_RMU_Factored__c = 0;
      //Querying opportunities without any lineitems 
      opplst = [ select ExpectedRevenue,CloseDate,Type,name,OwnerId,ForecastCategoryName,Opportunity_Co_owner_new__c,Amount,record_type_name__c from opportunity where ( ownerid = :aop.sales_manager__c  or Opportunity_Co_owner_new__c = :aop.sales_manager__c )  and hasopportunitylineitem = false  and amount  != null and ForecastCategoryName != 'Omitted' and Type!= 'BGA Aftermarket Programs' and Type != 'OEM Programs' and CALENDAR_YEAR(closedate) = :currentyear and (record_type_name__c  = 'BGA AM' or record_type_name__c  = 'BGA OE')and ForecastCategoryName = 'Pipeline'];
      
      //Querying opportunities with lineitems 
      opplst1 = [ select ExpectedRevenue,CloseDate,Type,name,OwnerId,ForecastCategoryName,Opportunity_Co_owner_new__c,Amount,record_type_name__c from opportunity where ( ownerid = :aop.sales_manager__c  or Opportunity_Co_owner_new__c = :aop.sales_manager__c )  and hasopportunitylineitem = true and (ForecastCategoryName = 'Pipeline' or ForecastCategoryName = 'Closed') and ForecastCategoryName != 'Omitted' and (record_type_name__c  = 'BGA AM' or record_type_name__c  = 'BGA OE') and Type!= 'BGA Aftermarket Programs' and Type != 'OEM Programs'];
      
      for(integer i=0;i<opplst1.size();i++)
      {
        oppidlst1.add(opplst1[i].Id);
      }
           
      if(oppidlst1.size()>0)
      {
         //Querying opportunity lineitem  without any schedule 
         olilst = [ Select HasRevenueSchedule ,Total_Revenue__c,ServiceDate, Opportunityid,Is_RMU__c,TotalPrice,Opportunity.ForecastCategoryName,opportunity.Opportunity_Co_owner_new__c from OpportunityLineItem where opportunityid in :oppidlst1 and hasrevenueschedule = false and ((CALENDAR_YEAR(servicedate) = :currentyear) or (servicedate = null and  CALENDAR_YEAR(opportunity.closedate) = :currentyear ) )];  
         //Querying opportunity lineitem  with any schedule 
         olilst1 = [ Select HasRevenueSchedule ,Total_Revenue__c,ServiceDate, Opportunityid,Is_RMU__c,TotalPrice,Opportunity.ForecastCategoryName,opportunity.Opportunity_Co_owner_new__c from OpportunityLineItem where opportunityid in :oppidlst1 and hasrevenueschedule = true ];  
      }
      for(integer i=0;i<olilst1.size();i++)
      {
        lineidlst.add(olilst1[i].Id);
      }
      
      if(lineidlst.size()>0)
      {
         //Querying opportunity revenue schedule 
         revlst = [select id,ScheduleDate,Revenue,OpportunityLineItemId,OpportunityLineItem.Opportunityid,OpportunityLineItem.Opportunity.Opportunity_Co_owner_new__c,OpportunityLineItem.Opportunity.ForecastCategoryName,OpportunityLineItem.Is_RMU__c   from OpportunityLineItemSchedule where OpportunityLineItemId in :lineidlst and CALENDAR_YEAR(scheduledate) = :currentyear];
      }
      
      //Calculation done for opportunity without lineitems
      for(integer i=0;i<opplst.size();i++)
     {
         
                      if(opplst[i].Opportunity_Co_owner_new__c == null) 
                                {
                                  bgaamtotalrev = bgaamtotalrev + opplst[i].Amount;
                                  bgaamfctrev = bgaamfctrev + opplst[i].ExpectedRevenue;
                                }
                              else
                                {
                                  bgaamtotalrev = bgaamtotalrev + opplst[i].Amount/2;
                                  bgaamfctrev = bgaamfctrev + opplst[i].ExpectedRevenue/2;
                                }
       
     }
      
     
     //Calculation done for opportunity lineitems without schedules
   for(integer i=0;i<olilst.size();i++)
     {
      if(olilst[i].IS_RMU__c == 'Yes' && olilst[i].Opportunity.ForecastCategoryName == 'Closed'  )
        {
          if(olilst[i].Opportunity.Opportunity_Co_owner_new__c == null)
                   {
                      closedwonamt4rmu  = closedwonamt4rmu + olilst[i].TotalPrice ;
                    }
                     else
                    {
                       closedwonamt4rmu  = closedwonamt4rmu +olilst[i].TotalPrice /2;
                    }
        }
       if(olilst[i].Opportunity.ForecastCategoryName == 'Pipeline'  )
       {
                      if(olilst[i].Opportunity.Opportunity_Co_owner_new__c == null) 
                                {
                                  bgaamtotalrev = bgaamtotalrev + +olilst[i].TotalPrice;
                                  bgaamfctrev = bgaamfctrev + +olilst[i].Total_Revenue__c;
                                  if(olilst[i].IS_RMU__c == 'YES')
                                   {
                                     rmutotalrev  = rmutotalrev +olilst[i].TotalPrice;
                                     rmufactrev = rmufactrev + olilst[i].Total_Revenue__c;
                                   }
                                }
                              else
                                {
                                 bgaamtotalrev = bgaamtotalrev + +olilst[i].TotalPrice/2;
                                 bgaamfctrev = bgaamfctrev + +olilst[i].Total_Revenue__c/2;
                                 if(olilst[i].IS_RMU__c == 'YES')
                                   {
                                    rmutotalrev  = rmutotalrev +olilst[i].TotalPrice/2;
                                    rmufactrev = rmufactrev + olilst[i].Total_Revenue__c/2;
                                   }
                                }
       
       }
     
     }
     //Calculation done for revenue schedules
     for(integer i=0;i<revlst.size();i++)
     {
     system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%INSIDE REVLST LOOP');
      if(revlst[i].Opportunitylineitem.Is_RMU__c =='YES' && revlst[i].Opportunitylineitem.Opportunity.ForecastCategoryName == 'Closed' )
        {
          if(revlst[i].Opportunitylineitem.Opportunity.Opportunity_Co_owner_new__c == null)
                   {
                      closedwonamt4rmu  = closedwonamt4rmu + revlst[i].Revenue;
                    }
                     else
                    {
                       closedwonamt4rmu  = closedwonamt4rmu + revlst[i].Revenue/2;
                    }
        }
      if(revlst[i].Opportunitylineitem.Opportunity.ForecastCategoryName == 'Pipeline'  )
        {
          if(revlst[i].Opportunitylineitem.Opportunity.Opportunity_Co_owner_new__c == null)
                   {
                      bgaamtotalrev = bgaamtotalrev + +revlst[i].Revenue;
                      bgaamfctrev = bgaamfctrev + +revlst[i].Revenue;
                         if(revlst[i].Opportunitylineitem.IS_RMU__c == 'YES')
                            {
                                rmutotalrev  = rmutotalrev +revlst[i].Revenue;
                                rmufactrev = rmufactrev + revlst[i].Revenue;
                            }
                   }
                     else
                   {
                      bgaamtotalrev = bgaamtotalrev + +revlst[i].Revenue/2;
                      bgaamfctrev = bgaamfctrev + +revlst[i].Revenue/2;
                         if(revlst[i].Opportunitylineitem.IS_RMU__c == 'YES')
                            {
                                rmutotalrev  = rmutotalrev +revlst[i].Revenue/2;
                                rmufactrev = rmufactrev + revlst[i].Revenue/2;
                            }
                   }
        }
     
     
     }
     //Aggregating the results
     system.debug('*************updating variables');
      aop.Opp_Closed_Won_Amount_for_RMU__c  =  closedwonamt4rmu;     
     aop.Pipeline_BGA_AM_Factored__c =  bgaamfctrev ; 
      aop.Pipeline_BGA_AM__c  =   bgaamtotalrev;                  
       aop.Pipeline_RMU__c =  rmutotalrev;
       aop.Pipeline_RMU_Factored__c =  rmufactrev;
       aop.flag__c = 'Processed';
       system.debug('*************Iupdating record');
       try
       {
      update aop;
      }
      catch(Exception e)
      {
      aop.flag__c = 'Exception or Error';
      update aop;
      }
      List<Field_Name__c> fnlist = [select name,id,Field_Name__c,Value__c from  Field_Name__c where ASMName__c = : aop.Id ];
      List<Field_Name__c> newfnlist = new List<Field_Name__c>();
      
        for(integer i=0;i<fnlist.size();i++)
        {
         if(fnlist[i].Field_Name__c == 'Opp_Closed_Won_Amount_for_RMU__c')
         fnlist[i].Value__c =  aop.Opp_Closed_Won_Amount_for_RMU__c;
         if(fnlist[i].Field_Name__c == 'Pipeline_BGA_AM__c')
         fnlist[i].Value__c =  aop.Pipeline_BGA_AM__c;
         if(fnlist[i].Field_Name__c == 'Pipeline_BGA_AM_Factored__c')
         fnlist[i].Value__c = aop.Pipeline_BGA_AM_Factored__c ;
         if(fnlist[i].Field_Name__c == 'Pipeline_RMU__c')
         fnlist[i].Value__c = aop.Pipeline_RMU__c ;
         if(fnlist[i].Field_Name__c == 'Pipeline_RMU_Factored__c')
         fnlist[i].Value__c =  aop.Pipeline_RMU_Factored__c;
         if(fnlist[i].Field_Name__c == 'AOP_BGA_AM__c')
         fnlist[i].Value__c =  aop.AOP_BGA_AM__c;
         if(fnlist[i].Field_Name__c == 'Actual_BGA_AM__c')
         fnlist[i].Value__c =   aop.Actual_BGA_AM__c;
         if(fnlist[i].Field_Name__c =='AOP_RMU__c')
         fnlist[i].Value__c =  aop.AOP_RMU__c;
         if(fnlist[i].Field_Name__c == 'Balance_AOP__c')
         fnlist[i].Value__c =  aop.Balance_AOP__c;
         if(fnlist[i].Field_Name__c == 'Balance_RMU_AOP__c')
         fnlist[i].Value__c =   aop.Balance_RMU_AOP__c;
         if(fnlist[i].Field_Name__c == 'Dealer_Amount__c')
         fnlist[i].Value__c =   aop.Dealer_Amount1__c;
         if(fnlist[i].Field_Name__c == 'Dealer_Factored__c')
         fnlist[i].Value__c =   aop.Dealer_Factored__c ;
         fnlist[i].ownerid =   aop.Sales_Manager__c;
         newfnlist.add(fnlist[i]);
        }
        if(newfnlist.size()>0)
        update newfnlist;
      
      
     System.debug('list of opportunity'+opplst);
   //  PageReference p = new PageReference('/'+i);
   //  return p;
 
  }
}