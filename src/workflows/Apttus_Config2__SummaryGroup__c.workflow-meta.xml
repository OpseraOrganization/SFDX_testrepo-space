<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>NokiaCPQ_Uncheck_the_Manual_Adjustment</fullName>
        <field>Apttus_Config2__AllowManualAdjustment__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck the Manual Adjustment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Additional_Information_for_CAD</fullName>
        <field>NokiaCPQ_Additional_Information__c</field>
        <formula>&apos;CAD -&apos; &amp; TEXT(Apttus_Config2__AdjustmentAmount__c) &amp;  Text(Apttus_Config2__ConfigurationId__r.Apttus_Config2__PriceListId__r.CurrencyIsoCode)</formula>
        <name>Update Additional Information for CAD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Adjustment_Type_Indirect</fullName>
        <field>Apttus_Config2__AdjustmentType__c</field>
        <literalValue>Discount Amount</literalValue>
        <name>Update Adjustment Type Indirect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Adjustment_Type_NSW_Direct</fullName>
        <field>Apttus_Config2__AdjustmentType__c</field>
        <name>Update Adjustment Type Direct</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Adjustment_type_on_summary_group</fullName>
        <field>Apttus_Config2__AdjustmentType__c</field>
        <literalValue>% Discount</literalValue>
        <name>Update Adjustment type on summary group</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Additional Information for CAD</fullName>
        <actions>
            <name>Update_Additional_Information_for_CAD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Quote_Type__c = $Label.IndirectCPQ , Apttus_Config2__AdjustmentAmount__c &gt; 0)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Disallow Manual Adjustment on Summary Group</fullName>
        <actions>
            <name>NokiaCPQ_Uncheck_the_Manual_Adjustment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>OR( AND( 	Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Quote_Type__c = $Label.IndirectCPQ , 	Name != &apos;Total (One Time)&apos; ), AND( 	Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Quote_Type__c = $Label.DirectCPQ, 	Name != &apos;Subtotal - Standard Price (One Time)&apos; ) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Nokia CPQ update Adjustment Type for Direct</fullName>
        <actions>
            <name>Update_Adjustment_Type_NSW_Direct</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(  Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Quote_Type__c = $Label.DirectCPQ,  Name != &apos;Subtotal - Standard Price (One Time)&apos; )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Nokia CPQ update adjustment type for direct quotes</fullName>
        <actions>
            <name>Update_Adjustment_type_on_summary_group</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND( Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Quote_Type__c = $Label.DirectCPQ,  Name = &apos;Subtotal - Standard Price (One Time)&apos; )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Nokia CPQ update adjustment type for indirect quotes</fullName>
        <actions>
            <name>Update_Adjustment_Type_Indirect</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND( Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Quote_Type__c = $Label.IndirectCPQ ,  Name = &apos;Total (One Time)&apos;  )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
