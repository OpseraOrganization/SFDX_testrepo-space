/***************************************************
**File Name: AutoConvertQualifiedLeadToOppertunity
** Description: Trigger is  automatically converting qualified lead to oppertunity.
**Company Name : Honeywell Aero
**Date Of Creation:28-sep-2012
**Version No:0.01
**Created By:Manoj Kumar Jena

**Update Date: 2016-10-15
**Update Reason: S2S Connection User needs to update CEC information on Lead and has no Profile.
**Update By: Michael, NTTData China

**Update Date: 2020-Oct-08
**Update Reason: Automation User needs to update DNS Reason Detail and Email opt out on Lead as part of CCPA Implementation and has no Profile.
**Update By: Effat, NTTData India
*****************************************************/ 

trigger AutoConvertQualifiedLeadToOppertunity on Lead (after update) {
system.debug('UserInfo.getName()'+UserInfo.getName());
if(Userinfo.getUserName() == 'Connection User' || UserInfo.getName() == 'Connection User' || UserInfo.getName() == 'Automated Process') return;
List<Profile> profileList;
Set<string> leadIdSet=new Set<String>();
String profileId = Userinfo.getprofileId().substring(0,15);
String profileName = [SELECT Name FROM Profile where Id  =: profileId].Name;
if(profileName =='ATR Read Only'||profileName=='ATR Read Only Demo'|| profileName=='ATR Sales'|| profileName=='ATR Sales Admin'
        ||profileName=='ATR Sales Admin IV'||profileName=='System Administrator' || profileName=='Honeywell System Administrator'){
         for(Lead led:Trigger.new){
            if(Trigger.isUpdate){
                if(System.Trigger.OldMap.get(led.Id).Status != led.Status){
                    if(led.Status =='Sales Qualified Lead'){
                        leadIdSet.add(led.Id);
                    }
                }
            }
        }
        List<Lead> LeadList=[Select id,Lead_converted__c from Lead Where Id IN:leadIdSet];
        for(Integer i=0;i<LeadList.size();i++){
            LeadList[i].Lead_converted__c=true;
        
        }
        if(LeadList.size()>0){
            try{
               update LeadList;
            }catch(DmlException de){
            }catch(Exception e){
            }
            
        }
    }
}