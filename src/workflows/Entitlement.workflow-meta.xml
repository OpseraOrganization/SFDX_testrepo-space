<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>HWS_Field_update_MVR_RFR_to_RFR</fullName>
        <field>CH_ServiceMappingId__c</field>
        <literalValue>Return for Repair or Replacement</literalValue>
        <name>HWS Field update MVR RFR to RFR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HWS_Update_service_mapping_id_to_MVR_IR</fullName>
        <field>CH_ServiceMappingId__c</field>
        <literalValue>Identical Repair</literalValue>
        <name>HWS Update service mapping id to MVR IR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HWS_update_service_mappingId_RFE_to_RFR</fullName>
        <field>CH_ServiceMappingId__c</field>
        <literalValue>Return for Repair or Replacement</literalValue>
        <name>HWS update service mappingId RFE to RFR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Update service mapping Id for MVR IR</fullName>
        <actions>
            <name>HWS_Update_service_mapping_id_to_MVR_IR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Entitlement.CH_ServiceMappingId__c</field>
            <operation>equals</operation>
            <value>MVR Identical Repair</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update service mapping Id for MVR RFR</fullName>
        <actions>
            <name>HWS_Field_update_MVR_RFR_to_RFR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Entitlement.CH_ServiceMappingId__c</field>
            <operation>equals</operation>
            <value>MVR Return for Repair or Replacement</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update service mapping Id for RFE</fullName>
        <actions>
            <name>HWS_update_service_mappingId_RFE_to_RFR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Entitlement.CH_ServiceMappingId__c</field>
            <operation>equals</operation>
            <value>Return for Exchange</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
