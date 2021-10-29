@RestResource(urlMapping='/ngbss/api/v1/accounts/*')
global with sharing class accountRestResource {

     
    @HttpGet
    global static void doGetProduct() {
    
        RestResponse res = RestContext.response;
       res.addHeader('Content-Type','application/json');
        
       try{
             List<wrapperAccounts> data = new List<wrapperAccounts>();
             List<soldDetails> soldTo;
             RestRequest req = RestContext.request;
            
            // String accountName = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
             String accountName = req.params.get('name');
             if(accountName == Null)
               throw new MyException('Customer Name is Mandatory with 3 letters');
               
             String searchname = accountName+'%';  
                       
                      
             List<Account> accountSolds = [Select id,Name,(Select External_Account_ID__c,External_Account_Name__c,External_Address_Line_1__c,External_Address_Line_2__c,External_City_Name__c,External_Country_Name__c,External_Postal_Code__c,External_State_Code__c,Account_Name__c from Account_Cross_Ref__r where XREF_Type__c = 'SAP_SOLD_TO' and (NOT External_Account_Name__c like '%DO NOT USE%')) from Account where name like :searchname];
             System.debug(accountSolds.Size()); 
             
             For(Account Acc :accountSolds)
             {                          
                wrapperAccounts lstwrapper = new wrapperAccounts();
                System.debug('Acc.Account_Cross_Ref__r.size()'+Acc.Account_Cross_Ref__r.size());
                soldTo = New list<soldDetails>();
                For(Account_Cross_Ref__c Acr :Acc.Account_Cross_Ref__r)
                {
                 
                  If(Acc.id == Acr.Account_Name__c)
                  {
                    System.debug(Acc.id);
                    System.debug(Acr.Account_Name__c);
                    
                  soldDetails sd = New soldDetails();
                  sd.soldToNumber = Acr.External_Account_ID__c;
                  sd.sapAccountName = Acr.External_Account_Name__c;
                  sd.addressLine1 = Acr.External_Address_Line_1__c;
                  sd.addressLine2  = Acr.External_Address_Line_2__c;
                  sd.city = Acr.External_City_Name__c;
                  sd.postalCode = Acr.External_Postal_Code__c;
                  sd.stateCode = Acr.External_State_Code__c ;
                  sd.country = Acr.External_Country_Name__c; 
                  soldTo.Add(sd);
                  }
                }
                lstwrapper.customerName = Acc.Name;
                lstwrapper.soldTo = soldTo;
              data.Add(lstwrapper);  
             }
                          
              system.debug(JSON.serialize(data));
              res.statusCode = 200;
              res.responseBody = Blob.valueOf(json.serialize(data));
              
        } catch (Exception ex) {
              Err error = new Err('BAD_REQUEST',ex.getMessage());
             
         res.statusCode = 400;
         res.responseBody = Blob.valueOf(json.serialize(error));
         res.addHeader('Access-Control-Allow-Origin','*');
        }
    
    }
    
    global class wrapperAccounts
    {
      Public String customerName{Get;Set;}
      Public List<soldDetails> soldTo{Get;set;}
    }
    global class soldDetails
    {
      Public string soldToNumber{Get;Set;}
      Public string sapAccountName{Get;Set;}
      Public string addressLine1{Get;Set;}
      Public string addressLine2{Get;Set;}
      Public string city{Get;Set;}
      Public string postalCode{Get;Set;}
      Public string stateCode{Get;Set;}
      Public string country{Get;Set;}
    }

      global class MyException extends Exception { }
    
        global class Err
        {
            public string errorCode;
            public string message;
            
            Err(string errorCode, string message)
            {
                this.errorCode = errorCode;
                this.message = message;
            }
    
        }
  }