<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_BG_Field_from_Product</fullName>
        <field>Business_Group__c</field>
        <formula>TEXT(Product__r.Business_Group__c)</formula>
        <name>Update BG Field from Product</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Update BG Field from Product to ProductExtension</fullName>
        <actions>
            <name>Update_BG_Field_from_Product</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( NOT( ISBLANK( Product__c ) ), $Profile.Name &lt;&gt; &apos;Data Loader Profile&apos;, OR(  ISNEW(), ISCHANGED( Product__c ), ISCHANGED( Custom_Bid__c ), ISCHANGED( Floor_Price__c ), ISCHANGED( Market_Price__c ), ISCHANGED( List_Price__c ), ISCHANGED( Market__c ), ISCHANGED( CurrencyIsoCode )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
