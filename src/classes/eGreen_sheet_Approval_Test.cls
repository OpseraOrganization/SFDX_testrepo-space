/**
 * Created by satya Mohanty on 5/25/2020.
 */
@isTest
private class eGreen_sheet_Approval_Test
{
    private static Platform__c platform;
    private static Account account;
    private static Workflow_details__c workflow;
    private static Profile profile;
    private static User user;
    private static Approver__c appMPM;
    private static Approver__c appFinance;
    private static Approver__c appProduct;
    private static Approver__c appBusiness;
    private static Approver__c appContract;
    private static Approver__c appNotification;
    private static Approver__c appAdditional;
    private static eGreen_sheet_Approval workflowApproval;
    private static server_details__c server;

    static void init() {
        platform = new Platform__c();
        platform.name='PLF_Test_rec';
        insert platform;

        server = new server_details__c();
        server.servername__c = 'notused';
        server.Name ='Servername';

        insert server;

        account = new Account();
        account.name='Acc_Text_rec';
        account.Type='OEM';
        account.Strategic_Business_Unit__c='ATR';
        account.CBT__c='Airbus';
        account.Customer_Status__c='Active';
        account.Region_Name__c='Americas';
        account.Sub_Region_Name__c='Canada';
        account.Service_Level__c='Standard';
        account.Sales_Channel__c = 'Divest';
        insert account;

        workflow = new Workflow_details__c();
        workflow.Wokflow_Name__c='WF_Test_rec';
        workflow.Approval_Level_in_Progress__c='Draft';
        workflow.Atlas_or_P_DR__c='Test';
        workflow.Proposal_Title__c='TM_rec';
        workflow.Contract_Manager__c='TM_Mngr';
        workflow.Pricing_Proposal_Type__c='TINA';
        workflow.Sales_K__c=1;
        workflow.X5_Year_Revenue_K__c=1;
        workflow.Terms_and_Conditions__c='Standard';
        workflow.Front_End_Loss__c=1;
        workflow.Exposed_Cost__c=1;
        workflow.Front_End_Loss_Max_Year__c=1;
        workflow.Exposed_Cost_Max_Year_K__c=1;
        workflow.Contract_Type__c='Cost Sharing';
        workflow.Platform__c=platform.id;
        workflow.Customer_Name__c=account.id;
        workflow.Status__c='Draft';
        workflow.Approval_Level_Required__c='Aero Tier 0';
        workflow.Approval_Level_in_Progress__c='Aero Tier 0';
        workflow.Americas__c=True;
        workflow.Sales_Channel__c = 'Americas AM';

        workflow.BG_A__c = true;

        insert workflow;

        profile = [select name from Profile where name = 'D&S Sales eGreensheet Approver (Non-US)'];

        user = new User(LastName = 'Test User',Username = 'testuser@test3.com.honeywell',Email = 'testuser@test.com',Alias = 't3user' ,CommunityNickname= 't3user' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = profile.Id, LanguageLocaleKey = 'en_US',Functional_Role__c='testrole');
        insert user;

        appFinance = SetApproverObject();
        appMPM = SetApproverObject();
        appProduct = SetApproverObject();
        appBusiness = SetApproverObject();
        appContract = SetApproverObject();
        appNotification = SetApproverObject();
        appAdditional = SetApproverObject();

        appFinance.Approver_type__c='Finance Approver';
        appMPM.Approver_type__c = 'M&PM';
        appProduct.Approver_type__c = 'Product Approver';
        appBusiness.Approver_type__c = 'Business Approver';
        appContract.Approver_type__c = 'Contract Approver';
        appNotification.Approver_type__c = 'Notification';
        appAdditional.Approver_type__c = 'Additional Approver';

        insert appFinance;
        insert appMPM;
        insert appProduct;
        insert appBusiness;
        insert appContract;
        insert appNotification;
        insert appAdditional;

        ApexPages.StandardController controller= new ApexPages.StandardController(workflow);
        System.currentPagereference().getParameters().put('id',workflow.id);
        workflowApproval = new eGreen_sheet_Approval(controller);
    }

    static Approver__c SetApproverObject()
    {
        Approver__c app = new Approver__c();
        app.name='Test_App_rec';
        app.Approver_Name__c=user.id;
        app.Business_Unit__c='BGA';
        app.Region__c='Americas';
        app.Tier__c='Aero Tier 0';
        app.Out_of_Office__c = true;
        app.Active__c = true;
        app.Sales_Channel__c = 'Americas AM';

        return app;
    }

