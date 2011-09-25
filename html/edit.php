<?

include('functions.php'); 

$project_name = $_GET['project_name'];

//open the relevant project info file  
$project_info = read_json('projects/'.$project_name.'/project_info.json');

//calculate how many seconds long each loop is 
$beats_per_second = $project_info['bpm']/60;
$seconds_per_beat = 1/$beats_per_second; 
$step_time =($seconds_per_beat * $project_info['bpl'])*1000; 




?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
            "http://www.w3.org/TR/html4/loose.dtd">

<html lang="en">

<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<title>Chance Acorn</title>
	
	<link rel='stylesheet' href="style.css" >

	<script type="text/javascript">var project_name = "<?=$project_name ?>";</script>
	
	<link rel="stylesheet" href="http://jqueryui.com/themes/base/jquery.ui.all.css">
	
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"> </script>

	<script src="/js/js/jquery-ui.custom.min.js"></script>
	
	<script type="text/javascript" src='script.js' > </script>

</head>


<body> 

<div id='container'> 
	
	<h3><a href='http://jimmytidey.co.uk/chance_acorn/'>Back</a>  |  <span id='project_name'><?=$project_name ?></span> </h3> 
	
	<div id='controls'> 
		<form method="get" action="<?php echo $PHP_SELF;?>">
			<p>BPM <input type='text' id='bpm' name='bpm' size='3' value='<? echo $project_info['bpm'] ?>' />
				Beats per loop <input type='text' id='bpl' name='bpl' size='2'  value='<? echo $project_info['bpl']?>' /> 
				Number of steps <input type='text' id='steps' name='steps' size='2'  value='<? echo $project_info['steps'] ?>' />
				<input type='hidden' name='project_name' value='<?=$project_name ?>' />	
				<input type='button' value='save' name='form_submit' id='save_settings'/>
			</p>
		</form >
	</div>
	
	<iframe src='explorer?root=<?=$project_name ?>' id='explorer' frameborder="0" ></iframe>


	<input type='button' id='refresh' value='refresh' /> 
	
	<div id='edit_grid' ></div> 
	
	<div id='flash'>

		<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
		<param name="wmode" value="transparent">
		<width="1000" height="700" id="Untitled-1" align="middle">
		<param name="allowScriptAccess" value="sameDomain" />
		<param name="movie" value="audio_player.swf?project_info_location=list.php?project_name=<?=$project_name ?>" />
		<param name="quality" value="high" />
		<param name="bgcolor" value="#ffffff" />
		<embed src="audio_player.swf?project_info_location=list.php?project_name=<?=$project_name ?>" quality="high" bgcolor="#ffffff" width="1000"
		height="700" name="mymovie" align="middle" allowScriptAccess="sameDomain"
		type="application/x-shockwave-flash" pluginspage="http://www.adobe.com/go/getflashplayer" wmode="transparent" />
		</object> 			
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



	

