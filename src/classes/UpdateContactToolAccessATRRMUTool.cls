global class UpdateContactToolAccessATRRMUTool
{
    @future
    public static void updateCase(Map<id,string> updcse)
    {
       List<Case> updCase = new List<Case>([select status,id from Case where id in:updcse.keySet()]);
       for(Case cs:updCase)
       {          
           cs.status=updcse.get(cs.id);
       }
       update updCase;
    }    
}