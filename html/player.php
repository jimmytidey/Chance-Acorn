<!DOCTYPE html>

<html lang="en">

	<head>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		<title>Riff</title>

		<script type="text/javascript" type="text/javascript" >var project_name = "tom/reckoner 1";</script>

		<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"> </script>

		<script type="text/javascript" src="js/swfobject.js"></script>
	
		<script type="text/javascript">
			swfobject.registerObject("myFlashContent", "9.0.0");
		</script>

	</head>

	<body>		
		<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="800" height="200" id="myFlashContent">
				<param name="movie" value="random_seed_composer.swf?project_info_location=list.php?project_name=<? echo  $_GET['project_name'] ?>" />
				<param name="quality" value="medium" />

				<param name="wmode" value="transparent" />
				<param name="allownetworking" value="all" />
				<!--[if !IE]>-->
				<object type="application/x-shockwave-flash" data="random_seed_player.swf?project_info_location=list.php?project_name=<? echo  $_GET['project_name']  ?>" width="800" height="200" >
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
	</body>
</html>