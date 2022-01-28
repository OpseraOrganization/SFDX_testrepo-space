function doUpdateSolutionObjectList() {
  $("#SolutionObjectsInOrder ol").html("");
  for (var x in oGActiveSolution.objects) {
    $("#SolutionObjectsInOrder ol").append("<li><a href='#' onclick='doEditSolutionComponent(\"" + oGActiveSolution.objects[x].id + "\")'>" + oGActiveSolution.objects[x].name + "</a></li>");
  }
  $nuxt.$bus.$emit('webWorker-vue_update-solution-object-list', oGActiveSolution);
}

function doExportSU() {
    oGActiveSolution.type = "Solution";

  var blob = new Blob([JSON.stringify(oGActiveSolution)]);

  if (navigator.appVersion.toString().indexOf('.NET') > 0)
    window.navigator.msSaveBlob(blob, 'solution_export.json');
  else {
    var el = document.createElement('a');
    var url = window.URL.createObjectURL(blob, {
      type: 'application/json'
    });
    el.setAttribute('href', url);
    el.setAttribute('download', 'solution_export.json');

    el.style.display = 'none';
    document.body.appendChild(el);

    el.click();
    window.URL.revokeObjectURL(url);
    document.body.removeChild(el);
  }
}


/*
function doStartWorker(sInObjectId) 
{
 try
 {
  if(typeof(Worker) !== "undefined")
  {
   if (sInObjectId != "") 
   {
	if(typeof(oWebWorkers[sInObjectId]) === "undefined")
	{
	 oWebWorkers[sInObjectId] = new Worker("doCATSolution.js?version=22");
	}
	oWebWorkers[sInObjectId].onmessage = function (event) 
	{
	 oRespObj = JSON.parse(event.data);
	 if(oRespObj.meta)
	 {//New API
      //$("#content").html("<iframe src='' style='border:none;'>"+JSON.stringify(oRespObj)+"</iframe>");
	  var sUIHTML="";
	  if(oRespObj.data)
	  {
	   for(var kk=0;kk<oRespObj.data.length;kk++)
	   {
		if((oRespObj.data[kk].type||"").toUpperCase()=="ATTRIBUTE") 
        {
		 if((oRespObj.data[kk].selector||"").toUpperCase()=="SELECT") 
         { 
	      sUIHTML+='<div class="form-group">';
          sUIHTML+= '<label for="sel1">Select list:</label>';
          sUIHTML+= '<select class="form-control" id="'+oRespObj.data[kk].id+'">';
		  for(var nn=0;nn<oRespObj.data[kk].options.length;nn++)
		  {	  
           sUIHTML+=  '<option>'+oRespObj.data[kk].options[nn].indexObj+'</option>';
		  } 
          sUIHTML+= '</select>';
          sUIHTML+='</div>';
		 }	
		}			
	   }	   
      }
      $("#content").html(sUIHTML+"<br>"+JSON.stringify(oRespObj));
     }
     else
     {		 
      oGActiveSolution = JSON.parse(JSON.stringify(oRespObj.data.solution));
	  oGActiveSolution.data={};
	  doUpdateSolutionObjectList();
	  var sSelectionList="";
	  if(oRespObj.data.solution.lGSelections)
	  {
	   sSelectionList="<div class=\"list-group\">";	 
	   for(var z in oRespObj.data.solution.lGSelections)
       {		  
        sSelectionList+="<a href=\"#\" class=\"list-group-item\">"+JSON.stringify(oRespObj.data.solution.lGSelections[z])+"</a>";
	   }  
       sSelectionList+="</div>";
      }     
	  $("#content").html((oRespObj.data.sHTML||""));
	  $("#SalesItemSlot").html(oRespObj.data.sHTMLSI||"");
	  $("#SelectionSlot").html(sSelectionList||"");
	  var sRequirementList="<div class=\"list-group\">",sServiceList="<div class=\"list-group\">";
	  for(var z in oRespObj.data.solution.objects)
      {		  
       if(oRespObj.data.solution.objects[z].requirements)
	   {
		sRequirementList+="<a href=\"#\" class=\"list-group-item\">"+JSON.stringify(oRespObj.data.solution.objects[z].requirements)+"</a>";
	   }	
	   if(oRespObj.data.solution.objects[z].services)
	   {
		sServiceList+="<a href=\"#\" class=\"list-group-item\">"+JSON.stringify(oRespObj.data.solution.objects[z].services)+"</a>";
	   }	
	  }  
	  sRequirementList+="</div>";
	  sServiceList+="</div>";
	  $("#FreeReqSlot").html(sRequirementList);
	  $("#FreeSerSlot").html(sServiceList);
	  if((oRespObj.data.sHTMLSI||"")!="")
	  {	 
       $("#solutionsalesitemgroup").show();
	  }
      else
      {
       $("#solutionsalesitemgroup").hide();
	  }
      if(oRespObj.data.files)
	  {	 
       for(var x in oRespObj.data.files)
       {
	    if((oRespObj.data.files[x].fileName!="")&&(oRespObj.data.files[x].text!=""))	  
	    {	   
	     var location = (oRespObj.data.files[x].fileName || "Bom_import_to_CSP.xml");
	     var blobObject = new Blob([oRespObj.data.files[x].text]);
	     window.navigator.msSaveBlob(blobObject, location);
	    }	
	   }		  
	  }
	  try{document.getElementById("TESObjects").setAttribute("class", "panel panel-warning")}catch(e){}
      if((oRespObj.data["-CONSISTENT"] == "T") && (oRespObj.data["-COMPLETE"] == "T")) 
	  {
	   try{document.getElementById("TESObjects").setAttribute("class", "panel panel-success")}catch(e){}
	  } 
	 }
    }
   }
  }   
 }catch(e)
 {
  console.log(e.message);
 }
}

*/