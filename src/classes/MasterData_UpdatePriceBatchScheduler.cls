/***********************************************************************
*@Class Name: MasterData_UpdatePriceBatchScheduler
*@Desription: to delete expired processing Table records on a daily basis
*@Test Class: MasterData_UpdatePriceBatchSchedulerTest
*@Modifiction Log:
 --------------------------------------------------------------------------
  @Author		 Change Description			 Date	   
------------------------------------------------------------------------------
  Siva Kumar		Created			29/Apr/2021
**************************************************************************/

public class MasterData_UpdatePriceBatchScheduler implements Schedulable {
   public void execute(SchedulableContext sc) {
	  MasterData_UpdatePriceBatch b = new MasterData_UpdatePriceBatch(); 
	  database.executebatch(b);
   }
}