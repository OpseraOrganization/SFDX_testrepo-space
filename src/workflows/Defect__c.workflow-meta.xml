<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_alert_on_Defect_Creation</fullName>
        <description>Email alert on Defect Creation</description>
        <protected>false</protected>
        <recipients>
            <field>Developer_Assigned__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PMO/Defect_Creation_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Defect_Lifecycle_Update_3</fullName>
        <field>Defect_Lifecycle__c</field>
        <literalValue>Test in Progress</literalValue>
        <name>Defect Lifecycle Update 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Defect_Lifecycle_Update_4</fullName>
        <field>Defect_Lifecycle__c</field>
        <literalValue>Fixed - Ready for retest</literalValue>
        <name>Defect Lifecycle Update 4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Defect_Lifecycle_Update_5</fullName>
        <field>Defect_Lifecycle__c</field>
        <literalValue>Monitor</literalValue>
        <name>Defect Lifecycle Update 5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Defect_Lifecycle_Update_6</fullName>
        <field>Defect_Lifecycle__c</field>
        <literalValue>Closed</literalValue>
        <name>Defect Lifecycle Update 6</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Defect_Lifecycle_update</fullName>
        <field>Defect_Lifecycle__c</field>
        <literalValue>New</literalValue>
        <name>Defect_Lifecycle update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Defect_Lifecycle_update_2</fullName>
        <field>Defect_Lifecycle__c</field>
        <literalValue>Open - Action Required</literalValue>
        <name>Defect_Lifecycle update 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_Defect_Raised</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Defect_Management</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>New Defect Raised</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Defect Path is updated based on Status change</fullName>
        <actions>
            <name>Defect_Lifecycle_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Defect__c.Status__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>Defect Path is updated based on Status change</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Defect Path is updated based on Status change 2</fullName>
        <actions>
            <name>Defect_Lifecycle_update_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Defect__c.Status__c</field>
            <operation>equals</operation>
            <value>Stakeholder Review,Assigned,Failed Retest,Re-opened</value>
        </criteriaItems>
        <description>Defect Path is updated based on Status change</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Defect Path is updated based on Status change 3</fullName>
        <actions>
            <name>Defect_Lifecycle_Update_3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Defect__c.Status__c</field>
            <operation>equals</operation>
            <value>Fixed,Validated SIT</value>
        </criteriaItems>
        <description>Defect Path is updated based on Status change</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Defect Path is updated based on Status change 4</fullName>
        <actions>
            <name>Defect_Lifecycle_Update_4</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Defect__c.Status__c</field>
            <operation>equals</operation>
            <value>Validate UAT,Validate PROD</value>
        </criteriaItems>
        <description>Defect Path is updated based on Status change</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Defect Path is updated based on Status change 5</fullName>
        <actions>
            <name>Defect_Lifecycle_Update_5</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Defect__c.Status__c</field>
            <operation>equals</operation>
            <value>Monitor</value>
        </criteriaItems>
        <description>Defect Path is updated based on Status change</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Defect Path is updated based on Status change 6</fullName>
        <actions>
            <name>Defect_Lifecycle_Update_6</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Defect__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed,Rejected,Duplicate,Withdrawn,Deferred</value>
        </criteriaItems>
        <description>Defect Path is updated based on Status change</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Recordtype Changes</fullName>
        <actions>
            <name>New_Defect_Raised</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Id &lt;&gt; null</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send email for defect creation</fullName>
        <actions>
            <name>Email_alert_on_Defect_Creation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Defect__c.Status__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Defect__c.Developer_Assigned__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
