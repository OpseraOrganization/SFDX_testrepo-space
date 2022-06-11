({
	getFormattedDate : function(date) {
		let monthNames = [
                "January", "February", "March",
                "April", "May", "June", "July",
                "August", "September", "October",
                "November", "December"
          	],
            d = new Date(new Date(date).getTime()+new Date(date).getTimezoneOffset()*60000),
            day = d.getDate(),
        	monthIndex = d.getMonth(),
  			year = d.getFullYear();
  		return monthNames[monthIndex] + ' ' + day + ', ' + year;
	}
})