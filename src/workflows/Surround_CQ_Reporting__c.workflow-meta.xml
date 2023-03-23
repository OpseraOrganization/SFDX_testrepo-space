<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CQRep_EmailAlert_to_CQ_Lead_if_CQDueDate_is_equal_to_today_and_stage_is_in_draft</fullName>
        <description>CQRep EmailAlert to CQ Lead if CQDueDate is equal to today and stage is in draft</description>
        <protected>false</protected>
        <recipients>
            <field>CQ_Lead__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>sCPQ_CQ_Email_templates/CQ_Rep_DueDate_is_Today</template>
    </alerts>
    <alerts>
        <fullName>CQRep_Email_Alert_to_CQ_Lead_if_CQ_Due_Date_is_Approaching_and_stage_is_in_draft</fullName>
        <description>CQRep Email Alert to CQ Lead if CQ Due Date is Approaching and stage is in draft</description>
        <protected>false</protected>
        <recipients>
            <field>CQ_Lead__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>sCPQ_CQ_Email_templates/CQ_Rep_DueDate_is_Approaching</template>
    </alerts>
    <alerts>
        <fullName>CQ_expired_email_alert</fullName>
        <description>CQ expired email alert</description>
        <protected>false</protected>
        <recipients>
            <field>CQ_Lead__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>sCPQ_CQ_Email_templates/CQ_Rep_Pricing_Expired</template>
    </alerts>
    <alerts>
        <fullName>CQ_expiring_soon</fullName>
        <description>CQ expiring soon</description>
        <protected>false</protected>
        <recipients>
            <field>CQ_Lead__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>sCPQ_CQ_Email_templates/CQ_Rep_Pricing_Expiring</template>
    </alerts>
    <rules>
        <fullName>CQ expired</fullName>
        <active>true</active>
        <formula>AND( Expiration_Date__c &gt;= Today(),  NOT(ISBLANK(Expiration_Date__c)), OR(ISPICKVAL( CQ_Status__c , &apos;Approved&apos;),  ISPICKVAL(CQ_Status__c, &apos;Accepted&apos;)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CQ_expired_email_alert</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Surround_CQ_Reporting__c.Expiration_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CQ expiring in in 5 days</fullName>
        <active>true</active>
        <formula>AND( Expiration_Date__c &gt;= Today(),  NOT(ISBLANK(Expiration_Date__c )), OR(ISPICKVAL( CQ_Status__c, &apos;Approved&apos;),  ISPICKVAL(CQ_Status__c, &apos;Accepted&apos;)),  IF((Expiration_Date__c - Today()) &gt;= 5, True, False) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CQ_expiring_soon</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Surround_CQ_Reporting__c.Expiration_Date__c</offsetFromField>
            <timeLength>-5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CQ_Rep_DueDate_is_Approaching</fullName>
        <active>true</active>
        <formula>AND(NOT(ISBLANK( CQ_Due_Date__c )), CQ_Due_Date__c -5 &gt;= TODAY(), ISPICKVAL(  CQ_Status__c ,&apos;Draft&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CQRep_Email_Alert_to_CQ_Lead_if_CQ_Due_Date_is_Approaching_and_stage_is_in_draft</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Surround_CQ_Reporting__c.CQ_Due_Date__c</offsetFromField>
            <timeLength>-5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CQ_Rep_DueDate_is_Today</fullName>
        <active>true</active>
        <formula>AND(NOT(ISBLANK( CQ_Due_Date__c )),CQ_Due_Date__c&gt;=TODAY() ,ISPICKVAL( CQ_Status__c ,&apos;Draft&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CQRep_EmailAlert_to_CQ_Lead_if_CQDueDate_is_equal_to_today_and_stage_is_in_draft</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Surround_CQ_Reporting__c.CQ_Due_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
