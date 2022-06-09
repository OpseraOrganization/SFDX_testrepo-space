/****************************************
	 * Class Name : checkRecursive
	 * Created By : Accenture
	 * Last Modified by: Accenture
	 * Description :  This class will help to avoid call method recursively	
	*****************************************/
public with sharing Class checkRecursive{

   @TestVisible
   private static boolean run = true;	
   /*****************************
	 *Method Name: runOnce
	 *Description: method to check runonce
	 *Parameters: NIL
	*******************************/	 
	public static boolean runOnce(){
	try{
		if(run){
		 run=false;
		 return true;
		}else{
			return run;
		}
	}
	catch(Exception ex){ExceptionHandler.addException(ex,CSWXGlobalConstant.checkRecursive,CSWXGlobalConstant.runOnce);return null;
	}
   
 }
}