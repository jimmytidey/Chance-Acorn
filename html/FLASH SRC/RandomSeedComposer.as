﻿package {	import com.adobe.serialization.json.JSON;	import flash.net.URLRequest;	import flash.net.URLLoader;	import flash.events.*;	import flash.utils.*;	import flash.media.Sound;	import flash.media.SoundChannel;	import flash.display.*; 	import flash.text.*; 	import com.joshtime.jButton;	import flash.media.SoundMixer;		//this object as a container for everything. Has to extend movieclip to inherit the stage obejct	public class RandomSeedComposer extends MovieClip {				private var _stage:Stage;				var loader:URLLoader = new URLLoader();		var requester:URLRequest = new URLRequest();				private var sounds:Array; // array for sound objects for each bank option				public var step_time:Number; //indicates which step the timer is currently on				private var myTimer:AccurateTimer; //accurate timing object				private var jsonData:Object; //holds all the json data				private var grid:Array; //holds the probabiliyies of each step playing 				var loop:String;				var volumeLevel:Number;				var step_number:Number;				//use this to check if we need to recreate all the sound objects 		var reload_sounds:int = 0;				var grid_container:MovieClip = new MovieClip;				var options_container:MovieClip = new MovieClip;				var playhead_container:MovieClip = new MovieClip;				public var project_info_location:String;				/**		 * get the json file with all the project info in		 *		 */ 		public function RandomSeedComposer(stage:Stage):void {			_stage = stage; 		}  						 		public function init() {		 				//clear the stage 			while (_stage.numChildren > 0) {				_stage.removeChildAt(_stage.numChildren-1);			} 						//reset the internal functions			if (myTimer) {myTimer.stop();} 			step_number = 0;						//draw buttons 			drawButtons();					//stop any sounds that have already started !!! Is the necessary? 			if (this.hasOwnProperty("bank_index")) { 				for (bank_index=0; bank_index < sounds.length; bank_index++) {					for (bank_option_index=0; bank_option_index < sounds[bank_index].length; bank_option_index++) {							sounds[bank_index][bank_option_index].stopPlayBack();					}				}			}						loadJSON();		}		private function loadJSON() {			project_info_location = root.loaderInfo.parameters.project_info_location;						if (project_info_location == null) { // assume this pat the make debug easier 				project_info_location  = 'http://chance-acorn.jimmytidey.co.uk/list.php?project_name=wav';			}						requester.url=project_info_location;			loader.load(requester);			loader.addEventListener(Event.COMPLETE, decodeJSON);						}						/**		 * Make the grid object with all of the relative play probabilties in 		 *		 */				 		private function decodeJSON(event:Event) {						this.jsonData =JSON.decode(loader.data);						calculateGrid()			drawPlayhead();		}						private function calculateGrid() {		if (this.reload_sounds == 0) {			var newSound:PlaySound = makeSoundObjects();			this.reload_sounds = 1; 		}				else {			my_stop();		}						//remove all the existing stuff		while (this.options_container.numChildren > 0) {			this.options_container.removeChildAt(this.options_container.numChildren-1);		} 		while (this.grid_container.numChildren > 0) {			this.grid_container.removeChildAt(this.grid_container.numChildren-1);		} 											 						// an array for keeping the bank option states			grid  = new Array(jsonData['banks'].length);  					//loop over this bank			var bank_index:int = 0;						var cumulatuive_y_offset:int = 0;						for each (var bank:Object in jsonData['banks']) {									//declare a new array for this bank (assuming all have the same number of steps) 				grid[bank_index] = new Array(jsonData['banks'][bank_index]['bank_options'][0]['sequence'].length);								//loop over each bank option 				var bank_option_index:int = 0;											for each (var bank_option:Object in bank['bank_options']) {													//label each bank option 					var myText:TextField = new TextField();										myText.text = jsonData['banks'][bank_index]['bank_options'][bank_option_index]['bank_option_name'];										myText.x = 5; 										myText.y = cumulatuive_y_offset + 100;										grid_container.addChild(myText);													var step_index:int = 0;													for each (var step:Object in jsonData['banks'][bank_index]['bank_options'][bank_option_index]['sequence']) {												//if we are on the first bank option we need to define the step array, otherwise not because doing this will erase info from previous step 						//of course, this wouldn't be a fucking problem if we didn't have to define the array 						if (bank_option_index == 0) {							grid[bank_index][step_index] = new Array(jsonData['banks'][bank_index]['bank_options'].length);						}												var temp_val:int = jsonData['banks'][bank_index]['bank_options'][bank_option_index]['sequence'][step_index];												//process a step which is very likely, but not certain 						if (temp_val > 0 && temp_val < 3) {														temp_val = temp_val * 25 * Math.random();  						}												if (temp_val == 3) {							temp_val = temp_val * 30 * ((Math.random()/3) + 0.6);  						}																	grid[bank_index][step_index][bank_option_index] = temp_val; 												var mc:MovieClip = new MovieClip();												//draw a grey box for this step 						mc.graphics.beginFill(0x333, ((temp_val/200)+0.05));						mc.graphics.drawRect(0, 0, 10, 10);						mc.graphics.endFill();														mc.x = step_index * 20 +100;												mc.y =cumulatuive_y_offset + 100;												grid_container.addChild(mc);															step_index++;					}										cumulatuive_y_offset += 20;										bank_option_index++;				}				bank_index++;							}									_stage.addChild(grid_container);										calculateOptions();			calculateStepTime();					}		/**		 * draw the playhead 		 *		 */		private function drawPlayhead() {					trace('number of children'+ this.playhead_container.numChildren); 				while (this.playhead_container.numChildren > 0) {			this.playhead_container.removeChildAt(this.playhead_container.numChildren-1);			trace('removing'); 		} 							trace('number of children after '+ this.playhead_container.numChildren); 						//work out how high the playhead needs to be 						var total_bank_options:int;						for (bank_index=0; bank_index < jsonData['banks'].length; bank_index++) {									total_bank_options += jsonData['banks'][bank_index]['bank_options'].length;			}						var playhead_height:int = ((total_bank_options - bank_index) * 20) + (bank_index * 40); 						var playhead:MovieClip = new MovieClip(); //the playhead movie						//draw that playhead			playhead.graphics.beginFill(0xcccccc, 0.5);			playhead.graphics.drawRect(0, 0, 10, playhead_height);			playhead.graphics.endFill();									playhead.x = 100;			playhead.y = 90;						trace('drawing'); 						this.playhead_container.addChild(playhead);						_stage.addChild(this.playhead_container);		}						/**		 * Make all the required sound objects 		 *		 */			private function makeSoundObjects() {						//make all the sound objects ready for me to play them 						sounds = new Array(jsonData['banks'].length); 						var myController:SoundChannel;						var cumulative_y_ofset:int = 100; 						for (bank_index=0; bank_index < jsonData['banks'].length; bank_index++) {									sounds[bank_index] = new Array(jsonData['banks'][bank_index]['bank_options'].length);								for (bank_option_index=0; bank_option_index < jsonData['banks'][bank_index]['bank_options'].length; bank_option_index++) {										var sound_file_location:String = "http://chance-acorn.jimmytidey.co.uk/"+jsonData['banks'][bank_index]['bank_options'][bank_option_index]['file_location'];										//if the sound needs to loop within a step, find out and build the sound object with that setting					if (jsonData['banks'][bank_index]['bank_options'][bank_option_index]['loop'] == 'true') {						loop= 'yes';					}					else {loop='no';}															volumeLevel = jsonData['banks'][bank_index]['bank_options'][bank_option_index]['volume'];										//fuck I hate flash 					//pass in an mc for the thign to report it's loadedness into 					var statusMC:MovieClip = new MovieClip();					statusMC.y = cumulative_y_ofset;					statusMC.x = 700;										_stage.addChild(statusMC);										var MySound:PlaySound = new PlaySound(sound_file_location, loop, volumeLevel, statusMC);													sounds[bank_index][bank_option_index] = MySound;										cumulative_y_ofset  += 20;  				}			}					}				/**		 * draw... the... buttons...  		 *		 */				public function drawButtons() {						/*			//shake btn 			var shakeBtn = new jButton("Load");			shakeBtn.x = 10; 			shakeBtn.y = 10;			_stage.addChild(shakeBtn);			trace(shakeBtn);			shakeBtn.addEventListener("c", shakeListener);			function shakeListener() {init();}			*/												//play btn 			var playBtn = new jButton("Play");			playBtn.x = 130; 			playBtn.y = 10;			_stage.addChild(playBtn);			playBtn.addEventListener("c", playListener);			function playListener() {go();}									//stop btn 			var stopBtn = new jButton("Stop");			stopBtn.x = 250; 			stopBtn.y = 10;			_stage.addChild(stopBtn);			stopBtn.addEventListener("c", stopListener);			function stopListener() {my_stop();}						//randomise			var randomiseBtn = new jButton("Randomise");			randomiseBtn.x = 370; 			randomiseBtn.y = 10;			_stage.addChild(randomiseBtn);			randomiseBtn.addEventListener("c", randomise);								function randomise() {loadJSON();}								//rewind			var rewindBtn = new jButton("rewind");			rewindBtn.x = 490; 			rewindBtn.y = 10;			_stage.addChild(rewindBtn);			rewindBtn.addEventListener("c", rewind);						function rewind() {				calculateStepTime()				this.step_time = 0; 				drawPlayhead(); 			}		}				/**		 * set the step time		 *		 */		private function calculateStepTime() {							var beats_per_second:Number = jsonData['project_info']['bpm']/60;			var seconds_per_beat:Number = 1/beats_per_second; 			step_time = (seconds_per_beat * jsonData['project_info']['bpl'])*1000; 						myTimer = new AccurateTimer(step_time, 1000);		}		//this function goes trhough and works out which steps will play and which won't		private function calculateOptions() {					var number_of_steps:int = jsonData['banks'][bank_index]['bank_options'][0]['sequence'].length;						var cumulatuive_y_offset:int;						//go through steps 			for (var step_number:int=0; step_number < number_of_steps; step_number++) {								cumulatuive_y_offset = 100;								//loop through banks 				for (var bank_index:int=0; bank_index < jsonData['banks'].length; bank_index++) {															var max_value:int =0 					var max_value_index:int = 0					var current_step_value = 0; 															//loop throuh bank options 					for (bank_option_index=0; bank_option_index < jsonData['banks'][bank_index]['bank_options'].length; bank_option_index++) {												current_step_value = grid[bank_index][step_number][bank_option_index];												//work out which of the bank options should play						if (current_step_value > max_value) {							max_value = current_step_value;							max_value_index = bank_option_index; 						} 					}										if (max_value > 20) {												grid[bank_index][step_number][max_value_index] = 100;												//for each bank, indicate which						var mc:MovieClip = new MovieClip();												//draw a grey box for this step  						mc.graphics.beginFill(129, 0);						mc.graphics.drawRect(0, 0, 10, 10);						mc.graphics.endFill();												mc.x = step_number * 20 +100;												mc.y = cumulatuive_y_offset + max_value_index * 20;												options_container.addChild(mc);									}										else {						grid[bank_index][step_number][max_value_index] = 0;					}										cumulatuive_y_offset += 20 * grid[bank_index][step_number].length; 				}	 			}			_stage.addChild(options_container);		 }		public function go() {			my_stop(); // stop it from playing two things at once			myTimer.addEventListener(TimerEvent.TIMER, step);			myTimer.start(); 			playStep();		}				public function my_stop() {			myTimer.stop(); 												for (bank_index=0; bank_index < sounds.length; bank_index++) {				for (bank_option_index=0; bank_option_index < sounds[bank_index].length; bank_option_index++) {						sounds[bank_index][bank_option_index].stopPlayBack();				}			}		}								/**		 * function called for each new step  		 *		 */				private function step(event:TimerEvent) {							playStep();		}				private function playStep() {			if (this.step_number == jsonData['project_info']['steps']-1) {				 my_stop()			}						else {								this.step_number = (myTimer.currentCount) % jsonData['project_info']['steps'];							this.playhead_container.x = this.step_number * 20;								//stop all sounds which have to stop before the next step ie. ones which don't have overplay set				for (var bank_index:int =0; bank_index < jsonData['banks'].length; bank_index++) {										for (var bank_option_index:int =0; bank_option_index < jsonData['banks'][bank_index]['bank_options'].length; bank_option_index++) {											if (jsonData['banks'][bank_index]['bank_options'][bank_option_index]['overplay'] == "false") {							sounds[bank_index][bank_option_index].stopPlayBack();						}												if (grid[bank_index][step_number][bank_option_index] == 100) { 							sounds[bank_index][bank_option_index].playBack();						}					}				}			}		}	}}