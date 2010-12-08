$(document).ready(function() {
	
	$("table#users input[type='submit']").hide();
	$("input.user_role").click(function(){ $(this).parent().parent().children('form').submit() });
	
	$(".js_blocklink").each(function() {
			$(this).click(function() {
				$(this).find("a").each(function(index) {
					if ($(this).attr("href") != undefined) {
						document.location = $(this).attr("href"); return false;
					}
				});
			});
			$(this).hover(
				function(){$(this).css("cursor","pointer")},
				function(){$(this).css("cursor","auto")}
			);
			$(this).find("a").click(function(e) {
				e.stopPropagation();
			})
		});
		
});