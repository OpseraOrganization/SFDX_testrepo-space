({
    sortFavourites: function(aFavs) {
        return aFavs.sort(function (a, b) {
            var favA = a.Name;
            var favB = b.Name;

            if (favA < favB) {
                return -1;
            }
            if (favA > favB) {
                return 1;
            }
            return 0;
        });
    }
})