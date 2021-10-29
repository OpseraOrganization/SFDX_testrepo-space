trigger CSWIuptcustomername on Customer_Specific_Work_Instruction__c (before insert,before update) {
    string profileId = userinfo.getProfileId();
    string customLabel = Label.Aero_Data_Load_Profile;
    //string customLabel = Label.Data_Loading_Profile;
    List<id> cswiaccId = new List<id>(); 
    List<string> custcode = new List<string>();
    List <Customer_Specific_Work_Instruction__c> dupcswi = new List<Customer_Specific_Work_Instruction__c>();
    Set<String> setupcswi = new  set<String> ();
    //Set<Integer> setupcswi = new  set<Integer> ();
    List<Customer_Specific_Work_Instruction__c> cswiId = new List<Customer_Specific_Work_Instruction__c>(); 
    system.debug('--upid--'+userinfo.getProfileId());
    if(!customLabel.contains(profileId.substring(0,profileId.length()-3))){
        system.debug('--entered--');
        for(Customer_Specific_Work_Instruction__c cswi:trigger.new){
           //Code for INC000005988436 starts
                  if((null!=cswi.customer_code__c)&&(cswi.customer_code__c.isNumeric())){
                      System.debug('length : '+cswi.Customer_Code__c.length());
                      if (null!=cswi.Customer_Code__c && cswi.Customer_Code__c.length()<10){
                            string temp='';
                          for (Integer i=1;i<=(10-cswi.Customer_Code__c.length());i++)
                          {
                           temp=temp+'0';
                          }  
                         cswi.Customer_Code__c=temp+cswi.Customer_Code__c;                
                      }    
        }
        system.debug('after  :'+cswi.Customer_Code__c);
           //Code for INC000005988436 End
            if((Trigger.isInsert || (Trigger.isUpdate && System.Trigger.OldMap.get(cswi.id).Account__c != cswi.Account__c)) && cswi.Account__c !=null){  
                cswiaccId.add(cswi.Account__c);                           
                cswiId.add(cswi);
            }
            //code added for SRINC000005682650 -  Starts   
            if(cswi.customer_code__c != null && (Trigger.isInsert || (Trigger.isUpdate && System.Trigger.OldMap.get(cswi.id).customer_code__c != cswi.customer_code__c))){
                 //Code for INC000005988436 starts
                  if((null!=cswi.customer_code__c)&&(cswi.customer_code__c.isNumeric()))
                     custcode.add('%'+ Long.valueof(cswi.customer_code__c)); 
                 else
                 //Code for INC000005988436 Ends
                     custcode.add(cswi.customer_code__c);
            }    
        }
        if (custcode.size()>0){
            dupcswi = [select id, Customer_Code__c from Customer_Specific_Work_Instruction__c where Customer_Code__c like : custcode];
            for(Customer_Specific_Work_Instruction__c  csdup : dupcswi )
            {
                //Code for INC000005988436 Starts
                if(null!=csdup.customer_code__c && csdup.customer_code__c.isNumeric())
                    setupcswi.add(''+Long.valueof(csdup.Customer_Code__c) );
                else
                //Code for INC000005988436 Ends
                    setupcswi.add(csdup.Customer_Code__c );
            }
          if (setupcswi.size()>0){
            for(Customer_Specific_Work_Instruction__c  cs : trigger.new){
                //Code for INC000005988436 Starts
                if(null!=cs.customer_code__c && cs.customer_code__c.isNumeric())
                {
                    if(setupcswi.contains(''+Long.valueof(cs.Customer_Code__c)))
                        cs.addError('Duplicate Customer Code  found!'); 
                }       
                else
                {
                //Code for INC000005988436 Ends
                    if(setupcswi.contains(cs.Customer_Code__c))
                     cs.addError('Duplicate Customer Code  found!');
                }
            }    
         }
       }
        //code added for SRINC000005682650 -  Ends 
        if (cswiaccId.size()>0){
        Map<id,Account> mapAccCSWI= new Map<id,Account>([select id,Name from Account where id IN: cswiaccId]);    
        for(Customer_Specific_Work_Instruction__c cswi:cswiId){        
                Account acc = mapAccCSWI.get(cswi.Account__c);
                if (acc != null){
                cswi.Customer_Name__c = acc.Name;    
           }                         
         }   
       }
    }
}