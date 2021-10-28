/**
 * Created by bkandov on 16/05/2018.
 */

public with sharing class NCP_EmergencyContact_Wrapper {

	@auraEnabled
	public List<NCP_EmergencySupport_Wrapper> CARES_TelephoneContact { get; set; }

	@auraEnabled
	public List<NCP_EmergencySupport_Wrapper> CARES_EmailSupport { get; set; }

	@auraEnabled
	public List<NCP_EmergencySupport_Wrapper> NCT_TelephoneContact { get; set; }

}