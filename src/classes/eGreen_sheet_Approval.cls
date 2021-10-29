/**
Updated by Honeywell team for ticket#240 on 12/14/2017.
**/
public class eGreen_sheet_Approval {
    list < Workflow_details__c > WFList = new list < Workflow_details__c > ();
    List < WorkFlow_Approval_History__c > ApproveobjRec = new List < WorkFlow_Approval_History__c > ();
    List < WorkFlow_Approval_History__c > ApproveobjRec1 = new List < WorkFlow_Approval_History__c > ();
    List < WorkFlow_Approval_History__c > Approveobj = new List < WorkFlow_Approval_History__c > ();
    List < WorkFlow_Approval_History__c > ApproveobjRec2 = new List < WorkFlow_Approval_History__c > ();
    List < WorkFlow_Notification_History__c > notifyobj = new List < WorkFlow_Notification_History__c > ();
    list < string > suggesttierlst = new list < string > ();
    WorkFlow_Approval_History__c objComm = new WorkFlow_Approval_History__c();
    WorkFlow_Approval_History__c objComm1 = new WorkFlow_Approval_History__c();
    list < string > lstofAPP = new list < string > ();
    list < string > lstofAP = new list < string > ();
    list < string > lstofAPP2 = new list < string > ();
    list < string > lstofAP3 = new list < string > ();
    string user2;


    Workflow_details__c WFRec = new Workflow_details__c();
    //list<Approver__c> Alist=new  list<Approver__c>();
    list <Approver__c> Alist = new list < Approver__c > ();
    Set < ID > dupBusUser = new Set < ID > ();
    Set < ID > dupContUser = new Set < ID > ();
    Set < ID > dupFinUser = new Set < ID > ();
    Set < ID > dupProductUser = new Set < ID > ();
    Set < ID > dupMpmUser = new Set < ID > ();
    Set < ID > dupNotUser = new Set < ID > ();
    Set <ID> dupAdditionalUser = new Set <ID>();

    list < Approver__c > BusinessSort = new list < Approver__c > ();
    list < Approver__c > ContractSort = new list < Approver__c > ();
    list < Approver__c > FinanceSort = new list < Approver__c > ();
    list < Approver__c > ProductSort = new list < Approver__c > ();
    list < Approver__c > MPMSort = new list < Approver__c > ();
    list < Approver__c > NotificationSort = new list < Approver__c > ();
    list <Approver__c> AdditionalSort = new list <Approver__c> ();

    list < Approver__c > bus_app = new list < Approver__c > ();
    list < Approver__c > con_app = new list < Approver__c > ();
    list < Approver__c > fin_app = new list < Approver__c > ();
    list < Approver__c > not_app = new list < Approver__c > ();
    list < Approver__c > mpm_app = new list < Approver__c > ();
    list<Approver__c> additional_app = new list<Approver__c>();

    list < Approver__c > bus_app1 = new list < Approver__c > ();
    list < Approver__c > con_app1 = new list < Approver__c > ();
    list < Approver__c > fin_app1 = new list < Approver__c > ();
    list < Approver__c > mpm_app1 = new list < Approver__c > ();
    list < Approver__c > not_app1 = new list < Approver__c > ();
    list<Approver__c> additional_app1 = new list<Approver__c>();

    Save_As_Draft__c saveAsDrft = new Save_As_Draft__c();
    Map < id, Approver__c > SveAsMap = new Map < id, Approver__c > ();
    //string user2;
    list < integer > intlist = new list < integer > ();
    boolean flag = false;
    //List<SelectOption> options1 = new List<SelectOption>();
    String region0, region1, region2, region3, region4;
    Approver__c CurrApp = new Approver__c();

    List < server_details__c > lstSrvDet = server_details__c.getall().values();

    string strSrvName = lstSrvDet[0].servername__c;

    public string status {
        get;
        set;
    }
    public string Tier {
        get;
        set;
    }

    Map < string, Approver__c > Applstbusiness = new Map < string, Approver__c > ();

    Map < id, Approver__c > ApplstContract = new Map < id, Approver__c > ();
    Map < id, Approver__c > ApplstFinance = new Map < id, Approver__c > ();
    Map < id, Approver__c > Applstmpm = new Map < id, Approver__c > ();
    Map < id, Approver__c > ApplstNotification = new Map < id, Approver__c > ();
    public id Wfid; {
        WFId = System.currentPageReference().getParameters().get('id');
        WFList = [select Product_SBU__c,Approval_Level_Required__c,Sales_Channel__c,Approver_Business_Unit__c, Airbus_c__c, Wokflow_Name__c, Global__c, Airlines_c__c, Name, Documentum__c, owner.name, Requester_s_Comments__c, ATR_c__c, BG_A_OE_c__c, BG_A_c__c, Boeing_c__c, RACC_c__c, Defence_Space_c__c, Defence_Space_OE_c__c, HIS_c__c, HTSI_c__c, HTSI_OE_c__c, Approval_Level_in_Progress__c, ATR__c, Airlines__c, Ownerid, Business_Unit__c, Sales_K__c, X5_Year_Revenue_K__c, Customer_Name__r.name, Front_End_Loss__c, Front_End_Loss_Max_Year__c, Exposed_Cost__c, Exposed_Cost_Max_Year_K__c, Terms_and_Conditions__c, Atlas_or_P_DR__c, Opportunity_number__c, Airbus__c, Status__c, BG_A__c, BG_A_OE__c, Boeing__c, Defence_Space__c, Defence_Space_OE__c, HIS__c, HTSI__c, HTSI_OE__c, RACC__c, Americas__c, APAC__c, EMEAI__c, Middle_East_APU_s_Only__c from Workflow_details__c where id =: WFId];
    }
    public eGreen_sheet_Approval(ApexPages.StandardController controller) {
        //WFId = System.currentPageReference().getParameters().get('id');
        //WFList=[select Approver_Business_Unit__c, Airbus_c__c,Wokflow_Name__c,Global__c,Airlines_c__c,Name,Documentum__c,owner.name,Requester_s_Comments__c,ATR_c__c,BG_A_OE_c__c,BG_A_c__c,Boeing_c__c,RACC_c__c,Defence_Space_c__c,Defence_Space_OE_c__c,HIS_c__c,HTSI_c__c,HTSI_OE_c__c,Approval_Level_in_Progress__c,ATR__c,Airlines__c,Ownerid,Business_Unit__c ,Sales_K__c,X5_Year_Revenue_K__c,Customer_Name__r.name,Front_End_Loss__c,Front_End_Loss_Max_Year__c,Exposed_Cost__c,Exposed_Cost_Max_Year_K__c,Terms_and_Conditions__c,Atlas_or_P_DR__c,Airbus__c,Status__c,BG_A__c,BG_A_OE__c,Boeing__c,Defence_Space__c,Defence_Space_OE__c,HIS__c,HTSI__c,HTSI_OE__c,RACC__c,Americas__c,APAC__c,EMEAI__c,Middle_East_APU_s_Only__c from Workflow_details__c where id=:WFId];
        Tier = WFList[0].Approval_Level_in_Progress__c;
        status = WFList[0].Status__c;
        user2 = WFList[0].Ownerid;
        /************************************** Checking for all required inputs ************************************************/


        if (WFList[0].ATR__c == false && WFList[0].BG_A_OE__c == false && WFList[0].Defence_Space_OE__c == false && WFList[0].HTSI_OE__c == false && WFList[0].Airbus__c == false && WFList[0].Airlines__c == false && WFList[0].BG_A__c == false && WFList[0].Boeing__c == false && WFList[0].RACC__c == false && WFList[0].Defence_Space__c == false && WFList[0].HIS__c == false && WFList[0].HTSI__c == false) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select a BU to generate the approver list'));
        }

