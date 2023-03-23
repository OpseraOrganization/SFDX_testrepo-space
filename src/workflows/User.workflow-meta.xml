<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>User_Management_60_Days_User_Deactivation_Notification_LOA_User</fullName>
        <description>User Management 60 Days User Deactivation Notification: LOA User</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/User_Management_60_Days_User_Deactivation_Notification_LOA_User</template>
    </alerts>
    <alerts>
        <fullName>User_Management_60_Days_User_Deactivation_Notification_Non_LOA_User</fullName>
        <description>User Management 60 Days User Deactivation Notification: Non LOA User</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/User_Management_60_Days_User_Deactivation_Notification_Non_LOA_User</template>
    </alerts>
    <alerts>
        <fullName>X90_Days_User_Deactivation_Notification1</fullName>
        <description>90 Days User Deactivation Notification1</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ALL/X90_Days_User_Deactivation_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>DCP_Deactivate1</fullName>
        <field>DCP_deactivate__c</field>
        <literalValue>0</literalValue>
        <name>DCP Deactivate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DCP_deactivate</fullName>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>DCP deactivate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Handling_Internal_Contact_True</fullName>
        <field>CH_Case_Handling_Internal_Contact__c</field>
        <literalValue>1</literalValue>
        <name>Set Case Handling Internal Contact True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Email_Sent_Date</fullName>
        <field>Email_Sent__c</field>
        <formula>NOW()</formula>
        <name>Update Email Sent Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Old_Email</fullName>
        <field>CH_OldEmail__c</field>
        <formula>Email</formula>
        <name>Update Old Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_auto_deactivation</fullName>
        <field>Auto_Deactivation__c</field>
        <formula>(&quot;Deactivated due to inactivity&quot;) + &apos; &apos; + TEXT(Today())</formula>
        <name>update auto deactivation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Auto Deactivation DCP Internal Portal User</fullName>
        <actions>
            <name>DCP_deactivate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>update_auto_deactivation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 4 AND 5 AND (2 OR 3 ) AND 6</booleanFilter>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>DCP Internal Portal User</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.LastLoginDate</field>
            <operation>lessThan</operation>
            <value>LAST 90 DAYS</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.LastLoginDate</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.Do_Not_Deactivate_User__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.IsActive</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.CreatedDate</field>
            <operation>lessThan</operation>
            <value>LAST 90 DAYS</value>
        </criteriaItems>
        <description>Auto Deactivation of DCP Users if not logged in to CRM &gt; 90Days OR Never logged in</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DCP Internal Portal User%3A Field Update</fullName>
        <actions>
            <name>DCP_Deactivate1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>DCP Internal Portal User</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.IsActive</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Auto Deactivation DCP Internal Portal User: This WF is will ensure the safe reactivation of  DCP Internal Portal Use</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Case Handling Internal Contact to true</fullName>
        <actions>
            <name>Set_Case_Handling_Internal_Contact_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.IsActive</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>CH_Case Handler</value>
        </criteriaItems>
        <description>NOKIASC-4622 : This rule triggers when the new user is created and profile equals &apos;CH_Case Handler&apos;.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update old email value on User record</fullName>
        <actions>
            <name>Update_Old_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.IsActive</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.CH_Case_Handling_Internal_Contact__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>4622 : Rule fires to hold user old value</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>User Deactivation not logged in %3E 90 Days Email Notification</fullName>
        <actions>
            <name>X90_Days_User_Deactivation_Notification1</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Email_Sent_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND ( 5 OR 6) AND 7 AND 8</booleanFilter>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>contains</operation>
            <value>3rd Party Telemarketing Profile,Global Process Admin Profile,iCare Profile,Marketing Profile,Nokia Admin Profile,Nokia Read Only,Nokia Sales Profile,Non-Sales User Profile,Sales Ops Profile,System Administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.LastLoginDate</field>
            <operation>lessThan</operation>
            <value>LAST 60 DAYS</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.IsActive</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Do_Not_Deactivate_User__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Reactivation_Date__c</field>
            <operation>lessThan</operation>
            <value>LAST 30 DAYS</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Reactivation_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.CreatedDate</field>
            <operation>lessThan</operation>
            <value>LAST 60 DAYS</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.User_Deactivate__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
