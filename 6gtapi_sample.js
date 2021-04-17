//Example for 6GTAPI...
var line=Telephony.getLines()[0]; //default
var call=line.createCall(line.getAddresses()[0],"+15556789");
var media=call.createMediaStream("audio");
media.connectSource(0); //default device
media.connectSink(0);
await call.make();
//terminate...
await call.drop(null,"Goodbye");