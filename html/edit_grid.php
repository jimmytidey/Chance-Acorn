<p id='volume_label'>Volume</p>
<p id='loop_label'>Loop</p>
<p id='overplay_label'>Overplay</p>
<?
include('functions.php'); 

$project_name = $_GET['project_name']; 
 
// hack to ensure all the files are readable  

$escaped_project_string = str_replace (' ',  '\ ', $project_name );

$command_string = "chmod -R 777 projects/$escaped_project_string";

shell_exec ($command_string);

$project_info = read_json('projects/'.$project_name.'/project_info.json');

// get a list of all the folders in the current project directory 
$bank_array = structure_list("projects/".$project_name, 'dir');

if (!empty($bank_array)) {

	//loop through all the banks 
	foreach ($bank_array as $bank_name) {
		echo '<h3 class="bank_name">'.$bank_name.'</h3>';
		
		//in each bank, find out which bank options are saved 
		$bank_options = structure_list('projects/'.$project_name.'/'.$bank_name, 'dir');
		
		if (!empty($bank_options)) {
		
			foreach ($bank_options as $bank_option_name) {
				
				//make bank_option_info.json if it doesn't exist yet 
				if (!file_exists('projects/'.$project_name.'/'.$bank_name."/".$bank_option_name."/bank_option_info.json")) {
					
					$padded_temp = array(); 
					
					$length_of_banks = $project_info['steps'];
					
					$padded_temp = array_pad($padded_temp, $length_of_banks, '0');  
					
					$bank_option_info['sequence'] = $padded_temp;  
					$bank_option_info['volume'] = 50;  
					$bank_option_info['loop'] = 'false'; 
					$bank_option_info['overplay'] = 'false'; 
					
					write_json('projects/'.$project_name.'/'.$bank_name."/".$bank_option_name."/bank_option_info.json", $bank_option_info); 
					
				}
				
				//get the info file for this bank 
				$bank_option_info = read_json('projects/'.$project_name.'/'.$bank_name."/".$bank_option_name."/bank_option_info.json");  
				 
				
				//echo the name of this bank option 
				echo "<div class='bank_option ".$bank_option_name."'><p class='bank_option_name'>".$bank_option_name."</p>";
					?>
						
						<div class="volume" volume='<? echo $bank_option_info['volume'] ?>' ></div>
						<input type="checkbox" name="loop" class='loop_option' state='<? echo $bank_option_info['loop']; ?>' <? if ($bank_option_info['loop']=='true') {echo "checked='checked'";} ?> /> 
						<input type="checkbox" name="loop" class='overplay' state='<? echo $bank_option_info['overplay']; ?>' <? if ($bank_option_info['overplay']=='true') {echo "checked='checked'";} ?> />
						
					<?
					//loop through and draw each step 
					$step_count = count($bank_option_info['sequence']);
					
					?> <span class='switches'> <? 
					for($step=0; $step < $step_count; $step++) {
						$left = $step * 17 ; 
						echo "<div style='left:".$left."px;'  class='switch_".$bank_option_info['sequence'][$step]."' state='".$bank_option_info['sequence'][$step]."'></div>";  
					}				
				echo "</span></div>"; 
			}
		}	
	}
}

?>