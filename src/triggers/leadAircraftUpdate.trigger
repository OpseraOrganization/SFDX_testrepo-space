trigger leadAircraftUpdate on Lead (before insert, before update) 
{
    integer errLoc =0;
    string tmpId;
    try
    {   
        errLoc = 10;
        for (Lead ld : Trigger.new)
        if((Trigger.new.size() == 1) && (ld.recordtypeid == label.BGA_Honeywell_Prospect || ld.recordtypeid == label.BGA_Honeywell_Prospect_Convert))
        {
            tmpId = ld.Id;
            errLoc = 20;
            List<Fleet_Asset_Detail__c> objAir = [select SERIAL_NUMBER__C, TAIL_NUMBER__C,Make__c,Model__c  from Fleet_Asset_Detail__c WHERE Id=:ld.Aircraft__c ];
            errLoc = 30;
            for( integer i =0;i< objAir.size();i++)
            {
                errLoc = 40;
             /*   ld.Serial_Number__c = objAir[i].SERIAL_NUMBER__C;*/
                errLoc = 41;
                ld.Aircraft_Serial_Number__c =objAir[i].SERIAL_NUMBER__C;
                errLoc = 50;
                ld.Aircraft_Make__c = objAir[i].Make__c;
                errLoc = 60;
                ld.Aircraft_Tail_Number__c = objAir[i].TAIL_NUMBER__C;
                errLoc = 70;
                ld.Aircraft_Model__c = objAir[i].Model__c;
            }
            
            /*if(ld.Aircraft__c == null)
            {
                //ld.Serial_Number__c = null;
                ld.Aircraft_Serial_Number__c = null;
                ld.Aircraft_Make__c = null;
                ld.Aircraft_Tail_Number__c = null;
                ld.Aircraft_Model__c = null;
            }*/
            
            
            
        }
        
     
        
    }
    catch(Exception e)
    {
     utilClass.createErrorLog('leadAircraftUpdate','leadAircraftUpdate','errLoc - ' + errLoc + ' - ' + tmpId + ' - ' + e.getMessage());     
    }

}