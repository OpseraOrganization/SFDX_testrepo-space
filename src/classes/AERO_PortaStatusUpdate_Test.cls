@isTest
public class AERO_PortaStatusUpdate_Test {
	
    static testMethod void updateFieldsByBatch(){
        
        dateTime startDate = system.now().addDays(-1);
        dateTime endDate = system.now().addDays(1);
        id recId = Schema.SObjectType.case.getRecordTypeInfosByName().get('AOG').getRecordTypeId();
        case cs = new case(status = 'Open',Subject = 'Test',recordTypeId = recId);
        insert cs;
        test.startTest();
        AERO_PortalStatusUpdate bc = new AERO_PortalStatusUpdate(startDate,endDate);
        database.executeBatch(bc);
        test.stopTest();
    }
    
    static testMethod void updateFieldsByBatch1(){
        
        dateTime startDate;
        dateTime endDate;
        id recId = Schema.SObjectType.case.getRecordTypeInfosByName().get('AOG').getRecordTypeId();
        case cs = new case(status = 'Open',Subject = 'Test',recordTypeId = recId);
        insert cs;
        test.startTest();
        AERO_PortalStatusUpdate bc = new AERO_PortalStatusUpdate();
        database.executeBatch(bc);
        test.stopTest();
    }
}