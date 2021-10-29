public with sharing class AreaASMChartController {

/*
*   This class is controller to (asmregions.page) (BGA ASMs and country ampping chart). Also contains remote action called from javascript.
*   Ticket#338315
*/
    @RemoteAction
    public static MyInterface getContactDetails(MyInterface qryInput){
            
            //qryInput contains parameter as country code and state code (only for US (and Canada))
        
            ReturnDataSet myc = new ReturnDataSet();
            try{
            myc.setAsmCountry(qryInput.getAsmCountry());
            BGA_Area_Contacts__c bgaASMDetls = null;
            
            //if region selected as US
            if(qryInput.getAsmCountry() == 'US'){
                // set state code
                myc.setAsmState(qryInput.getAsmState());
                // Query ASM mapping details
                bgaASMDetls = getASMDetails(myc.getAsmCountry(),myc.getAsmState());
                    if(bgaASMDetls != null){                
                        myc.setAsmState(bgaASMDetls.State__c);
                    }
            }
            
            //if region selected as CA
            if(qryInput.getAsmCountry() == 'CA'){
                // set state code
                myc.setAsmState(qryInput.getAsmState());
                // Query ASM mapping details
                bgaASMDetls = getASMDetails(myc.getAsmCountry(),myc.getAsmState());
                    if(bgaASMDetls != null){                
                        myc.setAsmState(bgaASMDetls.State__c);
                    }
            }
            //if other region selected
            else{
                // Query ASM mapping details
                bgaASMDetls = getASMDetails(myc.getAsmCountry());
                    // Query ASM user details
                    if(bgaASMDetls != null){
                        myc.setAsmCountry(bgaASMDetls.Country__c);
                    }
            }
            // if Mapping found
            if(bgaASMDetls != null){
                            String asm1Id = null;
                            String asm2Id = null;
                            
                                    // If two ASMs exists for same region then split names and IDs on ';'
                                    if(bgaASMDetls.SFDC_ID__c.contains(';')){
                                        asm1Id = bgaASMDetls.SFDC_ID__c.split(';')[0];
                                        asm2Id = bgaASMDetls.SFDC_ID__c.split(';')[1];
                                        
                                        if(bgaASMDetls.specialMessage__c != null){
                                            myc.setSecialMsg(bgaASMDetls.specialMessage__c);
                                        }
                                        
                                    }
                                    else{
                                        asm1Id = bgaASMDetls.SFDC_ID__c;
                                    }
                            
                            //Query ASM1,ASM2 user details
                            if(asm1Id != null){
                                List<User> usrDetl = [select Name,Email,Phone,Extension,MobilePhone,Fax,FullPhotoUrl from user where Id= :asm1Id];
                                            myc.setAsmName(usrDetl[0].Name);
                                            myc.setAsmEmail(usrDetl[0].Email);
                                            myc.setAsmPhone(usrDetl[0].Phone);
                                            myc.setAsmMobile(usrDetl[0].MobilePhone);
                                            myc.setAsmPhoneExtn(usrDetl[0].Extension);
                                            myc.setAsmFax(usrDetl[0].Fax);
                                            myc.setAsmPhoto(usrDetl[0].FullPhotoUrl);
                            }  
                            
                            if(asm2Id != null){
                                    List<User> usrDetl = [select Name,Email,Phone,Extension,MobilePhone,Fax,FullPhotoUrl from user where Id= :asm2Id];
                                                myc.setAsm2Name(usrDetl[0].Name);
                                                myc.setAsm2Email(usrDetl[0].Email);
                                                myc.setAsm2Phone(usrDetl[0].Phone);
                                                myc.setAsm2Mobile(usrDetl[0].MobilePhone);
                                                myc.setAsm2PhoneExtn(usrDetl[0].Extension);
                                                myc.setAsm2Fax(usrDetl[0].Fax);
                                                myc.setAsm2Photo(usrDetl[0].FullPhotoUrl);
                                }               
                            
                            if(bgaASMDetls.Technical_Support_IDs__c != null){
                                    List<User> usrDetl = [select Name,Email,Phone,Extension,MobilePhone,Fax,FullPhotoUrl from user where Id= :bgaASMDetls.Technical_Support_IDs__c];
                                                myc.setTechName(usrDetl[0].Name);
                                                myc.setTechEmail(usrDetl[0].Email);
                                                myc.setTechPhone(usrDetl[0].Phone);
                                                myc.setTechMobile(usrDetl[0].MobilePhone);
                                                myc.setTechPhoneExtn(usrDetl[0].Extension);
                                                myc.setTechFax(usrDetl[0].Fax);
                                                myc.setTechPhoto(usrDetl[0].FullPhotoUrl);
                                }  
                              
            }
            
            return myc;
            
            }
            catch(Exception e){
                return null;
            }
        
    }

    public static BGA_Area_Contacts__c getASMDetails(String countryName,String stateName){
        
                    List<BGA_Area_Contacts__c> retData = [select 
                            State__c,
                            Country__c,
                            StateCode__c,
                            SFDC_ID__c,
                            specialMessage__c ,
                            Technical_Support_IDs__c
                            from 
                            BGA_Area_Contacts__c
                            where StateCode__c = :stateName
                            LIMIT 1
                        ];
                
                if(retData != null && retData.size() > 0){
                    return retData[0];
                }
                else{
                    return null;
                }   
                    
    }
    
    public static BGA_Area_Contacts__c getASMDetails(String countryName){
        
                    List<BGA_Area_Contacts__c> retData = [select 
                            State__c,
                            Country__c,
                            StateCode__c,
                            SFDC_ID__c,
                            specialMessage__c ,
                            Technical_Support_IDs__c
                            from 
                            BGA_Area_Contacts__c
                            where Country_Code__c = :countryName 
                            LIMIT 1
                        ];
                
                if(retData != null && retData.size() > 0){
                    return retData[0];
                }
                else{
                    return null;
                }       
                        
    }
    
    public List<BGA_Area_Contacts__c> getAsmListUS(){
        return [
                                                        select 
                                                                Name__c,
                                                                State__c,
                                                                Country__c,
                                                                StateCode__c,
                                                                SFDC_ID__c,
                                                                specialMessage__c,
                                                                Country_Code__c 
                                                        from 
                                                        BGA_Area_Contacts__c
                                                        where Country__c = 'US'
                                                        and Country_Code__c != ''
                                                        order by State__c
                                                    ];
    }
    
    //Canada- adding this section based on Alejandra Lopez's requirement
    
    public List<BGA_Area_Contacts__c> getAsmListCA(){
        return [
                                                        select 
                                                                Name__c,
                                                                State__c,
                                                                Country__c,
                                                                StateCode__c,
                                                                SFDC_ID__c,
                                                                specialMessage__c,
                                                                Country_Code__c 
                                                        from 
                                                        BGA_Area_Contacts__c
                                                        where Country__c = 'CA'
                                                        and Country_Code__c != ''
                                                        order by State__c
                                                    ];
    }

    public List<BGA_Area_Contacts__c> getAsmListOthers(){
        return  [
                                                        select 
                                                                Name__c,
                                                                State__c,
                                                                Country__c,
                                                                StateCode__c,
                                                                SFDC_ID__c,
                                                                specialMessage__c,
                                                                Country_Code__c 
                                                        from 
                                                        BGA_Area_Contacts__c
                                                        where Country__c <> 'US'
            											and Country__c <> 'CA'
                                                        and Country_Code__c != ''
                                                        order by Country__c
                                                    ];
    }       
    
    //Interface for remote action parameters
    public interface MyInterface { 
                String getAsmState();
                String getAsmCountry();
        
                String getAsmName(); 
                String getAsmEmail(); 
                String getAsmPhone(); 
                String getAsmPhoneExtn(); 
                String getAsmMobile(); 
                String getAsmFax(); 
                String getAsmPhoto(); 

                String getAsm2Name(); 
                String getAsm2Email(); 
                String getAsm2Phone(); 
                String getAsm2PhoneExtn(); 
                String getAsm2Mobile(); 
                String getAsm2Fax(); 
                String getAsm2Photo(); 
                String getSecialMsg();
                
                String getTechName(); 
                String getTechEmail(); 
                String getTechPhone(); 
                String getTechPhoneExtn(); 
                String getTechMobile(); 
                String getTechFax(); 
                String getTechPhoto(); 

        }
    //Implementation for remote parameters interface
    public class ReturnDataSet implements MyInterface { 
        
                private String asmName;
                private String asmEmail;
                private String asmPhone;
                private String asmPhoneExtn;
                private String asmMobile;
                private String asmFax;
                private String asmPhoto;
                                
                
                private String asmState;
                private String asmCountry;   
                
                public String getAsmState() {
                return asmState;
                }
                public void setAsmState(String s) {
                    asmState = s;
                }
                public String getAsmCountry() {
                    return asmCountry;
                }
                public void setAsmCountry(String s) {
                    asmCountry = s;
                }
                public String getAsmName() {
                    return asmName;
                }
                public void setAsmName(String s) {
                    asmName = s;
                }
                public String getAsmEmail() {
                    return asmEmail;
                }
                public void setAsmEmail(String s) {
                    asmEmail = s;
                }
                public String getAsmPhone() {
                    return asmPhone;
                }
                public void setAsmPhone(String s) {
                    asmPhone = s;
                }
                public String getAsmPhoneExtn() {
                    return asmPhoneExtn;
                }
                public void setAsmPhoneExtn(String s) {
                    asmPhoneExtn = s;
                }
                public String getAsmMobile() {
                    return asmMobile;
                }
                public void setAsmMobile(String s) {
                    asmMobile = s;
                }
                public String getAsmFax() {
                    return asmFax;
                }
                public void setAsmFax(String s) {
                    asmFax = s;
                }
                public String getAsmPhoto() {
                    return asmPhoto;
                }
                public void setAsmPhoto(String s) {
                    asmPhoto = s;
                }
                
                 public String getTechName() {
                    return techName;
                }
                public void setTechName(String techName) {
                    this.techName = techName;
                }
                public String getTechEmail() {
                    return techEmail;
                }
                public void setTechEmail(String techEmail) {
                    this.techEmail = techEmail;
                }
                public String getTechPhone() {
                    return techPhone;
                }
                public void setTechPhone(String techPhone) {
                    this.techPhone = techPhone;
                }
                public String getTechPhoneExtn() {
                    return techPhoneExtn;
                }
                public void setTechPhoneExtn(String techPhoneExtn) {
                    this.techPhoneExtn = techPhoneExtn;
                }
                public String getTechMobile() {
                    return techMobile;
                }
                public void setTechMobile(String techMobile) {
                    this.techMobile = techMobile;
                }
                public String getTechFax() {
                    return techFax;
                }
                public void setTechFax(String techFax) {
                    this.techFax = techFax;
                }
                public String getTechPhoto() {
                    return techPhoto;
                }
                public void setTechPhoto(String techPhoto) {
                    this.techPhoto = techPhoto;
                }
                private String techName;
                private String techEmail;
                private String techPhone;
                private String techPhoneExtn;
                private String techMobile;
                private String techFax;
                private String techPhoto;   
                
                public String getAsm2Name() {
                    return asm2Name;
                }
                public void setAsm2Name(String asm2Name) {
                    this.asm2Name = asm2Name;
                }
                public String getAsm2Email() {
                    return asm2Email;
                }
                public void setAsm2Email(String asm2Email) {
                    this.asm2Email = asm2Email;
                }
                public String getAsm2Phone() {
                    return asm2Phone;
                }
                public void setAsm2Phone(String asm2Phone) {
                    this.asm2Phone = asm2Phone;
                }
                public String getAsm2PhoneExtn() {
                    return asm2PhoneExtn;
                }
                public void setAsm2PhoneExtn(String asm2PhoneExtn) {
                    this.asm2PhoneExtn = asm2PhoneExtn;
                }
                public String getAsm2Mobile() {
                    return asm2Mobile;
                }
                public void setAsm2Mobile(String asm2Mobile) {
                    this.asm2Mobile = asm2Mobile;
                }
                public String getAsm2Fax() {
                    return asm2Fax;
                }
                public void setAsm2Fax(String asm2Fax) {
                    this.asm2Fax = asm2Fax;
                }
                public String getAsm2Photo() {
                    return asm2Photo;
                }
                public void setAsm2Photo(String asm2Photo) {
                    this.asm2Photo = asm2Photo;
                }
                
                public String getSecialMsg() {
                    return asm2Photo;
                }
                public void setSecialMsg(String secialMsg) {
                    this.secialMsg = secialMsg;
                }               
                private String asm2Name;
                private String asm2Email;
                private String asm2Phone;
                private String asm2PhoneExtn;
                private String asm2Mobile;
                private String asm2Fax;
                private String asm2Photo;       
                private String secialMsg;       
        
    }
    
    //testing code
    @isTest
    public static void testCodeCoverage(){
        
        AreaASMChartController aacc = new AreaASMChartController();
        aacc.getAsmListOthers();
        aacc.getAsmListUS();
        
        ReturnDataSet rds = new ReturnDataSet();    
        rds.setAsmCountry('US');
        rds.setAsmState('CA');
        AreaASMChartController.getContactDetails(rds);
        rds = new ReturnDataSet();  
        rds.setAsmCountry('IN');
        AreaASMChartController.getContactDetails(rds);
                rds.setAsmState('test');
                rds.setAsmCountry('test');
                rds.setAsmName('test'); 
                rds.setAsmEmail('test'); 
                rds.setAsmPhone('test'); 
                rds.setAsmPhoneExtn('test'); 
                rds.setAsmMobile('test'); 
                rds.setAsmFax('test'); 
                rds.setAsmPhoto('test'); 
                rds.setAsm2Name('test'); 
                rds.setAsm2Email('test'); 
                rds.setAsm2Phone('test'); 
                rds.setAsm2PhoneExtn('test'); 
                rds.setAsm2Mobile('test'); 
                rds.setAsm2Fax('test'); 
                rds.setAsm2Photo('test'); 
                rds.setSecialMsg('test');
                rds.setTechName('test'); 
                rds.setTechEmail('test'); 
                rds.setTechPhone('test'); 
                rds.setTechPhoneExtn('test'); 
                rds.setTechMobile('test'); 
                rds.setTechFax('test'); 
                rds.setTechPhoto('test'); 
                rds.getAsmState();
                rds.getAsmCountry();
                rds.getAsmName(); 
                rds.getAsmEmail(); 
                rds.getAsmPhone(); 
                rds.getAsmPhoneExtn(); 
                rds.getAsmMobile(); 
                rds.getAsmFax(); 
                rds.getAsmPhoto(); 
                rds.getAsm2Name(); 
                rds.getAsm2Email(); 
                rds.getAsm2Phone(); 
                rds.getAsm2PhoneExtn(); 
                rds.getAsm2Mobile(); 
                rds.getAsm2Fax(); 
                rds.getAsm2Photo(); 
                rds.getSecialMsg();
                rds.getTechName(); 
                rds.getTechEmail(); 
                rds.getTechPhone(); 
                rds.getTechPhoneExtn(); 
                rds.getTechMobile(); 
                rds.getTechFax(); 
                rds.getTechPhoto(); 
                
    }    
}