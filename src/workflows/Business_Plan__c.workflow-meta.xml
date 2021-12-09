<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
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
