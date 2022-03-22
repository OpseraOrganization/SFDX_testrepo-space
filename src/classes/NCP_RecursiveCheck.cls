public class NCP_RecursiveCheck {
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