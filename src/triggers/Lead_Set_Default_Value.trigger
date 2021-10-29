trigger Lead_Set_Default_Value on Lead (before insert) 
{
    try
    {
                for (Lead ld : Trigger.new)
                {   
                 //if(ld.recordtypeid == label.BGA_Honeywell_Prospect || ld.recordtypeid == label.BGA_Honeywell_Prospect_Convert))      
                    //ld.LeadSource = 'EBACE 2010';
                }
    }
    catch(Exception e)
    {
        
    }           
                
}