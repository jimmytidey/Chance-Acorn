<?
	include('functions.php');
	
	echo "Save page results";
	
	$json = json_decode(stripslashes($_POST['json']), true);
	 
	$project_name = $_GET['project_name'];
	$bank_name = $_GET['bank_name'];
	$bank_option_name = $_GET['bank_option_name'];	
	
	print_r($json);
	
	write_json('projects/'.$project_name.'/'.$bank_name."/".$bank_option_name."/bank_option_info.json", $json['grid_option_json']);
	
?>
