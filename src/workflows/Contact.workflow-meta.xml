<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Contact_Inactive_Mail</fullName>
        <ccEmails>gss.partnersupport@nokia.com; partner.registration@nokia.com</ccEmails>
        <description>Contact Inactive Mail</description>
        <protected>false</protected>
        <senderAddress>nokia_global_partner_communications@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Secondary_Resources/Contact_Inactive_Mail</template>
    </alerts>
    <alerts>
        <fullName>Contact_Status_is_still_Open</fullName>
        <ccEmails>michael.schuele.ext@nokia.com</ccEmails>
        <description>Contact Status is still Open</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ALL/Reminder_Contact</template>
    </alerts>
    <alerts>
        <fullName>New_Contact</fullName>
        <ccEmails>michael.schuele.ext@nokia.com</ccEmails>
        <description>New Contact is Created</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ALL/New_Contact</template>
    </alerts>
    <fieldUpdates>
        <fullName>NCP_Update_Sync_To_Marketo_Customer</fullName>
        <description>This field update is used to update the flag Sync To Marketo as True</description>
        <field>Sync_To_Marketo__c</field>
        <literalValue>1</literalValue>
        <name>NCP Update Sync To Marketo(Customer)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NCP_Update_Sync_To_Marketo_Supplier</fullName>
        <description>This field update is used to update the flag Sync To Marketo as False</description>
        <field>Sync_To_Marketo__c</field>
        <literalValue>0</literalValue>
        <name>NCP Update Sync To Marketo(Supplier)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Poplulate_Sales_Manager_Email_Contact</fullName>
        <field>Sales_Manager_Email__c</field>
        <formula>Owner.Manager.Email</formula>
        <name>Poplulate Sales Manager Email Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Contact_State_Field_Update</fullName>
        <description>Req #1491</description>
        <field>State__c</field>
        <formula>MailingState</formula>
        <name>Populate Contact State Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TimeStamp_Last_Edited_Con</fullName>
        <field>TM_Edited_by__c</field>
        <formula>LastModifiedBy.FirstName + &quot; - &quot; + LastModifiedBy.Username</formula>
        <name>TimeStamp(Last_Edited_Con)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TimeStamp_Last_Upadated_Con</fullName>
        <field>TM_Last_Updated__c</field>
        <formula>now()</formula>
        <name>TimeStamp(Last_Upadated_Con)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TimeStamp_Last_Updated_Con</fullName>
        <field>TM_Last_Updated__c</field>
        <formula>now()</formula>
        <name>TimeStamp(Last_Updated_Con)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Partner_Account_Name</fullName>
        <field>Partner_Account_Name__c</field>
        <formula>Account.AccountNumber</formula>
        <name>Update Partner Account Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SyncToMarketo_TRUE_Contact</fullName>
        <field>Sync_To_Marketo__c</field>
        <literalValue>1</literalValue>
        <name>Update SyncToMarketo TRUE Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Contact Account Update</fullName>
        <actions>
            <name>Update_Partner_Account_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.AccountName</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact Inactive Mail</fullName>
        <actions>
            <name>Contact_Inactive_Mail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.User_Create_Status__c</field>
            <operation>equals</operation>
            <value>Inactive</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contact Marketo check for Customer Type</fullName>
        <actions>
            <name>Update_SyncToMarketo_TRUE_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.CH_ContactType__c</field>
            <operation>equals</operation>
            <value>Customer,Partner,No Relationship</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Data Loader Profile</value>
        </criteriaItems>
        <description>contacts which have the &apos;Contact type&apos; as Customer the Sync to Marketo checkbox should automatically/by default checked</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Notification For New Contact</fullName>
        <actions>
            <name>New_Contact</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Req #5118

