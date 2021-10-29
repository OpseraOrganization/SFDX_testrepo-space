public class HwTrng_SpclTrngForm_Cls {

    public HwTrng_SpclTrngForm_Cls(ApexPages.StandardController controller) {

    }
 
RecordType RecType = new RecordType();
QueueSobject QueueRec= new QueueSobject();
list<Contact> Cntlst = new list<Contact>();    
Case CaseNewRec=new case();
    
Public case getCaseNewRec()  
  {     
     return CaseNewRec;  
  }
Public void setCaseNewRec()  
  {     
     this.CaseNewRec=CaseNewRec;  
  }
    
public pagereference ClearForm()
  {
     Pagereference p = new pagereference('/apex/HwTrng_SpclTrngForm');
     return p.setredirect(true);
  }
   
public pagereference Save()
  {  
     RecType =[select id,name from recordtype where name='Training'];
     Case CaseTempRec= new case();
     Cntlst=[select id,name,email,Accountid from contact where email=:CaseNewRec.Requestor_Email_Address__c limit 1];
     
     //QueueRec=[Select SobjectType, QueueId, Id,name From QueueSobject where name='HwTrng_SpclTrng_Queue'];
     
     QueueRec= [Select Id, SobjectType, QueueId, Queue.Name from QueueSobject where SobjectType = 'Case' AND Queue.Name = 'Honeywell Training Administrators']; 
     CaseTempRec.Types_of_Training__c=CaseNewRec.Types_of_Training__c;
     CaseTempRec.Customer_Service_Level__c=CaseNewRec.Customer_Service_Level__c;
     if(CaseNewRec.Honeywell_Product_Area__c!='Select an area')
     {
     CaseTempRec.Honeywell_Product_Area__c=CaseNewRec.Honeywell_Product_Area__c;
     }
     else
     {
     CaseTempRec.Honeywell_Product_Area__c=Null;
     }
     CaseTempRec.Specific_Honeywell_Product_for_ur_requst__c=CaseNewRec.Specific_Honeywell_Product_for_ur_requst__c;
     if(CaseNewRec.Level_of_Training__c!='Select an area')
     {
     CaseTempRec.Level_of_Training__c=CaseNewRec.Level_of_Training__c;
     }
     else
     {
     CaseTempRec.Level_of_Training__c=Null;
     }
     CaseTempRec.Preferred_Date_for_Training__c=CaseNewRec.Preferred_Date_for_Training__c;
     CaseTempRec.Preferred_Date_for_Training__c=CaseNewRec.Preferred_Date_for_Training__c;
     if(CaseNewRec.Requested_Training_Location__c!='Select a location')
     {
     CaseTempRec.Requested_Training_Location__c=CaseNewRec.Requested_Training_Location__c;
     }
     else
     {
     CaseTempRec.Requested_Training_Location__c=Null;
     }
     CaseTempRec.Number_of_Students__c=CaseNewRec.Number_of_Students__c;
     CaseTempRec.Aircraft_Type_Model__c=CaseNewRec.Aircraft_Type_Model__c;
     CaseTempRec.Company__c=CaseNewRec.Company__c;
     CaseTempRec.Company_Street_Address__c=CaseNewRec.Company_Street_Address__c;
     CaseTempRec.City_Town__c=CaseNewRec.City_Town__c;
     CaseTempRec.State_Province__c=CaseNewRec.State_Province__c;
     CaseTempRec.Zip_Postal_Code__c=CaseNewRec.Zip_Postal_Code__c;
     CaseTempRec.Requestor_Name__c=CaseNewRec.Requestor_Name__c;
     CaseTempRec.Requestor_Email_Address__c=CaseNewRec.Requestor_Email_Address__c;
     CaseTempRec.Requestor_Telephone__c=CaseNewRec.Requestor_Telephone__c;
     CaseTempRec.Requestor_Fax__c=CaseNewRec.Requestor_Fax__c;
     CaseTempRec.Customer_Type__c=CaseNewRec.Customer_Type__c;
     CaseTempRec.Other_Customer_Type__c=CaseNewRec.Other_Customer_Type__c;
     CaseTempRec.Country__c=CaseNewRec.Country__c;
     CaseTempRec.Your_Field_Service_Engineering_Rep__c=CaseNewRec.Your_Field_Service_Engineering_Rep__c;
     CaseTempRec.Additional_Web_Form_Info__c=CaseNewRec.Additional_Web_Form_Info__c;
     CaseTempRec.recordtypeid=RecType.id;
     CaseTempRec.ownerid=QueueRec.QueueId;
     CaseTempRec.subject='Special training request';
     CaseTempRec.origin='Web';
     //Setting flag to sent notification email to the case owners
     CaseTempRec.Created_From_Form__c=True;
     
     //CaseTempRec.Priority='Urgent';
     if(Cntlst.size()>0)
        {
           CaseTempRec.Contactid=Cntlst[0].id;
           CaseTempRec.Accountid=Cntlst[0].Accountid;
        }
     insert CaseTempRec;
     Pagereference p = new pagereference('/apex/HwTrng_Thanku_VF');
     //Pagereference p = new pagereference('/'+CaseTempRec.id);
     return p;
  }
    
}