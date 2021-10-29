/************************************************************
 * @Description : 
 * 
 * **********************************************************/
public with Sharing class SPoG_PricingHelper {
	
	

    /*******************************************************************
     * @Description : 
     * ****************************************************************/
    public String getPricingInfo(Map<String,Object> mapInputRequest){
		Map<String, SPoG_PriceTypeMapping__c> priceTypesMap = SPoG_PriceTypeMapping__c.getAll();


        System.debug('$$$mapInputRequest='+mapInputRequest.keySet());
        System.debug('$$$mapInputRequest='+mapInputRequest.Values());
        RequestPayload reqObj = new RequestPayload(); 
        
		//OP_Pricing opPricing = new OP_Pricing(); 
        SPoG_Utility objUtility = new SPoG_Utility(); 
        SPoG_InterfaceHelper objHandler = new SPoG_InterfaceHelper(); 
		
		//SCommon request Format
		SCommon sCommon = new SCommon();
		System.debug('$$$tHeader='+sCommon);
		reqObj.d.sCommon = sCommon;
		
		
		//Pricing Date Format
		String pricingDate = (String) mapInputRequest.get('pricingDate'); 
        if(String.isNotBlank(pricingDate) && pricingDate != null){
			pricingDate = objUtility.parseDateForInput(pricingDate);
		}else {
			pricingDate = System.Now().format('yyyyMMdd');
		}
        System.debug('$$$pricingDate='+pricingDate);	

        //tITem Request Payload		
        List<MatInput> lstInputs = (List<MatInput>) JSON.deserialize((String) mapInputRequest.get('lstMaterials'), List<MatInput>.Class); 
		System.debug('$$$lstInputs='+lstInputs);   
		Integer inputCount = 0;
        for(MatInput objInput : lstInputs){
			inputCount += 1;
            TItem tItem = new TItem();
            
			tItem.docNumber = String.valueOf(inputCount);
			tItem.itmNumber = String.valueOf(inputCount);
			tItem.poItmNo = '100000';
			tItem.matEntrd = objInput.materialNumber;
		    tItem.priceDate = pricingDate;
			tItem.reqDate = System.Now().format('yyyyMMdd');
			tItem.targetQty = objInput.materialQuantity+'';
			tItem.valType = '';
			tItem.QuoteId = '';
			reqObj.d.tItem.add( tItem );

			//TPartner Request Format
			for(Integer i=0; i<=1; i++) {
				TPartnr tPartnr = new TPartnr();
				tPartnr.docNumber = String.valueOf(inputCount);
				if(i == 0){
					tPartnr.partnRole = 'AG';
				}else {
					tPartnr.partnRole = 'WE';
				}
				tPartnr.partnNumb = (String) mapInputRequest.get('shipTo');			
				tPartnr.QuoteId = '';
				reqObj.d.tPartnr.add( tPartnr );
			} 
             
            if (!Test.isRunningTest()){
			SPoG_PriceTypeMapping__c priceType = priceTypesMap.get(objInput.Valuetype);
			//THeader Request Format
			THeader tHeader = new tHeader();
			tHeader.docNumber = String.valueOf(inputCount);
			tHeader.subType = priceType.subType__c != null ? priceType.subType__c : '';
			tHeader.tranType = priceType.tranType__c != null ? priceType.tranType__c : '';
			reqObj.d.tHeader.add( tHeader ); 
            }
			//System.debug('$$$TPartner=' + reqObj.d.tPartnr);
		}

        System.debug('$$$tHeader='+reqObj.d.tHeader);
        System.debug('$$$tPartnr='+reqObj.d.tPartnr);
        System.debug('$$$tItem='+reqObj.d.tItem);
		String jsonReq = JSON.serialize( reqObj );
		//System.debug('$$$jsonReq = '+jsonReq);
       
        HttpResponse objResponse = objHandler.getPricingInfo( jsonReq );
        System.debug('Received Response for Pricing '+objResponse);
        /*PricingInfo objPricingResults = new PricingInfo(); 
        Map<String , PricingInfo> mapPricingInfo = new Map<String,PricingInfo>(); 
        List<PricingInfo> lstResults = new List<PricingInfo>(); 
        PricingInfoResult objResult = new PricingInfoResult();*/
        /*if result is success 
        if(objResponse.getStatusCode() == 201) {
            objResult.isSuccess = true ; 
            OP_Response objOutput = new OP_Response(); 
            objOutput =   (OP_Response) JSON.deserialize(objResponse.getBody(), OP_Response.Class); 
            if(objOutput.d.PricingToItmOut != null){
              objResult.lstNewResults = objOutput.d.PricingToItmOut.results ;     
            }
        }
        else if(objResponse.getStatusCode() == 400) {
            Error objError = new Error();
            objError = (Error) JSOn.deserialize(objResponse.getBody(), Error.Class); 
            objResult.isSuccess = false ; 
            objResult.errorMessage = objError.error.message.value ; 
        }*/
        
        /*for(OP_Pricing objPriceInfo : objResult.lstNewResults){
            objPriceInfo.Angdt = objUtility.parseDateForOutput(objPriceInfo.Angdt); 
            objPriceInfo.Bnddt = objUtility.parseDateForOutput(objPriceInfo.Bnddt); 
		}*/
		Map<String, String> responseMap = new Map<String, String>();
		if(objResponse.getStatusCode() == 201) {
			responseMap.put('isSuccess', 'true');
			responseMap.put('body', objResponse.getBody());
		} else {
			responseMap.put('isSuccess', 'false');
			responseMap.put('body', objResponse.getBody());
		}
        
        return JSON.serialize(responseMap);
    }
    
	public class RequestPayload {
		public d d;
		public RequestPayload() {
			d = new d();
		}
	}
	
    public class Components {
	}

	public class TPartnr {
		public String docNumber = '1';
		public String partnRole = '';
		public String partnNumb;
		public String QuoteId = '';
	}

	public class THeader {
		public String docNumber = '1';
		public String tranType = 'SALE';
		public String subType = '';
		public String QuoteId = '';
	}

	public class d {
		public SCommon sCommon;
		public List<THeader> tHeader = new List<THeader>();
		public List<TItem> tItem = new List<TItem>();
		public List<TPartnr> tPartnr = new List<TPartnr>();
		public List<Components> tAvail = new List<Components>();
		public List<Components> tText = new List<Components>();
		public List<Components> tPrice = new List<Components>();
		public List<Components> tSched = new List<Components>();
		public List<Components> tReplace = new List<Components>();
		public List<Components> tSupplierList = new List<Components>();
		public List<Components> tIncomp = new List<Components>();
		public List<Components> tReturn = new List<Components>();
		public List<Components> tContract = new List<Components>();
		public List<Components> tCertificates = new List<Components>();
		public List<Components> tServiceBul = new List<Components>();
		public List<Components> tAdders = new List<Components>();
		public String QuoteId = '';
		
	}

	public class TItem {
		public String docNumber;
		public String itmNumber;
		public String poItmNo;
		public String matEntrd;
		public String priceDate;
		public String reqDate;
		public String targetQty;
		public String valType;
		public List<Components> components;
		public String QuoteId;
		public TItem() {
			components = new List<Components>();
		}
	}

	public class SCommon {
		public String action = 'PANDA';
		public String QuoteId = '';
	}
    
    private with Sharing Class PricingInfoResult {
        Boolean isSuccess = false ; 
        String errorMessage ; 
        //List<PricingInfo> lstResults = new List<PricingInfo>(); 
       // List<OP_Pricing> lstNewResults = new List<OP_Pricing>(); 
    }
    
    private with Sharing Class Error {
        ErrorHandler error = new ErrorHandler(); 
    }
    
    private with Sharing Class ErrorHandler {
        String code ; 
        MessageInfo message = new MessageInfo(); 
    }
    
    private with Sharing Class MessageInfo {
        String lang ; 
        String value ; 
    }
    
    private with Sharing Class MatInput {
        String Valuetype ; 
        Integer materialQuantity ; 
        String materialNumber ; 
        
    }
}