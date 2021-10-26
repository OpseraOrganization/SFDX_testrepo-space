<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CH_CA_CLI_Hidden_Name</fullName>
        <field>CH_Hidden_Searchfield__c</field>
        <formula>LEFT(ServiceContract.Name +&apos; &apos;+ CH_Account__c  +&apos; &apos; +Asset.Name, 250)</formula>
        <name>CH CA CLI Hidden Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CH_Update_Line_Item_Script_Flag</fullName>
        <field>CH_LineItemScript_flag__c</field>
        <formula>LEN(CH_LineItemEntitlementScript__c)</formula>
        <name>CH_Update Line Item Script Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HWS_Field_update</fullName>
        <field>CH_ServiceType__c</field>
        <literalValue>Identical Repair</literalValue>
        <name>HWS Field update MVR IR to IR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HWS_Field_update_MVR_RFR_to_RFR</fullName>
        <field>CH_ServiceType__c</field>
        <literalValue>Return for Repair or Replacement</literalValue>
        <name>HWS Field update MVR RFR to RFR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HWS_Service_Type_code_MVR_IR_to_IR</fullName>
        <field>CH_ServiceTypeCode__c</field>
        <formula>&quot;0000053748&quot;</formula>
        <name>HWS Service Type code MVR IR to IR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HWS_Update_Service_Item_Description</fullName>
        <field>CH_ServiceItemDescription__c</field>
        <formula>&quot;Commissioning Spares&quot;</formula>
        <name>HWS Update Service Item Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HWS_Update_Service_Type_MVR_RFR_to_RFR</fullName>
        <field>CH_ServiceTypeCode__c</field>
        <formula>&quot;0000052442&quot;</formula>
        <name>HWS Update Service Type MVR RFR to RFR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HWS_Update_service_mapping_id_to_RFR</fullName>
        <field>CH_ServiceMappingId__c</field>
        <literalValue>Return for Repair or Replacement</literalValue>
        <name>HWS Update service mapping id to RFR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HWS_update_service_item_code</fullName>
        <field>CH_ServiceItemCode__c</field>
        <formula>&quot;P501391&quot;</formula>
        <name>HWS update service item code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HWS_update_service_mapping</fullName>
        <field>CH_ServiceMappingId__c</field>
        <literalValue>Return for Repair or Replacement</literalValue>
        <name>HWS update service mapping</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HWS_update_service_mapping_to_IR</fullName>
        <field>CH_ServiceMappingId__c</field>
        <literalValue>Identical Repair</literalValue>
        <name>HWS update service mapping to IR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HWS_update_service_type_code</fullName>
        <field>CH_ServiceTypeCode__c</field>
        <formula>&quot;0000052442&quot;</formula>
        <name>HWS update service type code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Hws_service_type</fullName>
        <field>CH_ServiceType__c</field>
        <literalValue>Return for Repair or Replacement</literalValue>
        <name>Hws service type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CH_CA_CLI</fullName>
        <actions>
            <name>CH_CA_CLI_Hidden_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( ISNEW(), OR( ISCHANGED(  CH_Hidden_Searchfield__c   ), ISCHANGED(  AssetId ) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CH_Check Line Item Script</fullName>
        <actions>
            <name>CH_Update_Line_Item_Script_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>HWS Update Service Item Description</fullName>
        <actions>
            <name>HWS_Update_Service_Item_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ContractLineItem.CH_ServiceClassification__c</field>
            <operation>equals</operation>
            <value>HWS Service</value>
        </criteriaItems>
        <criteriaItems>
            <field>ContractLineItem.CH_ServiceType__c</field>
            <operation>equals</operation>
            <value>Identical Repair</value>
        </criteriaItems>
        <criteriaItems>
            <field>ContractLineItem.CH_ServiceOffering__c</field>
            <operation>equals</operation>
            <value>Commissioning Spares</value>
        </criteriaItems>
        <description>To update service item Description based on Service Type</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>HWS Update Service Type</fullName>
        <actions>
            <name>HWS_update_service_item_code</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>HWS_update_service_mapping</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>HWS_update_service_type_code</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Hws_service_type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ContractLineItem.CH_ServiceClassification__c</field>
            <operation>equals</operation>
            <value>HWS Service</value>
        </criteriaItems>
        <criteriaItems>
            <field>ContractLineItem.CH_ServiceType__c</field>
            <operation>equals</operation>
            <value>Return for Exchange</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>HWS Update Service Type MVR IR to IR</fullName>
        <actions>
            <name>HWS_Field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>HWS_Service_Type_code_MVR_IR_to_IR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ContractLineItem.CH_ServiceClassification__c</field>
            <operation>equals</operation>
            <value>HWS Service</value>
        </criteriaItems>
        <criteriaItems>
            <field>ContractLineItem.CH_ServiceType__c</field>
            <operation>equals</operation>
            <value>MVR Identical Repair</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>HWS Update Service Type MVR RFR to RFR</fullName>
        <actions>
            <name>HWS_Field_update_MVR_RFR_to_RFR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>HWS_Update_Service_Type_MVR_RFR_to_RFR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ContractLineItem.CH_ServiceClassification__c</field>
            <operation>equals</operation>
            <value>HWS Service</value>
        </criteriaItems>
        <criteriaItems>
            <field>ContractLineItem.CH_ServiceType__c</field>
            <operation>equals</operation>
            <value>MVR Return for Repair or Replacement</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
