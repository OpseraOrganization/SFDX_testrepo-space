trigger PreventCreatingCases on Case (before insert){
    /*commenting inactive trigger code to improve code coverage-----
    try{
    for(Case c : Trigger.new){
        
        if((c.SuppliedEmail!=null)&&(c.SuppliedEmail=='georgereaver@fgrrb.org')){
            c.addError('Spam Message should not create case!');
        }
        if((c.subject != null)&&(c.Subject.contains('How to Get Paid by Uncle Sam - Many New Topics and WAWF Demo'))){
            c.addError('Spam Message should not create case!');
        }
  }
  }
  catch(Exception e)
  {
  System.debug('Exception occured '+e);
  }*/
}