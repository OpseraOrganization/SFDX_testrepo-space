<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>DSUpdateStartDateBasedOnEndDateTermsCPO</fullName>
        <field>Contract_start_date__c</field>
        <formula>ADDMONTHS(Contract_end_date__c,- Terms__c)</formula>
        <name>DSUpdateStartDateBasedOnEndDateTermsCPO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DS_Update_Business_Category</fullName>
        <field>Business_category__c</field>
        <literalValue>2G</literalValue>
        <name>DS Update Business Category</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DS_Update_Business_Category_to_blank</fullName>
        <field>Business_category__c</field>
        <name>DS Update Business Category to blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DS_Update_Contract_End_Date_on_CPO</fullName>
        <field>Contract_end_date__c</field>
        <formula>ADDMONTHS(Contract_start_date__c , Terms__c)</formula>
        <name>DS Update Contract End Date on CPO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DS_Update_End_Date_on_CPO</fullName>
        <field>Contract_end_date__c</field>
        <formula>ADDMONTHS( Contract_start_date__c ,  Terms__c )</formula>
        <name>DS Update End Date on CPO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DS_Update_Reporting</fullName>
        <field>Reporting__c</field>
        <literalValue>Excl contr from OBL</literalValue>
        <name>DS Update Reporting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DS_Update_Reporting_to_blank</fullName>
        <field>Reporting__c</field>
        <name>DS Update Reporting to blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DS_Update_Terms_on_CPO</fullName>
        <field>Terms__c</field>
        <formula>IF(MOD(Contract_end_date__c- Contract_start_date__c,30) =0 , (Contract_end_date__c- Contract_start_date__c) /30 , 

IF(MOD(Contract_end_date__c- Contract_start_date__c,30) &gt;=15, FLOOR(((Contract_end_date__c- Contract_start_date__c) /30)) +1, 

Floor( (Contract_end_date__c- Contract_start_date__c)/ 30 )))</formula>
        <name>DS Update Terms on CPO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>DS Check ERP is P20</fullName>
        <actions>
            <name>DS_Update_Business_Category</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>DS_Update_Reporting</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Config2__CustomerPurchaseOrder__c.ERP__c</field>
            <operation>equals</operation>
            <value>P20</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DS Check ERP is blank</fullName>
        <actions>
            <name>DS_Update_Business_Category_to_blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>DS_Update_Reporting_to_blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Apttus_Config2__CustomerPurchaseOrder__c.ERP__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DS Check if Contract End Date is blank on CPO</fullName>
        <actions>
            <name>DS_Update_Contract_End_Date_on_CPO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISNULL(Contract_end_date__c),NOT(ISNULL(Contract_start_date__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DS Check if Contract End Date is not Blank on CPO</fullName>
        <actions>
            <name>DS_Update_Terms_on_CPO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(OR(ISCHANGED(Contract_end_date__c ),ISCHANGED(Contract_start_date__c ),ISBLANK(Terms__c)),NOT(ISNULL(Contract_start_date__c)),NOT(ISNULL(Contract_end_date__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DS Check if Terms has changed on CPO</fullName>
        <actions>
            <name>DS_Update_End_Date_on_CPO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(  Terms__c ),NOT(ISCHANGED(Contract_end_date__c)), NOT(ISBLANK(Terms__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DS_CPOEmailTrigger</fullName>
        <actions>
            <name>DS_CPO_Ready_Routing_Email_Alert_To_CDM</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>DS_CPO_Ready_for_Execution_Email_Alert_To_AM</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>DS_CPO_Ready_for_Execution_Email_Alert_To_CDM</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>DSI-778. The status update to &quot;Ready for Routing&quot; will trigger a mailing in an
automated way</description>
        <formula>AND(ISPICKVAL(Apttus_Config2__Status__c , &apos;Ready for Execution&apos;), ISCHANGED(Apttus_Config2__Status__c ), ISPICKVAL(Contract_Type_Name__c , &apos;Contract mode&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DS_StartDate Calculation on Term And End Date on CPO</fullName>
        <actions>
            <name>DSUpdateStartDateBasedOnEndDateTermsCPO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISBLANK(Contract_start_date__c),ISCHANGED(Contract_start_date__c),NOT(ISBLANK(Contract_end_date__c)),NOT(ISBLANK( Terms__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
