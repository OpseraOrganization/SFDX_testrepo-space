<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CPQ_Send_Email_to_Submitted_for_Approval_Status_Change</fullName>
        <description>Send Email to Submitted for Approval Status Change</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/CPQ_EBG_Send_Email_to_Inform_about_Approval_Stage</template>
    </alerts>
    <alerts>
        <fullName>CPQ_Send_Email_to_Submitter_for_Rejected_Stage</fullName>
        <description>EBG_Send Email to Submitter for Rejected Stage</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/CPQ_EBG_Send_Email_to_Inform_about_Rejected_Stage</template>
    </alerts>
    <alerts>
        <fullName>CQ_SendNotificationToCQSender</fullName>
        <description>CQ_SendNotificationToCQSender</description>
        <protected>false</protected>
        <recipients>
            <field>CQ_Sender__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>sCPQ_CQ_Email_templates/CQ_FailedNotificationForEQuote</template>
    </alerts>
    <alerts>
        <fullName>DS_Email_Alert_for_Quote_Approved_Stage</fullName>
        <description>DS Email Alert for Quote Approved Stage</description>
        <protected>false</protected>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Send_Email_to_Account_Owner_for_Approved_Quote</template>
    </alerts>
    <alerts>
        <fullName>DS_Email_Alert_for_Quote_Draft_Stage</fullName>
        <description>DS Email Alert for Quote Draft Stage</description>
        <protected>false</protected>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Send_Email_to_Account_Owner_for_Draft_Quote</template>
    </alerts>
    <alerts>
        <fullName>Email_to_AM</fullName>
        <description>Email to AM</description>
        <protected>false</protected>
        <recipients>
            <field>NokiaCPQ_Account_Manager_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/NotifyQuoteAccountManager_Approval_Required</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_GDC_user_when_quote_is_publised</fullName>
        <ccEmails>logistics_sfr.gdc_portugal@nokia.com</ccEmails>
        <description>Notification to GDC user when quote is publised</description>
        <protected>false</protected>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/DS_Quote_Published_Notification_to_GDC</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_To_Partner_For_LEO_Quote</fullName>
        <ccEmails>heema.1.solanki@nokia.com</ccEmails>
        <ccEmails>Rahul.garje@nokia.com</ccEmails>
        <description>Send Email To Partner For LEO Quote</description>
        <protected>false</protected>
        <recipients>
            <field>NokiaCPQ_Partner_Sales_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Send_Email_to_Partner_to_Inform_about_his_certification</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_for_Recalled_Quotes</fullName>
        <ccEmails>rahul.garje@nokia.com</ccEmails>
        <description>Send Email for Recalled Quotes</description>
        <protected>false</protected>
        <recipients>
            <field>NokiaCPQ_Partner_Sales_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Send_Email_to_PSM_to_Inform_about_Recalled_Approval</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_PSM_for_Approval_Status_Change</fullName>
        <ccEmails>rahul.garje@nokia.com</ccEmails>
        <description>Send Email to PSM for Approval Status Change</description>
        <protected>false</protected>
        <recipients>
            <field>NokiaCPQ_Partner_Sales_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/CPQ_Approval_Status_Change_to_PSM</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_PSM_for_Rejected_Approval_Stage</fullName>
        <ccEmails>rahul.garje@nokia.com</ccEmails>
        <description>Send Email to PSM for Rejected Approval Stage</description>
        <protected>false</protected>
        <recipients>
            <field>NokiaCPQ_Partner_Sales_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Send_Email_to_PSM_to_Inform_about_Rejected_Stage</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_Stage_Update</fullName>
        <field>Apttus_Proposal__Approval_Stage__c</field>
        <literalValue>Accepted</literalValue>
        <name>Approval Stage Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Stage_Update_For_Recall</fullName>
        <field>Apttus_Proposal__Approval_Stage__c</field>
        <literalValue>Requires Approval</literalValue>
        <name>Approval Stage Update For Recall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Blank_Submitted_date</fullName>
        <description>When quote is cloned then submitted date should be blank.</description>
        <field>Submitted_Date__c</field>
        <name>Blank Submitted date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPQ_Application_Code_update</fullName>
        <description>Set the value of Application Code to ZZ, based on Master quote field for QTC-NCQ quote</description>
        <field>CPQ_Application_Code__c</field>
        <literalValue>ZZ</literalValue>
        <name>Application Code update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPQ_DraftStatus</fullName>
        <field>Apttus_Proposal__Approval_Stage__c</field>
        <literalValue>Draft</literalValue>
        <name>CPQ_DraftStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_record_type_to_editable</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Contracted_Quote</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change record type to editable</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_record_type_to_read_only</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CQ_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change record type to read only</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DS_Update_End_Date</fullName>
        <field>Contract_End_Date__c</field>
        <formula>ADDMONTHS( Contract_Start_Date__c , Terms_Month__c )</formula>
        <name>DS Update End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DS_Update_StartDate_Based_OnEndDateAndTe</fullName>
        <field>Contract_Start_Date__c</field>
        <formula>ADDMONTHS(Contract_End_Date__c,-Terms_Month__c)</formula>
        <name>DS_Update_StartDate_Based_OnEndDateAndTe</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DS_Update_Term_In_Month</fullName>
        <field>Terms_Month__c</field>
        <formula>12</formula>
        <name>DS_Update_Term_In_Month</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DS_Update_Terms</fullName>
        <field>Terms_Month__c</field>
        <formula>IF(MOD(Contract_End_Date__c- Contract_Start_Date__c,30) =0 , (Contract_End_Date__c- Contract_Start_Date__c) /30 , 

IF(MOD(Contract_End_Date__c- Contract_Start_Date__c,30) &gt;=15, FLOOR(((Contract_End_Date__c- Contract_Start_Date__c) /30)) +1, 

Floor( (Contract_End_Date__c- Contract_Start_Date__c)/ 30 )))</formula>
        <name>DS Update Terms</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DS_Update_contract_start_date_and_Term</fullName>
        <field>Contract_Start_Date__c</field>
        <formula>TODAY()</formula>
        <name>DS Update contract start date and Term</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Make_NCQ_Quote_Read_Only</fullName>
        <description>Change page layout for NCQ quote upon Approval Stage = Closed(Won) or Closed(not won), via record type change</description>
        <field>RecordTypeId</field>
        <lookupValue>NCQ_ReadOnly_Recordtype</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Make NCQ Quote Read Only</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Make_New_CQ_Quote_Read_Only</fullName>
        <description>Change page layout for New CQ quote upon Approval Stage = Closed(Won) or Closed(not won), via record type change</description>
        <field>RecordTypeId</field>
        <lookupValue>CPQ_QTC_CQ_Quote_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Make New CQ Quote Read Only</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NCQ_Update_Approval_Stage_to_Approved</fullName>
        <field>Apttus_Proposal__Approval_Stage__c</field>
        <literalValue>Approved</literalValue>
        <name>NCQ Update Approval Stage to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Need_Reprice_update</fullName>
        <field>NokiaCPQ_Needs_Reprice__c</field>
        <literalValue>1</literalValue>
        <name>Need Reprice update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nokia_CPQ_update_shipping_location</fullName>
        <field>NokiaCPQ_Direct_Shipping_Location__c</field>
        <formula>TEXT( Apttus_Proposal__Opportunity__r.Account.Country__c )</formula>
        <name>Nokia CPQ update shipping location</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Status_field_update</fullName>
        <field>Quote_Status__c</field>
        <literalValue>Configure</literalValue>
        <name>Quote Status field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Status_update2</fullName>
        <field>Quote_Status__c</field>
        <literalValue>Order</literalValue>
        <name>Quote Status update2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Status_update3</fullName>
        <field>Quote_Status__c</field>
        <literalValue>Accept</literalValue>
        <name>Quote Status update3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Update</fullName>
        <field>Quote_Status__c</field>
        <literalValue>Validate</literalValue>
        <name>Quote Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_change_to_Quote_Read_Only</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SWx_CCRE_Proposal_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type change to Quote-Read Only</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>NokiaCPQ_Draft_Quote</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_LoA_Status_To_Rejected</fullName>
        <field>LOA_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Set LoA Status To Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unchecked_Indirect_Approval_Required</fullName>
        <field>Indirect_Approval_Required__c</field>
        <literalValue>0</literalValue>
        <name>Unchecked Indirect Approval Required</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CQ_Close_date_blank</fullName>
        <field>CQ_Close_Date__c</field>
        <name>Update CQ Close date blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Close_Date</fullName>
        <description>Update Close date once the status has been changed to Closed(Won) or Closed(Not Won)</description>
        <field>CQ_Close_Date__c</field>
        <formula>Today()</formula>
        <name>Update Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contract_End_Date</fullName>
        <field>Contract_End_Date__c</field>
        <formula>ADDMONTHS(Contract_Start_Date__c ,Terms_Month__c)</formula>
        <name>DS Update Contract End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_isRebid_status_to_false</fullName>
        <description>Update the rebid status to false again</description>
        <field>CQ_isRebid_Done__c</field>
        <literalValue>0</literalValue>
        <name>Update isRebid status to false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_IsCQ</fullName>
        <field>isCQ__c</field>
        <literalValue>1</literalValue>
        <name>update IsCQ</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
