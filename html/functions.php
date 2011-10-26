<?


function structure_list($folder_name, $type) {
	// open this directory 
	$myDirectory = opendir($folder_name);
	
	$dirArray = '';
	// get each entry
	while($entryName = readdir($myDirectory)) {

		if ((substr($entryName, 0, 1) != ".") && $entryName !='recycle_bin' && $entryName !='explorer' && $entryName !='project_info' && $entryName !='bank_option_info'  && filetype($folder_name."/".$entryName) == $type) {
 
			$dirArray[] = $entryName;	
		}
	}
	
	// close directory
	closedir($myDirectory);
	
	return ($dirArray); 
}


function write_json($file_location, $json) {
	$fp = fopen($file_location, 'w');
	fwrite($fp, json_encode($json));
	fclose($fp);
}


function read_json($file_location) {
	$data = file_get_contents($file_location); 
	$return = json_decode($data, true); 
	return($return); 
	
}


?>