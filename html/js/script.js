
var grid = new Object(); 
grid.grid_option_json = new Object();
grid.grid_option_json['sequence'] = new Object();

grid.refresh = function() {
	$.ajax({
	  url: 'edit_grid.php?project_name='+grid.project_name,
	  success: function(data) {
		$('#edit_grid').html(data);
		
		//bind events to refreshed HTML 
		$('.upload_icon').click(function() {
			var bank_name = $(this).parent().prev('.bank_name').html();
			var bank_option_name = $(this).prev('.bank_option_name').html(); 
			grid.newWindow(bank_name, bank_option_name);
		});
					
		$(".volume").each(function() {
			var volume = $(this).attr('data-volume'); 
			$(this).slider({ min: 0, max:100, value: volume, change: function(event, ui) {grid.bank_option_save($(this).parents('.bank_option'));} });	 
		});
					
		$('.overplay, .loop_option').click(function() {
			grid.bank_option_save($(this).parents('.bank_option'));
		});	

		$('#bank_add_btn').click(function() {
			grid.bank_add($('#bank_add_name').val());
		});		

		$('.option_add').click(function() {
			var bank_name = $(this).parent().find('h3').html();	
			var bank_option_name = $(this).prev('.option_add_name').val();
			grid.elem = this; 
			grid.bank_option_add(bank_name, bank_option_name);
		});
		

		grid.bank_rename = function() {
			$('.bank_name').click(function() { 
				grid.old_name = $(this).html();
				$(this).append("<div id='modal'><input id='bank_rename_text' type='text' value='"+grid.old_name+"' /><input type='button' id='bank_option_rename_button' value='save'/></div>"); 
				$('#modal').dialog();

				$("#bank_option_rename_button").click(function(){
					$.ajax({
					  url: "rename_bank.php?project_name="+grid.project_name+"&old_name="+grid.old_name+"&new_name="+$('#bank_rename_text').val(),
					  type: "GET",	
					  success: function(html) {
							$('#modal').dialog('close');
							grid.refresh();
						}
					});		
				}); 
			});	
		};

		
		grid.bank_rename();
		
		grid.bank_option_rename = function() {

		$('.bank_option_name').unbind('click');
			$('.bank_option_name').click(function() { 
				grid.old_option_name = $(this).html();
				grid.bank_name = $(this).parent().siblings('.bank_name').html(); 
				$(this).append("<div id='modal'><input id='bank_option_rename_text' type='text' value='"+grid.old_option_name+"' /><input type='button' id='bank_option_rename_button' value='save'/></div>"); 
				$('#modal').dialog();
 
				$("#bank_option_rename_button").click(function(bank_name){
					$.ajax({
					  url: "rename_bank_option.php?project_name="+grid.project_name+"&bank_name="+grid.bank_name+"&old_name="+grid.old_option_name+"&new_name="+$('#bank_option_rename_text').val(),
					  type: "GET",	
					  success: function(html) {
							$('#modal').dialog('close');
							grid.refresh();
						}
					});	
				}); 	
			});	
		};

		grid.bank_option_rename();
			
					
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


grid.bank_add = function(name) {
	$.ajax({
		url: "add_bank.php?bank_name="+escape(name)+"&project_name="+escape(grid.project_name),
		type: "GET",
		success: function(html) {
			grid.refresh(); 
		} 
	});

};

grid.bank_option_add = function(bank_name, bank_option_name) {
	$.ajax({
		url: "add_bank_option.php?bank_name="+escape(bank_name)+"&bank_option_name="+escape(bank_option_name)+"&project_name="+escape(grid.project_name),
		type: "GET",
		success: function(html) {
			grid.refresh(); 
		} 
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
	setInterval("grid.refresh()", 20000);
};

grid.newWindow = function(bank_name, bank_option_name) {
	var URL = 'upload/index.php?bank_name='+escape(bank_name)+'&bank_option_name='+escape(bank_option_name)+'&project_name='+escape(grid.project_name);
	var name = '_blank';
	var specs = 'location=no,scrollbars=no,menubar=no,status=no,toolbar=no,width=400,height=200';
	window.open(URL,name,specs);
}

grid.newFileManager = function() {
	var project_name = $('#project_name_field').val(); 
	var URL = 'explorer?root='+project_name; 
	var name = '_blank';
	var specs = 'location=no,scrollbars=no,menubar=no,status=no,toolbar=no,width=600,height=900';
	window.open(URL,name,specs);
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
	
	$('#explore_launch').click(function() {
		grid.newFileManager();
	});	
	
});
