/*********************************************
    Test Class Name  : RDF_OneOffExtApprovalPageCtrlTest 
    Class Name       : RDF_OneOffExternalApprovalCntrl
    Created On       : 27th Aug 2018
    Project          : RDF - One - Off Discount process
    Created By       : NTTDATA INC
    Purpose          : This class is used for code coverage for RDF_OneOffExternalApprovalCntrlTest.
*********************************************/
@isTest
public class RDF_OneOffExtApprovalPageCtrlTest 
{
 static testmethod void submitForApprovalTest(){       
        Set<String> contentDocIdSet = new Set<String>();
        Case newcase=new Case(subject='Fax:{9986502495} test data',Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
                Type='Order',Customer_PO_RO_WONumber__c='43545',workstrem__c='Spares' ,CSM_Region__c='EMEAI',FSE_Name_1__c=Userinfo.getUserid(),FSE_Name_2__c=Userinfo.getUserid(),FSE_Name_3__c=Userinfo.getUserid(), 
        Supported_Product__c='Radio',Origin ='Email-Disputes',Primary_Email__c='test.11@test.com');
        insert newcase;       
        ApexPages.StandardController sc = new ApexPages.StandardController(newcase);
        Id currentRecordId  = ApexPages.CurrentPage().getparameters().put('id',newcase.id);      
       
    RDF_OneOffExternalApprovalCntrl rdf2=new RDF_OneOffExternalApprovalCntrl(sc);
        rdf2.sendEmail(newcase,contentDocIdSet,'External');
        rdf2.validateandSubmit();
        rdf2.back();
        rdf2.doSendToCommunity();
    }
    static testmethod void submitForApprovalTest2(){       
        Set<String> contentDocIdSet = new Set<String>();
        Case newcase=new Case(subject='Fax:{9986502495} test data',Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
                Type='Order',Customer_PO_RO_WONumber__c='43545',workstrem__c='Spares' ,CSM_Region__c='EMEAI',
        User_VN_Name__c=Userinfo.getUserid(),  Supported_Product__c='Radio',Origin ='Email-Disputes',Primary_Email__c='test.11@test.com');
        insert newcase;       
        ApexPages.StandardController sc = new ApexPages.StandardController(newcase);
        Id currentRecordId  = ApexPages.CurrentPage().getparameters().put('id',newcase.id);      
       
    RDF_OneOffExternalApprovalCntrl rdf2=new RDF_OneOffExternalApprovalCntrl(sc);
        rdf2.sendEmail(newcase,contentDocIdSet,'Internal');
        rdf2.validateandSubmit();
        rdf2.back();
        rdf2.doSendToCommunity();
    }
    static testmethod void submitForApprovalTest3(){       
        Set<String> contentDocIdSet = new Set<String>();
        Case newcase=new Case(subject='Fax:{9986502495} test data',Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
                Type='Order',Customer_PO_RO_WONumber__c='43545',workstrem__c='Spares' ,CSM_Region__c='EMEAI',FSE_Name_1__c=Userinfo.getUserid(),FSE_Name_2__c=Userinfo.getUserid(),FSE_Name_3__c=Userinfo.getUserid(),
        User_VN_Name__c=Userinfo.getUserid(),Show_in_Community_Flag__c = True,Classification__c = 'Customer Approved' , Supported_Product__c='Radio',Origin ='Email-Disputes',Primary_Email__c='test.11@test.com');
        insert newcase;       
        ApexPages.StandardController sc = new ApexPages.StandardController(newcase);
        Id currentRecordId  = ApexPages.CurrentPage().getparameters().put('id',newcase.id);      
       
    RDF_OneOffExternalApprovalCntrl rdf2=new RDF_OneOffExternalApprovalCntrl(sc);
        rdf2.sendEmail(newcase,contentDocIdSet,'Internal');
        rdf2.validateandSubmit();
        rdf2.back();
        rdf2.doSendToCommunity();
    }
    static testmethod void submitForApprovalTest4(){       
        Set<String> contentDocIdSet = new Set<String>();
        ID RecTypeId = RecordTypeServices.getrecordtypebyName('One-Off Discount','Case').Id;
        Case newcase=new Case(subject='Fax:{9986502495} test data',Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
                Type='Order',Customer_PO_RO_WONumber__c='43545',workstrem__c='Spares' ,CSM_Region__c='EMEAI',FSE_Name_1__c=Userinfo.getUserid(),FSE_Name_2__c=Userinfo.getUserid(),FSE_Name_3__c=Userinfo.getUserid(),
        User_VN_Name__c=Userinfo.getUserid(),Show_in_Community_Flag__c = False,Classification__c = '' , Supported_Product__c='Radio',Origin ='Email-Disputes',Primary_Email__c='test.11@test.com',
        Is_Record_Submited_for_Approval__c = True,Sub_Status__c ='',RecordTypeId = RecTypeId );
        insert newcase;       
        ApexPages.StandardController sc = new ApexPages.StandardController(newcase);
        Id currentRecordId  = ApexPages.CurrentPage().getparameters().put('id',newcase.id);      
       
    RDF_OneOffExternalApprovalCntrl rdf2=new RDF_OneOffExternalApprovalCntrl(sc);
        rdf2.sendEmail(newcase,contentDocIdSet,'Internal');
        rdf2.validateandSubmit();
        rdf2.back();
         rdf2.doSendToCommunity();
    }
    static testmethod void submitForApprovalTest5(){       
        Set<String> contentDocIdSet = new Set<String>();
        Case newcase=new Case(subject='Fax:{9986502495} test data',Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
                Type='Order',Customer_PO_RO_WONumber__c='43545',workstrem__c='Spares' ,CSM_Region__c='EMEAI',FSE_Name_1__c=Userinfo.getUserid(),FSE_Name_2__c=Userinfo.getUserid(),FSE_Name_3__c=Userinfo.getUserid(),
        User_VN_Name__c=Userinfo.getUserid(),Show_in_Community_Flag__c = False,Classification__c = '' , Supported_Product__c='Radio',Origin ='Email-Disputes',Primary_Email__c='test.11@test.com',
        Is_Record_Submited_for_Approval__c = True,Sub_Status__c ='Rejected');
        insert newcase;       
        ApexPages.StandardController sc = new ApexPages.StandardController(newcase);
        Id currentRecordId  = ApexPages.CurrentPage().getparameters().put('id',newcase.id);      
       
    RDF_OneOffExternalApprovalCntrl rdf2=new RDF_OneOffExternalApprovalCntrl(sc);
        rdf2.sendEmail(newcase,contentDocIdSet,'Internal');
        rdf2.validateandSubmit();
        rdf2.back();
         rdf2.doSendToCommunity();
    }
    static testmethod void submitForApprovalTest6(){       
        Set<String> contentDocIdSet = new Set<String>();
        Case newcase=new Case(subject='Fax:{9986502495} test data',Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
                Type='Order',Customer_PO_RO_WONumber__c='43545',workstrem__c='Spares' ,CSM_Region__c='EMEAI',FSE_Name_1__c=Userinfo.getUserid(),FSE_Name_2__c=Userinfo.getUserid(),FSE_Name_3__c=Userinfo.getUserid(),
        User_VN_Name__c=Userinfo.getUserid(),Show_in_Community_Flag__c = False, Supported_Product__c='Radio',Origin ='Email-Disputes',Primary_Email__c='test.11@test.com',
        Is_Record_Submited_for_Approval__c = false,Sub_Status__c ='',Classification__c ='Customer Approved' );
        insert newcase;       
        ApexPages.StandardController sc = new ApexPages.StandardController(newcase);
        Id currentRecordId  = ApexPages.CurrentPage().getparameters().put('id',newcase.id);      
       
    RDF_OneOffExternalApprovalCntrl rdf2=new RDF_OneOffExternalApprovalCntrl(sc);
        rdf2.sendEmail(newcase,contentDocIdSet,'Internal');
        rdf2.validateandSubmit();
        rdf2.back();
        rdf2.doSendToCommunity();
    }    
    static testmethod void submitForApprovalTest7(){       
        Set<String> contentDocIdSet = new Set<String>();
        Id RecTypeId = RecordTypeServices.getrecordtypebyName('One-Off Discount','Case').Id;
         Case newcase=new Case(subject='Fax:{9986502495} test data',Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
                Type='Order',Customer_PO_RO_WONumber__c='43545',workstrem__c='Spares' ,CSM_Region__c='EMEAI',FSE_Name_1__c=Userinfo.getUserid(),FSE_Name_2__c=Userinfo.getUserid(),FSE_Name_3__c=Userinfo.getUserid(),
        User_VN_Name__c=Userinfo.getUserid(),Show_in_Community_Flag__c = False, Supported_Product__c='Radio',Origin ='Email-Disputes',Primary_Email__c='test.11@test.com',
        Is_Record_Submited_for_Approval__c = false,Sub_Status__c ='',Status='New',RecordTypeId = RecTypeId );
        insert newcase;
        
        SEA_Approval__c sObj = new SEA_Approval__c();
        sobj.Approval_Status__c ='Not Submitted';
        sObj.case__c=newcase.id;
        sobj.Name= 'Test';
        sobj.Approver_Name__c=Userinfo.getUserid();
        insert sobj;        
        ApexPages.StandardController sc = new ApexPages.StandardController(newcase);
        Id currentRecordId  = ApexPages.CurrentPage().getparameters().put('id',newcase.id);      
       
    RDF_OneOffExternalApprovalCntrl rdf2=new RDF_OneOffExternalApprovalCntrl(sc);
        rdf2.sendEmail(newcase,contentDocIdSet,'Internal');
        rdf2.validateandSubmit();
        rdf2.back();
        rdf2.doSendToCommunity();
    }    
    static testmethod void submitForApprovalTest8(){       
        Set<String> contentDocIdSet = new Set<String>();
        Case newcase=new Case(subject='Fax:{9986502495} test data',Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
                Type='Order',Customer_PO_RO_WONumber__c='43545',workstrem__c='Spares' ,CSM_Region__c='EMEAI',FSE_Name_1__c=Userinfo.getUserid(),FSE_Name_2__c=Userinfo.getUserid(),FSE_Name_3__c=Userinfo.getUserid(),
        User_VN_Name__c=Userinfo.getUserid(),Show_in_Community_Flag__c = True,Classification__c = '' , Supported_Product__c='Radio',Origin ='Email-Disputes',Primary_Email__c='test.11@test.com');
        insert newcase;       
        ApexPages.StandardController sc = new ApexPages.StandardController(newcase);
        Id currentRecordId  = ApexPages.CurrentPage().getparameters().put('id',newcase.id);      
      
      case cs1 = new case();
    RDF_OneOffExternalApprovalCntrl rdf2=new RDF_OneOffExternalApprovalCntrl(sc);
        rdf2.sendEmail(cs1 ,contentDocIdSet,'External');
        rdf2.validateandSubmit();
        rdf2.back();
        rdf2.doSendToCommunity();
    }
}