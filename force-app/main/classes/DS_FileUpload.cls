Public class DS_FileUpload{
@AuraEnabled
		//@future (callout=true)
		public static void UploadFile(Id recordId,String jsonString ) 
			{
			   // String  jsonString =  DS_BusinessRulesCheck_Controller.getJsonFile(recordId);
	
				System.debug('jsonString-future->'+jsonString);
	 
					ContentVersion conVer = new ContentVersion();
					conVer.ContentLocation = CSWXGlobalConstant.fileloaction; // S specify this document is in SF, use E for external files
					conVer.PathOnClient = CSWXGlobalConstant.filelogo; 
					String dp = DS_BusinessRulesCheck_Controller.getDPInfo(recordId);
					String []dpfilename = dp.split(CSWXGlobalConstant.splitBy);
					conVer.Title = dpfilename[0]; // Display name of the files
					conVer.VersionData =Blob.valueOf(jsonString);
					insert conVer;
					System.debug('conVer-future->'+conVer);
					
		
					// First get the content document Id from ContentVersion
					Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()].ContentDocumentId;
					 
					//Create ContentDocumentLink
					ContentDocumentLink cDe = new ContentDocumentLink();
					cDe.ContentDocumentId = conDoc;
					cDe.LinkedEntityId = recordId; 
					cDe.ShareType = CSWXGlobalConstant.fileShareType; 
					cDe.Visibility = CSWXGlobalConstant.fileVisiblity;
					insert cDe;
				 System.debug('cDe-future->'+cDe);
	 
			}
			
			}