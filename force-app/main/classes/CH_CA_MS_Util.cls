public class CH_CA_MS_Util {
	
	// Delete a list of objects and return the result 
	public static string deleteSelectedObjects(List<sObject> objectsToDelete, string objectName){
		//Delete the objects
		Database.deleteResult[] deleteErrors = Database.delete(objectsToDelete, false);
		
		// Analyze the delete result
		String statusMessage = '';
		integer deletedSchedules = 0;
		if (deleteErrors.size() > 0){
			for(Database.DeleteResult deleteError : deleteErrors){
				if (deleteError.isSuccess())
					deletedSchedules++;
				else{
					statusMessage += deleteError.getErrors()[0].getMessage();
				}
			}
		}
		return 'Deleted ' + deletedSchedules + ' ' + objectName + (deletedSchedules > 1 ? 's. ' : '. ') + statusMessage;
	}
	
	// Save a list of objects and return the result 
	public static string saveObjects(List<sObject> objectsToSave, string objectName){
		//Delete the objects
		Database.UpsertResult[] upsertErrors = Database.upsert(objectsToSave, false);
		
		// Analyze the delete result
		String statusMessage = '';
		integer upsertedObjects = 0;
		if (upsertErrors.size() > 0){
			for(Database.UpsertResult upsertError : upsertErrors){
				if (upsertError.isSuccess())
					upsertedObjects++;
				else{
					statusMessage += upsertError.getErrors()[0].getMessage();
				}
			}
		}
		return 'Saved ' + upsertedObjects + ' ' + objectName + (upsertedObjects > 1 ? 's. ' : '. ') + statusMessage;
	}
}