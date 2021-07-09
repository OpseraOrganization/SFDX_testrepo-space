<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
  <fieldUpdates>
    <fullName>PRM_Update_Accreditation_Evaluation_Flag</fullName>
    <field>Evaluated_Accreditation__c</field>
    <literalValue>1</literalValue>
    <name>PRM Update Accreditation FlagTest0402</name>
    <notifyAssignee>false</notifyAssignee>
    <operation>Literal</operation>
    <protected>false</protected>
    <reevaluateOnChange>false</reevaluateOnChange>
  </fieldUpdates>
  <rules>
    <fullName>Notify on Accreditation Level Change</fullName>
    <actions>
      <name>Email_Alert_on_Accreditation_Level_Change</name>
      <type>Alert</type>
    </actions>
    <actions>
      <name>Sent_Email_updates_to_PSM</name>
      <type>Task</type>
    </actions>
    <active>false</active>
    <formula>ISCHANGED(Accreditation_Level__c)</formula>
    <triggerType>onAllChanges</triggerType>
  </rules>
</Workflow>
