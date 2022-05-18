/***************************************************************
* Class Name : CH_csvDownloadCtrlTest   test
* Created Date: 28 March 2020
* Description : Test class for CH_csvDownloadCtrlTest
***************************************************************/

@isTest
public class CH_csvDownloadCtrlTest {
  @isTest
  public static void fetchCase(){
  
  Test.startTest();
	CH_csvDownloadCtrl.fetchCase();
	String Datevar=string.valueof(Date.Today());
	CH_csvDownloadCtrl.getExcelFileAsBase64String('HWS', Datevar, Datevar, 'Assigned');
	CH_csvDownloadCtrl.getCaseInfoForDownload('HWS',Date.Today(), Date.Today(), 'Assigned');
	CH_csvDownloadCtrl.getCaseInfoForDownload('SWS',Date.Today(), Date.Today(), 'Assigned'); // Added for NOKIASC-35556
	CH_csvDownloadCtrl.getHWS_GenericSettings();
  Test.stopTest();
  
  }
  
}