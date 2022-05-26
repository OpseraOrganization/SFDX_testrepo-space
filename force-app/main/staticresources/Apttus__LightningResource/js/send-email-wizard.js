$(document).ready(function () {
    
    for (i = 1; i <= tooltips.length; i++) {
        $("#step-" + i + "-tooltiptext").text(tooltips[i - 1]);
    }

    
    $("img.lookupIcon").after('<svg class="slds-lookup-icon slds-icon_xx-small" aria-hidden="true"><use href="'+imageSource+'" /></svg>');
    $("img.lookupIcon").remove();
    
});