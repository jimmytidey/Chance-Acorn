<?

include('functions.php'); 

$project_name = $_GET['project_name'];

//open the relevant project info file  
$project_info = read_json('projects/'.$project_name.'/project_info.json');

//calculate how many seconds long each loop is 
$beats_per_second = $project_info['bpm']/60;
$seconds_per_beat = 1/$beats_per_second; 
$step_time =($seconds_per_beat * $project_info['bpl'])*1000; 

include('header.php');


?>

<!DOCTYPE html>

<html lang="en">

<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<title>Chance Acorn</title>
	
	<link rel='stylesheet' href="style.css" >

	<script type="text/javascript" type="text/javascript" >var project_name = "<?=$project_name ?>";</script>
	
	<link rel="stylesheet" href="http://jqueryui.com/themes/base/jquery.ui.all.css">
	
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"> </script>

	<!-- <script src="js/js/jquery-ui.custom.min.js" type="text/javascript"></script> -->

	<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>

	<script type="text/javascript" src='js/script.js' > </script>

	<script type="text/javascript" src="js/swfobject.js"></script>
	
	<script type="text/javascript">
		swfobject.registerObject("myFlashContent", "9.0.0");
	</script>

</head>


<body> 

<div id='container'> 
	
	<h3><a href='http://chance-acorn.jimmytidey.co.uk/'>Back</a>  |  <span id='project_name'><?=$project_name ?></span> </h3> 
	
	<div id='controls'> 
		<form method="get" action="edit.php">
			<p>BPM <input type='text' id='bpm' name='bpm' size='3' value='<? echo $project_info['bpm'] ?>' />
				Beats per loop <input type='text' id='bpl' name='bpl' size='2'  value='<? echo $project_info['bpl']?>' /> 
				Number of steps <input type='text' id='steps' name='steps' size='2'  value='<? echo $project_info['steps'] ?>' />
				<input type='hidden' name='project_name' value='<?=$project_name ?>' id='project_name_field' />	
				<input type='button' value='save' name='form_submit' id='save_settings'/>
			</p>
		</form >
		
		<a href='player.php?project_name=<?=$project_name ?>' target='_blank' id='view_player_link' >View the player</a>
		
		<input type='button' id='explore_launch' value='Launch file manager' />
	</div>
	
	<!-- <input type='button' id='refresh' value='refresh' /> -->
	
	<div id='instructions'>
		<p></p>
			
	</div>

	
	
	
	<div id='edit_grid' ></div> 
	
	<div id='flash'>

		<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="760" height="1000" id="myFlashContent">
				<param name="movie" value="random_seed_composer.swf?project_info_location=list.php?project_name=<?= $user_id.'/'.$project_name ?>" />
				<param name="quality" value="medium" />
		
				<param name="wmode" value="transparent" />
				<param name="allownetworking" value="all" />
				<!--[if !IE]>-->
				<object type="application/x-shockwave-flash" data="random_seed_composer.swf?project_info_location=list.php?project_name=<?=$project_name ?>" width="760" height="1000" >
					<param name="quality" value="medium" />
				
					<param name="wmode" value="transparent" />
					<param name="allownetworking" value="all" />
				<!--<![endif]-->
					<a href="http://www.adobe.com/go/getflashplayer">
						<img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" />
					</a>
				<!--[if !IE]>-->
				</object>
				<!--<![endif]-->
			</object>
		
	</div>	
</div>
			
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-15474551-1");
pageTracker._trackPageview();
} catch(err) {}</script>

</body>
</html>
