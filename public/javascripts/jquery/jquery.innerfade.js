/* =========================================================
 *
 *  <ul id="news"> 
 *      <li>content 1</li>
 *      <li>content 2</li>
 *      <li>content 3</li>
 *  </ul>
 *  
 *  $('#news').innerfade({ 
 *	  animationtype: Type of animation 'fade' or 'slide' (Default: 'fade'), 
 *	  speed: Fading-/Sliding-Speed in milliseconds or keywords (slow, normal or fast) (Default: 'normal'), 
 *	  timeout: Time between the fades in milliseconds (Default: '2000'), 
 *	  type: Type of slideshow: 'sequence', 'random' or 'random_start' (Default: 'sequence'), 
 * 		containerheight: Height of the containing element in any css-height-value (Default: 'auto'),
 *	  runningclass: CSS-Class which the container get’s applied (Default: 'innerfade'),
 *	  children: optional children selector (Default: null)
 *  }); 
 *

// ========================================================= */


(function($) {

    $.fn.innerfade = function(options) {
      var settings;
      var elements;
      var shown;
      var next;
      var timer;
      return this.each(function() {   
          $.innerfade(this, options);
      });
    };

    $.innerfade = function(container, options) {
        settings = {
			      'animationtype':    'fade',
            'speed':            'normal',
            'type':             'sequence',
            'timeout':          200000,
            'containerheight':  'auto',
            'runningclass':     'innerfade',
            'children':         null,
            'floatcontainer':   true,
            'simplecontrols':  true
        };

       
        if (options)
              $.extend(settings, options);
        if (settings.children === null)
            elements = $(container).children();
        else
            elements = $(container).children(settings.children);
        if (elements.length > 1) {
            var height = 0; 
            if (settings.containerheight == 'auto') { // chrome and safari users: make sure you load this after window is loaded ( $(window).load )
              for (var i = 0; i < elements.length; i++) {
                var eheight = $(elements[i]).height();
                if ( eheight > height) { height = eheight; }
              }
              settings.containerheight = height;
            }

            if (settings.floatcontainer) { //IE fix...
              $(container).wrap('<div style="float: left; height: '+height+'; width: 100%; "/>');            
            }
                        if (settings.simplecontrols) {
              $(container).before('<ul id="carrousel_nav_home" class="non_floating_menu"><li id="carrousel_terug"><a><span class="hidden">Terug</span></a></li><li id="carrousel_volgende"><a><span class="hidden">Volgende</span></a></li></ul>');
            }
            $(container).css('position', 'relative').css('height', settings.containerheight).addClass(settings.runningclass);
            for (var i = 0; i < elements.length; i++) {
                $(elements[i]).css('z-index', String(elements.length-i)).css('position', 'absolute').hide();
            };
            if (settings.type == "sequence") {
                $(elements[0]).show();
                shown = 0;
                
                timer = setTimeout(function() {
                    $.fn.innerfade.showNext();
                }, settings.timeout);
                
                $.innerfade.addHighlightClassToRelatedActive(elements[0], settings); // added set active reference
            } else if (settings.type == "random") {
            		shown = Math.floor ( Math.random () * ( elements.length ) );
            		$(elements[shown]).show();
            		
                timer = setTimeout(function() {       
										$.fn.innerfade.showNext();
                }, settings.timeout);
                

						} else if ( settings.type == 'random_start' ) {
								settings.type = 'sequence';
								var current = Math.floor ( Math.random () * ( elements.length ) );
								timer = setTimeout(function(){
									$.innerfade.next();
								}, settings.timeout);
								shown=current;
								$(elements[current]).show();
						}	else {
							alert('Innerfade-Type must either be \'sequence\', \'random\' or \'random_start\'');
						}
				}
				
				
    };
    
    $.fn.innerfade.getShown = function() {
        return shown;
    }
    
    $.fn.innerfade.getNext = function() {
        var next;
        if (settings.type == "sequence") {
            if ((shown + 1) < elements.length) {
                next = shown + 1;
            } else {
                next = 0;
            }
        } else if (settings.type == "random") {
            next = shown;
            while (shown == next)
                next = Math.floor(Math.random() * elements.length);
        } else
            alert('Innerfade-Type must either be \'sequence\', \'random\' or \'random_start\'');
        return next;
    }
    
    $.fn.innerfade.showNext = function() {
       next = $.fn.innerfade.getNext();
       $.innerfade.next();
    }
    
    $.fn.innerfade.showPrevious = function() {
       next = $.fn.innerfade.getPrevious();
       
       $.innerfade.next();
    }
    
    $.fn.innerfade.getPrevious = function() {
        var next;
        if (settings.type == "sequence") {
            if ((shown - 1) >= 0) {
                next = shown - 1;
            } else {
                next = elements.length - 1;
            }
        } else 
            next = $.fn.innerfade.getNext()
        return next;
    }

    $.innerfade.next = function() {
        clearTimeout(timer);
        if (settings.animationtype == 'slide') {
            $(elements[shown]).slideUp(settings.speed);
            $(elements[next]).slideDown(settings.speed);
        } else if (settings.animationtype == 'fade') {
            $(elements[shown]).fadeOut(settings.speed);
            $(elements[next]).fadeIn(settings.speed, function() {
							removeFilter($(this)[0]);
						});
        } else
            alert('Innerfade-animationtype must either be \'slide\' or \'fade\'');
        shown = next;
        $.innerfade.addHighlightClassToRelatedActive(elements[shown], settings); // added set active reference
                 
        // in the future
        timer = setTimeout((function() {
            $.fn.innerfade.showNext();
        }), settings.timeout);
    };
    
    $.innerfade.addHighlightClassToRelatedActive = function(elementWithLink, settings) {
      var link = $(elementWithLink).find("a").attr("href");
      $("#"+settings.listofroutes+" a").removeClass("selected");
      $("#"+settings.listofroutes+" a[href='"+link+"']").addClass("selected");
    }

})(jQuery);

// **** remove Opacity-Filter in ie ****
function removeFilter(element) {
	if(element.style.removeAttribute){
		element.style.removeAttribute('filter');
	}
}

