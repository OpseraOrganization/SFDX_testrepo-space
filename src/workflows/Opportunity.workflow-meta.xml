<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Pre_Opportunity_AM_Notification</fullName>
        <description>Pre-Opportunity AM Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Pre_Opportunity_Emails/Pre_Opportunity_AM_Notification</template>
    </alerts>
    <alerts>
        <fullName>Pre_Opportunity_CTHead_Notification</fullName>
        <description>Pre-Opportunity CTHead Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Pre_Opportunity_Emails/Pre_Opportunity_CTHead_Req_Notif</template>
    </alerts>
    <alerts>
        <fullName>Pre_Opportunity_Owner_Notification</fullName>
        <description>Pre-Opportunity Owner Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Pre_Opportunity_Emails/Pre_Opportunity_Owner_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_pricing_pricing</fullName>
        <ccEmails>heema.1.solanki@nokia.com</ccEmails>
        <ccEmails>Rahul.garje@nokia.com</ccEmails>
        <description>Send Email to pricing pricing</description>
        <protected>false</protected>
        <recipients>
            <recipient>Pricing Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Sent_Email_to_Pricing_Manager_when_PSP_gets_selected_at_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Stalling_Opp_Close</fullName>
        <description>Stalling Opp: Close</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ALL/Stalling_Opp_Close</template>
    </alerts>
    <fieldUpdates>
        <fullName>G3_Submission_dates_Update</fullName>
        <field>G3_Submission_Date__c</field>
        <formula>IF((ISPICKVAL(StageName ,&apos;Identify Opportunity&apos;)),NULL,
IF(AND(ISPICKVAL(StageName ,&apos;Develop Opportunity&apos;),ISPICKVAL(Phase_Status__c,&apos;Opportunity in Progress&apos;)),NULL,
IF( ISPICKVAL(Phase_Status__c,&apos;Submitted for G3 Approval&apos;), DATEVALUE(Now()),G3_Submission_Date__c )
)
)</formula>
        <name>G3 Submission dates Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>G4_Submission_dates_Update</fullName>
        <field>G4_Submission_Date__c</field>
        <formula>IF( ISPICKVAL(StageName ,&apos;Identify Opportunity&apos;),NULL, IF( ISPICKVAL(StageName ,&apos;Develop Opportunity&apos;),NULL,
IF(AND(ISPICKVAL(StageName ,&apos;Create Offer (Bid)&apos;),ISPICKVAL(Phase_Status__c,&apos;Offer in Progress&apos;)),NULL,
IF(ISPICKVAL(Phase_Status__c,&apos;Submitted for G4 Approval&apos;),DATEVALUE(NOW()),G4_Submission_Date__c
)
)
))</formula>
        <name>G4 Submission dates Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>G5_Submission_dates_Update</fullName>
        <field>G5_Submission_Date__c</field>
        <formula>IF( ISPICKVAL(StageName ,&apos;Identify Opportunity&apos;),NULL,
IF( ISPICKVAL(StageName ,&apos;Develop Opportunity&apos;),NULL,
IF((ISPICKVAL(StageName ,&apos;Create Offer (Bid)&apos;)),NULL,
IF(AND(ISPICKVAL(StageName ,&apos;Win the Case (Negotiate)&apos;),ISPICKVAL(Phase_Status__c,&apos;Offer Submitted to Customer (Manual)&apos;)),NULL,
IF(ISPICKVAL(Phase_Status__c,&apos;Submitted for G5 Approval&apos;),DATEVALUE(NOW()), G5_Submission_Date__c
)
)
)
)
)</formula>
        <name>G5 Submission dates Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NF_G3_Approval_Date_Update</fullName>
        <field>G3_Approval_Date__c</field>
        <formula>IF( ISPICKVAL(StageName ,&apos;Identify Opportunity&apos;),NULL, IF( ISPICKVAL(StageName ,&apos;Develop Opportunity&apos;),NULL,
G3_Approval_Date__c))</formula>
        <name>NF_G3 Approval Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NF_G4_Approval_Date_Update</fullName>
        <field>G4_Approval_Date__c</field>
        <formula>IF( ISPICKVAL(StageName ,&apos;Identify Opportunity&apos;),NULL, IF( ISPICKVAL(StageName ,&apos;Develop Opportunity&apos;),NULL,
IF(ISPICKVAL(StageName ,&apos;Create Offer (Bid)&apos;),NULL, G4_Approval_Date__c
)
))</formula>
        <name>NF_G4 Approval Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NF_G5_Approval_Date_Update</fullName>
        <field>G5_Approval_Date__c</field>
        <formula>IF( ISPICKVAL(StageName ,&apos;Identify Opportunity&apos;),NULL, IF( ISPICKVAL(StageName ,&apos;Develop Opportunity&apos;),NULL,
IF(ISPICKVAL(StageName ,&apos;Create Offer (Bid)&apos;),NULL,
IF(ISPICKVAL(StageName ,&apos;Win the Case (Negotiate)&apos;),NULL,
IF( AND(ApprovalStatusTechField__c=&apos;Approved G2,Approved G3,Approved G4,Approved G5&apos;,ISBLANK(G5_Approval_Date__c) ),NOW(), G5_Approval_Date__c
)
)
)
))</formula>
        <name>NF_Win Declaration Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NF_G5_Contract_Sign_Date</fullName>
        <field>G5_Contract_Approval_Date__c</field>
        <formula>IF(ISPICKVAL(StageName ,&apos;Identify Opportunity&apos;), NULL, 
			IF( ISPICKVAL(StageName ,&apos;Develop Opportunity&apos;),NULL, 
     IF( ISPICKVAL(StageName ,&apos;Create Offer (Bid)&apos;),NULL, 
        IF(ISPICKVAL(Phase_Status__c,&apos;Offer Submitted to Customer (Manual)&apos;),Null, 
           IF( AND( ISPICKVAL(StageName ,&apos;Handover (Prepare for Delivery)&apos;), NF_LoA_Bypass__c&gt;0,  ISPICKVAL(Blanket_Approval_Condition__c,&apos;&apos;) , ISBLANK(G5_Contract_Approval_Date__c) ) , NOW() ,   
             IF( AND( ISPICKVAL(StageName ,&apos;Handover (Prepare for Delivery)&apos;) ,  NOT(ISPICKVAL(Blanket_Approval_Condition__c,&apos;&apos;)) , ISBLANK(G5_Contract_Approval_Date__c) ) , Now() , G5_Contract_Approval_Date__c )
           ) 
        ) 
      )
			)
)</formula>
        <name>NF_G5 Contract Sign  Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSR_PO_Expected_Initial</fullName>
        <description>Setting the &quot;Initial PO Expected Date&quot; with the &quot;Date PO Expected / Contract Signed&quot; upon approval</description>
        <field>PSR_Initial_PO_Expected_Date__c</field>
        <formula>PSR_Date_PO_Expected__c</formula>
        <name>PSR_PO_Expected_Initial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stalling_Opportunity</fullName>
        <field>Stalling_Opportunity__c</field>
        <literalValue>0</literalValue>
        <name>Stalling Opportunity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stalling_Opportunity_false</fullName>
        <field>Stalling_Opportunity__c</field>
        <literalValue>0</literalValue>
        <name>Stalling Opportunity_False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Current_Status</fullName>
        <field>Approvals_Current_Status__c</field>
        <formula>&apos;Approved G4&apos;</formula>
        <name>Update Approval Current Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
