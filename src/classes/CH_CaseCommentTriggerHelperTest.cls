/* commit no data to the database, and are flagged with the testMethod
* keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed
* to a production organization to confirm correctness, ensure code
* coverage, and prevent regressions. All Apex classes are
* required to have at least 75% code coverage in order to be deployed
* 
* to a production organization. In addition, all triggers must have some code coverage.
* 
* The @isTest class annotation indicates this class only contains test
* methods. Classes defined with the @isTest annotation do not count against
* the organization size limit for all Apex scripts.
*
* See the Apex Language Reference for more information about Testing and Code Coverage.
*/
@isTest
public class CH_CaseCommentTriggerHelperTest {
	
	public testMethod static void TestScrambled(){
		list<case> caselst = new list<case>();
		case caserec=new case();
		Id caseRecordtypeid = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		caserec.RecordTypeId = caseRecordtypeid;
		caserec.Allow_admin_login__c=true;
		caserec.Status='Created';
		caserec.Severity__c='major';
		caserec.Subject= 'MySubject 36::83:563::::527';
		caserec.Description= 'Mydesct 36::83:563::::527 68:408:::8:2:28:651.096.953.858';
		caserec.CH_IssueDescription__c='483.937.912.050'; 
		caserec.CH_Outage__c = 'No';
		caserec.Country__c ='India';
		caserec.CH_InitialDiagnosis__c = 'testt';
		caselst.add(caserec);
		
		Test.StartTest();
		Insert caselst;		
		CaseComment cc=new CaseComment();
		cc.CommentBody ='483.937.912.050';
		cc.ParentId = caserec.id;		
		insert cc;
		Test.stopTest();
		
	}
	
	public testMethod static void  updateScrambled(){
		list<case> caselst = new list<case>();
		
		case caserec=new case();
		Id caseRecordtypeid = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		caserec.RecordTypeId = caseRecordtypeid;
		caserec.Allow_admin_login__c=true;
		caserec.Status='Created';
		caserec.Severity__c='major';
		caserec.Subject= 'MySubject 36::83:563::::527';
		caserec.Description= 'Mydesct 36::83:563::::527 68:408:::8:2:28:651.096.953.858';
		caserec.CH_IssueDescription__c='483.937.912.050'; 
		caserec.CH_Outage__c = 'No';
		caserec.Country__c ='India';
		caserec.CH_InitialDiagnosis__c = 'testt';
		caselst.add(caserec);
		Insert caselst;		
		CaseComment cc1=new CaseComment();
		cc1.CommentBody ='063.383.239.641';
		cc1.ParentId = caserec.id;  
		insert cc1;
		Test.StartTest();
		cc1.CommentBody ='483.937.912.050';
		cc1.IsPublished = true;
		update cc1;

		delete cc1;
		Test.stopTest();
	}
	
	
	
}