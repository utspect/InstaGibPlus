// ===============================================================
// UTPureRC6B.PureSuperDuperConsole: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class PureSuperDuperConsole extends UTConsole;

event PreRender( canvas zzCanvas); //never used.
event PostRender( canvas zzC );

event bool KeyType( EInputKey Key );
event bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta );

event Tick( float Delta );

function ShowConsole();
function HideConsole();

function DrawConsoleView( Canvas C );
function DrawSingleView( Canvas C );

exec function TimeDemo(bool bEnabled, optional bool bSaveToFile);
function TimeDemoRender( Canvas C );
function StartTimeDemo();
function StopTimeDemo();
function PrintTimeDemoResult();
function TimeDemoCalc();

function LaunchUWindow();
function CloseUWindow();

function RenderUWindow( canvas Canvas );

exec function MenuCmd(int Menu, int Item);
exec function ShowObjectives();

function DrawLevelAction( canvas C );
function PrintActionMessage( Canvas C, string BigMessage );

function CreateMessage();
function ShowMessage();
function HideMessage();

defaultproperties
{
}
