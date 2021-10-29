trigger Marcom_Ticket_Routing on Marcom_Service_Request__c (before insert) {
    List<Marcom_Service_Request__c> MarcomSRList = new List<Marcom_Service_Request__c>();
    List<Marcom_Request_Ticket_Routing__c> MarcomrequestRoutingList=new List<Marcom_Request_Ticket_Routing__c>();
    MarcomrequestRoutingList=[select id,Marcom_Audience__c,Carbon_Copy__c,Marcom_Market__c,Marcom_Region__c,Owner__c,name from Marcom_Request_Ticket_Routing__c Limit 10000 ];
    set<Id>MarcomSet = new set<Id>();
    set<Id>MarcomSet1 = new set<Id>();
    String[] ccAddresses = null;
    for(Marcom_Service_Request__c MarcomSR:trigger.new){    
        for(Marcom_Request_Ticket_Routing__c MRTC:MarcomrequestRoutingList){    
            if(MRTC.Marcom_Audience__c==MarcomSR.Marcom_Audience__c && MRTC.Marcom_Market__c==MarcomSR.Marcom_Market__c && MRTC.Marcom_Region__c==MarcomSR.Marcom_Request_Region__c){
                MarcomSR.OwnerId=MRTC.Owner__c; 
                ccAddresses = MRTC.Carbon_Copy__c.split('\n');
            }
        }
        MarcomSet1.add(MarcomSR.OwnerId);       
        //List<User> userList= new List<user>();
        //userList = [Select Id, Name,email from user where Id IN:MarcomSet1];
        for(user u:[Select Id, Name,email from user where Id IN:MarcomSet1] ){
            system.debug('------->'+u.email);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {u.email};
            mail.setToAddresses(toAddresses);
            string field1='<b>Business/communications :</b>    '+ MarcomSR.Marcom_Business__c;
            string field2='<b>audience:</b>    '+ MarcomSR.Marcom_Audience__c;
            string field3='<b>Related to this activity:</b>    '+ MarcomSR.Marcom_Related_Activity__c;
            string field4='<b>Market:</b>    '+ MarcomSR.Marcom_Market__c;
            string field5='<b>Region :</b>    '+ MarcomSR.Marcom_Request_Region__c;
            string field6='<b>Requested Timeline:</b>    '+ MarcomSR.Marcom_Request_Timeline__c;
            mail.setCcAddresses(ccAddresses);
            mail.setTargetObjectId(MarcomSR.Id);
            mail.setSaveAsActivity(false);  
            mail.setHtmlBody('<b> New  Request Created   </b><br/>' + '<br/>'+field1+'<br/>'+field2+'<br/>'+field3+'<br/>'+field4+'<br/>'+field5+'<br/>'+field6);                           
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }  
    }
}