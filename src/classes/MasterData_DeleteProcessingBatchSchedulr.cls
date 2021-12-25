/***********************************************************************
*@Class Name: MasterData_DeleteProcessingBatchSchedulr
*@Desription: to delete expired processing Table records on a daily basis
*@Test Class: MasterData_DelProcessingBatchSchdlrTest
*@Modifiction Log:
 --------------------------------------------------------------------------
  @Author		 Change Description			 Date	   
------------------------------------------------------------------------------
  Siva Kumar		Created			14/Apr/2021
************************************************************************/
public class MasterData_DeleteProcessingBatchSchedulr implements Schedulable {
   public void execute(SchedulableContext sc) {
	  MasterData_DeleteProcessingBatch b = new MasterData_DeleteProcessingBatch(); 
	  database.executebatch(b);
   }
}