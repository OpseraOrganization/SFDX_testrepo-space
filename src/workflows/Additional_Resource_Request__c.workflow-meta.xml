<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Access Level Change - Admin</fullName>
        <actions>
            <name>Access_Requested_Date_Request</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Clear_Completed_By_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Procurement_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Procurement_Status_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Removal_Requested_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Access_Requested_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 5 AND 2 AND NOT(3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Additional_Resource_Request__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Additional_Resource_Request__c.Access_Level__c</field>
            <operation>equals</operation>
            <value>Admin</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Integration API Only Profile</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Data Loader Profile</value>
        </criteriaItems>
        <criteriaItems>
            <field>Additional_Resource_Request__c.Partner_Type_Update__c</field>
            <operation>notEqual</operation>
            <value>No</value>
        </criteriaItems>
        <description>Clears the Procurement Completed Date, Completed By, and Procurement Status fields when the Access Level is updated</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Access Level Change - Relationship Manager</fullName>
        <actions>
            <name>Access_Requested_Date_Request</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Clear_Completed_By_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Procurement_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Procurement_Status_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Removal_Requested_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Access_Requested_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND NOT(3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Additional_Resource_Request__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Additional_Resource_Request__c.Access_Level__c</field>
            <operation>equals</operation>
            <value>Relationship Manager</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Integration API Only Profile</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Data Loader Profile</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Access Level Change - Training Manager</fullName>
        <actions>
            <name>Access_Requested_Date_Request</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Clear_Completed_By_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Procurement_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Procurement_Status_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Removal_Requested_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Access_Requested_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND NOT (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Additional_Resource_Request__c.Access_Level__c</field>
            <operation>equals</operation>
            <value>Training Manager</value>
        </criteriaItems>
        <criteriaItems>
            <field>Additional_Resource_Request__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Data Loader Profile</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Integration API Only Profile</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Access Level Change - Viewer</fullName>
        <actions>
            <name>Access_Requested_Date_Request</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Clear_Completed_By_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Procurement_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Procurement_Status_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Removal_Requested_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Access_Requested_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND NOT (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Additional_Resource_Request__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Additional_Resource_Request__c.Access_Level__c</field>
            <operation>equals</operation>
            <value>Viewer</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Data Loader Profile</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Integration API Only Profile</value>
        </criteriaItems>
        <description>Clears the Procurement Completed Date, Completed By, and Procurement Status fields when the Access Level is updated</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notification to user when coop eligible</fullName>
        <actions>
            <name>Send_Notification_to_Partner_user</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_coop_eligible_flag_on_contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Additional_Resource_Request__c.Additional_Resource__c</field>
            <operation>equals</operation>
            <value>Co-op</value>
        </criteriaItems>
        <criteriaItems>
            <field>Additional_Resource_Request__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Additional_Resource_Request__c.Procurement_Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PRM ARR NDAC - Notify Completed</fullName>
        <actions>
            <name>PRM_ARR_NDAC_Notify_Completed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Additional_Resource_Request__c.Additional_Resource__c</field>
            <operation>equals</operation>
            <value>NDAC Info Center and Training</value>
        </criteriaItems>
        <criteriaItems>
            <field>Additional_Resource_Request__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Additional_Resource_Request__c.Procurement_Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PRM ARR NDAC - Notify Rejected</fullName>
        <actions>
            <name>PRM_ARR_NDAC_Notify_Rejected</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Additional_Resource_Request__c.Additional_Resource__c</field>
            <operation>equals</operation>
            <value>NDAC Info Center and Training</value>
        </criteriaItems>
        <criteriaItems>
            <field>Additional_Resource_Request__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Additional_Resource_Request__c.Procurement_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Previous value of Access Level</fullName>
        <actions>
            <name>Previous_access_level_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISCHANGED(Access_Level__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Previous value of request status</fullName>
        <actions>
            <name>Update_previous_value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Previous value of request status</description>
        <formula>ISCHANGED(Request_Status__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Access Requested Date</fullName>
        <actions>
            <name>Access_Requested_Date_Request</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Clear_Completed_By_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Procurement_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Procurement_Status_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Removal_Requested_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Access_Requested_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND NOT 4</booleanFilter>
        <criteriaItems>
            <field>Additional_Resource_Request__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.User_Create_Status__c</field>
            <operation>notEqual</operation>
            <value>Inactive</value>
        </criteriaItems>
        <criteriaItems>
            <field>Additional_Resource_Request__c.Access_Level__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Data Loader Profile</value>
        </criteriaItems>
        <description>Updates the Access Requested Date when Request Status = Request</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Procurement Completed Date</fullName>
        <actions>
            <name>Update_Procurement_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND NOT (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Additional_Resource_Request__c.Procurement_Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Integration API Only Profile</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Data Loader Profile</value>
        </criteriaItems>
        <description>Updates the Procurement Completed Date when Procurement Status = Completed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Removal Completed Date</fullName>
        <actions>
            <name>Update_Removal_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND NOT(2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Additional_Resource_Request__c.Procurement_Status__c</field>
            <operation>equals</operation>
            <value>Removed</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Integration API Only Profile</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Data Loader Profile</value>
        </criteriaItems>
        <description>Updates the Procurement Completed Date when Procurement Status = Removed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Removal Requested Date</fullName>
        <actions>
            <name>Clear_Access_Requested_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Completed_By_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Procurement_Status_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Removal_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Removal_Requested_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND NOT(3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Additional_Resource_Request__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Remove</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.User_Create_Status__c</field>
            <operation>notEqual</operation>
            <value>Inactive</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Integration API Only Profile</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Data Loader Profile</value>
        </criteriaItems>
        <description>Updates the Removal Requested Date when Request Status = Remove</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Removal Requested Date with partner type %3DNo%3D _v1</fullName>
        <active>false</active>
        <formula>TEXT(Partner_Type_Update__c) = &apos;No&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_partner_type_update_field</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Removal Requested Date with partner type %3DYes%3D</fullName>
        <actions>
            <name>Access_Requested_Date_Remove</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Updates the Removal Requested Date when Request Status = Remove</description>
        <formula>AND(  ISCHANGED(Request_Status__c),  TEXT(Partner_Type_Update__c)= &apos;Yes&apos;,  TEXT(Request_Status__c)= &apos;Remove&apos;, NOT(TEXT(Partner_Contact__r.User_Create_Status__c) = &apos;Inactive&apos;), NOT( OR( $User.ProfileId =&apos;00e41000000wIbR&apos;, $User.ProfileId =&apos;00e41000000wIbT&apos;)), NOT(ISCHANGED(Partner_Type_Update__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
