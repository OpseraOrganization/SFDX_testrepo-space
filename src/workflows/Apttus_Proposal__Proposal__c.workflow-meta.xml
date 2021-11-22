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
    <rules>
        <fullName>Application_Code_setup</fullName>
        <actions>
            <name>CPQ_Application_Code_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.CQ_Master_Quote__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set the value of Application Code based on Master quote field for QTC-NCQ quote</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Auto update the shipping location on quote</fullName>
        <actions>
            <name>Nokia_CPQ_update_shipping_location</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Quote_Type__c</field>
            <operation>equals</operation>
            <value>Direct CPQ</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CCRE%2FCXM_Change Quote Record type when Published</fullName>
        <actions>
            <name>Change_Quote_Record_type_when_Published</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Apttus_Proposal__Approval_Stage__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>SWx/CCRE Proposal</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPQ_Approval_To_Draft</fullName>
        <actions>
            <name>CPQ_DraftStatus</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL( NokiaCPQ_Portfolio__c , &quot;QTC&quot;) , OR( ISBLANK(TEXT(Apttus_Proposal__Approval_Stage__c)), ISNULL(TEXT(Apttus_Proposal__Approval_Stage__c))))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPQ_EBG Send Email to Inform about Rejected Stage</fullName>
        <actions>
            <name>CPQ_Send_Email_to_Submitter_for_Rejected_Stage</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Apttus_Proposal__Approval_Stage__c),ISPICKVAL(Apttus_QPApprov__Approval_Status__c,&quot;Rejected&quot;),Quote_Type__c = &quot;Direct CPQ&quot;, ISPICKVAL(NokiaCPQ_Portfolio__c, &quot;IP Routing&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPQ_EBG_Notification for Quote Approval Status</fullName>
        <actions>
            <name>CPQ_Send_Email_to_Submitted_for_Approval_Status_Change</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED( Apttus_Proposal__Approval_Stage__c ),OR(AND(ISPICKVAL(Apttus_Proposal__Approval_Stage__c ,&quot;Approval Required&quot;),NOT(ISPICKVAL(Apttus_QPApprov__Approval_Status__c, &quot;Rejected&quot;))),ISPICKVAL( Apttus_Proposal__Approval_Stage__c , &quot;Approved&quot;),ISPICKVAL( Apttus_Proposal__Approval_Stage__c , &quot;Rejected&quot;),ISPICKVAL( Apttus_QPApprov__Approval_Status__c, &quot;Expired&quot;)),Quote_Type__c  = &quot;Direct CPQ&quot;, ISPICKVAL(NokiaCPQ_Portfolio__c, &quot;IP Routing&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CQ - Update isRebid status to false after rebid</fullName>
        <actions>
            <name>Update_isRebid_status_to_false</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.CQ_isRebid_Done__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Update isRebid status to false, once rebid is done via quick action</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CQ Change record type to editable</fullName>
        <actions>
            <name>Change_record_type_to_editable</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_CQ_Close_date_blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( RecordType.DeveloperName = &quot;CQ_Read_Only&quot;,   OR(ISPICKVAL( PRIORVALUE( Apttus_Proposal__Approval_Stage__c ), &quot;Closed(not won)&quot;),       ISPICKVAL( PRIORVALUE( Apttus_Proposal__Approval_Stage__c ) , &quot;Closed (Won)&quot;) ),   OR(ISPICKVAL( Apttus_Proposal__Approval_Stage__c , &quot;Draft&quot;),      ISPICKVAL( Apttus_Proposal__Approval_Stage__c , &quot;Approved&quot;),      ISPICKVAL( Apttus_Proposal__Approval_Stage__c , &quot;Accepted&quot;),      ISPICKVAL( Apttus_Proposal__Approval_Stage__c , &quot;Rebid&quot;)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CQ change to Read only</fullName>
        <actions>
            <name>Change_record_type_to_read_only</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(RecordType.DeveloperName = &quot;Contracted_Quote&quot;,     OR(ISPICKVAL( PRIORVALUE(Apttus_Proposal__Approval_Stage__c ), &quot;Draft&quot;),        ISPICKVAL( PRIORVALUE(Apttus_Proposal__Approval_Stage__c ) ,&quot;Approved&quot;),        ISPICKVAL( PRIORVALUE(Apttus_Proposal__Approval_Stage__c ) ,&quot;Accepted&quot;),        ISPICKVAL( PRIORVALUE(Apttus_Proposal__Approval_Stage__c ),&quot;Rebid&quot;)),     OR(ISPICKVAL(Apttus_Proposal__Approval_Stage__c, &apos;Closed (Won)&apos;),        ISPICKVAL(Apttus_Proposal__Approval_Stage__c, &apos;Closed(not won)&apos;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CQ_ApprovalStage_Accepted</fullName>
        <actions>
            <name>Approval_Stage_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>The Approval Stage must be changed to Accepted State if Submitted to Customer date is populated.</description>
        <formula>AND(RecordType.DeveloperName=&quot;Contracted_Quote&quot;,ISBLANK( Surround_Priced_Account__c ),NOT(ISPICKVAL( Apttus_Proposal__Approval_Stage__c ,&apos;Rebid&apos;)),OR( ISPICKVAL( Apttus_Proposal__Approval_Stage__c , &apos;Draft&apos;), ISPICKVAL(Apttus_Proposal__Approval_Stage__c, &apos;Approved&apos;)  ), NOT( CQ_eQuote__c ),NOT(ISBLANK( CQ_Submitted_to_Customer_Date__c )),ISCHANGED(CQ_Submitted_to_Customer_Date__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CQ_SendNotificationUponeQuoteFailure</fullName>
        <actions>
            <name>CQ_SendNotificationToCQSender</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.CQ_eQuote_Status__c</field>
            <operation>equals</operation>
            <value>Failure</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.CQ_eQuote__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Send email notification when eQuote status set to Failure.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Change Quote Record type when Accepted</fullName>
        <actions>
            <name>Record_Type_change_to_Quote_Read_Only</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>4 AND (1 OR 2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Apttus_Proposal__Approval_Stage__c</field>
            <operation>equals</operation>
            <value>Accepted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Apttus_Proposal__Approval_Stage__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Apttus_Proposal__Approval_Stage__c</field>
            <operation>equals</operation>
            <value>Rework</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>SWx/CCRE Proposal</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Change Quote Status from %27Price%27 to %27Validate%27</fullName>
        <actions>
            <name>Quote_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Change the Quote Status of Quote from &apos;Price&apos; to &apos;Validate&apos;.</description>
        <formula>Quote_Type__c = $Label.DirectCPQ &amp;&amp; Roll_Up_Of_Proposal_Line_Item__c &gt;0</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Change Quote status from %27Accept%27 to %27Order%27</fullName>
        <actions>
            <name>Quote_Status_update2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Change Quote status of quote from &apos;Accept&apos; to &apos;Order&apos;</description>
        <formula>AND(Quote_Type__c = $Label.DirectCPQ, AND( ISPICKVAL(Quote_Status__c, &apos;Accept&apos;) ,ISPICKVAL(Apttus_Proposal__Approval_Stage__c, &apos;Accepted&apos;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Quote status from %27Submit%27 to %27Accept%27</fullName>
        <actions>
            <name>Quote_Status_update3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Change Quote status of quote from &apos;Submit&apos; to &apos;Accept&apos;</description>
        <formula>AND(Quote_Type__c = $Label.DirectCPQ,AND( NOT( ISBLANK(Submitted_Date__c) ), ISPICKVAL(Quote_Status__c,&apos;Submit&apos;)  ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change the Approved Stage while recall the Approval Process</fullName>
        <actions>
            <name>Send_Email_for_Recalled_Quotes</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Approval_Stage_Update_For_Recall</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Record_type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Unchecked_Indirect_Approval_Required</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Apttus_QPApprov__Approval_Status__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Quote_Type__c</field>
            <operation>equals</operation>
            <value>Indirect CPQ</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Apttus_Proposal__Approval_Stage__c</field>
            <operation>equals</operation>
            <value>In Review</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DS Check if Contract End Date is blank</fullName>
        <actions>
            <name>Update_Contract_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( ISNULL(Contract_End_Date__c), NOT(ISNULL(Contract_Start_Date__c )), OR(RecordType.Name = &apos;SWx/CCRE Proposal&apos;, RecordType.Name = &apos;SWx/CCRE Proposal Read Only&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DS Check if Contract End Date is not Blank</fullName>
        <actions>
            <name>DS_Update_Terms</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( OR( 	AND( 		ISNEW(), 		NOT(ISNULL(Contract_Start_Date__c)), 		NOT(ISNULL(Contract_End_Date__c)) 	), 	AND( 		OR( 			ISCHANGED(Contract_End_Date__c ), 			ISCHANGED(Contract_Start_Date__c ), 			ISBLANK(Terms_Month__c) 		), 		NOT(ISNULL(Contract_Start_Date__c)), 		NOT(ISNULL(Contract_End_Date__c)))  ), OR( RecordType.Name = &apos;SWx/CCRE Proposal&apos;, RecordType.Name = &apos;SWx/CCRE Proposal Read Only&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DS Check if Terms has changed</fullName>
        <actions>
            <name>DS_Update_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED(Terms_Month__c), NOT(ISCHANGED(Contract_End_Date__c)), NOT(ISBLANK(Terms_Month__c )), OR( RecordType.Name = &apos;SWx/CCRE Proposal&apos;, RecordType.Name = &apos;SWx/CCRE Proposal Read Only&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DS Send Email Alert To AM when Quote is in Draft</fullName>
        <actions>
            <name>DS_Email_Alert_for_Quote_Draft_Stage</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Apttus_Proposal__Approval_Stage__c</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <description>DS Send Email Alert To AM when Quote is in Draft</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DS Sent Email To AM when Quote is in Approved</fullName>
        <actions>
            <name>DS_Email_Alert_for_Quote_Approved_Stage</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Apttus_Proposal__Approval_Stage__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DS_Change Quote Record type when Accepted For Customer</fullName>
        <actions>
            <name>RecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>4 AND (1 OR 2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Quote_Stage__c</field>
            <operation>equals</operation>
            <value>Accepted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Quote_Stage__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Quote_Stage__c</field>
            <operation>equals</operation>
            <value>Withdrawn</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>SWx/CCRE Proposal</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DS_Populate Quote Start Date</fullName>
        <actions>
            <name>DS_Update_Term_In_Month</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>DS_Update_contract_start_date_and_Term</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule is responsible for populating the Contract start date and Term when Quote is Published and if the contract start date is empty</description>
        <formula>AND( ISBLANK(Contract_Start_Date__c), ISPICKVAL(Apttus_Proposal__Approval_Stage__c, &apos;Approved&apos;), ISCHANGED(Apttus_Proposal__Approval_Stage__c), OR(RecordType.Name = &apos;SWx/CCRE Proposal&apos;, RecordType.Name = &apos;SWx/CCRE Proposal Read Only&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DS_Quote_Published_Email_Notification</fullName>
        <actions>
            <name>Notification_to_GDC_user_when_quote_is_publised</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Quote_Stage__c</field>
            <operation>equals</operation>
            <value>Published</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.NokiaCPQ_Proposal_Id__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>SWx/CCRE Proposal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.NokiaCPQ_Opportunity_Account_Formula__c</field>
            <operation>contains</operation>
            <value>Société Française du Radiotéléphone</value>
        </criteriaItems>
        <description>When Quote is published, send notification to GDC user</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DS_StartDate Calculation on Term And End Date</fullName>
        <actions>
            <name>DS_Update_StartDate_Based_OnEndDateAndTe</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( ISBLANK(Contract_Start_Date__c), ISCHANGED(Contract_Start_Date__c), NOT(ISBLANK(Contract_End_Date__c)), NOT(ISBLANK(Terms_Month__c)), OR(RecordType.Name = &apos;SWx/CCRE Proposal&apos;, RecordType.Name = &apos;SWx/CCRE Proposal Read Only&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DirectQuoteStatusOnClone</fullName>
        <actions>
            <name>Blank_Submitted_date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Quote_Status_field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISCLONE() &amp;&amp;  Quote_Type__c = $Label.DirectCPQ &amp;&amp; ISBLANK(SWx_Upsell_Proposal__c) &amp;&amp; OR(  NOT(ISPICKVAL(Quote_Status__c,&apos;Configure&apos;)),  Submitted_Date__c != null )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NCQ change to Read only</fullName>
        <actions>
            <name>Make_NCQ_Quote_Read_Only</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Change page layout for NCQ quote upon Approval Stage = Closed(Won) or Closed(not won)</description>
        <formula>AND( CPQ_NCQ_Check__c , OR(ISPICKVAL( PRIORVALUE(Apttus_Proposal__Approval_Stage__c ), &quot;Draft&quot;), ISPICKVAL( PRIORVALUE(Apttus_Proposal__Approval_Stage__c ) ,&quot;Approved&quot;), ISPICKVAL( PRIORVALUE(Apttus_Proposal__Approval_Stage__c ) ,&quot;Accepted&quot;), ISPICKVAL( PRIORVALUE(Apttus_Proposal__Approval_Stage__c ),&quot;Rebid&quot;)), OR(ISPICKVAL(Apttus_Proposal__Approval_Stage__c, &apos;Closed (Won)&apos;), ISPICKVAL(Apttus_Proposal__Approval_Stage__c, &apos;Closed(not won)&apos;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NCQ-Change the Approval Stage to Approved upon document generation</fullName>
        <actions>
            <name>NCQ_Update_Approval_Stage_to_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Apttus_Proposal__Approval_Stage__c</field>
            <operation>equals</operation>
            <value>Generated</value>
        </criteriaItems>
        <description>NCQ-Change the Approval Stage to Approved upon document generation</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Needs Reprice is True</fullName>
        <actions>
            <name>Need_Reprice_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Req 6165: Needs Reprice should be true if Maintenance type OR Maintenance number of years.</description>
        <formula>AND( NOT(ISNEW()),  Quote_Type__c  = &apos;Direct CPQ&apos;,  ISPICKVAL(NokiaCPQ_Portfolio__c  , &apos;Airscale Wifi&apos;), OR(  ISCHANGED( NokiaCPQ_Maintenance_Type__c ) ,  ISCHANGED( NokiaCPQ_No_of_Years__c )  )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New CQ change to Read only</fullName>
        <actions>
            <name>Make_New_CQ_Quote_Read_Only</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Change page layout for CQ quote upon Approval Stage = Closed(Won) or Closed(not won)</description>
        <formula>AND( CPQ_CQ_Check__c , OR(ISPICKVAL( PRIORVALUE(Apttus_Proposal__Approval_Stage__c ), &quot;Draft&quot;), ISPICKVAL( PRIORVALUE(Apttus_Proposal__Approval_Stage__c ) ,&quot;Approved&quot;), ISPICKVAL( PRIORVALUE(Apttus_Proposal__Approval_Stage__c ) ,&quot;Accepted&quot;), ISPICKVAL( PRIORVALUE(Apttus_Proposal__Approval_Stage__c ),&quot;Rebid&quot;)), OR(ISPICKVAL(Apttus_Proposal__Approval_Stage__c, &apos;Closed (Won)&apos;), ISPICKVAL(Apttus_Proposal__Approval_Stage__c, &apos;Closed(not won)&apos;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notification for PSM for Quote Approval Status</fullName>
        <actions>
            <name>Send_Email_to_PSM_for_Approval_Status_Change</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED( Apttus_Proposal__Approval_Stage__c ),OR(AND(ISPICKVAL(Apttus_Proposal__Approval_Stage__c ,&quot;Requires Approval&quot;),NOT(ISPICKVAL(Apttus_QPApprov__Approval_Status__c, &quot;Rejected&quot;))),ISPICKVAL( Apttus_Proposal__Approval_Stage__c , &quot;Approved&quot;),ISPICKVAL( Apttus_Proposal__Approval_Stage__c , &quot;Rejected&quot;),ISPICKVAL( Apttus_Proposal__Approval_Stage__c , &quot;In Review&quot;)),Quote_Type__c  = &quot;Indirect CPQ&quot;,    NOT(ISNULL(NokiaCPQ_Partner_Sales_Manager__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notification to AM- Approval Required</fullName>
        <actions>
            <name>Email_to_AM</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 3) AND 2</booleanFilter>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Apttus_Proposal__Approval_Stage__c</field>
            <operation>equals</operation>
            <value>Requires Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.NokiaCPQ_Portfolio__c</field>
            <operation>equals</operation>
            <value>Modular Private Wireless Solution</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Apttus_Proposal__Approval_Stage__c</field>
            <operation>equals</operation>
            <value>In Review</value>
        </criteriaItems>
        <description>For REQ: 7135 Testing workflow created</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Email Notification when Contract already in Place</fullName>
        <actions>
            <name>Send_Email_to_owner_s_Manager</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>NokiaCPQ_Partner_Sales_Manager__r.Email &lt;&gt; Owner:User.Email  &amp;&amp; (TEXT( NokiaCPQ_Existing_IONMaint_Contract__c )=&apos;Yes&apos;)  &amp;&amp; ((( NokiaCPQ_Quote_CAD__c = 0 || NokiaCPQ_Quote_CAD__c &lt; $Setup.NokiaCPQ_Discount_Threshold__c.NokiaCPQ_Approved_Amount_Threshold__c ) &amp;&amp; TEXT(Apttus_Proposal__Approval_Stage__c) = &apos;Approved&apos;) || TEXT(Apttus_Proposal__Approval_Stage__c) = &apos;In Review&apos;) &amp;&amp; Quote_Type__c = $Label.IndirectCPQ</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Email to PSM to Inform about Rejected Stage</fullName>
        <actions>
            <name>Send_Email_to_PSM_for_Rejected_Approval_Stage</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Apttus_Proposal__Approval_Stage__c),ISPICKVAL(Apttus_QPApprov__Approval_Status__c,&quot;Rejected&quot;),Quote_Type__c = &quot;Indirect CPQ&quot;,NOT(ISNULL(NokiaCPQ_Partner_Sales_Manager__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Mail To Partner User For LEO Quote Certification</fullName>
        <actions>
            <name>Send_Email_To_Partner_For_LEO_Quote</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.NokiaCPQ_LEO_Discount__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set_LoAStatus_to_Rejected_when_Quote_is_Rejected</fullName>
        <actions>
            <name>Set_LoA_Status_To_Rejected</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Apttus_Proposal__Approval_Stage__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <description>Whenever the Approval Stage of a quote is set to &apos;Rejected&apos; manually by a user then set the LoA Status = &apos;Rejected&apos; also</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update IsCQ on quote on creation</fullName>
        <actions>
            <name>update_IsCQ</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Contracted Quote</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Needs Reprice When Maintenance Changed</fullName>
        <actions>
            <name>Needs_Reprice_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>(  (NokiaCPQ_Net_Amount_Quote__c &gt; 0 &amp;&amp;  (ISCHANGED( NokiaCPQ_Existing_IONMaint_Contract__c) ||  ISCHANGED( NokiaCPQ_SSP_Level__c) ||   ISCHANGED( NokiaCPQ_SRS_Level__c) ||   ISCHANGED(NokiaCPQ_No_of_Years__c) ||  ISCHANGED(NokiaCPQ_Maintenance_Type__c) ||  ISCHANGED( Maintenance_Y1__c) ||  ISCHANGED( Maintenance_Y2__c) ||  ISCHANGED( SSP__c	) ||  ISCHANGED( SRS__c)   ) ) &amp;&amp; Quote_Type__c = $Label.IndirectCPQ ) || ((NokiaCPQ_Total_CNP__c&gt; 0) &amp;&amp; (Quote_Type__c = $Label.DirectCPQ) &amp;&amp; (ISCHANGED(Exchange_Rate__c) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
