@RestResource(urlMapping='/ngbss/api/v1/accounttype/*')
global with sharing class accountTypeRestResource {

     
    @HttpGet
    global static void doGetProduct() {
    
        RestResponse res = RestContext.response;
       res.addHeader('Content-Type','application/json');
        
       try{
             wrapperAccounts data = new wrapperAccounts();
              List<String> Sapnumberlst = New List<String>();
             RestRequest req = RestContext.request;
            
           
             String STo = req.params.get('soldtos');
               IF(STo != Null){
                String[] queryParams = STo.split(',');
                 Sapnumberlst  = searchAccList(queryParams);
                 System.debug(Sapnumberlst  );
                System.debug(queryParams );
               /* for(String queryParam: queryParams) {
                    Sapnumberlst.Add('%'+queryParam+'%');
                } */
                
                }
                Else
                {
               throw new MyException('SoldTos are Mandatory');
                }                                  
                      
             List<Account_Cross_Ref__c> accountSolds = [Select External_Account_ID__c,External_Account_Name__c,Account_Name__r.Name,Account_Name__c,Account_Name__r.Type from Account_Cross_Ref__c where XREF_Type__c = 'SAP_SOLD_TO' and (NOT External_Account_Name__c like '%DO NOT USE%') and External_Account_ID__c IN:Sapnumberlst];
            wrapperAccounts lstwrapper = new wrapperAccounts();
             if(accountSolds !=Null && accountSolds.Size()>0 )
             {
             
             set<id> AccountIdlst = New Set<Id>();
             For(Account_Cross_Ref__c ACR:accountSolds)
             {
                AccountIdlst.Add(ACR.Account_Name__c);
             }
             System.debug(accountSolds.Size()); 
             System.debug(AccountIdlst.Size()); 
              
              List<accounts> accounts = New List<accounts>();
             
             For(id accountid :AccountIdlst)
             { 
                  accounts a = New accounts();
                 List<sapSoldTo> sapSoldTo = New List<sapSoldTo>();
                  
             For(Account_Cross_Ref__c Acc :accountSolds)
             {              
                 If(Acc.Account_Name__c == accountid)
                 {  
                 sapSoldTo S = New sapSoldTo();                  
                 a.accountId = Acc.Account_Name__c;
                 a.customerName = Acc.Account_Name__r.Name;
                 a.accountType = Acc.Account_Name__r.Type;
                 S.sapNumber = Acc.External_Account_ID__c;      
                 sapSoldTo.Add(s);
                 a.sapSoldTo = sapSoldTo; 
                 }
                        
            }
                 accounts.Add(a);    
            
            }
             lstwrapper.accounts = accounts;
            }
            else
             throw new MyException('SoldTo numbers are Invalid');  
              system.debug(JSON.serialize(lstwrapper));
              res.statusCode = 200;
              res.responseBody = Blob.valueOf(json.serialize(lstwrapper));
              
        } catch (Exception ex) {
              Err error = new Err('BAD_REQUEST',ex.getMessage());
             
         res.statusCode = 400;
         res.responseBody = Blob.valueOf(json.serialize(error));
         res.addHeader('Access-Control-Allow-Origin','*');
        }
    
    }
    
    global class wrapperAccounts
    {
     Public List<accounts> accounts{Get;set;}
    }
    global Class accounts
    {
      Public string accountId{Get;Set;}
      Public string customerName{Get;Set;}
      Public string accountType{Get;Set;}
      Public List<sapSoldTo> sapSoldTo{Get;Set;}
    }
    global class sapSoldTo
    {
      Public string sapNumber{Get;Set;}
     
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
        
        public static List<String> searchAccList(String[] Accntlst){
        
        List<String> accntList = new List<String>();
            String newaccnt;
            For(String accnt:Accntlst)
            {
            Integer size = accnt.length();
            if(size < 10){
                Integer sizetoadd = 10 - size;
                String append = '0';
                for(integer i=1;i<sizetoadd;i++){
                    append = append+'0';
                }           
                newaccnt = append + accnt;
                system.debug('newaccnt' +newaccnt);
               // accntList.add(newaccnt);
                accntList.add(newaccnt+'-01');
                accntList.add(newaccnt+'-02');
            }
            
            // accntList.add(accnt);
            accntList.add(accnt+'-01');
            accntList.add(accnt+'-02');
            //To identify shipTo which is truncated
            String accntT = accnt.replaceFirst('^0+', '');
           // accntList.add(accntT);
            accntList.add(accntT+'-01');
            accntList.add(accntT+'-02');
            }
            return accntList;
    }  
  }