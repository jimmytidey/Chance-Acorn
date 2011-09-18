package  
{
	import de.popforge.gui.Slider;	
	import de.popforge.audio.output.Sample;	
	import de.popforge.audio.processor.effects.Flanger;	
	
	import flash.display.*;
	import flash.media.*;
	import flash.utils.*;
	import flash.events.*;
	import flash.text.*;
	import flash.net.*;
	
	[SWF(frameRate='255',backgroundColor='0x22222f',width='400', height='400')]
	
	/**
	 * @author Joa Ebert
	 */
	public class Main extends Sprite 
	{
		private static const BUFFER_SIZE: int = 0x1000;
		
		private const flanger: Flanger = new Flanger();
		private const samples: Array = new Array( BUFFER_SIZE );//Vector.<Sample>
		private const buffer: Sound = new Sound();
		private const mp3: Sound = new Sound();
		private const sampleBuffer: ByteArray = new ByteArray();
		private const text: TextField = new TextField();
		
		private var samplePosition: int;
		
		public function Main()
		{
			init();
		}
		
		private function init(): void
		{
			initGUI();
			initSamples();
			initMP3();	
			
			flanger.parameterDelay.setValueNormalized( 0.32 );
			flanger.parameterMix.setValue( 1.0 );
			flanger.parameterFeedback.setValue( 0.75 );
		}

		private function initMP3(): void
		{
			text.text = 'Loading MP3 ...';
			
			mp3.addEventListener( Event.COMPLETE, onMP3Complete);
			mp3.load(new URLRequest('sound.mp3'));
		}
				
		private function initSamples(): void
		{
			for( var i: int = 0, n: int = BUFFER_SIZE; i < n; ++i )
				samples[i] = new Sample();
		}
		
		private function initGUI(): void
		{
			var slider: Slider;
			
			slider = new Slider( flanger.parameterDelay );
			slider.x = 16;
			slider.y = 16;
			addChild( slider );
			
			slider = new Slider( flanger.parameterDepth );
			slider.x = 16;
			slider.y = 48;
			addChild( slider );
			
			slider = new Slider( flanger.parameterSpeed );
			slider.x = 16;
			slider.y = 80;
			addChild( slider );
			
			slider = new Slider( flanger.parameterFeedback );
			slider.x = 16;
			slider.y = 112;
			addChild( slider );
			
			slider = new Slider( flanger.parameterMix );
			slider.x = 16;
			slider.y = 144;
			addChild( slider );
			
			text.x = 148;
			text.y = 16;
			text.selectable = false;
			
			text.defaultTextFormat = new TextFormat('Arial', 9, 0xffffff);
			text.autoSize = TextFieldAutoSize.LEFT;
			text.multiline = true;
			
			addChild( text );
		}
		
		private function onMP3Complete( event: Event ): void
		{
			text.text = '# Flanger.DELAY\n# Flanger.DEPTH\n# Flanger.SPEED\n# Flanger.FEEDBACK\n# Flanger.MIX';
			
			buffer.addEventListener( Event.SAMPLES_CALLBACK, onSamplesCallback );
			buffer.play();
		}
		
		private function onSamplesCallback( event: Event ): void
		{		
			const n: int = BUFFER_SIZE;
			
			var i: int = 0;
			var sample: Sample;
			var samplesRead: int;
			var samplesOffset: int;
			
			{
				//
				//-- EXTRACT AUDIO SAFE FROM AN MP3 AND LOOP IT
				//
				
				//-- RESET BUFFER
				sampleBuffer.position = 0;
				
				//-- TRY READING AS MANY SAMPLES AS POSSIBLE
				samplesRead = mp3.extract( sampleBuffer, BUFFER_SIZE, samplePosition );
				
				//-- IF WE ARE AT THE END > START FROM THE BEGINNING
				if( 0 == samplesRead )
					samplePosition = 0;
				else			
					samplePosition = -1;
				
				//-- BE SAFE AND READ UNTIL WE REACH THE BUFFER SIZE
				while( samplesRead < BUFFER_SIZE )
				{
					//-- TRY READING THE MISSING NUMBER OF SAMPLES
					samplesOffset = mp3.extract( sampleBuffer,BUFFER_SIZE - samplesRead, samplePosition );
					
					//-- LOOP IF WE ARE AT THE END
					if( 0 == samplesOffset )
						samplePosition = 0;
					else
						samplePosition = -1;
						
					samplesRead += samplesOffset; 
				}
					
				sampleBuffer.position = 0;
			}
			
			//-- CONVERT BINARY DATA INTO POPFORGE SAMPLES
			for(;i<n;++i)
			{
				sample = samples[i];
				
				sample.left = sampleBuffer.readFloat();
				sample.right = sampleBuffer.readFloat();
			}
			
			//-- ANDRÉ MICHELLE'S FLANGER
			flanger.processAudio( samples );
			
			//-- WRITE THE SAMPLES INTO THE AUDIO BUFFER
			for(i=0;i<n;++i)
			{
				sample = samples[i];
				
				buffer.samplesCallbackData.writeFloat(sample.left);
				buffer.samplesCallbackData.writeFloat(sample.right);
			}
		}
	}
}
