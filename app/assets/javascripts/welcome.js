$(function() {

  changeLocalType ();

});



function changeLocalType (){
  var localTypes = ['adventurer', 'shopper', 'drinker', 'surfer', 'foodie', 'artist', 'local'];
  var i=0;
  (function loop() {
      $('#local-type').text(localTypes[i]).addClass("animated infinite swing");
      if (++i < localTypes.length) {
          setTimeout(loop, 2000);  // call myself in 2 seconds time if required
      }
  })();

}
