﻿package {	import flash.net.URLRequest;	import flash.net.URLLoader;	import flash.events.*;	import flash.utils.*;	import flash.display.*; 	import com.joshtime.jButton;		public class Render extends MovieClip {		var playhead_container:MovieClip = new MovieClip;				//draw the playhead		public function drawPlayhead(jsonData, _stage) {						//incase playhead is already on the screen somehow			while (this.playhead_container.numChildren > 0) {				this.playhead_container.removeChildAt(this.playhead_container.numChildren-1);			}									//work out how high the playhead needs to be 			var total_bank_options:int;			for (bank_index=0; bank_index < jsonData['banks'].length; bank_index++) {				total_bank_options += jsonData['banks'][bank_index]['bank_options'].length;			}						var playhead_height:int = ((total_bank_options - bank_index) * 20) + (bank_index * 40); 						//draw that playhead			var playhead:MovieClip = new MovieClip(); //the playhead movie			playhead.graphics.beginFill(0xcccccc, 0.5);			playhead.graphics.drawRect(0, 0, 10, playhead_height);			playhead.graphics.endFill();									playhead.x = 100;			playhead.y = 90;						//add the container to the stage			this.playhead_container.addChild(playhead);			_stage.addChild(this.playhead_container);		}				public function movePlayhead(x_displacement) {			playhead_container.x = x_displacement; 		}	}}