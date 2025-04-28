/*Media-specific streams*/
/*These are for (TLine).createMediaStream e.g. line.createMediaStream("audio");
Note the naming convention
API-level major types DO NOT match those in SDP or PrSD
--known SDP types are audio/*, video/*, application/bfcp, control/isup, image/t38, message/msrp, text/t140--
*/

interface TAudio:MediaStream{ } //nothing special

interface TVideo:MediaStream{
 attribute int32 Window; //handle to output window (impl. specific)
 attribute int32 x,y,w,h; //size of the output inside the Window
 //The window displays the input stream, or monitors the output one.
}

//an old draft lists in this order...
interface TFax:MediaStream{ } //TODO. There is feedback - the number of the recipient transmitted back to the sender

interface TTextStream:MediaStream{ } //text stream, as in TTY or T.140 or telnet or SSH. Anyone wants this?

interface TFile:MediaStream{
 //TODO
 /*A file consists of name, content (sized), times (creation, access, modification), other attributes (implementation-specific). E.g. FAT: read-only, hidden, system, archive; HPFS/NTFS: security descriptor.
 Not everything above makes sense for network transmissions at all.
 This API MUST also allow file requests (pulling) and searching. Current specs (MSRP) do not define these features.*/
}

interface TApplicationSharing:MediaStream{ 
 //TODO
 //this is the official name of T.128. MS-RDP is based on it.
 //actual terminal->host stream consists of keyboard input (in T.128, either 1-byte VK defined by Windows API, distinct from HTML; or Unicode) and mouse input (in T.128, X10 like). The host->terminal stream is a series //of windows and bitmaps. Cf. X and Wayland.
}

interface TWhiteboard:MediaStream{ } //TODO, currently no specs at IETF

interface TPresentation:MediaStream{ } //TODO, currently no specs at IETF nor ITU

interface TVoting:MediaStream{ } //TODO, currently no specs at IETF nor ITU

interface TTextChat:MediaStream{ } //message-based

//remote call control, as in draft-tveretin-dispatch-remote
interface Remote:MediaStream{
 TLine getLine();
}

interface TSms:MediaStream{
 attribute String raw; //or other type, such as BLOB?
 attribute String text; //could be transcoded
 attribute String? messageCenter;
}

//tunneling
interface TCell:MediaStream{ } //e.g. ATM or MPEG Transport

interface TPacket:MediaStream{ } //e.g. X.25

interface TFrame:MediaStream{ //big, so IP fits tis category, as well as Frame Relay
 attribute boolean vpn; //connect as VPN
} 