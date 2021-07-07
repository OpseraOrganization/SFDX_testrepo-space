<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>LockingOpptyIfClosedbeforeG5SalesPhaseAndRTIndirect</fullName>
        <actions>
            <name>UpdateReadonlyIndirectRecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>REQ855</description>
        <formula>AND(  OR(      ISPICKVAL(StageName, &apos;Closed - Cancelled by Customer&apos;),   ISPICKVAL(StageName, &apos;Closed - Withdrawn by Nokia&apos;),    ISPICKVAL(StageName, &apos;Closed - Lost to Competitor&apos;),   ISPICKVAL(StageName, &apos;Closed - Obsolete&apos;) ),  $RecordType.DeveloperName = &apos;Indirect_Record_Type&apos;, $Profile.Name &lt;&gt; $Label.Data_Loader_Profile_Name )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Automatic_Bypass_of_Gate5</fullName>
        <assignedToType>owner</assignedToType>
        <description>This opportunity has been bypassed automatically in Gate 5</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Automatic Bypass of Gate5</subject>
    </tasks>
</Workflow>
