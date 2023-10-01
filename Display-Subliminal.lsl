// DisplaySubliminal.lsl
// "Subliminal" Display script for BG L-CON Subliminal HUD 2023-09-29
// Timberwoof Lupindo
// September 2023
string version = "2023-09-29";
integer OPTION_DEBUG = FALSE;

integer linkTitler = 1;
integer AlphanumFrameLink;
integer AlphanumFrameFace = 0;
integer timerInterval = 20;

// **** general use colors
vector BLACK = <0,0,0>;
vector DARK_GRAY = <0.2, 0.2, 0.2>;
vector GRAY = <0.5, 0.5, 0.5>;
vector LIGHT_GRAY = <0.7, 0.7, 0.7>;
vector WHITE = <1.0, 1.0, 1.0>;
vector DARK_RED = <0.5, 0.0, 0.0>;
vector RED = <1.0, 0.0, 0.0>;
vector REDORANGE = <1.0, 0.25, 0.0>;
vector DARK_ORANGE = <0.5, 0.25, 0.0>;
vector ORANGE = <1.0, 0.5, 0.0>;
vector YELLOW = <1.0, 1.0, 0.0>;
vector DARK_GREEN = <0.0, 0.5, 0.0>;
vector GREEN = <0.0, 1.0, 0.0>;
vector DARK_BLUE = <0.0, 0.0, 0.5>;
vector BLUE = <0.0, 0.0, 1.0>;
vector DARK_MAGENTA = <0.5, 0.0, 0.5>;
vector MAGENTA = <1.0, 0.0, 1.0>;
vector DARK_CYAN = <0.0, 0.5, 0.5>;
vector MEDIUM_CYAN = <0.0, 0.5, 1.0>;
vector CYAN = <0.0, 1.0, 1.0>;
vector PURPLE = <0.7, 0.1, 1.0>;

// BG_CollarV4_PowerDisplay_PNG
key batteryIconID = "ef369716-ead2-b691-8f5c-8253f79e690a";
integer batteryIconLink = -1;
integer batteryIconFace = 4;
float batteryIconHScale = 0.2;
float batteryIconVScale = 0.75;
float batteryIconRotation = 90.0;
float batteryIconHoffset = -0.4;
vector batteryIconColor;
integer batteryPercent;
float brightnessMultiplier = 1.0;

list moodNames = ["OOC", "Lockup", "Submissive", "Versatile", "Dominant", "Nonsexual", "Story", "DnD"];
list moodColors = [LIGHT_GRAY, WHITE, GREEN, YELLOW, ORANGE, CYAN, PURPLE, GRAY];
list moodTexts = ["I am not roleplaying.", "I just need some lockup time.", 
    "I want to submit to someone else.", "I am ready for any role.", "I want to dominate someone.",
    "I am not feeling sexual.", "I want to role-play in a story.", "I do not wish to be disturbed."];
vector moodColor = WHITE;
vector oldMoodColor = BLACK;
string mood = "OOC";

//list threatLevels = ["None", "Moderate", "Dangerous", "Extreme"];
//list threatColors = [GREEN, YELLOW, ORANGE, RED];

list classNames = ["white","pink","red","orange","green","blue","black"];
list classNamesLong = ["a transfer prisoner", "a sexual deviant", "in the Mechanics Guild", 
    "in General Population", "receiving medical treatment", "violent or hopeless", "an end-stage mental patient"];
list classColors = [WHITE, MAGENTA, RED, ORANGE, GREEN, MEDIUM_CYAN, GRAY];

string class;
string classLong;
vector classColor;
string lockLevel;
string crime;
string threat;

string assetNumber = "P-00000";
string unassignedAsset = "P-00000";

key avatar = NULL_KEY;
integer listenChannel = -36984125;
integer listenEr;

list displayMessageList = [];
string oldMessage = "";
integer maxlines = 6;

sayDebug(string message)
{
    if (OPTION_DEBUG)
    {
        llOwnerSay("Display: "+message);
    }
}

integer getLinkWithName(string name) {
    // Look at every prim and return the link number of the one whose name matches.
    integer i;   // Start at zero (single prim) or 1 (two or more prims)
    integer x = llGetNumberOfPrims() + i; // [0, 1) or [1, llGetNumberOfPrims()]
    integer result = -1;
    for (i = 1; i <= x; ++i) {
        string linkName = llGetLinkName(i);
        sayDebug("getLinkWithName "+(string)i+" "+linkName);
        if (linkName == name) {
            result = i; // Found it! Exit loop early with result
        }
    }
    sayDebug("getLinkWithName("+name+") returns "+(string)result);
    return result; // No prim with that name, return -1.
}

