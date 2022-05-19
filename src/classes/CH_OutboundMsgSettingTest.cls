@isTest
public class CH_OutboundMsgSettingTest {
	 public static testMethod void test() {
		 insert new CH_OutboundMessageSettings__c(Name = 'CreatedForTestClass');
		 CH_OutboundMessageSettings__c oms=[SELECT Name from CH_OutboundMessageSettings__c where Name='CreatedForTestClass'];
		 oms.CaseFeedEmailCauseAnalysisReport__c = true ;
		 CH_OutboundMsgSetting.upsertOutBoundRecord(oms);
		 CH_OutboundMsgSetting.getOMSList();
		 CH_OutboundMsgSetting.getOMS('CreatedForTestClass');
		 CH_OutboundMsgSetting.isOMSPresent('CreatedForTestClass');
		 CH_OutboundMsgSetting.deleteOMS('CreatedForTestClass');
		 CH_OutboundMsgSetting.accessToOBM(UserInfo.getUserId());
		 insert new CH_InterfacingMapping__c(Name='reportLink',ReportUrl__c = 'test');
		 CH_OutboundMsgSetting.getReportLink();
	 }
}