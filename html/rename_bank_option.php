<?

include('functions.php'); 

if (!empty($_GET['old_name'])) { 
	$old_name = urldecode($_GET['old_name']); 
}

else {
	echo "you must supply the old name<br/>";
}

if (!empty($_GET['new_name'])) { 
	$new_name = urldecode($_GET['new_name']); 
}

else {
	echo "you must supply a new name<br/>";
}

if (!empty($_GET['project_name'])) { 
	$project_name = urldecode($_GET['project_name']); 
}

else {
	echo "you must supply a project name<br/>";
}

if (!empty($_GET['bank_name'])) { 
	$bank_name = urldecode($_GET['bank_name']); 
}

else {
	echo "you must supply a project name<br/>";
}

rename('projects/'.$project_name.'/'.$bank_name.'/'.$old_name, 'projects/'.$project_name.'/'.$bank_name.'/'.$new_name );


?>