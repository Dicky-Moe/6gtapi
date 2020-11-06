/*Telephone line.
There are reasons for this API even in case of virtual line, as wireless and packet-oriented (as IP).
1. An intermediate level between a provider (not exposed to a script) and an address. It is possible to have 2 (or more) implementations of SIP, slightly different; a script would thus see 2 identical addresses. Now, the script should see 2 lines, with an address each.
2. A line - even wireless or virtual - has some state, distinct from state of any call.
3. The same interface is used for remote call control.
*/

interface TLine {
 Call createCall(TAddress local, String remote);
 Call? takeCall();
 sequence <TAddress> getLocalAddresses ();
 Promise <Call> unpark(String call);
 callback onincomingcall void();
 callback onmonitorcall void();
 callback oninvite void(Invitation);
 Promise <Conference?> join(String convenor, boolean hidden);
 callback onjoin Conference? (TAddress);
 Call createCall3(TAddress local, String cg, String cd); /*3rd party call control*/
 Conference createConference(TAddress local, String subject, Object policy, sequence<MediaStream> streams); /*Create a conference... How did I forget this?*/
 boolean checkState(String state); /*I could not make it enum!*/
 callback onstatechange void();
}

/*Extension to telephony*/
interface LineTelephony : Telephony {
 sequence<TLine> getLines();
}

/*Extension to call*/
interface CallWithLine : Call {
 readonly attribute TLine line;
}