displayBattery(integer percent)
// Based on the percentage, display the correct icon and color.
// Integer percent ranges 0 to 100.
{
    // The battery icon has 5 states. Horizontal Offsets can be
    // -0.4 full charge 100% - 88%
    // -0.2 3/4 charge   87% - 75% - 62%
    //  0.0 1/2 charge   61% - 50% - 38%
    //  0.2 1/4 charge   37% - 25% - 12%
    //  0.4 0/4 charge   12% - 0%
    //  Between 5% and 1% it shows red.
    //  At 0% it turns black.

    if (percent > 87) batteryIconHoffset = -0.4; // full
    else if (percent > 61) batteryIconHoffset = -0.2; // 3/4
    else if (percent > 37) batteryIconHoffset =  0.0; // 1/2
    else if (percent > 12) batteryIconHoffset =  0.2; // 1/4
    else batteryIconHoffset =  0.4; // empty
    
    if (percent > 12) {
        batteryIconColor = MEDIUM_CYAN; // blue-cyan full, 3/4, 1/2, 1/4
        brightnessMultiplier = 1.0;
    }
    else if (percent > 8) {
        batteryIconColor = <1.0, 0.5, 0>; // orange empty
        brightnessMultiplier = 0.75;
    }
    else if (percent > 4) {
        batteryIconColor = <1.0, 0.0, 0.0>; // red empty
        brightnessMultiplier = 0.50;
    }
    else {
        batteryIconColor = <0.0, 0.0, 0.0>; // black empty
        brightnessMultiplier = 0.0;
    }
    sayDebug("displayBattery("+(string)percent+") brightnessMultiplier:" + (string)brightnessMultiplier);
    llSetLinkPrimitiveParamsFast(batteryIconLink,[PRIM_TEXTURE, batteryIconFace, batteryIconID, <0.2, 0.75, 0.0>, <batteryIconHoffset, 0.0, 0.0>, 1.5708]);
    llSetLinkPrimitiveParamsFast(batteryIconLink,[PRIM_COLOR, batteryIconFace, batteryIconColor*brightnessMultiplier, 1.0]);
}

displaySubliminal(string newMessage) {
    // Display the message on the HUD. 
    // Fade out  the old text, fade in the new text.
    // Remember the message and (in case mood got set) color. 
    // moodColor is evilly taken from the global. 
    float index;
    for (index = 1.0; index >= 0.0; index = index - 0.02) {
        llSetText(oldMessage, oldMoodColor, index);
    }
    for (index = 0.0; index <= 1.0; index = index + 0.02) {
        llSetText(newMessage, moodColor, index);
    }
    oldMessage = newMessage;
    oldMoodColor = moodColor;
    llSetTimerEvent(timerInterval);
}

addKeyValue(string Key, string value) {
// Add a key-value pair to displayMessageList,
// a strided list of keys and values.
// Thus one message of each key can be kept. 
// This is useful for things like class and mood. 
// Evil message transmitters can also replace messages. 
    integer index = llListFindStrided(displayMessageList, [Key], 0, -1, 2);
    if (index == -1) {
        // it's not in the list, so add it
        sayDebug("addKeyValue "+(string)index+" adding "+Key+"="+value);
        displayMessageList = displayMessageList + [Key, value];
    } else {
        // it is in the list, so replace it
        sayDebug("addKeyValue "+(string)index+" replacing "+Key+"="+value);
        string oldValue = llList2String(displayMessageList, index+1);
        displayMessageList = llListReplaceList(displayMessageList, [Key, value], index, index+1);
    }
    integer numOfLines = llGetListLength(displayMessageList);
    sayDebug("addKeyValue numOfLines:"+(string)numOfLines);
}

removeKeyValue(string Key) {
// Remove a key-value pair from displayMessageList
    integer index = llListFindStrided(displayMessageList, [Key], 0, -1, 2);
    if (index > 0) {
        // it is in the list, so remove it
        sayDebug("removeKeyValue "+Key+" "+(string)index);
        displayMessageList = llListReplaceList(displayMessageList, [], index, index+1);
    }
}

