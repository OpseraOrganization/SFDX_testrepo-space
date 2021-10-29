public class eGreen_sheet_Approval_draft
{
    public eGreen_sheet_Approval_draft(ApexPages.StandardController controller) {}

    Workflow_details__c WFList = new Workflow_details__c();
    Workflow_details__c WFRec= new Workflow_details__c();
    Save_As_Draft__c savendrftrec = new Save_As_Draft__c();

    public id savenDrftId;
    {
        savenDrftId= System.currentPageReference().getParameters().get('id');
        system.debug('&&&&&&&&&&&&&&&'+savenDrftId);
        savendrftrec =[select Business_Approver1__c,Business_Approver2__c,Business_Approver3__c,Business_Approver4__c,Contract_Approvers1__c,Contract_Approvers2__c,Contract_Approvers3__c,Contract_Approvers4__c,Finance_Approver1__c,Finance_Approver2__c,Finance_Approver3__c,Finance_Approver4__c,Additional_Approver1__c,Additional_Approver2__c,Additional_Approver3__c,Additional_Approver4__c,Notification1__c,Notification2__c,Notification3__c,Notification4__c,Workflow_details__c,M_PM_Approver1__c,M_PM_Approver2__c,M_PM_Approver3__c,M_PM_Approver4__c,Workflow_details__r.id,Product_Approver1__c,Product_Approver2__c,Product_Approver3__c,Product_Approver4__c from Save_As_Draft__c where id=:savenDrftId];
        WFList=[select Airbus_c__c,Opportunity_Description__c,Approval_Level_in_Progress__c,ATR__c,Airlines__c,Ownerid,Business_Unit__c ,Sales_K__c,X5_Year_Revenue_K__c,Customer_Name__c,Front_End_Loss__c,Front_End_Loss_Max_Year__c,Exposed_Cost__c,Exposed_Cost_Max_Year_K__c,Terms_and_Conditions__c,Atlas_or_P_DR__c,Airbus__c,Status__c,BG_A__c,BG_A_OE__c,Boeing__c,Defence_Space__c,Defence_Space_OE__c,HIS__c,HTSI__c,HTSI_OE__c,RACC__c,Americas__c,APAC__c,EMEAI__c,Middle_East_APU_s_Only__c from Workflow_details__c where id=:savendrftrec.Workflow_details__r.id];
    }

    public Workflow_details__c getWFRec()
    {
        return WFList;
    }

    Public pagereference Cancel()
    {
        PageReference oppPage = new PageReference('/'+ savendrftrec.Workflow_details__r.id);
        oppPage.setRedirect(true);
        return oppPage;
    }

    Public pagereference edit()
    {
        PageReference editpage= new PageReference('/apex/SaveNdraft_Edit_VF?id='+savenDrftId);
        editpage.setRedirect(true);
        return editpage;
    }
}