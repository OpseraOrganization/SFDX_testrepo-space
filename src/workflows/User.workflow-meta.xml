<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
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
</Workflow>
