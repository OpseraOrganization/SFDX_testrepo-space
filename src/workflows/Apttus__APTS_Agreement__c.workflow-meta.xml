<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Apttus__SearchFieldUpdate</fullName>
        <description>Update the account search field with Account Name</description>
        <field>Apttus__Account_Search_Field__c</field>
        <formula>Apttus__Account__r.Name  &amp;  Apttus__FF_Agreement_Number__c</formula>
        <name>Search Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apttus__SetAgreementNumber</fullName>
        <description>Set agreement number from the auto generated contract number</description>
        <field>Apttus__Agreement_Number__c</field>
        <formula>Apttus__Contract_Number__c</formula>
        <name>Set Agreement Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apttus__SetClonetriggertofalse</fullName>
        <description>Set Clone trigger to false</description>
        <field>Apttus__Workflow_Trigger_Created_From_Clone__c</field>
        <literalValue>0</literalValue>
        <name>Set Clone trigger to false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Apttus__Reset Clone Trigger</fullName>
        <actions>
            <name>Apttus__SetClonetriggertofalse</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Workflow_Trigger_Created_From_Clone__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Reset Clone Trigger</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Apttus__Search Field Update</fullName>
        <actions>
            <name>Apttus__SearchFieldUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate an external Id search field with account name, so that side bar support can work with Account name search</description>
        <formula>or(not (isnull(Apttus__Account__r.Name)) ,not (isnull(Apttus__FF_Agreement_Number__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Apttus__Set Agreement Number</fullName>
        <actions>
            <name>Apttus__SetAgreementNumber</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Agreement_Number__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Set agreement number for new agreements. The agreement number is auto generated.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
