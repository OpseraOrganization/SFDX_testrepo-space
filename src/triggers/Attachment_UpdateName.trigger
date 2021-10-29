/** * File Name: Attachment_UpdateName
* Description Trigger to copy the attahcment name to Planned Meeting field "Attachment Name" 
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger Attachment_UpdateName on Attachment(after delete, after insert, after update) {

//Variable Declaration
List<Attachment> attachlist = new List<Attachment>();
List<ID> pmidlist =new List<ID>();
List<Planned_Meeting__c> pmlist = new List<Planned_Meeting__c>();
List<Planned_Meeting__c> newpmlist = new List<Planned_Meeting__c>();
String attname='';

if(Trigger.isDelete)
{
attachlist = Trigger.old;
}
else
{
attachlist = Trigger.new;
}

//Getting the Planned Meeting IDs to a list
for(integer i=0;i<attachlist.size();i++)
{
	pmidlist.add(attachlist[i].parentid);
}

//Querying related Planned Meeting 
if(pmidlist.size()>0)
{
pmlist=[select id, name,Attachment_Name__c from Planned_Meeting__c where id in :pmidlist];
}

//Querying all the attachments related to the planned meeting
for(Attachment[] attlist :[select id,parentid,Name from Attachment where parentid in :pmidlist])
{
	for(Planned_Meeting__c pms : pmlist)
	  {
	      for(Attachment atts : attlist)
	        {
	  	     if(atts.parentid==pms.id)
	  	         {
	  	         	//Constructing the string to update the Attachment Name field
	  	         	attname= attname + atts.Name;
	  	         }
	  	      attname = attname + ',';
	         }
	      if(attname.length()>0 && attname !=null)
	        {
	         //Removing the comma at the end of the string
	         attname=attname.substring(0,attname.length()-1);       
	        }
	       //Updating the field  
	      pms.Attachment_Name__c = attname ;
	      newpmlist.add(pms);
	      attname='';
	  }   
}
//Updating Planned Meeting records
if(newpmlist.size()>0)
{
update newpmlist;
}

}