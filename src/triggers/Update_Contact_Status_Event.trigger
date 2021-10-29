Trigger Update_Contact_Status_Event on Event (Before Insert, Before Update) {
Map<ID,String> Eventmap =  new Map<ID,String>();
Set<ID> EventID = new Set<ID>();
List<Event> Newevent = new List<Event>();
List<Contact> Contactlist = new List<Contact>();
String Contactid;

    for(Event nevent : Trigger.new){
        if( nevent.recordtypeid != label.BGA_Event && nevent.Whoid != null){
        Contactid =nevent.Whoid; 
        Contactid = Contactid.substring(0,3);
            if(Contactid == '003'){
            EventID.add(nevent.whoid);
            Newevent.add(nevent); 
            }
        }
    }
    
    if(EventID.size()>0){ 
        Contactlist = [Select Name, Id, Contact_Status__c from Contact where ID in : EventID];
    }

    if(Contactlist.size()>0){
        for(Contact newconlist :Contactlist ){
        Eventmap.put(newconlist.id,newconlist.contact_status__c);
        } 
    }
    
    if(Newevent.size()>0){
        for(Event eventlist : Newevent){
        eventlist.contact_status__c = Eventmap.get(eventlist.whoid);
        }
    }   
}