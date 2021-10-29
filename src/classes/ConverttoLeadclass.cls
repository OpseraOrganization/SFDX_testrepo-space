public class ConverttoLeadclass {

    public list<Potential_Sales_Ideas__c> ptsalesidea{get;set;}
    public string ptslsid{get;set;}
    public ConverttoLeadclass(){           
           
      }
       
    public Pagereference Convertion(){
           ptslsid=System.currentPageReference().getParameters().get('id');
           ptsalesidea =[select id,Sales_Idea_Number__c,Name,Account_Name__c,Description__c,Product_Information__c,Contact__c,Estimated_Value__c,Source__c,Aircraft_Type__c,Aircraft_Tail_Number__c,Converted_Date__c,Status__c,GBE__c from Potential_Sales_Ideas__c where id=:ptslsid limit 1];
           ptsalesidea[0].Status__c = 'Converted';
           ptsalesidea[0].Converted_Date__c = System.today();
           update ptsalesidea;
           id leadtype=Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead Create Layout').getRecordTypeId();
        
            Lead ld= new lead();
            //ld.CreatedByid = ptsalesidea.OwnerId;
            ld.LastName = ptsalesidea[0].Name;
            ld.Company = 'test cmp from potent sales';
            ld.RecordTypeId = leadtype;
            //enabling as part of SCTASK3039869
            ld.Lead_Description__c = ptsalesidea[0].Description__c;
            ld.ATR_Estimated_Value__c = ptsalesidea[0].Estimated_Value__c;
            ld.LeadSource = ptsalesidea[0].Source__c;
            ld.Contact__c = ptsalesidea[0].Contact__c;
            //enabling as part of SCTASK3039869
            ld.Account__c = ptsalesidea[0].Account_Name__c;
            ld.ATR_Product_Information__c = ptsalesidea[0].Product_Information__c;
            ld.Aircraft_Type__c = ptsalesidea[0].Aircraft_Type__c;
            ld.Aircraft_Tail_Number__c = ptsalesidea[0].Aircraft_Tail_Number__c;
            ld.GBE__c = ptsalesidea[0].GBE__c;
            ld.Sales_Idea_Number__c = ptsalesidea[0].Sales_Idea_Number__c;
            insert ld;
            Pagereference pref = new Pagereference('/'+ld.Id);
            return pref;
            //ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.INFO,'A new lead has been created'+ld.id);
            //ApexPages.addMessage(msg);
            
        }   
        
    }