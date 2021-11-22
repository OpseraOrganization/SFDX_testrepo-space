<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CH_KB_Author_Notification_Approved</fullName>
        <description>CH KB Author Notification - Approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CH_EmailTemplates/CH_KB_Author_Email</template>
    </alerts>
    <alerts>
        <fullName>CH_KB_Author_Notification_Rejected</fullName>
        <description>CH KB Author Notification - Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CH_EmailTemplates/CH_KB_Author_Email_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>CH_Capture_Version_Creator</fullName>
        <description>It will Capture the user of version creation</description>
        <field>CH_Version_Created_By__c</field>
        <formula>$User.FirstName + &apos; &apos; + $User.LastName</formula>
        <name>Capture Version Creator</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CH_Deselect_Candidate_For_External</fullName>
        <field>CH_Candidate_for_External__c</field>
        <literalValue>0</literalValue>
        <name>Deselect Candidate For External</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CH_KB_UpdateValidationStatus</fullName>
        <field>ValidationStatus</field>
        <literalValue>Work In Progress</literalValue>
        <name>Update Validation Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CH_Set_Reviewer_to_Null</fullName>
        <field>CH_Reviewer__c</field>
        <name>Set Reviewer to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSP_Update_Validation_Status</fullName>
        <description>PSP Migration</description>
        <field>ValidationStatus</field>
        <literalValue>Internal Approved</literalValue>
        <name>PSP Update Validation Status Internal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_In_Approval_to_False</fullName>
        <field>CH_InApproval__c</field>
        <literalValue>0</literalValue>
        <name>Set In Approval to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_In_Approval_to_True</fullName>
        <field>CH_InApproval__c</field>
        <literalValue>1</literalValue>
        <name>Set In Approval to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Validation_Status_External</fullName>
        <description>PSP Migration - External</description>
        <field>ValidationStatus</field>
        <literalValue>External Approved</literalValue>
        <name>PSP Update Validation Status External</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CH_ApproverChecksMinorChangesFalse</fullName>
        <actions>
            <name>CH_DeselectComingfromApprovalProcess</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CH_UncheckMinorChangesCheckbox</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CH_Knowldege_Action_New</name>
            <type>KnowledgePublish</type>
        </actions>
        <active>true</active>
        <booleanFilter>((1 AND 2 AND 3 AND 4 ) OR (5 AND 6 AND 7 AND 8)) AND 9 AND 10</booleanFilter>
        <criteriaItems>
            <field>Knowledge__kav.ValidationStatus</field>
            <operation>equals</operation>
            <value>Internal Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Knowledge__kav.PublishStatus</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <criteriaItems>
            <field>Knowledge__kav.CH_Minor_changes__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Knowledge__kav.CH_Candidate_for_External__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Knowledge__kav.ValidationStatus</field>
            <operation>equals</operation>
            <value>External Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Knowledge__kav.PublishStatus</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <criteriaItems>
            <field>Knowledge__kav.CH_Candidate_for_External__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Knowledge__kav.CH_Minor_changes__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Knowledge__kav.CH_KnowledgeRecordTypeCheck__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Knowledge__kav.CH_ComingFromApprovalProcess__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CH_ApproverChecksMinorChangesTrue</fullName>
        <actions>
            <name>CH_DeselectComingfromApprovalProcess</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CH_UncheckMinorChangesCheckbox</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CH_Knowldege_Action</name>
            <type>KnowledgePublish</type>
        </actions>
        <active>true</active>
        <booleanFilter>((1 AND 2 AND 3 AND 4 ) OR (5 AND 6 AND 7 AND 8)) AND 9 AND 10</booleanFilter>
        <criteriaItems>
            <field>Knowledge__kav.ValidationStatus</field>
            <operation>equals</operation>
            <value>Internal Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Knowledge__kav.PublishStatus</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <criteriaItems>
            <field>Knowledge__kav.CH_Minor_changes__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Knowledge__kav.CH_Candidate_for_External__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Knowledge__kav.ValidationStatus</field>
            <operation>equals</operation>
            <value>External Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Knowledge__kav.PublishStatus</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <criteriaItems>
            <field>Knowledge__kav.CH_Candidate_for_External__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Knowledge__kav.CH_Minor_changes__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Knowledge__kav.CH_ComingFromApprovalProcess__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Knowledge__kav.CH_KnowledgeRecordTypeCheck__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When Approver unchecks external article will publish as new.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CH_ArchivedArticles</fullName>
        <actions>
            <name>CH_KB_UpdateValidationStatus</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CH_Set_Approver_to_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CH_Set_Publisher_to_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Knowledge__kav.PublishStatus</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <criteriaItems>
            <field>Knowledge__kav.ValidationStatus</field>
            <operation>equals</operation>
            <value>Internal Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Knowledge__kav.ValidationStatus</field>
            <operation>equals</operation>
            <value>External Approved</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Validation Status - External</fullName>
        <actions>
            <name>Update_Validation_Status_External</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CH_Knowldege_Action</name>
            <type>KnowledgePublish</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Knowledge__kav.CH_Candidate_for_External__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Knowledge__kav.ValidationStatus</field>
            <operation>equals</operation>
            <value>Work In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>Knowledge__kav.PublishStatus</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Data Loader Profile</value>
        </criteriaItems>
        <description>PSP Migration - External Article</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Validation Status - Internal</fullName>
        <actions>
            <name>PSP_Update_Validation_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CH_Knowldege_Action</name>
            <type>KnowledgePublish</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Knowledge__kav.ValidationStatus</field>
            <operation>equals</operation>
            <value>Work In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>Knowledge__kav.PublishStatus</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <criteriaItems>
            <field>Knowledge__kav.CH_Candidate_for_External__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Data Loader Profile</value>
        </criteriaItems>
        <description>PSP Migration - Internal Articles</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
