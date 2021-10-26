<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Field_Update_from_last_modified</fullName>
        <field>Last_Modified_Version__c</field>
        <formula>LastModifiedDate</formula>
        <name>Field Update from last modified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ProductIsActive</fullName>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>ProductIsActive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Old_Product_Name</fullName>
        <field>Old_Product_Name__c</field>
        <formula>PRIORVALUE(  Name )</formula>
        <name>Update Old Product Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
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
    <rules>
        <fullName>Field Update on Version change</fullName>
        <actions>
            <name>Field_Update_from_last_modified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED(Apttus_Config2__Version__c),   NOT(ISBLANK(Portfolio__c))  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NokiaCPQ_ProductStatus</fullName>
        <actions>
            <name>ProductIsActive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Product2.NokiaCPQ_State__c</field>
            <operation>equals</operation>
            <value>Create,Field Maintenance,Obsolete,Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>Product2.Portfolio__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Product Name Update</fullName>
        <actions>
            <name>Update_Old_Product_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Product_Last_Updated_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( NOT(ISNEW()), ISCHANGED(Name) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Product State Update</fullName>
        <actions>
            <name>Update_Old_Product_State</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Product_Last_Updated_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( NOT(ISNEW()), ISCHANGED( NokiaCPQ_State__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
