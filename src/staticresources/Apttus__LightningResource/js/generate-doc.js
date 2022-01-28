var tooltipGenerate = "{!$Label.apttus__selectattachments}";
            var tooltipSubmit = "{!$Label.apttus__selectdocumentprotectionoptional}";
            
            $(document).ready(function () {
    
                    
                        $("#generateBtnsyncTop").text(tooltipGenerate);                                                                           
                    
                });
				
				function showTooltip(divId) {
                var tooltipDiv = document.getElementById(divId);
                tooltipDiv.style.display = "block";
            }

            function hideTooltip(divId) {
                var tooltipDiv = document.getElementById(divId);
                tooltipDiv.style.display = "none";
            }