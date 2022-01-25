<aura:application access="GLOBAL"  extends="ltng:outApp">
    <aura:dependency resource="markup://force:showToast" type="EVENT,COMPONENT" />
    <aura:attribute name="configId" type="String" default=""/>
    <aura:dependency resource="c:Nokia_CPQSitePhaseConfirmbox"/>
    <!--<c:Nokia_CPQSitePhaseConfirmbox configId="{!configId}" />-->
</aura:application>