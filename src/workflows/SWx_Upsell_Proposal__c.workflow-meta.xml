<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>DS_Email_Notification_to_AM_on_SWMP_Failure</fullName>
        <description>DS Email Notification to AM on SWMP Failure</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/DS_SWMPInterfaceLogErrorNotification</template>
    </alerts>
    <alerts>
        <fullName>DS_Nokia_ScratchOrderDPStatusEntitled</fullName>
        <description>DS_Nokia_ScratchOrderDPStatusEntitled</description>
        <protected>false</protected>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/DS_Nokia_ScratchOrderReadyForDelivery</template>
    </alerts>
    <fieldUpdates>
        <fullName>Assign_SWX_read_only</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SWx_Upsell_Proposal_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Assign SWX read only</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CCRE_RecordType_Assignment</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CCRE_Upsell_Proposal</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>CCRE RecordType Assignment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_DP_Record_type_when_Rejected</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Proposal_Read_only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change DP Record type when Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Upsell_Stage_to_Replace_when_Prop</fullName>
        <field>Upsell_Status__c</field>
        <literalValue>Replaced</literalValue>
        <name>Change Upsell Stage to Replace</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_record_type_to_SWx_Proposal_Read</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SWx_Upsell_Proposal_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change record type to SWx Proposal Read</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SWX_Record_Type_Assignment</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SWx_Upsell_Proposal</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SWX Record Type Assignment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CXM_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SWx_Upsell_Proposal_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update CXM Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Portal_Display_Timestamp_Field</fullName>
        <description>Set Field &quot;Portal Display Timestamp&quot; to current date and time.</description>
        <field>DS_Portal_Display_Timestamp__c</field>
        <formula>NOW()</formula>
        <name>Update Portal Display Timestamp Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Show_In_Portal_Field</fullName>
        <description>Set &quot;Show In Portal&quot; to True</description>
        <field>DS_Show_In_Portal__c</field>
        <literalValue>1</literalValue>
        <name>Update Show In Portal Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_proposal_record_type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Proposal_Read_only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update proposal record type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CCRE Digital Proposal</fullName>
        <actions>
            <name>CCRE_RecordType_Assignment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( OR(ISPICKVAL(PRIORVALUE( Upsell_Status__c),&quot;Convert&quot;),ISPICKVAL(PRIORVALUE( Upsell_Status__c),&quot;Cancel&quot;),ISPICKVAL(PRIORVALUE( Upsell_Status__c),&quot;Reject&quot;)), ISPICKVAL(( Upsell_Status__c),&quot;Draft&quot;), ISPICKVAL((Analytics_Source__c),&quot;CCRE&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Upsell Stage to Replaced</fullName>
        <actions>
            <name>Change_Upsell_Stage_to_Replace_when_Prop</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SWx_Upsell_Proposal__c.Proposal_Status__c</field>
            <operation>equals</operation>
            <value>Replaced</value>
        </criteriaItems>
        <description>Change Upsell Stage to Replace when Proposal Status changes to Replaced</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DS CCRE Record Type Assignment on Reject</fullName>
        <actions>
            <name>Change_DP_Record_type_when_Rejected</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SWx_Upsell_Proposal__c.Upsell_Status__c</field>
            <operation>equals</operation>
            <value>Reject</value>
        </criteriaItems>
        <criteriaItems>
            <field>SWx_Upsell_Proposal__c.Proposal_Status__c</field>
            <operation>equals</operation>
            <value>Close-Reject</value>
        </criteriaItems>
        <criteriaItems>
            <field>SWx_Upsell_Proposal__c.Analytics_Source__c</field>
            <operation>equals</operation>
            <value>CCRE</value>
        </criteriaItems>
        <description>DSI - 085 - When the customer &quot;Rejects&quot; via the portal reject button that digital proposal goes instantly in Upsell Stage &quot;Rejected&quot;, so no action anyhow to do anymore from an Account Manager point of view.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DS SWX Record Type Assignment on Reject</fullName>
        <actions>
            <name>Update_CXM_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SWx_Upsell_Proposal__c.Upsell_Status__c</field>
            <operation>equals</operation>
            <value>Reject</value>
        </criteriaItems>
        <criteriaItems>
            <field>SWx_Upsell_Proposal__c.Proposal_Status__c</field>
            <operation>equals</operation>
            <value>Close-Reject</value>
        </criteriaItems>
        <criteriaItems>
            <field>SWx_Upsell_Proposal__c.Analytics_Source__c</field>
            <operation>equals</operation>
            <value>CXM</value>
        </criteriaItems>
        <description>DSI - 085 - When the customer &quot;Rejects&quot; via the portal reject button that digital proposal goes instantly in Upsell Stage &quot;Rejected&quot;, so no action anyhow to do anymore from an Account Manager point of view.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DS Show Digital Proposal to Customer</fullName>
        <actions>
            <name>Update_Portal_Display_Timestamp_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Show_In_Portal_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SWx_Upsell_Proposal__c.Upsell_Status__c</field>
            <operation>equals</operation>
            <value>Ready For Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>SWx_Upsell_Proposal__c.DS_Show_In_Portal__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>This is used to update field on Digital Proposal that clarifies whether to show DP to customer or not.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Proposal Read only</fullName>
        <actions>
            <name>Update_proposal_record_type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 2 OR 3) AND 4</booleanFilter>
        <criteriaItems>
            <field>SWx_Upsell_Proposal__c.Upsell_Status__c</field>
            <operation>equals</operation>
            <value>Reject</value>
        </criteriaItems>
        <criteriaItems>
            <field>SWx_Upsell_Proposal__c.Upsell_Status__c</field>
            <operation>equals</operation>
            <value>Cancel</value>
        </criteriaItems>
        <criteriaItems>
            <field>SWx_Upsell_Proposal__c.Upsell_Status__c</field>
            <operation>equals</operation>
            <value>Convert</value>
        </criteriaItems>
        <criteriaItems>
            <field>SWx_Upsell_Proposal__c.Analytics_Source__c</field>
            <operation>equals</operation>
            <value>CCRE</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SWX Digital Proposal</fullName>
        <actions>
            <name>SWX_Record_Type_Assignment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  OR(ISPICKVAL(PRIORVALUE( Upsell_Status__c),&quot;Convert&quot;),ISPICKVAL(PRIORVALUE( Upsell_Status__c),&quot;Cancel&quot;),ISPICKVAL(PRIORVALUE( Upsell_Status__c),&quot;Reject&quot;)),  ISPICKVAL(( Upsell_Status__c),&quot;Draft&quot;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SWX Proposal Read only</fullName>
        <actions>
            <name>Assign_SWX_read_only</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 2 OR 3) AND 4</booleanFilter>
        <criteriaItems>
            <field>SWx_Upsell_Proposal__c.Upsell_Status__c</field>
            <operation>equals</operation>
            <value>Reject</value>
        </criteriaItems>
        <criteriaItems>
            <field>SWx_Upsell_Proposal__c.Upsell_Status__c</field>
            <operation>equals</operation>
            <value>Cancel</value>
        </criteriaItems>
        <criteriaItems>
            <field>SWx_Upsell_Proposal__c.Upsell_Status__c</field>
            <operation>equals</operation>
            <value>Convert</value>
        </criteriaItems>
        <criteriaItems>
            <field>SWx_Upsell_Proposal__c.Analytics_Source__c</field>
            <operation>equals</operation>
            <value>CXM</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
