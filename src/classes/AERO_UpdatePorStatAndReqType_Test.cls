@isTest
public class AERO_UpdatePorStatAndReqType_Test {
    
    static testMethod void updateCaseFields(){
        test.startTest();
        list<id> csList = new list<id>();
        case cs = new case(status = 'Open',Subject = 'Test');
        insert cs;
        csList.add(cs.id);
        case cs1 = new case(status = 'Open',Subject = 'Test1');
        insert cs1;
        csList.add(cs1.id);  
        AERO_UpdatePortalStatusAndRequestType updateFields = new AERO_UpdatePortalStatusAndRequestType();
        AERO_UpdatePortalStatusAndRequestType.updateFieldsOnCase(csList);
        test.stopTest();
    }
}