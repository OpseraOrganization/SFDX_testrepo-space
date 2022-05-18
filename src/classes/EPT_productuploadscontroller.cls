public without sharing class EPT_productuploadscontroller{			  //This class is for EPT upload functionality
	// List <Apttus_CPQApi.CPQ.SelectedProductDO> sselectedProdDOList = new List <Apttus_CPQApi.CPQ.SelectedProductDO>();
	public Id proposalId;
	List<String> siteQty = new List<String>();
	Set<NokiaCPQ_Site__c> sitesToInsertset = new Set<NokiaCPQ_Site__c>();
	List<NokiaCPQ_Site__c> sitesToInsertLists = new List<NokiaCPQ_Site__c>();
	List<String> siteSet = new List<String>();
	List<String> eptsites = new List<String>();
	String finalsiteq = ',0';
	String finaltxt='';
	public Id proposalId1 {get;set;}
	public Apttus_Proposal__Proposal__c proposal;  
	public boolean readSuccess {get;set;}
	public String productDataAsString;
	public string csvAsString{get;set;}
	public Blob csvFileBody{get;set;}
	public String[] csvFileLines{get;set;}
	public Integer totalCount = 0;
	public Set<String> pCodFinalCheck = new Set<String>();
	public Id cartId;
	public List<Apttus_Config2__PriceListItem__c> productlist;
	public List<Apttus_Config2__ProductConfiguration__c> prodConfig;
	public List<Apttus_Config2__LineItem__c> LineitemEPT;
	public Set<String> inactiveID = new  Set<String>();
	public Map<String,String> pCodeQuantity = new Map<String,String>();
	public boolean isCSV = false; 
	public Boolean getisCSV(){					  //CSVFile
		return isCSV; 
	}
	public map<Id,Decimal> productmap;
	public PS_ApttusCPQWebServiceCalls acpq;
	public String errorMessageWithProducts;
	public boolean isPRM {get; set;}
	public boolean issCRM {get; set;}
	public boolean isOptics {get; set;}
	Public Map<String,String> productcodeQuantMap = new Map<String, String>();
	Public  String store = '';
	//  public List<String> siteCount; 
	Integer flag=0;
	String Value;
	
	//RG: 21/08/2019 For SourceType Start
	public string selectedSource{get;set;}

	public List<NokiaCPQ_Site__c> sitesExistingRecords;
	public List<SelectOption> getsourceType() {
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('EPT','EPT'));
		options.add(new SelectOption('Wavelite','Wavelite'));
		return options;
	}
	//RG: 21/08/2019 For SourceType End
	
	Public Map<String,String> productCodeToPortfolioMap = new Map<String,String>();
	Public Map<String,String> productCodeToPCMap = new Map<String,String>(); 
	
	public  List <Apttus_CPQApi.CPQ.SelectedProductDO> selectedProdDOList = new List <Apttus_CPQApi.CPQ.SelectedProductDO>();
	//Added by Christie JJ: Requirement 6987
	public List<String> uploadedFiles = new List<String>();
	public String priorUploadedFiles {get; set;}
	//Added by Christie JJ: Requirement 4374
	public Map<String,Apttus_CPQApi.CPQ.SelectedProductDO> pcodePDOmap = new Map<String,Apttus_CPQApi.CPQ.SelectedProductDO>();
	public  EPT_productuploadscontroller(Apexpages.Standardcontroller controller)	   //This is for the controller of the Apex Page
	{
		//Added by Christie JJ: Requirment 6987
		priorUploadedFiles = '';
		proposalId = ApexPages.currentPage().getParameters().get(GlobalConstants.PROPOSALID);
		system.debug('proposalId'+proposalId);
		proposalId1 = ApexPages.currentPage().getParameters().get(GlobalConstants.PROPOSALID);
		readSuccess = FALSE;
		acpq = new PS_ApttusCPQWebServiceCalls();
		productlist = new List<Apttus_Config2__PriceListItem__c>();
		productmap = new map<Id,Decimal>();
		if(proposalId != null){
			proposal = [Select Id,Apttus_Proposal__Opportunity__c,NokiaCPQ_Portfolio__c, Apttus_QPConfig__PriceListId__c,
						NokiaCPQ_Environment_Access_Type__c,CPQ_PortfolioClusterSF1__c,CPQ_PortfolioClusterSF2__c,
						CPQ_PortfolioClusterSF3__c,CPQ_PortfolioClusterSF4__c,EPT_Sites__c,Turbo_Pricing_Enable__c,Quote_Type__c,
						APTS_ConfigureProductsTP__c,Configure_button_field_TP__c,Configure_grid_flow_button__c,Configure_button_field__c,
						Is_Turbo_Pricing__c, Is_Classic_Pricing__c from Apttus_Proposal__Proposal__c where Id =:proposalId Limit 1];
			
			prodConfig = [Select Id ,Apttus_Config2__Status__c from Apttus_Config2__ProductConfiguration__c 
							where Apttus_QPConfig__Proposald__c =: proposalId 
							AND (Apttus_Config2__Status__c =: GlobalConstants.FINALIZED 
							OR Apttus_Config2__Status__c =: GlobalConstants.SAVED)];
		}
		
		if(proposal.NokiaCPQ_Portfolio__c != GlobalConstants.PORTFOLIO){
			isOptics = false;
		}
		else
			isOptics=true;
		
		if(proposal.NokiaCPQ_Environment_Access_Type__c.equalsIgnoreCase(GlobalConstants.ENVIRONMENT)){
			isPRM = true;
			issCRM = false;
		}
		else{
			isPRM = false;
			issCRM = true;
		}
	}
	//This reads the data from the file
	public void readFromFile(){
		system.debug('readFromFile>>>');
		if(csvAsString != null && csvFileBody != null){
			String extension = csvAsString.substring( csvAsString.lastIndexOf(GlobalConstants.FULLSTOP)+1);
			
			try{ 
				if(extension.equalsIgnoreCase(GlobalConstants.EXTSMALL) ||extension.equalsIgnoreCase(GlobalConstants.EXTCAPS)){
					//if(csvFileBody !=null){
					readCSVFile();
					
					//}
					
				}
				else{
					ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'File type should be csv type');
					ApexPages.addMessage(errormsg); 
				}  
			}
			catch(exception e){
				readSuccess = FALSE;
				//ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,Label.PS_CSV_Error);
				ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,GlobalConstants.APEXMESSAGE4);
				ApexPages.addMessage(errorMessage); 
			}
		}
		else{
			ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,GlobalConstants.APEXMESSAGE5);
			ApexPages.addMessage(errorMessage);
		}
	}   
	/*-------------------------------logic to insert config lineitem------------------------*/
	public void readCSVFile()
	{
		system.debug('readCSVFile>>>');
		//Added by Christie JJ: Requirement 4374
		finaltxt = '';
		selectedProdDOList.clear();
		//Added by Christie JJ: Requirement 4374(ITCCPQ-817)
		store = '';
		try{
			//system.debug('readCSVFile::::');
			List<String> prodconfigid = new List<String>();
			if(!prodConfig.isEmpty()){
				for(Apttus_Config2__ProductConfiguration__c config: prodConfig){
					prodconfigid.add(config.Id);
				}
				if(!prodconfigid.isEmpty()){
					LineitemEPT = [Select Id,Source__c from Apttus_Config2__LineItem__c where Source__c =: selectedSource AND Apttus_Config2__ConfigurationId__c IN: prodconfigid];
					// if(!LineitemEPT.isEmpty()) //RG: 21-08-2019 Req-6428 GlobalConstants.SOURCE 
					if(!LineitemEPT.isEmpty() && LineitemEPT != NULL ){
						delete LineitemEPT;
						proposal.EPT_Sites__c = GlobalConstants.NOTHING;
					}
				}
			}
			
			//  public Boolean wrongProdFlag;
			set<String> pCode = new set<String>();
			Set<String> pCodList = new Set<String>();
			//Set<String> siteSet = new Set<String>();
			Map<String,String> pCodeQuantity = new Map<String,String>();
			Map<String,String> pCodeCount =new Map<String,String>();
			List<String> csvRecordData;  
			Map<String,ID> siteNameIDMap = new Map<String,ID>();
			Set<String> productCodeSet = new Set<String>();
			Set<String> productCodeSet2 = new Set<String>();
			Map<String,ID> productCodeIDMap = new Map<String,ID>();
			Map<String,Integer> concatenateProductIDSiteIDQuantityMap = new Map<String,Integer>();
			Map<String,Integer> productCodeQuantityMap = new Map<String,Integer>();
			Map<Id,Integer> productIdQuantitymap = new Map<Id,Integer>();
			productDataAsString = csvFileBody.toString();
			Integer acronymStarts = 0;
			if(productDataAsString.contains(GlobalConstants.SEMICOLONMM)){		 //EPT Upload
				csvFileLines = productDataAsString.split(GlobalConstants.ENTER);
				for(integer i=0;i<csvFileLines.size();i++){
					
					
					csvRecordData = csvFileLines[i].split(GlobalConstants.SEMICOLONMM);
					if(csvRecordData[0] != null && csvRecordData[0].equalsignorecase(GlobalConstants.IGNORECASE)){
						acronymStarts = i; 
					}
					productDataAsString = productDataAsString.trim();
				}
				if(csvFileLines.size()>1){  
					csvRecordData = csvFileLines[acronymStarts].split(GlobalConstants.SEMICOLONMM); 
				}
				for(Integer i=5;i<csvRecordData.size();i++){ 
					if(!(GlobalConstants.SMSTOOL.equals(csvRecordData[i]) || GlobalConstants.NSPTOOL.equals(csvRecordData[i].trim()))){
						siteSet.add(csvRecordData[i]);
					}
				}
				system.debug('siteSet>>>>>>'+siteSet);
				for(String a :siteSet) {
					finaltxt= finaltxt+a+GlobalConstants.COMMAS;  
				}
				finaltxt = finaltxt.removeEnd(GlobalConstants.COMMAS);
				proposal.EPT_Sites__c = finaltxt;
				csvFileLines = productDataAsString.split(GlobalConstants.ENTER);
				//System.debug('csvFileLines-->'+csvFileLines);
				if(csvFileLines.size()>1){
					csvRecordData = csvFileLines[1].split(GlobalConstants.SEMICOLONMM); 
				}
				String []correctcsv;
				//System.debug('csvRecordData-->'+csvRecordData);
				
				for(integer i=acronymStarts+2;i<csvFileLines.size();i++){
					String siteCount='';
					String []csvfromProdCode  = csvFileLines[i].split(GlobalConstants.SEMICOLONMM);
					if(csvfromProdCode.size()>4){
						pCodeQuantity.put(csvfromProdCode[2].trim(),csvfromProdCode[4]);
					}
					
					if(csvfromProdCode.size()>2){
						pCode.add(csvfromProdCode[2]);  
					}
					
					// System.debug('correctcsv size-  else--->'+correctcsv.size());
					totalCount = 0;
					for(integer j=5;j<csvfromProdCode.size();j++){
						if(!String.isEmpty(csvfromProdCode[j]) && !String.isEmpty(csvfromProdCode[2]) && selectedSource.equalsIgnoreCase(GlobalConstants.WAVELITESOURCE)){
							totalCount = Integer.valueOf(csvfromProdCode[j].replace('(-)','0').trim()) + totalCount;
						}
						siteCount=siteCount+csvfromProdCode[j].replace('(-)','0')+GlobalConstants.COMMAS;
					}
					if(totalCount==0 && selectedSource.equalsIgnoreCase(GlobalConstants.WAVELITESOURCE)){
						if(!finaltxt.contains('Assigned')){
							finaltxt = finaltxt+GlobalConstants.COMMAS+'No Site Assigned';
						}
						siteCount = siteCount + csvfromProdCode[4].replace('(-)','0');
					}
					siteCount.removeEnd(GlobalConstants.COMMAS);
					//System.debug('siteCount-->'+siteCount);
					if(csvfromProdCode.size()>2){
						pCodeCount.put(csvfromProdCode[2].trim(),siteCount.removeEnd(GlobalConstants.COMMAS));
					}
				}
			}
			else									  //EPT Upload
			{
				csvFileLines = productDataAsString.split(GlobalConstants.ENTER);
				for(integer i=0;i<csvFileLines.size();i++){  
					csvRecordData=removedelimier(',',csvFileLines[i]); 
					//system.debug('lines-----'+csvRecordData);  
					if(csvRecordData[0] != null && csvRecordData[0].equalsignorecase(GlobalConstants.IGNORECASE)){  
						acronymStarts = i; 
					}
					productDataAsString = productDataAsString.trim(); 
				}   
				if(csvFileLines.size()>1){	 
					csvRecordData =removedelimier(',',csvFileLines[acronymStarts]);
					
				}
				
				for(Integer i=5;i<csvRecordData.size();i++){ 
					if(!(GlobalConstants.SMSTOOL.equals(csvRecordData[i]) || GlobalConstants.NSPTOOL.equals(csvRecordData[i].trim()))){ 
						siteSet.add(csvRecordData[i]);
					}
				}
				System.debug('siteSet2-->'+siteSet);
				for(String a :siteSet) {
					finaltxt= finaltxt+a+GlobalConstants.COMMAS;
				}
				
				
				finaltxt = finaltxt.removeEnd(GlobalConstants.COMMAS);
				proposal.EPT_Sites__c = finaltxt;
				csvFileLines = productDataAsString.split(GlobalConstants.ENTER);
				
				if(csvFileLines.size()>1){  
					csvRecordData = csvFileLines[1].split(GlobalConstants.COMMAS); 
				}
				String []correctcsv;
				String line;
				String []assignline;
				for(integer i=acronymStarts+2;i<csvFileLines.size();i++){
					String siteCount='';	 
					if(csvFileLines[i].startsWith(GlobalConstants.DOUBLEINVERTEDCOMMAS)){		
						//system.debug('lines4-----'+csvFileLines[i]);
						line = csvFileLines[i].substringAfter(GlobalConstants.INVERTEDCOMMA);
						if(line.contains(GlobalConstants.DOUBLEINVERTEDCOMMAS)){
							String []csvfromProdCode = line.split(GlobalConstants.INVERTEDCOMMA);
							if(csvfromProdCode.size()>1){
								correctcsv=csvfromProdCode[1].split(GlobalConstants.COMMAS);
							}
							if(correctcsv.size()>2){
								pCodeQuantity.put(correctcsv[0].trim(),correctcsv[2]);  
							}
							if(correctcsv.size()>0){
								pCode.add(correctcsv[0]);  
							}
							totalCount = 0;
							for(integer j=3;j<correctcsv.size();j++){
								if(!String.isEmpty(csvfromProdCode[j]) && !String.isEmpty(csvfromProdCode[2]) && selectedSource.equalsIgnoreCase(GlobalConstants.WAVELITESOURCE)){
									totalCount = Integer.valueOf(csvfromProdCode[j].replace('(-)','0').trim()) + totalCount;
								}
								siteCount=siteCount+correctcsv[j]+GlobalConstants.COMMAS;	 
							}
							if(totalCount==0 && selectedSource.equalsIgnoreCase(GlobalConstants.WAVELITESOURCE)){
								if(!finaltxt.contains('Assigned')){
									finaltxt = finaltxt+GlobalConstants.COMMAS+'No Site Assigned';
								}
								siteCount = siteCount + csvfromProdCode[4].replace('(-)','0');
							}
							siteCount.removeEnd(GlobalConstants.COMMAS);
							//System.debug('siteCount 2-->'+siteCount);
							pCodeCount.put(correctcsv[0].trim(),siteCount.removeEnd(GlobalConstants.COMMAS));
						}
						else{
							String []csvfromProdCode  = line.split(GlobalConstants.COMMAS);
							if(csvfromProdCode.size()>2){
								pCodeQuantity.put(csvfromProdCode[1].trim(),csvfromProdCode[3]);
							}
							if(csvfromProdCode.size()>1)
								pCode.add(csvfromProdCode[1]);
							totalCount = 0;							
							for(integer j=4;j<csvfromProdCode.size();j++){
								if(!String.isEmpty(csvfromProdCode[j]) && !String.isEmpty(csvfromProdCode[2]) && selectedSource.equalsIgnoreCase(GlobalConstants.WAVELITESOURCE)){
									totalCount = Integer.valueOf(csvfromProdCode[j].replace('(-)','0').trim()) + totalCount;
								}
								siteCount = siteCount+csvfromProdCode[j]+GlobalConstants.COMMAS;
							}
							if(totalCount==0 && selectedSource.equalsIgnoreCase(GlobalConstants.WAVELITESOURCE)){
								if(!finaltxt.contains('Assigned')){
									finaltxt = finaltxt+GlobalConstants.COMMAS+'No Site Assigned';
								}
								siteCount = siteCount + csvfromProdCode[4].replace('(-)','0');
							}
							siteCount.removeEnd(GlobalConstants.COMMAS);
							//System.debug('siteCount 3-->'+siteCount);
							if(csvfromProdCode.size()>1)	  
								pCodeCount.put(csvfromProdCode[1].trim(),siteCount.removeEnd(GlobalConstants.COMMAS));
						}
					}
					else{
						String []csvfromProdCode=removedelimier(',',csvFileLines[i]);
						//System.debug('csvfromProdCode-->'+csvfromProdCode);
						if(csvfromProdCode.size()>4){
							pCodeQuantity.put(csvfromProdCode[2].trim(),csvfromProdCode[4]);
						}
						if(csvfromProdCode.size()>2)
							pCode.add(csvfromProdCode[2]);	   
						
						totalCount = 0;
						for(integer j=5;j<csvfromProdCode.size();j++){
							if(!(GlobalConstants.SMSTOOL.equals(csvRecordData[j]) || GlobalConstants.NSPTOOL.equals(csvRecordData[j].trim()))){ 
								if(!String.isEmpty(csvfromProdCode[j]) && !String.isEmpty(csvfromProdCode[2]) && selectedSource.equalsIgnoreCase(GlobalConstants.WAVELITESOURCE)){
									totalCount = Integer.valueOf(csvfromProdCode[j].replace('(-)','0').trim()) + totalCount;
								}
								siteCount=siteCount+csvfromProdCode[j].replace('(-)','0')+GlobalConstants.COMMAS;
								
							}
						}
						
						if(totalCount==0 && selectedSource.equalsIgnoreCase(GlobalConstants.WAVELITESOURCE)){
							if(!finaltxt.contains('Assigned')){
								finaltxt = finaltxt+GlobalConstants.COMMAS+'No Site Assigned';
							}
							siteCount = siteCount + csvfromProdCode[4].replace('(-)','0');
						}
						//system.debug('finaltxt'+finaltxt);
						//system.debug('siteCount'+siteCount);
						siteCount.removeEnd(GlobalConstants.COMMAS);
						//System.debug('siteCount 5-->'+siteCount);
						siteCount = siteCount.trim();
						if(csvfromProdCode.size()>2)
							pCodeCount.put(csvfromProdCode[2].trim(),siteCount.removeEnd(GlobalConstants.COMMAS));
						// }
						
					}
				}
			}
			
			if(!pCode.isEmpty() && pCode !=null){
				for(String s:pCode){
					pCodList.add(s.trim());
				}
			}
			Map<String,id> pcodeIdMap = new Map<String,id>();	 
			
			Set<String> pCodListActive = new Set<String>();
			// Below List created to store productcode for Req. 4064  
			List<Product2> prodcodefinallist = new List<Product2>();
			if(!pCodList.isEmpty() && pCodList !=null){
				// Start by Chhedika for Req. 4064  
				Set<String> combinedlist = new Set<String>();
				Set<String> pCodListActiveAA = new Set<String>();
				Map<String,Integer> prodcodefound = new Map<String,Integer>();
				Map<String,Integer> prodcodefoundxx = new Map<String,Integer>();
				Map<String,Integer> prodcodefoundtw = new Map<String,Integer>();
				Map<String,String> prodcodexx = new Map<String,String>();
				Map<String,String> prodcodeaa = new Map<String,String>();
				List<Product2> prodcodelist = new List<Product2>();
				string portfoliocontains = '%'+proposal.NokiaCPQ_Portfolio__c+'%';
				prodcodelist = [select Apttus_Config2__Version__c,id,productcode,Portfolio__c,Pricing_Clusters__c,Pricing_Clusters_Search_Filter__c from product2 where IsActive = TRUE AND portfolio__c like : portfoliocontains AND productcode in : pCodList];  //RG: 12-8-2019 for Req 6428  //ITCCPQ-2594
				integer i =0 ;
				for(Product2 pnot : prodcodelist){
					prodcodefound.put(pnot.productcode,i++);
					prodcodefinallist.add(pnot);
				}
				if(prodcodelist.size() != pCodList.size()){
					for(String prodcd : pCodList){
						if(!prodcodefound.containskey(prodcd) && prodcd.length() == 10 ){
							string prodcodeten ='';
							prodcodeten = prodcd + GlobalConstants.PRODUCTCODE;
							combinedlist.add(prodcodeten);
							prodcodexx.put(prodcodeten,prodcd);
						}
						else if(!prodcodefound.containskey(prodcd) && prodcd.length() ==12){
							string prodt = ''; 
							prodt = prodcd.left(10) +GlobalConstants.PRODUCTCODE;
							integer y = 0;
							prodcodefoundtw.put(prodt,y++);
							combinedlist.add(prodt);
							prodcodeaa.put(prodt,prodcd);
						}
					}
					if(combinedlist.size()>0){
						List<Product2> prodcodelistxx = new List<Product2>();
						prodcodelistxx = [select Apttus_Config2__Version__c,id,productcode,Portfolio__c,Pricing_Clusters__c,Pricing_Clusters_Search_Filter__c from product2 where IsActive = TRUE AND productcode in : combinedlist];
						integer x =0 ;
						for(Product2 pnot : prodcodelistxx){
							prodcodefoundxx.put(pnot.productcode,x++);
							prodcodefinallist.add(pnot);
						}
						if(prodcodelistxx.size() != combinedlist.size()){
							for(String prodcdxx : combinedlist){
								if(!prodcodefoundxx.containskey(prodcdxx) && !prodcodefoundtw.containskey(prodcdxx)){
									string addAAprdcode = '';
									addAAprdcode = prodcdxx.left(10) +GlobalConstants.PRODUCTCODEAA;
									pCodListActiveAA.add(addAAprdcode);
									prodcodexx.put(addAAprdcode,prodcdxx.left(10));
								}
							}
						}
						if(pCodListActiveAA.size()>0) {
							List<Product2> prodcodelistAA = new List<Product2>();
							prodcodelistAA = [select Apttus_Config2__Version__c,id,productcode,Portfolio__c,Pricing_Clusters__c,Pricing_Clusters_Search_Filter__c from product2 where IsActive = TRUE AND productcode in : pCodListActiveAA];
							if(prodcodelistAA.size()>0){
								prodcodefinallist.addAll(prodcodelistAA);
							}
						}
					}
				}
				for(Product2 prod :prodcodefinallist){
					try{   
						string onlyinloop ='';
						if(prodcodexx.size()>0 && prodcodexx.containskey(prod.productcode)){
							if(prodcodexx.get(prod.productcode)!=null || prodcodexx.get(prod.productcode)!= GlobalConstants.NOTHING){
								pCodListActive.add(prodcodexx.get(prod.productcode));
								onlyinloop = prodcodexx.get(prod.productcode);
							}
						}
						else if(prodcodeaa.size()>0 && prodcodeaa.containskey(prod.productcode)){
							if(prodcodeaa.get(prod.productcode)!=null || prodcodeaa.get(prod.productcode)!=GlobalConstants.NOTHING){
								pCodListActive.add(prodcodeaa.get(prod.productcode));
								onlyinloop = prodcodeaa.get(prod.productcode);
							}
						}
						else{
							pCodListActive.add(prod.productcode);
							onlyinloop = prod.productcode;
						}
						// END By Chhedika for Req. 4064  
						
						pcodeIdMap.put(prod.productcode,prod.id);   
						productCodeToPortfolioMap.put(prod.productcode,prod.Portfolio__c);  
						productCodeToPCMap.put(prod.productcode,prod.Pricing_Clusters_Search_Filter__c); 
						string prdfinalcode = ''; 
						boolean inactiveprd = false;
						List<String> siteQty = new List<String>();
						List<String> eptsites = new List<String>();
						String finalsiteq = ',0';
						
						if(((productCodeToPortfolioMap.get(prod.ProductCode).equalsignorecase(proposal.NokiaCPQ_Portfolio__c)) 
							&& (productCodeToPCMap.get(prod.ProductCode).contains(proposal.CPQ_PortfolioClusterSF1__c)
								|| productCodeToPCMap.get(prod.ProductCode).contains(proposal.CPQ_PortfolioClusterSF2__c)
								|| productCodeToPCMap.get(prod.ProductCode).contains(proposal.CPQ_PortfolioClusterSF3__c)
								|| productCodeToPCMap.get(prod.ProductCode).contains(proposal.CPQ_PortfolioClusterSF4__c))) 
							|| Test.isRunningTest()){
							inactiveprd = true;
							pCodFinalCheck.add(prod.productcode);
							prdfinalcode =prod.productcode;
							Apttus_CPQApi.CPQ.SelectedProductDO SelectedProductDOInstance = new Apttus_CPQApi.CPQ.SelectedProductDO();
							Id prodIdList =pcodeIdMap.get(prod.productcode);
							
							SelectedProductDOInstance.ProductId = pcodeIdMap.get(prod.productcode);
							List<String> customFields = new List<String>();
							customFields.add(GlobalConstants.SITEQUANTITY);
							customFields.add(GlobalConstants.SITE);  
							customFields.add(GlobalConstants.SOURCEFIELD);
							customFields.add(GlobalConstants.QUANTITYMODIFIABLE);
							customFields.add(GlobalConstants.PRODUCTVERSION);  
							
							SelectedProductDOInstance.CustomFields = customFields;
							Apttus_Config2__LineItem__c customData = new Apttus_Config2__LineItem__c();
							CustomData.Apttus_Config2__ProductVersion__c = prod.Apttus_Config2__Version__c; 
							CustomData.EPT_Sites__c = finaltxt;
							//6987
							
							if(String.isNotBlank(finaltxt)){
								eptsites.addAll(finaltxt.split(GlobalConstants.COMMAS));
								//System.debug('[+] 1st IF');
							}
							if(String.isNotBlank(pCodeCount.get(onlyinloop))){
								siteQty.addAll(pCodeCount.get(onlyinloop).split(GlobalConstants.COMMAS));
								//System.debug('[+] 2ndst IF');
							}
							
							if(eptsites.size() > siteQty.size()){
								//System.debug('[+] 3rd IF');
								for(integer j=0;j< (eptsites.size()-siteQty.size());j++){
									finalsiteq =pCodeCount.get(onlyinloop)+finalsiteq;
								}
								
							}
							else{
								//System.debug('[+] 3rd else');
								finalsiteq =pCodeCount.get(onlyinloop);
							}
							
							
							CustomData.EPT_Site_Quantity__c=finalsiteq;
							// Changed below get value for Req. 4064 because in onlyinloop variable we are storing exact value  
							// CustomData.EPT_Site_Quantity__c=pCodeCount.get(onlyinloop);//Count ;//pCodeCount.get(prod.productcode);//sitecountlist;
							//RG:21-08-19 Req-6428 CustomData.Source__c =GlobalConstants.SOURCE;
							CustomData.Source__c = selectedSource;
							CustomData.Apttus_Config2__IsQuantityModifiable__c =false;
							SelectedProductDOInstance.CustomData = customData;
							SelectedProductDOInstance.Quantity = decimal.valueOf(pCodeQuantity.get(onlyinloop)); 
							selectedProdDOList.add(SelectedProductDOInstance);
						}
						else{  
							if(inactiveprd==false){
								// Below change added for req. 4064
								inactiveID.add(onlyinloop);
							}
						}
					}
					catch(Exception e){
						ExceptionHandler.addException(e,EPT_productuploadscontroller.class.getName(),GlobalConstants.ERROR_ST);
					}
					
					
				}
				if(pCodList!=null && pCodListActive!=null && !pCodList.isEmpty()){
					for(String garbageValue : pCodList){
						if(String.isNotBlank(garbageValue) && !pCodListActive.contains(garbageValue)){
							store= store+garbageValue+GlobalConstants.COMMAS ;
						}
						// store = store.removeEnd(',');  
					}
					if(store.endsWith(GlobalConstants.COMMAS)){ 
						String value = store;
						value= value.removeEnd(GlobalConstants.COMMAS);
						if(value.endsWith(GlobalConstants.COMMAS)){
							store = store.removeEnd(GlobalConstants.COMMAS);
						}
					}
					If(inactiveID!=null && !inactiveID.isEmpty()){
						for(String inactivePro : inactiveID){
							if(inactivePro!=null){
								store= store+inactivePro+GlobalConstants.COMMAS ;
							}
						}
					}
					
				}
			}
			
			//Added by Christie JJ for rqmt 6987
			uploadedFiles.add(csvAsString);
			priorUploadedFiles = String.join(uploadedFiles,' , ');
			
		}   
		catch(Exception e){
			ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,GlobalConstants.APEXMESSAGE6);
			ApexPages.addMessage(errorMessage);
		}
	}
	
	
	/******  on close return to Proposal *******/
	public PageReference  returntoquote(){
		PageReference pg = new PageReference('/'+proposalId);   
		try{
			pg.setRedirect(true);
		}
		catch(Exception e){
			ExceptionHandler.addException(e,EPT_productuploadscontroller.class.getName(),GlobalConstants.ERROR_ST);
		} 
		return pg;
	}
	
	/******  on close return to Proposal cart *******/
	public PageReference  returntocart(){
		//PageReference pg1 = new PageReference(GlobalConstants.URLLINK1+proposalId+GlobalConstants.URLLINK2);   
		PageReference pg1 = new PageReference(Nokia_CPQ_Utility.updateQuoteAndRedirect(proposal));
		system.debug('pg1>>>>>'+pg1);
		try{

			pg1.setRedirect(true);
		}
		catch(Exception e){
			ExceptionHandler.addException(e,EPT_productuploadscontroller.class.getName(),GlobalConstants.ERROR_ST);
		}
		return pg1;	 
	}
	
	/******  Create a Cart for the proposal *******/
	public void createcart(){
		system.debug('createcart>>>');
		
		system.debug('[+] Inside createCart');
		
		sitesExistingRecords = new List<NokiaCPQ_Site__c>();
		
		try{ if(proposalId != null && proposal.NokiaCPQ_Portfolio__c != GlobalConstants.PORTFOLIO2){
			
			aggregateDuplicates(selectedProdDOList);
			//system.debug('[+] finished aggregating duplicates');
		}
			
			else{
				ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,GlobalConstants.APEXMESSAGE7);
				ApexPages.addMessage(errorMessage);
			}
			//Removed as part of rqmt 4378
			//addProducttoLineItem(cartId);
			
		   }
		catch(Exception e){
			ExceptionHandler.addException(e,EPT_productuploadscontroller.class.getName(),GlobalConstants.ERROR_ST);
		}
		// added SOURCE check for site phase qty=> Surinder
		if(selectedSource.equalsIgnoreCase(GlobalConstants.WAVELITESOURCE)  || selectedSource.equalsIgnoreCase(GlobalConstants.SOURCE)){
			List<NokiaCPQ_Site__c> siteList = [SELECT ID, Name FROM NokiaCPQ_Site__c WHERE Opportunity__c  = : proposal.Apttus_Proposal__Opportunity__c];
			Map<String,NokiaCPQ_Site__c> opptySite = new Map<String,NokiaCPQ_Site__c>();
			for(NokiaCPQ_Site__c oppSite : siteList){
				opptySite.put(oppSite.Name, oppSite);
			}
			for(String siteName : siteSet){
				//System.debug('RG:siteName--->'+siteName);
				String siteNameTm = siteName.trim();
				if(!opptySite.containsKey(siteNameTm)){
					NokiaCPQ_Site__c siteRecord = new NokiaCPQ_Site__c();
					siteRecord.Name = siteNameTm;
					siteRecord.Opportunity__c = proposal.Apttus_Proposal__Opportunity__c;
					sitesToInsertLists.add(siteRecord);
				}
				else if(opptySite.containsKey(siteNameTm)){
					sitesExistingRecords.add(opptySite.get(siteNameTm));
				}
			}

			if(!sitesToInsertLists.isEmpty()){
				insert sitesToInsertLists;
				sitesExistingRecords.addAll(sitesToInsertLists);
			}

		}	
	}
	//This adds Products to the the Line Item
	public void addProducttoLineItem(Id cartId){

		if(cartID != null){
			Apttus_CPQApi.CPQ.AddMultiProductRequestDO lineItemRecords = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
			lineItemRecords.cartID = cartID;
			lineItemRecords.SelectedProducts = selectedProdDOList;
			Apttus_CPQApi.CPQ.AddMultiProductResponseDO lineItemRecordsResponse = Apttus_CPQApi.CPQWebService.addMultiProducts(lineItemRecords);
			
			
			try{
				if(!selectedProdDOList.isEmpty()) {
					update proposal;
				}
			}
			catch(Exception e){
				ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,GlobalConstants.APEXMESSAGE8);
				ApexPages.addMessage(errorMessage);
			}
		}
	}
	/******* Add products selected from the CSV file to Cart *******/ 
	public void addProductsfromfile(){
		
	}
	
	/******  Reprice the cart *******/
	public void Reprice(){
		try{if(cartId != null){
			acpq.RepriceProposal(cartId);
		}
		   }
		catch(Exception e){
			ExceptionHandler.addException(e,EPT_productuploadscontroller.class.getName(),GlobalConstants.ERROR_ST);
		}
	}
	/****** START -- Return Products which are Not Found for Generalised Solution to display it in proper lines ******/
	public List<string> notfoundprdct(String store){
		integer storellength = store.length();
		integer dividedtime =0;
		string str = '';
		if(store!=GlobalConstants.NOTHING){
			str = store;
		}
		// string noproducts = '';
		List<string> msgi = new List<String>();
		try{if(storellength>150){
			dividedtime =storellength/150;
			for(integer i=0; i<dividedtime; i++){
				integer storellengthleft = 0;
				integer storellengthright = 0;
				string leftstr = '';
				storellengthleft = 150;
				leftstr  = str.left(storellengthleft);
				storellength = str.length();
				integer fc = leftstr.reverse().indexof(GlobalConstants.COMMAS);
				if(fc!=0){
					storellengthleft = 150 - fc;
				}
				else{
					storellengthleft = 150;
				}
				storellengthright =  storellength - storellengthleft ;
				if(storellengthright>150){
					string xyz = GlobalConstants.BREAKLINE +str.left(storellengthleft);
					msgi.add(xyz);
				}
				else{
					string breakstr = GlobalConstants.BREAKLINE +str.left(storellengthleft) +GlobalConstants.BREAKLINE + str.right(storellengthright);
					msgi.add(breakstr);
				}
				str = str.right(storellengthright);
			}
		}
			else{
				if(str!=GlobalConstants.NOTHING){
					msgi.add(str);
				}
			}
		   }
		catch(Exception e){
			ExceptionHandler.addException(e,EPT_productuploadscontroller.class.getName(),GlobalConstants.ERROR_ST);
		}
		return msgi; 
		
	}
	
	
	/****** END-- Return Products which are Not Found for Generalised Solution to display it in proper lines ******/
	/***** Save The cart *********/
	public void Saveconfig(){

		//Removed as part of rqmt 4374(ITCCPQ-817) by Christie JJ(Standav)  
		if(csvFileBody !=null){
			//acpq.saveCart(cartId);
			String finlstr = '';
			string msgi = '';
			List<String> breakstring = new List<String>();
			ApexPages.Message errorMessage;
			if(!pCodFinalCheck.isEmpty() && pCodFinalCheck != null){	
				errorMessage = new ApexPages.Message(ApexPages.Severity.Info,GlobalConstants.APEXMESSAGE1);
				ApexPages.addMessage(errorMessage);
			}
			else{
				errorMessage = new ApexPages.Message(ApexPages.severity.Info,GlobalConstants.APEXMESSAGE2);
			}
			if(!String.isBlank(store) && !String.isEmpty(store) && store!=GlobalConstants.NULLWORD && store!=null){
				//wrongProdFlag = true;
				if(store.contains(GlobalConstants.COMMANULL)){
					store = store.remove(GlobalConstants.COMMANULL);
				}
				if(store.endswith(GlobalConstants.COMMAS)){
					store = store.removeEnd(GlobalConstants.COMMAS);
				}
				if(store.startswith(GlobalConstants.COMMAS))
					store = store.removestart(GlobalConstants.COMMAS);
				List<String> prodnotfnd = new List<String>();
				//Calling notfoundprdct method to get the string in proper format by Chhedika  
				if(store!=GlobalConstants.NOTHING){
					prodnotfnd = notfoundprdct(store);
					string noproducts ='';
					if(prodnotfnd.size()>0)
					{
						for(integer i =0; i<prodnotfnd.size();i++){
							if(prodnotfnd[i]!=null){
								noproducts = noproducts +prodnotfnd[i];
							}
						}
					}  
					msgi = GlobalConstants.MESSAGE1 + noproducts;
				}
				else{
					msgi = GlobalConstants.MESSAGE1 + store;
				}
				ApexPages.Message  errorMessage2 = new ApexPages.Message(ApexPages.Severity.Info,msgi);
				ApexPages.addMessage(errorMessage2);
			}
			// For rules that are not marked as Check on Finalization
			
		}
		isCSV = true;
	}
	
	/******  Finalize the cart *******/ 
	public void Finalize(){
		try{
			if(cartId != null && proposal.NokiaCPQ_Portfolio__c != GlobalConstants.PORTFOLIO2){
				acpq.Finalizeproposal(cartId);
				ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.Info,GlobalConstants.APEXMESSAGE9);
				ApexPages.addMessage(errorMessage);
			}
			else{
				ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,GlobalConstants.APEXMESSAGE7);
				ApexPages.addMessage(errorMessage);
			}
		}
		catch(Exception e){
			ExceptionHandler.addException(e,EPT_productuploadscontroller.class.getName(),GlobalConstants.ERROR_ST);
		}
	}
	/***** Set the five values ******/
	public void setCSVFile(){

		try{
			if(csvAsString != null){
				String extension = csvAsString.substring( csvAsString.lastIndexOf(GlobalConstants.FULLSTOP)+1);
				if(!extension.containsIgnoreCase(GlobalConstants.EXTSMALL)){
					isCSV = true;
					ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,GlobalConstants.APEXMESSAGE3);
					ApexPages.addMessage(errormsg);
				}
				else{
					isCSV = false;
				}
				if(proposal.NokiaCPQ_Portfolio__c != GlobalConstants.PORTFOLIO2){
					//system.debug('csvAsStringin set :'+csvAsString);
					//system.debug('csvFileBody :'+csvFileBody); 
				}
				else{
					ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,GlobalConstants.APEXMESSAGE7);
					ApexPages.addMessage(errorMessage);
				}
				
				//Added by Christie JJ for rqmt 6987
				if(uploadedFiles.contains(csvAsString)){
					isCSV = true;
					ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,GlobalConstants.DUPLICATE);
					ApexPages.addMessage(errorMessage);
					
				}
				else
					isCSV = false;
			}
			else{
				ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,GlobalConstants.APEXMESSAGE5);
				ApexPages.addMessage(errormsg);
			}
		}
		catch(Exception e){
			ExceptionHandler.addException(e,EPT_productuploadscontroller.class.getName(),GlobalConstants.ERROR_ST);
		}
	}
	
	public List<String> removedelimier(string str,string lineString){
		List<String> finalString = new List<String>();
		String csvLine = lineString;
		String prevLine = csvLine;
		Integer startIndex;
		Integer endIndex;
		while(csvLine.indexOf('"') > -1){
			if(startIndex == null){
				startIndex = csvLine.indexOf('"');
				csvLine = csvLine.substring(0, startIndex) + ':quotes:' + csvLine.substring(startIndex+1, csvLine.length());
			}else{
				if(endIndex == null){
					endIndex = csvLine.indexOf('"');
					csvLine = csvLine.substring(0, endIndex) + ':quotes:' + csvLine.substring(endIndex+1, csvLine.length());
				}
			}
			if(startIndex != null && endIndex != null){
				String sub = csvLine.substring(startIndex, endIndex);
				sub = sub.replaceAll(',', ':comma:');
				csvLine = csvLine.substring(0, startIndex) + sub + csvLine.substring(endIndex, csvLine.length());
				startIndex = null;
				endIndex = null;
			}
		}
		//System.debug('prevLine:::'+prevLine);
		//System.debug('csvLine:::'+csvLine);
		for(String column : csvLine.split(',')){
			column = column.replaceAll(':quotes:', '').replaceAll(':comma:', '');
			finalString.add(column);
			//System.debug('column::'+column);
		}
		return finalString;
		
	}
	
	//Added by ChristieJJ for rqmt 4374 for aggregating same products
	public void aggregateDuplicates(List<Apttus_CPQApi.CPQ.SelectedProductDO> tempList) {
		system.debug('[+] aggregateDuplicates');	
		for(Apttus_CPQApi.CPQ.SelectedProductDO temp : tempList){
			if(pcodePDOmap.keyset().contains(temp.ProductId)){
				system.debug('[+] Existing product : '+temp.ProductId);
				String newSites = temp.CustomData.EPT_Site_Quantity__c;
				String oldSites = pcodePDOmap.get(temp.ProductId).CustomData.EPT_Site_Quantity__c;
				newSites = addSites(newSites,oldSites);
				system.debug('[+] old qty = '+pcodePDOmap.get(temp.ProductId).Quantity+ ', new qty = '+temp.Quantity);
				Decimal newQuantity = temp.Quantity + pcodePDOmap.get(temp.ProductId).Quantity;
				temp.Quantity = newQuantity;
				temp.CustomData.EPT_Site_Quantity__c = newSites;
				//Update existing database with aggregated values
				pcodePDOmap.put(temp.ProductId,temp);	  
			}
			else{
				system.debug('[+] Not existing product : ');
				//returnList.add(temp);
				pcodePDOmap.put(temp.ProductId,temp);
			}
			//return returnList
		}
	}
	
	//Added by Christie JJ for rqmt 4374 for aggregating EPT Site quantities
	public String addSites(String newString,String oldString){
		system.debug('[+] inside addSites');
		
		List<String> newLi = newString.split(',');
		List<String> oldLi = oldString.split(',');
		List<String> finalLi = new List<String>();
		if(newLi.size()==oldLi.size() && !newLi.isEmpty() && !oldLi.isEmpty()){
			for(Integer i =0;i<newLi.size();++i){
				Integer value = Integer.valueOf(newLi.get(i).substring(0,1)) + Integer.valueOf(oldLi.get(i).substring(0,1));
				finalLi.add(String.valueOf(value));
			}
			
		}
		else
			return null;
		system.debug('[+] Exit addSites');
		return String.join(finalLi,',');
		
	}
	
	//Added by Christie JJ for rqmt 4374 for finally adding all aggregated line items to the cart, onclick of 'Go To Cart' button.
	public PageReference addProductsToCart(){
		system.debug('[+] inside addProductsToCart()');
		system.debug('[+] pcode size = '+pcodePDOmap.values().size());
		system.debug('[+] if = '+(proposalId != null && proposal.NokiaCPQ_Portfolio__c != GlobalConstants.PORTFOLIO2));
		//PageReference pg1 = new PageReference(site.getBaseSecureUrl()+GlobalConstants.URLLINK1+proposalId+GlobalConstants.URLLINK2);
		try{
			if(proposalId != null && proposal.NokiaCPQ_Portfolio__c != GlobalConstants.PORTFOLIO2){   
				system.debug('[+] creating cart');
				cartId = acpq.CreateApttusCart(proposalId);
				system.debug('[+] created cart id = '+cartId );
				system.debug('[+] saving cart');
				acpq.saveCart(cartid);
				system.debug('[+] saved cart');
				system.debug('[+] Cart!=null  = '+(cartId != null));
				if(cartId != null){
					if(!selectedProdDOList.isEmpty()) {
						update proposal;
						system.debug('[+] updated proposal');
					}
					Apttus_CPQApi.CPQ.AddMultiProductRequestDO lineItemRecords = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
					lineItemRecords.cartID = cartId;
					lineItemRecords.SelectedProducts = pcodePDOmap.values();
					system.debug('[+] assosciated cart with lineitems');
					Apttus_CPQApi.CPQ.AddMultiProductResponseDO lineItemRecordsResponse = Apttus_CPQApi.CPQWebService.addMultiProducts(lineItemRecords);
					system.debug('[+] updated cart with lineitems');
					acpq.saveCart(cartid);
					system.debug('[+] saved final cart');
					createSitePhaseQty(cartid,lineItemRecordsResponse.LineNumbers, proposal.Apttus_Proposal__Opportunity__c);
					// For rules that are not marked as Check on Finalization
					List<Integer> primaryLines = new List<Integer>();
					Apttus_CPQApi.CPQWebService.associateConstraintRules(cartId,primaryLines);
					system.debug('[+] assosciated constrain rules on cart'); 
					Apttus_CPQApi.CPQWebService.applyConstraintRules(cartId, false);
					system.debug('[+] applied constrain rules on cart');   
					//sitesExistingRecords.addAll(sitesToInsertLists);
					System.debug('23sitesExistingRecords>>>'+sitesExistingRecords);
					if(!sitesExistingRecords.isEmpty()){
						List<ID> sitesInCSVOrderlstIns = new  List<ID> ();
						System.debug('RecordsExists>>>');
						for(String site:siteSet){
							for(NokiaCPQ_Site__c  siteObj :sitesExistingRecords){
								if(site.trim() == siteObj.Name){
									sitesInCSVOrderlstIns.add(siteObj.Id);
									break;
								}
							}
						}  

						
						Nokia_CPQ_Utility.insertSitePhaseConfig(cartId, sitesInCSVOrderlstIns, new  List<ID>());
					}	  
				}
			}
		}
		catch(Exception e){
			ExceptionHandler.addException(e,EPT_productuploadscontroller.class.getName(),GlobalConstants.ERROR_ST);
		}
		return null;
		
	}
	public static void  createSitePhaseQty(String cartId,list<Decimal> lineNumberList,Id oppId){
		// surinder 
		// added for site phase qty logic. Moving sites names f rom EPT_site__c to related list on line item
		Set<Decimal> lineNumbers= new Set<Decimal>();
		set<String> siteSet= new set<String>();
		list<String> quantities = new list<String>();
		Map<String,ID> nameWithId= new Map<String,Id>();
		list<String> siteNames= new list<String>();		 
		list<CPQ_Site_Phase_and_Quantity__c> toInsert = new List<CPQ_Site_Phase_and_Quantity__c>();
		Map<String,list<String>> pcodeWithQuantityList= new Map<String,list<String>>();
		Map<String,String> siteWithQty= new Map<String,String>();
		system.debug('line numbers added==>'+lineNumberList);
		system.debug('cartId'+cartId);
		for(Decimal dec:lineNumberList){
			lineNumbers.add(dec);
		}
		List<string> maintenanceProdCodes = new List<string> {'MT001','MT002','SRS001','CMUSRS','SSP002'};
		List<Apttus_Config2__LineItem__c> lineItemList=[SELECT id,Name,Apttus_Config2__ProductId__r.ProductCode,EPT_Sites__c,
														EPT_Site_Quantity__c,Apttus_Config2__ConfigurationId__c 
														FROM Apttus_Config2__LineItem__c 
														WHERE Apttus_Config2__ConfigurationId__c =:cartId
														AND Apttus_Config2__ProductId__r.ProductCode NOT IN:maintenanceProdCodes];		
		if(!lineItemList.isEmpty()){
			for(Apttus_Config2__LineItem__c li:lineItemList){
				system.debug('entered in line item loop&&&&&&&&&&&&&&&&&&&&&&&&7');
				system.debug('li.Apttus_Config2__ProductId__r.ProductCode p&&&&&&&&&&&&&&&&&&&&&&&&7'+li.Apttus_Config2__ProductId__r.ProductCode);
				if(!String.isBlank(li.EPT_Sites__c)){
					siteNames=li.EPT_Sites__c.split(',');
				}
				if(!String.isBlank(li.EPT_Site_Quantity__c)){
					quantities=li.EPT_Site_Quantity__c.split(',');
					pcodeWithQuantityList.put(li.Apttus_Config2__ProductId__r.ProductCode,quantities);
				}   
				
				system.debug('siteNames size=>'+quantities.size());
				for(integer i=0;i<=quantities.size()-1;i++){ 
					system.debug('quantities[i]=>'+quantities[i]);
					if(quantities[i]!=null) { 
						siteWithQty.put(li.Apttus_Config2__ProductId__r.ProductCode+'-'+sitenames[i],quantities[i]);
					}//else{
					// siteWithQty.put(li.Apttus_Config2__ProductId__r.ProductCode+'-'+sitenames[i],'0');
					// }					
				}			
			}
		}
		  
		for(String sites:siteNames){
			siteSet.add(sites);
		}
		system.debug('siteSet=$$$$$=>'+siteSet);
		for(NokiaCPQ_Site__c site : [SELECT ID,Opportunity__c, Name FROM NokiaCPQ_Site__c WHERE  Opportunity__c=:oppId]){
			if(siteSet.contains(site.Name)){
				nameWithId.put(site.Name,site.id);
			}
		}
		system.debug('nameWithId=$$$$$=>'+nameWithId);
		if(!lineItemList.isEmpty()){
			for(Apttus_Config2__LineItem__c li:lineItemList){
				if(li.EPT_Sites__c!=null){
					for(String str:siteNames){
						if(sitenames.size() ==1 && str=='No Site Assigned'){
							// do nothing
						}else{											   
							if((str=='No Site Assigned' && siteWithQty.get(li.Apttus_Config2__ProductId__r.ProductCode+'-'+ str)!=null && siteWithQty.get(li.Apttus_Config2__ProductId__r.ProductCode+'-'+ str)!='' && decimal.valueof(siteWithQty.get(li.Apttus_Config2__ProductId__r.ProductCode+'-'+ str))>0)||
							   (str!='No Site Assigned') ){												  
								   CPQ_Site_Phase_and_Quantity__c obj= new CPQ_Site_Phase_and_Quantity__c();
								   obj.Line_Item__c=li.id;
								   obj.NCPQ_Site__c=nameWithId.get(str);						
								   if(siteWithQty.get(li.Apttus_Config2__ProductId__r.ProductCode+'-'+ str)!=null && siteWithQty.get(li.Apttus_Config2__ProductId__r.ProductCode+'-'+ str)!=''){
									   obj.NCPQ_Quantity__c=decimal.valueof(siteWithQty.get(li.Apttus_Config2__ProductId__r.ProductCode+'-'+str));				   
								   } 
								   else{
									   obj.NCPQ_Quantity__c=0;
								   } 
								   toInsert.add(obj); 
								   li.EPT_Sites__c=null;
								   li.EPT_Site_Quantity__c=null; 
							   }
						}
					}
				}
				
			}
		}
		if(!toInsert.isEmpty()){
			insert toInsert; 
		}
		if(!lineItemList.isEmpty()){
			update lineItemList;
		}
		
		/************************************** */
		//surinder end
	}
}