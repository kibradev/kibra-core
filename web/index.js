$(function() {
    window.addEventListener('message', function(event) {
        var type = event.data.type
        var data = event.data
        if(type === "ShowUI"){
            $('#Badge').css('opacity', '1.0');
            text = event.data.text;
		    control = event.data.control;
		    $('#control').html(control);
            $('#text').html(text);
            $('#Badge').removeClass('hideleft');
			$('#Badge').addClass('showleft');
        } else if (type === "Hide"){
            $('#Badge').css("opacity", "1;")
            $('#Badge').removeClass('hideright');
			$('#Badge').removeClass('showright');
			$('#Badge').removeClass('showleft');
			$('#Badge').addClass('hideleft');
        }
    })
});