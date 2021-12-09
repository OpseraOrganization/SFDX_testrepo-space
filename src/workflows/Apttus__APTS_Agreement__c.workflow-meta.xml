<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CLM_Agreement_Naming_convention</fullName>
        <field>Name</field>
        <formula>LEFT(Apttus__Account__r.Name, 40) +&apos;-&apos;+   RecordType.Name  +&apos;-&apos;+TEXT( Apttus__Contract_Start_Date__c )</formula>
        <name>Agreement Naming convention</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Expiry_Status_Catagory_Field_Update</fullName>
        <field>Apttus__Status_Category__c</field>
        <literalValue>Expired</literalValue>
        <name>CLM Expiry Status Catagory Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Expiry_status_Field_update</fullName>
        <field>Apttus__Status__c</field>
        <literalValue>Expired</literalValue>
        <name>CLM Expiry status Field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Set_nonstd_legal_language_to_False</fullName>
        <field>Apttus__Non_Standard_Legal_Language__c</field>
        <literalValue>0</literalValue>
        <name>Set nonstd legal language to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Set_nonstd_legal_language_to_true</fullName>
        <field>Apttus__Non_Standard_Legal_Language__c</field>
        <literalValue>1</literalValue>
        <name>Set nonstd legal language to true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DS_Populate_Agreement_EPR_to_Blue_Planet</fullName>
        <description>DS S20</description>
        <field>ERP__c</field>
        <literalValue>Blue Planet</literalValue>
        <name>DS_Populate Agreement EPR to Blue Planet</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DS_Populate_Agreement_EPR_to_P20</fullName>
        <description>DS S20</description>
        <field>ERP__c</field>
        <literalValue>P20</literalValue>
        <name>DS_Populate Agreement EPR to P20</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CLM Agreement Name Rule</fullName>
        <actions>
            <name>CLM_Agreement_Naming_convention</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.RecordTypeId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>General</value>
        </criteriaItems>
        <description>This rule will define the agreement naming convention</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CLM Contract Request is created but not submitted to Legal</fullName>
        <actions>
            <name>CLM_Contract_Request_is_created_but_not_submitted_to_L_C</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Status_Category__c</field>
            <operation>equals</operation>
            <value>Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Status__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Contract Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.CLM_Manual_or_Automatic__c</field>
            <operation>equals</operation>
            <value>Automatic</value>
        </criteriaItems>
        <description>CLM Contract Request is created but not submitted to L &amp; C</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CLM Notification to CM AM for Automatic agreement Creation</fullName>
        <actions>
            <name>CLM_Agreement_Submission_alert_to_Individual_CM</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CLM_Individual_Ownership_of_CM_Queue</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Status_Category__c</field>
            <operation>equals</operation>
            <value>Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Status__c</field>
            <operation>equals</operation>
            <value>Submitted Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.CLM_Manual_or_Automatic__c</field>
            <operation>equals</operation>
            <value>Automatic</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CLM Renewal Notification</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Status__c</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Status_Category__c</field>
            <operation>equals</operation>
            <value>In Effect</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Contract_End_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>The Account Manager should receive an email 6 months before the expiration date.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CLM_AM_and_CM_receives_reminder_notification</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Apttus__APTS_Agreement__c.Apttus__Contract_End_Date__c</offsetFromField>
            <timeLength>-150</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>CLM_AM_and_CM_receives_reminder_notification_4</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Apttus__APTS_Agreement__c.Apttus__Contract_End_Date__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>CLM_AM_and_CM_receives_reminder_notification_2</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Apttus__APTS_Agreement__c.Apttus__Contract_End_Date__c</offsetFromField>
            <timeLength>-90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>CLM_AM_and_CM_receives_contract_expired_notification</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>CLM_Expiry_Status_Catagory_Field_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>CLM_Expiry_status_Field_update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Apttus__APTS_Agreement__c.Apttus__Contract_End_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>CLM_AM_and_CM_receives_reminder_notification_3</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Apttus__APTS_Agreement__c.Apttus__Contract_End_Date__c</offsetFromField>
            <timeLength>-60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>CLM_AM_and_CM_receives_reminder_notification_1</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Apttus__APTS_Agreement__c.Apttus__Contract_End_Date__c</offsetFromField>
            <timeLength>-120</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>CLM_AM_receives_reminder_before_six_months</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Apttus__APTS_Agreement__c.Apttus__Contract_End_Date__c</offsetFromField>
            <timeLength>-180</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CLM_Set NonStandard Legal Language field</fullName>
        <actions>
            <name>CLM_Set_nonstd_legal_language_to_true</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.CLM_Modified_Clauses_Count__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Source__c</field>
            <operation>equals</operation>
            <value>Customer Paper</value>
        </criteriaItems>
        <description>Set the field to true if there are any modified agreement clauses</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CLM_Set nonstd legal language to False</fullName>
        <actions>
            <name>CLM_Set_nonstd_legal_language_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.CLM_Modified_Clauses_Count__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DS Populate ERP field on agreement_Blue Planet</fullName>
        <actions>
            <name>DS_Populate_Agreement_EPR_to_Blue_Planet</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( 	NOT(ISBLANK(Apttus__Related_Opportunity__c)), 	ISPICKVAL(Apttus__Related_Opportunity__r.Contract_Signing_Entity__c, &apos;fALU&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DS Populate ERP field on agreement_P20</fullName>
        <actions>
            <name>DS_Populate_Agreement_EPR_to_P20</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( 	NOT(ISBLANK(Apttus__Related_Opportunity__c)), 	ISPICKVAL(Apttus__Related_Opportunity__r.Contract_Signing_Entity__c, &apos;fNOK&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
