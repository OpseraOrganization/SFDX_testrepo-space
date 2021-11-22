<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Customer_Offer_Due_Date_2</fullName>
        <field>Customer_Offer_Due_Date__c</field>
        <formula>Opportunity__r.G4_Planned_Date__c  + 2</formula>
        <name>Customer Offer Due Date + 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Update Customer Offer Due Date1</fullName>
        <actions>
            <name>Customer_Offer_Due_Date_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Profile.Name&lt;&gt; $Label.Data_Loader_Profile_Name, OR(  ISPICKVAL( Opportunity__r.StageName, &apos;Identify Opportunity&apos;),  ISPICKVAL( Opportunity__r.StageName, &apos;Develop Opportunity&apos;),  ISPICKVAL( Opportunity__r.StageName, &apos;Create Offer (Bid)&apos;),  ISPICKVAL( Opportunity__r.StageName, &apos;Win the Case (Negotiate)&apos;)) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
