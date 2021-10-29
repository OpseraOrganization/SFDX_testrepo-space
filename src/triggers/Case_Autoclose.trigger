trigger Case_Autoclose on Case (before insert) {
    /*commenting inactive trigger code to improve code coverage-----
    for(case cas:Trigger.New){
        if((cas.subject!=null) && (cas.origin=='Email-GDC Accounts') && ((cas.subject == 'ARINC Update') || (cas.subject=='HONEYWELL FLIGHT TRACKING REQUESTS') || (cas.subject=='OCD Updates 620') || (cas.subject=='OCD Updates 623') || (cas.subject=='PDC Update') || (cas.subject=='Sat Updates') || (cas.subject=='SITA JetBlue Updates') || (cas.subject=='SITA Updates') || (cas.subject=='VHF Updates'))){
            system.debug('SUBJECT : '+cas.Subject);
            system.debug('Owner1: '+cas.OwnerID);
            cas.Resolution__c='None';
            cas.status='Closed';
            cas.Sub_Class__c='';
            cas.Export_Compliance_Content_ITAR_EAR__c='No';
            cas.Government_Compliance_SM_M_Content__c='No';
        }
        // added code for SR#:351151
        String uid = Userinfo.getuserid();
        User usr = [Select id, Email from User where id =: uid];
        if(usr.Email.contains('@newslett')){
            cas.addError('Case cannot be created with mail id contains @newslett');
        }
        // End for SR#:351151
    }*/
}