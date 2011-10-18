﻿package {		import com.adobe.serialization.json.JSON;	import flash.net.URLRequest;	import flash.net.URLLoader;	import flash.events.*;	import flash.utils.*;	import flash.media.Sound;	import flash.media.SoundChannel;	import flash.display.*; 		public class RandomSeed extends MovieClip {				private var _stage:Stage;				var loader:URLLoader = new URLLoader();		var requester:URLRequest = new URLRequest();				private var sounds:Array; // array for sound objects for each bank option		private var channels:Array; // array of sound chanels for each bank 		private var transformation:Array; //array of sound transforms for each bank option				public var step_time:Number; //indicates which step the timer is currently on				private var myTimer:AccurateTimer; //accurate timing object				private var jsonData:Object; //holds all the json data				private var grid:Array; //holds the probabiliyies of each step playing 				var playhead:MovieClip = new MovieClip(); //the playhead movie				/**		 * get the json file with all the project info in		 *		 */ 		public function RandomSeed(stage:Stage):void {			_stage = stage;		}  		 		public function loadJson(project_info_location:String) {						if (project_info_location ==null) { // assume this pat the make debug easier 				project_info_location  = 'http://jimmytidey.co.uk/chance_acorn/list.php?project_name=wav_project';			}						requester.url=project_info_location;						loader.load(requester);			loader.addEventListener(Event.COMPLETE, decodeJSON);				}						/**		 * Make the grid object with all of the relative play probabilties in 		 *		 */				 		private function decodeJSON(event:Event) {						jsonData =JSON.decode(loader.data);						// an array for keeping the bank option states			grid  = new Array(jsonData['banks'].length);  					//loop over this bank			var bank_index:int = 0;			for each (var bank:Object in jsonData['banks']) {									//declare a new array for this bank 				grid[bank_index] = new Array(jsonData['banks'][bank_index]['bank_options'][0]['sequence'].length);								//loop over each bank option 				var bank_option_index:int = 0;											for each (var bank_option:Object in bank['bank_options']) {													var step_index:int = 0;													for each (var step:Object in jsonData['banks'][bank_index]['bank_options'][bank_option_index]['sequence']) {												//if we are on the first bank option we need to define the step array, otherwise not because doing this will erase info from previous step 						//of course, this wouldn't be a fucking problem if we didn't have to define the array 						if (bank_option_index == 0) {							grid[bank_index][step_index] = new Array(jsonData['banks'][bank_index]['bank_options'].length);						}												var temp_val:int = jsonData['banks'][bank_index]['bank_options'][bank_option_index]['sequence'][step_index];																								//process a step which is very likely, but not certain 						if (temp_val > 0 && temp_val < 3) {														temp_val = temp_val * 20 * Math.random();  						}												if (temp_val == 3) {							temp_val = temp_val * 25 * ((Math.random()/3) + 0.6);  						}																		grid[bank_index][step_index][bank_option_index] = temp_val; 												var mc:MovieClip = new MovieClip();												//draw a grey box for this step 						mc.graphics.beginFill(0xcccccc);						mc.graphics.drawRect(0, 0, 10, 10);						mc.graphics.endFill();														//draw a red box if the step is on 						mc.graphics.beginFill(0xFF0000, (100/100));						mc.graphics.drawRect(0, 0, 10, 10);						mc.graphics.endFill();																mc.x = step_index * 20;												trace(step_index * 20)												trace('step_index'+step_index);												//work out the number of bank options to draw things right												var number_of_bank_options:Number = jsonData['banks'][bank_index]['bank_options'].length; 												trace('bank index'+bank_index);												mc.y = (bank_option_index * 20) + (bank_index * number_of_bank_options * 20) + 100;												_stage.addChild(mc);															step_index++;					}					bank_option_index++;				}				bank_index++;							}									drawPLayhead();			makeSoundObjects();			calculateStepTime();		}		/**		 * draw the playhead 		 *		 */		private function drawPLayhead() {			//draw a grey box for this step 			playhead.graphics.beginFill(0xcccccc);			playhead.graphics.drawRect(0, 0, 10, 10);			playhead.graphics.endFill();												playhead.x = 0;			playhead.y = 90;						addChild(playhead);						}						/**		 * Make all the required sound objects 		 *		 */			private function makeSoundObjects() {						//make all the sound objects ready for me to play them 						sounds = new Array(jsonData['banks'].length);						var myController:SoundChannel;						for (bank_index=0; bank_index < jsonData['banks'].length; bank_index++) {									sounds[bank_index] = new Array(jsonData['banks'][bank_index]['bank_options'].length);								for (bank_option_index=0; bank_option_index < jsonData['banks'][bank_index]['bank_options'].length; bank_option_index++) {										var sound_file_location:String = "http://jimmytidey.co.uk/chance_acorn/"+jsonData['banks'][bank_index]['bank_options'][bank_option_index]['file_location'];										trace (sound_file_location);										var MySound:Sound = new Sound(new URLRequest(sound_file_location));					var MyChannel:SoundChannel = new SoundChannel();													sounds[bank_index][bank_option_index] = MySound;					channels[bank_index][bank_option_index] = MyChannel;					}			}					}		/**		 * set the step time		 *		 */		private function calculateStepTime() {							var beats_per_second:Number = jsonData['project_info']['bpm']/60;			var seconds_per_beat:Number = 1/beats_per_second; 			step_time = (seconds_per_beat * jsonData['project_info']['bpl'])*1000; 						myTimer = new AccurateTimer(step_time, 1000);					}		public function go() {			myTimer.addEventListener(TimerEvent.TIMER, step);			myTimer.start(); 		}				public function my_stop() {			myTimer.stop(); 		}						public function reset() {					}												/**		 * function called for each new step  		 *		 */				private function step(event:TimerEvent):void		{				step_number = (myTimer.currentCount-1) % jsonData['project_info']['steps'];						playhead.x = step_number*20;						for (bank_index=0; bank_index < jsonData['banks'].length; bank_index++) {								trace(jsonData['banks'][bank_index]['bank_options'].length);								var max_value:int =0 				var max_value_index:int = 0				var current_step_value = 0; 								for (bank_option_index=0; bank_option_index < jsonData['banks'][bank_index]['bank_options'].length; bank_option_index++) {										current_step_value = grid[bank_index][step_number][bank_option_index];										//work out which of the bank options should play					if (current_step_value > max_value) {						max_value = current_step_value;						max_value_index = bank_option_index; 					}															//stop all sounds which have to stop before the next step ie. ones which don't have overplay set					if (jsonData['banks'][bank_index]['bank_options'][bank_option_index]['overplay'] == "false") {						trace('bank index '+bank_index);						trace('step '+step_number);						trace('bank option index '+bank_option_index);									trace('stop');						channels[bank_index][max_value_index].stop();					}				}								//play the step with the maximum value				trace ("max value ="+ max_value+ " max value index="+ max_value_index); 				if (max_value > 10) {					trace("playing bank: "+bank_index+" bank_option "+max_value_index);										var loop:Number; 										if (jsonData['banks'][bank_index]['bank_options'][max_value_index]['loop'] == 'true') {						loop= 100;					}										else {loop=0;}										channels[bank_index][max_value_index] = sounds[bank_index][max_value_index].play(0,loop);							transformation[bank_index][max_value_index] = channels[bank_index][max_value_index].soundTransform;					 					transformation[bank_index][max_value_index].volume = (jsonData['banks'][bank_index]['bank_options'][max_value_index]['volume'])/100; 										channels[bank_index][max_value_index].soundTransform = transformation[bank_index][max_value_index];												}			}		}						}}