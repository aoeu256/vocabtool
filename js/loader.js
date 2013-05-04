

$(document).ready(function() {
	// $('body').keypress(function(e) {
	// 	if(e.keyCode == 13)  { // a 
	// 		$.getScript('./js/game.js');
	// 	}
	// });
	
	Loader = {}
	Loader.loadfunc = function() {
	 	$.getScript('./js/game.js');
	};
});