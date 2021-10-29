/** * File Name: Workflow_details__c
* Description : To populate 
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */

trigger TriggerTier on Workflow_details__c (before insert,before update) {

    //************Variable declartion****************************
    list<Tier_Level__c> Exposed_list= new list<Tier_Level__c>();
    list<Tier_Level__c> Exposed_Max_list = new list<Tier_Level__c>();
    list<Tier_Level__c> Frndend_cst = new list<Tier_Level__c>();
    list<Tier_Level__c> Frndend_Max_cst = new list<Tier_Level__c>();
    list<Tier_Level__c> Non_Revenue_lst = new list<Tier_Level__c>();
    list<Tier_Level__c> std_Revenue_lst = new list<Tier_Level__c>();
    boolean flag=False;
    string bu='';
    string suggestedTier;
    Decimal excost;
    Decimal frntendMaxls;
    Decimal FrndEndcst;
    Decimal ExcostMx;
    Decimal Revenue;

    //****************variables used to avoid duplication********************
    string lsttier;
    string[] words;
    integer length;
    string lstsuggestedTier;
    set<string> str = new set<string>();
    list<string> lststr= new list<string>();
    list<string> lststr1= new list<string>();
    string termsCndtn;
    //********************************************************
    for(Workflow_details__c wf1 : Trigger.new){
        if(Trigger.isInsert ||(
            wf1.Airbus__c != System.Trigger.OldMap.get(wf1.Id).Airbus__c ||
            wf1.Airlines__c != System.Trigger.OldMap.get(wf1.Id).Airlines__c ||
            wf1.ATR__c != System.Trigger.OldMap.get(wf1.Id).ATR__c ||
            wf1.BG_A_OE__c != System.Trigger.OldMap.get(wf1.Id).BG_A_OE__c ||
            wf1.Boeing__c != System.Trigger.OldMap.get(wf1.Id).Boeing__c ||
            wf1.RACC__c != System.Trigger.OldMap.get(wf1.Id).RACC__c ||
            wf1.Defence_Space__c != System.Trigger.OldMap.get(wf1.Id).Defence_Space__c ||
            wf1.HTSI__c != System.Trigger.OldMap.get(wf1.Id).HTSI__c ||
            wf1.HIS__c != System.Trigger.OldMap.get(wf1.Id).HIS__c ||
            wf1.Exposed_Cost__c != System.Trigger.OldMap.get(wf1.Id).Exposed_Cost__c ||
            wf1.Front_End_Loss__c != System.Trigger.OldMap.get(wf1.Id).Front_End_Loss__c ||
            wf1.Exposed_Cost_Max_Year_K__c != System.Trigger.OldMap.get(wf1.Id).Exposed_Cost_Max_Year_K__c ||
            wf1.Front_End_Loss_Max_Year__c != System.Trigger.OldMap.get(wf1.Id).Front_End_Loss_Max_Year__c ||
            wf1.X5_Year_Revenue_K__c != System.Trigger.OldMap.get(wf1.Id).X5_Year_Revenue_K__c ||
            wf1.Terms_and_Conditions__c != System.Trigger.OldMap.get(wf1.Id).Terms_and_Conditions__c ||
            wf1.Suggested_Tier__c != System.Trigger.OldMap.get(wf1.Id).Suggested_Tier__c  ) )
        {

            //*************** When SBU is Airbus****************
            if(wf1.Airbus__c==True)
            {
                bu='Airbus';
                excost= wf1.Exposed_Cost__c;
                FrndEndcst=wf1.Front_End_Loss__c;
                ExcostMx=wf1.Exposed_Cost_Max_Year_K__c;
                frntendMaxls=wf1.Front_End_Loss_Max_Year__c;
                Revenue=wf1.X5_Year_Revenue_K__c;
                termsCndtn=wf1.Terms_and_Conditions__c;
                querycostfields();
            }
            //************* when SBU is Airlines******************
            if(wf1.Airlines__c==True)
            {
                bu='Airlines';
                excost= wf1.Exposed_Cost__c;
                FrndEndcst=wf1.Front_End_Loss__c;
                ExcostMx=wf1.Exposed_Cost_Max_Year_K__c;
                frntendMaxls=wf1.Front_End_Loss_Max_Year__c;
                Revenue=wf1.X5_Year_Revenue_K__c;
                termsCndtn=wf1.Terms_and_Conditions__c;
                querycostfields();
            }

            //***************** when SBU is ATR***********
            if(wf1.ATR__c==True)
            {
                bu='ATR';
                excost= wf1.Exposed_Cost__c;
                FrndEndcst=wf1.Front_End_Loss__c;
                ExcostMx=wf1.Exposed_Cost_Max_Year_K__c;
                frntendMaxls=wf1.Front_End_Loss_Max_Year__c;
                Revenue=wf1.X5_Year_Revenue_K__c;
                termsCndtn=wf1.Terms_and_Conditions__c;
                querycostfields();
            }

            //***************** when SBU is BGA***********
            if(wf1.BG_A__c==True || wf1.BG_A_OE__c==True)
            {
                bu='BGA';
                excost= wf1.Exposed_Cost__c;
                FrndEndcst=wf1.Front_End_Loss__c;
                ExcostMx=wf1.Exposed_Cost_Max_Year_K__c;
                frntendMaxls=wf1.Front_End_Loss_Max_Year__c;
                Revenue=wf1.X5_Year_Revenue_K__c;
                termsCndtn=wf1.Terms_and_Conditions__c;
                querycostfields();
            }
            //***************** when SBU is Boeing ***********
            if(wf1.Boeing__c==True)
            {
                bu='Boeing';
                excost= wf1.Exposed_Cost__c;
                FrndEndcst=wf1.Front_End_Loss__c;
                ExcostMx=wf1.Exposed_Cost_Max_Year_K__c;
                frntendMaxls=wf1.Front_End_Loss_Max_Year__c;
                Revenue=wf1.X5_Year_Revenue_K__c;
                termsCndtn=wf1.Terms_and_Conditions__c;
                querycostfields();
            }
            //***************** when SBU is Components***********
            if(wf1.RACC__c==True)
            {
                bu='Components';
                excost= wf1.Exposed_Cost__c;
                FrndEndcst=wf1.Front_End_Loss__c;
                ExcostMx=wf1.Exposed_Cost_Max_Year_K__c;
                frntendMaxls=wf1.Front_End_Loss_Max_Year__c;
                Revenue=wf1.X5_Year_Revenue_K__c;
                termsCndtn=wf1.Terms_and_Conditions__c;
                querycostfields();
            }

            //***************** when SBU is D&S ***********
            if(wf1.Defence_Space__c==True || wf1.Defence_Space_OE__c==True)
            {
                bu='D&S';
                excost= wf1.Exposed_Cost__c;
                FrndEndcst=wf1.Front_End_Loss__c;
                ExcostMx=wf1.Exposed_Cost_Max_Year_K__c;
                frntendMaxls=wf1.Front_End_Loss_Max_Year__c;
                Revenue=wf1.X5_Year_Revenue_K__c;
                termsCndtn=wf1.Terms_and_Conditions__c;
                querycostfields();
            }

            //***************** when SBU is HIS***********
            if(wf1.HIS__c==True)
            {
                bu='HIS';
                excost= wf1.Exposed_Cost__c;
                FrndEndcst=wf1.Front_End_Loss__c;
                ExcostMx=wf1.Exposed_Cost_Max_Year_K__c;
                frntendMaxls=wf1.Front_End_Loss_Max_Year__c;
                Revenue=wf1.X5_Year_Revenue_K__c;
                termsCndtn=wf1.Terms_and_Conditions__c;
                querycostfields();
            }

            //***************** when SBU is HTSI ***********
            if(wf1.HTSI__c==True || wf1.HTSI_OE__c==True)
            {
                bu='HTSI';
                excost= wf1.Exposed_Cost__c;
                FrndEndcst=wf1.Front_End_Loss__c;
                ExcostMx=wf1.Exposed_Cost_Max_Year_K__c;
                frntendMaxls=wf1.Front_End_Loss_Max_Year__c;
                Revenue=wf1.X5_Year_Revenue_K__c;
                termsCndtn=wf1.Terms_and_Conditions__c;
                querycostfields();
            }

            //*********check for duplicate value and update the Suggested Tier field**********
            //checkduplicateval();

            checkduplicateval_New();
            wf1.Suggested_Tier__c=lstsuggestedTier;
        }
    }

    //************* Query the  cost fields******************
    public void  querycostfields()
    {
        //list of exposed cost
        Exposed_list= [select SBU__c,SBU_Region__c,Tier__c,Exposed_Cost__c,Exposed_Cost_Max_Year_K__c,Front_End_Loss__c,Front_End_Loss_Max_Year__c,X5_Year_Revenue__c,Non_Standard_Term__c from Tier_Level__c where SBU__c =: bu order by Exposed_Cost__c];
        //list of exposed Max cost
        Exposed_Max_list= [select SBU__c,SBU_Region__c,Tier__c,Exposed_Cost__c,Exposed_Cost_Max_Year_K__c,Front_End_Loss__c,Front_End_Loss_Max_Year__c,X5_Year_Revenue__c,Non_Standard_Term__c from Tier_Level__c where SBU__c =: bu order by Exposed_Cost_Max_Year_K__c];

        //list of frnd end max loss cost
        Frndend_cst= [select SBU__c,SBU_Region__c,Tier__c,Exposed_Cost__c,Exposed_Cost_Max_Year_K__c,Front_End_Loss__c,Front_End_Loss_Max_Year__c,X5_Year_Revenue__c,Non_Standard_Term__c from Tier_Level__c where SBU__c =: bu order by Front_End_Loss__c];
        //list of frnd end max loss cost
        Frndend_Max_cst= [select SBU__c,SBU_Region__c,Tier__c,Exposed_Cost__c,Exposed_Cost_Max_Year_K__c,Front_End_Loss__c,Front_End_Loss_Max_Year__c,X5_Year_Revenue__c,Non_Standard_Term__c from Tier_Level__c where SBU__c =: bu order by Front_End_Loss_Max_Year__c];

        //list of Revenue standard
        if(termsCndtn=='Standard')
        {
            std_Revenue_lst= [select SBU__c,SBU_Region__c,Tier__c,Exposed_Cost__c,Exposed_Cost_Max_Year_K__c,Front_End_Loss__c,Front_End_Loss_Max_Year__c,X5_Year_Revenue__c,Non_Standard_Term__c from Tier_Level__c where SBU__c =: bu order by X5_Year_Revenue__c];
        }
        else
        {
            Non_Revenue_lst= [select SBU__c,SBU_Region__c,Tier__c,Exposed_Cost__c,Exposed_Cost_Max_Year_K__c,Front_End_Loss__c,Front_End_Loss_Max_Year__c,X5_Year_Revenue__c,Non_Standard_Term__c from Tier_Level__c where SBU__c =: bu order by Non_Standard_Term__c];
        }

        system.debug('Exposed_list');
        system.debug(Exposed_list);

        //**********get fetch the exact Tier for based on Exposed Cost*************
        for(Tier_Level__c  l1 : Exposed_list)
        {
            if((excost <=l1.Exposed_Cost__c)&& flag==False)
            {
                suggestedTier=l1.Tier__c;
                if(lsttier==null)
                {
                    lsttier=suggestedTier;
                }
                else
                {
                    lsttier=lsttier+','+suggestedTier;
                }
                flag=True;
            }
        }
        flag=False;

        //**************get fetch the exact Tier for based on Frond end Max loss value*************************
        for(Tier_Level__c  l2 : Frndend_Max_cst)
        {
            if((frntendMaxls <=l2.Front_End_Loss_Max_Year__c)&& flag==False)
            {
                suggestedTier=l2.Tier__c;
                if(lsttier==null)
                {
                    lsttier=suggestedTier;
                }
                else
                {
                    lsttier=lsttier+','+suggestedTier;
                }
                flag=True;
            }
        }
        flag=False;
        //**************get fetch the exact Tier for based on Frond end cost value*************************
        for(Tier_Level__c  l3 : Frndend_cst)
        {
            if((FrndEndcst <=l3.Front_End_Loss__c)&& flag==False)
            {
                suggestedTier=l3.Tier__c;
                if(lsttier==null)
                {
                    lsttier=suggestedTier;
                }
                else
                {
                    lsttier=lsttier+','+suggestedTier;
                }
                flag=True;
            }
        }
        flag=False;

        //**************get fetch the exact Tier for based on Exposed cost  Max loss value*************************
        for(Tier_Level__c  l4 : Exposed_Max_list)
        {
            if((ExcostMx <=l4.Exposed_Cost_Max_Year_K__c)&& flag==False)
            {
                suggestedTier=l4.Tier__c;
                if(lsttier==null)
                {
                    lsttier=suggestedTier;
                }
                else
                {
                    lsttier=lsttier+','+suggestedTier;
                }
                flag=True;
            }
        }
        flag=False;

        //**************get fetch the exact Tier for based on Standard Term*************************
        for(Tier_Level__c  l5 : std_Revenue_lst)
        {
            if((Revenue <=l5.X5_Year_Revenue__c)&& flag==false)
            {
                suggestedTier=l5.Tier__c;

                if(lsttier==null)
                {
                    lsttier=suggestedTier;
                }
                else
                {
                    lsttier=lsttier+','+suggestedTier;
                }
                flag=True;
            }
        }
        flag=False;

        //**************get fetch the exact Tier for based on Non standard Term*************************
        for(Tier_Level__c  l6 : Non_Revenue_lst)
        {
            if((Revenue <=l6.Non_Standard_Term__c) && flag==false)
            {
                suggestedTier=l6.Tier__c;

                if(lsttier==null)
                {
                    lsttier=suggestedTier;
                }
                else
                {
                    lsttier=lsttier+','+suggestedTier;
                }
                flag=True;
            }
        }
        //flag=False;
        //*****************************end of the query*****************8
        /*if(lsttier==null)
          {
            lsttier=suggestedTier;
          }
        else
        {
            lsttier=lsttier+','+suggestedTier;
        }
        flag=False;*/
    }

    public void checkduplicateval_New()
    {
        if(lsttier!=null)
        {
            words= lsttier.split(',');

            length=words.size();

            for(integer i=0;i<words.size();i++)
            {
                if(!lststr.contains(words[i]))
                {
                    lststr.add(words[i]);
                }
            }

            for(integer j=0;j<lststr.size();j++)
            {
                if(j==0)
                {
                    lstsuggestedTier=lststr[j];
                }
                else
                {
                    lstsuggestedTier=lstsuggestedTier+','+lststr[j];
                }
            }

            /*
            str.addall(lststr);

            system.debug('str:' + str);

            lststr1.addall(str);

            system.debug('lststr1:' + lststr1);
            for(integer j=0;j<lststr1.size();j++)
            {
                   if(j==0)
                   {
                       lstsuggestedTier=lststr1[j];
                }
                   else
                   {
                       lstsuggestedTier=lstsuggestedTier+','+lststr1[j];
                   }
                   system.debug('lstsuggestedTier:' + lstsuggestedTier);
               }
            */
        }
    }
/*
    public void checkduplicateval()
    {
        system.debug('lsttier:' + lsttier);
        if(lsttier!=null)
        {
            words= lsttier.split(',');

            length=words.size();

            system.debug('words:' + words);

            for(integer i=0;i<words.size();i++)
            {
                lststr.add(words[i]);
            }

            str.addall(lststr);

            system.debug('str:' + str);

            lststr1.addall(str);

            system.debug('lststr1:' + lststr1);
            for(integer j=0;j<lststr1.size();j++)
            {
                if(j==0)
                {
                    lstsuggestedTier=lststr1[j];
                }
                else
                {
                    lstsuggestedTier=lstsuggestedTier+','+lststr1[j];
                }
                system.debug('lstsuggestedTier:' + lstsuggestedTier);
            }
        }
    }
 */
//updateegreensheet1
/*
set<id> wdid =new set<id>();
set<id> oppid =new set<id>();
list<Workflow_Details__c>wlist=new list<Workflow_Details__c>();
 list<Workflow_Details__c>wdlist=new list<Workflow_Details__c>();
for(Workflow_Details__c wd:Trigger.new)
{
if((wd.Opportunity_Description__c!=null)||(trigger.isUpdate && wd.Opportunity_Description__c!=Trigger.oldmap.get(wd.id).Opportunity_Description__c))
{
  system.debug('ooooo AM IN ');
 oppid.add(wd.Opportunity_Description__c);
 wdid.add(wd.id);
 }
 }
list<Opportunity>opplist=new list<Opportunity>();
if(oppid.size()>0)
{
opplist=[select Id,Account_Name_formula__c,Opportunity_Number__c,RecordTypeId,ATR_Opportunity_P_DR__c,AccountId,Opportunity_Owner_formula__c,Record_Type_Name__c,Name,CBT_Tier_2__c,Region__c,SBU__c from Opportunity where Id IN:oppid];
//wlist=[select Id,Customer_Name__c,Opportunity_Name__c,  Atlas_or_P_DR__c,Opportunity_Description__c from Workflow_Details__c where Opportunity_Description__c IN:oppid];
}

for(Workflow_Details__c wd:Trigger.new)
{

    if (opplist.size()>0 && opplist.isEmpty() == false)
    {
        for(Opportunity opplist1:opplist){
            if(opplist1.id==wd.Opportunity_Description__c){
                wd.Opportunity_Name__c=opplist1.Name;
                wd.Atlas_or_P_DR__c=opplist1.Opportunity_Number__c;
                wd.Customer_Name__c=opplist1.AccountId;
                wd.Opportunity_Lead_Owner__c=opplist1.Opportunity_Owner_formula__c;
                wd.Opportunity_Number__c=opplist1.Opportunity_Number__c;
                if(opplist1.SBU__c=='ATR')
                {
                    wd.ATR__c=True;
                      wd.BG_A__c=False;
                      wd.Defence_Space__c=False;
                    }
                 else if(opplist1.SBU__c=='BGA')
                  {
                 wd.BG_A__c=True;
                 wd.ATR__c=False;
                 wd.Defence_Space__c=False;
                  }
                else if(opplist1.SBU__c=='D&S')
                  {
                  wd.Defence_Space__c=True;
                  wd.BG_A__c=False;
                 wd.ATR__c=False;

                  }
                  else
                  {
                  wd.ATR__c=False;
wd.BG_A__c=False;
wd.Defence_Space__c=False;
                  }
                  if(opplist1.RecordTypeId==label.AM_Catalog || opplist1.RecordTypeId==label.AM_Complex || opplist1.RecordTypeId==label.AM_Standard)
                  {
                  wd.AM__c=True;
                  wd.OE__c=False;
                  }
                  else if(opplist1.RecordTypeId==label.OE_Complex || opplist1.RecordTypeId==label.OE_Standard)
                  {
                  wd.AM__c=False;
                  wd.OE__c=True;
                  }
                  else
                  {
                  wd.AM__c=False;
                  wd.OE__c=False;
                  }
                  if(opplist1.Region__c=='Americas')
                  {
                  wd.Americas__c=True;
                  wd.APAC__c=False;
                   wd.EMEAI__c=False;
                   wd.Global__c=False;
                   }
                 else if(opplist1.Region__c=='Asia/Pacific Rim')
                  {
                  wd.Americas__c=False;
                  wd.APAC__c=True;
                   wd.EMEAI__c=False;
                   wd.Global__c=False;
                  }
                 else if(opplist1.Region__c=='Europe/MiddleEast/Africa/India')
                  {
                  wd.Americas__c=False;
                  wd.APAC__c=False;
                   wd.EMEAI__c=True;
                   wd.Global__c=False;
                  }
                  else
                  {
                  wd.Americas__c=False;
                  wd.APAC__c=False;
                   wd.EMEAI__c=False;
                   wd.Global__c=True;
                  }
                if(opplist1.CBT_Tier_2__c=='Airlines')
                 {
                 wd.Airlines__c=True;
                 wd.Airbus__c=False;
                 wd.RACC__c=False;
                 wd.Boeing__c=False;
                  wd.HTSI__c=False;
               }
              else  if(opplist1.CBT_Tier_2__c=='Airbus')
                  {
                  wd.Airlines__c=False;
                 wd.Airbus__c=True;
                 wd.RACC__c=False;
                 wd.Boeing__c=False;
                 wd.HTSI__c=False;
                             }
              else if(opplist1.CBT_Tier_2__c=='Boeing ATR')
              {
              wd.Airlines__c=False;
                 wd.Airbus__c=False;
                 wd.RACC__c=False;
                 wd.Boeing__c=True;
                  wd.HTSI__c=False;
              }
              else if(opplist1.CBT_Tier_2__c=='Components Business')
              {
              wd.Airlines__c=False;
                 wd.Airbus__c=False;
                 wd.RACC__c=True;
                 wd.Boeing__c=False;
                  wd.HTSI__c=False;
              }
               else if(opplist1.CBT_Tier_2__c=='HTSI')
                        {
                 wd.Airlines__c=False;
                 wd.Airbus__c=False;
                 wd.RACC__c=False;
                 wd.Boeing__c=False;
                  wd.HTSI__c=True;
                        }
                        else
                        {
                        wd.Airlines__c=False;
                 wd.Airbus__c=False;
                 wd.RACC__c=False;
                 wd.Boeing__c=False;
                  wd.HTSI__c=False;
                  }
                //wdlist.add(wd);
            }
        }
    }
}*/
/*
if(wdlist.size()>0)
{
update wdlist;
}
*/

}