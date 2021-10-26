<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Build_Completion_Date_if_Release</fullName>
        <description>Build Completion Update if Release:Test</description>
        <field>Build_Completion_Date__c</field>
        <formula>Today()</formula>
        <name>Build Completion Date if Release:</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CCB_Approval_Date</fullName>
        <field>CCB_Approval_Date__c</field>
        <formula>now()</formula>
        <name>Set CCB Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Close_Deferred_Date</fullName>
        <field>Closed_Deferred_Date__c</field>
        <formula>now()</formula>
        <name>Set Close/Deferred Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Customization_Approval_Date</fullName>
        <field>Customization_Approval_Date__c</field>
        <formula>now()</formula>
        <name>Set Customization Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Lifecycle_update</fullName>
        <description>Status_Lifecycle says to Identify Requirement</description>
        <field>Status_Lifecycle__c</field>
        <literalValue>Identify Requirement</literalValue>
        <name>Status_Lifecycle update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Lifecycle_update3</fullName>
        <field>Status_Lifecycle__c</field>
        <literalValue>Design, Build</literalValue>
        <name>Status_Lifecycle update3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Lifecycle_update_2</fullName>
        <field>Status_Lifecycle__c</field>
        <literalValue>Consolidate Estimation and Approval</literalValue>
        <name>Status_Lifecycle update_2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Lifecycle_update_4</fullName>
        <field>Status_Lifecycle__c</field>
        <literalValue>Test</literalValue>
        <name>Status_Lifecycle update_4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Lifecycle_update_5</fullName>
        <field>Status_Lifecycle__c</field>
        <literalValue>Closed</literalValue>
        <name>Status_Lifecycle update_5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Actual Build Completion Date update if Release%3ATest</fullName>
        <actions>
            <name>Build_Completion_Date_if_Release</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Release: Test</value>
        </criteriaItems>
        <description>Actual Build Completion Update if Release:Test</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Customization Approved %3D TRUE</fullName>
        <actions>
            <name>Set_Customization_Approval_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Request__c.Customization_Approved__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Req%2E Path is updated based on Status change</fullName>
        <actions>
            <name>Status_Lifecycle_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Identify: New Requirement,Identify: Submit for Business Review,Identify: Deferred</value>
        </criteriaItems>
        <description>Path on Requirement is updated based on the Status change of the Requirement</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Req%2E Path is updated based on Status change_2</fullName>
        <actions>
            <name>Status_Lifecycle_update_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Consolidate: Approve to Estimate,Consolidate: Level of Effort Complete,Consolidate: Submit for CCB Review,Approve: Approved to Deploy</value>
        </criteriaItems>
        <description>Req. Path is updated based on Status change of the Requirement</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Req%2E Path is updated based on Status change_3</fullName>
        <actions>
            <name>Status_Lifecycle_update3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Release: Design,Release: Build</value>
        </criteriaItems>
        <description>Path on Requirement is updated based on the Status change of the Requirement</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Req%2E Path is updated based on Status change_4</fullName>
        <actions>
            <name>Status_Lifecycle_update_4</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Release: Test,Release: SIT,Release: UAT,Release: Build Production,Release: Test Production</value>
        </criteriaItems>
        <description>Path on Requirement is updated based on the Status change of the Requirement</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Req%2E Path is updated based on Status change_5</fullName>
        <actions>
            <name>Status_Lifecycle_update_5</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Close: Deployed,Close: Rejected,Close: Duplicate</value>
        </criteriaItems>
        <description>Path on Requirement is updated based on the Status change of the Requirement</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Requirement CCB Approved</fullName>
        <actions>
            <name>Set_CCB_Approval_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Request__c.Approved_by_CCB__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Requirement Closed%2FDeferred</fullName>
        <actions>
            <name>Set_Close_Deferred_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Identify: Deferred,Close: Deployed,Close: Rejected,Close: Duplicate</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
