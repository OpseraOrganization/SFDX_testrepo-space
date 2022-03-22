public without sharing class QTC_SiteXMLGeneration {
	
	public class XMLSerializer{
	
		//Private Members
		private boolean serializeNulls = true;				  
		private string rootElement;							 
		private Set<string> deSerializeAsArrayNodes = new Set<string>();
		
		public string serialize(object objectToSerialize){  
				 
			object deSerialized = JSON.deserializeUntyped(JSON.serializePretty(objectToSerialize));	
			system.debug('after JSON Deserialize>>>'+deSerialized);			
			return !string.isEmpty(rootElement) ? Wrap(rootElement,serialize((Map<string,object>)deSerialized)) : serialize((Map<string,object>)deSerialized);				 
		}
		
		public string serialize(object objectToSerialize,boolean suppressApexObjectNulls,string addRootElementName){
		
			this.serializeNulls = !suppressApexObjectNulls;
			this.rootElement = addRootElementName;			
			return serialize(objectToSerialize);
		}
		
		private string serialize(Map<string,object> objectMap){
			string xmlString = '';  
			Map<string,object> deSerializedSortedMap = new Map<string,object>();			
			list<string> keyValuesList = new List<string>(objectMap.keySet());
			
			if(Nokia_CPQ_Constants.QTC_SIT_EXPORT_TOP_LEVEL_XML_TAGS.contains(keyValuesList[0])){deSerializedSortedMap = serializeXMLTags(objectMap, Nokia_CPQ_Constants.QTC_SIT_EXPORT_TOP_LEVEL_XML_TAGS);}
			else if(Nokia_CPQ_Constants.QTC_SIT_EXPORT_ORDER_DATA_XML_TAGS.contains(keyValuesList[0])){deSerializedSortedMap = serializeXMLTags(objectMap, Nokia_CPQ_Constants.QTC_SIT_EXPORT_ORDER_DATA_XML_TAGS);}
			else if(Nokia_CPQ_Constants.QTC_SIT_EXPORT_CONFIG_TOOL_XML_TAGS.contains(keyValuesList[0])){deSerializedSortedMap = serializeXMLTags(objectMap, Nokia_CPQ_Constants.QTC_SIT_EXPORT_CONFIG_TOOL_XML_TAGS);}
			else if(Nokia_CPQ_Constants.QTC_SIT_EXPORT_ORDERABLE_ITEMS_XML_TAGS.contains(keyValuesList[0])){deSerializedSortedMap = serializeXMLTags(objectMap, Nokia_CPQ_Constants.QTC_SIT_EXPORT_ORDERABLE_ITEMS_XML_TAGS);}
			else {deSerializedSortedMap = objectMap;}
			   
			for(string key: deSerializedSortedMap.keySet()){  
				object o = deSerializedSortedMap.get(key);
				if(o == null) { if(this.SerializeNulls)	 xmlString += wrap(key,null); }					   
				else if(o InstanceOf List<object> )		 xmlString += serialize((List<object>) o,key);
				else if(o InstanceOf Map<string,object> )   xmlString += wrap(key,serialize((Map<string,object>) o));
				else										xmlString += wrap(key,string.valueOf(o));							   
			}
			return xmlString;
		}
		
		private string serialize(List<object> objectList, string key){
			string xmlString = '';	  
		   
			for(object o:objectList){			  
				if (o InstanceOf string)				xmlString += wrap(key,string.valueOf(o));   
				else if(o InstanceOf List<object> )	 xmlString += wrap(key,serialize((List<object>) o, key));
				else									xmlString += wrap(key,serialize((Map<string,object>) o));				
			}	 
			return xmlString;
		}
		
		private string wrap(string key, string value){		   
			if(value.left(1) == '<'){value = '\n'+value;}
						   
			return (string.isNotBlank(value) || serializeNulls) ? ('<' + key + '>' + (string.isBlank(value)?'':value) + '</' + key + '>\n') : value;
		}
		
		private Map<string,object> serializeXMLTags(Map<string,object> objectMap, string tagsSequenceString){
			Map<string,object> sortedObjectMap = new Map<string,object>();
			List<string> tagsList = new List<string>();
			try {
				tagsList = tagsSequenceString.split(':');
				if(!tagsList.isEmpty()){
					for(integer i=0 ; i < tagsList.size(); i++){
						if(objectMap.containsKey(tagsList[i])){sortedObjectMap.put(tagsList[i], objectMap.get(tagsList[i]));}
					}
				}
				else {sortedObjectMap = objectMap;}
			}
			catch(Exception e){
				ExceptionHandler.addException(e,QTC_SiteXMLGeneration.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
				system.debug('Error>>>>>>>>'+e.getMessage());
			}
			return sortedObjectMap;
		}
		
		
	}
	
	public class qtcXMLConfigData {
		qtcXMLWrapper CONFIG_DATA;
		
		public qtcXMLConfigData(qtcXMLWrapper configData){
			CONFIG_DATA = configData;
		}
	}
	
	public class qtcXMLWrapper {
		public String TITLE;
		public OrderData ORDER_DATA;
		public ConfigTool CONFIG_TOOL;
		public List<OrderableItem> ORDERABLE_ITEM;
		
		public qtcXMLWrapper (String title, OrderData insOrderData, ConfigTool insConfigTool, List<OrderableItem> listOrderableItems) {
			this.TITLE = title;
			this.ORDER_DATA = insOrderData;
			this.CONFIG_TOOL = insConfigTool;
			this.ORDERABLE_ITEM = listOrderableItems;
		}
		
	}
	
	public class OrderData {
		public String SALES_ORDER;
		public String SUBORDER;
		public String SEGMENT;
		public String VERSION;
		public String OPERATION;
		public String OMS;
		public String LOGIN_ID;
		
		public OrderData (String salesOrder, String subOrder, String segment, String version, String operation, String oms, String loginId) {
			this.SALES_ORDER = salesOrder;
			this.SUBORDER = subOrder;
			this.SEGMENT = segment;
			this.VERSION = version;
			this.OPERATION = operation;
			this.OMS = oms;
			this.LOGIN_ID = loginId;
		}
	}
	
	public class ConfigTool {
		public String TOOL_NAME;
		public String TOOL_STATUS;
		public String CONFIG_ID;
		public String VINTAGE;
		
		public ConfigTool (String toolName, String toolStatus, String configId, String vintage){
			this.TOOL_NAME = toolName;
			this.TOOL_STATUS =toolStatus;
			this.CONFIG_ID = configId;
			this.VINTAGE = vintage;
		}
	}
	
	public class OrderableItem {
		public String OI_ID;
		public String OI_TITLE;
		public String OI_QTY;
		public String CONFIG_DESC;
		
		public OrderableItem (String oiId, String oiTitle, String oiQty, String configDesc){
			this.OI_ID = oiId;
			this.OI_TITLE = oiTitle;
			this.OI_QTY = oiQty;
			this.CONFIG_DESC = configDesc;
		}
	}
	
	
	public static String generateQTCSITEFile(Id quoteId, String nokiaQuoteId){
		
		String outPutStatus;
		List<Apttus_Proposal__Proposal_Line_Item__c> listOfferTypeLineItems = new List<Apttus_Proposal__Proposal_Line_Item__c>();
		List<Apttus_Proposal__Proposal_Line_Item__c> listNonOfferTypeLineItems = new List<Apttus_Proposal__Proposal_Line_Item__c>();
		List<OrderableItem> listFinalisedOrderableItems = new List<OrderableItem>();
		Map<id, Apttus_Proposal__Proposal_Line_Item__c> mapFinalisedProposalLineItems;
		
		Try{
			mapFinalisedProposalLineItems = new Map<Id, Apttus_Proposal__Proposal_Line_Item__c>([SELECT Id, Name, NokiaCPQ_Quantity__c, Apttus_Proposal__Proposal__c, Apttus_QPConfig__BasePrice__c, NokiaCPQ_Product_Name__c, Apttus_QPConfig__ChargeType__c, Product_Code__c, Apttus_Proposal__Unit_Price__c, Apttus_Proposal__Sales_Discount__c, Apttus_Proposal__Unit_Net_Price__c, Apttus_Proposal__Ext_Price__c, Apttus_Proposal__Ext_Net_Price__c, Apttus_Proposal__Service_Date__c, Apttus_QPConfig__LineType__c, Apttus_QPConfig__PrimaryLineNumber__c, Apttus_QPConfig__ParentBundleNumber__c, NokiaCPQ_Extended_IRP__c, NokiaCPQ_Unitary_IRP__c,  NokiaCPQ_Extended_CLP__c,  NokiaCPQ_Configuration_Type__c, Apttus_Proposal__Description__c, NokiaCPQ_ExtendedPrice_CNP__c, Apttus_QPConfig__LineNumber__c, Total_Option_Quantity__c,Apttus_QPConfig__Quantity2__c , NokiaCPQ_Is_Direct_Option__c, Item_Type_From_CAT__c, Apttus_Proposal__Product__r.ProductCode FROM Apttus_Proposal__Proposal_Line_Item__c WHERE Apttus_Proposal__Proposal__c =:quoteId and Apttus_QPConfig__LineType__c =: Nokia_CPQ_Constants.NOKIA_OPTION ORDER BY Apttus_QPConfig__LineNumber__c ASC]);
			
			// filter Offer Item Type 
			for(Apttus_Proposal__Proposal_Line_Item__c objProposalLineItem : mapFinalisedProposalLineItems.values()){
				if(objProposalLineItem.Item_Type_From_CAT__c != null && objProposalLineItem.Item_Type_From_CAT__c.equalsIgnoreCase( Nokia_CPQ_Constants.ITEM_TYPE_OFFER))
					listOfferTypeLineItems.add(objProposalLineItem);
				else
					listNonOfferTypeLineItems.add(objProposalLineItem);
			}
			
			// collect OrderableItems for non Offer item type
			if(!listNonOfferTypeLineItems.isEmpty())
				listFinalisedOrderableItems = generateOrderableItems(listNonOfferTypeLineItems, false, quoteId);
			
			// collect OrderableItems for Offer item type
			if(!listOfferTypeLineItems.isEmpty())
				listFinalisedOrderableItems.addAll(generateOrderableItems(listOfferTypeLineItems, true, quoteId));
			
			// collect ConfigTool class structure
			if(!listFinalisedOrderableItems.isEmpty()){
				ConfigTool clsConfigTool = new ConfigTool(Nokia_CPQ_Constants.QTC_SIT_EXPORT_IST, Nokia_CPQ_Constants.VALID, Nokia_CPQ_Constants.INDIA_V_SELECT, Nokia_CPQ_Constants.SplitLevelOne);
				
				// generate OrderData class structure
				OrderData clsOrderData = new OrderData(Nokia_CPQ_Constants.SALES_ORDER_NUMBER, Nokia_CPQ_Constants.SUBORDER_NUMBER, Nokia_CPQ_Constants.ENGLISH_ALPHABET_X, Nokia_CPQ_Constants.ZERO, Nokia_CPQ_Constants.ENGLISH_ALPHABET_R, Nokia_CPQ_Constants.ENGLISH_ALPHABET_E, UserInfo.getName());
				
				// generate Final XML wrapper
				qtcXMLWrapper clsqtcXMLWrapper = new qtcXMLWrapper(Nokia_CPQ_Constants.CONFIGURATOR_OUTPUT, clsOrderData, clsConfigTool, listFinalisedOrderableItems);
				
				qtcXMLConfigData finalXMLConfig = new qtcXMLConfigData(clsqtcXMLWrapper);
				
				XMLSerializer insSerializer = new XMLSerializer();
				String finalXML = insSerializer.serialize(clsqtcXMLWrapper, true, Nokia_CPQ_Constants.QTC_SIT_EXPORT_ROOT_XML_TAG);		  
				finalXML = finalXML.removeStart(Nokia_CPQ_Constants.NOKIA_NEW_LINE);
				
				ContentVersion newQTCFileInstance = OrderExportProvider.generateQTCFileContentVersion(finalXML, nokiaQuoteId, true);
				
				// generate ContentDocumentLink to bind with quote		  
				if(newQTCFileInstance != NULL)
					outPutStatus = OrderExportProvider.generateContDocLinkForQTC(newQTCFileInstance, quoteId);
				else
					outPutStatus = Nokia_CPQ_Constants.ALLIANCE_EXPORT_ERROR_STRING + Nokia_CPQ_Constants.ERROR_EXPORT_FILE_CREATION;
			}
			else
				outPutStatus = Nokia_CPQ_Constants.ALLIANCE_EXPORT_ERROR_STRING + Nokia_CPQ_Constants.NO_SALES_ITEM_FOR_QTC_SITE_EXPORT;
				
		}
		catch(Exception e){
			ExceptionHandler.addException(e,QTC_SiteXMLGeneration.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
			outPutStatus = Nokia_CPQ_Constants.ALLIANCE_EXPORT_ERROR_STRING +e.getMessage();
		}	
		
		return outPutStatus ;
	}
	
	public static List<OrderableItem> generateOrderableItems (List<Apttus_Proposal__Proposal_Line_Item__c> listLineItems, Boolean isOfferType, Id quoteId){
		List<OrderableItem> listOrderableItems = new List<OrderableItem>();
		Try{
			if(isOfferType){
				Set<String> setParentProductCode = new Set<String>();
				for(Apttus_Proposal__Proposal_Line_Item__c objLineItem : listLineItems)
					setParentProductCode.add(objLineItem.Product_Code__c);
				
				// get Delivery Sales Item for all 'Offer' item type SIs.
				List<Quote_Delivery_Sales_Item__c> listQuoteDeliverySalesItem = [SELECT Id, Name, Arcadia_Product_Code__c, Item_Type__c, Parent_Line_Item__c, PCI_Code__c, Product_Code__c, Quantity__c, Proposal__c, Proposal__r.NokiaCPQ_Proposal_Id__c, Parent_Line_Item__r.NokiaCPQ_Part_Number__c, Parent_Line_Item__r.Apttus_Config2__Quantity__c FROM Quote_Delivery_Sales_Item__c WHERE Proposal__c =:quoteId AND Arcadia_Product_Code__c =:setParentProductCode];
				
				Set<String> setProductCodes = new Set<String>();
				for(Quote_Delivery_Sales_Item__c objQDSItems : listQuoteDeliverySalesItem)
					setProductCodes.add(objQDSItems.Product_Code__c);
			   
			   // collect Product Code and Product name from product2 object.
				Map<String, product2> mapProdCodeProdName = new Map<String, product2>();
				for(Product2 objProd : [Select Name, ProductCode, Description FROM Product2 WHERE ProductCode =: setProductCodes]){
					mapProdCodeProdName.put(objProd.ProductCode, objProd);
				}
					
				for(Quote_Delivery_Sales_Item__c objQDSItems : listQuoteDeliverySalesItem){
					decimal quantity = objQDSItems.Quantity__c * objQDSItems.Parent_Line_Item__r.Apttus_Config2__Quantity__c;
					quantity = quantity.setScale(2, RoundingMode.FLOOR);
					
					OrderableItem clsOrderableItem = new OrderableItem(objQDSItems.Product_Code__c, mapProdCodeProdName.get(objQDSItems.Product_Code__c).Name, String.ValueOf(quantity) , objQDSItems.Parent_Line_Item__r.NokiaCPQ_Part_Number__c);
					
					listOrderableItems.add(clsOrderableItem);
				}
				
			}
			else {
				for(Apttus_Proposal__Proposal_Line_Item__c objLineItem : listLineItems){
					OrderableItem clsOrderableItem = new OrderableItem(objLineItem.Product_Code__c, objLineItem.NokiaCPQ_Product_Name__c, String.ValueOf(objLineItem.Total_Option_Quantity__c) , objLineItem.Apttus_Proposal__Product__r.ProductCode);
					
					listOrderableItems.add(clsOrderableItem);
				}
			}
		}
		catch(Exception e){
			ExceptionHandler.addException(e,QTC_SiteXMLGeneration.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
			system.debug('Error:::'+ e.getMessage());
		}
		
		system.debug('List listOrderableItems>>>>>>'+listOrderableItems);
		
		return listOrderableItems;
		
	}
	
}