handleCollarMessage(string senderName, string json) {
    // When a message is received from the transmitter,
    // decide what to do with it. 
    // Generate the custom text for each message.
    // Some messages get displayed right away. 
    // All messages get added to the message store.  
        integer handled = 0;

        // IC/OOC Mood sets text color
        string value = llJsonGetValue(json, ["Mood"]);
        if (value != JSON_INVALID) {
            mood = value;
            integer moodIndex = llListFindList(moodNames, [mood]);
            sayDebug("listen moodIndex:"+(string)moodIndex);
            string moodText = llList2String(moodTexts, moodIndex);
            moodColor = llList2Vector(moodColors, moodIndex);
            sayDebug("listen moodColor:"+(string)moodColor);
            addKeyValue("Mood", moodText);
            displaySubliminal(moodText);
            handled = 1;
        }

        // Prisoner Class sets frame color
        value = llJsonGetValue(json, ["Class"]);
        if (value != JSON_INVALID) {
            class = value;
            integer classIndex = llListFindList(classNames, [class]);
            string classNameLong = llList2String(classNamesLong, classIndex);
            vector classColor = llList2Vector(classColors, classIndex);
            llSetLinkPrimitiveParamsFast(AlphanumFrameLink,[PRIM_COLOR, ALL_SIDES, classColor, 1.0]);
            llSetLinkPrimitiveParamsFast(AlphanumFrameLink,[PRIM_COLOR, AlphanumFrameFace, DARK_GRAY, 1.0]);
            addKeyValue("Class", "My collar is " + class + " because I am " + classNameLong + ".");
            handled = 1;
        }

        // Lock level 
        value = llJsonGetValue(json, ["LockLevel"]);
        if (value != JSON_INVALID) {
            list lockLevels = ["Safeword", "Off", "Light", "Medium", "Heavy", "Hardcore"];
            integer locki = llListFindList(lockLevels, [lockLevel]);
            string message;
            if (value == "Off") {
                message = "I would feel safer with my collar locked.";
            } else if (value == "Safeword") {
                message = "It's okay. I can receive counseling for having safeworded.";
            } else {
                message = "I am grateful that my collar gives me " + value + " lockup.";
            }
            addKeyValue("LockLevel",message);
            displaySubliminal(message);
            handled = 1;
        }

        // Threat level 
        value = llJsonGetValue(json, ["Threat"]);
        if (value != JSON_INVALID) {
            sayDebug("threat level json:"+json);
            // +" threati:"+(string)threati+" threatcolor:"+(string)threatcolor);
            threat = llToLower(value);
            if (threat == "none") {
                threat = "no";
            } else {
                threat = "a " + threat;
            }
            addKeyValue("Threat", "I am "+threat+" threat to those around me.");
            handled = 1;

            // Maybe later make the threat message show up in its color, 
            // and subsequent messages use the normal color. 
            // The threat message woudl have to be associated with its color. 
            //integer threati = llListFindList(threatLevels, [threat]);
            //vector threatcolor = llList2Vector(threatColors, threati);
        }

        // Battery Level
        value = llJsonGetValue(json, ["BatteryPercent"]);
        if (value != JSON_INVALID) {
            batteryPercent = (integer)value;
            displayBattery(batteryPercent);
            if (batteryPercent > 90) {
                addKeyValue("Battery", "I feel better now that my collar battery is charged up.");
            } else if (batteryPercent > 20) {
                removeKeyValue("Battery");
            } else if (batteryPercent > 10) {
                addKeyValue("Battery", "I should recharge my collar battery.");
            } else {
                addKeyValue("Battery", "I urgently need to recharge my collar battery.");
            }
            handled = 1;
        }

        // Prisoner Crime
        value = llJsonGetValue(json, ["Crime"]);
        if (value != JSON_INVALID) {
            crime = value;
            addKeyValue("Crime", "I regret having committed "+crime);
            handled = 1;
        }

        // Prisoner Asset Number
        value = llJsonGetValue(json, ["AssetNumber"]);
        if (value != JSON_INVALID) {
            assetNumber = value;
            sayDebug("set and display assetNumber \""+assetNumber+"\"");
            if (assetNumber != "P-00000") {
                addKeyValue("Name", "My name is "+assetNumber+".");
                addKeyValue("Say", "When I am asked my name, I will say "+assetNumber+".");
                addKeyValue("AssetNumber", "My Asset Number is "+assetNumber+".");
            }
            handled = 1;
        }

        // Prisoner Asset Number by Name
        // This decodes the "Name" message 
        // because the asset number isn't always sent.
        value = llJsonGetValue(json, ["Name"]);
        if (value != JSON_INVALID) {
            assetNumber = llGetSubString(senderName, 0, 6);
            sayDebug("set and display assetNumber \""+assetNumber+"\"");
            if (assetNumber != "BG L-CO") {
                addKeyValue("Name", "My name is "+assetNumber+".");
                addKeyValue("Say", "When I am asked my name, I will say "+assetNumber+".");
                addKeyValue("AssetNumber", "My Asset Number is "+assetNumber+".");
            }
            handled = 1;
        }

        // RLV zap by object such as door. 
        value = llJsonGetValue(json, ["RLV"]);
        if (value != JSON_INVALID) {
            handled = 1;
            sayDebug("RLV "+value);
            if (value == "ZapByObjectOFF") { 
                addKeyValue("ObjectZap", "I am safe from electrical shock.");
            } else if (value == "ZapByObjectON") { 
                addKeyValue("ObjectZap", "I deserve punishment for carelessness.");
            } else {
                handled = 0;
            }
        }
        
        value = llJsonGetValue(json, ["ZAP"]);
        if (value != JSON_INVALID) {
            handled = 1;
            sayDebug("RLV "+value);
            if (value == "0") {
                value = "Punishment is good for me.";
                addKeyValue("Zap", value);
                displaySubliminal(value);
            } else if (value == "1") {
                value = "I deserve extra punishment.";
                addKeyValue("Zap", value);
                displaySubliminal(value);
            } else if (value == "2") { 
                value = "I deserve extreme punishment.";
                addKeyValue("Zap", value);
                displaySubliminal(value);
            }
        }

        value = llJsonGetValue(json, ["ZapLevels"]);
        if (value != JSON_INVALID) {
            list zaplevels = llParseString2List(value, ["[","]"], [","]);
            sayDebug("zaplevels:"+(string)zaplevels);
            if (llList2Integer(zaplevels, 2)) {
                addKeyValue("Zap2","I may be punished severely.");
            } else {
                removeKeyValue("Zap2");
            }
            if (llList2Integer(zaplevels, 1)) {
                addKeyValue("Zap1","I may be punished moderately.");
            } else {
                removeKeyValue("Zap1");
            } 
            if (llList2Integer(zaplevels, 0)) {
                addKeyValue("Zap0","I may be punished mildly.");
            } else {
                removeKeyValue("Zap2");
            }
            handled = 1;
        }
        
        if (handled == 0) {
            sayDebug("handleCollarMessage did not handle "+json);
    }
}

