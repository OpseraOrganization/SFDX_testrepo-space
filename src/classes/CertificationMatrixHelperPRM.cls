/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
Name:			CertificationMatrixHelperPRM
Description:	 CertificationMatrixTriggerHelperPRMTest class to test values and perform DML operations on CertificationMatrix object
Date		Version	  Author		Summary of Changes 
-----------	  ----------	  -----------------	---------------------------------------------------------------------------------------------------
12/09/2017	 1.0		  supriyam			helper class for certification Matrix trigger
----------------------------------------------------------------------------------------------------------------------------------------------------------*/
	  
public class CertificationMatrixHelperPRM {
			 /**
* Description : method to update gpp certification name field when record is updated
Name - updateGPPFields
* @param Certification_MatrixOldMap Certification_MatrixNewMap
* @return User
* @throws NA
**/   
	public static void updateGPPFields(Map<id,Certification_Matrix__c> Certification_MatrixOldMap , Map<id,Certification_Matrix__c> Certification_MatrixNewMap ){
		Set<ID> CerMatID = new Set<ID>();
		try{
			for(Certification_Matrix__c CMID : Certification_MatrixNewMap.values()){
				 if(Certification_MatrixOldMap.get(CMID.Id).GPP_0_0__c != Certification_MatrixNewMap.get(CMID.Id).GPP_0_0__c){
				CerMatID.add(CMID.Id);
					 }
						 if(Certification_MatrixOldMap.get(CMID.Id).GPP_1_0__c != Certification_MatrixNewMap.get(CMID.Id).GPP_1_0__c){
				CerMatID.add(CMID.Id);
					 }
						 if(Certification_MatrixOldMap.get(CMID.Id).GPP_2_0__c != Certification_MatrixNewMap.get(CMID.Id).GPP_2_0__c){
				CerMatID.add(CMID.Id);
					 }
						 if(Certification_MatrixOldMap.get(CMID.Id).GPP_3_0__c != Certification_MatrixNewMap.get(CMID.Id).GPP_3_0__c){
				CerMatID.add(CMID.Id);
					 
						 }
			}
						 LIST<Certification__c> certdetailsUpdate = new LIST<Certification__c>();
			for (Certification__c certDetails : [select Partner__c,Partner__r.Partner_Program__c,GPP_Certification_Name__c,Certification_Matrix_Number__r.GPP_0_0__c,Certification_Matrix_Number__r.GPP_1_0__c,Certification_Matrix_Number__r.GPP_2_0__c,Certification_Matrix_Number__r.GPP_3_0__c from Certification__c where Certification_Matrix_Number__c in:CerMatID]){
				if(certDetails.Partner__r.Partner_Program__c == 'GPP 0.0'){
					certDetails.GPP_Certification_Name__c = certDetails.Certification_Matrix_Number__r.GPP_0_0__c;
				}else if(certDetails.Partner__r.Partner_Program__c == 'GPP 1.0'){
					certDetails.GPP_Certification_Name__c = certDetails.Certification_Matrix_Number__r.GPP_1_0__c;
				}else if(certDetails.Partner__r.Partner_Program__c == 'GPP 2.0'){
					certDetails.GPP_Certification_Name__c = certDetails.Certification_Matrix_Number__r.GPP_2_0__c;
				}else if(certDetails.Partner__r.Partner_Program__c == 'GPP 3.0'){
					certDetails.GPP_Certification_Name__c = certDetails.Certification_Matrix_Number__r.GPP_3_0__c;
				}
				certdetailsUpdate.add(certDetails); 
			}
			database.update(certdetailsUpdate, false);
		}
			
	   catch(exception e){
			   
			}
	
			}	
	   
		}