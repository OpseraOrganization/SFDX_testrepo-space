({
    // hints to ensure labels are preloaded
    // $Label.c.NCP_login_to_access_services
    // $Label.c.NCP_login_for_services_explanation
    // $Label.c.NCP_login_to_access_general
    // $Label.c.NCP_login_for_general_explanation
    // $Label.c.NCP_under_construction
    // $Label.c.NCP_under_construction_explanation
    // $Label.c.NCP_page_not_found
    // $Label.c.NCP_page_not_found_explanation
    // $Label.c.NCP_login_to_access_favourite_products
    // $Label.c.NCP_login_for_favourite_products_explanation
    // $Label.c.NCP_login_to_access_collaboration
    // $Label.c.NCP_login_for_collaboration_explanation
    // $Label.c.NCP_need_help
    // $Label.c.NCP_need_help_explanation_stem
    // $Label.c.NCP_need_help_explanation_leaf
    // $Label.c.NCP_need_help_explanation_link_text
    // $Label.c.NCP_upgrade_services
    // $Label.c.NCP_upgrade_services_explanation_stem
    // $Label.c.NCP_upgrade_services_explanation_leaf
    // $Label.c.NCP_upgrade_services_explanation_link_text

    types: {
        login: {
            icon: 'utility:info',
            headline: 'NCP_login_to_access_services',
            explanation: 'NCP_login_for_services_explanation'
        },
        generic: {
            icon: 'utility:info',
            headline: 'NCP_login_to_access_general',
            explanation: 'NCP_login_for_general_explanation'
        },
        loginForFavouriteProducts: {
            icon: 'utility:info',
            headline: 'NCP_login_to_access_favourite_products',
            explanation: 'NCP_login_for_favourite_products_explanation'
        },
        loginForCollaboration: {
            icon: 'utility:info',
            headline: 'NCP_login_to_access_collaboration',
            explanation: 'NCP_login_for_collaboration_explanation'
        },
        underConstruction: {
            icon: 'utility:info',
            headline: 'NCP_under_construction',
            explanation: 'NCP_under_construction_explanation'
        },
        pageNotFound: {
            icon: 'utility:dislike',
            headline: 'NCP_page_not_found',
            explanation: 'NCP_page_not_found_explanation'
        },
        needHelp: {
            icon: 'utility:info',
            headline: 'NCP_need_help',
            explanationStem: 'NCP_need_help_explanation_stem',
            explanationLeaf: 'NCP_need_help_explanation_leaf',
            explanationLinkText: 'NCP_need_help_explanation_link_text',
            link: 'product-list-view'
        },
        upgradeServices: {
            icon: 'utility:info',
            headline: 'NCP_upgrade_services',
            explanationStem: 'NCP_upgrade_services_explanation_stem',
            explanationLeaf: 'NCP_upgrade_services_explanation_leaf',
            explanationLinkText: 'NCP_upgrade_services_explanation_link_text',
            link: 'upgrade-my-services'
        }
    },
    setData: function(cmp) {
        var myType = cmp.get('v.myType');
        var myData = this.types[myType];
        if (!cmp.get('v.myHeadline')) {
            cmp.set('v.myHeadline', $A.get('$Label.c.' + myData.headline));
        }
        if (!cmp.get('v.myExplanation')) {
            var explanation;
            if (!myData.explanation) {
                // it is a composite explanation
                explanation = $A.get('$Label.c.' + myData.explanationStem) + ' ';
                cmp.set('v.myLinkText', $A.get('$Label.c.' + myData.explanationLinkText));
                if (myData.explanationLeaf) {
                    var leafText = $A.get('$Label.c.' + myData.explanationLeaf);
                    cmp.set('v.myLeafText', leafText);
                }
            } else {
                explanation = $A.get('$Label.c.' + myData.explanation);
            }
            cmp.set('v.myExplanation', explanation);
        }
        if (myData.link) {
            cmp.set('v.myLink', myData.link);
        }
    }
});