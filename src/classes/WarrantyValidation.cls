global class WarrantyValidation{
   @AuraEnabled
   webservice static String UpdateWarrantyDetails(string CaseId){
    String Status = 'SUCCESS';
    Boolean IsAtleastOneWarrantyFound = false;
     List<Warranty__c > warrantyinfos = new List<Warranty__c >();
    try {
            UpdateCaseExtenstion(CaseId);
            
            D data = new D();
           
            
            Set<Wrapper> distinctValues = new Set<Wrapper>();
            List<Sales_Order__c> SOs = new List<Sales_Order__c >();
            
        
        SOs= [ SELECT Sales_Order_Number__c ,Failed_Part_Number__c,Falied_Part_SN__c   FROM Sales_Order__c Where Case__c = :CaseId and Falied_Part_SN__c != Null and Failed_Part_Number__c != Null ];
        If(SOs.size() >0 )
        {
        for(Sales_Order__c so : SOs)
        {
            
            distinctValues.add(new Wrapper(so.Failed_Part_Number__c  , so.Falied_Part_SN__c));   
        }
        
        for(Wrapper val : distinctValues )
            {
                
                    Http http = new Http();
                    HttpRequest request = new HttpRequest();
                    request.setEndpoint(label.Warranty_Validation_URL);
                    request.setMethod('GET');
                    request.setHeader('Accept', 'application/json');
                    request.setHeader('client_id', label.Warranty_Validation_Client_Id);
                    request.setHeader('client_secret',label.Warranty_Validation_Client_Secret);
                    request.setHeader('materialNum', val.ProdutNo );
                    request.setHeader('serialNum', val.SerialNo);
                    HttpResponse response;

                    if(!TEST.isRunningTest())
                    {
                            response = http.send(request);
                    }

                    else{
                        response = WarrantyValidation.testclasscall();
                    }
                     
                
                    if (response.getStatusCode() == 200) 
                    {
                
                        data = (D)JSON.deserialize(response.getBody(), D.class);
                        
                        for(WarrantyData finaldata : data.records)
                        {
                          Integer mat = String.isBlank(finaldata.MASTER_WARRANTY) ? 0 : integer.ValueOf(finaldata.MASTER_WARRANTY);
                          if(mat <= 20000)
                          {
                            
                            Warranty__c warrantyinfo                     = new Warranty__c();
                            warrantyinfo.Case__c                         = CaseId ; 
                            warrantyinfo.CurrencyIsoCode                 = 'USD';
                            warrantyinfo.Serial_Type__c                  = String.isBlank(finaldata.SERIAL_TYPE) ? '' : finaldata.SERIAL_TYPE;
                            warrantyinfo.Failed_Part_Number__c           = String.isBlank(finaldata.MATERIAL_NUMBER) ? '' : finaldata.MATERIAL_NUMBER;
                            warrantyinfo.Failed_Part_SN__c               = String.isBlank(finaldata.SERIAL_NUMBER) ? '' : finaldata.SERIAL_NUMBER;
                            warrantyinfo.Equipment_Number__c             = String.isBlank(finaldata.EQUIPMENT_NUMBER) ? '' : finaldata.EQUIPMENT_NUMBER;
                            warrantyinfo.Warranty_Type__c                = String.isBlank(finaldata.WARRANTY_TYPE) ? '' : finaldata.WARRANTY_TYPE;
                            //Start Date
                            if(String.isNotBlank(finaldata.WARRANTY_START_DATE_STRING) && finaldata.WARRANTY_START_DATE_STRING != '00000000')
                            {
                                Integer war_year = integer.ValueOf(finaldata.WARRANTY_START_DATE_STRING.Substring(0,4));
                                if( war_year >= 1900 && war_year <= 2099)
                                {
                                    warrantyinfo.Warranty_Start_Date__c = FindtheDate(finaldata.WARRANTY_START_DATE_STRING);
                                }
                            }
                            
                                //End Date
                            if(String.isNotBlank(finaldata.WARRANTY_END_DATE_STRING) && finaldata.WARRANTY_END_DATE_STRING!= '00000000')
                            {
                                Integer war_year = integer.ValueOf(finaldata.WARRANTY_END_DATE_STRING.Substring(0,4));
                                if( war_year >= 1900 && war_year <= 2099)
                                {
                                    warrantyinfo.Warranty_End_Date__c = FindtheDate(finaldata.WARRANTY_END_DATE_STRING);
                                }
                            }
                    
                            warrantyinfo.Master_Warranty__c              = String.isBlank(finaldata.MASTER_WARRANTY) ? '' : finaldata.MASTER_WARRANTY.right(5);
                            warrantyinfo.Master_Warranty_Description__c  = String.isBlank(finaldata.MASTER_WARRANTY_DESC) ? '' : finaldata.MASTER_WARRANTY_DESC;
                            warrantyinfo.Contract__c                     = String.isBlank(finaldata.CONTRACT) ? '' : finaldata.CONTRACT;
                            warrantyinfo.Contract_Item__c                = String.isBlank(finaldata.CONTRACT_ITEM) ? '' : finaldata.CONTRACT_ITEM;
                            warrantyinfo.Program_Type__c                 = String.isBlank(finaldata.PROGRAM_TYPE) ? '' : finaldata.PROGRAM_TYPE;
                            warrantyinfo.Contract_Item_Text__c           = String.isBlank(finaldata.CONTRACT_ITEM_TEXT) ? '' : finaldata.CONTRACT_ITEM_TEXT;
                            warrantyinfo.Payment_Status_Desc__c          = String.isBlank(finaldata.PAYMENT_STATUS_DESC) ? '' : finaldata.PAYMENT_STATUS_DESC;
                            warrantyinfo.Payment_Status__c               = String.isBlank(finaldata.PAYMENT_STATUS) ? '' : finaldata.PAYMENT_STATUS;
                            warrantyinfo.Par_Status__c                   = String.isBlank(finaldata.PAR_STATUS) ? '' : finaldata.PAR_STATUS;
                            warrantyinfo.Par_Status_Desc__c              = String.isBlank(finaldata.PAR_STATUS_DESC) ? '' : finaldata.PAR_STATUS_DESC;
                            
                            warrantyinfos.add(warrantyinfo);
                            IsAtleastOneWarrantyFound  = true;
                          
                          }
                        }
                    }

                    else{

                        Status = 'Error: Failed to get Warranty Details, Error Code:' + response.getStatusCode() + ' , Error: ' + response.getBody();
                        break;
                    }
            }

        }

        else{

            Status = 'Error: No SalesOrder with Valid Combination of Part and Serial Number';
        }
    } catch (Exception ex) {

        Status = 'ERROR: ' + ex.getMessage();
    }
    
    if(IsAtleastOneWarrantyFound == false && Status =='SUCCESS')
    {
        Status = 'Warning : No Valid Warranty Details Found';
    }
    else if(IsAtleastOneWarrantyFound == true && Status =='SUCCESS')
    {
     insert warrantyinfos;
    }
    return Status;
    
}
public static void UpdateCaseExtenstion(string caseid)
{
            List<Case_Extension__c> caseext = new List<Case_Extension__c>();
            caseext = [SELECT Id FROM Case_Extension__c where Case_object__c = :caseid and Warranty_Check__c = false];
            if(caseext.size() >0)
            {
               caseext[0].Warranty_Check__c = true;
               Update caseext[0];
            }
}

public static Date FindtheDate(string datefield)
{
     Integer war_year = integer.ValueOf(datefield.Substring(0,4));
     Integer war_month = integer.ValueOf(datefield.Substring(4,6));
     Integer war_date = integer.ValueOf(datefield.Substring(6,8));
     Date d = Date.newInstance(war_year ,war_month ,war_date );
     return d;

}


public class D {
    public List<WarrantyData> records;
}
public class WarrantyData{
  public string GenID;
  public string SERIAL_TYPE;
  public string MATERIAL_NUMBER;
  public string SERIAL_NUMBER;
  public string EQUIPMENT_NUMBER;
  public string WARRANTY_TYPE;
  public string WARRANTY_START_DATE_STRING;
  public string WARRANTY_END_DATE_STRING;
  public string MASTER_WARRANTY;
  public string MASTER_WARRANTY_DESC;
  public string CONTRACT;
  public string CONTRACT_ITEM;
  public string PROGRAM_TYPE;
  public string CONTRACT_ITEM_TEXT;
  public string PAYMENT_STATUS_DESC;
  public string PAYMENT_STATUS;
  public string PAR_STATUS; 
  public string PAR_STATUS_DESC;
  public string WARRANTY_COUNT;

  }
  public class Wrapper {
    
    String ProdutNo;
    String SerialNo;

    public Wrapper(String PRNo, String SerNo) {
        
        ProdutNo = PRNo;
        SerialNo = SerNo;
    }
    public Integer hashCode() {
        
        return String.valueOf(ProdutNo +SerialNo ).hashCode();
    }
    public Boolean equals(Object o) {
        Wrapper other = (Wrapper)o;
        return ProdutNo == other.ProdutNo && SerialNo == other.SerialNo;
    }
}

public static HttpResponse testClassCall()
    {
        HttpResponse returnResponse = new HttpResponse();
        returnResponse.setStatusCode(200);
        returnResponse.setBody('{"records":[{"SERIAL_TYPE":"Material","MATERIAL_NUMBER":"7001850-939","SERIAL_NUMBER":"V1","EQUIPMENT_NUMBER":"000000000010233290","WARRANTY_TYPE":"Factory Warranty","WARRANTY_START_DATE_STRING":"20100212","WARRANTY_END_DATE_STRING":"20100212","MASTER_WARRANTY":"00000000000000000101","MASTER_WARRANTY_DESC":"36 months 20000 hours 1500 cycles","CONTRACT":null,"CONTRACT_ITEM":null,"PROGRAM_TYPE":null,"CONTRACT_ITEM_TEXT":null,"PAYMENT_STATUS_DESC":null,"PAYMENT_STATUS":null,"PAR_STATUS":null,"PAR_STATUS_DESC":null,"WARRANTY_COUNT":"1"}]}');
        return returnResponse;
    }

}