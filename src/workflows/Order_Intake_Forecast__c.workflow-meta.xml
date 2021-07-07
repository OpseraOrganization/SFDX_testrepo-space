<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>OIF EUR Currency Update</fullName>
        <actions>
            <name>OIF_EUR_Value_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>If the opportunity currency will be EUR then OIF EUR value update (Req:136)</description>
        <formula>ISPICKVAL( Opportunity__r.CurrencyIsoCode ,&apos;EUR&apos;)  &amp;&amp; ($Profile.Name&lt;&gt;$Label.Data_Loader_Profile_Name)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
