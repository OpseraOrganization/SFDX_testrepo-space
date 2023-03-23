<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Customer_Offer_Due_Date_2</fullName>
        <field>Customer_Offer_Due_Date__c</field>
        <formula>Opportunity__r.G4_Planned_Date__c  + 2</formula>
        <name>Customer Offer Due Date + 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NF_AuthorizedForPricingManager_Check1</fullName>
        <field>Authorized_for_Pricing_Manager__c</field>
        <literalValue>1</literalValue>
        <name>NF_AuthorizedForPricingManager_Check1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NF_AuthorizedForPricingManager_Uncheck</fullName>
        <field>Authorized_for_Pricing_Manager__c</field>
        <literalValue>0</literalValue>
        <name>NF_AuthorizedForPricingManager_Uncheck</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NF_FU_UPDATE_NO_LOA_FALSE</fullName>
        <field>No_Loa__c</field>
        <literalValue>0</literalValue>
        <name>NF_FU_UPDATE_NO_LOA_FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NF_FU_UPDATE_NO_LOA_FALSE_OFFER</fullName>
        <field>No_LoA__c</field>
        <literalValue>0</literalValue>
        <name>NF_FU_UPDATE_NO_LOA_FALSE_OFFER</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NF_FU_UPDATE_NO_LOA_TRUE</fullName>
        <field>No_Loa__c</field>
        <literalValue>1</literalValue>
        <name>NF_FU_UPDATE_NO_LOA_TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NF_FU_UPDATE_NO_LOA_TRUE_OFFER</fullName>
        <field>No_LoA__c</field>
        <literalValue>1</literalValue>
        <name>NF_FU_UPDATE_NO_LOA_TRUE_OFFER</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NF_PreapprovedPriceListAM_Check</fullName>
        <field>Pre_approved_Price_List_for_Acc_Managers__c</field>
        <literalValue>1</literalValue>
        <name>NF_PreapprovedPriceListAM_Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NF_PreapprovedPriceListAM_Uncheck</fullName>
        <field>Pre_approved_Price_List_for_Acc_Managers__c</field>
        <literalValue>0</literalValue>
        <name>NF_PreapprovedPriceListAM_Uncheck</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_the_Active_Price_Amount</fullName>
        <description>Req 580: Copy of the Unweighted Value from Opportunity(D-0913)</description>
        <field>Price__c</field>
        <formula>Opportunity__r.Amount</formula>
        <name>Set the Active Price Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Pre_Approved_Decision_Maker</fullName>
        <description>D-0505: system should automatically set the &apos;Pre-approved Decision Maker&apos; to the name who sets the flag &apos;Authorized for Pricing Manager&apos;</description>
        <field>Pre_approved_Decision_Maker__c</field>
        <formula>LastModifiedBy.FirstName &amp; &quot; &quot; &amp;  LastModifiedBy.LastName</formula>
        <name>Update Pre-Approved Decision Maker</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Authorized For Pricing Manager Is True</fullName>
        <actions>
            <name>Update_Pre_Approved_Decision_Maker</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>D-0505: system should automatically set the &apos;Pre-approved Decision Maker&apos; to the name who sets the flag &apos;Authorized for Pricing Manager&apos;</description>
        <formula>AND( 	OR( 		ISCHANGED( Authorized_for_Pricing_Manager__c),  		ISNEW() 	),  	Authorized_for_Pricing_Manager__c = True,         $Profile.Name&lt;&gt; $Label.Data_Loader_Profile_Name )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Offer Price</fullName>
        <actions>
            <name>Set_the_Active_Price_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Offer__c.ActiveOffer__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Data Loader Profile</value>
        </criteriaItems>
        <description>Req 580: Copy of the Unweighted Value from Opportunity(D-0913)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NF_LOA_BYPASS_NO_LOA</fullName>
        <actions>
            <name>NF_FU_UPDATE_NO_LOA_TRUE</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>NF_FU_UPDATE_NO_LOA_TRUE_OFFER</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Offer__c.LOA_Bypass__c</field>
            <operation>equals</operation>
            <value>No LoA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Offer__c.ActiveOffer__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When the LoA Bypass condition is updated to &quot;No LOA&quot; the No LOA flag on the opportunity is updated to true on the opportunity (to enable No LOA flag to be passed to approval process)

//TSALEM</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NF_LOA_BYPASS_NO_LOA_UNCHECK</fullName>
        <actions>
            <name>NF_FU_UPDATE_NO_LOA_FALSE</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>NF_FU_UPDATE_NO_LOA_FALSE_OFFER</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Offer__c.LOA_Bypass__c</field>
            <operation>notEqual</operation>
            <value>No LoA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Offer__c.ActiveOffer__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When the LOA bypass condition is unchecked from No LoA - update the NO LOA flag on the opportunity to false

//TSALEM</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NF_PreapprovedPriceListAM_ByPass_Check</fullName>
        <actions>
            <name>NF_PreapprovedPriceListAM_Check</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Offer__c.LOA_Bypass__c</field>
            <operation>equals</operation>
            <value>Pre-approved Price List for Account Managers</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Data Loader Profile</value>
        </criteriaItems>
        <description>When the LoA Bypass Offer Condition is set to Pre-approved Price list AM, set the flag on the offer object to true (which rolls up to the Opportunity flag</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NF_PreapprovedPriceListAM_Bypass_Uncheck</fullName>
        <actions>
            <name>NF_PreapprovedPriceListAM_Uncheck</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Offer__c.LOA_Bypass__c</field>
            <operation>notEqual</operation>
            <value>Pre-approved Price List for Account Managers</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Data Loader Profile</value>
        </criteriaItems>
        <description>When the LoA Bypass Offer Condition is unchecked from Pre-approved price list for AM (to something else), set the flag on the offer object to false (which rolls up to the Opportunity flag</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NF_WF_Update _AUTHORIZED_PRICING_MGR_CHECK</fullName>
        <actions>
            <name>NF_AuthorizedForPricingManager_Check1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Offer__c.LOA_Bypass__c</field>
            <operation>equals</operation>
            <value>Authorized for Pricing Manager</value>
        </criteriaItems>
        <description>When the LoA Bypass Offer Condition is set to Authorized for Pricing Manager, set the flag on the offer object to true (which rolls up to the Opportunity flag)

//TSALEM</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NF_WF_Update _AUTHORIZED_PRICING_MGR_UNCHECK</fullName>
        <actions>
            <name>NF_AuthorizedForPricingManager_Uncheck</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Offer__c.LOA_Bypass__c</field>
            <operation>notEqual</operation>
            <value>Authorized for Pricing Manager</value>
        </criteriaItems>
        <description>When the LoA Bypass Offer Condition is unchecked from Authorized for Pricing Manager (to something else), set the flag on the offer object to false (which rolls up to the Opportunity flag)

//TSALEM</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Customer Offer Due Date1</fullName>
        <actions>
            <name>Customer_Offer_Due_Date_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Profile.Name&lt;&gt; $Label.Data_Loader_Profile_Name,  	OR( ISPICKVAL( Opportunity__r.StageName, &apos;Identify Opportunity&apos;), 		ISPICKVAL( Opportunity__r.StageName, &apos;Develop Opportunity&apos;), 		ISPICKVAL( Opportunity__r.StageName, &apos;Create Offer (Bid)&apos;), 		ISPICKVAL( Opportunity__r.StageName, &apos;Win the Case (Negotiate)&apos;) 		), 		NOT(ISPICKVAL( Opportunity__r.Business_Type__c, &apos;Fast Track Opportunity&apos;)) 	)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
