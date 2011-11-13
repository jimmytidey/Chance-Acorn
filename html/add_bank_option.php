<?

include('functions.php'); 

if (!empty($_GET['project_name'])) { 
	$project_name = urldecode($_GET['project_name']); 
}

else {
	echo "you must supply project name";
}

if (!empty($_GET['bank_name'])) { 
	$bank_name =urldecode( $_GET['bank_name']); 
}

else {
	echo "you must supply bank name";
}

if (!empty($_GET['bank_option_name'])) { 
	$bank_option_name = urldecode($_GET['bank_option_name']); 
}

else {
	echo "you must supply bank option name";
}



if (isset($project_name) && isset($bank_name) && isset($bank_option_name)) {
	echo 'projects/'.$project_name.'/'.$bank_name.'/'.$bank_option_name;
	mkdir('projects/'.$project_name.'/'.$bank_name.'/'.$bank_option_name, 0777);
}

?>