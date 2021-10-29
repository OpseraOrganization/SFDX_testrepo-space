trigger multipicklistUpdate on Voice_of_Customer__c (before insert) {
    for(Voice_of_Customer__c voc: Trigger.new){
    string oemvalue,productval,selectval;
    List<string>oem=new list<string>();
    List<string> product= new list<string>();
    List<string>selectedgroup= new list<string>();
    if(voc.Product_Family__c!=null && voc.Product_Family__c!='' && voc.Product_family__c.contains('['))
          productval= voc.Product_Family__c.substring(1,voc.Product_Family__c.length()-1);
    /*if(voc.selectedgroup__c!=null && voc.selectedgroup__c!='')
          selectval=voc.selectedgroup__c.substring(1,voc.selectedgroup__c.length()-1);
      if(selectval!=''&& selectval!=null)
         selectedgroup=selectval.split(',');*/
     if(trigger.isbefore)
     { 
     
     voc.Disposition__c='New';
       if(productval!='' && productval!=null)
           product = productval.split(',');
        integer i=1;
        integer j=1;
        
       for(string s:product)
        {
           system.debug('ssssssssssssss'+s);
           if(j==1)
           voc.Product_Family__c=s;
           else
           {
           string temp1=voc.Product_Family__c;
           system.debug(voc.Product_Family__c+'**********************'+temp1+';'+s);
           voc.Product_Family__c=temp1+';'+s;
           }
           
           j++;
          
        }
        //voc.ownerid=UserInfo.getUserId();
      }
    } 
}