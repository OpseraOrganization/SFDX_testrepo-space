/*** @description: To set the Visibility to ALL Users for Files uploaded on Reimbursement(CoOp_Claim_Payment__c) object. 
* ============================================================================
*
* VERSION	   AUTHOR				  DATE		
* 1.0		 Avnish (HCL)		   15/12/2018
* ============================================================================ 
*/

trigger UpdateContentDocumentLinkVisibility on ContentDocumentLink(before insert) {
	for(ContentDocumentLink cdl : trigger.new)
				{
					Map<ID, CoOp_Claim_Payment__c> cd = new Map<ID, CoOp_Claim_Payment__c>([select id from CoOp_Claim_Payment__c where id=:cdl.LinkedEntityId]);
						if(cd.containsKey(cdl.LinkedEntityId))
							{
								System.debug('Avn...'+cdl.LinkedEntityId);
							   cdl.Visibility='AllUsers';
							}
				}
	 }