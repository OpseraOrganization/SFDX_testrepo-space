/**************************************************************************************************************************
*   Trigger to update Team Member & BGA Contract fields
*
* Modification History
* Date              Version No   Modified By        Brief Description of modification
* Mar-12-2013         1.0         NTTDATA           Initial Version
* Nov-14-2013         1.1         NTTDATA           For SR#433112, Populate BGA Contract Record as Platform Name based on 
                                                    Fleet Asset Aggregate record
* Aug-28-2015         1.2         NTTDATA           Populate the Region and Sub Region from the Country table
****************************************************************************************************************************/
trigger UpdateTextFieldwithTeammember on Account (before update,before insert)
{
    List<Fleet_Asset_Aggregate__c> FlList = new List<Fleet_Asset_Aggregate__c>();
    set<id> accid = new set<id>();
    set<id> accid1 = new set<id>();
    Map<id,list<string>> schedulemap=new Map<id,list<string>>();
    Map<id,list<string>> schedulemap1=new Map<id,list<string>>();
    List<AccountTeamMember> atmlist = new List<AccountTeamMember>();
    // INC000008883443 - Start
    Set<id> countryid = new set<id>();
    // INC000008883443 - End
    for(Account acc:trigger.new){
        accid.add(acc.id);
        // INC000008883443 - Start
        if(acc.country__c!=null){
            countryid.add(acc.country__c);
        }
        // INC000008883443 - End
    }
    atmlist = [SELECT UserId,user.name,AccountId,TeamMemberRole FROM AccountTeamMember WHERE AccountId =:accid AND TeamMemberRole='Customer Service Manager'];
    for(AccountTeamMember am:atmlist){
        list<string> temp=new list<string>();
        if(schedulemap.containsKey(am.AccountId))
            temp=(schedulemap.get(am.AccountId));
        temp.add(am.user.name);
        schedulemap.put(am.AccountId,temp);
    }
    // INC000008883443 - Start
    Map<id,Country__c> countrymap=new Map<id,Country__c>();
    if(countryid.size()>0){
        countrymap = new Map<id,Country__c>([Select id,Honeywell_Region_Name__c,Honeywell_Sub_Region_Name__c from Country__c where id in:countryid]);
    }
    // INC000008883443 - End
    for(Account acc:trigger.new){
        acc.Team_Member__c=''; 
        if(schedulemap.containsKey(acc.id)){
            acc.Team_Member__c+=schedulemap.get(acc.id);
            String test = acc.Team_Member__c;
            string test2 = test.substring(1,test.length()-1);
            acc.Team_Member__c = test2;
        }
        // INC000008883443 - Start
        if(acc.country__c != null) {
            if(countrymap.size()>0 && countrymap.get(acc.country__c)!=null){
                acc.Region_Name__c = countrymap.get(acc.country__c).Honeywell_Region_Name__c;
                acc.Sub_Region_Name__c = countrymap.get(acc.country__c).Honeywell_Sub_Region_Name__c;
            }
        }
        // INC000008883443 - End
    }
}