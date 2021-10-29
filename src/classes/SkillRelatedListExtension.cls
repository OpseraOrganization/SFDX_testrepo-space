public with sharing class SkillRelatedListExtension {

private List<skills2__c> sk1;
private List<skills2__c> sk;
private Case cas;
public SkillRelatedListExtension(ApexPages.StandardController controller) {
 this.cas=(Case)controller.getRecord();
 }
 public List<skills2__c> getSk()
 {
    if(cas.id!=null){
     Case c = [Select id, Supported_Products__r.id FROM Case where id =:cas.id];
     string meid = label.ManagerFilterForSkillsRelatedList;
     list<string> meid1 = meid.split(',');
     
     if(c.Supported_Products__c==null)
     return null;
     sk = [Select contact__r.name,Expertise__c,Region__c,Tier_4_Teams__c,contact__r.id,Skill_Value__c,Skill_Type__c,Supported_Products__r.name from 
     skills2__c where Supported_Products__c =: c.Supported_Products__r.Id and contact__r.User_Primary_Manager_eid__c in: meid1 and Supported_Products__r.Status__c = 'Active' ORDER BY Expertise__c DESC]; 
     
     }
     return sk;
 }

}