﻿package {     import flash.display.Sprite;       import flash.events.MouseEvent;       import flash.net.URLLoader;       import flash.net.URLRequest;       import flash.events.Event;       import flash.utils.ByteArray;       import flash.media.Sound;       import org.as3wavsound.WavSound;       import org.as3wavsound.WavSoundChannel;  			/**	 * ...	 * @author b.bottema [Codemonkey]	 */	class Main extends Sprite  {				         var urlRequest:URLRequest = new URLRequest('assets/rain_loop.wav');  		 var wav:URLLoader = new URLLoader();  		 wav.dataFormat = 'binary';  		 wav.load(urlRequest);  		 wav.addEventListener(Event.COMPLETE, playWav);  						function playWav(e:Event):void           {  			const RainLoop:Class;			const rain:WavSound = new WavSound(new RainLoop() as ByteArray);										rain.play(0, int.MAX_VALUE);					 }	}}