<?
// get the project name from the get string 
$project_name = $_GET['project_name'];

print_r($_GET);

include('functions.php'); 
	
$project_info_array['bpm'] = $_GET['bpm'];
$project_info_array['bpl'] = $_GET['bpl'];
$project_info_array['steps'] = $_GET['steps'];

write_json('projects/'.$project_name.'/project_info.json', $project_info_array);

//need to loop through all the json files and change the length of the sequence 

$bank_array = structure_list('projects/'.$project_name, "dir");

$i = 0; 
foreach ($bank_array as $bank) {
	
	$bank_option_array = structure_list('projects/'.$project_name."/".$bank, "dir");
	
	$j = 0; 
	foreach ($bank_option_array as $bank_option) {
		
		$bank_option_json = read_json('projects/'.$project_name."/".$bank."/".$bank_option."/bank_option_info.json");
		
		$current_step_length = count($bank_option_json['sequence']); 
		
		$new_step_length = $project_info_array['steps'];			
		
		if ($current_step_length > $new_step_length) {
			//truncate the array because it's too long 
			
			//print ('truncating');
			
			//print('current_step_length='.$current_step_length.' , new_step_length='. $new_step_length);
			
			$difference = $project_info_array['steps']- $current_step_length ;
			
			array_splice($bank_option_json['sequence'], $difference);
				
		}
		
		if ($current_step_length < $new_step_length) {

			
			if(!is_array($bank_option_json['sequence'])){
				$bank_option_json['sequence'] = array();
			}
			
			$bank_option_json['sequence'] = array_pad($bank_option_json['sequence'], $new_step_length, '0'); 
			
		}
		
		write_json('projects/'.$project_name."/".$bank."/".$bank_option."/bank_option_info.json", $bank_option_json);
		
		$j++;
	}

	$i++;
	
}	


?>