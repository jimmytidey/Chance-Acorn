
var grid = new Object(); 
grid.grid_option_json = new Object();
grid.grid_option_json['sequence'] = new Object();

grid.refresh = function() {
	$.ajax({
	  url: 'edit_grid.php?project_name='+grid.project_name,
	  success: function(data) {
		$('#edit_grid').html(data);
		
		//bind events to refreshed HTML 
		
		$(".volume").each(function() {
			var volume = $(this).attr('volume'); 
			$(this).slider({ min: 0, max:100, value: volume, change: function(event, ui) {grid.bank_option_save($(this).parents('.bank_option'));} });
			 
		});
					
		$('.overplay, .loop_option').click(function() {
			grid.bank_option_save($(this).parents('.bank_option'));
		});	
		
		//make the boxes chane colour when you click on them 
		$('.switches div').click(function() {
			if ($(this).attr("class") == "switch_ " || $(this).attr("class") == "switch_0") {$(this).attr("class", "switch_1");}
			else if ($(this).attr("class") == "switch_1") {$(this).attr("class", "switch_2");}
			else if ($(this).attr("class") == "switch_2") {$(this).attr("class", "switch_3");}
			else if ($(this).attr("class") == "switch_3") {$(this).attr("class", "switch_0");}
			grid.bank_option_save($(this).parents('.bank_option'));
		});	
		
	  }
	});				
};
	
grid.bank_option_save = function(bank_option) {
	
	//get the switch values
	$(".switches div", bank_option).each(function(index, value) {
		 var state = $(this).attr('class').split("_");
		 grid.grid_option_json['sequence'][index] = state['1']; 
	});
	
	//get all the other values 
	grid.grid_option_json['volume'] = $(".volume", bank_option).slider( "option", "value" );
	
	if ($(".loop_option", bank_option).is(':checked')) {grid.grid_option_json['loop'] = 'true'} else {grid.grid_option_json['loop'] = 'false'};
	if ($(".overplay", bank_option).is(':checked')) {grid.grid_option_json['overplay'] = 'true'} else {grid.grid_option_json['overplay'] = 'false'};
	
	//turn them into json 

	save_json = "json="+JSON.stringify(grid); 
	
	bank_option_name = $(".bank_option_name", bank_option).html(); 
	
	bank_name = $(bank_option).prevAll('.bank_name').html(); 
	

	
	$.ajax({
	  url: "save_bank_option.php?bank_option_name="+bank_option_name+"&bank_name="+bank_name+"&project_name="+grid.project_name,
	  type: "POST",
	  data: save_json,
	  success: function(html) {}, 
	});

	
};


grid.saveSettings = function() {
	
	var bpm  = $('#bpm').val(); 
	var bpl  = $('#bpl').val(); 
	var steps = $('#steps').val(); 
	
	$.ajax({
	  url: "save_settings.php?bpm="+bpm+"&bpl="+bpl+"&steps="+steps+"&project_name="+grid.project_name,
	 data: '',
	 type: "GET",
	  success: function(html) {}, 
	});
	
	grid.refresh(); 
}

grid.poll = function() {
	setTimeout("grid.refresh(); grid.poll();", 20000)
}

$(document).ready(function() {

	//make the project name available to javascript
	grid.project_name = $('#project_name').html();
	
	//load the grid 
	grid.refresh();	
			
	//bind click events 
	$('#refresh').click(function() {
		grid.refresh(); 
	});
	
	//this to poll server for file structure updates
	grid.poll()
	
	$('#save_settings').click(function() {
		grid.saveSettings();
	});
	
});
