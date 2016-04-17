$(".question").click( function() { 

	$(this).next().slideToggle("slow");
	$(this).children().toggleClass("collapse") ;
	
})