<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Business_Plan_Submission_Email_Notification</fullName>
        <description>Business Plan Submission Email Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Partner_Program_Contact_s_PRM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>nokia_global_partner_communications@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Business_Planning/Business_Plan_Submission_Email_Notification</template>
    </alerts>
    <alerts>
        <fullName>Business_Plan_Successful_Cloning_Notification</fullName>
        <description>Business Plan Successful Cloning  Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Partner_Program_Contact_s_PRM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>nokia_global_partner_communications@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Business_Planning/Business_Planning_Approval_Process_Notification_Ema</template>
    </alerts>
    <alerts>
        <fullName>Business_Plan_Successful_Cloning_Notification_If_not_Populate_PRM</fullName>
        <description>Business Plan Successful Cloning  Notification If not Populate PRM</description>
        <protected>false</protected>
        <recipients>
            <field>Nokia_Partner_Primary_Partner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>nokia_global_partner_communications@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Business_Planning/Business_Planning_Successful_Cloning_Notification_For_PRM_Not_Populate</template>
    </alerts>
    <alerts>
        <fullName>Business_Plan_Successful_Cloning_Notification_PSM</fullName>
        <description>Business Plan Successful Cloning  Notification PSM</description>
        <protected>false</protected>
        <recipients>
            <field>Nokia_Partner_Primary_Partner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>nokia_global_partner_communications@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Business_Planning/Business_Planning_Successful_Cloning_Notification_for_PSM</template>
    </alerts>
    <alerts>
        <fullName>Business_Planning_Successful_Creation_Notification</fullName>
        <description>Business Planning Successful Creation Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Partner_Program_Contact_s_PRM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>nokia_global_partner_communications@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Business_Planning/Business_Planning_Successful_Creation_Notification</template>
    </alerts>
    <alerts>
        <fullName>Business_Planning_Successful_cloning_Notification_PRM_PSM</fullName>
        <description>Business Planning Successful cloning  Notification PRM-PSM</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Partner_Program_Contact_s_PRM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>nokia_global_partner_communications@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Business_Planning/Business_Planning_Successful_cloning_Notification_PRM_PSM</template>
    </alerts>
    <rules>
        <fullName>Business Plan Submission Email PRM equl to PSM</fullName>
        <actions>
            <name>Business_Plan_Submission_Email_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Business Plan Submission Email PRM equl to PSM</description>
        <formula>AND($Profile.Name != &apos;PRM Partner Relationship Manager Login&apos; &amp;&amp;  $Profile.Name != &apos;Integration API Only Profile&apos; &amp;&amp; ISPICKVAL( Business_Plan_Status__c , &quot;Submitted&quot;) &amp;&amp;      $Profile.Name != &apos;Data Loader&apos; &amp;&amp;  Primary_Partner_Program_Contact_s_PRM__c  ==   Nokia_Partner_Primary_Partner__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Business Plan Submission Email PRM not equl to PSM</fullName>
        <actions>
            <name>Business_Planning_Submission_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Business Plan Submission Email PRM not equl to PSM</description>
        <formula>AND($Profile.Name != &apos;PRM Partner Relationship Manager Login&apos; &amp;&amp;  $Profile.Name != &apos;Integration API Only Profile&apos; &amp;&amp; ISPICKVAL( Business_Plan_Status__c , &quot;Submitted&quot;) &amp;&amp;  $Profile.Name != &apos;Data Loader&apos; &amp;&amp; Primary_Partner_Program_Contact_s_PRM__c != Nokia_Partner_Primary_Partner__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
