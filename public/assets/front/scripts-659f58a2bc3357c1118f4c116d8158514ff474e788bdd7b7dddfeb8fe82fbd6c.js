$(document).ready(function(){$("#main-slider").flexslider({animation:"fade",slideshowSpeed:3500,controlNav:!1,directionNav:!1})}),$(document).ready(function(){var e=$("#owl-demo");e.owlCarousel({items:4,itemsDesktop:[1e3,5],itemsDesktopSmall:[900,3],itemsTablet:[600,2],itemsMobile:!1})}),$("#testimonials .carousel").carousel({interval:6e3}),$(document).ready(function(){$(".popup-youtube, .popup-vimeo, .popup-gmaps").magnificPopup({disableOn:700,type:"iframe",iframe:{markup:'<div class="mfp-iframe-scaler"><div class="mfp-close"></div><iframe class="mfp-iframe" frameborder="0" allowfullscreen></iframe><div class="mfp-title">Some caption</div></div>',patterns:{youtube:{index:"youtube.com/",id:"v=",src:"http://www.youtube.com/embed/%id%?autoplay=1"},vimeo:{index:"vimeo.com/",id:"/",src:"http://player.vimeo.com/video/%id%?autoplay=1"},gmaps:{index:"//maps.google.",src:"%id%output=embed"}},srcAction:"iframe_src"},mainClass:"mfp-fade",removalDelay:160,preloader:!1,fixedContentPos:!1})}),$(".social-icons a, .social-icons-bottom a").tooltip(),$("#menu-close").click(function(e){e.preventDefault(),$("#sidebar-wrapper").toggleClass("active")}),$("#menu-toggle").click(function(e){e.preventDefault(),$("#sidebar-wrapper").toggleClass("active")}),$("a[href*=#]:not([href=#])").click(function(){if(location.pathname.replace(/^\//,"")==this.pathname.replace(/^\//,"")||location.hostname==this.hostname){var e=$(this.hash);if(e=e.length?e:$("[name="+this.hash.slice(1)+"]"),e.length)return $("html,body").animate({scrollTop:e.offset().top},1e3),!1}});