/*******************************
Class Name: DS_Util
Created by: Accenture
Last modified by: Nokia
Description: This class contains the commonly used functions on various components.
*******************************/
public without sharing class DS_Util {

	/*******************************
	Function Name: getTechnologies
	Created by: Accenture
	Last modified by: Accenture
	Description: This method is responsible for getting All technology configured from Technology usecase custom setting.
	*******************************/
	public static List<SelectOption> getTechnologies() {
		set<String> techSet = new Set<String>();
		List<selectOption> technologySelectOption = new List<SelectOption>();

		technologySelectOption.add(new SelectOption(CSWXGlobalConstant.NONE_OPTION_VALUE, CSWXGlobalConstant.NONE_OPTION_VALUE));
		for (DS_Technology_Usecase_Combination__c obj : [SELECT Id, Name, DS_Technology__c, DS_Usecase__c FROM DS_Technology_Usecase_Combination__c ORDER BY DS_Technology_Order_Number__c]) {
			techSet.add(obj.DS_Technology__c);
		}
		if(!techSet.isEmpty()) {
			for (String item : techSet) {
	technologySelectOption.add(new SelectOption(item, item));
			}
		}
		return technologySelectOption;
	}

	/*******************************
	Function Name: getUseCaseOnTechnology
	Created by: Accenture
	Last modified by: Accenture
	Description: This method is responsible for getting All Usecase based on Technology selected from configured from Technology usecase custom setting.
	*******************************/
	public static List<selectOption> getUseCaseOnTechnology(String selectedTechnology) {
		List<selectOption> useCaseSelectOption = new List<SelectOption>();

		usecaseSelectOption.add(new SelectOption(CSWXGlobalConstant.NONE_OPTION_VALUE, CSWXGlobalConstant.NONE_OPTION_VALUE));
		for (DS_Technology_Usecase_Combination__c obj : [SELECT Id, Name, DS_Technology__c, DS_Usecase__c FROM DS_Technology_Usecase_Combination__c WHERE DS_Technology__c = :selectedTechnology ORDER BY DS_UseCase_Order_Number__c]) {
			useCaseSelectOption.add(new SelectOption(obj.DS_Usecase__c,obj.DS_Usecase__c));
		}
		return useCaseSelectOption;
	}

	/*******************************
	Function Name: getTechnologiesForLC
	Created by: Accenture
	Last modified by: Accenture
	Description: This method is responsible for getting All technology configured from Technology usecase custom setting.
	*******************************/
	@AuraEnabled
	public static List<String> getTechnologiesForLC() {
		Set<String> techSet = new Set<String>();
		List<String> techValuesList = new List<String>();
		for (DS_Technology_Usecase_Combination__c obj : [SELECT Id, Name, DS_Technology__c, DS_Usecase__c FROM DS_Technology_Usecase_Combination__c ORDER BY DS_Technology_Order_Number__c]) {
			techSet.add(obj.DS_Technology__c);
		}
		techValuesList.addAll(techSet);
		return techValuesList;
	}

	/*******************************
	Function Name: getUseCaseOnTechnologyForLC
	Created by: Accenture
	Last modified by: Accenture
	Description: This method is responsible for getting All Usecase based on Technology selected from configured from Technology usecase custom setting.
	*******************************/
	@AuraEnabled
	public static List<String> getUseCaseOnTechnologyForLC(String selectedTechnology) {
		List<String> useCaseSelectOption = new List<String>();
		for (DS_Technology_Usecase_Combination__c obj : [SELECT Id, Name, DS_Technology__c, DS_Usecase__c FROM DS_Technology_Usecase_Combination__c WHERE DS_Technology__c = :selectedTechnology ORDER BY DS_UseCase_Order_Number__c]) {
			useCaseSelectOption.add(obj.DS_Usecase__c);
		}
		return useCaseSelectOption;
	}
}