window.userSelections = (function () {

    var valueCache = {};

    return {
        setUserChoice: function (aKey, aValue) {
            valueCache[aKey] = aValue;
        },
        getUserChoice: function (aKey) {
            if (valueCache[aKey]) {
                return valueCache[aKey];
            } else {
                return undefined;
            }
        },
        getAllUserChoices: function () {
            return valueCache;
        }
    };

}());