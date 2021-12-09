<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Update Claim to Expired</fullName>
        <active>true</active>
        <formula>NOT(OR(ISPICKVAL(Claim_Status__c, &apos;Rejected&apos;),  ISPICKVAL(Claim_Status__c, &apos;Expired&apos;),  ISPICKVAL(Claim_Status__c, &apos;Incomplete&apos;), ISPICKVAL(Claim_Status__c, &apos;Escalated&apos;), ISPICKVAL(Claim_Status__c, &apos;Submitted&apos;),  ISPICKVAL(Claim_Status__c, &apos;Passed Audit&apos;), ISPICKVAL(Claim_Status__c, &apos;Awaiting Reimbursement&apos;), ISPICKVAL(Claim_Status__c, &apos;Reimbursed&apos;)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Notification_to_Partner_user_when_claim_is_expired</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Update_Claim_to_expired</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Claim__c.Claim_Due_By__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
