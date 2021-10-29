global Class AccountInner
{
    public boolean isSelected {get;set;}
    public boolean isConSelected {get;set;}
    public Related_Customer_Stories__c acc {get;set;}
    public contact  con{get;set;}
    
    public AccountInner(boolean isSelected, Related_Customer_Stories__c acc)
    {
        this.isSelected = isSelected;
        this.acc = acc;
    }
    public AccountInner(boolean isConSelected , contact con)
    {
        this.isConSelected = isConSelected ;
        this.con= con;
    }
}