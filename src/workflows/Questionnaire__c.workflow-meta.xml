<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Date_Completed_on_Questionaire</fullName>
        <description>15th Feb: As per recent discussion &apos;Date Completed&apos; will be updated on Questionnaire creation</description>
        <field>Date_Completed__c</field>
        <formula>today()</formula>
        <name>Update Date Completed on Questionaire</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Probability</fullName>
        <description>This field update will update the calculated probabilty value on opportunity</description>
        <field>Probability</field>
        <formula>Win_Probability__c</formula>
        <name>Update Probability</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>Opportunity__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Update Date Completed on Questionaire</fullName>
        <actions>
            <name>Update_Date_Completed_on_Questionaire</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>15th Feb: As per our recent discussion this field will be updated on creation</description>
        <formula>$Profile.Name&lt;&gt; $Label.Data_Loader_Profile_Name</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Updating Win Probability</fullName>
        <actions>
            <name>Update_Probability</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Updating Win Probability on Opportunity only when Account Number is not null.</description>
        <formula>AND( NOT( ISBLANK(Opportunity__r.Opportunity_ID__c )), NOT(ISBLANK(Opportunity__r.Account.AccountNumber)), !ISPICKVAL(Opportunity__r.StageName, &apos;Execute (Start Delivery)&apos;), !ISPICKVAL(Opportunity__r.StageName, &apos;Completed&apos;), $Profile.Name &lt;&gt; $Label.Data_Loader_Profile_Name)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
