<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Cert_Expired</fullName>
        <field>Certification_expires_in__c</field>
        <literalValue>Expired</literalValue>
        <name>Cert Expired_test</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cert_expires_in_30_days</fullName>
        <field>Certification_expires_in__c</field>
        <literalValue>30 Days</literalValue>
        <name>Cert expires in 30 days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cert_expires_in_60_days</fullName>
        <field>Certification_expires_in__c</field>
        <literalValue>60 Days</literalValue>
        <name>Cert expires in 60 days_test</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cert_expires_in_6_months</fullName>
        <field>Certification_expires_in__c</field>
        <literalValue>6 Months</literalValue>
        <name>Cert expires in 6 months</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cert_expires_in_90_days</fullName>
        <field>Certification_expires_in__c</field>
        <literalValue>90 Days</literalValue>
        <name>Cert expires in 90 days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Certification_Expiration_In_text</fullName>
        <field>Certification_expires_in_Text__c</field>
        <formula>TEXT(Certification_expires_in__c)</formula>
        <name>Certification Expiration In text</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Restore_expiration_date</fullName>
        <field>Certification_Expiration_Date__c</field>
        <formula>New_Expiration_Date__c</formula>
        <name>Restore expiration date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateCertExpired</fullName>
        <field>Certification_Status__c</field>
        <literalValue>Expired</literalValue>
        <name>UpdateCertExpired</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_Name_Certifiaction</fullName>
        <field>Account_Name__c</field>
        <formula>Partner__r.AccountNumber</formula>
        <name>Update Account Name Certifiaction</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Backend_expiration_date</fullName>
        <field>New_Expiration_Date__c</field>
        <formula>Certification_Expiration_Date__c</formula>
        <name>Update Backend expiration date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Backend_expiration_date_to_blank</fullName>
        <field>New_Expiration_Date__c</field>
        <name>Update Backend expiration date to blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Certification_Name</fullName>
        <field>Cert_Name__c</field>
        <formula>Certification_Name__c</formula>
        <name>Update Certification Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Expiration_field_to_blank</fullName>
        <field>Certification_Expiration_Date__c</field>
        <name>Update Expiration field to blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_port</fullName>
        <field>port__c</field>
        <formula>Technologies_Portfolio__c</formula>
        <name>update port</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Certification Account Update</fullName>
        <actions>
            <name>Update_Account_Name_Certifiaction</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Certification__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Certification Expiration Reminder 1 month</fullName>
        <active>true</active>
        <formula>AND(NOT(ISNULL(Certification_Expiration_Date__c)), (Certification_Expiration_Date__c) &gt;= (today() + 29))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Cert_expires_in_30_days</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Certification__c.Certification_Expiration_Date__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Certification Expiration Reminder 2 months</fullName>
        <active>true</active>
        <formula>AND(NOT(ISNULL(Certification_Expiration_Date__c)), Certification_Expiration_Date__c &gt; Today()+ 59)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Cert_expires_in_60_days</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Certification__c.Certification_Expiration_Date__c</offsetFromField>
            <timeLength>-60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Certification Expiration Reminder 3 months</fullName>
        <active>true</active>
        <formula>AND(NOT(ISNULL(Certification_Expiration_Date__c)), Certification_Expiration_Date__c &gt; Today()+ 89)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Cert_expires_in_90_days</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Certification__c.Certification_Expiration_Date__c</offsetFromField>
            <timeLength>-90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Certification Expiration Reminder 6 months</fullName>
        <active>true</active>
        <formula>AND(NOT(ISNULL(Certification_Expiration_Date__c)), Certification_Expiration_Date__c &gt; Today()+ 179)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Cert_expires_in_6_months</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Certification__c.Certification_Expiration_Date__c</offsetFromField>
            <timeLength>-180</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Certification Expiration Reminder Expired</fullName>
        <active>true</active>
        <formula>AND(NOT(ISNULL(Certification_Expiration_Date__c)), Certification_Expiration_Date__c  &gt;  Today()-1)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Cert_Expired</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Certification__c.Certification_Expiration_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Certification Expiration in Text  update</fullName>
        <actions>
            <name>Certification_Expiration_In_text</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Certification_expires_in__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Restore Expiration date</fullName>
        <actions>
            <name>Restore_expiration_date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Backend_expiration_date_to_blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(New_Expiration_Date__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Certification Name and portfolio</fullName>
        <actions>
            <name>Update_Certification_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>update_port</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(ISNEW(),ISCHANGED(Certification_Matrix_Number__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Expired Status</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Certification__c.Certification_Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>Certification is complete, expiration date is today date or older, change status to expired</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>UpdateCertExpired</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Certification__c.Certification_Expiration_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Updated Expirtaion date%28backend%29</fullName>
        <actions>
            <name>Update_Backend_expiration_date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Expiration_field_to_blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Certification_Expiration_Date__c ), NOT(ISBLANK(Certification_Expiration_Date__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
