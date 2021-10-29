global class AgreementAttachmentToContract implements Schedulable {
/*Created for MSP HAPP Project. This scheduled method is used to copy the signed documents to 
corresponding contract for agreements with Renewal date as yesterday and copy over the renewal info to contracts*/
 
   global void execute(SchedulableContext ctx){
        date compareDate = Date.today();
        compareDate = compareDate.addDays(-1); //getting previous day record
        String Qry;
        
        // Getting list of agreements that has renewal date as yesterday
        List<RecordType> rt = [select id from recordtype where (name='MSP Contracts' or name='HAPP/MPP Contracts') 
                               and SObjectType='Contract'];  
        
        //Getting query list to copy over the Renewal information
        List<Contract> ct = [select id, Renewal_Account_Name_Dealer__c, Renewal_Address_Dealer__c,  Renewal_Annual_Flight_HRS__c,
        Renewal_Customer__c, RENEWAL_DOLLAR_AMT__c, Renewal_End_Date__c, Renewal_Fleet_Discount__c, Renewal_Net_Total_price_for_This_Year__c, Renewal_Notes__c, Renewal_Order_Receipt_Name__c, Renewal_Period_of_Coverage__c, Renewal_Start_date__c,
        Renewal_Last_Year_Price_ZGRT__c, Renewal_MPP_required__c, Renewal_Package_Sent__c, Renewal_Status__c, Account__c,
        Aircraft__c, End_date_Required__c, ANNUAL_HOUR_AMT__c,  TOTAL_DOLLAR_AMT__c, EndDate, NEW_CONTRACT_DOLLAR_AMT__c, Effective_Date__c, Payment_Schedule__c
        from Contract where Renewal_Start_date__c= :compareDate and RecordTypeId IN :rt];

        List<Contract_Account__c> calist    = new List<Contract_Account__c>(); 
        List<ContractContactRole> ccrlist   = new List<ContractContactRole>();
        List<Note> notelist                 = new List<Note>();  
        List<Entitlement__c> entlist        = new List<Entitlement__c>();
         
        for(Integer i=0;i<ct.size();i++){

            if(ct[i].Renewal_Account_Name_Dealer__c != null){
               Contract_Account__c ca = new Contract_Account__c();
               ca.Contract__c = ct[i].id;
               ca.Account__c = ct[i].Renewal_Account_Name_Dealer__c;
               ca.Contract_Account_Role__c='Dealer';
               calist.add(ca);
               Account c = [select id, Report_Address_Line_1__c, Report_Address_Line_2__c, Report_Address_Line_3__c, Report_City_Name__c, Report_Country_Name__c, Report_State_Code__c, Report_Postal_Code__c from Account where id=:ct[i].Renewal_Account_Name_Dealer__c];
               ct[i].BillingCity = c.Report_City_Name__c;
               ct[i].BillingCountry = c.Report_Country_Name__c;
               ct[i].BillingState = c.Report_State_Code__c;
               ct[i].BillingPostalCode = c.Report_Postal_Code__c;
               
               if(c.Report_Address_Line_1__c != null)
                   ct[i].BillingStreet = c.Report_Address_Line_1__c; 
               else{}
               if(c.Report_Address_Line_2__c != null)
                   ct[i].BillingStreet = ct[i].BillingStreet + c.Report_Address_Line_1__c; 
               else
                   ct[i].BillingStreet = ct[i].BillingStreet;
               if(c.Report_Address_Line_3__c != null)
                   ct[i].BillingStreet = ct[i].BillingStreet + c.Report_Address_Line_1__c; 
               else 
                   ct[i].BillingStreet = ct[i].BillingStreet;
            }
            ct[i].Account__c = ct[i].Renewal_Account_Name_Dealer__c;
            ct[i].Renewal_Account_Name_Dealer__c = null;
            //ct[i].Aircraft__c = ct[i].Renewal_Aircraft__c;
            //ct[i].Renewal_Aircraft__c = null;
            ct[i].ANNUAL_HOUR_AMT__c = ct[i].Renewal_Annual_Flight_HRS__c;
            ct[i].Renewal_Annual_Flight_HRS__c = null;
            ct[i].TOTAL_DOLLAR_AMT__c = ct[i].RENEWAL_DOLLAR_AMT__c;
            ct[i].RENEWAL_DOLLAR_AMT__c = null;
            //ct[i].EMS__c = ct[i].Renewal_EMS_Required__c;
            //ct[i].Renewal_EMS_Required__c = false;
           
            if(ct[i].Renewal_End_Date__c != null){
               ct[i].EndDate = ct[i].Renewal_End_Date__c;
               ct[i].End_date_Required__c = 'Yes';
               date startDate = ct[i].Renewal_Start_date__c;
               date endDate = ct[i].Renewal_End_Date__c;
               ct[i].Renewal_Period_of_Coverage__c =  startDate.daysBetween(endDate) + ' ';
            }
            else{
               ct[i].EndDate = ct[i].Renewal_End_Date__c;
               ct[i].End_date_Required__c = 'No'; 
            }
            
            if(ct[i].Renewal_Customer__c != null){
               Contract_Account__c ca = new Contract_Account__c();
               ca.Contract__c = ct[i].id;
               ca.Account__c = ct[i].Renewal_Customer__c;
               ca.Contract_Account_Role__c='Aircraft Owner'; 
               calist.add(ca);
            }
            
            if(ct[i].Renewal_Notes__c != null){
               Note n = new Note();
               Date t = System.today();
               n.Title = 'Renewal Notes '+t.day()+'-'+t.month()+'-'+t.year();
               n.Body = ct[i].Renewal_Notes__c;
               n.Parentid = ct[i].id;
               notelist.add(n);
            }
            
            if(ct[i].Renewal_Order_Receipt_Name__c != null){
               ContractContactRole ccr = new ContractContactRole();
               ccr.ContactId = ct[i].Renewal_Order_Receipt_Name__c;
               ccr.ContractId = ct[i].id;
               ccr.Role = 'Order recipient';
               ccrlist.add(ccr);
            }
            
            if(ct[i].Renewal_Fleet_Discount__c != null){
               List<String> dis = (ct[i].Renewal_Fleet_Discount__c).split('%', 2);
               Entitlement__c et = new Entitlement__c();
               et.Contract_Number__c = ct[i].id;
               et.Entitlement_Type__c = 'Fleet Discount';
               et.Percentage__c = Decimal.valueOf(dis[0]);
               et.Entitlement_Start_Date__c = System.today();
               entlist.add(et);
            }
            
            ct[i].NEW_CONTRACT_DOLLAR_AMT__c = ct[i].Renewal_Net_Total_price_for_This_Year__c;
            ct[i].Renewal_Net_Total_price_for_This_Year__c = null;
            ct[i].Effective_Date__c = ct[i].Renewal_Start_date__c;
            ct[i].Renewal_Start_date__c = null;
            ct[i].Renewal_End_Date__c = null;
            ct[i].Renewal_Notes__c = null;
            ct[i].Renewal_Customer__c = null;
            ct[i].Renewal_Order_Receipt_Name__c = null;
            //ct[i].Payment_Schedule__c = ct[i].Renewal_Payment_Schedule__c;
            //ct[i].Renewal_Payment_Schedule__c = null;
            ct[i].Renewal_Fleet_Discount__c = null;
        }

        update ct;
       
        if(calist.size() > 0)
        {
           insert calist;
        } 
        if(notelist.size() > 0)
        {
           insert notelist;
        }
        if(ccrlist.size() > 0)
        {
           try{
           insert ccrlist;
           }catch(DMLException e){}
        }
        if(entlist.size() > 0)
        {
           insert entlist;
        }      
   }
}