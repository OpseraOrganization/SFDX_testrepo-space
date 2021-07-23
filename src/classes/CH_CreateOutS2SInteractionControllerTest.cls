@isTest
private class CH_CreateOutS2SInteractionControllerTest {
 @isTest
  private static void resendOutboundS2SInteractionTest() {
  Interface_Log__c Inlog= new Interface_Log__c();
  Inlog.Message_Type__c='Outbound';
   Inlog.Interface_Type__c='Customer S2S';
	Inlog.Name='S2S Case';
	insert Inlog;
	
  CH_CreateOutS2SInteractionController.sendS2SInteraction(Inlog.id);  
  
  }
}