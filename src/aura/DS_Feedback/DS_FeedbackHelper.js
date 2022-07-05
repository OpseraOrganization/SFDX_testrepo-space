({
    	  setimagebackground : function(component) {
                var imageLabel = $A.get("$Label.c.DSI_Feedbackimage");
             component.set("v.selectedsurveyimage", imageLabel);
          },
         
   })