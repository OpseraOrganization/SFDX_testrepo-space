/** * File Name: SendApprovalMail
* Description Controller for the visualforce page which displays the Opportunity team members for Phase approval and 
* inserts record in the Opportunity_Gate_Approval_History__c object
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 

public class SendApprovalMail {

public boolean showlist{get; set;}
public boolean backto{get; set;}
boolean showerror = false;
List<Oppwrap> wrapper=new List<Oppwrap>();
List<String> team = new List<String>();
 Opportunity_Gate__c og= new  Opportunity_Gate__c ();
List<Opportunity_Gate_Approval_History__c> ApproveobjRec=new List<Opportunity_Gate_Approval_History__c>();
public Id oppGateId;
public Id oppId;  

public SendApprovalMail(ApexPages.StandardController controller) {
    oppGateId = System.currentPageReference().getParameters().get('id');
  
    if(oppGateId != null)
    {
    og= [Select o.Opportunity__c, o.Id From Opportunity_Gate__c o where o.Id=: oppGateId];
        oppId=og.Opportunity__c;
        System.debug('oppId -- > '+oppId);
        }
 //Code to avoid duplicate approvals being sent to users/contacts       
 List<Opportunity_Gate_Approval_History__c> ch = [select name,Opportunity_Team_Name__c from Opportunity_Gate_Approval_History__c where Opportunity_Gate__c = : oppGateId ];
   for(integer i=0;i<ch.size();i++)
   {
   team.add(ch[i].Opportunity_Team_Name__c);
   }       
          
   List<Opportunity_Sales_Team__c> oppTem = [Select user__r.Name,User__r.Email,contact__r.Name,contact__r.Email,Name from Opportunity_Sales_Team__c where Opportunity__c=:oppId and name not in :team];
        
           if(oppTem.size()==0)
            {
            showlist = false;
            backto = true;
            System.debug('campaign team nulllllll ');
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'There are no Opportunity Team Members for the Opportunity '));
            }
            else
            {
            for(integer i=0;i<oppTem.size();i++)
            {
           if(oppTem[i].contact__r.Email!=null )
            {
            showlist = true;
            backto = false;
            wrapper.add(new Oppwrap(oppTem[i].contact__r.name,'Contact',oppTem[i].contact__r.email,oppTem[i].name));
            }
            if(oppTem[i].user__r.Email!=null)
            {
            showlist = true;
            backto =false;
            wrapper.add(new Oppwrap(oppTem[i].user__r.name,'User',oppTem[i].user__r.email,oppTem[i].name));
            }
            }
             }
        
        
    
}
    public pagereference sendMail() {
    
    try{     
            
        for(Integer i=0;i<wrapper.size();i++){
        if(wrapper[i].selected==true && wrapper[i].Email==null)
    {   
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please select contact with email id '));
         return null;
    }
    //Code to insert records in Opportunity_Gate_Approval_History__c object
             if(wrapper[i].selected==true && wrapper[i].Email!=null){
             showerror = true;
             System.debug('wrapper[i].selected -- > '+wrapper[i].selected);
              System.debug('wrapper[i].Email -- > '+wrapper[i].Email); 
              
                 Opportunity_Gate_Approval_History__c aprec=new Opportunity_Gate_Approval_History__c();
                aprec.Approval_Status__c='Pending';
                aprec.Opportunity_Gate__c=oppGateId;
                aprec.Email__c=wrapper[i].Email;
                aprec.Approver__c=wrapper[i].Email;
                aprec.Approver_Name__c=wrapper[i].Name;
                aprec.Opportunity_Team_Name__c=wrapper[i].team;
                ApproveobjRec.add(aprec);
                
            }
            
            System.debug('wrapper[i].selected==true'+wrapper[i].selected);
        }
        if(ApproveobjRec.size()==0)
        {
        System.debug('insidee.........................');
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please select a user or contact for sending Approval'));
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
    public pagereference  cancel()
    {
    PageReference oppPage = new PageReference('/' + oppGateId);
      oppPage.setRedirect(true);
      return  oppPage;
    
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
          this.selected=false;
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
}