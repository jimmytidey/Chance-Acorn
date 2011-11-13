<?

include('functions.php'); 

if (!empty($_GET['project_name'])) { 
	$project_name = urldecode($_GET['project_name']); 
}

else {
	echo "you must supply project name";
}

if (!empty($_GET['bank_name'])) { 
	$bank_name = urldecode($_GET['bank_name']); 
}

else {
	echo "you must supply bank name";
}


mkdir('projects/'.$project_name.'/'.$bank_name, 0777);


?>