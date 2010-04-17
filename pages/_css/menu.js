
jQuery.fn.menu = function (options) {
	$(this).each(function() {
		var active = null;
		
		$(this).children('li').each(function() {
			var menu = $('.menu', this);
			var timeout = null;
			
			menu.showMenu = function () {
				if (active && active !== menu) {
					active.hideMenu(true);
				}
				
				menu.fadeIn(200);
				
				if (timeout) {
					clearTimeout(timeout);
					timeout = null;
				}
				
				active = menu;
			}
			
			menu.hideMenu = function (immediately) {
				if (timeout) {
					clearTimeout(timeout);
					timeout = null;
				}
				
				if (immediately) {
					menu.fadeOut(100);
				} else {
					timeout = setTimeout(function() {
						menu.fadeOut(200);
						timeout = null;
					}, 500);
				}
			}
			
			$(this).hover(function() {
				menu.showMenu();
			}, function() {
				menu.hideMenu();
			});
		})
	});
};
