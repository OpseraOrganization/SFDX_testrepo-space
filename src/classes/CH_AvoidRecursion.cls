public class CH_AvoidRecursion {
	public static boolean run=true;
	//Start Recursive check for casetrigger for CAPS Code
	public static boolean afterUpdateCAPSCaseStatus = true;
	public static boolean afterUpdateCAPSCaseProduct = true;
	public static boolean afterUpdateCAPSCaseEntitlement = true;
	public static boolean afterUpdateCAPSCaseAccount = true;
	public static boolean afterUpdateCAPSCaseSG = true;
	public static boolean afterUpdateCAPSCaseProductRelease = true;
	//End Recursive for casetrigger for CAPS Code
	//Start Do execute case trigger for Batch_CH_Notifications run
	public static boolean doNtExcuteCseTrggr4NotfcationBtch = true;
	//End Do execute case trigger for Batch_CH_Notifications run
	public static boolean runOnce(){
		if(run){
			run=false;
			return true;
		}else{
			return run;
		}
	}
	
	public static boolean beforeInsert = true;
	public static boolean beforeUpdate = true;
	public static boolean afterInsert = true;
	public static boolean afterUpdate = true;
	
	public static boolean runBeforeInsertOnce(){
		if(beforeInsert){
			beforeInsert=false;
			return true;
		} else{
			return beforeInsert;
		}
	}
	public static boolean runBeforeUpdateOnce(){
		if(beforeUpdate){
			beforeUpdate=false;
			return true;
		} else{
			return beforeUpdate;
		}
	}
	public static boolean runAfterInsertOnce(){
		if(afterInsert){
			afterInsert=false;
			return true;
		} else{
			return afterInsert;
		}
	}
	public static boolean runAfterUpdateOnce(){
		if(afterUpdate){
			afterUpdate=false;
			return true;
		} else{
			return afterUpdate;
		}
	}
}