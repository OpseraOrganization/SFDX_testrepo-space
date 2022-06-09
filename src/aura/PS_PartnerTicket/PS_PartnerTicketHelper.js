({
    resetField: function(component)
    {
        var internaluserFields=component.find("IntenralField");
        internaluserFields.forEach(function(item,index){
            item.reset();
        });  
    },
    checkFieldValidityForExternal: function(component)
    {
     var valid=true;
     var subject = component.find('subject');
     var desc = component.find('Description');
     var type = component.find('Type');
     var commLang = component.find('CommunitcationLang');
     if(!subject.get('v.validity').valid)
     {
     valid=false;
     subject.reportValidity();
     }
     else if (!desc.get('v.validity').valid )
     {
      valid=false;
      desc.reportValidity();   
     }
     else if (!type.get('v.validity').valid)
     {
      valid=false;
      type.reportValidity();    
     }
     else if (!commLang.get('v.validity').valid)
     {
      valid=false;
      commLang.reportValidity();    
     }
     return valid;
    }
  

})