Send Email notification (New Contact) to contact owner if certain criteria&apos;s on contact are full filled</description>
        <formula>AND(ISPICKVAL( Status__c , &quot;Open&quot;),(OR(ISPICKVAL(Budget__c, &quot;0 - 99K&quot;),ISPICKVAL(Budget__c, &quot;100K - 249K&quot;), ISPICKVAL(Budget__c, &quot;250K - 499K&quot;),ISPICKVAL(Budget__c, &quot;500K - 1M&quot;),ISPICKVAL(Budget__c, &quot;Over 1M&quot;),ISPICKVAL(Budget__c, &quot;Not specified&quot;))), NOT(ISBLANK(Description)), (OR(ISPICKVAL(Purchasing_Timeframe__c , &quot;0 - 3 Months&quot;),ISPICKVAL(Purchasing_Timeframe__c , &quot;4 - 6 Months&quot;),ISPICKVAL(Purchasing_Timeframe__c , &quot;7 - 12 Months&quot;),ISPICKVAL(Purchasing_Timeframe__c , &quot;No Project Now&quot;))) , (OR(ISPICKVAL(Purchasing_Role__c, &quot;Approver&quot;),ISPICKVAL(Purchasing_Role__c, &quot;Decision Maker&quot;),ISPICKVAL(Purchasing_Role__c, &quot;Influencer&quot;),ISPICKVAL(Purchasing_Role__c, &quot;Contact&quot;))), $Profile.Name &lt;&gt; $Label.Data_Loader_Profile_Name, NOT(ISBLANK(Marketing_Campaign__c )))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Email Notification For Open Contact</fullName>
        <active>false</active>
        <description>Req #5119 

Send Email notification (REMINDER) to contact owner if certain criteria&apos;s on contact are full filled</description>
        <formula>AND(ISPICKVAL( Status__c , &quot;Open&quot;),(OR(ISPICKVAL(Budget__c, &quot;0 - 99K&quot;),ISPICKVAL(Budget__c, &quot;100K - 249K&quot;), ISPICKVAL(Budget__c, &quot;250K - 499K&quot;),ISPICKVAL(Budget__c, &quot;500K - 1M&quot;),ISPICKVAL(Budget__c, &quot;Over 1M&quot;),ISPICKVAL(Budget__c, &quot;Not specified&quot;))), NOT(ISBLANK(Description)), (OR(ISPICKVAL(Purchasing_Timeframe__c , &quot;0 - 3 Months&quot;),ISPICKVAL(Purchasing_Timeframe__c , &quot;4 - 6 Months&quot;),ISPICKVAL(Purchasing_Timeframe__c , &quot;7 - 12 Months&quot;),ISPICKVAL(Purchasing_Timeframe__c , &quot;No Project Now&quot;))) , (OR(ISPICKVAL(Purchasing_Role__c, &quot;Approver&quot;),ISPICKVAL(Purchasing_Role__c, &quot;Decision Maker&quot;),ISPICKVAL(Purchasing_Role__c, &quot;Influencer&quot;),ISPICKVAL(Purchasing_Role__c, &quot;Contact&quot;))), $Profile.Name &lt;&gt; $Label.Data_Loader_Profile_Name, NOT(ISBLANK(Marketing_Campaign__c )))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Contact_Status_is_still_Open</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Contact.LastModifiedDate</offsetFromField>
            <timeLength>12</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>NCP Sync To Marketo%28Customer%29</fullName>
        <actions>
            <name>NCP_Update_Sync_To_Marketo_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.CH_ContactType__c</field>
            <operation>equals</operation>
            <value>Customer</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Data Loader Profile</value>
        </criteriaItems>
        <description>This workflow is used to update the flag Sync To Marketo as True if the contact type is a customer</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NCP Sync To Marketo%28Supplier%29</fullName>
        <actions>
            <name>NCP_Update_Sync_To_Marketo_Supplier</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.CH_ContactType__c</field>
            <operation>equals</operation>
            <value>Supplier</value>
        </criteriaItems>
        <description>This workflow is used to update the flag Sync To Marketo as False if the contact type is a supplier</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Populate Contact State Rule</fullName>
        <actions>
            <name>Populate_Contact_State_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.MailingState</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate Sales Manager Email Contact</fullName>
        <actions>
            <name>Poplulate_Sales_Manager_Email_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( ISBLANK( Sales_Manager_Email__c )  , ( Sales_Manager_Email__c &lt;&gt;  Owner.Manager.Email  ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TM_Edited_by%2FTM Last Updated%28Contact%29</fullName>
        <actions>
            <name>TimeStamp_Last_Edited_Con</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>TimeStamp_Last_Updated_Con</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Req #3774

Req #5067</description>
        <formula>AND($Profile.Name &lt;&gt; $Label.Data_Loader_Profile_Name, OR(  ISCHANGED( TM_Lead_Status__c ),  ISCHANGED( TM_Notes__c ), ISCHANGED( TM_List_Source__c) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
