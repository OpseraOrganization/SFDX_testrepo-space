/************************************
Name         : AvoidRecursionTest
Created By   : Chiranjeevi Gogulakonda
Company Name : NTT Data
Project      : M&PM Simulation Phase2
Created Date : 15 May 2017
Test Class   : 
Usages       : Test Class for Avoid Recusion Class
*************************************/ 
@isTest(SeeAllData=true)
public Class AvoidRecursionTest{
Public static testmethod void AvoidRecursionMethod(){
AvoidRecursion.isFirstRun();
}
Public static testmethod void AvoidRecursionMethod9(){
AvoidRecursion1.isFirstRun();
}
Public static testmethod void AvoidRecursionMethod1(){
AvoidRecursion.isAtrAutomation();
}
Public static testmethod void AvoidRecursionMethod2(){
AvoidRecursion.isFirstRun_OpportunityProduct_UpdateTechSales();
}
Public static testmethod void AvoidRecursionMethod3(){
AvoidRecursion.isFirstRun_preventOpportunityProductChange();
}
Public static testmethod void AvoidRecursionMethod4(){
AvoidRecursion.isFirstRun_Releatedcustomerstories();
}
Public static testmethod void AvoidRecursionMethod5(){
AvoidRecursion.isFirstRun_UpdateProductProductLine();
}
Public static testmethod void AvoidRecursionMethod6(){
AvoidRecursion.isFirstRun_preventScheduleChange();
}
Public static testmethod void AvoidRecursionMethod7(){
AvoidRecursion.isFirstRun_Updateproduct();
}
Public static testmethod void AvoidRecursionMethod8(){
AvoidRecursion1.isFirstRun_Opportunity_Prod_Update_RevenueSchedule();
}
Public static testmethod void AvoidRecursionMethod10(){
AvoidRecursion.checkCount();
}
Public static testmethod void AvoidRecursionMethod11(){
AvoidRecursion1.checkCount();
}
}