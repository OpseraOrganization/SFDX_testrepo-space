public with sharing class  NOKIACPQ_LineItemInsertWithAPI {
	public class MyException extends Exception {}
	@AuraEnabled
	Public static string insertlineitems(string configId,string body, string lineitemid){
		
		list<string>productcodes= new list<string>();
		list<id>quotenumber=new list<id>();
		list<id>pricelistid=new list<id>();
		String configString;
		String ErrorMessage ;
		String ErrorDispaly;
		String Successmessage;
		Boolean iserror = false;
		set<String> prdsnotavailable = new set<string>();
		map<string,integer>productqtymap= new map<string,integer>();
		map<string,string>productsite= new map<string,string>();
		map<string,string>productsitequantity= new map<string,string>();
		
		NOKIACPQ_BOMJson jsonbody= NOKIACPQ_BOMJson.parse(body);
		system.debug('jsonbody'+jsonbody);
		system.debug('configId'+configId);
		system.debug('lineitemid'+lineitemid);
		
		//system.debug('stationname: '+jsonbody.data.bom_data[0].children.stations[0].pci_code);
		
		configString = jsonbody.data.cfg_data;
		//save configdata to product configuration
		if(String.isNotBlank(configString)){
			String result =  insertAttachment(lineitemid,jsonbody.data.cfg_data);
			if(result != null && result.equalsignorecase('success')){
	errorMessage = 'Your configuration has been saved';
			}else {
	iserror = true;
	errormessage = 'Issue while saving configuration';
			}
			
		}else{
			iserror = true;
			errorMessage = 'Missing configuration data';
		}
		
		
		
		for(NOKIACPQ_BOMJson.cls_stations station : jsonbody.data.bom_data[0].children.stations){
			String StationName = station.pci_code.trim();
			for(NOKIACPQ_BOMJson.cls_children prods : station.children){
	if(productqtymap.containskey(prods.product_code)){
		Integer qtyaggr = productqtymap.get(prods.product_code) + prods.quantity;
		
		string str = string.valueOf(prods.quantity);
		productqtymap.put(prods.product_code, qtyaggr);
		system.debug('productqtymap'+productqtymap);
	}else{
		productqtymap.put(prods.product_code, prods.quantity);
		system.debug('productqtymap'+productqtymap);
	}
	if(productsite.containskey(prods.product_code)){
		if(!(productsite.get(prods.product_code)).contains(StationName)){
			productsite.put(prods.product_code,productsite.get(prods.product_code) +','+StationName );
			productsitequantity.put(prods.product_code,productsitequantity.get(prods.product_code)+','+prods.quantity);
		}
		 else
		{
		string allsite = productsite.get(prods.product_code);
		String allsiteqty = productsitequantity.get(prods.product_code);
		String updateQty = '';
		List<String> listSite = allsite.split(',');
		List<String> listSiteqty = allsiteqty.split(',');
		Integer siteIndex = listSite.Indexof(StationName);
		Integer siteIndexqty = Integer.ValueOf(listSiteqty.get(siteIndex)) + Integer.ValueOf(prods.quantity);
		listSiteqty[siteIndex] = String.Valueof(siteIndexqty);
		for(String siteqty: listSiteqty)
		{
		updateQty += siteqty + ',';
		}
		updateQty = updateQty.subString(0,updateQty.length()-1);
		productsitequantity.put(prods.product_code,updateQty);
		}
	}else{
		productsite.put(prods.product_code,StationName);
		string str = string.valueOf(prods.quantity);
		productsitequantity.put(prods.product_code,str);
		system.debug('productsitequantity'+productsitequantity);
	}
			}
		}
		system.debug('productsite'+productsite); 
		list<Apttus_Config2__LineItem__c>existinglineitemlist = [select id,Custom_Product_Code__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c=:configId and id!=:lineitemid and NokiaCPQ_Is_CAT_Configured__c =true];  
		system.debug('existinglineitemlist'+existinglineitemlist);
		if(!existinglineitemlist.isEmpty())
		{
			database.delete(existinglineitemlist);
			//Added by Christie, for defect - 758
			list<Apttus_Config2__LineItem__c> maintlineitemlist = [SELECT Id,Apttus_Config2__ConfigurationId__c,NokiaCPQ_Part_Number__c,Apttus_Config2__PricingStatus__c FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c=:configId AND Apttus_Config2__PricingStatus__c != 'Pending' AND (NokiaCPQ_Part_Number__c = 'MT001' OR NokiaCPQ_Part_Number__c = 'MT002')];
			system.debug('[+] maintlineitemlist = '+maintlineitemlist.size());
			if(maintlineitemlist .size()>0){
			for(Apttus_Config2__LineItem__c tempLine : maintlineitemlist )
			tempLine.Apttus_Config2__PricingStatus__c = 'Pending';
			database.update(maintlineitemlist);
			system.debug('[+] Updated mainLine Pricing');
			}
		}
		
		if(!productqtymap.isempty()){
			
			// From JSON, extract all the product codes and query them with conditions productcode in () and Portfolio = microwave and Isactive =true
			map<Id, Product2> Productmap = new map<Id, Product2>([select Id,ProductCode,NokiaCPQ_Product_Discount_Category__c,NokiaCPQ_Category__c from Product2 where productcode in :productqtymap.keyset() and IsActive=true and Portfolio__c like '%Microwave%']);  //ITCCPQ-2594

			
			system.debug('Productmap'+Productmap);
			
			Apttus_Config2__ProductConfiguration__c Cart = [SELECT Id,Apttus_QPConfig__Proposald__c,Apttus_Config2__PriceListId__c FROM Apttus_Config2__ProductConfiguration__c WHERE id =:configId LIMIT 1];
			
			// Get Price List Items for the products extracted from above for the price list derived from Quote.			
			list<Apttus_Config2__PriceListItem__c>pricelistitem=[Select id,Apttus_Config2__ProductId__c,Apttus_Config2__PriceListId__c,Apttus_Config2__ProductId__r.Productcode,Apttus_Config2__ProductId__r.name from Apttus_Config2__PriceListItem__c where Apttus_Config2__ProductId__c=:Productmap.keyset() and Apttus_Config2__PriceListId__c=: cart.Apttus_Config2__PriceListId__c];
			
			system.debug('pricelistitem'+pricelistitem);
			map<string,Product2> prdcodetoidmap= new  map<string,Product2>();
			map<string,string> prodtoplimap= new  map<string,string>();
			map<string,string> Productcodemissing= new  map<string,string>();
			for(Apttus_Config2__PriceListItem__c pli : pricelistitem){
	
	if(!prdcodetoidmap.containsKey(pli.Apttus_Config2__ProductId__r.Productcode)){
		prdcodetoidmap.put(pli.Apttus_Config2__ProductId__r.Productcode,Productmap.get(pli.Apttus_Config2__ProductId__c));
		Productcodemissing.put(pli.Apttus_Config2__ProductId__r.Productcode,pli.Apttus_Config2__ProductId__c);
	}
	if(!prodtoplimap.containsKey(pli.Apttus_Config2__ProductId__r.Productcode)){
		prodtoplimap.put(pli.Apttus_Config2__ProductId__r.Productcode,pli.id);
	}
			}
			
			system.debug('prodtoplimap'+prodtoplimap); 
			system.debug('Productcodemissing'+Productcodemissing); 
			
			// Create the request object
			Apttus_CPQApi.CPQ.AddMultiProductRequestDO request = new
	Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
			
			request.CartId = configId;
			
			// Add the products to the request
			for(string prodcode : productqtymap.keySet())
	//system.debug('prodcode'+prodcode);   
			{
	if(!prodtoplimap.containskey(prodcode)){
		iserror = true;
		prdsnotavailable.add(prodcode);
		system.debug('prdsnotavailable'+prdsnotavailable);
	}
	Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct = new
		Apttus_CPQApi.CPQ.SelectedProductDO();
	Apttus_Config2__LineItem__c li = new Apttus_Config2__LineItem__c();
	
	//Get Price list item from the map created initially
	li.Apttus_Config2__PriceListItemId__c = prodtoplimap.get(prodcode);
	li.Source__c = 'CAT';
	li.EPT_Sites__c=productsite.get(prodcode);
	li.EPT_Site_Quantity__c=productsitequantity.get(prodcode);
	li.Apttus_Config2__ClassificationHierarchy__c='';
	li.Apttus_Config2__ClassificationId__c=null;
	li.Apttus_Config2__ClassificationHierarchyInfo__c='';
	li.NokiaCPQ_Is_CAT_Configured__c=true;
	li.Apttus_Config2__PricingStatus__c = Nokia_CPQ_Constants.PENDING_STRING;
	li.Apttus_Config2__IsQuantityModifiable__c = false;
	//  li.NokiaCPQ_Product_Discount_Category__c = prdcodetoidmap.get(prodcode).NokiaCPQ_Product_Discount_Category__c;
	//  li.NokiaCPQ_Category__c = prdcodetoidmap.get(prodcode).NokiaCPQ_Category__c;
	
	selectedProduct.CustomData = li;
	selectedProduct.Customfields =new List<String>{'Apttus_Config2__PriceListItemId__c','Apttus_Config2__PricingStatus__c','EPT_Sites__c','EPT_Site_Quantity__c',
		'Apttus_Config2__ClassificationHierarchy__c','Apttus_Config2__ClassificationId__c','Apttus_Config2__IsQuantityModifiable__c','Source__c','Apttus_Config2__ClassificationHierarchyInfo__c','NokiaCPQ_Is_CAT_Configured__c'
		};
			if(!prdcodetoidmap.isEmpty() && prdcodetoidmap.get(prodcode)!=null){
	selectedProduct.ProductId = (prdcodetoidmap.get(prodcode)).Id;
	
	if(!productqtymap.isEmpty() && productqtymap.get(prodcode)!=null){
		selectedProduct.Quantity = productqtymap.get(prodcode);  //Get Quantity from the map created using JSON file
		request.SelectedProducts.add(selectedProduct);
	}
			}
			}
			if(prdsnotavailable.isEmpty()){ 
	Apttus_Config2__LineItem__c lineitemfieldupdatetrue = [select Id,NokiaCPQ_Is_CAT_Configured__c from Apttus_Config2__LineItem__c 
		where id=:lineitemid];
	lineitemfieldupdatetrue.NokiaCPQ_Is_CAT_Configured__c=true;
	update lineitemfieldupdatetrue;
	system.debug('prdsnotavailable'+prdsnotavailable);
	
	// Execute the addMultiProducts routine
	Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(request);
	// create the update price request
	/*  Apttus_CPQApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
objUpdatePriceRequestDO.CartId = configId;
// update price for the cart
Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO); 
*/
	/*  Boolean IsPricePending = true;
do{
Apttus_CPQApi.CPQ.UpdatePriceRequestDO priceReqDO = new Apttus_CPQApi.CPQ.UpdatePriceRequestDO();
priceReqDO.cartID = configID;
Apttus_CPQApi.CPQ.UpdatePriceResponseDO priceRespDO = Apttus_CPQApi.CPQWebService.updatePriceForCart(priceReqDO);	
List<Decimal> complLineNums = priceRespDO.CompletedLineNumbers;
system.debug('complLineNums :'+ complLineNums);
IsPricePending = priceRespDO.IsPricePending;
List<Decimal> PendingLineNumbers = priceRespDO.PendingLineNumbers;
system.debug('IsPricePending :'+ IsPricePending);

}while(IsPricePending); */
	
	// acpq.saveCart(configId);
	
			}else{
	
	Apttus_Config2__LineItem__c lineitemfieldupdate = [select Id,NokiaCPQ_Is_CAT_Configured__c from Apttus_Config2__LineItem__c 
	   where id=:lineitemid];
	lineitemfieldupdate.NokiaCPQ_Is_CAT_Configured__c=false;
	Update lineitemfieldupdate;
	string joinstring = String.join(new List<String>(prdsnotavailable), ',');
	iserror = true;
	//errormessage = errormessage + '; ' +'There are items currently not available for quoting: ['+joinstring +']';
	
	//errormessage = errormessage + ', ' +'but it contains items currently not available for quoting.  Please:  A.contact your Partner Sales Manager about the item in question OR   B.adjust your configuration to not include those items to continue quoting right away   The items not available for quoting are:['+joinstring +']';
	
	errormessage = errormessage + ', ' +'but it contains items currently not available for quoting.'+'\n'+'Please:'+'\n'+'A. contact your Partner Sales Manager about the item in question'+'\n'+'OR'+'\n'+'B. adjust your configuration to not include those items to continue quoting right away'+'\n'+'The items not available for quoting are:'+'\n'+'['+joinstring +']';
	
	
			}
		}
		
		if(iserror){
			return errorMessage;
		}else{
			return 'success';
		}
		
	}
	@TestVisible private static void saveconfigdata(string configbody, String configId){
		
		Apttus_Config2__LineItem__c MWconfigline = [select Id from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c = :configId and Apttus_Config2__ProductId__r.productcode = 'MWDummy' limit 1];
		Attachment att = new attachment (parentId = MWconfigline.Id, body = blob.valueof(configbody), name = 'cfg_data');
		Database.SaveResult srList = database.insert(att);
		system.debug('attachement insert: '+ srList);
	}
	
	private static string insertAttachment(String parentId,  string configbody){
		Boolean insertsuccess = false;
		try{
			Attachment[] existingAttch = [SELECT Id FROM Attachment WHERE parentId =: parentId LIMIT 1]; 
			
			//Blob payloadBlob = EncodingUtil.base64Decode(configbody);
			
			Attachment attach = new Attachment(contentType = 'text/plain',name = 'cfg_data.txt',
	 parentId = parentId, body = blob.valueOf(configbody));
			configbody = null;
			if(!existingAttch.isEmpty()){
	//First delete existing attachment/configuration
	Database.deleteResult[] delRes = Database.delete(existingAttch,false);
	system.debug('delRes'+delRes);
	if(delRes[0].isSuccess()){
		database.saveresult dbsave = Database.insert(attach,false);
		if(dbsave.isSuccess()) { insertsuccess = true; }
	}
	
			}else{
	database.saveresult dbsave = Database.insert(attach,false);
	if(dbsave.isSuccess()) { insertsuccess = true; }
	
			}
			
			if(insertsuccess){
	return 'success';
			}else{
	return 'error' ;
			}
		}catch(Exception ex){
			
			exceptionhandler.addException(ex, 'NOKIACPQ_LineItemInsertWithAPI', 'insertAttachment');
			return 'error';
		}
	}
	@AuraEnabled
	public static String getconfigdata(string lineitemid){
		try{
			Attachment att = [select body from attachment where parentId = :lineitemid and name = 'cfg_data.txt' limit 1];
			String configstring = att.body.tostring();
			system.debug('cfgdata string: '+att.body.tostring());
			return configstring;
		}catch(Exception ex){
			throw new AuraHandledException('No saved configurations');
		}
	}
	@AuraEnabled
	Public static String getNAIPRespv1(string url,string passmsg , string urlparam){
		try{
			String endpoint = url.substring(1,url.length()-1);
			if(endpoint == 'customReq'){
	  endpoint = 'custom-req';
			}
			system.debug('urlparam: '+urlparam);
			system.debug('url: '+url);
			system.debug('passmsg: '+passmsg);
			endpoint = urlparam.endsWithIgnoreCase('null') ? endpoint : endpoint+'/'+urlparam.substring(1,urlparam.length()-1);
	system.debug('endpoint: '+endpoint);
			Http httpProtocol = new Http();
			HttpRequest request = new HttpRequest();
			request.setEndpoint( String.format('callout:NokiaCPQ_NAIPCAT_Callout/{0}',new String[]{endpoint} ));
			//request.setEndPoint('callout:LineItem_Callout'+endpoint);
			//request.setClientCertificateName('certificatename');
			request.setMethod('POST');
			String body = passmsg.replace('\\','');
			body = body.substring(1, body.length() - 1);
			system.debug('body:'+body);
			request.setBody(body);
			String encodedHeaderValue = EncodingUtil.base64Encode(Blob.valueOf('{!$Credential.UserName}' + ':' + '{!$Credential.Password}'));
			system.debug('encodedHeaderValueencodedHeaderValue-->'+encodedHeaderValue);
			request.setHeader('Authorization', 'Basic ' + encodedHeaderValue);
			request.setHeader('Content-Type', 'application/json');
			// request.setTimeout(120000);
			HttpResponse response = httpProtocol.send(request);
			system.debug(response.getBody());
			System.debug(response.getstatuscode());
			if(response.getStatuscode() == 200){
	//string responsestring=response.getBody();
	return response.getBody();
			}else{
	 throw new MyException(response.getBody()); 
	
			}
			
		}catch (exception ex){
			system.debug('error: '+ex.getMessage());
			throw new AuraHandledException('Error while connecting to Product Model. Please try again or Contact System Administrator');
		}
	}
	
}