public class CreateCMDPack4Request{
 
	public static DOM.Document createRequest(Map<String,list<Sales_Role_Audit__c>> srtData){
		User objUser= [select timezonesidkey from user where Id =:UserInfo.getUserId()];
		Datetime endDateTime = Datetime.newInstance(9999,12,31);
		string strEndDateTime= endDateTime.format('MM/dd/yyyy HH:mm:ss', objUser.timezonesidkey );
		
		DOM.Document doc = new DOM.Document();
		
		String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
		String xsd = 'http://www.w3.org/2001/XMLSchema';
		String xsi='http://www.w3.org/2001/XMLSchema-instance';
		
		String endpoint = 'http://nsn.com/scmd/createProspectSFStartProcess/';
		
		dom.XmlNode envelope= doc.createRootElement('Envelope', soapNS, '');
		
		
		dom.XmlNode body = envelope.addChildElement('Body', soapNS, null);
		
		dom.XmlNode updateOwnerDetails = body.addChildElement('updateRoleOwnerDetails', 'http://nsn.com/cmd/service/', '');
		updateOwnerDetails.setNamespace('xsi', xsi);
		
		dom.XmlNode salesHierarchyRequest = updateOwnerDetails.addChildElement('salesHierarchyRequest','',''); 
		
		for(String salesHierarchyID : srtData.keySet()){
			 salesHierarchyRequest.addChildElement('SalesHierarchyID',null, null).addTextNode(salesHierarchyID);
			 for(Sales_Role_Audit__c SRTAudit: srtData.get(salesHierarchyID)){
				dom.XmlNode roleOwnerDetails = salesHierarchyRequest.addChildElement('roleOwnerDetails',null, null); 
				roleOwnerDetails.addChildElement('RoleCode', null, null).addTextNode(String.isBlank(SRTAudit.Role_Code__c)?'':SRTAudit.Role_Code__c);
				roleOwnerDetails.addChildElement('RoleOwnerNokiaID', null, null).addTextNode(String.isBlank(SRTAudit.Role_Owner_ID__c)?'':SRTAudit.Role_Owner_ID__c);
				string strStartDateTime= SRTAudit.Role_Start_Date__c.format('MM/dd/yyyy HH:mm:ss', objUser.timezonesidkey );
				 
				 //roleOwnerDetails.addChildElement('RoleStartDate', null, null).addTextNode(String.isBlank(SRTAudit.Role_Start_Date__c+'')?'':SRTAudit.Role_Start_Date__c+'');
				//roleOwnerDetails.addChildElement('RoleEndDate', null, null).addTextNode(String.isBlank(SRTAudit.Role_End_Date__c+'')?'':SRTAudit.Role_End_Date__c+'');
				roleOwnerDetails.addChildElement('RoleStartDate', null, null).addTextNode(strStartDateTime);
				roleOwnerDetails.addChildElement('RoleEndDate', null, null).addTextNode(strEndDateTime);
				 
				//roleOwnerDetails.addChildElement('RoleStartDate', null, null).addTextNode('2017-04-03T10:00:05');
				//roleOwnerDetails.addChildElement('RoleEndDate', null, null).addTextNode('9999-12-30T18:30:00');
				
				roleOwnerDetails.addChildElement('BGAttribute', null, null).addTextNode(String.isBlank(SRTAudit.BG__c)?'':SRTAudit.BG__c);
				roleOwnerDetails.addChildElement('OperationType', null, null).addTextNode(String.isBlank(SRTAudit.Operation_Type__c)?'':SRTAudit.Operation_Type__c);
			 }
		}
		
		System.debug(doc.toXmlString());
		
		return doc;

	}
}