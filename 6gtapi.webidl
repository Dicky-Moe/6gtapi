/*Helper interface. TODO*/
interface Bearer{
 attribute String BearerType;
 attribute Number Bitrate;
 attribute String QoSClass; //CBR, rtVBR, nrtVBR, ABR, UBR; RT, BE
}

interface MediaStream{
 void connectSink (int i);
 void connectSource (int i);
 void disconnect Sink();
 void disconnectSource ();
 void add ();
 void remove ();
 readonly attribute Direction enum {Both, In, Out, None};
 readonly attribute String type;
 attribute String subtype;
 readonly attribute boolean isConnected;
 Promise send(any data);
 Promise <any> recv();
 callback onrecv void(any);
}

/*The call. Conferences are excluded. However, SMS is considered a call.*/
interface Call{
 readonly attribute TAddress callingParty;
 readonly attribute TAddress calledParty;
 attribute String Subject;
 readonly attribute State enum {New, Dialing, Proceeding, Ringing, Waiting, Connected, Disconnected, Idle, Sent, Delivered, Unknown};
 attribute Bearer Bearer;
 readonly attribute Direction enum{Incoming, Outgoing, Transit, Internal, 3rdParty};
 readonly attribute LowLevel LowLevel;
 attribute Priority enum {};
 attribute int CUG;
 readonly attribute String AdviceOfCharge;
 attribute boolean unknownMediaType;
 boolean checkState(String state);
 sequence <MediaStream> getActiveMediaStreams();
 sequence <ForwardRecord> getHistory();
 Promise make();
 Promise commit();
 Promise drop(Reason reason, String text);
 Promise <boolean> blindTransfer(String to, Reason reason, String text);
 MediaStream createMediaStream(String type);
 void replaceMediaStream(MediaStream from, MediaStream to);
 boolean handoff();
 Promise <boolean> hold();
 Promise <String> park();
 Promise transfer(Call consult);
 Promise <boolean> unhold();
 callback onconnect void(Call);
 callback ondisconnect void(Call);
 callback onstatechange void(Call);
 callback onalert void(Call);
 callback onforward void(Call, ForwardRecord);
 callback ontransfer void(Call);
 callback onmodify void(Call);
 callback onremotehold void(Call);
 callback onremoteunhold void(Call);
}

/*Main interface. Globally accessible e.g. 
 var c=Telephony.createCall(Telephony.getLocalAddresses[0],"+15556789");*/
interface Telephony{
 Call createCall(TAddress local, String remote);
 Call? takeCall();
 sequence <TAddress> getLocalAddresses ();
 Promise <Call> unpark (String call);
 sequence <TDevice> getSourceDevices (String type);
 sequence <TDevice> getSinkDevices (String type);
 callback onincomingcall void();
 callback onmonitorcall void();
 callback oninvite void(Invitation);
 Promise <Conference?> join (String convenor, boolean hidden);
 callback onjoin Conference? (TAddress);
 String getSinkName(String type, int i);
 String getSourceName(String type, int i);
 int createSinkFile(String type, String file);
 int openSourceFile(String type, String file);
 Call createCall3(TAddress local, String cg, String cd); /*3rd party call control*/
}

interface Conference{
 sequence <Party> getParties();
 attribute String Subject;
 attribute Object Policy;
 Promise leave();
 Promise disband();
 Promise <Party> invite(String addr, String reason);
 Promise merge(Call);
 Party getSelf();
 callback onadmission boolean? (TAddress);
 callback onotherpartyjoin void(Party);
 callback onotherpartyleave void(Party, Reason);
 callback ondisconnect void(Reason);
 sequence <MediaStream> getMediaStreams();
 callback onwhisper void (Party, any);
}

interface Party{
 readonly attribute Conference conference;
 readonly attribute TAddress address;
 Promise <Call> split();
 void whisper(any data);
 Promise kill (Reason reason, String text);
}

interface Invitation{
 Promise <Conference> accept();
 Promise <Conference> acceptHidden();
 Promise reject (Reason);
 Conference asConference();
 Call asCall();
 Readonly attribute TAddress invitor;
 Readonly attribute String reason;
}

[Constructor (TAddress assumed, TAddress asserted)]
[Constructor (String assumedAddress, String assumedName, TAddress asserted)]
[Constructor (TAddress assumed, String assertedAddress, String assretedName)]
interface Impersonation{
 TAddress asAddress();
 boolean check();
 void grant();
 void revoke();
}

/*Telephony address. Currently, immutable, no constructor. Discuss.*/
interface TAddress{
 readonly attribute String DialString;
 readonly attribute String DisplayName;
 readonly attribute boolean isAnonymous; /*local address could be*/
 readonly attribute boolean isUnknown;
}
