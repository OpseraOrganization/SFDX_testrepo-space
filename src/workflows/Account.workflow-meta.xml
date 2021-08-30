<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_notification_to_be_sent_out_if_the_Partner_Status_is_Customer_Terminated_o</fullName>
        <ccEmails>gss.partnersupport@nokia.com</ccEmails>
        <description>Email notification to be sent out if the Partner Status is Customer Terminated or Partner Terminated.</description>
        <protected>false</protected>
        <senderAddress>nokia_global_partner_communications@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Secondary_Resources/email_notification_when_a_partner_account_is_terminated</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_Icare</fullName>
        <ccEmails>gss.partnersupport@nokia.com</ccEmails>
        <description>Notification to Icare</description>
        <protected>false</protected>
        <senderAddress>nokia_global_partner_communications@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Secondary_Resources/Notify_Icare</template>
    </alerts>
    <fieldUpdates>
        <fullName>Business_Date_Set</fullName>
        <field>Lifecycle_Business_Developement_Date__c</field>
        <formula>NOW()</formula>
        <name>Business Date Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Co_op_enabled_date</fullName>
        <field>Co_op_Enabled_Date__c</field>
        <formula>TODAY()</formula>
        <name>Co-op enabled date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Disengaged_Date_Set</fullName>
        <field>Lifecycle_Disengaged_Date__c</field>
        <formula>NOW()</formula>
        <name>Disengaged Date Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lifecycle_Acquisition_Date_Update</fullName>
        <field>Lifecycle_Acquisition_Date__c</field>
        <formula>NOW()</formula>
        <name>Lifecycle - Acquisition Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Old_value_field</fullName>
        <field>Partner_Program_Old_Value__c</field>
        <formula>TEXT(PRIORVALUE(Partner_Program__c))</formula>
        <name>Old value field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PRM_Terminate_Display_on_Partner_Locator</fullName>
        <field>Co_op_Account_Created__c</field>
        <literalValue>No</literalValue>
        <name>PRM Terminate Display on Partner Locator</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Acquisition_Set</fullName>
        <field>Partner_Lifecycle__c</field>
        <literalValue>Acquisition</literalValue>
        <name>Partner Acquisition Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prospect_country_code</fullName>
        <field>CountryNameISO2__c</field>
        <formula>TEXT( CountryCode__c )</formula>
        <name>Prospect country code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Revenue_Date_Set</fullName>
        <field>Lifecycle_Revenue_Producing_Date__c</field>
        <formula>NOW()</formula>
        <name>Revenue Date Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Disable_Partner_Field_to_False</fullName>
        <field>Partner_Disable__c</field>
        <literalValue>0</literalValue>
        <name>Update Disable Partner Field to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Unique_Id</fullName>
        <description>Requirement# 059 &amp; 104
Combination of Name +  BillingStreet +  BillingCity +  BillingCountry has to be unique</description>
        <field>Unique_Id__c</field>
        <formula>Name +  BillingStreet +  BillingCity +  BillingCountry</formula>
        <name>Update Unique Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Acquisition_Set_once_Partner_Registered</fullName>
        <actions>
            <name>Lifecycle_Acquisition_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Partner_Acquisition_Set</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Partner_Registration_Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Business Date Set</fullName>
        <actions>
            <name>Business_Date_Set</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Partner_Lifecycle__c</field>
            <operation>equals</operation>
            <value>Business Development</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Check Duplicate</fullName>
        <actions>
            <name>Update_Unique_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If &quot;uniqueness test&quot; does not pass, system should provide link to account with those four fields (Legal Name, Street, City, Country) 
Requirement #59,Requirement #104</description>
        <formula>AND( $Profile.Name &lt;&gt; $Label.Data_Loader_Profile_Name,  Name  &lt;&gt; &apos;&apos; ,  BillingCity  &lt;&gt; &apos;&apos; ,  BillingCountry &lt;&gt; &apos;&apos;,  RecordType.DeveloperName = &apos;Prospect&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Co-op enabled account</fullName>
        <actions>
            <name>Co_op_enabled_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Enrolled_in_Co_Op__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Disable Partner Uncheck on Account Enabled as Partner</fullName>
        <actions>
            <name>Update_Disable_Partner_Field_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.IsPartner</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Disengaged Date Set</fullName>
        <actions>
            <name>Disengaged_Date_Set</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Partner_Lifecycle__c</field>
            <operation>equals</operation>
            <value>Disengaged</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email notification to be sent out if the Partner Status is Customer Terminated or Partner Terminated</fullName>
        <actions>
            <name>Email_notification_to_be_sent_out_if_the_Partner_Status_is_Customer_Terminated_o</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>PRM_Terminate_Display_on_Partner_Locator</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Email notification to be sent out if the Partner Status is Customer Terminated or Partner Terminated</description>
        <formula>ISPICKVAL(Partner_Status__c,&apos;Customer Terminated&apos;) || ISPICKVAL(Partner_Status__c,&apos;Partner Terminated&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Partner Program Field Update</fullName>
        <actions>
            <name>Old_value_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>created and every time Account GPP  is edited</description>
        <formula>ISCHANGED(Partner_Program__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Prospect country code</fullName>
        <actions>
            <name>Prospect_country_code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>On prospect account creation country code to be mapped to Country Code ISO2 field</description>
        <formula>AND( $Profile.Name &lt;&gt; $Label.Data_Loader_Profile_Name,  RecordType.DeveloperName  = &apos;Prospect&apos; )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Revenue Date Set</fullName>
        <actions>
            <name>Revenue_Date_Set</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Partner_Lifecycle__c</field>
            <operation>equals</operation>
            <value>Revenue Producing</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>email notification when an Account%27s business role is added or modified</fullName>
        <actions>
            <name>Notification_to_Icare</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Ability for the iCare team and Julie&apos;s team to automatically receive 1 email notification when an Account(with a record type of Customer/Prospect)&apos;s Business Partner Role is added/modified</description>
        <formula>AND(OR( RecordType.Name = $Label.AccountCustomerRecordType, RecordType.Name = $Label.AccountProsepectRecordType),  ISCHANGED(Partner_Type__c),  NOT(ISNEW() ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
