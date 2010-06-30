$(document).ready(function() {
  //$('.campagne_functie a.destroy').click(function(event) {
    //event.preventDefault();
    //$(this).parents('.campagne_functie').remove();
  //});

  $('a.add_role').click(function(event) {
    event.preventDefault();

    functie = $('.campagne_functie.template').clone().removeClass('template').show();
    $('.new_transaction_role').append(functie);

    //$(functie.find('a.destroy').get(0)).click(function(event) {
      //$(this).parents('.campagne_functie').remove();
      //event.preventDefault();
    //});
  });
  
  $('.campagne_functie.template').hide();

  
});
