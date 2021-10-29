public without sharing class HIPIUnitIdentifierCtrl{
 public String sbg{get;set;}
 public String sbu{get;set;}
 public String sbe{get;set;}
 public String grp{get;set;}
 public String line{get;set;}
 public String type{get;set;}
 public String spc{get;set;}
 public String allocation{get;set;}
 
 public HIPIUnitIdentifierCtrl(ApexPages.StandardController controller) { 
 
 }
public String getvalues()
{
    sbg='AERO';
    sbu='BGA';
    sbe='Aero Services';
    grp='Maintenance Services';
    line='Ground Support Solutions';
    type='Ground Support Solutions';
    spc='2001000007';
    allocation='100';
    return sbg;
    return sbu;
    return sbe;
    return grp;
    return line;
    return type;
    return spc;
    return allocation;
   
}
}