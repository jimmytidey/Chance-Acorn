﻿package {	import com.adobe.serialization.json.JSON;	import flash.net.URLRequest;	import flash.net.URLLoader;	import flash.events.*;	import flash.display.*; 	import flash.text.*; 	import com.joshtime.jButton;	import flash.media.SoundMixer;			//this object as a container for everything. Has to extend movieclip to inherit the stage obejct	public class RandomSeedComposer extends MovieClip {				var _stage:Stage; // have to define this to pass the stage object around, how fucking stupid is that?				//holding all the date from reading the json		var jsonData:Object; //holds all the json data		var sounds:Array; // array for sound objects for each bank option		var grid:Array; //holds the probabiliyies of each step playing 				//variables from controlling the state of this class		var step_time:Number; //indicates the length of time each step plays for 		var step_number:int = 0; //indicates which step the timer is currently on		var reload_sounds:int = 1; ////use this to check if we need to recreate all the sound objects		var play_status:int = 0;				//control objects 		var calculateGrid:CalculateGrid = new CalculateGrid();		var selectSteps:SelectSteps = new SelectSteps();		var render:Render = new Render();		var soundObjects:SoundObjects = new SoundObjects();					//other useful objects 		var myTimer:AccurateTimer;				var loader:URLLoader = new URLLoader();		var requester:URLRequest = new URLRequest();						var stopPlayContainer:MovieClip = new MovieClip;		public function RandomSeedComposer(stage:Stage):void {			_stage = stage; 		}  				public function init() {			//clear the stage 			while (_stage.numChildren > 0) {_stage.removeChildAt(_stage.numChildren-1);} 						_stage.addChild(stopPlayContainer); 			//draw buttons 			drawButtons();			loadJSON();					}		public function loadJSON() {			var project_info_location:String = root.loaderInfo.parameters.project_info_location;						//default to make debug easier			if (project_info_location == null) {project_info_location  = 'http://chance-acorn.jimmytidey.co.uk/list.php?project_name=test2';}						requester.url=project_info_location;			loader.load(requester);			loader.addEventListener(Event.COMPLETE, decodeJSON);					} 					//Make the grid object with all of the relative play probabilties in		public function decodeJSON(event:Event) {			this.jsonData =JSON.decode(loader.data);						//some stuff that only needs to be done on a reload, not a randomise			trace (reload_sounds);			if (this.reload_sounds == 1) {						sounds = soundObjects.make(this.jsonData, _stage);				calculateStepTime();				reload_sounds = 0; 				}						//draw the grid and shade in the various probabilities 			this.grid = calculateGrid.buildGrid(this.jsonData, _stage);						//colour in the steps which will actually play 			selectSteps.renderPlayingSteps(jsonData, grid, _stage);								//Draw the playhead			render.drawPlayhead(jsonData, _stage, step_number);											}						public function drawButtons() {								//play btn 			var playBtn = new jButton("Play");			playBtn.x = 50; 			playBtn.y = 10;			stopPlayContainer.addChild(playBtn);			playBtn.addEventListener("c", playListener);			function playListener() {				while (stopPlayContainer.numChildren > 0) {stopPlayContainer.removeChildAt(stopPlayContainer.numChildren-1);}								stopPlayContainer.addChild(stopBtn);				go();			}						//stop btn 			var stopBtn = new jButton("Stop");			stopBtn.x = 50; 			stopBtn.y = 10;			stopBtn.addEventListener("c", stopListener);			function stopListener() {				while (stopPlayContainer.numChildren > 0) {stopPlayContainer.removeChildAt(stopPlayContainer.numChildren-1);}								stopPlayContainer.addChild(playBtn);				my_stop();			}						//randomise			var randomiseBtn = new jButton("Randomise");			randomiseBtn.x = 170; 			randomiseBtn.y = 10;			_stage.addChild(randomiseBtn);			randomiseBtn.addEventListener("c", randomise);								function randomise() {stopListener(); loadJSON();}								//rewind			var rewindBtn = new jButton("rewind");			rewindBtn.x = 290; 			rewindBtn.y = 10;			_stage.addChild(rewindBtn);			rewindBtn.addEventListener("c", rewind);									function rewind() {				stopListener();				movePlayHead(0);			}						//reload			var reloadBtn = new jButton("reload audio");			reloadBtn.x = 410; 			reloadBtn.y = 10;			_stage.addChild(reloadBtn);			reloadBtn.addEventListener("c", reload);						function reload() {				reload_sounds = 1;				init();			}			//step backward 			var backwardBtn = new jButton("«");			backwardBtn.x = 530; 			backwardBtn.y = 10;			_stage.addChild(backwardBtn);			backwardBtn.addEventListener("c", backward);						function backward() {				trace('back'); 				movePlayHead(step_number-1);				if (play_status == 1) {go();}			}							//step forward			var forwardBtn = new jButton("»");			forwardBtn.x = 650; 			forwardBtn.y = 10;			_stage.addChild(forwardBtn);			forwardBtn.addEventListener("c", forward);						function forward() {				movePlayHead(step_number+1)				if (play_status == 1) {go();}			}										}				private function calculateStepTime() {			var beats_per_second:Number = jsonData['project_info']['bpm']/60;			var seconds_per_beat:Number = 1/beats_per_second; 			step_time = (seconds_per_beat * jsonData['project_info']['bpl'])*1000; 			myTimer = new AccurateTimer(step_time, 1000);			myTimer.addEventListener(TimerEvent.TIMER, step);		}				public function go() {			my_stop(); // stop it from playing two things at once			myTimer.start();			play_status = 1; 			playStep();		}				public function step(event:TimerEvent) {			trace('timer event !'); 			step_number++;			playStep();		}									public function my_stop() {			trace('stop called');			play_status = 0; 			myTimer.stop(); 			SoundMixer.stopAll();		}						public function movePlayHead(position) {			trace(position); 			step_number = position; 			render.movePlayhead(step_number);		}				public function playStep() {						trace("STEP NUMBER:"+step_number); 						if (this.step_number == jsonData['project_info']['steps']-1) { //stop playback if we've got to the end of the track				 my_stop()			}						else {								render.movePlayhead(step_number);								for (var bank_index:int =0; bank_index < jsonData['banks'].length; bank_index++) {										for (var bank_option_index:int =0; bank_option_index < jsonData['banks'][bank_index]['bank_options'].length; bank_option_index++) {											//stop playback of everything which isn't playing and where overplay is false 						if (jsonData['banks'][bank_index]['bank_options'][bank_option_index]['overplay'] == "false") {							sounds[bank_index][bank_option_index].stopPlayBack();						}												//play any sounds which are set this time						if (grid[bank_index][step_number][bank_option_index] == 100) { 							sounds[bank_index][bank_option_index].playBack();						}					}				}			}		}	}}