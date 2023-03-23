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
        <fullName>CH_DeselectComingfromApprovalProcess</fullName>
        <field>CH_ComingFromApprovalProcess__c</field>
        <literalValue>0</literalValue>
        <name>Deselect Coming from Approval Process</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
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
        <fullName>CH_IndicateArticleForwardedfromProcess</fullName>
        <description>Indicate that Article was forwarded from Process so that it is directly forwarded for external approval</description>
        <field>CH_ComingFromApprovalProcess__c</field>
        <literalValue>1</literalValue>
        <name>Indicate Article Forwarded from Process</name>
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
        <fullName>CH_Set_Approver_to_CurrentUser</fullName>
        <description>The approver field will capture the name of current approver</description>
        <field>CH_Approver__c</field>
        <formula>$User.FirstName + &apos; &apos; + $User.LastName</formula>
        <name>Set Approver to CurrentUser</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CH_Set_Approver_to_Null</fullName>
        <description>whenever the article enter into internal process approver field set to null</description>
        <field>CH_Approver__c</field>
        <name>Set Approver to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CH_Set_Assignee_to_Null</fullName>
        <description>Updating Assignee field as null</description>
        <field>CH_Reviewer__c</field>
        <name>Set Assignee to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CH_Set_Coming_From_Approval_Process</fullName>
        <field>CH_ComingFromApprovalProcess__c</field>
        <literalValue>1</literalValue>
        <name>Set Coming From Approval Process</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CH_Set_Customer_to_False</fullName>
        <description>Article is not visible for customer</description>
        <field>IsVisibleInCsp</field>
        <literalValue>0</literalValue>
        <name>Set Customer to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CH_Set_Customer_to_True</fullName>
        <description>Article is visible for customer</description>
        <field>IsVisibleInCsp</field>
        <literalValue>1</literalValue>
        <name>Set Customer to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CH_Set_External_Candidate_to_False</fullName>
        <description>External candidate field set to false</description>
        <field>CH_Candidate_for_External__c</field>
        <literalValue>0</literalValue>
        <name>Set External Candidate to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CH_Set_PublicknowledgeBase_to_False</fullName>
        <description>Article is visible only for internal users</description>
        <field>IsVisibleInPkb</field>
        <literalValue>0</literalValue>
        <name>Set PublicknowledgeBase to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CH_Set_PublicknowledgeBase_to_True</fullName>
        <description>Article is visible for everyone</description>
        <field>IsVisibleInPkb</field>
        <literalValue>1</literalValue>
        <name>Set PublicknowledgeBase to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CH_Set_Publisher_to_CurrentUser</fullName>
        <description>The publisher field will capture the name of current publisher</description>
        <field>CH_Publisher__c</field>
        <formula>$User.FirstName + &apos; &apos; + $User.LastName</formula>
        <name>Set Publisher to CurrentUser</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CH_Set_Publisher_to_Null</fullName>
        <description>whenever the article enter into internal process publisher field set to null</description>
        <field>CH_Publisher__c</field>
        <name>Set Publisher to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
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
        <fullName>CH_Set_Status_to_External_Approved</fullName>
        <description>If it is satisfied by the criteria Validation status set to external approved</description>
        <field>ValidationStatus</field>
        <literalValue>External Approved</literalValue>
        <name>Set Status to External Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CH_Set_Status_to_Internal_Approved</fullName>
        <description>If it is satisfied by the criteria Validation status set to internal approved</description>
        <field>ValidationStatus</field>
        <literalValue>Internal Approved</literalValue>
        <name>Set Status to Internal Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CH_Set_Status_to_Needs_Approver_Review</fullName>
        <description>In the Initial action article validation status set to needs approver review</description>
        <field>ValidationStatus</field>
        <literalValue>Needs Approver Review</literalValue>
        <name>Set Status to Needs Approver Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CH_Set_Status_to_Needs_Publisher_Review</fullName>
        <description>In the Initial action article validation status set to needs publisher review</description>
        <field>ValidationStatus</field>
        <literalValue>Needs Publisher Review</literalValue>
        <name>Set Status to Needs Publisher Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CH_Set_Status_to_Work_In_Progress</fullName>
        <description>If does not satisfy the criteria status set to work in progress</description>
        <field>ValidationStatus</field>
        <literalValue>Work In Progress</literalValue>
        <name>Set Status to Work In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CH_UncheckMinorChangesCheckbox</fullName>
        <field>CH_Minor_changes__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Minor Changes Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
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
    <knowledgePublishes>
        <fullName>All_other_category_Approval</fullName>
        <action>PublishAsNew</action>
        <label>All other category Approval</label>
        <language>en_US</language>
        <protected>false</protected>
    </knowledgePublishes>
    <knowledgePublishes>
        <fullName>CH_Knowldege_Action</fullName>
        <action>Publish</action>
        <description>Here the type of article action is publish</description>
        <label>Internal Knowldege Action with Publish</label>
        <language>en_US</language>
        <protected>false</protected>
    </knowledgePublishes>
    <knowledgePublishes>
        <fullName>CH_Knowldege_Action_New</fullName>
        <action>PublishAsNew</action>
        <description>Here the type of article action is publish	as a new</description>
        <label>Internal Knowldege Action with Publish as a New</label>
        <language>en_US</language>
        <protected>false</protected>
    </knowledgePublishes>
    <knowledgePublishes>
        <fullName>LOA_Article_Approval</fullName>
        <action>PublishAsNew</action>
        <label>LOA Article Approval</label>
        <language>en_US</language>
        <protected>false</protected>
    </knowledgePublishes>
    <knowledgePublishes>
        <fullName>OIF_Approval_step</fullName>
        <action>PublishAsNew</action>
        <label>OIF Approval step</label>
        <language>en_US</language>
        <protected>false</protected>
    </knowledgePublishes>
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
