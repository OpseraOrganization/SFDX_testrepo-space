<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Old_Product_State</fullName>
        <field>Old_State__c</field>
        <formula>TEXT(PRIORVALUE( NokiaCPQ_State__c ))</formula>
        <name>Update Old Product State</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Product_Last_Updated_Date</fullName>
        <field>Product_Last_Updated__c</field>
        <formula>TODAY()</formula>
        <name>Update Product Last Updated Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
