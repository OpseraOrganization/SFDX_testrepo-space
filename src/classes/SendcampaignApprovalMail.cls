/** * File Name: SendcampaignApprovalMail 
* Description Controller for the visualforce page which displays the Campaign team members for
 *Phase approval and inserts record in the Campaign_Gate_Approval_History__c object
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 

public class SendcampaignApprovalMail {

public boolean showlist{get; set;}
public boolean backto{get; set;}
 boolean showerror = false;
List<Oppwrap> wrapper=new List<Oppwrap>();

List<String> team = new List<String>();
List<Campaign_Gate_Approval_History__c> ApproveobjRec=new List<Campaign_Gate_Approval_History__c>();
public Id oppGateId;
public Id oppId;  

public SendcampaignApprovalMail(ApexPages.StandardController controller) {
  oppGateId = System.currentPageReference().getParameters().get('id');
  Campaign_Gate__c og= [Select o.Campaign__c, o.Id From Campaign_Gate__c o where o.Id=: oppGateId];
      oppId=og.Campaign__c;
      System.debug('oppId -- > '+oppId);
//Code to avoid duplicate approvals being sent to users/contacts 
   List<Campaign_Gate_Approval_History__c> ch = [select name,Campaign_Team_Name__c from Campaign_Gate_Approval_History__c where Campaign_Phase__c = : oppGateId ];
   for(integer i=0;i<ch.size();i++)
   {
   team.add(ch[i].Campaign_Team_Name__c);
   }
    List<Campaign_Team__c> oppcon = [Select team_user__r.name,contact__r.name,contact__r.email,team_user__r.email,name from Campaign_Team__c where campaign__c=:oppId and name not in :team];
         
            System.debug('oppcon '+ oppcon);
            if(oppcon.size()==0)
            {
            showlist = false;
            backto = true;
            System.debug('campaign team nulllllll ');
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'There are no Campiagn Team Members for the Campaign '));
            }
            else
            {
            for(integer i=0;i<oppcon.size();i++)
            {
            System.debug('Contact role oppId -- > '+oppId);
            if(oppcon[i].team_user__c == null)
            {
            showlist = true;
            backto = false;
            wrapper.add(new Oppwrap(oppcon[i].contact__r.name,'Contact',oppcon[i].contact__r.email,oppcon[i].name));
            }
            if(oppcon[i].contact__c == null)
            {
            showlist = true;
            backto =false;
            wrapper.add(new Oppwrap(oppcon[i].team_user__r.name,'User',oppcon[i].team_user__r.email,oppcon[i].name));
            }
            }
        }
}
    public pagereference sendMail() {
    try{     
           System.debug('wrapper.size() -- > '+wrapper.size());
           for(Integer i=0;i<wrapper.size();i++){
           if(wrapper[i].selected==true && wrapper[i].Email==null)
    {   
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please select contact with email id '));
         return null;
    }
     //Code to insert records in Campaign_Gate_Approval_History__c object
            if(wrapper[i].selected==true && wrapper[i].Email!=null){
                
                showerror = true;
                Campaign_Gate_Approval_History__c aprec=new Campaign_Gate_Approval_History__c();
                aprec.Approval_Status__c='Pending';
                aprec.Campaign_Phase__c=oppGateId;
                aprec.Email__c=wrapper[i].Email;
                aprec.Approver_Email__c=wrapper[i].Email;
                aprec.Approver_Name__c=wrapper[i].Name;
                aprec.Campaign_Team_Name__c=wrapper[i].team;
                ApproveobjRec.add(aprec);
                
            }
            
            System.debug('wrapper[i].selected==true'+wrapper[i].selected);
        }
         if(ApproveobjRec.size()==0)
    {   
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please select atleast one Campaign Team Member '));
         return null;
    }
   
      Database.SaveResult[] lsr = Database.insert(ApproveobjRec,false);
      PageReference oppPage = new PageReference('/' + oppGateId);
      oppPage.setRedirect(true);
      return  oppPage;
       
       
       
      
    }
     catch(Exception e)    
          {   
                  System.debug('Exception............e'+e);   
           } 
         return null;
    }
   //Usage of wrapper class
public class Oppwrap{
     public boolean selected{get;set;}
     public String Name{get;set;}
     public String Obj{get;set;}
     public String Email{get;set;}
     public String team{get;set;}
     public Oppwrap(String Nm,String Ob,String mailId,String team){
          this.Name=Nm;
          this.Obj=Ob;
          this.Email=mailId;
          this.team=team;
          this.selected=true;
     }
 }
    public List<Oppwrap> getWrapper(){
        return this.wrapper;
    }
    public void setWrapper(List<Oppwrap> op){
        this.wrapper=op;
    }
    public PageReference Back()
    {
      PageReference oppPage = new PageReference('/' + oppId);
        return  oppPage; 
    }
    public PageReference cancelmail()
    {
      PageReference oppPage = new PageReference('/' + oppgateId);
        return  oppPage; 
    }
}