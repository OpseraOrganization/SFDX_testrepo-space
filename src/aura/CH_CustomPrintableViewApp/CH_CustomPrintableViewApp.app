<aura:application extends="force:slds" access="global" controller="CH_CustomPrintableView_Controller" >
    <aura:attribute name="recordid" type="String"/>
    <aura:attribute name="fieldSetName" type="String"/>
    <aura:attribute name="sObjectTypeName" type="String"/>
    <aura:attribute name="objName" type="String"/>
    <aura:attribute name="showData" type="Boolean" default="false"/>
    <aura:attribute name="parentName" type="String"/>
    <aura:attribute name="selectedDate" type="Date" />
    <aura:attribute name="currentCaseRecord" type="Case" />
    <aura:attribute name="startDate" type="Date" />
    <aura:attribute name="endDate" type="Date" />
    
    <aura:attribute name="isSpinner" type="Boolean" default="false"/>
    <aura:attribute name="relatedObjects" type="Object[]" description="to store related objects"/>
    <aura:attribute name="activeSections" type="List" default="[]"/>
    <aura:attribute name="allDates" type="List" default="[]"/>
    <aura:handler name="init" value="{!this}" action="{!c.doInit}"/>
    <lightning:workspaceAPI aura:id="workspace"/>
    <!--<aura:handler name="change" value="{!v.selectedDate}" action="{!c.onDateChange}" />-->
    <aura:handler name="change" value="{!v.startDate}" action="{!c.onstartDateChange}" />
    <aura:handler name="change" value="{!v.endDate}" action="{!c.onendDateChange}" />
    
    
    <aura:if isTrue="{!v.isSpinner}">
        <lightning:spinner variant="brand"  size="medium" />
    </aura:if>
    <aura:if isTrue="{!v.showData}">
        <div class="slds-box custom-section">
            <lightning:layout horizontalAlign="center">
                <lightning:layoutItem size="6">
                    <lightning:avatar size="large"   
                                      src="/img/salesforce_printable_logo.gif" 
                                      class="slds-m-right_large" style="width:146px;height:47px"/>
                    <!--<div class="slds-global-header__logo" style="background-image: url(/img/salesforce-noname-logo-v2.svg?width=128&amp;height=128)" data-aura-rendered-by="274:0;p"></div>-->
                </lightning:layoutItem>
                <lightning:layoutItem size="6">
                    <div class="slds-clearfix slds-p-around_medium">
                        <div class="slds-float_right">
                            <lightning:button aura:id="closeButton" variant="basic" class="" label="Close Window" onclick="{!c.closeWindow}"/>
                            <br/>
                            <lightning:button aura:id="printButton" variant="basic" class="" label="Print This Page" onclick="{!c.print}"/>
                            <br/>
                            <lightning:button variant="basic" aura:id="expand" class="" label="Expand All" onclick="{!c.expandAll}"/> || <lightning:button variant="basic" aura:id="collapse" class="" label="Collapse All" onclick="{!c.collapseAll}"/>
                        </div>
                        
                    </div>
                </lightning:layoutItem>
            </lightning:layout>
            <div class="slds-text-heading_medium"><b>Support Ticket: {!v.parentName}</b></div>
            <br/>
            <lightning:layout horizontalAlign="left">
                <div>
                <lightning:layoutItem size="2">                    
                    <lightning:input   type="date" name="startDate" class ="large-font" label="Start Date" value="{!v.startDate}" style="width:180px"/>
                </lightning:layoutItem> 
                </div>
				<div>
                <lightning:layoutItem size="2">                   
                    <lightning:input   type="date" name="endDate"  class= "large-font" label="End Date" value="{!v.endDate}" style="width:180px"/>
                </lightning:layoutItem>
				</div>
            </lightning:layout>
            <lightning:accordion class= "large-font-header"
                                 allowMultipleSectionsOpen="true"
                                 onsectiontoggle="{! c.handleSectionToggle }"
                                 activeSectionName="{! v.activeSections }">
                <lightning:accordionSection name="case" label="Case Details">
                    <c:CH_CustomPrintableView recordId="{!v.recordid}" fieldSetName="FieldsToPrint" sObjectTypeName="Case"
                                              />
                </lightning:accordionSection>
                <aura:iteration items="{!v.relatedObjects}" var="d">
                    <aura:if isTrue="{! and(lessthanorequal(v.startDate, d.key), greaterthanorequal(v.endDate, d.key))}">
                        <lightning:accordionSection name="{!d.key}" label="{!d.key}" class= "large-font-header">
                            <aura:iteration items="{!d.value}" var="childObj">
                                <c:CH_CustomPrintableView recordId="{!v.recordid}" 
                                                          fieldSetName="contactFieldSet" 
                                                          sObjectTypeName="{!childObj.childOjectName}"
                                                          isRelatedList="true"
                                                          childObjectName="{!childObj.childOjectName}"
                                                          referenceFieldName="{!childObj.referenceField}"
                                                          childObjectLabel="{!childObj.childOjectLabel}"
                                                          iconName="standard:case"
                                                          selectedDate="{!d.key}"
                                                          />
                            </aura:iteration>
                        </lightning:accordionSection>
                    </aura:if>
                </aura:iteration>
            </lightning:accordion>
            <!-- <aura:if isTrue="{!and(v.relatedObjects==null)}">
                <p>No Activities on a selected Date</p>
            </aura:if> -->
        </div>
    </aura:if>
</aura:application>