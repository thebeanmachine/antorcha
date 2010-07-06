/* TOC jQuery plugin by The Bean Machine */

/* =========================================================
 *
 *  <div id="content"> 
 *      <h2>content 1</h2>
 *      <h3>content 2</h3>
 *      <h2>content 3</h2>
 *  </ul>
 *  
 *  $('#content').toc({ 
 *    'title':"Inhoudsopgave"
 *    'elements':"h2,h3"
 *    'minElements': 4 // don't display if less than n headings
 *  }); 
 *

// ========================================================= */

(function($) {
	$.fn.toc = function(options) {
    var settings;
    var tochtml;
    var elements;
    var elementCount;
    var elemname = "test";
    return this.each(function() {   

      $.toc(this, options);
    });
  };
  
  $.toc = function(container, options) {
    settings = {
         'elements':"h2,h3",
         'minElements': 4
     };
    if (options) $.extend(settings, options);
    
    tochtml = "";
    
    if (settings.prepend) {
      tochtml = tochtml + settings.prepend;
    }
    elementCount = 0;
    tochtml= tochtml+"<ul>";
    
    elements = settings.elements.split(",");
    elemname = false;
          
    $(container).find(settings.elements).each(function() {
      tochtml = $.toc.menuItemAppender(this, tochtml);
      elementCount++;
    });
    
    if (elementCount >= settings.minElements) $(container).prepend(tochtml);
  }
  
  $.toc.menuItemAppender = function(header, tochtml) {
    if (!elemname) elemname = $.getIndexValue(elements[0]);
    var titleId = $(header).text();
    var title = $(header).text();
    $(header).prepend('<a id="'+titleId+'" />');
    
    //MENU
    var levelChange = $.compareOrderElement($(header)[0].tagName, elemname);
    if (levelChange == -1) {
      tochtml = tochtml + '<ul>';
    }    
    if (levelChange == 1) {
      tochtml = tochtml + '</ul>';
    }
    tochtml = tochtml + '<li><a href="#'+titleId+'">'+title+'</a></li>';
    elemname = $(header)[0].tagName;
    return tochtml;
  }
  
  $.compareOrderElement = function(a, b) {
    var iCurrentElem = $.getIndexValue(a);
    var iElem = $.getIndexValue(b);
  
    if (iCurrentElem > iElem) return -1
    if (iCurrentElem == iElem) return 0
    if (iCurrentElem < iElem) return 1
    
  }
  $.getIndexValue = function(elementName) {
    var i;
    if (!elementName) return 0;
    for (i = 0; i < elements.length; i++) {
      if (elements[i].split(' ').join('').toLowerCase() == 
           elementName.split(' ').join('').toLowerCase()) {
        return i;
      }
    }
  }
})(jQuery);

