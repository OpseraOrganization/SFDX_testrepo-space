({
	init : function(component, event, helper) {
        var action = component.get('c.getActiveSurveys');
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                let result= response.getReturnValue(),
                    validList = component.get('v.surveysSelected'),
                    surveyList = [];
                validList = (validList && validList.indexOf(',') == -1?validList.split(','):validList);
                for(let i = 0; i < result.length; i++)
                    if(!validList || validList.indexOf(result[i].Name) != -1)
                        surveyList= [...surveyList, result[i]];
                surveyList = (surveyList.length == 0?result:surveyList);
                component.set('v.surveyList', surveyList);
            }
        });
        $A.enqueueAction(action);
	},
    selectSurvey : function(component, event, helper) {
        var action = component.get('c.getSurveyQuestionsPerSurvey');
        action.setParams({SurveyActiveVersionId: component.find("selectSurvey").get("v.value")});
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                let result = [],
                    unsortedList = response.getReturnValue(),
                    defaultValues= [0,1,2,3,4,5,6,7,8,9,10];
                for(let i = 0; i < unsortedList.length; i++){
                    let found= false;
                    for(let j = 0; j < result.length; j++){
                        if(result[j].name === unsortedList[i].SurveyPage.Name.substring(2)){
                           if(unsortedList[i].QuestionType === 'CSAT')
                                unsortedList[i].QuestionChoices = defaultValues;
                           result[j].questions = [...result[j].questions, unsortedList[i]];
                           found = true;
                        }                        
                    }
                    if(!found)
                        result= [...result, {'name':unsortedList[i].SurveyPage.Name.substring(2), 'questions': [unsortedList[i]]}];
                }
                component.set('v.questionList', result);
            	component.set('v.curPage', 0);
            }
        });
        $A.enqueueAction(action);
    },
    selectRate : function(component, event, helper) {
        let found= false,
        	childrenList = $(event.target).parent().children(),
            value = $(event.target).val();
        $(event.target).parent().val(value);
        for(let i = 0; i < childrenList.length; i++){
            if(!found && !$(event.target).parent().hasClass('csat') || $(childrenList[i]).val() === value)
                $(childrenList[i]).addClass("active");
           	else
                $(childrenList[i]).removeClass("active");
            if($(childrenList[i]).val() === value) found = true;
        }
	},
    selectMultiChoice : function(component, event, helper) {
        let value = $(event.target).parent().val(),
            thisVal = $(event.target).val();
        if(value.indexOf(thisVal) != -1){
        	$(event.target).removeClass("active");
            $(event.target).parent().val(value.replace(thisVal+",",""));
        }
        else {
        	$(event.target).addClass("active");
            $(event.target).parent().val(value+thisVal+",");
        }
    },
    selectSlider : function(component, event, helper) {
    	$(event.target).val(event.getSource().get("v.value"));
	},
    checkComplete : function(component, event, helper) {
        //Do Nothing
    },
    changePage : function(component, event, helper) {
        let curPage = component.get('v.curPage'),
            targetPage = event.getSource().get("v.value");
        $("#Page"+curPage).hide();
        $("#Page"+targetPage).show();
        component.set('v.curPage', targetPage);
    },
    submitSurvey : function(component, event, helper) {
        $(".surveyBox").hide()
        $(".endSurveyBox").show();
        var action = component.get('c.insertSurveyQuestionsResponses');
        let questionList= JSON.parse(JSON.stringify(component.get('v.questionList')));
        let responseList = [], userId = $A.get("$SObjectType.CurrentUser.Id");
        for(let i = 0; i < questionList.length; i++){
            for(let j = 0; j < questionList[i].questions.length; j++){
                let response = {
                    SurveyVersionId : questionList[i].questions[j].SurveyVersionId,
                    CreatedById 	: userId,
                    QuestionId 		: questionList[i].questions[j].Id
                }, value = $("#"+questionList[i].questions[j].Id).val();
                switch($("#"+questionList[i].questions[j].Id).attr("class")){
                    case 'freetext':
                        response.ResponseShortText = value;
                        response.Datatype = "String";
                		responseList= [ ...responseList, response];
                        break;
                    case 'rating':
                        response.QuestionChoiceId = value.split('|')[0];
                        response.ResponseShortText = value.split('|')[1];
                        response.Datatype = "Number";
                		responseList= [ ...responseList, response];
                        break;
                    case 'csat':
                        response.ResponseShortText = value;
                        response.Datatype = "Number";
                		responseList= [ ...responseList, response];
                        break;
                    case 'date':
                        response.ResponseShortText = value;
                        response.Datatype = "String";
                		responseList= [ ...responseList, response];
                        break;
                    case 'slider':
                        response.ResponseShortText = value;
                        response.Datatype = "Number";
                		responseList= [ ...responseList, response];
                        break;
                    case 'multichoice':
                        let values= value.split(',');
                        for(let v = 0; v < values.length-1; v++){
                            let cResponse = JSON.parse(JSON.stringify(response));
                            cResponse.QuestionChoiceId = values[v].split('|')[0];
                            cResponse.ResponseShortText = values[v].split('|')[1];
                            cResponse.Datatype = "String";
                            responseList= [ ...responseList, cResponse];
                        }
                        break;
                    case 'picklist':
                        response.QuestionChoiceId = value.split('|')[0];
                        response.ResponseShortText = value.split('|')[1];
                        response.Datatype = "String";
                		responseList= [ ...responseList, response];
                        break;
                }
            }            
        }
        action.setParams({SurveyQuestionsResponses: JSON.stringify(responseList)});
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                $(".endSurveyBox").html('<div style="text-align: center; width: 100%;"><img src="'
                                     +component.get('v.imagePath')
                                     +'" class="surveyEndImage"/><br><br>'
                                     +component.get('v.submitText')
                                     +'<div>');
            }
            else {
                $(".surveyBox").show()
                $(".endSurveyBox").hide();
                helper.showToast("error", "Error submitting the survey. Try Again Later or contact an Admin.");                
            }
        });
        $A.enqueueAction(action);
    }
})