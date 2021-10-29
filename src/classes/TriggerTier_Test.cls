/**
 * Created by Meiying Liang on 1/18/2020.
 */

@IsTest
private class TriggerTier_Test {
    private static Workflow_details__c workflowDetails;
    private static Tier_Level__c tierLevel;

    static void init() {
        workflowDetails = new TestEgreensheetBuilder()
                .setApprovalLevelinProgress('Tier I')
                .addField('Exposed_Cost__c',100)
                .addField('Exposed_Cost_Max_Year_K__c',200)
                .addField('Front_End_Loss__c',100)
                .addField('Front_End_Loss_Max_Year__c',200)
                .addField('X5_Year_Revenue_K__c',100)
                .build();

        tierLevel = new Tier_Level__c();
        tierLevel.Exposed_Cost__c = 150;
        tierLevel.Front_End_Loss_Max_Year__c = 300;
        tierLevel.Front_End_Loss__c = 150;
        tierLevel.Exposed_Cost_Max_Year_K__c = 300;
        tierLevel.X5_Year_Revenue__c = 150;
    }
    @IsTest
    static void BI_Airbus_Test() {
        init();

        tierLevel.SBU__c = 'Airbus';
        tierLevel.Tier__c = 'Airbus Tier II-1';

        insert tierLevel;

        workflowDetails.Airbus__c = true;
        workflowDetails.Terms_and_Conditions__c = 'Standard';
        insert workflowDetails;

        List<Workflow_details__c> result = [Select Suggested_Tier__c From Workflow_details__c];

        system.assertEquals(result[0].Suggested_Tier__c,'Airbus Tier II-1');
    }

    @IsTest
    static void BI_Airlines_Test() {
        init();

        tierLevel.SBU__c = 'Airlines';
        tierLevel.Tier__c = 'Airlines Tier III-5';

        insert tierLevel;

        workflowDetails.Airlines__c = true;
        workflowDetails.Terms_and_Conditions__c = 'Non-Standard';
        insert workflowDetails;

        List<Workflow_details__c> result = [Select Suggested_Tier__c From Workflow_details__c];

        system.assertEquals(result[0].Suggested_Tier__c,'Airlines Tier III-5');
    }

    @IsTest
    static void BI_ATR_Test() {
        init();

        tierLevel.SBU__c = 'ATR';
        tierLevel.Tier__c = 'Airbus Tier III-2';

        insert tierLevel;

        workflowDetails.ATR__c = true;
        workflowDetails.Terms_and_Conditions__c = 'Standard';
        insert workflowDetails;

        List<Workflow_details__c> result = [Select Suggested_Tier__c From Workflow_details__c];
        system.assertEquals(result[0].Suggested_Tier__c,'Airbus Tier III-2');
    }

    @IsTest
    static void BI_BGA_Test() {
        init();

        tierLevel.SBU__c = 'BGA';
        tierLevel.Tier__c = 'BGA Tier III-5';

        insert tierLevel;

        workflowDetails.BG_A__c = true;
        workflowDetails.Terms_and_Conditions__c = 'Standard';
        insert workflowDetails;

        List<Workflow_details__c> result = [Select Suggested_Tier__c From Workflow_details__c];

        system.assertEquals(result[0].Suggested_Tier__c,'BGA Tier III-5');
    }

    @IsTest
    static void BI_Boeing_Test() {
        init();

        tierLevel.SBU__c = 'Boeing';
        tierLevel.Tier__c = 'Boeing Tier II-1';

        insert tierLevel;

        workflowDetails.Boeing__c = true;
        workflowDetails.Terms_and_Conditions__c = 'Standard';
        insert workflowDetails;

        List<Workflow_details__c> result = [Select Suggested_Tier__c From Workflow_details__c];

        system.assertEquals(result[0].Suggested_Tier__c,'Boeing Tier II-1');
    }

    @IsTest
    static void BI_Components_Test() {
        init();

        tierLevel.SBU__c = 'Components';
        tierLevel.Tier__c = 'Components Tier III-5';

        insert tierLevel;

        workflowDetails.RACC__c = true;
        workflowDetails.Terms_and_Conditions__c = 'Standard';
        insert workflowDetails;

        List<Workflow_details__c> result = [Select Suggested_Tier__c From Workflow_details__c];

        system.assertEquals(result[0].Suggested_Tier__c,'Components Tier III-5');
    }

    @IsTest
    static void BI_D_And_S_Test() {
        init();

        tierLevel.SBU__c = 'D&S';
        tierLevel.Tier__c = 'D&S Tier III-2';

        insert tierLevel;

        workflowDetails.Defence_Space__c = true;
        workflowDetails.Terms_and_Conditions__c = 'Standard';
        insert workflowDetails;

       List<Workflow_details__c> result = [Select Suggested_Tier__c From Workflow_details__c];

        system.assertEquals(result[0].Suggested_Tier__c,'D&S Tier III-2');
    }

    @IsTest
    static void BI_HIS_Test() {
        init();

        tierLevel.SBU__c = 'HIS';
        tierLevel.Tier__c = 'HIS Tier I-1';

        insert tierLevel;

        workflowDetails.HIS__c = true;
        workflowDetails.Terms_and_Conditions__c = 'Standard';
        insert workflowDetails;

        List<Workflow_details__c> result = [Select Suggested_Tier__c From Workflow_details__c];

        system.assertEquals(result[0].Suggested_Tier__c,'HIS Tier I-1');
    }

    @IsTest
    static void BI_HTSI_Test() {
        init();

        tierLevel.SBU__c = 'HTSI';
        tierLevel.Tier__c = 'HTSI Tier I-3';

        insert tierLevel;

        workflowDetails.HTSI__c = true;
        workflowDetails.Terms_and_Conditions__c = 'Standard';
        insert workflowDetails;

        List<Workflow_details__c> result = [Select Suggested_Tier__c From Workflow_details__c];

        system.assertEquals(result[0].Suggested_Tier__c,'HTSI Tier I-3');
    }
}