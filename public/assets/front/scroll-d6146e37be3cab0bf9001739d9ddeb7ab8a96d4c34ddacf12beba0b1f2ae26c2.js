$(document).ready(function(){$("#learn-more").click(function(){return $("html, body").animate({scrollTop:$($.attr(this,"href")).offset().top},500),!1})});