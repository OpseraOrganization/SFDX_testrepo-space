/** * File Name: Solution_afterInsert
* Description :Trigger to create solution categories
* Copyright : Wipro Technologies Limited Copyright (c) 2001 
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
trigger Solution_afterInsert on Solution (after insert,after update) {
List<CategoryNode> CategoryNodes= new List<CategoryNode>();
List<CategoryData> CategoryDatas= new List<CategoryData>();
List<CategoryData> CategoryDatasDelete= new List<CategoryData>();
List<String> category=new List<String>();
List<Id> deleteId=new List<Id>();
integer flag=0;
 for(Solution sol: Trigger.New){
 category.add(sol.Categorization__c);
     if(Trigger.IsUpdate){
      if(System.Trigger.NewMap.get(sol.Id).Categorization__c !=System.Trigger.OldMap.get(sol.Id).Categorization__c ){
      deleteId.add(sol.Id);

      }
      }
 }
 // for deleting changed category
 if(deleteId.size()>0){
 try{
  CategoryDatasDelete=[Select Id from  CategoryData  where RelatedSobjectId in:deleteId];
  }
 catch(Exception e){}
 if(CategoryDatasDelete.size()>0)
 delete(CategoryDatasDelete);
 }
 if(category.size()>0){
  CategoryNodes=[Select Id,MasterLabel from CategoryNode where MasterLabel in :category];
 }
  for(Solution sols: Trigger.New){
  flag=0;
  //for Insert of solutions
      if(Trigger.IsInsert)
      flag=1; 
    //if Categorization Changed  
      if(Trigger.IsUpdate){
      if(System.Trigger.NewMap.get(sols.Id).Categorization__c !=System.Trigger.OldMap.get(sols.Id).Categorization__c )
      flag=1;
      }
  if(flag==1){
     for(integer i=0;i<CategoryNodes.size();i++){
       if(sols.Categorization__c==CategoryNodes[i].MasterLabel){
       CategoryData data=new CategoryData();
       data.RelatedSobjectId=sols.Id;
       data.CategoryNodeId=CategoryNodes[i].Id;
       CategoryDatas.add(data);
       }// end of if
     }//end of for
  }// end of if   
  }// end of for
  if(CategoryDatas.size()>0)
  insert CategoryDatas;
}