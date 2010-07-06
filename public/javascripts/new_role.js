$(document).ready(function() {
  //$('.campagne_functie a.destroy').click(function(event) {
    //event.preventDefault();
    //$(this).parents('.campagne_functie').remove();
  //});

  $('a.add_role').click(function(event) {
    event.preventDefault();
    alert(" hoi")

    //functie = $('.campagne_functie').clone().removeClass('template').show();
    functie = $('.campagne_functie').clone().show();
    $('.new_role').append(functie)

    //$(functie.find('a.destroy').get(0)).click(function(event) {
      //$(this).parents('.campagne_functie').remove();
      //event.preventDefault();
    //});
  });
  
  //$('.campagne_functie.template').hide();
  
});
