<?
header('Cache-Control: no-cache, must-revalidate');
header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
header('Content-type: application/json');

include('functions.php'); 

$project_name = $_GET['project_name'];

$json = array(); 

$json['project_info'] = read_json('projects/'.$project_name."/project_info.json");

//find out which banks are available 
$bank_array = structure_list('projects/'.$project_name, "dir");
$i = 0; 
foreach ($bank_array as $bank) {
	
	$bank_option_array = structure_list('projects/'.$project_name."/".$bank, "dir");
	
	$j = 0;
	foreach ($bank_option_array as $bank_option) {
		
		$json['banks'][$i]['bank_name'] = $bank; 
		
		
		$json['banks'][$i]['bank_options'][$j] = read_json('projects/'.$project_name."/".$bank."/".$bank_option."/bank_option_info.json");
		$json['banks'][$i]['bank_options'][$j]['bank_option_name'] = $bank_option;
		
		//find the name of the wav file for this directory 
		
		$audio_file_array = structure_list('projects/'.$project_name."/".$bank."/".$bank_option, "file");
		
		if (count($audio_file_array) > 0) {
			foreach ($audio_file_array as $audio_file) {
						
				if ($audio_file != 'bank_option_info.json') {
					$json['banks'][$i]['bank_options'][$j]['file_location'] = 'projects/'.$project_name."/".$bank."/".$bank_option."/".$audio_file; 
				}
			}
		}	
		$j++;
	}
	$i++;
}

print_r(json_encode($json));






?>