        if (WFList[0].Americas__c == false && WFList[0].APAC__c == false && WFList[0].EMEAI__c == false && WFList[0].Middle_East_APU_s_Only__c == false && WFList[0].Global__c == false) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select a Region to generate the approver list'));
        }

        if(WFList[0].Product_SBU__c == null || WFList[0].Sales_Channel__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select a Sales Channel and Product SBU to generate the approver list'));
        }
        if (status == 'In progress') {
            // change made for INC000005812699
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot generate approver list for eGreensheet with status "In Progress" '));
        }

        /************************* Checking for the region *******************************************/
        if (WFList[0].Americas__c)
            region0 = 'Americas';
        if (WFList[0].APAC__c)
            region1 = 'APAC';
        if (WFList[0].Global__c)
            region2 = 'Global';
        if (WFList[0].EMEAI__c)
            region3 = 'EMEAI';
        if (WFList[0].Middle_East_APU_s_Only__c)
            region4 = 'MiddleEast-APU only';

        /********************************** Checking for the Tier level in progress *******************************/

        string progress_level = WFList[0].Approval_Level_in_Progress__c;
        list < string > p_level1 = progress_level.split('Tier');
        string plevel = 'Tier' + p_level1[1];
        system.debug('DDDDDDDDDDDD' + plevel);

        /*************************************** Quering the required Approvers *****************************************/

        Alist = [select Tier__c,Product_SBU__c,Sales_Channel__c,id, Approver_Name__r.lastname,Approver_Name__r.firstname,Approver_Name__r.name, Approver_type__c, Name from Approver__c where Tier__c like: '%' + plevel and(Region__c like: region0 or Region__c like: region1 or Region__c like: region2 or Region__c like: region3 or Region__c like: region4) and(Business_Unit__c like: WFList[0].Airbus_c__c or Business_Unit__c like: WFList[0].Airlines_c__c or Business_Unit__c like: WFList[0].ATR_c__c or Business_Unit__c like: WFList[0].BG_A_OE_c__c or Business_Unit__c like: WFList[0].BG_A_c__c or Business_Unit__c like: WFList[0].Boeing_c__c or Business_Unit__c like: WFList[0].RACC_c__c or Business_Unit__c like: WFList[0].Defence_Space_c__c or Business_Unit__c like: WFList[0].Defence_Space_OE_c__c or Business_Unit__c like: WFList[0].HIS_c__c or Business_Unit__c like: WFList[0].HTSI_c__c or Business_Unit__c like: WFList[0].HTSI_OE_c__c) and(Active__c = TRUE) order by Approver_Name__r.lastname];
        system.debug('wwwwwwwwwwwww' + Alist);
        not_app1 = [select Tier__c,Product_SBU__c,Sales_Channel__c,id, Approver_Name__r.lastname,Approver_Name__r.firstname,Approver_Name__r.name, Approver_type__c from Approver__c where Approver_Name__r.name != null and Approver_type__c = 'Notification'
        order by Approver_Name__r.lastname
        ];

        /************************************Segregating the approvers based on their type *************************************/

        for (integer j = 0; j < Alist.size(); j++) {
            if (Alist[j].Approver_type__c == 'Business Approver') {
                //Applstbusiness.put(Alist[j].Approver_Name__r.id,Alist[j]);
                if (!(dupBusUser.contains(Alist[j].Approver_Name__r.id))) {
                    //Newly added code for ticket#:240
                    system.debug('Alist[j].Sales_Channel__c :'+Alist[j].Sales_Channel__c );
                    system.debug('WFList[0].Sales_Channel__c :'+WFList[0].Sales_Channel__c );
                    system.debug('Alist[j].Tier__c :'+Alist[j].Tier__c);
                    system.debug('WFList[0].Approval_Level_in_Progress__c :'+WFList[0].Approval_Level_in_Progress__c);
                    if(Alist[j].Sales_Channel__c == WFList[0].Sales_Channel__c && Alist[j].Tier__c  == WFList[0].Approval_Level_in_Progress__c){
                        if (Alist[j] != null) {
                            BusinessSort.add(Alist[j]);
                            dupBusUser.add(Alist[j].Approver_Name__r.id);
                            system.debug('uuuuuuuu' + dupBusUser);
                        }
                    }
                }
                system.debug('aaaaaaaa' + BusinessSort);
            }

            if (Alist[j].Approver_type__c == 'Contract Approver') {
                //ApplstContract.put(Alist[j].Approver_Name__r.id,Alist[j]);
                if (!(dupContUser.contains(Alist[j].Approver_Name__r.id))) {
                    //Newly added code for ticket#:240
                    if(Alist[j].Sales_Channel__c == WFList[0].Sales_Channel__c && Alist[j].Tier__c  == WFList[0].Approval_Level_in_Progress__c){
                        if (Alist[j] != null) {
                            ContractSort.add(Alist[j]);
                            dupContUser.add(Alist[j].Approver_Name__r.id);
                        }
                    }
                }
                system.debug('aaaaaaaa' + ContractSort);
            }

            if (Alist[j].Approver_type__c == 'Finance Approver') {
                //ApplstFinance.put(Alist[j].Approver_Name__r.id,Alist[j]);
                if (!(dupFinUser.contains(Alist[j].Approver_Name__r.id))){
                    //Newly added code for ticket#:240
                    if(Alist[j].Sales_Channel__c == WFList[0].Sales_Channel__c && Alist[j].Tier__c  == WFList[0].Approval_Level_in_Progress__c){
                        if (Alist[j] != null) {
                            FinanceSort.add(Alist[j]);
                            dupFinUser.add(Alist[j].Approver_Name__r.id);
                        }
                    }
                }
                system.debug('aaaaaaaa' + FinanceSort);
            }

            if (Alist[j].Approver_type__c == 'Additional Approver') {
                if (!(dupAdditionalUser.contains(Alist[j].Approver_Name__r.id))){
                    if(Alist[j].Sales_Channel__c == WFList[0].Sales_Channel__c && Alist[j].Tier__c  == WFList[0].Approval_Level_in_Progress__c){
                        if (Alist[j] != null) {
                            AdditionalSort.add(Alist[j]);
                            dupAdditionalUser.add(Alist[j].Approver_Name__r.id);
                        }
                    }
                }
                system.debug('aaaaaaaa' + AdditionalSort);
            }

            //Newly added code for ticket#:240
            if (Alist[j].Approver_type__c == 'Product Approver') {
                if (!(dupProductUser.contains(Alist[j].Approver_Name__r.id))){
                    if(Alist[j].Product_SBU__c!=null && WFList[0].Product_SBU__c!=null && WFList[0].Product_SBU__c.contains(Alist[j].Product_SBU__c) && Alist[j].Tier__c  == WFList[0].Approval_Level_in_Progress__c){
                        if (Alist[j] != null) {
                            ProductSort.add(Alist[j]);
                            dupProductUser.add(Alist[j].Approver_Name__r.id);
                        }
                    }
                }
                system.debug('ProductSort aaaaaaaa' + ProductSort);
            }

            /*if (Alist[j].Approver_type__c == 'M&PM Approver') {
                //Applstmpm.put(Alist[j].Approver_Name__r.id,Alist[j]);
                if (!(dupMpmUser.contains(Alist[j].Approver_Name__r.id))) {
                    if (Alist[j] != null) {
                        MPMSort.add(Alist[j]);
                        dupMpmUser.add(Alist[j].Approver_Name__r.id);
                    }
                }
                system.debug('aaaaaaaa' + ContractSort);
            }*/
        }

        system.debug('164########' + not_app1.size());
        for (integer j = 0; j < not_app1.size(); j++) {
            ApplstNotification.put(not_app1[j].Approver_Name__r.id,not_app1[j]);
            system.debug('168########' + not_app1[j].Approver_Name__c);
            if (!(dupNotUser.contains(not_app1[j].Approver_Name__r.id))) {
                if (not_app1[j] != null) {
                    NotificationSort.add(not_app1[j]);
                    dupNotUser.add(not_app1[j].Approver_Name__r.id);
                }
            }
            system.debug('173########' + NotificationSort);
            system.debug('174########' + dupNotUser);
        }


    }

    /************************************** Checking for User privilege ***********************************************/

    public Boolean VarConf1 {
        get;
        set;
    } {
        string user1 = Userinfo.getuserid();
        WFId = System.currentPageReference().getParameters().get('id');
        WfRec = [select ownerid from Workflow_details__c where id =: WFId];
        user2 = WfRec.ownerid;
        if (user1 == user2)
            VarConf1 = True;
        else {
            VarConf1 = False;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Insufficient Privilege'));

        }

    }

    /******************************************** First Picklist For Business Approver ****************************/

    String LstVal1;
    public string getoptions1() {

        return LstVal1;
    }
    public void setoptions1(string LstVal1) {

        this.LstVal1 = LstVal1;


    }
    public list < SelectOption > getUserList1() {
        List < SelectOption > options1 = new List < SelectOption > ();
        options1.add(new SelectOption('None', 'None'));
        for (Approver__c apprs: BusinessSort) {
            if (apprs.Approver_Name__r.name != null) {
                options1.add(new SelectOption(apprs.id, apprs.Approver_Name__r.lastname+', '+apprs.Approver_Name__r.firstname));
            }
        }

        /*for(Approver__c apprs: BusinessSort)
        {
        options1.add(new SelectOption(apprs.id,apprs.Approver_Name__r.name));
        }*/
        return options1;
    }
    //*****************second list
    string LstVal2;
    public string getoptions2() {

        return LstVal2;
    }
    public void setoptions2(string LstVal2) {
        this.LstVal2 = LstVal2;
    }
    //*********third picklist
    string Lstval3;
    public string getoptions3() {

        return Lstval3;
    }

    public void setoptions3(string Lstval3) {
        this.Lstval3 = Lstval3;
    }
    //***************fourth picklist
    string Lstval4;
    public string getoptions4() {

        return Lstval4;
    }

    public void setoptions4(string Lstval4) {
        this.Lstval4 = Lstval4;
    }
    public list < SelectOption > getUserList2() {
        List < SelectOption > options2 = new List < SelectOption > ();

        options2.add(new SelectOption('Optional', 'Optional'));

        for (Approver__c apprs: BusinessSort) {
            if (apprs.Approver_Name__r.name != null) {
                options2.add(new SelectOption(apprs.id, apprs.Approver_Name__r.lastname+', '+apprs.Approver_Name__r.firstname));
            }
        }

        return options2;
    }
    //*****************contract approver************
    String LstVal1c;
    public string getoptions1c() {

        return LstVal1c;
    }
    public void setoptions1c(string LstVal1c) {

        this.LstVal1c = LstVal1c;
    }

    public list < SelectOption > getUserList1c() {
        List < SelectOption > options1c = new List < SelectOption > ();
        options1c.add(new SelectOption('None', 'None'));
        for (Approver__c apprs: ContractSort) {
            if (apprs.Approver_Name__r.name != null) {
                options1c.add(new SelectOption(apprs.id, apprs.Approver_Name__r.lastname+', '+apprs.Approver_Name__r.firstname));
            }
        }

        return options1c;
    }

    String LstVal2c;
    public string getoptions2c() {

        return LstVal2c;
    }
    public void setoptions2c(string LstVal2c) {

        this.LstVal2c = LstVal2c;
    }

    String LstVal3c;
    public string getoptions3c() {

        return LstVal3c;
    }
    public void setoptions3c(string LstVal3c) {

        this.LstVal3c = LstVal3c;
    }
    String LstVal4c;
    public string getoptions4c() {

        return LstVal4c;
    }
    public void setoptions4c(string LstVal4c) {

        this.LstVal4c = LstVal4c;
    }
    public list < SelectOption > getUserList2c() {
        List < SelectOption > options2c = new List < SelectOption > ();
        options2c.add(new SelectOption('Optional', 'Optional'));
        for (Approver__c apprs: ContractSort) {
            if (apprs.Approver_Name__r.name != null) {
                options2c.add(new SelectOption(apprs.id, apprs.Approver_Name__r.lastname+', '+apprs.Approver_Name__r.firstname));
            }
        }

        return options2c;
    }
    //******************Finance Approvers**********************
    String LstVal1f;
    public string getoptions1f() {

        return LstVal1f;
    }
    public void setoptions1f(string LstVal1f) {

        this.LstVal1f = LstVal1f;
    }

    String LstVal2f;
    public string getoptions2f() {

        return LstVal2f;
    }
    public void setoptions2f(string LstVal2f) {

        this.LstVal2f = LstVal2f;
    }

    String LstVal3f;
    public string getoptions3f() {

        return LstVal3f;
    }
    public void setoptions3f(string LstVal3f) {

        this.LstVal3f = LstVal3f;
    }
    String LstVal4f;
    public string getoptions4f() {

        return LstVal4f;
    }
    public void setoptions4f(string LstVal4f) {

        this.LstVal4f = LstVal4f;
    }


    //*****************product approver************
    String LstVal1p;
    public string getoptions1p() {

        return LstVal1p;
    }
    public void setoptions1p(string LstVal1p) {

        this.LstVal1p = LstVal1p;
    }

    String LstVal2p;
    public string getoptions2p() {

        return LstVal2p;
    }
    public void setoptions2p(string LstVal2p) {

        this.LstVal2p = LstVal2p;
    }

    String LstVal3p;
    public string getoptions3p() {

        return LstVal3p;
    }
    public void setoptions3p(string LstVal3p) {

        this.LstVal3p = LstVal3p;
    }
    String LstVal4p;
    public string getoptions4p() {

        return LstVal4p;
    }
    public void setoptions4p(string LstVal4p) {

        this.LstVal4p = LstVal4p;
    }
    public list < SelectOption > getUserList1f() {
        List < SelectOption > options1f = new List < SelectOption > ();
        options1f.add(new SelectOption('None', 'None'));

        for (Approver__c apprs: FinanceSort) {
            if (apprs.Approver_Name__r.name != null) {
                options1f.add(new SelectOption(apprs.id, apprs.Approver_Name__r.lastname+', '+apprs.Approver_Name__r.firstname));
            }
        }

        return options1f;
    }
    public list < SelectOption > getUserList2f() {
        List < SelectOption > options2f = new List < SelectOption > ();
        options2f.add(new SelectOption('Optional', 'Optional'));

        for (Approver__c apprs: FinanceSort) {
            if (apprs.Approver_Name__r.name != null) {
                options2f.add(new SelectOption(apprs.id, apprs.Approver_Name__r.lastname+', '+apprs.Approver_Name__r.firstname));
            }
        }

        return options2f;
    }

    public list < SelectOption > getUserList1p() {
        List < SelectOption > options1p = new List < SelectOption > ();
        options1p.add(new SelectOption('None', 'None'));

        for (Approver__c apprs: ProductSort) {
            if (apprs.Approver_Name__r.name != null) {
                options1p.add(new SelectOption(apprs.id, apprs.Approver_Name__r.lastname+', '+apprs.Approver_Name__r.firstname));
            }
        }

        return options1p;
    }
    public list < SelectOption > getUserList2p() {
        List < SelectOption > options2p = new List < SelectOption > ();
        options2p.add(new SelectOption('Optional', 'Optional'));

        for (Approver__c apprs: ProductSort) {
            if (apprs.Approver_Name__r.name != null) {
                options2p.add(new SelectOption(apprs.id, apprs.Approver_Name__r.lastname+', '+apprs.Approver_Name__r.firstname));
            }
        }

        return options2p;
    }

    //*****************Additional approver************
    String LstVal1a;
    public string getoptions1a() {

        return LstVal1a;
    }
    public void setoptions1a(string LstVal1a) {

        this.LstVal1a = LstVal1a;
    }

    String LstVal2a;
    public string getoptions2a() {

        return LstVal2a;
    }
    public void setoptions2a(string LstVal2a) {

        this.LstVal2a = LstVal2a;
    }

    String LstVal3a;
    public string getoptions3a() {

        return LstVal3a;
    }
    public void setoptions3a(string LstVal3a) {

        this.LstVal3a = LstVal3a;
    }
    String LstVal4a;
    public string getoptions4a() {

        return LstVal4a;
    }
    public void setoptions4a(string LstVal4a) {

        this.LstVal4a = LstVal4a;
    }
    public list < SelectOption > getUserList1a() {
        List < SelectOption > options1a = new List < SelectOption > ();
        options1a.add(new SelectOption('None', 'None'));
        for (Approver__c apprs: AdditionalSort) {
            if (apprs.Approver_Name__r.name != null) {
                options1a.add(new SelectOption(apprs.id, apprs.Approver_Name__r.lastname+', '+apprs.Approver_Name__r.firstname));
            }
        }

        return options1a;
    }
    public list < SelectOption > getUserList2a() {
        List < SelectOption > options2a = new List < SelectOption > ();
        options2a.add(new SelectOption('Optional', 'Optional'));
        for (Approver__c apprs: AdditionalSort) {
            if (apprs.Approver_Name__r.name != null) {
                options2a.add(new SelectOption(apprs.id, apprs.Approver_Name__r.lastname+', '+apprs.Approver_Name__r.firstname));
            }
        }

        return options2a;
    }


    //*****************M&PM Approvers***************
    String LstVal1m;
    public string getoptions1m() {

        return LstVal1m;
    }
    public void setoptions1m(string LstVal1m) {

        this.LstVal1m = LstVal1m;
    }
    String LstVal2m;
    public string getoptions2m() {

        return LstVal2m;
    }
    public void setoptions2m(string LstVal2m) {

        this.LstVal2m = LstVal2m;
    }
    String LstVal3m;
    public string getoptions3m() {

        return LstVal3m;
    }
    public void setoptions3m(string LstVal3m) {

        this.LstVal3m = LstVal3m;
    }
    String LstVal4m;
    public string getoptions4m() {

        return LstVal4m;
    }
    public void setoptions4m(string LstVal4m) {

        this.LstVal4m = LstVal4m;
    }
    public list < SelectOption > getUserList1m() {
        List < SelectOption > options1m = new List < SelectOption > ();

        options1m.add(new SelectOption('None', 'None'));
        for (Approver__c apprs: MPMSort) {
            if (apprs.Approver_Name__r.name != null) {
                options1m.add(new SelectOption(apprs.id, apprs.Approver_Name__r.lastname+', '+apprs.Approver_Name__r.firstname));
            }
        }
        return options1m;
    }
    public list < SelectOption > getUserList2m() {
        List < SelectOption > options2m = new List < SelectOption > ();

        options2m.add(new SelectOption('Optional', 'Optional'));
        for (Approver__c apprs: MPMSort) {
            if (apprs.Approver_Name__r.name != null) {
                options2m.add(new SelectOption(apprs.id, apprs.Approver_Name__r.lastname+', '+apprs.Approver_Name__r.firstname));
            }
        }
        return options2m;
    }
    //********************notification users
    String LstVal1n;
    public string getoptions1n() {
        system.debug('#####' + LstVal1n);
        return LstVal1n;
    }
    public void setoptions1n(string LstVal1n) {

        this.LstVal1n = LstVal1n;
    }
    String LstVal2n;
    public string getoptions2n() {

        return LstVal2n;
    }
    public void setoptions2n(string LstVal2n) {

        this.LstVal2n = LstVal2n;
    }
    String LstVal3n;
    public string getoptions3n() {

        return LstVal3n;
    }
    public void setoptions3n(string LstVal3n) {

        this.LstVal3n = LstVal3n;
    }
    String LstVal4n;
    public string getoptions4n() {

        return LstVal4n;
    }
    public void setoptions4n(string LstVal4n) {

        this.LstVal4n = LstVal4n;
    }
    public list < SelectOption > getUserList1n() {
        List < SelectOption > options1n = new List < SelectOption > ();
        options1n.add(new SelectOption('None', 'None'));
        system.debug('535#######' + NotificationSort);
        for (Approver__c apprs: NotificationSort) {
            if (apprs.Approver_Name__r.name != null) {
                options1n.add(new SelectOption(apprs.id, apprs.Approver_Name__r.lastname+', '+apprs.Approver_Name__r.firstname));
            }
        }

        return options1n;
    }
    public list < SelectOption > getUserList2n() {
        List < SelectOption > options2n = new List < SelectOption > ();
        options2n.add(new SelectOption('Optional', 'Optional'));

        for (Approver__c apprs: NotificationSort) {
            if (apprs.Approver_Name__r.name != null) {
                options2n.add(new SelectOption(apprs.id, apprs.Approver_Name__r.lastname+', '+apprs.Approver_Name__r.firstname));
            }
        }

        return options2n;
    }
    //***************SendMail
    Public pagereference sendMail() {
        System.debug('557##### sendMail start ');
        List < Messaging.SingleEmailMessage > mailMass = new List < Messaging.SingleEmailMessage > ();
        lstofAPP.add(Lstval1);
        lstofAPP.add(LstVal2);
        lstofAPP.add(Lstval3);
        lstofAPP.add(Lstval4);

        lstofAPP.add(LstVal1c);
        lstofAPP.add(LstVal2c);
        lstofAPP.add(LstVal3c);
        lstofAPP.add(LstVal4c);

        lstofAPP.add(LstVal1f);
        lstofAPP.add(LstVal2f);
        lstofAPP.add(LstVal3f);
        lstofAPP.add(LstVal4f);

        lstofAPP.add(LstVal1a);
        lstofAPP.add(LstVal2a);
        lstofAPP.add(LstVal3a);
        lstofAPP.add(LstVal4a);

        lstofAPP.add(LstVal1p);
        lstofAPP.add(LstVal2p);
        lstofAPP.add(LstVal3p);
        lstofAPP.add(LstVal4p);

        lstofAPP.add(LstVal1m);
        lstofAPP.add(LstVal2m);
        lstofAPP.add(LstVal3m);
        lstofAPP.add(LstVal4m);

        lstofAPP.add(LstVal1n);
        lstofAPP.add(LstVal2n);
        lstofAPP.add(LstVal3n);
        lstofAPP.add(LstVal4n);

        System.debug('584 ######  lstofAPP' + lstofAPP);

        string progress_level = WFList[0].Approval_Level_in_Progress__c;
        list < string > p_level1 = progress_level.split('Tier');
        string plevel = 'Tier' + p_level1[1];

        list < WorkFlow_Approval_History__c > aprec1 = new list < WorkFlow_Approval_History__c > ();
        list < Approver__c > Alist1 = new list < Approver__c > ();
        list < Approver__c > Alist2 = new list < Approver__c > ();


        /**************************************** Querying the selected approvers *********************************/

        system.debug('qweqweqwe' + lstofAPP.size());
        Alist1 = [select Email_from_user__c, id, Approver_Name__r.name, Out_of_Office__c, From__c, To__c, Delegate_Name__c, Delegate_Email__c, Business_Unit__c, Approver_type__c, Email__c from Approver__c where Tier__c like: '%' + plevel and(Region__c like: region0 or Region__c like: region1 or Region__c like: region2 or Region__c like: region3 or Region__c like: region4) and(Business_Unit__c like: WFList[0].Airbus_c__c or Business_Unit__c like: WFList[0].Airlines_c__c or Business_Unit__c like: WFList[0].ATR_c__c or Business_Unit__c like: WFList[0].BG_A_OE_c__c or Business_Unit__c like: WFList[0].BG_A_c__c or Business_Unit__c like: WFList[0].Boeing_c__c or Business_Unit__c like: WFList[0].RACC_c__c or Business_Unit__c like: WFList[0].Defence_Space_c__c or Business_Unit__c like: WFList[0].Defence_Space_OE_c__c or Business_Unit__c like: WFList[0].HIS_c__c or Business_Unit__c like: WFList[0].HTSI_c__c or Business_Unit__c like: WFList[0].HTSI_OE_c__c)];
        system.debug('oooooooo' + Alist1);

        Alist2 = [select Delegation_Valid_From1__c, Delegation_Valid_To1__c, Delegate_Name_Text1__c, Delegation_Valid_From2__c, Delegation_Valid_To2__c, Delegate_Name_Text2__c, Delegation_Valid_From3__c, Delegation_Valid_To3__c, Delegate_Name_Text3__c, Delegation_Valid_From4__c, Delegation_Valid_To4__c, Delegate_Name_Text4__c, Email_from_user__c, id, Approver_Name__r.name, Out_of_Office__c, From__c, To__c, Delegate_Name__c, Delegate_Email__c, Business_Unit__c, Approver_type__c, Email__c from Approver__c where id in: lstofAPP];
        system.debug('CCCCCCCCCCCC' + Alist2.size());

        /******************************* Marking the previously submitted requests as old *******************************/
        System.debug('######605  Old_record__c start');
        aprec1 = [select Old_record__c from WorkFlow_Approval_History__c where Workflow_details__c =: WFid];
        for (WorkFlow_Approval_History__c a: aprec1) {
            System.debug('#####609 Old_record__c' + a.Old_record__c);
            a.Old_record__c = True;
            Approveobj.add(a);
        }
        update Approveobj;
        System.debug('######614  Old_record__c end ' + Approveobj);
        //list < Approver__c > Applist = new list < Approver__c > ();
        //String dynamStr = 'select Business_Unit__c,id,Approver_Name__r.name,Name,Email__c,Out_of_Office__c,Delegate_Email__c,Email_from_user__c,Delegate_Name__c,Approver_type__c from Approver__c';
        //String TempStr = '';
        map<id,Approver__c> ApproverRecMap = new map<id,Approver__c>();
        for(Approver__c app :Alist2 ) {
            ApproverRecMap.put(app.id,app);
        }

        for (integer i = 0; i < lstofAPP.size(); i++) {
            system.debug('lstofappsizeeeeeeeeee' + lstofAPP.size());

            system.debug('list of apps:' + i + ',' + lstofAPP[i]);

            if (lstofAPP[i] <> null && lstofAPP[i] != 'Optional' && lstofAPP[i] != 'None') {
                system.debug('@@@@@@inside1stif@@@@@@');
                WorkFlow_Approval_History__c aprec = new WorkFlow_Approval_History__c();
                WorkFlow_notification_History__c ntrec = new WorkFlow_notification_History__c();
                WorkFlow_Approval_History__c aprecDelt = new WorkFlow_Approval_History__c();
                system.debug('alist2sizeeee' + alist2.size());
                for (Approver__c a: Alist2) {
                    system.debug('@@@@@inside2ndif@@@@' + Alist2.size());
                    if (lstofAPP[i] == a.id) {
                        CurrApp = a;
                        system.debug('TTTTTTTTTTTTT' + lstofAPP[i]);
                        /******************************************** Checking for delegates ********************************************************/
                        if (CurrApp.Out_of_Office__c) {
                            if (CurrApp.From__c <= System.Today() && CurrApp.To__c >= System.Today()) {
                                system.debug('CURRAPP:');
                                String lstdel = CurrApp.Delegate_Name__c;
                                if(CurrApp.Out_of_Office__c == true)
                                {
                                    //system.debug('loop1' + dynamStr);
                                    //if (dynamStr != null) {
                                    //   dynamStr = dynamStr + ' ' + 'where Approver_Name__r.name =: lstdel limit 1';
                                    //}
                                    //system.debug('CURRAPP:' + dynamStr);

                                    //CurrApp = [select Business_Unit__c,id,Approver_Name__r.name,Name,Email__c,Out_of_Office__c,Delegate_Email__c,Email_from_user__c,Delegate_Name__c,Approver_type__c from Approver__c where  Approver_Name__r.name =: lstdel limit 1 ];
                                    Boolean j = CurrApp.Out_of_Office__c;
                                    if(j==True)
                                    {
                                        lstdel = ApproverRecMap.get(CurrApp.id).Delegate_Name__c;
                                    }
                                }


                            } else if (CurrApp.Delegation_Valid_From1__c <= System.Today() && CurrApp.Delegation_Valid_To1__c >= System.Today()) {
                                String lstdel = CurrApp.Delegate_Name_Text1__c;
                                if(CurrApp.Out_of_Office__c == true)
                                {
                                    //system.debug('loop2' + dynamStr);
                                    //if (dynamStr != null) {
                                    //  dynamStr = dynamStr + ' ' + 'where Approver_Name__r.name =: lstdel limit 1';
                                    //}
                                    //system.debug('CURRAPP1:' + dynamStr);
                                    //CurrApp = [select Business_Unit__c,id,Approver_Name__r.name,Name,Email__c,Out_of_Office__c,Delegate_Email__c,Email_from_user__c,Delegate_Name__c,Approver_type__c from Approver__c where  Approver_Name__r.name =: lstdel limit 1 ];
                                    Boolean j = CurrApp.Out_of_Office__c;
                                    if(j==True)
                                    {
                                        lstdel = ApproverRecMap.get(CurrApp.id).Delegate_Name__c;
                                    }
                                }
                            } else if (CurrApp.Delegation_Valid_From2__c <= System.Today() && CurrApp.Delegation_Valid_To2__c >= System.Today()) {
                                String lstdel = CurrApp.Delegate_Name_Text2__c;
                                if(CurrApp.Out_of_Office__c ==true)
                                {
                                    //system.debug('loop3' + dynamStr);
                                    //if (dynamStr != null) {
                                    //    dynamStr = dynamStr + ' ' + 'where Approver_Name__r.name =: lstdel limit 1';
                                    //}
                                    //system.debug('CURRAPP2:' + dynamStr);
                                    //CurrApp = [select Business_Unit__c,id,Approver_Name__r.name,Name,Email__c,Out_of_Office__c,Delegate_Email__c,Email_from_user__c,Delegate_Name__c,Approver_type__c from Approver__c where  Approver_Name__r.name =: lstdel limit 1 ];
                                    Boolean j = CurrApp.Out_of_Office__c;
                                    if(j==True)
                                    {
                                        lstdel = ApproverRecMap.get(CurrApp.id).Delegate_Name__c;
                                    }
                                }
                            } else if (CurrApp.Delegation_Valid_From3__c <= System.Today() && CurrApp.Delegation_Valid_To3__c >= System.Today()) {
                                //system.debug('loop4' + dynamStr);
                                String lstdel = CurrApp.Delegate_Name_Text3__c;
                                if(CurrApp.Out_of_Office__c ==true)
                                {
                                    //system.debug('loop4' + dynamStr);
                                    //if (dynamStr != null) {
                                    //   dynamStr = dynamStr + ' ' + 'where Approver_Name__r.name =: lstdel limit 1';
                                    //}
                                    //system.debug('CURRAPP3:' + dynamStr);
                                    //CurrApp = [select Business_Unit__c,id,Approver_Name__r.name,Name,Email__c,Out_of_Office__c,Delegate_Email__c,Email_from_user__c,Delegate_Name__c,Approver_type__c from Approver__c where  Approver_Name__r.name =: lstdel limit 1 ];
                                    Boolean j = CurrApp.Out_of_Office__c;
                                    if(j==True)
                                    {
                                        lstdel = ApproverRecMap.get(CurrApp.id).Delegate_Name__c;
                                    }
                                }
                            } else if (CurrApp.Delegation_Valid_From4__c <= System.Today() && CurrApp.Delegation_Valid_To4__c >= System.Today()) {
                                String lstdel = CurrApp.Delegate_Name_Text4__c;
                                if(CurrApp.Out_of_Office__c ==true)
                                {
                                    //system.debug('loop5' + dynamStr);
                                    //if (dynamStr != null) {
                                    //dynamStr = dynamStr + ' ' + 'where Approver_Name__r.name =: lstdel limit 1';
                                    //}
                                    // system.debug('CURRAPP4:' + dynamStr);
                                    //CurrApp = [select Business_Unit__c,id,Approver_Name__r.name,Name,Email__c,Out_of_Office__c,Delegate_Email__c,Email_from_user__c,Delegate_Name__c,Approver_type__c from Approver__c where  Approver_Name__r.name =: lstdel limit 1 ];
                                    Boolean j = CurrApp.Out_of_Office__c;
                                    if(j==True)
                                    {
                                        lstdel = ApproverRecMap.get(CurrApp.id).Delegate_Name__c;
                                    }
                                }
                            }

                        }
                        //system.debug('CURRAPP FINAL:' + dynamStr);
                        //Applist = Database.Query(DynamStr);
                        //system.debug('Applist ' + Applist);
                        ///*************************************************** Updating Workflow history records ***********************************************/
                        System.debug(i+'The Values are ====='+CurrApp.Approver_type__c);
                        if (CurrApp.Approver_type__c != 'Notification' && i < 20) {
                            aprec.Approver__c = CurrApp.Approver_Name__r.name;
                            //newly added
                            aprec.Select_Approver__c = CurrApp.ID;
                            aprec.Ownerid = CurrApp.Approver_Name__c;
                            aprec.Email__c = CurrApp.Email_from_user__c;
                            aprec.Workflow_details__c = WFid;
                            aprec.Approval_Status__c = 'Pending Approval';
                            aprec.Approver_Type__c = CurrApp.Approver_type__c;
                            aprec.Approval_submitted_date__c = System.today();
                            aprec.Business_Unit__c = CurrApp.Business_Unit__c;
                            aprec.Tier__c = WFList[0].Approval_Level_in_Progress__c;
                            WFList[0].Status__c = 'In progress';
                            ApproveobjRec.add(aprec);
                            system.debug('PPPPPPPPPPPPPP' + CurrApp);
                        }
                        /*if (i >= 16 && i <= 19 && lstofAPP[i] != Null) {
                            aprec.Approver__c = CurrApp.Approver_Name__r.name;
                            //newly added
                            aprec.Select_Approver__c = CurrApp.ID;
                            aprec.Ownerid = CurrApp.Approver_Name__c;
                            aprec.Email__c = CurrApp.Email_from_user__c;
                            aprec.Workflow_details__c = WFid;
                            aprec.Approval_Status__c = 'Pending Approval';
                            aprec.Approver_Type__c = CurrApp.Approver_type__c;
                            aprec.Approval_submitted_date__c = System.today();
                            aprec.Business_Unit__c = CurrApp.Business_Unit__c;
                            aprec.Tier__c = WFList[0].Approval_Level_in_Progress__c;
                            WFList[0].Status__c = 'In progress';
                            ApproveobjRec2.add(aprec);
                            system.debug('Additional' + CurrApp);
                        }*/
                        if (i >= 20 && i <= 23 && lstofAPP[i] != Null) {
                            system.debug('MMMMMMMMMM' + i);
                            aprecDelt.Approver__c = CurrApp.Approver_Name__r.name;
                            //newly added
                            aprecDelt.Select_Approver__c = CurrApp.ID;
                            aprecDelt.Ownerid = CurrApp.Approver_Name__c;
                            aprecDelt.Email__c = CurrApp.Email_from_user__c;
                            aprecDelt.Workflow_details__c = WFid;
                            aprecDelt.Approval_Status__c = 'Pending Approval';
                            aprecDelt.Approver_Type__c = CurrApp.Approver_type__c;
                            aprecDelt.Approval_submitted_date__c = System.today();
                            aprecDelt.Business_Unit__c = CurrApp.Business_Unit__c;
                            aprecDelt.Tier__c = WFList[0].Approval_Level_in_Progress__c;
                            aprecDelt.Delete_Check_Box__c = True;
                            //WFList[0].Status__c ='In progress';
                            ApproveobjRec1.add(aprecDelt);
                        }
                        System.debug('685######' + CurrApp.Approver_type__c);

                        if (CurrApp.Approver_type__c == 'Notification') {
                            System.debug('688######' + CurrApp.Approver_type__c);
                            ntrec.Approver__c = CurrApp.Approver_Name__r.name;
                            //newly added
                            ntrec.Select_Approver__c = CurrApp.ID;
                            ntrec.Ownerid = CurrApp.Approver_Name__c;
                            ntrec.Email__c = CurrApp.Email_from_user__c;
                            ntrec.Workflow_details__c = WFid;
                            ntrec.WF_Status__c = 'Pending Approval';
                            ntrec.Approver_Type__c = CurrApp.Approver_type__c;
                            ntrec.Approval_submitted_date__c = System.today();
                            //ntrec.Business_Unit__c=CurrApp.Business_Unit__c;
                            // ntrec.Tier__c=WFList[0].Approval_Level_in_Progress__c;
                            // WFList[0].Status__c ='In progress';
                            System.debug('701######' + ntrec);
                            notifyobj.add(ntrec);
                            system.debug('PPPPPPPPPPPPPP' + CurrApp);
                            System.debug('704######' + notifyobj);
                            // }
                        }
                    }
                }
            }

        }
        lstofAPP.Clear();

        if (ApproveobjRec.size() > 0) {
            system.debug('JJJJJJJJJJJJJJ' + ApproveobjRec);
            try {
                insert ApproveobjRec;
            } catch (DMLException e) {
                ApexPages.addMessages(e);
                return null;
            }
        }
        if (ApproveobjRec1.size() > 0) {
            system.debug('kkkkkkkk');
            insert ApproveobjRec1;
            delete ApproveobjRec1;
        }
        if (notifyobj.size() > 0) {
            system.debug('JJJJJJJJJJJJJJ' + notifyobj);
            insert notifyobj;
        }
        update WFList;
        PageReference oppPage = new PageReference('/' + WFId);
        oppPage.setRedirect(true);
        return oppPage;
    }
    //************************

    public pagereference savendraft() {
        if (BusinessSort.size() > 0) {
            for (Approver__c apprs: BusinessSort) {
                if (LstVal1 != 'None' && apprs.id == LstVal1) {
                    saveAsDrft.Business_Approver1__c = apprs.Approver_Name__r.name;
                    saveAsDrft.Business_Approver1_Id__c = apprs.Approver_Name__r.id;
                }
                if (LstVal2 != 'Optional' && apprs.id == LstVal2) {
                    saveAsDrft.Business_Approver2__c = apprs.Approver_Name__r.name;
                    saveAsDrft.Business_Approver2_Id__c = apprs.Approver_Name__r.id;
                }
                if (LstVal3 != 'Optional' && apprs.id == LstVal3) {
                    saveAsDrft.Business_Approver3__c = apprs.Approver_Name__r.name;
                    saveAsDrft.Business_Approver3_Id__c = apprs.Approver_Name__r.id;
                }
                if (LstVal4 != 'Optional' && apprs.id == LstVal4) {
                    saveAsDrft.Business_Approver4__c = apprs.Approver_Name__r.name;
                    saveAsDrft.Business_Approver4_Id__c = apprs.Approver_Name__r.id;
                }
            }
        }
        if (ContractSort.size() > 0) {
            for (Approver__c apprs: ContractSort) {
                if (LstVal1c != 'None' && apprs.id == LstVal1c) {
                    saveAsDrft.Contract_Approvers1__c = apprs.Approver_Name__r.name;
                    saveAsDrft.Contract_Approvers1_Id__c = apprs.Approver_Name__r.id;
                }
                if (LstVal2c != 'Optional' && apprs.id == LstVal2c) {
                    saveAsDrft.Contract_Approvers2__c = apprs.Approver_Name__r.name;
                    saveAsDrft.Contract_Approvers2_Id__c = apprs.Approver_Name__r.id;
                }
                if (LstVal3c != 'Optional' && apprs.id == LstVal3c) {
                    saveAsDrft.Contract_Approvers3__c = apprs.Approver_Name__r.name;
                    saveAsDrft.Contract_Approvers3_Id__c = apprs.Approver_Name__r.id;
                }
                if (LstVal4c != 'Optional' && apprs.id == LstVal4c) {
                    saveAsDrft.Contract_Approvers4__c = apprs.Approver_Name__r.name;
                    saveAsDrft.Contract_Approvers4_Id__c = apprs.Approver_Name__r.id;
                }
            }
        }
        if (FinanceSort.size() > 0) {
            for (Approver__c apprs: FinanceSort) {
                if (LstVal1f != 'None' && apprs.id == LstVal1f) {
                    saveAsDrft.Finance_Approver1__c = apprs.Approver_Name__r.name;
                    saveAsDrft.Finance_Approver1_Id__c = apprs.Approver_Name__r.id;
                }
                if (LstVal2f != 'Optional' && apprs.id == LstVal2f) {
                    saveAsDrft.Finance_Approver2__c = apprs.Approver_Name__r.name;
                    saveAsDrft.Finance_Approver2_Id__c = apprs.Approver_Name__r.id;
                }
                if (LstVal3f != 'Optional' && apprs.id == LstVal3f) {
                    saveAsDrft.Finance_Approver3__c = apprs.Approver_Name__r.name;
                    saveAsDrft.Finance_Approver3_Id__c = apprs.Approver_Name__r.id;
                }
                if (LstVal4f != 'Optional' && apprs.id == LstVal4f) {
                    saveAsDrft.Finance_Approver4__c = apprs.Approver_Name__r.name;
                    saveAsDrft.Finance_Approver4_Id__c = apprs.Approver_Name__r.id;
                }
            }
        }
        if (AdditionalSort.size() > 0) {
            for (Approver__c apprs: AdditionalSort) {
                if (LstVal1a != 'None' && apprs.id == LstVal1a) {
                    saveAsDrft.Additional_Approver1__c = apprs.Approver_Name__r.name;
                    saveAsDrft.Additional_Approver1_Id__c = apprs.Approver_Name__r.id;
                }
                if (LstVal2a != 'Optional' && apprs.id == LstVal2a) {
                    saveAsDrft.Additional_Approver2__c = apprs.Approver_Name__r.name;
                    saveAsDrft.Additional_Approver2_Id__c = apprs.Approver_Name__r.id;
                }
                if (LstVal3a != 'Optional' && apprs.id == LstVal3a) {
                    saveAsDrft.Additional_Approver3__c = apprs.Approver_Name__r.name;
                    saveAsDrft.Additional_Approver3_Id__c = apprs.Approver_Name__r.id;
                }
                if (LstVal4a != 'Optional' && apprs.id == LstVal4a) {
                    saveAsDrft.Additional_Approver4__c = apprs.Approver_Name__r.name;
                    saveAsDrft.Additional_Approver4_Id__c = apprs.Approver_Name__r.id;
                }
            }
        }

        //Need to check if the below code is neede
        if (ProductSort.size() > 0) {
            for (Approver__c apprs: ProductSort) {
                if (LstVal1p != 'None' && apprs.id == LstVal1p) {
                    saveAsDrft.Product_Approver1__c = apprs.Approver_Name__r.name;
                    saveAsDrft.Product_Approver1_Id__c = apprs.Approver_Name__r.id;
                }
                if (LstVal2p != 'Optional' && apprs.id == LstVal2p) {
                    saveAsDrft.Product_Approver2__c = apprs.Approver_Name__r.name;
                    saveAsDrft.Product_Approver2_Id__c = apprs.Approver_Name__r.id;
                }
                if (LstVal3p != 'Optional' && apprs.id == LstVal3p) {
                    saveAsDrft.Product_Approver3__c = apprs.Approver_Name__r.name;
                    saveAsDrft.Product_Approver3_Id__c = apprs.Approver_Name__r.id;
                }
                if (LstVal4p != 'Optional' && apprs.id == LstVal4p) {
                    saveAsDrft.Product_Approver4__c = apprs.Approver_Name__r.name;
                    saveAsDrft.Product_Approver4_Id__c = apprs.Approver_Name__r.id;
                }
            }
        }
        if (MPMSort.size() > 0) {
            for (Approver__c apprs: MPMSort) {
                if (LstVal1m != 'None' && apprs.id == LstVal1m) {
                    saveAsDrft.M_PM_Approver1__c = apprs.Approver_Name__r.name;
                    saveAsDrft.M_PM_Approver1_Id__c = apprs.Approver_Name__r.id;
                }
                if (LstVal2m != 'Optional' && apprs.id == LstVal2m) {
                    saveAsDrft.M_PM_Approver2__c = apprs.Approver_Name__r.name;
                    saveAsDrft.M_PM_Approver2_Id__c = apprs.Approver_Name__r.id;
                }
                if (LstVal3m != 'Optional' && apprs.id == LstVal3m) {
                    saveAsDrft.M_PM_Approver3__c = apprs.Approver_Name__r.name;
                    saveAsDrft.M_PM_Approver3_Id__c = apprs.Approver_Name__r.id;
                }
                if (LstVal4m != 'Optional' && apprs.id == LstVal4m) {
                    saveAsDrft.M_PM_Approver4__c = apprs.Approver_Name__r.name;
                    saveAsDrft.M_PM_Approver4_Id__c = apprs.Approver_Name__r.id;
                }

            }
        }
        if (NotificationSort.size() > 0) {
            for (Approver__c apprs: NotificationSort) {
                if (LstVal1n != 'None' && apprs.id == LstVal1n) {
                    saveAsDrft.Notification1__c = apprs.Approver_Name__r.name;
                    saveAsDrft.Notification1_Id__c = apprs.Approver_Name__r.id;
                }
                if (LstVal2n != 'Optional' && apprs.id == LstVal2n) {
                    saveAsDrft.Notification2__c = apprs.Approver_Name__r.name;
                    saveAsDrft.Notification2_Id__c = apprs.Approver_Name__r.id;
                }
                if (LstVal3n != 'Optional' && apprs.id == LstVal3n) {
                    saveAsDrft.Notification3__c = apprs.Approver_Name__r.name;
                    saveAsDrft.Notification3_Id__c = apprs.Approver_Name__r.id;
                }
                if (LstVal4n != 'Optional' && apprs.id == LstVal4n) {
                    saveAsDrft.Notification4__c = apprs.Approver_Name__r.name;
                    saveAsDrft.Notification4_Id__c = apprs.Approver_Name__r.id;
                }
            }
        }

        saveAsDrft.Draft_Date__c = system.today();
        saveAsDrft.Workflow_details__c = Wfid;
        insert saveAsDrft;
        system.debug('saveAsDrft' + saveAsDrft);
        PageReference oppPage = new PageReference('/' + WFId);
        oppPage.setRedirect(true);

        return oppPage;

    }
    /*****************Canceling the page****************/
    Public pagereference Cancel() {
        PageReference oppPage = new PageReference('/' + WFId);
        oppPage.setRedirect(true);
        return oppPage;
    }


}