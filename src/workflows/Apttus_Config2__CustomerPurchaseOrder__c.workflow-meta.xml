<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>DS_CPO_Confirmation_to_Customer</fullName>
        <description>DS CPO Confirmation to Customer</description>
        <protected>false</protected>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/DS_CPO_Confirmation_to_Customer</template>
    </alerts>
    <alerts>
        <fullName>DS_CPO_Email_Notification_Invoice_Trigger</fullName>
        <description>DS CPO Email Notification Invoice Trigger</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/DS_CPO_Email_Invoice_Template</template>
    </alerts>
    <alerts>
        <fullName>DS_CPO_Enrichment_Email_Alert_To_Account_Manager</fullName>
        <description>DS CPO Enrichment Email Alert To Account Manager</description>
        <protected>false</protected>
        <recipients>
            <field>DS_Account_manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/DS_CPO_Account_Manager_Notification_For_CPO_Enrichment</template>
    </alerts>
    <alerts>
        <fullName>DS_CPO_Enrichment_Email_Alert_To_CDM</fullName>
        <description>DS CPO Enrichment Email Alert To CDM</description>
        <protected>false</protected>
        <recipients>
            <field>DS_CDM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/DS_CPO_CDM_Notification_For_CPO_Enrichment</template>
    </alerts>
    <alerts>
        <fullName>DS_CPO_Ready_Routing_Email_Alert_To_CDM</fullName>
        <description>DS CPO Ready Routing Email Alert To CDM</description>
        <protected>false</protected>
        <recipients>
            <field>DS_CDM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/DS_CPOEmailTriggerTemp</template>
    </alerts>
    <alerts>
        <fullName>DS_CPO_Ready_for_Execution_Email_Alert_To_AM</fullName>
        <description>DS CPO Ready for Execution Email Alert To AM</description>
        <protected>false</protected>
        <recipients>
            <field>DS_Account_manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/DS_CPOEmailTriggerTemp</template>
    </alerts>
    <alerts>
        <fullName>DS_CPO_Ready_for_Execution_Email_Alert_To_CDM</fullName>
        <description>DS CPO Ready for Execution Email Alert To CDM</description>
        <protected>false</protected>
        <recipients>
            <field>DS_CDM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/DS_CPOEmailTriggerTemp</template>
    </alerts>
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
</Workflow>
