<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Account_Market_Update</fullName>
        <field>NokiaCPQ_Account_Region__c</field>
        <formula>Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.NokiaCPQ_Geo_Level_1_ID__c</formula>
        <name>Account Market Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPQ_LI_ApprovalStatus_Update</fullName>
        <field>Apttus_CQApprov__Approval_Status__c</field>
        <literalValue>Approval Required</literalValue>
        <name>CPQ_LI_ApprovalStatus_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>List_Price</fullName>
        <description>Update List price from  PLI to Config LI</description>
        <field>Apttus_Config2__ListPrice__c</field>
        <formula>Apttus_Config2__PriceListItemId__r.Apttus_Config2__ListPrice__c</formula>
        <name>List Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quan_Update</fullName>
        <field>Apttus_Config2__Quantity__c</field>
        <name>Quan Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quan_Update_FBA</fullName>
        <field>Apttus_Config2__Quantity__c</field>
        <name>Quan Update FBA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Account Market Update</fullName>
        <actions>
            <name>Account_Market_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Apttus_Config2__ProductConfiguration__c.Apttus_Config2__BusinessObjectType__c</field>
            <operation>equals</operation>
            <value>Proposal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Config2__ProductConfiguration__c.Quote_Type__c</field>
            <operation>contains</operation>
            <value>CPQ</value>
        </criteriaItems>
        <description>This workflow will update Account Market.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CPQ_Approval_Check</fullName>
        <actions>
            <name>CPQ_LI_ApprovalStatus_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Used to Set Approval Required status for Line item for QTC Portfolio</description>
        <formula>AND(Portfolio_from_Quote_Line_Item__c=&apos;QTC&apos;, OR(ISPICKVAL( Apttus_CQApprov__Approval_Status__c , &apos;Cancelled&apos;),ISPICKVAL( Apttus_CQApprov__Approval_Status__c , &apos;Rejected&apos;) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DS Update Customer Grouping</fullName>
        <actions>
            <name>Customer_Grouping_Field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>List_Price</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Customer grouping field with value on Price list item</description>
        <formula>AND( Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Quote_Type__c = &apos;Direct DS&apos;,   Apttus_Config2__PriceListItemId__c != null, NokiaCPQ_Configuration_Type__c != &apos;Option&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Enable Manual Adjustment For Options</fullName>
        <actions>
            <name>Disable_Manual_Adjustment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Apttus_Config2__LineItem__c.Quote_Type__c</field>
            <operation>equals</operation>
            <value>Direct CPQ</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Config2__LineItem__c.Apttus_Config2__ChargeType__c</field>
            <operation>notEqual</operation>
            <value>Standard Price</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Config2__LineItem__c.NokiaCPQ_Portfolio__c</field>
            <operation>equals</operation>
            <value>Nokia Software</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Is FBA Update</fullName>
        <actions>
            <name>Is_FBA_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Total_ONT_Quantity_Update_FBA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>IF( TEXT(Apttus_Config2__LineType__c) = &apos;Option&apos;, (TEXT(Apttus_Config2__OptionId__r.NokiaCPQ_Category__c) != &apos;PTP&apos;) &amp;&amp; TEXT(Apttus_Config2__OptionId__r.NokiaCPQ_Category__c) = &apos;ONT&apos; &amp;&amp; Apttus_Config2__OptionId__r.Portfolio__c = &apos;Fixed Access - FBA&apos; &amp;&amp; Apttus_Config2__ListPrice__c &gt; 0,  (TEXT(Apttus_Config2__ProductId__r.NokiaCPQ_Category__c) != &apos;PTP&apos;) &amp;&amp; TEXT(Apttus_Config2__ProductId__r.NokiaCPQ_Category__c) = &apos;ONT&apos; &amp;&amp; Apttus_Config2__ProductId__r.Portfolio__c = &apos;Fixed Access - FBA&apos; &amp;&amp; Apttus_Config2__ListPrice__c &gt; 0 )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Is P2P Update</fullName>
        <actions>
            <name>Is_P2P_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Total_ONT_Quantity_Update_P2P</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>IF( TEXT(Apttus_Config2__LineType__c) = &apos;Option&apos;, TEXT(Apttus_Config2__OptionId__r.NokiaCPQ_Category__c) = &apos;PTP&apos; &amp;&amp; Apttus_Config2__OptionId__r.Number_of_GE_Ports__c &gt; 0 &amp;&amp; Apttus_Config2__ListPrice__c &gt; 0,  TEXT(Apttus_Config2__ProductId__r.NokiaCPQ_Category__c) = &apos;PTP&apos; &amp;&amp; Apttus_Config2__ProductId__r.Number_of_GE_Ports__c &gt; 0 &amp;&amp; Apttus_Config2__ListPrice__c &gt; 0 )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ON Quantity Update</fullName>
        <actions>
            <name>Quan_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>(Apttus_Config2__ProductId__r.ProductCode = &apos;3FE30998BA&apos; || Apttus_Config2__ProductId__r.ProductCode = &apos;301049607&apos;) &amp;&amp;  Apttus_Config2__ConfigurationId__r.NokiaCPQ_Portfolio_From_Quote__c = &apos;Fixed Access - POL&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ON Quantity Update FBA</fullName>
        <actions>
            <name>Quan_Update_FBA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>(Apttus_Config2__ProductId__r.ProductCode = &apos;3EC17929UA&apos; || Apttus_Config2__ProductId__r.ProductCode = &apos;3FE30949BA&apos; || Apttus_Config2__ProductId__r.ProductCode = &apos;301049607&apos;) &amp;&amp;  Apttus_Config2__ConfigurationId__r.NokiaCPQ_Portfolio_From_Quote__c = &apos;Fixed Access - FBA&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update ONT Qunatity</fullName>
        <actions>
            <name>ONT_Quantity_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>IF( TEXT(Apttus_Config2__LineType__c) = &apos;Option&apos;, Apttus_Config2__OptionId__r.Number_of_GE_Ports__c &gt; 0 &amp;&amp; TEXT(Apttus_Config2__OptionId__r.NokiaCPQ_Category__c) != &apos;PTP&apos; &amp;&amp; Apttus_Config2__ConfigurationId__r.NokiaCPQ_Portfolio_From_Quote__c = &apos;Fixed Access - POL&apos; &amp;&amp; Apttus_Config2__ListPrice__c &gt; 0, Apttus_Config2__ProductId__r.Number_of_GE_Ports__c &gt; 0 &amp;&amp; TEXT(Apttus_Config2__ProductId__r.NokiaCPQ_Category__c) != &apos;PTP&apos; &amp;&amp; Apttus_Config2__ConfigurationId__r.NokiaCPQ_Portfolio_From_Quote__c = &apos;Fixed Access - POL&apos; &amp;&amp; Apttus_Config2__ListPrice__c &gt; 0 )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
