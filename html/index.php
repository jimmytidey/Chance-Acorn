<?
include('header.php');
include('functions.php'); 

if (!empty($_POST['project_name'])) 

{
	$project_name = $_POST['project_name']; 
	
	if (is_dir('projects/'.$user_id.'/'.$project_name)) {
		echo "this project name already exists"; 
	}
	
	else {
		//make the project folder
		mkdir('projects/'.$user_id.'/'.$project_name, 0777);
		
		//copt template into the file 
		$src = "TEMPLATE/*";
		$dest = 'projects/'.$user_id.'/'.$project_name;

		shell_exec("cp -r $src $dest");
	}
}
 
?>


<!DOCTYPE html>
<html>
<head>
	<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>

	<link rel='stylesheet' href="style.css" >
</head>
<body> 

<div id='home_page'> 
	
	<h1 id='title'>Riff</h1>
	
	<p id='tag_line'>Felicitous composition</p>
	
	<form method="post" action="index.php">
		
		<h3>Add new project</h3>
		<p><input type='text' id='project_name' name='project_name' value='new project name' /><input type='submit' value='save new project' id='save_project_button' /></p>
		 
		
	</form> 
	
	<h3>Existing projects</h3> 
	<?
	

	// get each entry
	$folder_array = structure_list('projects/'.$user_id.'/', 'dir');
	
	
	foreach($folder_array as $project) {
		
		$encoded_name = urlencode($user_id.'/'.$project);
		
		echo "<a href='edit.php?project_name=$encoded_name'>$project</a><br/>";
	
	}
	
	
	?>
	
</div> 