handleMessageSender(string json) {
    // Handle message from a generalized message sender.
    // These get added to the store of messages. 
    list jsonList = llJson2List(json);
    string Key = llList2String(jsonList, 0);
    string value =  llList2String(jsonList, 1);
    addKeyValue(Key,value);
    sayDebug("handleMessageSender added "+Key+":"+value);
}

default
{
    state_entry()
    {
        sayDebug("state_entry");
        llSetText("", BLACK, 0.0);
        linkTitler = 1;
        AlphanumFrameLink = getLinkWithName("alphanumFrame");
        batteryIconLink = getLinkWithName("powerDisplay");
        llSetLinkPrimitiveParamsFast(AlphanumFrameLink,[PRIM_COLOR, AlphanumFrameFace, LIGHT_GRAY, 1.0]);

        // Initialize the world
        batteryPercent = 100;
        displayBattery(batteryPercent);
        assetNumber = unassignedAsset;
        mood = "OOC";
        crime = "";
        class = "white";
        classColor = WHITE;
        threat = "none";

        listenEr = llListen(listenChannel, "", "", "");
        llSetTimerEvent(timerInterval);
        sayDebug("state_entry done");
    }

    touch_start(integer total_number)
    {
            integer touchedLink = llDetectedLinkNumber(0);
            integer touchedFace = llDetectedTouchFace(0);
            vector touchedUV = llDetectedTouchUV(0);
            sayDebug("Touched Link "+(string)touchedLink+", Face "+(string)touchedFace+", UV "+(string)touchedUV);
    }
    
    listen(integer channel, string name, key id, string json) {
        key messageOwner = llGetOwnerKey(id);
        sayDebug("link_message name:"+name+" json:"+json+" id:"+(string)id+ "messageOwner:"+(string)messageOwner);
        key HudOwner = llGetOwner();
        key timberwoof = "284ba63f-378b-4be6-84d9-10db6ae48b8d";
        if (messageOwner == HudOwner) {
            handleCollarMessage(name, json);
        }
        if (name == "L-CON Subliminal Message Sender" & messageOwner == timberwoof){
            handleMessageSender(json);
        }
    }
    
    timer() {
        integer numOfLines = llGetListLength(displayMessageList);
        integer index = (integer)(llFloor(llFrand(numOfLines) / 2) * 2);
        string Value = llList2String(displayMessageList, index+1);
        sayDebug("timer numOfLines:"+(string)numOfLines+" index:"+(string)index+" Value:"+Value);
        displaySubliminal(Value);
        llSetTimerEvent(20);
    }
}
