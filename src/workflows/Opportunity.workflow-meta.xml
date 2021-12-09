<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
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
    <rules>
        <fullName>G2 to G6 Submission dates</fullName>
        <actions>
            <name>G2_Submission_dates_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>G6_Submission_dates_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Req::792 Updating the Submission dates</description>
        <formula>AND(  ISCHANGED(Phase_Status__c),  $Profile.Name &lt;&gt; $Label.Data_Loader_Profile_Name )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NF_ByPassApprovalG3</fullName>
        <actions>
            <name>G3_Approval_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $User.ProfileId != $Label.Data_Loader_Profile_Id, ISPICKVAL(PRIORVALUE(StageName) , &apos;Develop Opportunity&apos;), Gate_3_Bypass_no_offer_support__c = TRUE , ISPICKVAL(StageName , &apos;Create Offer (Bid)&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NF_ByPassApprovalG5</fullName>
        <actions>
            <name>G5_Approval_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( 				$User.ProfileId != $Label.Data_Loader_Profile_Id,  				ISPICKVAL(PRIORVALUE(StageName) , &apos;Win the Case (Negotiate)&apos;),  				ISPICKVAL(StageName , &apos;Handover (Prepare for Delivery)&apos;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NF_ByPassApprovalG6</fullName>
        <actions>
            <name>G6_Approval_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $User.ProfileId != $Label.Data_Loader_Profile_Id, ISPICKVAL(PRIORVALUE(StageName) , &apos;Handover (Prepare for Delivery)&apos;), ISPICKVAL(StageName, &apos;Execute (Start Delivery)&apos;),   OR(Gate_6_Bypass_No_Execute_needed__c  = true,No_Offer_Support__c &gt; 1)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Noki 2</fullName>
        <actions>
            <name>Stalling_Opportunity</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Stalling_Opportunity_false</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Checking Suspending Opp checkbox when Stage is Create Offer and Phase Status is changing to Submitted for G4 Approval from Offer in Progress</description>
        <formula>AND(    ISCHANGED( Phase_Status__c),  ISPICKVAL( PRIORVALUE( Phase_Status__c ) , &quot;Offer in Progress&quot; ),   $Profile.Name &lt;&gt; $Label.Data_Loader_Profile_Name  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PSR_In_Execution</fullName>
        <actions>
            <name>PSR_PO_Expected_Initial</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Rule for when PSRO is approved (moves to In Execution)</description>
        <formula>AND( ISCHANGED(StageName), ISPICKVAL(StageName, &apos;In Execution&apos;) , ISPICKVAL(PRIORVALUE(StageName), &apos;Submitted For Approval&apos;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Reset Approval Current Status</fullName>
        <actions>
            <name>Update_Approval_Current_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Reset Approval Current Status</description>
        <formula>$Profile.Name != $Label.Data_Loader_Profile_Name &amp;&amp;  ISPICKVAL(StageName,&apos;Win the Case (Negotiate)&apos;) &amp;&amp;  ISPICKVAL(Phase_Status__c,&apos;Offer Submitted to Customer (Manual)&apos;) &amp;&amp; ISPICKVAL(PRIORVALUE(Phase_Status__c),&apos;Pending Win/Loss Declaration&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update on Last Modified Risk Section</fullName>
        <actions>
            <name>Update_Last_Modified_Risk_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Last_Modified_Risk_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Any of the Risk Session field will update then Update the Last Modified name and Date (Req::816)</description>
        <formula>AND( $Profile.Name &lt;&gt;  $Label.Data_Loader_Profile_Name , 				OR( ISCHANGED( Risk_Categories__c ), ISCHANGED( Risk_Rating__c ), ISCHANGED( Risk_type__c ), ISCHANGED( Project_description_major_reason__c )  , ISCHANGED( Risk_Action_plan__c )  )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update on Last Modified Upside Section</fullName>
        <actions>
            <name>Update_Last_Modified_Upside_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Last_Modified_Upside_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Any of the Upside Session field will update then Update the Last Modified  Section(Req::816)</description>
        <formula>AND(  	         $Profile.Name &lt;&gt; $Label.Data_Loader_Profile_Name ,            				OR( ISCHANGED(  Upside_Categories__c  ), ISCHANGED(  Upside_Rating__c   ), ISCHANGED(  Upside_Project_description_major_reason__c   ), ISCHANGED( Upside_Action_plan__c  ) )  			)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update_Opportunity_ID</fullName>
        <actions>
            <name>Update_Opportunity_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Req 648: To Update Opportunity ID when it is not updated from external system.

PreSales : SFTicket : 00005192</description>
        <formula>AND($Profile.Name &lt;&gt; $Label.Data_Loader_Profile_Name,  	ISBLANK( Opportunity_ID__c ),   	OR($RecordType.DeveloperName = &apos;Direct_Record_Type&apos;,  	   $RecordType.DeveloperName = &apos;Indirect_Record_Type&apos;,   	   $RecordType.DeveloperName = &apos;Pre_opportunity&apos; 	) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>When PSP Selected at Opportunity</fullName>
        <actions>
            <name>Send_Email_to_pricing_pricing</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>RecordType.Name = &apos;Create Indirect Sales Opportunity&apos; &amp;&amp; ( (ISCHANGED(Contract_Price_List__c ) &amp;&amp; ISBLANK(PRIORVALUE(Contract_Price_List__c ))) || (NOT(ISBLANK(Contract_Price_List__c)) &amp;&amp;   (ISCHANGED(Contract_Price_List__c ) &amp;&amp; NOT(ISBLANK(PRIORVALUE(Contract_Price_List__c ))))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
