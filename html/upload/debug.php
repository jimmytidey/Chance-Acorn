<?


$project_name = explode('/', urldecode($_GET['project_name'])); // JIMMY 

$directory = "../projects/".$project_name[0]."/".$project_name[1]."/".urldecode($_GET['bank_name'])."/".urldecode($_GET['bank_option_name'])."/";

foreach(glob($directory.'*.wav') as $v){
	unlink($v);
}

foreach(glob($directory.'*.WAV') as $v){
	unlink($v);
}

foreach(glob($directory.'*.mp3') as $v){
	unlink($v);
}

foreach(glob($directory.'*.MP3') as $v){
	unlink($v);
}

?>
