<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>OIF_EUR_Value_Update</fullName>
        <description>Opportunity Currency equals EUR then OIF EUR will update(Req:136)</description>
        <field>OIF_Value_EUR__c</field>
        <formula>OIF_Value__c</formula>
        <name>OIF EUR Value Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_OIF_Change_on_relevant_flag</fullName>
        <description>If any one of the BL/Category/ Period/ Software(%)/OIF value then modified by owner filed will make as true(Req::779)</description>
        <field>Changes_on_relevant_fields__c</field>
        <literalValue>1</literalValue>
        <name>Update OIF Change on relevant flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Previous_OIF_Business_Line</fullName>
        <description>If any changes in the BL then Previous Bl line will update the old vale (Req:779)</description>
        <field>Previous_Business_Line__c</field>
        <formula>IF( ISCHANGED( BusinessLine__c ),   PRIORVALUE(Business_line_Data__c)   , Previous_Business_Line__c  

)</formula>
        <name>Update  Previous OIF Business Line</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Previous_OIF_Forecast_Category</fullName>
        <description>If any changes in the Category then Previous Category line will update (Req:779)</description>
        <field>Previous_Forecast_Category__c</field>
        <formula>IF( ISCHANGED( Forecast_Category__c ), TEXT(PRIORVALUE(Forecast_Category__c )),
 Previous_Forecast_Category__c  

)</formula>
        <name>Update Previous OIF Forecast Category</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Previous_OIF_POPlan</fullName>
        <description>If any changes in the OIF Period then Previous OIF Period line will update the old Period Name (Req:779)</description>
        <field>Previous_PO_Plan_Receipt__c</field>
        <formula>IF( ISCHANGED(POPlanReceipt__c),  PRIORVALUE(PO_Plan_Data__c ) , Previous_PO_Plan_Receipt__c   

)</formula>
        <name>Update Previous OIF  POPlan</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Previous_OIF_Software</fullName>
        <description>If any changes in the Software(%) then Previous  Software line will update Req:779)</description>
        <field>Previous_Software__c</field>
        <formula>IF( ISCHANGED( Software__c ) , PRIORVALUE(Software__c),
 Previous_Software__c 
)</formula>
        <name>Update Previous OIF Software(%)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Previous_OIF_Value</fullName>
        <description>If any changes in the Oif Value then Previous OIF line will update the old OIF value (Req:779)</description>
        <field>Previous_OIF_Value__c</field>
        <formula>IF( ISCHANGED( OIF_Value__c ), PRIORVALUE( OIF_Value__c ) , Previous_OIF_Value__c  

)</formula>
        <name>Update Previous OIF Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_Close_date_to_empty</fullName>
        <description>Update the close date to Empty(Req:136)</description>
        <field>Close_Date__c</field>
        <name>Update the Close date to empty</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_OIF_status</fullName>
        <field>Update_Status__c</field>
        <literalValue>0</literalValue>
        <name>Update the OIF status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_Relevant_Flag_To_False</fullName>
        <description>Update the relevant flag to False (Req::779)</description>
        <field>Changes_on_relevant_fields__c</field>
        <literalValue>0</literalValue>
        <name>Update the  Relevant Flag To False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_close_date</fullName>
        <description>Fill the Close date as per the today date(Req:136)</description>
        <field>Close_Date__c</field>
        <formula>DATEVALUE(Now())</formula>
        <name>Update the close date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_status_to_true</fullName>
        <field>Update_Status__c</field>
        <literalValue>1</literalValue>
        <name>Update the status to true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Changes on relevant flag to false</fullName>
        <actions>
            <name>Update_the_Relevant_Flag_To_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This will trigger everytime the OIF line is edited but no changes have been done to the relevant fields AND Last Modified date before was not equal to today(Req::779)</description>
        <formula>AND(  NOT( OR(  ISCHANGED( BusinessLine__c ), ISCHANGED( POPlanReceipt__c ), ISCHANGED( Forecast_Category__c ), ISCHANGED( OIF_Value__c ), ISCHANGED( Software__c ) ) ),  (DATEVALUE (PRIORVALUE(LastModifiedDate)) &lt;&gt; TODAY()), ($Profile.Name &lt;&gt; $Label.Data_Loader_Profile_Name)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OIF EUR Currency Update</fullName>
        <actions>
            <name>OIF_EUR_Value_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>If opportunity currency will be EUR then OIF EUR value update (Req:136)</description>
        <formula>ISPICKVAL( Opportunity__r.CurrencyIsoCode ,&apos;EUR&apos;)  &amp;&amp; ($Profile.Name&lt;&gt;$Label.Data_Loader_Profile_Name)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OIF Record type change track</fullName>
        <actions>
            <name>Update_the_status_to_true</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED( RecordTypeId ), $Profile.Name &lt;&gt; $Label.Data_Loader_Profile_Name   )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update OIF CLone Line Status</fullName>
        <actions>
            <name>Update_the_OIF_status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set the flag has to false Req: 1439</description>
        <formula>AND(      Update_Status__c=TRUE, $Profile.Name &lt;&gt; $Label.Data_Loader_Profile_Name   )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update OIF Object Close Date</fullName>
        <actions>
            <name>Update_the_close_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order_Intake_Forecast__c.Forecast_Category__c</field>
            <operation>equals</operation>
            <value>Booked,Cancelled,Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Data Loader Profile</value>
        </criteriaItems>
        <description>Update &apos;Close Date&apos; with the date of first setting Forecast Category to &apos;Booked&apos;, &apos;Cancelled&apos; or &apos;Lost&apos;(Req:136)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update OIF Object Close Date to Empty</fullName>
        <actions>
            <name>Update_the_Close_date_to_empty</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>if Forecast Category is set to Secure, Risk, Upside, RoP, Excluded from Booked, Cancelled or Lost then close date will be empty(Req:136)</description>
        <formula>AND(  OR( ISPICKVAL(PRIORVALUE(Forecast_Category__c ),&quot;Booked&quot;), ISPICKVAL(PRIORVALUE(Forecast_Category__c ),&quot;Cancelled&quot;), ISPICKVAL(PRIORVALUE(Forecast_Category__c ),&quot;Lost&quot;) ) ,   OR( ISPICKVAL(Forecast_Category__c, &quot;Secure&quot;), ISPICKVAL(Forecast_Category__c, &quot;Risk&quot;), ISPICKVAL(Forecast_Category__c, &quot;Upside&quot;), ISPICKVAL(Forecast_Category__c, &quot;ROP&quot;), ISPICKVAL(Forecast_Category__c, &quot;Excluded&quot;) ),    ($Profile.Name&lt;&gt;$Label.Data_Loader_Profile_Name)   )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update the OIF previous field with the previous value</fullName>
        <actions>
            <name>Update_OIF_Change_on_relevant_flag</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Previous_OIF_Business_Line</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Previous_OIF_Forecast_Category</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Previous_OIF_POPlan</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Previous_OIF_Software</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Previous_OIF_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the Previous fields with Old Data (Req::779)</description>
        <formula>AND(  OR(  ISCHANGED( BusinessLine__c ),  ISCHANGED( Forecast_Category__c ),  ISCHANGED( POPlanReceipt__c ),  ISCHANGED( OIF_Value__c ),  ISCHANGED( Software__c )  ),   ($Profile.Name&lt;&gt; $Label.Data_Loader_Profile_Name )      )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
