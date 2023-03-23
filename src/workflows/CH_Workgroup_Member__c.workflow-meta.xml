<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CH_UpdateWorkgroupMemberUserName</fullName>
        <field>CH_KB_User__c</field>
        <formula>CH_User__r.FirstName + &apos; &apos; + CH_User__r.LastName</formula>
        <name>CH_UpdateWorkgroupMemberUserName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CH_Update_WorkgroupMember_Hidden_Name</fullName>
        <field>CH_Hidden_Searchfield__c</field>
        <formula>CH_Name__c</formula>
        <name>CH Update WorkgroupMember Hidden Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CH WorkgroupMember</fullName>
        <actions>
            <name>CH_Update_WorkgroupMember_Hidden_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND ( OR(ISNEW(), ISCHANGED(CH_Name__c)),  RecordType.DeveloperName = &quot;CH_CA_WorkgroupMember&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CH_UpdateWorkgroupMemberUserName</fullName>
        <actions>
            <name>CH_UpdateWorkgroupMemberUserName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CH_Workgroup_Member__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>CH_KB_WorkgroupMember</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
