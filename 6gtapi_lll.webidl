/*Low level events for phone lines. Not all providers need this.*/

/*Telephone network. Could be virtual for non-molile networks e.g. IP*/
dictionary TNetwork {
 String name;
 String prefix;
 byte home; /*level: 0 for home, 1,2,3... for farther roaming*/
 float rssi; /*received signal strength indication... or something like that*/
}

/*Low-level Line */
interface LLL : TLine {
 callback mm_onbeforeattach bool(TNetwork? oldN, TNetwork newN); /*return true to veto*/
 callback mm_onafterattach void(TNetwork? oldN, TNetwork newN);
 callback mm_ondetach void(TNetwork oldN);
 callback rr_ondetect void(TNetwork newN); /* a network detected, some information may be unavailable*/
}
