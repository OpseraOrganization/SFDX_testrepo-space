global class NCP_FavoriteProduct_WS {
		
		global class FavoriteProduct {
			WebService String id;
			WebService String userId;
			WebService String productId;
			WebService String ssoPID;
			WebService String productName;
			WebService String nokiaProductId;
			WebService Boolean isDeleted;
			
			public FavoriteProduct(String productName, String nokiaProductId, String ssoPID, String id) {
				this.nokiaProductId = nokiaProductId;
				this.productName = productName;
				this.ssoPID = ssoPID;
				this.Id = id;  
			}
			public FavoriteProduct(String productName, String nokiaProductId, String ssoPID, Boolean isDeleted, String id) {
				this.nokiaProductId = nokiaProductId;
				this.productName = productName;
				this.ssoPID = ssoPID; 
				this.isDeleted = isDeleted;
				this.Id = id; 
			}
		}
		
		webservice static  List<FavoriteProduct> GetAllFavoriteProducts(){
			List<FavoriteProduct> result = new List<FavoriteProduct>();
			List<NCP_Favorite_Product__c> all_favoriteProducts = new List<NCP_Favorite_Product__c>();
			for(NCP_Favorite_Product__c fp : [select Id, NCP_User__c, NCP_User__r.NCP_SSOPID__c, NCP_Product_Id__r.Name, NCP_Product_Id__r.ProductCode, NCP_Product_Id__r.NCP_Nokia_Product_Id__c,NCP_Product_Id__r.NCP_ALTERNATE_CODE2__c from NCP_Favorite_Product__c LIMIT 50000]){
				if(fp.NCP_Product_Id__r.NCP_ALTERNATE_CODE2__c != null){
					result.add(new FavoriteProduct(fp.NCP_Product_Id__r.Name, fp.NCP_Product_Id__r.NCP_ALTERNATE_CODE2__c, fp.NCP_User__r.NCP_SSOPID__c, fp.Id));
				}
			}
			System.debug('### GetAllFavoriteProducts.result : '+result.size());
			return result;
		}	
		
		webservice static  List<FavoriteProduct> GetLastModifiedFavoriteProducts(){
			List<FavoriteProduct> result = new List<FavoriteProduct>();
			List<NCP_Favorite_Product__c> all_favoriteProducts = new List<NCP_Favorite_Product__c>();
			for(NCP_Favorite_Product__c fp : [select Id, NCP_Product_Id__r.Name, NCP_User__r.NCP_SSOPID__c, NCP_Product_Id__r.NCP_ALTERNATE_CODE2__c, LastModifiedDate,Interface_Status__c, NCP_Removed_Record__c from NCP_Favorite_Product__c Where Interface_Status__c != 'Completed' LIMIT 50000]){
				   if(fp.NCP_Product_Id__r.NCP_ALTERNATE_CODE2__c != null){
						result.add(new FavoriteProduct(fp.NCP_Product_Id__r.Name, fp.NCP_Product_Id__r.NCP_ALTERNATE_CODE2__c, fp.NCP_User__r.NCP_SSOPID__c, fp.NCP_Removed_Record__c, fp.Id));
				   }
			}
			System.debug('### GetLastModifiedFavoriteProducts.result : '+result.size());
			return result;
		}
		webservice static  List<NCP_Favorite_Product__c> UpdateInterfaceStatusFavoriteProducts(List<Id> fpIds){
			//List<FavoriteProduct> result = new List<FavoriteProduct>();
			List<NCP_Favorite_Product__c> completeFavoriteProducts = new List<NCP_Favorite_Product__c>();
			List<NCP_Favorite_Product__c> deleteFavoriteProducts = new List<NCP_Favorite_Product__c>();
			List<Interface_Log__c> interfaceLogList = new List<Interface_Log__c>();

			for(NCP_Favorite_Product__c fp : [select Id, Interface_Status__c, NCP_Removed_Record__c from NCP_Favorite_Product__c Where Id in :fpIds LIMIT 50000]){
				System.debug('fp.NCP_Removed_Record__c= '+fp.NCP_Removed_Record__c+'fp.Id= '+fp.Id+'Interface_Status__c='+fp.Interface_Status__c);
				if(fp.NCP_Removed_Record__c == true){
					fp.Interface_Status__c = 'Completed';
					deleteFavoriteProducts.add(fp);
				}else{
					fp.Interface_Status__c = 'Completed';
					completeFavoriteProducts.add(fp); 
					System.debug('fp.Interface_Status__c= '+fp.Interface_Status__c);
				}
			}
			System.debug('### UpdateInterfaceStatusFavoriteProducts.deleteFavoriteProducts : '+deleteFavoriteProducts.size());
			System.debug('### UpdateInterfaceStatusFavoriteProducts.completeFavoriteProducts : '+completeFavoriteProducts.size());
			if(deleteFavoriteProducts.size() != 0){			 
				try{
					delete(deleteFavoriteProducts); 
					for(NCP_Favorite_Product__c fp:deleteFavoriteProducts){
						interfaceLogList.add(NCP_InterfaceLog.createInterfaceLog('SUS Favorite Products','Inbound','Delete','SUS Integration','Success','Record successfully deleted',''+fp));
					}
				}Catch(Exception e){
					interfaceLogList.add(NCP_InterfaceLog.createInterfaceLog('SUS Favorite Products','Inbound','Delete','SUS Integration','Failure',e.getMessage(),''+deleteFavoriteProducts));
				}
			}
			if(completeFavoriteProducts.size() != 0){
				try{
					update(completeFavoriteProducts);
					for(NCP_Favorite_Product__c fp:completeFavoriteProducts){
						interfaceLogList.add(NCP_InterfaceLog.createInterfaceLog('SUS Favorite Products','Inbound','Update','SUS Integration','Success','Record successfully updated',''+fp));
					}
				}Catch(Exception e){
					interfaceLogList.add(NCP_InterfaceLog.createInterfaceLog('SUS Favorite Products','Inbound','Update','SUS Integration','Failure',e.getMessage(),''+completeFavoriteProducts));
				}
			}
			List<NCP_Favorite_Product__c> results = new List<NCP_Favorite_Product__c>();
			results.addAll(completeFavoriteProducts);
			results.addAll(deleteFavoriteProducts);
			if(!interfaceLogList.isEmpty()){
				insert interfaceLogList;
			}
			return results;
		}
	}