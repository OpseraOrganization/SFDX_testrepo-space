({
  // Create the datatable and load it
  init: function(component) {
    var thisHelper = this;
    component.set("v.Spinner", true);
    thisHelper
      .getCaseDetails(component)
      .then(function(result) {
        // Set the search fields to the case fields
        var caseDTO = result;
        component.find("severity").set("v.value", caseDTO.severity);
        component.find("customer").set("v.value", caseDTO.customerId);
        component.set("v.recordTypeName", caseDTO.recordTypeName);
        // Temp fix to load a single value picklist with a value when
        // mutliple values are possible
        //component.find("levelOfSupport").set("v.value", caseDTO.levelOfSupport.split(";")[0]);
        component.find("levelOfSupport").set("v.value", caseDTO.levelOfSupport);                       
        if (caseDTO.workgroupTypes.includes("Engineer")) {
        	component.find("workgroupType").set("v.value", "Engineer");
        } else {
                component.find("workgroupType").set("v.value", caseDTO.workgroupType);
        }
        component.find("region").set("v.value", caseDTO.region);
        component.find("country").set("v.value", caseDTO.country);
        component.find("product").set("v.value", caseDTO.productId);
        component.find("productModule").set("v.value", caseDTO.productModule);
        component.find("productVariant").set("v.value", caseDTO.productVariant);
        component.find("productRelease").set("v.value", caseDTO.productRelease);
        component.find("solution").set("v.value", caseDTO.solution);
        component.find("outage").set("v.value", caseDTO.outage);
        component.find("schedule").set("v.value", false);
		 //34648
		  if(caseDTO.HWSRecordTypeCheck){
			  component.find("serviceType").set("v.value", 'Hardware Support');
			  component.set("v.disableServiceType",true);
		  }
		  else{
			  component.find("serviceType").set("v.value", caseDTO.serviceType);
		  }
        component.find("solution").set("v.value", caseDTO.solution);
        component.find("productModule").set("v.value", caseDTO.productModule);
        component.find("productVariant").set("v.value", caseDTO.productVariant);
        component.find("productRelease").set("v.value", caseDTO.productRelease);
        //  var setVal=component.find("contractType").get("v.value");
        component.set("v.selectedValue", caseDTO.contractType);
        //return thisHelper.getWorkgroupMembersInitialLoad(component);
		return thisHelper.getWorkgroupMembersOnInitialLoad(component);
      })
      .then(function(result) {
        component.set("v.workgroupMembers", result);
        thisHelper.createTable(component);
        thisHelper.refreshTable(component, result);
        thisHelper.getCaseTeamRoles(component);
		if(result!=0  && result != null){
		thisHelper.displayWorkgrpInstructions(component, result);
		}
        component.set("v.Spinner", false);
      })
      .catch(function(error) {
        component.set("v.Spinner", false);
        var messageBox = component.find("messageBox");
        messageBox.displayToastMessage("An error occured. " + error, "error");
      });
  },
  // Create the table to display the workgroup members
  createTable: function(component) {
    var tableId = "#workgroupMembers-" + component.get("v.recordId");
    var thisHelper = this;
    $(tableId).DataTable({
      columnDefs: [
        {
          orderable: false,
          render: function(data, type, row, meta) {
            var buttonsDiv = "";
            if (row["role"] != "Queue") {
              buttonsDiv +=
                '<div><input type=button id="connect" value="Connect" onclick="{!c.search}" ></div>';
            }
            return buttonsDiv;
          },
          data: null,
          defaultContent: "",
          width: "4em",
          targets: 0,
          title: "Options"
        },
        {
          orderable: false,
          render: function(data, type, row, meta) {
            if (row["role"] != "Hotline") {
              return (data = '<input type=button id="add" value="Add" >');
            }
          },
          data: null,
          defaultContent: "",
          width: "4em",
          targets: 1
        },
        {
          data: "name",
          defaultContent: "",
          className: "popup",
          width: "15em",
          targets: 2,
          title: "Member Details"
        },
        {
          data: "scheduleType",
          defaultContent: "",
          width: "7em",
          targets: 3,
          title: "Schedule Type"
        },
        {
          data: "role",
          defaultContent: "",
          width: "15em",
          targets: 4,
          title: "Role"
        },
        {
          data: "phone",
          defaultContent: "",
          width: "8em",
          targets: 5,
          title: "Phone"
        },
        {
          data: "workgroupName",
          defaultContent: "",
          width: "15em",
          targets: 6,
          title: "Workgroup"
        },
		{
                    data: null,
                    render: function(data, type, row, meta) {
                        if (true) {
                            return (data = '<button id="Instructions" class="getInstructions"><span style="font-size:18px;">&#9432;</span></button>');
                        }
                    },
                    defaultContent: "",
                    width: "2em",
                    targets: 7
                    
                },
        {
          data: "ruleOrderNumber",
          defaultContent: "",
          width: "4em",
          targets: 8,
          title: "Rule #"
        },
        {
          data: "levelOfSupport",
          defaultContent: "",
          width: "10em",
          targets: 9,
          title: "Level Of Support"
        },
        {
          data: "lastCaseAssigned",
          defaultContent: "",
          mRender: function(data, type, full) {
            var date = new Date(data);
            var locale = $A.get("$Locale.datetimeFormat");
            return (
              $A.localizationService.formatDateTime(date) 
              );
          },
          type: "date",
          width: "15em",
          targets: 10,
          title: "Last Case Assigned"
        },
          {
          data: "lastEngagement",
          defaultContent: "",
          mRender: function(data, type, full) {
            var date = new Date(data);
            var locale = $A.get("$Locale.datetimeFormat");
            return (
              '<input class="slds-input" type="text" readonly value="' +
              $A.localizationService.formatDateTime(date) +
              '" />'
            );
          },
          type: "date",
          width: "15em",
          targets: 14,
          title: "IM Last Engagement"
        },
        {
          data: "roleOrderNumber",
          defaultContent: "",
          targets: 11,
          visible: false
        },
        {
          data: "scheduleTypeOrderNumber",
          defaultContent: "",
          targets: 12,
          visible: false
        },
		{
                    data: "workgroupId",
                    defaultContent: "",
                    targets: 13,
                    visible: false
        }
      ],
      ordering: true,
      autoWidth: false,
      rowId: "userId",
      pageLength: 5,
      lengthMenu: [5, 10, 25]
    });
    // When the mouse hovers over the member column display a popup
    $(tableId).on("mouseenter", "td.popup", function() {
      var tr = $(this).closest("tr");

      var rowData = $(tableId)
        .DataTable()
        .row(tr);
      if (rowData.data()["role"] == "Hotline") {
        var popUp = "Hotline Number: " + rowData.data()["phone"];
        this.setAttribute("title", popUp);
      } else {
        // If a user
        var popUp = "Email: " + rowData.data()["email"];
        this.setAttribute("title", popUp);
      }
    });
    // When the add button is clicked
    $(tableId).on("click", "#add", function() {
      var tr = $(this).closest("tr");
      var rowId = $(tableId)
        .DataTable()
        .row(tr)
        .id();
      component.set("v.userIdToAddToCaseTeam", rowId);
      var CaseId = component.get("v.recordId");
      thisHelper
        .validateInsertMember(component)
        .then(function(result) {
        	component.set("v.showSelectRoleModal", true);         
        })
        .catch(function(error) {
        	component.set("v.Spinner", false);
          	var messageBox = component.find("messageBox");
            	messageBox.displayToastMessage("Error : " + error, "error");
        });
    });
    // When connect button is clicked
    $(tableId).on("click", "#connect", function() {
      var tr = $(this).closest("tr");
      var email = $(tableId).DataTable().row(tr).data()['email']; //['email'];
      var ciscoLink='CISCOIM:' + email;
      //location.href=ciscoLink;
      //alert("This feature is currently not available because of known Salesforce issue");
	  try {
            location.href=ciscoLink;
        }
        catch(err) {
            var name=$(tableId).DataTable().row(tr).data()['name'];
            var phone=$(tableId).DataTable().row(tr).data()['phone'];
            if(phone === 'undefined' || phone === undefined || phone ===null || phone ===NaN ){
                phone='';
            }
            if(email === 'undefined' ||email === undefined || email ===null || email ===NaN){
                email='';
            }
            var textMessage='Impossible to Connect to Jabber \n'+name+' Contact details are the following: \n'+'Phone: '+phone+'\n'+'Email: '+email+'\n Warning: Max 3 Contacts details can be displayed at the same time.';
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                mode: 'Sticky',
                message: textMessage,
                type : 'Info'
                
            });
            toastEvent.fire();
        }
    });
	//When Instruction button is clicked
        $(tableId).on('click', '#Instructions', function() {
            var tr = $(this).closest('tr');
            var getWorkgroupId = $(tableId).DataTable().row(tr).data()['workgroupId'];
            component.set("v.captureWorkgroupId", getWorkgroupId);  
			var getWorkgroupName = $(tableId).DataTable().row(tr).data()['workgroupName'];
            component.set("v.captureWorkgroupName", getWorkgroupName); 
            console.log('captureWorkgroupId'+component.get("v.captureWorkgroupId"));
            component.set("v.showworkgroupInstructions", true);
			var callController=component.get("c.handleWorkgroupInstructions");
            $A.enqueueAction(callController);
            
        });
  },
  // Refresh the table after new workgroup members are loaded
  refreshTable: function(component, workgroupMembers) {
    var tableId = "#workgroupMembers-" + component.get("v.recordId");
    $(tableId)
      .DataTable()
      .clear()
      .rows.add(workgroupMembers)
      // Sort by: Rule Number, Schedule Type, Role Order Number, Last assigned date, Member Details
      .order([8, "asc"], [12, "asc"], [11, "asc"], [10, "asc"], [2, "asc"])
      .draw();
  },
  // Get the case details to load into the search window
  getCaseDetails: function(component) {
    var promise = new Promise(function(resolve, reject) {
      const sharedjs = component.find("sharedJavaScript");
      resolve(
        sharedjs.apex(component, "getCaseFields", {
          caseId: component.get("v.recordId")
        })
      );
    });
    return promise;
  },
  // Get the workgroup members for the initial load
  getWorkgroupMembersInitialLoad: function(component) {
    var thisHelper = this;
    var promise = new Promise(function(resolve, reject) {
      const sharedjs = component.find("sharedJavaScript");
      resolve(
        sharedjs.apex(component, "getWorkgroupMembers", {
          caseId: component.get("v.recordId"),
          searchCriteriaJSON: thisHelper.createSearchCriteriaDTO(component)
        })
      );
    });
    return promise;
  },
  
   // Get the workgroup members for the initial load
  getWorkgroupMembersOnInitialLoad: function(component) {
    var thisHelper = this;
    var promise = new Promise(function(resolve, reject) {
      const sharedjs = component.find("sharedJavaScript");
      resolve(
        sharedjs.apex(component, "getWorkgroupMembersOnInitialLoad", {
          caseId: component.get("v.recordId")         
        })
      );
    });
    return promise;
  },
  // Add the user on the row where the add button is clicked to the case team
  addUserToCaseTeam: function(component) {
    var promise = new Promise(function(resolve, reject) {
      const sharedjs = component.find("sharedJavaScript");
      resolve(
        sharedjs.apex(component, "insertMember", {
          userId: component.get("v.userIdToAddToCaseTeam"),
          caseId: component.get("v.recordId"),
          selectedRole: component.find("caseTeamRole").get("v.value")
        })
      );
    });
    return promise;
  },
  // Search for workgroup members when the search button is clicked
  searchWorkgroupMembers: function(component) {
    var thisHelper = this;
    var promise = new Promise(function(resolve, reject) {
      const sharedjs = component.find("sharedJavaScript");
      resolve(
        sharedjs.apex(component, "searchWorkgroupMembers", {
          caseId: component.get("v.recordId"),
          searchCriteriaJSON: thisHelper.createSearchCriteriaDTO(component)
        })
      );
    });
    return promise;
  },
  // Create JSON with the search criteria DTO
  createSearchCriteriaDTO: function(component) {
    var selectedType = component.find("mySelect").get("v.value");
    if (selectedType == "") {
      component.set("v.selectedValue", "--None--");
    }
    var contractType = component.get("v.selectedValue");
    var searchCriteriaDTO = {
      severity: component.find("severity").get("v.value"),
      levelOfSupport: component.find("levelOfSupport").get("v.value"),
      contract: component.find("contract").get("v.value"),
      customerId: component.find("customer").get("v.value"),
      productId: component.find("product").get("v.value"),
      region: component.find("region").get("v.value"),
      customerGroupId: component.find("customerGroup").get("v.value"),
      productGroupId: component.find("productGroup").get("v.value"),
      country: component.find("country").get("v.value"),
      outage: component.find("outage").get("v.value"),
      workgroupType: component.find("workgroupType").get("v.value"),
      serviceType: component.find("serviceType").get("v.value"),
      productModule: component.find("productModule").get("v.value"),
      productVariant: component.find("productVariant").get("v.value"),
      productRelease: component.find("productRelease").get("v.value"),
      solution: component.find("solution").get("v.value"),
      schedule: component.find("schedule").get("v.value"),
      activeRules: "true",
      contractType: component.get("v.selectedValue")
    };
    return JSON.stringify(searchCriteriaDTO);
  },
  getCaseTeamRoles: function(component) {
        //34648
        if(component.get("v.recordTypeName").startsWith('HWS')){
            var options = [
				{ label: "Customer Care Manager", value: "Customer Care Manager" },
                { value: "Quotation Manager", label: "Quotation Manager" },
                { value: "Quotation Manager - NokiaA", label: "Quotation Manager - NokiaA" },
                { value: "Quotation Manager - NokiaN", label: "Quotation Manager - NokiaN" },
                { value: "Warranty Manager - NokiaA", label: "Warranty Manager - NokiaA" },
                { value: "Warranty Manager - NokiaN", label: "Warranty Manager - NokiaN" },
                { value: "Warranty Manager", label: "Warranty Manager" },
                { value: "Price Manager - NokiaA", label: "Price Manager - NokiaA" },
                { value: "Price Manager - NokiaN", label: "Price Manager - NokiaN" },
                { value: "Price Manager", label: "Price Manager" }
            ];
        }
        else if (component.get("v.recordTypeName") === "CH_Problem") {
            var options = [
                { value: "Incident Owner", label: "Incident Owner" },
                { value: "Problem Expert", label: "Problem Expert" },
                { value: "Problem Support", label: "Problem Support" },
                { value: "Problem Manager", label: "Problem Manager" }
            ];
        } else {
            var options = [
                { label: "Customer Care Manager", value: "Customer Care Manager" },
                { label: "Incident Engineer", value: "Incident Engineer" },
                { label: "Incident Expert", value: "Incident Expert" },
                { label: "Incident Manager", value: "Incident Manager" },
                { label: "Incident Support", value: "Incident Support" },
                { label: "Incident Field Agent", value: "Incident Field Agent" },
                { label: "Problem Manager", value: "Problem Manager" },
                { label: "Problem Owner", value: "Problem Owner" },
                {
                    label: "Technical Escalation Manager",
                    value: "Technical Escalation Manager"
                },
                { label: "Case Manager", value: "Case Manager" }
            ];
        }
        component.set("v.caseTeamRoles", options);
    },
  loadOptions: function(component, event, helper) {
    var action = component.get("c.getRecords");
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        console.log(response.getReturnValue());
        component.set("v.options", response.getReturnValue());
      }
    });
    $A.enqueueAction(action);
  },
  // Validate Insert Member
  validateInsertMember: function(component) {
    var thisHelper = this;
    var promise = new Promise(function(resolve, reject) {
      const sharedjs = component.find("sharedJavaScript");
      resolve(
        sharedjs.apex(component, "validateInsertMember", {
          Userid: component.get("v.userIdToAddToCaseTeam"),
          caseId: component.get("v.recordId")
        })
      );
    });
    return promise;
  },
    //Calling WorkGroup Instructions from Search Button
	displayWorkgrpInstructions: function(component, workgroupMembers) {
        var tableId = "#workgroupMembers-" + component.get("v.recordId");
        var getWorkgroupId = $(tableId).DataTable().rows().data();
		component.set("v.captureWorkgroupId", getWorkgroupId[0].workgroupId);  
		component.set("v.captureWorkgroupName", getWorkgroupId[0].workgroupName);
        console.log('captureWorkgroupId'+component.get("v.captureWorkgroupId"));
        component.set("v.showworkgroupInstructions", true);
		var callController=component.get("c.handleWorkgroupInstructions");
        $A.enqueueAction(callController);
		
    },
});