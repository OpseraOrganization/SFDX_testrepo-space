<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>footprint__Analysis_is_finished</fullName>
        <description>Analysis is finished</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>footprint__Footprint/footprint__FP_AnalysisDone</template>
    </alerts>
    <rules>
        <fullName>footprint__FP_MakeFieldUneditable</fullName>
        <actions>
            <name>footprint__FP_UpdateEditableField</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>footprint__FootPrint__c.footprint__isEditable__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
