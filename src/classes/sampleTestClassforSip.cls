@isTest
                private class sampleTestClassforSip
                {
                     public static testMethod void testocc()
                    {
                    
                     Test.startTest();
            
            
           user u= [select id,SIP_Primary_Mgr__c,SIP_Secondary_Mgr__c,Finance__c,SIP_Tertiary_Mgr__c,Comp_and_Ben_Owner__c from user where Email!='' limit 1];
            
            
               
               SIP_Tickets__c sipObj1=new SIP_Tickets__c();
               sipObj1.Ticket_on_behalf_of__c=u.id;
               sipObj1.Reason_for_Request__c = 'Requesting Xactly Access';
               sipObj1.Ownerid=Label.aero_default_user_id;
               insert sipobj1;
                
              Test.stopTest();     
                 
        }
        }