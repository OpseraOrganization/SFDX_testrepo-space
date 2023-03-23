<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CH_NEA_Unique_Key_Update_Rule</fullName>
        <description>NOKIASC-36189</description>
        <field>CH_NetworkElementAssetUniqueKey__c</field>
        <formula>Account.AccountNumber+&apos;|&apos;+
CH_NetworkManagementSystemID__c+&apos;|&apos;+CH_NetworkElementID__c+&apos;|&apos;+
Product2.ProductCode</formula>
        <name>CH_NEA_Unique_Key_Update_Rule</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CH_NEA_Unique_Key_Update_Rule</fullName>
        <actions>
            <name>CH_NEA_Unique_Key_Update_Rule</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>NOKIASC-36189</description>
        <formula>AND($RecordType.Name = &quot;Network Element Asset&quot;, OR( (OR( NOT(ISBLANK(  AccountId  )), ISCHANGED( AccountId ))), (OR( NOT(ISBLANK( CH_NetworkManagementSystemID__c   )),ISCHANGED( CH_NetworkManagementSystemID__c ))) , (OR( NOT(ISBLANK(  CH_NetworkElementID__c   )),ISCHANGED( CH_NetworkElementID__c ))),    (OR( NOT(ISBLANK(  Product2Id  )), ISCHANGED(  Product2Id  )))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
