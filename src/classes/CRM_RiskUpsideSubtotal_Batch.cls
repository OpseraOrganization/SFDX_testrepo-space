global with sharing class CRM_RiskUpsideSubtotal_Batch implements Schedulable, Database.Batchable<SObject>, Database.Stateful {

	private String currentQuarter, nextQuarter;
	private Nokia_Financial_Calendar__c currentPeriod;

	public CRM_RiskUpsideSubtotal_Batch(){}

	global void execute(SchedulableContext sc) {
		database.executebatch(new CRM_RiskUpsideSubtotal_Batch(), 300);
	}

	global Database.QueryLocator start(Database.BatchableContext context)
	{
		getCurrentPeriod();
		//Should only run at the first day of the nokia financial calendar
		if(currentPeriod.Start_Date__c != System.today()){
			return Database.getQueryLocator([SELECT Id FROM Opportunity Limit 0]);
		}
		return Database.getQueryLocator([SELECT Id, Opportunity_Id__c , Risk_Subtotal__c, Upside_Subtotal__c from Opportunity where Open_OIF_Lines__c > 0 ]);
	}

	global void execute(Database.BatchableContext context, List<SObject> opptiesWithOIFs)
	{
		try{
			if(opptiesWithOIFs.isEmpty()) return;

			Map<Id,Opportunity> opportunities = new Map<Id,Opportunity>();
			for(Opportunity oppty : (List<Opportunity>)opptiesWithOIFs){
	opportunities.put(oppty.Id, new Opportunity(Id=oppty.Id,Upside_Subtotal__c=null,Risk_Subtotal__c =null));
			}
			//get already the sum per Category for this quarter and next one
			List<AggregateResult> oifsPerOppties = [SELECT Opportunity__c, Forecast_Category__c , SUM(OIF_Value_EUR__c)subtotal FROM Order_Intake_Forecast__c
				WHERE Opportunity__c IN :opportunities.keySet() AND (Quarter_Name__c=:currentQuarter OR Quarter_Name__c=:nextQuarter )  AND ( Forecast_Category__c = 'Risk' OR Forecast_Category__c = 'Upside' )
				GROUP BY Opportunity__c, Forecast_Category__c];

			for(AggregateResult oifsPerOppty : oifsPerOppties){
	Id opptyId = (Id)oifsPerOppty.get('Opportunity__c');
	if( !opportunities.containskey(opptyId) ) continue;
	Opportunity oppty = opportunities.get(opptyId);
	if(oifsPerOppty.get('Forecast_Category__c') == 'Upside'){
		oppty.Upside_Subtotal__c = getValue(oppty.Upside_Subtotal__c) + (Decimal)oifsPerOppty.get('subtotal');
	} else {
		oppty.Risk_Subtotal__c = getValue(oppty.Risk_Subtotal__c) + (Decimal)oifsPerOppty.get('subtotal');
	}
			}

			//remove from the list of opportunities to update the ones that the subtotals are unchanged, and add those which do not have any OIF lines for this and next quarter, but had a previous subtotal that now will be reset
			for( Opportunity currentValueOppty : (List<Opportunity>) opptiesWithOIFs ){
	Id opId = currentValueOppty.Id;
	if( currentValueOppty.Risk_Subtotal__c == opportunities.get(opId).Risk_Subtotal__c && currentValueOppty.Upside_Subtotal__c == opportunities.get(opId).Upside_Subtotal__c )
		opportunities.remove(opId);
			}
			System.debug('Risk & Upside Subtotals - #' + opportunities.size() + ' to be updated');
			Database.update(opportunities.values(),false);
		} catch (Exception e){
			System.debug('Exception - ' + e.getMessage());
		}
	}

	global void finish(Database.BatchableContext context){}

	public void getCurrentPeriod(){
		this.currentPeriod = [select Id, Quarter_Name__c, Start_Date__c, End_Date__c from Nokia_Financial_Calendar__c where Current_Period__c = true];
		this.currentQuarter = this.currentPeriod.Quarter_Name__c;
		this.nextQuarter = getNextQuarter(this.currentQuarter);
	}

	private String getNextQuarter(String currentQuarter){
		String[] data = currentQuarter.split('-Q');
		Integer year = Integer.valueOf(data[0]);
		Integer quarter = Integer.valueOf(data[1])+1;
		if(quarter==5){
			return String.valueOf(year+1)+'-Q1';
		} else {
			return String.valueOf(year)+'-Q'+String.valueOf(quarter);
		}
	}

	public Decimal getValue(Decimal subtotal){
		return subtotal == null ? 0 : subtotal;
	}
}