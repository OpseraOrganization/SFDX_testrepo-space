/**
 * Created by tweinberger on 2019-04-02.
 */
({
    debouncedSearch: null,
    itemHeight: 27,
    maxShownResults: 10,
    scrollTopPixels: 0,
    scrollTopIndex: 0,
    resultsListElement: null,
    initSearch: function (component, event, helper) {
        var action = component.get('c.searchProductsJson');

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                //var matches = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.
                var data = JSON.parse(response.getReturnValue());
                component.set('v.allData', data);
            }
        });
        $A.enqueueAction(action);
    },

    doSearch: function (cmp, searchTerm) {
        this.showSpinner(cmp);
        var data = cmp.get("v.allData");
        if (searchTerm === '') {
            this.hideSpinner(cmp);
            return;
        }
        var regex = new RegExp(searchTerm, "i");
        var count = 1;
        var curruntSearch = [];
        cmp.set('v.searchResults', curruntSearch);
        $.each(data, function (key, val) {
            if (val.Name.search(regex) != -1) {
                count++;
                curruntSearch.push(val);
            }
        });
        if (!curruntSearch.length) {
            cmp.set('v.searchStatusMessage', 'No Result Found...');
            this.hideSpinner(cmp);
        } else {
            cmp.set('v.searchStatusMessage', '');
        }

        this.augmentAndSetResults(cmp, curruntSearch, searchTerm);

    },
    searchTermChange: function (cmp) {
        // only do this if there is not a saved search term
        if (!cmp.get('v.savedSearchTerm')) {
            var minChars = cmp.get('v.minNumOfChars') - 1;
            // get the search Input keyword
            var searchTerm = cmp.get('v.searchTerm').trim();
            if (searchTerm && searchTerm.length > minChars) {
                this.showResults(cmp);
                // this.debouncedSearch(cmp, searchTerm);
                // console.log('doing search');
                this.doSearch(cmp, searchTerm);
            } else {
                cmp.set('v.searchResults', []);
                this.hideResults(cmp);
            }
        } else {
            // console.log('Saved search term');
        }
    },
    doSearchOrg: function (cmp, searchTerm) {
        var action = cmp.get('c.searchProducts');
        action.setParams({
            searchKeyWord: searchTerm,
            objectName: cmp.get('v.objectAPIName')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var matches = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.
                if (!matches.length) {
                    cmp.set('v.searchStatusMessage', 'No Result Found...');
                } else {
                    cmp.set('v.searchStatusMessage', '');
                }
                // augment and set search results
                this.augmentAndSetResults(cmp, matches, searchTerm);
            }
        });
        $A.getCallback(function () {
            $A.enqueueAction(action);
        })();
    },
    showSpinner: function (cmp) {
        if (!cmp.get('v.isHidden')) {
            var listBox = cmp.find('ncp_productSearchResults').getElement();
            var spinner = cmp.find('ncp_productSearchSpinner');
            $A.util.addClass(listBox, 'ncp-is-searching');
            $A.util.removeClass(spinner, 'slds-hide');
        }
    },
    hideSpinner: function (cmp) {
        if (!cmp.get('v.isHidden')) {
            var listBox = cmp.find('ncp_productSearchResults').getElement();
            var spinner = cmp.find('ncp_productSearchSpinner');
            $A.util.addClass(spinner, 'slds-hide');
            $A.util.removeClass(listBox, 'ncp-is-searching');
        }
    },
    augmentAndSetResults: function (cmp, aMatches, aSearchTerm) {
        var regex = new RegExp(aSearchTerm, 'gi');
        // var resultEl = cmp.find('ncpSearchResults').getElement();
        aMatches.forEach(function (match) {
            match.hasFocus = false;
            // do the regex here
            var emboldenedText = match.Name.replace(regex, this.parseForMatchingClauses);
            match.matchedText = emboldenedText;
            // match.markup = this.getMatchMarkup(match);
            // resultEl.appendChild(match.markup);
        }, this);
        cmp.set('v.searchResults', aMatches);
        this.testForScrolling(cmp);
    },
    testForScrolling: function (cmp) {
        if (cmp.get('v.searchResults').length > 10) {
            // add the overflow scrolling;
            $A.util.addClass(this.resultsListElement, 'ncp_scrollable');
        } else {
            // remove it if it is present
            $A.util.removeClass(this.resultsListElement, 'ncp_scrollable');
        }
    },
    parseForMatchingClauses: function (match, pos, fullString) {
        var baseString = '<mark class="ncp-text-body_regular-bold">' + match + '</mark>';
        // find the position of the match in the fullString and if the next character is a space add an nbsp
        var matchPos = fullString.indexOf(match);
        var previousCharacter = fullString[matchPos - 1];
        var followingCharacter = fullString[matchPos + match.length];
        if (previousCharacter === ' ') {
            baseString = '&nbsp;' + baseString;
        }
        if (followingCharacter === ' ') {
            baseString += '&nbsp;';
        }
        return baseString;
    },
    getMatchMarkup: function (aMatch) {
        var listItem = document.createElement('li');
        listItem.setAttribute('role', 'presentation');
        listItem.classList.add('slds-listbox__item');
        var outerSpan = document.createElement('span');
        outerSpan.classList.add(
            'slds-media',
            'slds-listbox__option',
            'slds-listbox__option_entity',
            'slds-listbox__option_has-meta'
        );
        outerSpan.setAttribute('data-product-id', aMatch.Id);
        outerSpan.innerHTML = aMatch.matchedText;
        listItem.appendChild(outerSpan);
        return listItem;
    },
    getProductName: function (cmp) {
        var searchResults = cmp.get('v.searchResults');
        var productName = null;
        searchResults.forEach(function (result) {
            if (result.hasFocus) {
                productName = result.Name;
            }
        });
        return productName;
    },
    findFocusIdx: function (cmp) {
        var searchResults = cmp.get('v.searchResults');
        var focusIdx = null;
        searchResults.forEach(function (result, idx) {
            if (result.hasFocus) {
                focusIdx = idx;
            }
        });
        return focusIdx;
    },
    findAndShowProductPage: function (cmp) {
        // if there is only one item we should just show it
        var targetPageId;
        var searchResults = cmp.get('v.searchResults');
        var currentFocusIdx = this.findFocusIdx(cmp);
        if (currentFocusIdx || currentFocusIdx === 0) {
            targetPageId = searchResults[currentFocusIdx].Id;
        } else {
            // check that this isn't only one item
            if (searchResults.length === 1) {
                targetPageId = searchResults[0].Id;
            } else {
                // there is more than one item
                // show the first item in the list?
                // or do nothing?
                return false;
            }
        }
        this.showProductPage(cmp, targetPageId);
    },
    addItemToSelectedItems: function (cmp, aProductId) {
        var targetItem;
        var searchResults = cmp.get('v.searchResults');
        var selectedItems = cmp.get('v.selectedItems');
        if (aProductId) {
            // find the product by id
            searchResults.forEach(function (aResult) {
                if (aResult.Id === aProductId) {
                    targetItem = aResult;
                }
            });
        } else {
            var currentFocusIdx = this.findFocusIdx(cmp);
            if (currentFocusIdx || currentFocusIdx === 0) {
                targetItem = searchResults[currentFocusIdx];
            } else {
                // check that this isn't only one item
                if (searchResults.length === 1) {
                    targetItem = searchResults[0];
                }
            }
        }
        // augment the target item
        targetItem.name = targetItem.Name;
        targetItem.label = targetItem.Name;
        selectedItems.push(targetItem);
        cmp.set('v.selectedItems', selectedItems);
        this.cleanUp(cmp);
    },
    removeItemFromSelectedItems: function (cmp, anItem) {
        var selectedItems = cmp.get('v.selectedItems');

        selectedItems.splice(anItem, 1);
        cmp.set('v.selectedItems', selectedItems);
    },
    showProductPage: function (cmp, aPageId) {
        /*var urlEvent = $A.get('e.force:navigateToURL');
        urlEvent.setParams({
            url: '/product2/' + aPageId
        });
        urlEvent.fire();
        */
        //var productId = event.target.id;
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": aPageId
        });
        navEvt.fire();
        this.cleanUp(cmp);

    },
    cleanUp: function (cmp) {
        // clear the search string and results
        cmp.set('v.savedSearchTerm', '');
        // there is a change listener on the search term
        // this takes care of closing the results
        cmp.set('v.searchTerm', '');
        cmp.set('v.searchResults', []);
        // clear up the scroll variables
        // this.scrollCleanUp(cmp)
    },
    attachEventListBox: function (cmp) {
        // this is to close the results when the user clicks outside the list
        document.addEventListener(
            'click',
            function () {
                var isFilterOpened = cmp.get('v.isFilterOpened');
                if (isFilterOpened) {
                    this.hideResults(cmp);
                    this.cleanUp(cmp);
                }
            }.bind(this)
        );
    },
    hideResults: function (cmp) {
        $A.util.addClass(this.resultsListElement, 'slds-hide');
        cmp.set('v.isFilterOpened', false);
    },
    showResults: function (cmp) {
        $A.util.removeClass(this.resultsListElement, 'slds-hide');
        cmp.set('v.isFilterOpened', true);
    },
    keyPress: function (cmp, evt) {
        var isDown = true;
        if (evt.getParam('domEvent').key === 'ArrowDown') {
            evt.getParam('domEvent').preventDefault();
            // move the focus on to the results if length > 0
            this.moveFocus(cmp, isDown);
        } else if (evt.getParam('domEvent').key === 'ArrowUp') {
            evt.getParam('domEvent').preventDefault();
            isDown = false;
            this.moveFocus(cmp, isDown);
        } else if (evt.getParam('domEvent').key === 'Enter') {
            // determine which product is focussed and show the product page
            if (cmp.get('v.isDeepLinking')) {
                var numberOfMatches = cmp.get('v.searchResults').length;
                // need to test here to see if there is a match
                if (numberOfMatches) {
                    this.findAndShowProductPage(cmp);
                }
            } else {
                this.addItemToSelectedItems(cmp);
            }
        }
        // only accept other keys if the focus is not on the results list
        if (cmp.get('v.savedSearchTerm')) {
            evt.getParam('domEvent').preventDefault();
        } else {
            // console.log(evt.getParam('domEvent').key);
        }
    },
    moveFocus: function (cmp, aDown) {
        var searchResults = cmp.get('v.searchResults');
        var currentFocusIdx = this.findFocusIdx(cmp);
        // only bother doing anything here if there are results
        if (searchResults.length < 1) {
            return false;
        }

        if (aDown) {
            if (currentFocusIdx || currentFocusIdx === 0) {
                //move it on to the next one (if it is not the last)
                if (currentFocusIdx !== searchResults.length - 1) {
                    searchResults[currentFocusIdx].hasFocus = false;
                    searchResults[currentFocusIdx + 1].hasFocus = true;
                    cmp.set('v.searchTerm', this.getProductName(cmp));
                    cmp.set('v.searchResults', searchResults);
                    // scroll the list
                    // if the currentFocusIdx is greater than the number of items shown scroll up by 27 pixels;
                    // and increment the scrollTopIndex
                    if (currentFocusIdx >= 9 && searchResults.length > this.maxShownResults) {
                        this.scrollTopPixels += this.itemHeight;
                        this.resultsListElement.scrollTop = this.scrollTopPixels;
                        this.scrollTopIndex += 1;
                    }
                }
            } else {
                // if the list has been scrolled reset it to the beginning
                this.resetScrolling();
                //focus the first item
                searchResults[0].hasFocus = true;
                // save the search term so it can be restored if necessary
                // cmp.set('v.savedSearchTerm', cmp.get('v.searchTerm'));
                // set the searchTerm to be the text of the selected item
                // don't submit the search though
                cmp.set('v.savedSearchTerm', cmp.get('v.searchTerm'));
                cmp.set('v.searchTerm', this.getProductName(cmp));
                cmp.set('v.searchResults', searchResults);
            }
        } else {
            //its up
            if (currentFocusIdx || currentFocusIdx === 0) {
                //move it on to the next one (if it is not the last)
                if (currentFocusIdx === 0) {
                    // blur the list
                    searchResults[currentFocusIdx].hasFocus = false;
                    cmp.set('v.searchTerm', cmp.get('v.savedSearchTerm'));
                    cmp.set('v.savedSearchTerm', '');
                } else {
                    // focus the previous item
                    searchResults[currentFocusIdx].hasFocus = false;
                    searchResults[currentFocusIdx - 1].hasFocus = true;
                    cmp.set('v.searchTerm', this.getProductName(cmp));
                    if (currentFocusIdx <= this.scrollTopIndex) {
                        this.scrollTopPixels -= this.itemHeight;
                        this.resultsListElement.scrollTop = this.scrollTopPixels;
                        this.scrollTopIndex -= 1;
                    }
                }
                cmp.set('v.searchResults', searchResults);
            }
        }
    },
    resetScrolling: function () {
        if (this.resultsListElement.scrollTop !== 0) {
            this.scrollTopPixels = 0;
            this.resultsListElement.scrollTop = 0;
        }
    },
    attachScrollListener: function (cmp) {
        var resultsList, resultsListElement;
        resultsList = cmp.find('ncp_productSearchResults');
        if (resultsList) {
            var listenedForEvents = ['wheel', 'touchmove'];
            resultsListElement = resultsList.getElement();
            listenedForEvents.forEach(function (event) {
                resultsListElement.addEventListener(
                    event,
                    function () {
                        var ticking = false;
                        if (!ticking) {
                            window.requestAnimationFrame(
                                function () {
                                    ticking = false;
                                    this.scrollCleanUp(cmp);
                                }.bind(this)
                            );
                            ticking = true;
                        }
                    }.bind(this)
                );
            }, this);
        }
    },
    scrollCleanUp: function (cmp) {
        var currentFocusIdx = this.findFocusIdx(cmp);
        if (currentFocusIdx || currentFocusIdx === 0) {
            var searchResults = cmp.get('v.searchResults');
            searchResults[currentFocusIdx].hasFocus = false;
            this.scrollTopIndex = 0;
            // reset the display too as the highlight is nixed
            cmp.set('v.searchTerm', cmp.get('v.savedSearchTerm'));
            cmp.set('v.savedSearchTerm', '');
            cmp.set('v.searchResults', searchResults);
        }
    }
});