    @IsTest
    static void AddWorkflowHistory()
    {
        init();

        WorkFlow_Approval_History__c workflowHistory= new WorkFlow_Approval_History__c();
        workflowHistory.Workflow_details__c=workflow.id;
        workflowHistory.Select_Approver__c=appFinance.id;
        workflowHistory.Tier__c=workflow.approval_level_in_progress__c;
        insert workflowHistory;
    }

    @IsTest
    static void sendMail()
    {
        init();

        workflowApproval.setoptions1(appBusiness.id);

        workflowApproval.sendMail();
    }

    @IsTest
    static void sendMail_NumOfAppBetween16And19()
    {
        GetSetOptions();

        workflowApproval.sendMail();
    }

    @IsTest
    static void savendraft()
    {
        GetSetOptions();

        workflowApproval.savendraft();
    }

    @IsTest
    static void Cancel()
    {
        init();
        workflowApproval.Cancel();
    }

    @IsTest
    static void GetSetOptions()
    {
        init();

        workflowApproval.getoptions1();
        workflowApproval.setoptions1(appBusiness.id);

        workflowApproval.getoptions2();
        workflowApproval.setoptions2(appBusiness.id);

        workflowApproval.getoptions3();
        workflowApproval.setoptions3(appBusiness.id);

        workflowApproval.getoptions4();
        workflowApproval.setoptions4(appBusiness.id);

        workflowApproval.getoptions1c();
        workflowApproval.setoptions1c(appContract.id);

        workflowApproval.getoptions2c();
        workflowApproval.setoptions2c(appContract.id);

        workflowApproval.getoptions3c();
        workflowApproval.setoptions3c(appContract.id);

        workflowApproval.getoptions4c();
        workflowApproval.setoptions4c(appContract.id);

        workflowApproval.getoptions1f();
        workflowApproval.setoptions1f(appFinance.id);

        workflowApproval.getoptions2f();
        workflowApproval.setoptions2f(appFinance.id);

        workflowApproval.getoptions3f();
        workflowApproval.setoptions3f(appFinance.id);

        workflowApproval.getoptions4f();
        workflowApproval.setoptions4f(appFinance.id);

        workflowApproval.getoptions1p();
        workflowApproval.setoptions1p(appProduct.id);

        workflowApproval.getoptions2p();
        workflowApproval.setoptions2p(appProduct.id);

        workflowApproval.getoptions3p();
        workflowApproval.setoptions3p(appProduct.id);

        workflowApproval.getoptions4p();
        workflowApproval.setoptions4p(appProduct.id);

        workflowApproval.getoptions1m();
        workflowApproval.setoptions1m(appMPM.id);

        workflowApproval.getoptions2m();
        workflowApproval.setoptions2m(appMPM.id);

        workflowApproval.getoptions3m();
        workflowApproval.setoptions3m(appMPM.id);

        workflowApproval.getoptions4m();
        workflowApproval.setoptions4m(appMPM.id);

        workflowApproval.getoptions1n();
        workflowApproval.setoptions1n(appNotification.id);

        workflowApproval.getoptions2n();
        workflowApproval.setoptions2n(appNotification.id);

        workflowApproval.getoptions3n();
        workflowApproval.setoptions3n(appNotification.id);

        workflowApproval.getoptions4n();
        workflowApproval.setoptions4n(appNotification.id);

        /*workflowApproval.getoptions1a();
        workflowApproval.setoptions1a(appAdditional.id);*/

        /*workflowApproval.getoptions2a();
        workflowApproval.setoptions2a(appAdditional.id);

        workflowApproval.getoptions3a();
        workflowApproval.setoptions3a(appAdditional.id);

        workflowApproval.getoptions4a();
        workflowApproval.setoptions4a(appAdditional.id);*/

        workflowApproval.getUserList1();
        workflowApproval.getUserList2();

        workflowApproval.getUserList1p();
        workflowApproval.getUserList2p();

        /*workflowApproval.getUserList1a();
        workflowApproval.getUserList2a();*/

        workflowApproval.getUserList1c();
        workflowApproval.getUserList2c();

        workflowApproval.getUserList1f();
        workflowApproval.getUserList2f();

        workflowApproval.getUserList1m();
        workflowApproval.getUserList2m();

        workflowApproval.getUserList1n();
        workflowApproval.getUserList2n();
    }
}