<?

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
		
		//make the project info file
		
		$project_info_array['bpm'] = '120';
		$project_info_array['bpl'] = '16';
		$project_info_array['steps'] = '20';
		
		write_json('projects/'.$user_id.'/'.$project_name."/project_info.json", $project_info_array);

	}
}

include('header.php');
 
?>


<!DOCTYPE html>
<html>
<head>

<style type="text/css">
#container {
	position:absolute;
	width: 1000px; 
	left:50%; 
	margin-left:-500px; 
	border:1px solid black;
	padding:30px;
}

.channel_container {
	float:left; 
	height:700px; 
	padding-right:20px; 
	width:230px;
}

</style>
<script type="text/javascript"
    src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js">
</script>



</script>
</head>
<body> 

<div id='container'> 
	<form method="post" action="<?php echo $PHP_SELF;?>">
		
		<p>Project name  <input type='text' id='project_name' name='project_name' /></p>
		<input type='submit' value='save new project' /> 
		
	</form> 
	
	<h3>Existing projects</h3> 
	<?
	

	// get each entry
	$folder_array = structure_list('projects/'.$user_id.'/', 'dir');
	
	
	foreach($folder_array as $project) {
		
		echo "<a href='edit.php?project_name=$user_id/$project'>$project</a><br/>";
	
	}
	
	
	?>
	
</div> 

