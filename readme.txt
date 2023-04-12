BG "L-CON" Collar V4 2021-12-23 READ ME

Introduction
========
This document describes the Black Gazza "L-CON" Collar 4th Edition. Please read and understand all the safety directives before using this machinery. Do not operate this device under the influence of unauthorized psychotropic drugs except under the order of a Black Gazza official. Applying electrical tape to the neck electrodes is strictly forbidden. 

Quick Start
========
Do this in this order:
• Wear the Collar.
• Edit and adjust its size and position.
• Drag and drop your character sheet from your inventory into the collar Contents. 
• Close the edit window. 
• Click the collar, select Settings -> Class -> your prisoner color.
• Threat -> How dangerous a guard might think you are.
• SetZap -> checkboxes for what zap levels you will accept .
• Settings > RLV -> any option.
• Speech -> Renamer.
• Main -> Settings -> Mood -> your ic/ooc mood.

Sometimes menu items are surrounded by [Brackets]. That means that option is not available to you. You can't change some things while IC. Some things, like the renamer, gag, and bad words only work when you are locked. Prisoners cannot zap themselves or other prisoners. Guards can zap you or change your threat level, but not set your color. You can see all your information, but other inmates cannot see your info. Guards can see all your info. 

The RLV Lock levels just mean more severe restrictions. Light and Medium you can just turn off by selecting Off. Heavy requires you to safeword out. The collar will shout that you did it. Hardcore is available only when you are in Heavy lock. If you select that, you give up the Safeword option. Guards have much more control over your collar. If you want to be freed of Hardcore, you have to ask a Guard. 

This collar uses the Dominatech Relay. If you want to use it, do Settings > RLV > [] Relay. It will be in Ask mode. If you don't want to use this relay, then don't use this relay. When you switch to Heavy mode, it will switch to On mode. You have no choice. 

Philosophy
=======
BG L-CON Collar V3 was written in OpenCollar 6.5. The OC and custom BG code codebase comes to about 2.5 MB. The collar is slow, laggy, complicated, and difficult to maintain and debug. We do not wish to maintain that software and we do not wish to publish our software under the Gnu software license. 

Thus Black Gazza L-CON Collar V4. The intent is to keep it fast, simple, and maintainable while providing an immersive, captivating experience of loss of autonomy. With this release we have achieved a milestone: The codebase has grown to one tenth the size of the V3 code. We hope your stay at Black Gazza lasts as long as you deserve. 

Full Instructions
==========
https://library.panocul.us/mw/index.php/Second_Life_Black_Gazza_Collar#Instructions



New in this Version 
=============
New in This Version (Development)
• when you select a menu item in brackets, the collar makes a burp sound
• display character set has brackets
• RLV menus have added blank buttons for better gouping of functions
• Commands to change relay mode show up in alphanumeric display
• Settings Punishments allows you to turn off zaps by objects
• Where possible, added Settings, Main, Close commands to menus.
• Threat levels that can be set depend on the prisoner class. The order of increasing danger is
    white, pink, red, green, orange, blue, black.


New in this Version (2023-03-30)
• Collar allows a Guard to setthe crime listed for the active asset number. To set a crime:
Inmate: Settings: Set mood to OOC. Choose the character. Set mood to IC.
Guard: Settings: Set Crime.
• Script Display-stocks has been updated for the Black Gazza Stocks. If you have BG Stocks, get the box with the update scripts. Replace all the scripts with the ones in the box.
Script Display-stocks refers to links by name. IF the names of objects in your collar or stocks are not correct, the script will not work right.
// PilotLight
// blinky1
// blinky2
// blinky3
// blinky4
// DisplayFrame
// powerDisplay
// hardware
// powerHoseNozzle
// leashpoint right
// leashpoint left
// leashpoint out left
// padlock1
// padlock2
// padlock3
Not having these named properly will not break the collar. It will just not look quite right. Timberwoof Lupindo will provide detailed instructions on how to verify that the names are correct.
• Script Display refers to links by name. IF the names of objects in your collar or stocks are not correct, the script will not work right.
// Titler
// BG_CollarV4_LightsMesh
// powerDisplay
// powerHoseNozzle
// leashPoint
It is not likely that your collr doesn't have these link names.
• Support for Lockmeister cuffs. Please test and report bugs.
• Authoriation is based on actual group membership, not just not-Inmate-group membership. This means that Guards must have their Black Gazza Guards group active to inflict guard functions on you.
• Zap level preferences are corrected.
• New animation sequence for Zap. You will need some animations for your Stocks. These are included in the Stocks update box.

New in this version (2023-03-08)
The menu script has been split into three, making it less likely to crap out from a stack-heap collision. 
The Number pad script has been cleaned up to eliminate the "too many listens" error. 

New in this version (2021-12-29)
Collar V4 supports selecting multiple characters. When you attach the collar it will give you a dialog to ask you what character you want to use. Click that inmate's asset number. You can also change it by selecting Settings - Character. 

New in this version (2021-12-23)
The menu previously named "Lock" is now named "RLV." 
Dominatech Relay is included. In RLV modes Off, Light, Medium, it is optionally on in "Ask" mode. If some cruel furniture wants to lock you, the relay will ask permission. In RLV modes Heavy and Hardcore, it is in "On" mode. You are at the mercy of cruel furniture. 

New in this version (2020-11-23)
Corrected issues with guard/inmate permissions in ic/ooc modes.
Fixed some spelling issues. 
Simplified the Lock menu help text.
Removed more speech filter code. The collar is not a gag. 
Fixed a bug where the collar would stop all animations instead of just the Zap animation. 
Code size is up to 190kB. I don't foresee us ever meeting the 2.4MB mark set by Collar V3. 

New in this version (2020-11-15)
Embiggened a small prim that prevented resizing. 
Fixed a bug where new inmate's data display was horked. 
Revised the menus. Ordering is different. Look under Settings! 
Fixed renamer's behavior for emotes. 
Fixed bug with no crime set for new inmates. 
Fixed bug where a change in RLV lock level would kill the renamer. 
Renamer is now independent of lock level. 
The collar is not a gag. 

New in This Version (2020-08-08)
Revised collar name set on restart - should eliminate renamer problems
Removed Gag, Hack, Maintenance menu items as they are experimental.
Removed Vision restriction punishments as they are experimental.
Removed Timer menu as it is experimental.
Added Lock menu item to Speech Menu.
Removed IC restrictions on some menu items. 
Added "Lockup" Mood. 

Credits
=====
The collar mesh was designed for Black Gazza by Dein Newt. 

The display font is Advanced Pixel LCD-7 
https://www.dafont.com/advanced-pixel-lcd-7.font

The Dominatech RLV Relay Script 2.0  is Copyright © 2009 Julia Banshee and distributed under the GNU General Public License version 3. 

The remainder of the software is entirely new by Timberwoof Lupindo with some parts by Lormyr Daviau. 

For history and in-depth information about the V4 collar software project, please read https://library.panocul.us/mw/index.php/Second_Life_Black_Gazza_Collar#Introduction

Timberwoof Lupindo
2023-03-08
