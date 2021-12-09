<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>CPQ_EBG Notifiication for Approval Request Comments</fullName>
        <actions>
            <name>CPQ_EBG_Add_Comment_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(Apttus_QPApprov__ProposalId__r.Quote_Type__c  = &quot;Direct CPQ&quot;,  ISPICKVAL(Apttus_QPApprov__ProposalId__r.NokiaCPQ_Portfolio__c, &quot;IP Routing&quot;),NOT(ISBLANK(Apttus_Approval__Approver_Comments__c)),Apttus_Approval__Approver_Comments__c  &lt;&gt; &apos;For system use only. No action needed&apos;, NOT( CONTAINS(Apttus_Approval__Approver_Comments__c, &apos;Recalled&apos;)),  NOT(ISBLANK( Apttus_Approval__Assigned_To_Name__c )))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NF_G3 Approvers Remainder</fullName>
        <active>false</active>
        <formula>AND( $User.ProfileId != $Label.Data_Loader_Profile_Id,    OR(  ISPICKVAL(Apttus_Approval__Approval_Status__c ,&apos;Assigned&apos;),  ISPICKVAL(Apttus_Approval__Approval_Status__c ,&apos;Reassigned&apos;)  ),  OR(  CONTAINS(Apttus_Approval__Step_Name__c,&apos;G3&apos;), CONTAINS(Apttus_Approval__Step_Name__c,&apos;Gate 3&apos;) ), NOT(CONTAINS(Apttus_Approval__Step_Name__c,&apos;Bypass&apos;)),   NF_Remaindercount__c=1      )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>NF_G3_Remainder_Notification</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>NF_G3_Reminder_Count</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>NF_G3_Tech_Filed_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Apttus_Approval__Approval_Request__c.ApprovalDateTechField__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>NF_G3 Validator Reminder</fullName>
        <active>false</active>
        <formula>AND( $User.ProfileId != $Label.Data_Loader_Profile_Id,    ISPICKVAL(Apttus_Approval__Approval_Status__c ,&apos;Notified&apos;), CONTAINS( NF_Assignee_Type__c,&apos;Validator&apos;),    OR(  CONTAINS(Apttus_Approval__Step_Name__c,&apos;G3&apos;), CONTAINS(Apttus_Approval__Step_Name__c,&apos;Gate 3&apos;) ),   NOT(CONTAINS(Apttus_Approval__Step_Name__c,&apos;Bypass&apos;)), NF_Remaindercount__c=1, ISPICKVAL(Validator_Status__c ,&apos;&apos;),  ISBLANK( Tech_Status__c )    )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>NF_G3_Validator_Remind_Email</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>NF_G3_Validate_Tech_Filed_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>NF_G3_Validator_Remind_Count</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Apttus_Approval__Approval_Request__c.ApprovalDateTechField__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>NF_G4 Approvers Remainder</fullName>
        <active>false</active>
        <formula>AND( $User.ProfileId != $Label.Data_Loader_Profile_Id,  OR(  ISPICKVAL(Apttus_Approval__Approval_Status__c ,&apos;Assigned&apos;),  ISPICKVAL(Apttus_Approval__Approval_Status__c ,&apos;Reassigned&apos;)  ),    OR(  CONTAINS(Apttus_Approval__Step_Name__c,&apos;G4&apos;), CONTAINS(Apttus_Approval__Step_Name__c,&apos;Gate 4&apos;) ), NOT(CONTAINS(Apttus_Approval__Step_Name__c,&apos;Bypass&apos;)), NF_Remaindercount__c&gt;=1    )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>NF_G4_Remainder_Notification</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>NF_G4_Remind_Count</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>NF_G4_Tech_Field_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Apttus_Approval__Approval_Request__c.ApprovalDateTechField__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>NF_G4 Validator Reminder</fullName>
        <active>false</active>
        <formula>AND( $User.ProfileId != $Label.Data_Loader_Profile_Id,    ISPICKVAL(Apttus_Approval__Approval_Status__c ,&apos;Notified&apos;), CONTAINS( NF_Assignee_Type__c,&apos;Validator&apos;),    OR(  CONTAINS(Apttus_Approval__Step_Name__c,&apos;G4&apos;), CONTAINS(Apttus_Approval__Step_Name__c,&apos;Gate 4&apos;) ),   NOT(CONTAINS(Apttus_Approval__Step_Name__c,&apos;Bypass&apos;)), NF_Remaindercount__c&gt;=1, ISPICKVAL(Validator_Status__c ,&apos;&apos;),  ISBLANK( Tech_Status__c )    )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>NF_G4_Validator_Remind_Email</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>NF_G4_Validate_Tech_Filed_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>NF_G4_Validator_Remind_Count</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Apttus_Approval__Approval_Request__c.ApprovalDateTechField__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>NF_G5 Approvers Remainder</fullName>
        <active>false</active>
        <formula>AND(  	$User.ProfileId != $Label.Data_Loader_Profile_Id,  	OR(  		ISPICKVAL(Apttus_Approval__Approval_Status__c ,&apos;Assigned&apos;),  		ISPICKVAL(Apttus_Approval__Approval_Status__c ,&apos;Reassigned&apos;) 	),  	OR( 		CONTAINS(Apttus_Approval__Step_Name__c,&apos;G5&apos;),  		CONTAINS(Apttus_Approval__Step_Name__c,&apos;Gate 5&apos;)  	),  	CONTAINS( NF_Assignee_Type__c,&apos;Approver&apos;),  	NOT(CONTAINS(Apttus_Approval__Step_Name__c,&apos;Bypass&apos;)), NF_Remaindercount__c&gt;=1  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>NF_G5_Remainder_Email</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>NF_G5_Reminder_Count</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>NF_G5_Tech_Field_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Apttus_Approval__Approval_Request__c.ApprovalDateTechField__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>NF_G5 Validator Reminder</fullName>
        <active>false</active>
        <formula>AND( $User.ProfileId != $Label.Data_Loader_Profile_Id,    ISPICKVAL(Apttus_Approval__Approval_Status__c ,&apos;Notified&apos;), CONTAINS( NF_Assignee_Type__c,&apos;Validator&apos;),    OR(  CONTAINS(Apttus_Approval__Step_Name__c,&apos;G5&apos;), CONTAINS(Apttus_Approval__Step_Name__c,&apos;Gate 5&apos;) ),   NOT(CONTAINS(Apttus_Approval__Step_Name__c,&apos;Bypass&apos;)), NF_Remaindercount__c&gt;=1 , ISPICKVAL(Validator_Status__c ,&apos;&apos;) ,  ISBLANK( Tech_Status__c )   )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>NF_G5_Validator_Remind_Email</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>NF_G5_Validate_Tech_Filed_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>NF_G5_Validator_Remind_Count</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Apttus_Approval__Approval_Request__c.ApprovalDateTechField__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>NF_RejectPendingLongApprovals</fullName>
        <active>false</active>
        <description>Used to reject pending approvals for more than 6 months.   (workflow rule did not work correctly.  deactivated in QCRM and Prod Sep 22 2020; ksiler)</description>
        <formula>AND($User.ProfileId != $Label.Data_Loader_Profile_Id, OR( ISPICKVAL( Apttus_Approval__Approval_Status__c , &apos;Assigned&apos;), AND( NF_Assignee_Type__c = &apos;Validator&apos;, ISPICKVAL( Apttus_Approval__Approval_Status__c , &apos;Notified&apos;), ISBLANK(Apttus_Approval__Approver_Comments__c) ) ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>NF_FU_RejectApprovalStatus</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Apttus_Approval__Approval_Request__c.CreatedDate</offsetFromField>
            <timeLength>180</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>NF_StakeHolder Status Update</fullName>
        <actions>
            <name>NF_Satkeholder_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  CONTAINS(NF_Assignee_Type__c, &apos;Stakeholder for Information&apos;) ,  $Profile.Name&lt;&gt; $Label.Data_Loader_Profile_Name,  Apttus_Approval__Notify_Only__c=False   )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NF_StakeHolder Status Update to Notify</fullName>
        <actions>
            <name>NF_Status_Updated_to_Notify</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  	CONTAINS(NF_Assignee_Type__c, &apos;Stakeholder for Information&apos;) ,  	$Profile.Name&lt;&gt; $Label.Data_Loader_Profile_Name,  	NOT(ISPICKVAL(Apttus_Approval__Approval_Status__c,&apos;Cancelled&apos;)),  	OR(  		AND(  			NOT(ISPICKVAL(Apttus_Approval__Related_Opportunity__r.Phase_Status__c,&apos;Submitted for G5 Approval&apos;)),  			CONTAINS(TEXT(Apttus_Approval__Related_Opportunity__r.Apttus_Approval__Approval_Status__c), &apos;Pending Approval&apos;)  		),  		AND(  			ISPICKVAL(Apttus_Approval__Related_Opportunity__r.Phase_Status__c,&apos;Submitted for G5 Approval&apos;), OR( Apttus_Approval__Related_Opportunity__r.LOA_Level__c=&apos;A+&apos;, Apttus_Approval__Related_Opportunity__r.LOA_Level__c=&apos;E&apos; )  		)  	)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify PSM for Approval Request Comments</fullName>
        <actions>
            <name>Approval_Request_Comments_updates</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(Apttus_QPApprov__ProposalId__r.Quote_Type__c  = &quot;Indirect CPQ&quot;, NOT(ISBLANK(Apttus_Approval__Approver_Comments__c)),Apttus_Approval__Approver_Comments__c  &lt;&gt; &apos;For system use only. No action needed&apos;, NOT(ISBLANK( Apttus_Approval__Assigned_To_Name__c )))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
