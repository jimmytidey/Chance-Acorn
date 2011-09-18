var mp3sound:Sound = new Sound();
var dynamicSound:Sound = new Sound();
var samples:ByteArray = new ByteArray();

function sampleData(event:SampleDataEvent):void {
  samples.position = 0;
  var len:Number = mp3sound.extract(samples,1777);
  if ( len < 1777 ) {
    // seamless loop
    len += mp3sound.extract(samples,1777-len,0);
  }
  samples.position = 0;
  for ( var c:int=0; c < len; c++ ) {
    var left:Number = samples.readFloat();
    var right:Number = samples.readFloat();
    event.data.writeFloat(left);
    event.data.writeFloat(right);
 }
}

function loadComplete(event:Event):void {
 dynamicSound.addEventListener("sampleData",sampleData);
 dynamicSound.play();
}


function extract(target:ByteArray,
           length:Number,
           startPosition:Number = -1 ):Number;

mp3sound.addEventListener(Event.COMPLETE, loadComplete);
mp3sound.load(new URLRequest("sound.mp3"));

