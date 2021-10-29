@isTest 
public class CaseServiceUtilityTest {
@isTest static void testMethodCaseUtility(){
  Test.startTest(); 
  CaseServiceUtility.getITECUser();
  CaseServiceUtility.getAtrRmuApiUser();
  CaseServiceUtility.getDeniedScreeningAPIUser();
  CaseServiceUtility.getAircraftConnectivity();
  CaseServiceUtility.getEffortlessUser();
  CaseServiceUtility.getMyaerospacewebformUser();
  CaseServiceUtility.getAreoDefaultUser();
  CaseServiceUtility.getGroupID('A1ANHERMACustomerExecutive', 'Role');
  CaseServiceUtility.getCaseEmailId('AEROEBIZSUPPORT-INDS');
  Test.stopTest();
  }
  }