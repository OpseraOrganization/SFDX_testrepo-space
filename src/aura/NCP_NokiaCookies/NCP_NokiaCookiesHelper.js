({
    // populateContent: function (cmp, aContent) {
    //     var formattedBodyCopy = this.formatBodyCopy(cmp, aContent.Body_copy__c);
    //     var contentEl = cmp.find('bodyCopy').getElement();
    //     cmp.set('v.heading', aContent.Heading__c);
    //     cmp.set('v.headingCopy', aContent.Heading_copy__c);
    //     cmp.set('v.ctaText', aContent.CTA_text__c);
    //     contentEl.innerHTML = formattedBodyCopy;
    // },
    parseForBoldTags: function (match) {
        if (match === '<b>') {
            return '<b class="ncp-text-body_regular-bold">';
        } else {
            return '</b>';
        }
    },
    parseForUnderlineTags: function (match) {
        if (match === '<u>') {
            return '<span class="underline">';
        } else {
            return '</span>';
        }
    },
    formatBodyCopy: function (cmp, aCopy) {
        var i;
        var tempElement = document.createElement('div');
        var cleanCopy = aCopy.replace(/<b>|<\/b>/g, this.parseForBoldTags);
        var cleanerCopy = cleanCopy.replace(/<u>|<\/u>/g, this.parseForUnderlineTags);
        tempElement.innerHTML = cleanerCopy;
        var listElements = tempElement.getElementsByTagName('ul');
        var listElementsItems = tempElement.getElementsByTagName('li');
        var primaryHeadings = tempElement.getElementsByTagName('h1');
        var secondaryHeadings = tempElement.getElementsByTagName('h2');
        var level3Headings = tempElement.getElementsByTagName('h3');
        var level4Headings = tempElement.getElementsByTagName('h4');
        var otherHeadings = tempElement.querySelectorAll('h5, h6, h7');
        for (i = 0; i < listElements.length; ++i) {
            listElements[i].classList.add('slds-list_dotted');
            listElements[i].classList.add('slds-list_vertical-space');
            listElements[i].classList.add('slds-m-vertical_medium');
        }
        for (i = 0; i < primaryHeadings.length; ++i) {
            primaryHeadings[i].classList.add('ncp-text-headline_one');
        }

        for (i = 0; i < secondaryHeadings.length; ++i) {
            secondaryHeadings[i].classList.add('ncp-text-headline_two');
        }
        for (i = 0; i < level3Headings.length; ++i) {
            level3Headings[i].classList.add('ncp-text-headline_three');
        }
        for (i = 0; i < level4Headings.length; ++i) {
            level4Headings[i].classList.add('ncp-text-headline_four');
        }
        for (i = 0; i < otherHeadings.length; ++i) {
            otherHeadings[i].classList.add('ncp-text-subheader');
        }
        for (i = 0; i < listElementsItems.length; ++i) {
            listElementsItems[i].classList.add('slds-list__item');
        }
        return tempElement.innerHTML;
    }
});