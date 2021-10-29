trigger updateAircraftDetails on Contact (before update) 
{
   //invoke this class on before update of contact records.
   if(Trigger.isBefore && Trigger.isUpdate)
   {
    updateContactAircraftDetails cad = new updateContactAircraftDetails();
    cad.updateAircraftDetails(Trigger.new,Trigger.oldMap);
    }
}