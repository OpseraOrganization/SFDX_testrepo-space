@isTest
public class DeiniedPartyResponse_Test{
    static testmethod void DeiniedPartyResponse_MethodTest(){
    
        DeiniedPartyResponse.SPL_ADDRESS_cls splAddress = new DeiniedPartyResponse.SPL_ADDRESS_cls();
        splAddress.LAUNR = '11';
        splAddress.SPL_STREET1 = 'Test 1';
        splAddress.SPL_CITY = 'Test 2';
        splAddress.SPL_COUNTRY = 'India';
        
        List<DeiniedPartyResponse.SPL_ADDRESS_cls> splAddressList = new List<DeiniedPartyResponse.SPL_ADDRESS_cls>();
        splAddressList.add(splAddress);
        
        DeiniedPartyResponse.SPL_NAME_cls splName = new DeiniedPartyResponse.SPL_NAME_cls();
        splName.LAUNR = '11';
        splName.SPL_NAME1 = 'Test 1';
        splName.SPL_ID_NUMBER = '1231';
        List<DeiniedPartyResponse.SPL_NAME_cls> splNameList = new List<DeiniedPartyResponse.SPL_NAME_cls>();
        splNameList.add(splName);
        
        DeiniedPartyResponse.SPL_ENTITIY_cls splEntity = new DeiniedPartyResponse.SPL_ENTITIY_cls();

        splEntity.LGREG= 'Test1';
        splEntity.SPL_LIST_TYPE = 'Test1';
        splEntity.SPL_PROVIDER_ID = 'Test1';
        splEntity.SPL_DATA_REF_ID = 'Test1';
        splEntity.SPL_ENTRY_DATE= 'Test1';
        splEntity.SPL_TZONE_ENTRY= 'Test1';
        splEntity.SPL_FILE_ID= 'Test1';
        splEntity.SPL_COMMENT1= 'Test1';
        splEntity.SPL_COMMENT2= 'Test1';
        splEntity.SPL_COMMENT3= 'Test1';
        splEntity.SPL_NAME = splNameList;
        splEntity.SPL_ADDRESS = splAddressList;
        List<DeiniedPartyResponse.SPL_ENTITIY_cls> splEntitylist = new List<DeiniedPartyResponse.SPL_ENTITIY_cls>();
        splEntitylist.add(splEntity);
        
        DeiniedPartyResponse.ADDRNUMBER_cls splAddrNumber  = new DeiniedPartyResponse.ADDRNUMBER_cls();

        splAddrNumber.ADDRESS_ID = 'Test1';
        splAddrNumber.BPTYP= 'Test1';
        splAddrNumber.BPVSY= 'Test1';
        splAddrNumber.ADDRESS_BLOCKED= 'Test1';
        splAddrNumber.USER_ACTION= 'Test1';
        splAddrNumber.RELEASE_REASON_SCHEMA= 'Test1';
        splAddrNumber.RELEASE_REASON= 'Test1';
        splAddrNumber.SPL_ENTITIY = splEntitylist;
        list<DeiniedPartyResponse.ADDRNUMBER_cls> splAddrNumberList = new list<DeiniedPartyResponse.ADDRNUMBER_cls>();
        
        test.startTest();
        DeiniedPartyResponse.SPL_OFFLINE_SCREENING_RESULT(splAddrNumberList);
        test.stopTest();
    }
}