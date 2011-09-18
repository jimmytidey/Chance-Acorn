package 
{
	
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.*;
	import flash.utils.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.display.*; 
	

 public class WavURLPlayer
     {


      public static function PlayWavFromURL(wavurl:String):void
      {
       var urlLoader:URLLoader = new URLLoader();
        urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
        urlLoader.addEventListener(Event.COMPLETE, onLoaderComplete);
        urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError);

       var urlRequest:URLRequest = new URLRequest(wavurl);

       urlLoader.load(urlRequest);
      }

      private static function onLoaderComplete(e:Event):void
      {
       var urlLoader:URLLoader = e.target as URLLoader;
        urlLoader.removeEventListener(Event.COMPLETE, onLoaderComplete);
        urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError);

       var wavformat:WavFormat = WavFormat.decode(urlLoader.data);

       SoundFactory.fromArray(wavformat.samples, wavformat.channels, wavformat.bits, wavformat.rate, onSoundFactoryComplete);
      }

      private static function onLoaderIOError(e:IOErrorEvent):void
      {
       var urlLoader:URLLoader = e.target as URLLoader;
        urlLoader.removeEventListener(Event.COMPLETE, onLoaderComplete);
        urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError);

       trace("error loading sound");

      }

      private static function onSoundFactoryComplete(sound:Sound):void
      {
       sound.play();
      }

	}
 }
