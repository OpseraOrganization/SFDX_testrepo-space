/***************************************************
**File Name: DeliverableRecSelection_cls 
** Description: to select  reordtype for  in DeliverableItem object
**Company Name : Honeywell Aero
**Date Of Creation:26-Dec-2013
**Version No:0.01
**Created By:Manoj Kumar Jena
** 
*****************************************************/ 
public class DeliverableRecSelection_cls {
    public String ggpname{get;set;}
    public String ggpid{get;set;}
    public DeliverableRecSelection_cls(ApexPages.StandardController controller) {
       ggpname=apexpages.currentpage().getparameters().get('ggp');
       ggpid=apexpages.currentpage().getparameters().get('gid');
       //System.debug('********************************'+ggpname);
    }
   // public String ggpid=Apexpages.currentpage().getparameters().get('lkid');
    public  List<RecordType> recType= new List<RecordType>([select Name,Description from RecordType where SobjectType = 'Deliverable_Item__c' and (Name = 'SR Required' OR Name = 'SR Not Required' OR Name = 'ATR VOC')]);
    public String  selectval{get;set;}
    public List<SelectOption> getvalues() {
        List<SelectOption> options = new List<SelectOption>();
        for(RecordType reTyp : recType)
        options.add(new SelectOption(reTyp .name,reTyp .name));
        return options;
    }
    public List<RecordType> getRecType() {
        if(recType== null) recType= [select Name,Description from RecordType where SobjectType = 'Deliverable_Item__c' and (Name = 'SR Required' OR Name = 'SR Not Required' OR Name = 'ATR VOC') ];
        return recType;
    }
    public PageReference doContinue() {
        if(selectval== 'SR Required' ){
            Pagereference pageRef = new Pagereference('/apex/DeliverableItem?ggp='+ggpname+'&gid='+ggpid);
                pageRef .setredirect(true);
                return pageRef ;
         }else if(selectval== 'SR Not Required' ) {
            Pagereference pageRef  = new Pagereference('/a3g/e?CF00Na0000009RhZc='+ggpname+'&CF00Na0000009RhZc_lkid='+ggpid+'&retURL=%2F'+ggpid+'&RecordType=012a0000001ZJo7&ent=01Ia0000001u1Ti');
                pageRef .setredirect(true);
                return pageRef ;
        }else if(selectval== 'ATR VOC') {
            Pagereference pageRef  = new Pagereference('/a3g/e?CF00Na0000009RhZc='+ggpname+'&CF00Na0000009RhZc_lkid='+ggpid+'&retURL=%2F'+ggpid+'&RecordType=01213000001ZTCD&ent=01Ia0000001u1Ti');
                pageRef .setredirect(true);
                return pageRef ;
        }else return null;// QA ATR VOC record type id 012180000004KqA
    }
    public PageReference docancel(){
        PageReference pref=new PageReference('/'+ggpid);// This we can get once it is integrated with the button .
        pref.setRedirect(true);
        return pref;
    
    }
}