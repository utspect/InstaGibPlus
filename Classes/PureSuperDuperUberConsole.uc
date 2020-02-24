//=============================================================================
// CSHPSuperDuperUberConsole
//
// This is our custom console class.  It allows us to control the VR and the 
// easiest route to drawing on the canvas.
//
// (c) 2001, Midnight Interactive
//=============================================================================

// TNSe
// 5b2:
// Added: some checks for accessed none...
// 5c:
// Added: 3 execs (ShowIPs, ShowNetSpeeds, ShowTickrate)
// 5T:
// Added: ConsoleCommand is only allowed during zzbCanCSL ... Temp disabled.
// Added: MessageWindow.HideWindow() in UWindowRender to avoid EzRadar.
// 5w:
// Added: Replaced the code MessageWindow.HideWindow() with the actual code behind it.

// 6B:
// Changed: added PureSuperDuperConsole to remove Tick() ;)

// 7D:
// Added: functionality to check for Canvas Activity between PostRender & PreRender.

// UsAaR33
// Added: bbPlayer.zzbCanCSL in PostRender() to avoid CSL/CSR haxx0ring
// 5e:	
// Fixed: A possible accessed None in xxRevert()

class PureSuperDuperUberConsole extends PureSuperDuperConsole;

var UTConsole zzOldConsole;
var int zzMyState; // 0=global state 1=UWINDOW 2=Typing
var bool bForcedStats;
var string Ello;

event PreRender( canvas zzC);

event PostRender( canvas zzC )
{
	local int YStart, YEnd;
	local bbPlayer zzbb;

	//Log("Console.PostRender");
	
	if (zzMyState==1)
		xxWindowPostRender(zzC);
	else
	{
		if(bNoDrawWorld)
		{
			zzC.SetPos(0,0);
			zzC.DrawPattern( Texture'Border', zzC.ClipX, zzC.ClipY, 1.0 );
		}

		if( bTimeDemo )
		{
			TimeDemoCalc();
			TimeDemoRender( zzC );
		}

		// call overridable "level action" rendering code to draw the "big message"
		DrawLevelAction( zzC );

		// If the console has changed since the previous frame, draw it.
		if ( ConsoleLines > 0 )
		{
			zzC.SetOrigin(0.0, ConsoleLines - FrameY*0.6);
			zzC.SetPos(0.0, 0.0);
			zzC.DrawTile( ConBackground, FrameX, FrameY*0.6, zzC.CurX, zzC.CurY, FrameX, FrameY );
		}

		// Draw border.
		if ( BorderLines > 0 || BorderPixels > 0 )
		{
			YStart	 = BorderLines + ConsoleLines;
			YEnd	 = FrameY - BorderLines;
			if ( BorderLines > 0 )
			{
				zzC.SetOrigin(0.0, 0.0);
				zzC.SetPos(0.0, 0.0);
				zzC.DrawPattern( Border, FrameX, BorderLines, 1.0 );
				zzC.SetPos(0.0, YEnd);
				zzC.DrawPattern( Border, FrameX, BorderLines, 1.0 );
			}
			if ( BorderPixels > 0 )
			{
				zzC.SetOrigin(0.0, 0.0);
				zzC.SetPos(0.0, YStart);
				zzC.DrawPattern( Border, BorderPixels, YEnd - YStart, 1.0 );
				zzC.SetPos( FrameX - BorderPixels, YStart );
				zzC.DrawPattern( Border, BorderPixels, YEnd - YStart, 1.0 );
			}
		}

		// Draw console text.
		zzC.SetOrigin(0.0, 0.0);
		if ( ConsoleLines > 0 )
			DrawConsoleView( zzC );
		else
			DrawSingleView( zzC );

		//global:

		//UT CONSOLE:
//		if(bShowSpeech || bShowMessage)
//			RenderUWindow(zzC);
                        
	}

	zzbb = bbPlayer(ViewPort.Actor);
	if (zzbb != None)
	{
		zzbb.zzbCanCSL = zzbb.zzTrue; //allow csl.
		zzbb.zzbConsoleInvalid = zzbb.zzFalse;
		zzbb.zzCannibal = zzC;
		zzbb.zzCanOldFont = zzC.Font;
		zzbb.zzCanOldStyle = zzC.Style;
	}
}

final function xxWindowPostRender(canvas zzCanvas)
{ //UWindow.postrender

//	Log("Console.WindowPostRender");
	if( bTimeDemo )
	{	
		TimeDemoCalc();
		TimeDemoRender( zzCanvas );
	}

	if(Root != None)
		Root.bUWindowActive = True;

	RenderUWindow( zzCanvas );
}

event bool KeyType( EInputKey Key )
{
	if (zzMyState==0)
		return false;

	if (zzMyState==1)
	{
		if (root==none)
			return false;

		Root.WindowEvent(WM_KeyType, None, MouseX, MouseY, Key);
		return True;
	}
	
	if ( bNoStuff )
	{
		bNoStuff = false;
		return true;
	}
	
	if( Key>=0x20 && Key<0x100 && Key!=Asc("~") && Key!=Asc("`") )
	{
		TypedStr = TypedStr $ Chr(Key);
		Scrollback=0;
		return true;
	}

}

//unlinker:
event NotifyLevelChange()
{
	// Unhook ourselves
	xxRevert();
//	Log("UTPure Console UnHooked"); //@@removeline
	zzOldConsole.NotifyLevelChange();		 //call notify on old console.
}

event bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
{
//	local bool zzretval;
	// If any KeyEvent is received, adopt bShowMenu tracking of Execs
	return xxKeyEvent(Key, Action, Delta);
}

final function bool xxKeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
{
	local byte zzk;
	local bbPlayer zzbbP;

	zzbbP = bbPlayer(ViewPort.Actor);
	// Stop FireBots (TraceBots)
	if (zzbbP != None && zzbbP.zzbCanCSL)
	{	
		zzbbP.zzbStoppingTraceBot = zzbbP.zzTrue;
		zzbbP.xxStopTracebot();
	}
	
	if (zzMyState!=0)
	{
		if (zzMyState==1&&Key!=IK_F9) //exception for screenshot.
			return xxWinKeyEvent(Key,Action,Delta);
		if (zzMyState==2&&Key==IK_Escape)
			return xxTypingKeyEvent(Key,Action,Delta);
	}

	//UT console:
	if( Action!=IST_Press )
		return false;
	
	if( Key==SpeechKey )
	{
		if ( !bShowSpeech && !bTyping )
		{
			ShowSpeech();
			bQuickKeyEnable = True;
			LaunchUWindow();
		}
		return true;
	}

	//wiped one as it is for ladder
	//from Window Console:
	zzk = Key;
	switch(Action)
	{
	case IST_Press:
		switch(zzk)
		{
			case EInputKey.IK_Escape:
				if (bLocked)
					return true;

				bQuickKeyEnable = False;
				LaunchUWindow();
				return true;
                                
			case ConsoleKey:
				if (bLocked)
					return true;

				bQuickKeyEnable = True;
				LaunchUWindow();
				if(!bShowConsole)
					ShowConsole();
				return true;
		}
		break;
	}
	if (zzMyState==2) //emulates global key event.
		return xxTypingKeyEvent(Key,Action,Delta);

	return False; 
}

final function bool xxWinKeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
{
	 local byte zzk;
//UTconsole:
	if(Action==IST_Release && Key==SpeechKey)
	{
		if (bShowSpeech)
			HideSpeech();
		return True;
	}
	
	if ( bShowSpeech && (SpeechWindow != None) )
	{
			
		//forward input to speech window
		if ( SpeechWindow.KeyEvent(Key, Action, Delta) )
			return true;
	}
//WINDOWCONSOLE:
	zzk = Key;

	switch (Action)
	{
	case IST_Release:
		switch (zzk)
		{
			case EInputKey.IK_LeftMouse:
				if(Root != None) 
					Root.WindowEvent(WM_LMouseUp, None, MouseX, MouseY, zzk);
				break;
			case EInputKey.IK_RightMouse:
				if(Root != None)
					Root.WindowEvent(WM_RMouseUp, None, MouseX, MouseY, zzk);
				break;
			case EInputKey.IK_MiddleMouse:
				if(Root != None)
					Root.WindowEvent(WM_MMouseUp, None, MouseX, MouseY, zzk);
				break;
			default:
				if(Root != None)
					Root.WindowEvent(WM_KeyUp, None, MouseX, MouseY, zzk);
				break;
		}
		break;

	case IST_Press:
		switch (zzk)
		{
			case ConsoleKey:
				if (bShowConsole)
				{
					HideConsole();
					if(bQuickKeyEnable)
						CloseUWindow();
				}
				else
				{
					if(Root.bAllowConsole)
						ShowConsole();
					else
						Root.WindowEvent(WM_KeyDown, None, MouseX, MouseY, zzk);
				}
				break;
                                
			case EInputKey.IK_Escape:
				if(Root != None)
					Root.CloseActiveWindow();
				break;
			case EInputKey.IK_LeftMouse:
				if(Root != None)
					Root.WindowEvent(WM_LMouseDown, None, MouseX, MouseY, zzk);
				break;
			case EInputKey.IK_RightMouse:
				if(Root != None)
					Root.WindowEvent(WM_RMouseDown, None, MouseX, MouseY, zzk);
				break;
			case EInputKey.IK_MiddleMouse:
				if(Root != None)
					Root.WindowEvent(WM_MMouseDown, None, MouseX, MouseY, zzk);
				break;
			default:
				if(Root != None)
					Root.WindowEvent(WM_KeyDown, None, MouseX, MouseY, zzk);
				break;
		}
		break;
	case IST_Axis:
		switch (Key)
		{
			case IK_MouseX:
				MouseX = MouseX + (MouseScale * Delta);
				break;
			case IK_MouseY:
				MouseY = MouseY - (MouseScale * Delta);
				break;					
		}
	default:
		break;
	}
	return true;
}

//typing state: (engine.console)
final function bool xxTypingKeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
{
	local string Temp;
	bNoStuff = false;
	if( Key==IK_Escape )
	{
		if( Scrollback!=0 )
		{
			Scrollback=0;
		}
		else if( TypedStr!="" )
		{
			TypedStr="";
		}
		else
		{
			ConsoleDest=0.0;
			bTyping = false;
			Viewport.Actor.Typing(bTyping);
			zzMyState=0;
		}
		Scrollback=0;
	}
	else if( Key==IK_Enter )
	{
		if( Scrollback!=0 )
		{
			Scrollback=0;
		}
		else
		{
			if( TypedStr!="" )
			{
				// Print to console.
				if( ConsoleLines!=0 )
					Message( None, "(>" @ TypedStr, 'Console' );
					// Update history buffer.
				History[HistoryCur++ % MaxHistory] = TypedStr;
				if( HistoryCur > HistoryBot )
					HistoryBot++;
				if( HistoryCur - HistoryTop >= MaxHistory )
					HistoryTop = HistoryCur - MaxHistory + 1;

				// Make a local copy of the string.
				Temp=TypedStr;
				TypedStr="";
				if( !ConsoleCommand( Temp ) )
					Message( None, Localize("Errors","Exec","Core"), 'Console' );

				Message( None, "", 'Console' );
			}
			if( ConsoleDest==0.0 )
			{
				zzMyState=0;
				bTyping = false;
				Viewport.Actor.Typing(false);
			}
	//log("Console leaving Typing");

			Scrollback=0;
		}
	}
	else if( Key==IK_Up )
	{
		if( HistoryCur > HistoryTop )
		{
			History[HistoryCur % MaxHistory] = TypedStr;
			TypedStr = History[--HistoryCur % MaxHistory];
		}
		Scrollback=0;
	}
	else if( Key==IK_Down )
	{
		History[HistoryCur % MaxHistory] = TypedStr;
		if( HistoryCur < HistoryBot )
			TypedStr = History[++HistoryCur % MaxHistory];
		else
			TypedStr="";
		Scrollback=0;
	}
	else if( Key==IK_PageUp )
	{
		if( ++Scrollback >= MaxLines )
			Scrollback = MaxLines-1;
	}
	else if( Key==IK_PageDown )
	{
		if( --Scrollback < 0 )
			Scrollback = 0;
	}
	else if( Key==IK_Backspace || Key==IK_Left )
	{
		if( Len(TypedStr)>0 )
			TypedStr = Left(TypedStr,Len(TypedStr)-1);
		Scrollback = 0;
	}
	return true;
}
/*
function bool ConsoleCommand( coerce string S )
{
	Log("ConsoleCommand"@S@bbPlayer(ViewPort.Actor).zzbCanCSL);
	return bbPlayer(ViewPort.Actor).zzbCanCSL && Super.ConsoleCommand(S);
}
*/

// Called each rendering iteration to update any time-based display.
event Tick( float Delta )
{
//	Log("Console.Tick");
//	local rotator zzVR;
	
	// Tick is

	//Console (probably not needed though):
	MsgTickTime += Delta;

	// Slide console up or down.
	if( ConsolePos < ConsoleDest )
		ConsolePos = FMin(ConsolePos+Delta,ConsoleDest);
	else if( ConsolePos > ConsoleDest )
		ConsolePos = FMax(ConsolePos-Delta,ConsoleDest);

	// Update status message.
	if( ((MsgTime-=Delta) <= 0.0) && (TextLines > 0) )
		TextLines--;

	//WindowConsole:
	if(bLevelChange && Root != None && string(Viewport.Actor.Level) != OldLevel)
	{
		OldLevel = string(Viewport.Actor.Level);
		// if this is Entry, we could be falling through to another level...
		if(Viewport.Actor.Level != Viewport.Actor.GetEntryLevel())
			bLevelChange = False;
		Root.NotifyAfterLevelChange();
	}

	//UTconsole:
	if ( Root != None && (bShowMessage ||zzMyState==1))
	{
		Root.DoTick( Delta );	 //an aimbot may potentially exist here.
	}
	//UTconsole.Uwindow:
	if (zzMyState==0&&root!=none&&viewport.actor.Song == None)
		if ( FRand() < 0.5 )
			viewport.actor.ClientSetMusic( Music(DynamicLoadObject("Skyward.Skyward", class'Music')), 0, 0, MTRAN_Fade );
		else if ( FRand() < 0.5 )
			viewport.actor.ClientSetMusic( Music(DynamicLoadObject("Foregone.Foregone", class'Music')), 0, 0, MTRAN_Fade );
		else if ( FRand() < 0.5 )
			viewport.actor.ClientSetMusic( Music(DynamicLoadObject("Nether.Nether", class'Music')), 0, 0, MTRAN_Fade );
		else if ( FRand() < 0.5 )
			viewport.actor.ClientSetMusic( Music(DynamicLoadObject("Course.Course", class'Music')), 0, 0, MTRAN_Fade );
		else
			viewport.actor.ClientSetMusic( Music(DynamicLoadObject("Mech8.Mech8", class'Music')), 0, 0, MTRAN_Fade );
}

final function xxGetValues() //initial only
{
	local int i;
	local UWindowList zzList;

	ConsoleWindow = zzOldConsole.ConsoleWindow;
	ViewPort = zzOldConsole.ViewPort;

	if (zzOldConsole.Root != None)
	{
		Root = zzOldConsole.Root;
		Root.Console = Self;
	}
	else
	{
		Root = None;
	}

	SpeechWindow = zzOldConsole.SpeechWindow;
	MessageWindow = zzOldConsole.MessageWindow;
	bTyping = zzOldConsole.bTyping;
	TypedStr = zzOldConsole.TypedStr;
	bShowSpeech = zzOldConsole.bShowSpeech;
	bCreatedRoot = zzOldConsole.bCreatedRoot;
	bshowconsole = zzOldConsole.bshowconsole;
	MouseX= zzOldConsole.MouseX;
	MouseY= zzOldConsole.MouseY;
	bUWindowType= zzOldConsole.bUWindowType;
	bUWindowActive=zzOldConsole.bUWindowActive;
	bLocked=zzOldConsole.bLocked;
	bQuickKeyEnable=zzOldConsole.bQuickKeyEnable;
	showdesktop=zzOldConsole.showdesktop;
	// added by DB
	bTimeDemo=zzOldConsole.bTimeDemo;
	bSaveTimeDemoToFile=zzOldConsole.bSaveTimeDemoToFile;
	// copy history
	HistoryCur = zzOldConsole.HistoryCur;
	HistoryTop = zzOldConsole.HistoryTop;
	//added by UsA: this may be needed?
	bLevelChange=zzOldConsole.bLevelChange;
	OldLevel=zzOldConsole.OldLevel;
	RootWindow=zzOldConsole.RootWindow;
	for (i = 0; i<MaxHistory; i++)
	    History[i] = zzOldConsole.History[i];
	
	if (ConsoleWindow != None)
		ConsoleWindow.WindowTitle = class'UTPure'.Default.ConsoleName;

	//states:
	switch (zzOldConsole.getstatename())
	{
		case 'UWindow':
			zzMyState=1;
			break;
		
		case 'Typing':
			zzMyState=2;
			break;
		
		default:
			zzMyState=0;
	}

	if (Root != None)	// Will not work properly if they joined directly without creatign the menu...
	{
		for (zzList = UMenuRootWindow(Root).MenuBar.ModItems; zzList != None; zzList = zzList.Next)
		{
			if (UMenuModMenuList(zzList) != None && bbPlayer(ViewPort.Actor) != None)
				bbPlayer(ViewPort.Actor).xxServerReceiveMenuItems(UMenuModMenuList(zzList).MenuItemClassName,zzList.Next == None);
		}
	}
}

final function xxRevert()
{
local int i;
	//return to old console.
	zzOldConsole.ConsoleWindow = ConsoleWindow;
	if (Root != None)
	{
		zzOldConsole.Root = Root;
		zzOldConsole.Root.Console = zzOldConsole;
	}
	else
	{
		zzOldConsole.Root = None;
	}

	zzOldConsole.SpeechWindow = SpeechWindow;
	zzOldConsole.MessageWindow = MessageWindow;
	zzOldConsole.bTyping = bTyping;
	zzOldConsole.TypedStr = TypedStr;
	zzOldConsole.bShowSpeech = bShowSpeech;
	zzOldConsole.bCreatedRoot = bCreatedRoot;
	zzOldConsole.bshowconsole = bshowconsole;
	zzOldConsole.MouseX= MouseX;
	zzOldConsole.MouseY= MouseY;
	zzOldConsole.bUWindowType= bUWindowType;
	zzOldConsole.bUWindowActive=bUWindowActive;
	zzOldConsole.bLocked=bLocked;
	zzOldConsole.bQuickKeyEnable=bQuickKeyEnable;
	zzOldConsole.showdesktop=showdesktop;
	// added by db
	zzOldConsole.bTimeDemo=bTimeDemo;
	zzOldConsole.bSaveTimeDemoToFile=bSaveTimeDemoToFile;
	// copy history
	zzOldConsole.HistoryCur = HistoryCur;
	zzOldConsole.HistoryTop = HistoryTop;
	if (ConsoleWindow != None)
	  	ConsoleWindow.WindowTitle=ConsoleWindow.default.WindowTitle; //UsA: use old title.
	
	if (zzOldConsole != None)
		for (i = 0; i<MaxHistory; i++)
			zzOldConsole.History[i] = History[i];

	//states:

	switch (zzMyState)
	{
		case 1:
			zzOldConsole.gotostate('UWindow');
			break;
		
		case 2:
			zzOldConsole.gotostate('Typing');
			break;
		
		default:
			zzOldConsole.gotostate('');
	}
	
        viewport.console=zzOldConsole; //set console back.
}
//state checks:

// Begin typing a command on the console.
exec function Type()
{
	if (zzMyState==2)
	{
		zzMyState=0;
		bTyping = false;
		Viewport.Actor.Typing(bTyping);
		ConsoleDest=0.0;
		return;
	}
	DoTalk("");
}
 
exec function Talk()			{ DoTalk("Say "); }
exec function TeamTalk()		{ DoTalk("TeamSay "); }
exec function MutateTalk()		{ DoTalk("Mutate "); }
exec function AdminTalk()		{ DoTalk("Admin "); }

final function DoTalk(string str)
{
	TypedStr=str;
	bNoStuff = true;
	zzMyState=2;
	bTyping = true;
	Viewport.Actor.Typing(bTyping);
}
	
// Don't work right anyway with Uwindows:
exec function ViewUp();
exec function ViewDown();

//more overloads:
function ShowConsole()
{
	bShowConsole = true;
	if(bCreatedRoot)
		ConsoleWindow.ShowWindow();
}

function HideConsole()
{
	ConsoleLines = 0;
	bShowConsole = false;
	if (ConsoleWindow != None)
		ConsoleWindow.HideWindow();
}
//view overloads:
function DrawConsoleView( Canvas C )
{
	local int Y, I, Line;
	local float XL, YL;

	// Console is visible; display console view.
	Y = ConsoleLines - 1;
	MsgText[(TopLine + 1 + MaxLines) % MaxLines] = "(>"@TypedStr;
	for ( I = Scrollback; I < (NumLines + 1); I++ )
	{
		// Display all text in the buffer.
		Line = (TopLine + MaxLines*2 - (I-1)) % MaxLines;
		
		C.Font = C.MedFont;

		if (( MsgType[Line] == 'Say' ) || ( MsgType[Line] == 'TeamSay' ))
			C.StrLen( MsgPlayer[Line].PlayerName$":"@MsgText[Line], XL, YL );				
		else
			C.StrLen( MsgText[Line], XL, YL );
		
		// Half-space blank lines.
		if ( YL == 0 )
			YL = 5;
			
		Y -= YL;
		if ( (Y + YL) < 0 )
			break;
		C.SetPos(4, Y);
		C.Font = C.MedFont;

		if (( MsgType[Line] == 'Say' ) || ( MsgType[Line] == 'TeamSay' ))
			C.DrawText( MsgPlayer[Line].PlayerName$":"@MsgText[Line], false );
		else
			C.DrawText( MsgText[Line], false );
	}				
}

function DrawSingleView( Canvas C )
{
	local string TypingPrompt;
	local int I, J;
	local float XL, YL;
	local string ShortMessages[4];
	local int ExtraSpace;

	// Console is hidden; display single-line view.

	C.SetOrigin(0.0, 0.0);

	// Ask the HUD to deal with messages.
	if ( Viewport.Actor.myHUD != None 
		&& Viewport.Actor.myHUD.DisplayMessages(C) )
		return;

	// If the HUD doesn't deal with messages, use the default behavior
	if (!Viewport.Actor.bShowMenu)
	{
		if ( bTyping )
		{
			TypingPrompt = "(>"@TypedStr$"_";
			C.Font = C.MedFont;
			C.StrLen( TypingPrompt, XL, YL );
			C.SetPos( 2, FrameY - ConsoleLines - YL - 1 );
			C.DrawText( TypingPrompt, false );
		}
	}
		
	if ( TextLines > 0 && (!Viewport.Actor.bShowMenu || Viewport.Actor.bShowScores) )
	{
		J = TopLine;
		I = 0;
		while ((I < 4) && (J >= 0))
		{
			if ((MsgText[J] != "") && (MsgTick[J] > 0.0) && (MsgTick[J] > MsgTickTime) )
			{
				if (MsgType[J] == 'Say') 
					ShortMessages[I] = MsgPlayer[J]$":"@MsgText[J];
				else
					ShortMessages[I] = MsgText[J];
				I++;
			}
			J--;
		}

		J = 0;
		C.Font = C.MedFont;
		for ( I = 0; I < 4; I++ )
		{
			if (ShortMessages[3 - I] != "")
			{
				C.SetPos(4, 2 + (10 * J) + (10 * ExtraSpace));
				C.StrLen( ShortMessages[3 - I], XL, YL );
				C.DrawText( ShortMessages[3 - I], false );
				if ( YL == 18.0 )
					ExtraSpace++;
				J++;
			}
		}		
	}
}

//TD overloads (prevent a superclass console bot from abusing):
exec function TimeDemo(bool bEnabled, optional bool bSaveToFile)
{
	bSaveTimeDemoToFile = bSaveToFile;
	if(bEnabled)
		StartTimeDemo();
	else
		StopTimeDemo();
}

function TimeDemoRender( Canvas C )
{
	local string AText, LText;
	local float W, H;
	if(	TimeDemoFont == None )
		TimeDemoFont = class'FontInfo'.Static.GetStaticSmallFont(C.ClipX);
	
         C.Font = TimeDemoFont;
	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;

	AText = AvgText @ FormatFloat(FrameCount / (Viewport.Actor.GetEntryLevel().TimeSeconds - StartTime - ExtraTime));
	LText = LastSecText @ FormatFloat(LastSecFPS);

	C.TextSize(AText, W, H);
	C.SetPos(C.ClipX - W, 0.3*C.ClipY);
	C.DrawText(AText);
	C.TextSize(LText, W, H);
	C.SetPos(C.ClipX - W, 0.3*C.ClipY+H);
	C.DrawText(LText);
}

function StartTimeDemo()
{
	TimeDemoFont = None;
	if(bTimeDemo)
		return;
	bTimeDemo = True;
	bStartTimeDemo = True;
}

function StopTimeDemo()
{
	if(!bTimeDemo)
		return;
	bTimeDemo = False;
	PrintTimeDemoResult();
}

function PrintTimeDemoResult()
{
	local LevelInfo Entry;
	local float Avg;
	local float Delta;
	local string AvgString;
	local string Temp;

	Entry = Viewport.Actor.GetEntryLevel();

	Delta = Entry.TimeSeconds - StartTime - ExtraTime;
	if(Delta <= 0)
		Avg = 0;
	else
		Avg = FrameCount / Delta;
	
	AvgString = string(FrameCount)@FramesText@FormatFloat(delta)@SecondsText@MinText@FormatFloat(MinFPS)@MaxText@FormatFloat(MaxFPS)@AvgText@FormatFloat(Avg)@fpsText$".";
	Viewport.Actor.ClientMessage(AvgString);
	Log(AvgString);
	if(bSaveTimeDemoToFile)
	{		
		Temp =
			FormatFloat(Avg) $ " Unreal "$ Viewport.Actor.Level.EngineVersion $ Chr(13) $ Chr(10) $
			FormatFloat(MinFPS) $ " Min"$ Chr(13) $ Chr(10) $
			FormatFloat(MaxFPS) $ " Max"$ Chr(13) $ Chr(10);
			
		SaveTimeDemo(Temp);
	}
}

function TimeDemoCalc()
{
	local LevelInfo Entry;
	local float Delta;
	Entry = Viewport.Actor.GetEntryLevel();

	if( bRestartTimeDemo )
	{
		StopTimeDemo();
		StartTimeDemo();
		bRestartTimeDemo = False;
	}

	if(	bStartTimeDemo )
	{
		bStartTimeDemo = False;
		StartTime = Entry.TimeSeconds;
		ExtraTime =	0;
		LastFrameTime = StartTime;
		LastSecondStartTime = StartTime;
		FrameCount = 0;
		LastSecondFrameCount = 0;
		MinFPS = 0;
		MaxFPS = 0;		
		LastSecFPS = 0;
		return;
	}

	Delta = Entry.TimeSeconds - LastFrameTime;

	// If delta time is more than a half of a second, ignore frame entirely (precaching, loading etc)
	if( Delta > 0.5 )
	{
		ExtraTime += Delta;
		LastSecondStartTime = Entry.TimeSeconds;
		LastSecondFrameCount = 0;
		LastFrameTime = Entry.TimeSeconds;
		return;
	}

	FrameCount++;
	LastSecondFrameCount++;

	if( Entry.TimeSeconds - LastSecondStartTime > 1)
	{
		LastSecFPS = LastSecondFrameCount / (Entry.TimeSeconds - LastSecondStartTime);
		if( MinFPS == 0 || LastSecFPS < MinFPS )
			MinFPS = LastSecFPS;
		if( LastSecFPS > MaxFPS )
			MaxFPS = LastSecFPS;
		LastSecondFrameCount = 0;
		LastSecondStartTime = Entry.TimeSeconds;
	}

	LastFrameTime = Entry.TimeSeconds;
}

//window state holders:
function LaunchUWindow()
{
	Viewport.bSuspendPrecaching = True;
	bUWindowActive = !bQuickKeyEnable;
	Viewport.bShowWindowsMouse = True;

	if(bQuickKeyEnable)
		bNoDrawWorld = False;
	else
	{
		if(Viewport.Actor.Level.NetMode == NM_Standalone)
			Viewport.Actor.SetPause( True );
		bNoDrawWorld = ShowDesktop;
	}
	if(Root != None)
		Root.bWindowVisible = True;
	if (zzMyState==2){ //check typing!
		bTyping = false;
		Viewport.Actor.Typing(bTyping);
	}
	zzMyState=1;
}
function CloseUWindow()
{
	if(!bQuickKeyEnable)
		Viewport.Actor.SetPause( False );

	bNoDrawWorld = False;
	bQuickKeyEnable = False;
	bUWindowActive = False;
	Viewport.bShowWindowsMouse = False;

	if(Root != None)
		Root.bWindowVisible = False;
	zzMyState=0;
	Viewport.bSuspendPrecaching = False;
}


function RenderUWindow( canvas zzCanvas )
{
	local UWindowWindow NewFocusWindow;
	zzCanvas.bNoSmooth = True;
	zzCanvas.Z = 1;
	zzCanvas.Style = 1;
	zzCanvas.DrawColor.r = 255;
	zzCanvas.DrawColor.g = 255;
	zzCanvas.DrawColor.b = 255;

	if(Viewport.bWindowsMouseAvailable && Root != None)
	{
		MouseX = Viewport.WindowsMouseX/Root.GUIScale;
		MouseY = Viewport.WindowsMouseY/Root.GUIScale;
	}

	if(!bCreatedRoot) 
		CreateRootWindow(zzCanvas);

	Root.bWindowVisible = True;
	Root.bUWindowActive = bUWindowActive;
	Root.bQuickKeyEnable = bQuickKeyEnable;

	if(zzCanvas.ClipX != OldClipX || zzCanvas.ClipY != OldClipY)
	{
		OldClipX = zzCanvas.ClipX;
		OldClipY = zzCanvas.ClipY;
		
		Root.WinTop = 0;
		Root.WinLeft = 0;
		Root.WinWidth = zzCanvas.ClipX / Root.GUIScale;
		Root.WinHeight = zzCanvas.ClipY / Root.GUIScale;

		Root.RealWidth = zzCanvas.ClipX;
		Root.RealHeight = zzCanvas.ClipY;

		Root.ClippingRegion.X = 0;
		Root.ClippingRegion.Y = 0;
		Root.ClippingRegion.W = Root.WinWidth;
		Root.ClippingRegion.H = Root.WinHeight;

		Root.Resized();
	}

	if(MouseX > Root.WinWidth) MouseX = Root.WinWidth;
	if(MouseY > Root.WinHeight) MouseY = Root.WinHeight;
	if(MouseX < 0) MouseX = 0;
	if(MouseY < 0) MouseY = 0;


	// Check for keyboard focus
	NewFocusWindow = Root.CheckKeyFocusWindow();

	if(NewFocusWindow != Root.KeyFocusWindow)
	{
		Root.KeyFocusWindow.KeyFocusExit();		
		Root.KeyFocusWindow = NewFocusWindow;
		Root.KeyFocusWindow.KeyFocusEnter();
	}


	Root.MoveMouse(MouseX, MouseY);
//	MessageWindow.WindowHidden();
//	MessageWindow.ParentWindow.HideChildWindow(MessageWindow);
//	MessageWindow = None; // Stop EzRadar. Dumb DarkByte didn't want this :(
	Root.WindowEvent(WM_Paint, zzCanvas, MouseX, MouseY, 0);
	if(bUWindowActive || bQuickKeyEnable) 
		Root.DrawMouse(zzCanvas);
}

event Message( PlayerReplicationInfo PRI, coerce string Msg, name N )
{
	local string OutText;
	if( Msg!="" )
	{
		TopLine				 = (TopLine+1) % MaxLines;
		NumLines			 = Min(NumLines+1,MaxLines-1);
		MsgType[TopLine] = N;
		MsgTime				 = 6.0;
		TextLines++;
		MsgText[TopLine] = Msg;
		MsgPlayer[TopLine] = PRI;
		MsgTick[TopLine] = MsgTickTime + MsgTime;
	}

	if ( Viewport.Actor == None )
		return;

	if( Msg!="" )
	{
		if (( MsgType[TopLine] == 'Say' ) || ( MsgType[TopLine] == 'TeamSay' ))
			OutText = MsgPlayer[TopLine].PlayerName$": "$MsgText[TopLine];
		else
			OutText = MsgText[TopLine];
		if (ConsoleWindow != None)
			UWindowConsoleClientWindow(ConsoleWindow.ClientArea).TextArea.AddText(OutText);
	}
}

event AddString( coerce string Msg )
{
	if( Msg!="" )
	{
		TopLine				 = (TopLine+1) % MaxLines;
		NumLines			 = Min(NumLines+1,MaxLines-1);
		MsgType[TopLine] = 'Event';
		MsgTime				 = 6.0;
		TextLines++;
		MsgText[TopLine] = Msg;
		MsgPlayer[TopLine] = None;
		MsgTick[TopLine] = MsgTickTime + MsgTime;

		if (ConsoleWindow != None)
			UWindowConsoleClientWindow(ConsoleWindow.ClientArea).TextArea.AddText(Msg);
	}
}

function UpdateHistory()
{
	// Update history buffer.
	History[HistoryCur++ % MaxHistory] = TypedStr;
	if( HistoryCur > HistoryBot )
		HistoryBot++;
	if( HistoryCur - HistoryTop >= MaxHistory )
		HistoryTop = HistoryCur - MaxHistory + 1;
}

function HistoryUp()
{
	if( HistoryCur > HistoryTop )
	{
		History[HistoryCur % MaxHistory] = TypedStr;
		TypedStr = History[--HistoryCur % MaxHistory];
	}
}

function HistoryDown()
{
	History[HistoryCur % MaxHistory] = TypedStr;
	if( HistoryCur < HistoryBot )
		TypedStr = History[++HistoryCur % MaxHistory];
	else
		TypedStr="";
}
exec function MenuCmd(int Menu, int Item)
{
	if (bLocked||zzMyState!=0)
		return;
	bQuickKeyEnable = False;
	LaunchUWindow();
	if(!bCreatedRoot) 
		CreateRootWindow(None);
	UMenuRootWindow(Root).MenuBar.MenuCmd(Menu, Item);
}

exec function ShowObjectives()
{
	local GameReplicationInfo GRI;
	local class<GameInfo> AssaultClass, GameClass;

	// Keep testing Locally...
	if(!bCreatedRoot)
		CreateRootWindow(None);
					 //import saving?
	AssaultClass = class<GameInfo>(DynamicLoadObject("Botpack.Assault", class'Class'));
					//I really don't like this.	But I don't want to risk screwing something up:
	foreach viewport.actor.AllActors(class'GameReplicationInfo', GRI)
	{
		GameClass = class<GameInfo>(DynamicLoadObject(GRI.GameClass, class'Class'));
		if ( ClassIsChildOf(GameClass, AssaultClass) )
		{
			bLocked = True;
			bNoDrawWorld = True;
			UMenuRootWindow(Root).MenuBar.HideWindow();
			LaunchUWindow();
			Root.CreateWindow(class<UWindowWindow>(DynamicLoadObject("UTMenu.InGameObjectives", class'Class')), 100, 100, 100, 100);
		}
	}
}
//prevent abuse of this function:

function DrawLevelAction( canvas C )
{
	local string BigMessage;

	if ( (Viewport.Actor.Level.Pauser != "") && (Viewport.Actor.Level.LevelAction == LEVACT_None) )
	{
		C.Font = C.MedFont;
		BigMessage = PausedMessage@"by"@Viewport.Actor.Level.Pauser; // Add pauser name?
		xxPrintActionMessage(C, BigMessage);
		return;
	}
	if ( (Viewport.Actor.Level.LevelAction == LEVACT_None)
		 || Viewport.Actor.bShowMenu )
	{
		BigMessage = "";
		return;
	}
	else if ( Viewport.Actor.Level.LevelAction == LEVACT_Loading )
		BigMessage = LoadingMessage;
	else if ( Viewport.Actor.Level.LevelAction == LEVACT_Saving )
		BigMessage = SavingMessage;
	else if ( Viewport.Actor.Level.LevelAction == LEVACT_Connecting )
		BigMessage = ConnectingMessage;
	else if ( Viewport.Actor.Level.LevelAction == LEVACT_Precaching )
		BigMessage = PrecachingMessage;
	
	if ( BigMessage != "" )
	{
		C.Style = 1;
		C.Font = C.LargeFont;	
		xxPrintActionMessage(C, BigMessage);
	}
}

function xxPrintActionMessage( Canvas C, string BigMessage )
{
	local float XL, YL;
	local class<FontInfo> FC;

	FC = Class<FontInfo>(DynamicLoadObject(class'ChallengeHUD'.default.FontInfoClass, class'Class'));

	if ( Len(BigMessage) > 10 )
		C.Font = FC.Static.GetStaticBigFont(C.ClipX);
	else
		C.Font = FC.Static.GetStaticHugeFont(C.ClipX);
	C.bCenter = false;
	C.StrLen( BigMessage, XL, YL );
	C.SetPos(FrameX/2 - XL/2 + 1, (FrameY/3)*2 - YL/2 + 1);
	C.DrawColor.R = 0;
	C.DrawColor.G = 0;
	C.DrawColor.B = 0; 
	C.DrawText( BigMessage, false );
	C.SetPos(FrameX/2 - XL/2, (FrameY/3)*2 - YL/2);
	C.DrawColor.R = 0;
	C.DrawColor.G = 0;
	C.DrawColor.B = 255; 
	C.DrawText( BigMessage, false );
}

function CreateMessage()
{
//	Log("CreateMessagE()");
	MessageWindow = MessageWindow(Root.CreateWindow(Class'MessageWindow', 100, 100, 200, 200));
	MessageWindow.bLeaveOnScreen = True;
	MessageWindow.HideWindow();
}

function ShowMessage()
{
//	Log("ShowMessage()"@bbPlayer(ViewPort.Actor).zzbCanCSL);
	if (MessageWindow != None)
	{
		bWasShowingMessage = False;
		bShowMessage = True;
		MessageWindow.ShowWindow();
	}
}

function HideMessage()
{
//	Log("HideMessage()"@bbPlayer(ViewPort.Actor).zzbCanCSL);
	if (MessageWindow != None)
	{
		bShowMessage = False;
		MessageWindow.HideWindow();
	}
}

//not-mutate execs. why not?
exec function PureHelp()	{ viewport.actor.mutate("PurePlayerHelp"); }
exec function CheatInfo()	{ viewport.actor.mutate("CheatInfo"); }
exec function CheatTest()	{ viewport.actor.mutate("CheatTest"); }
exec function FixTeams()	{ viewport.actor.mutate("FixTeams");  }
exec function NextTeam()	{ viewport.actor.mutate("NextTeam");  }
exec function ChangeTeam(string newteam) { viewport.actor.mutate("ChangeTeam"@newteam); }
// for my div-info
exec function ShowNetSpeeds()	{ ViewPort.Actor.Mutate("PureShowNetSpeeds"); }
exec function ShowIPs()		{ ViewPort.Actor.Mutate("PureShowIPs"); }
exec function ShowTickrate()	{ ViewPort.Actor.Mutate("PureShowTickrate"); }
exec function ShowDemos()	{ ViewPort.Actor.Mutate("PureShowDemos"); }
// Helpers
exec function ShowID()		{ ViewPort.Actor.Mutate("ShowID"); }
exec function KickID(string ID)	{ ViewPort.Actor.Mutate("KickID"@ID); }
exec function BanID(string ID)	{ ViewPort.Actor.Mutate("BanID"@ID); }

//=============================================================================
// History:
//=============================================================================
/*
2001-08-28 : DB : Fixed BDBMapVote Bug (there might still be some)
								: VR Checking of MenuCmd, ShowObjective
				: Capturing LaunchUWindow/CloseUWindow
2001-06-1 USA : (no idea what month you are on DB):
		: implamented complete no state console
2001-12-02 DB : Set as PureConsole
 */

exec simulated function GetWeapon(class<Weapon> NewWeaponClass )
{
	if (ViewPort != None && ViewPort.Actor != None) {
		bbPlayer(ViewPort.Actor).zzSwitchedTime = ViewPort.Actor.Level.TimeSeconds;
		ViewPort.Actor.GetWeapon(NewWeaponClass);
	}
}

exec simulated function SwitchWeapon(byte F)
{
	if (ViewPort != None && ViewPort.Actor != None) {
		bbPlayer(ViewPort.Actor).zzSwitchedTime = ViewPort.Actor.Level.TimeSeconds;
		ViewPort.Actor.SwitchWeapon(F);
	}
}

exec simulated function PrevWeapon()
{
	if (ViewPort != None && ViewPort.Actor != None) {
		bbPlayer(ViewPort.Actor).zzSwitchedTime = ViewPort.Actor.Level.TimeSeconds;
		ViewPort.Actor.PrevWeapon();
	}
}

exec simulated function NextWeapon()
{
	if (ViewPort != None && ViewPort.Actor != None) {
		bbPlayer(ViewPort.Actor).zzSwitchedTime = ViewPort.Actor.Level.TimeSeconds;
		ViewPort.Actor.NextWeapon();
	}
}

exec simulated function SwitchToBestWeapon()
{
	if (ViewPort != None && ViewPort.Actor != None) {
		bbPlayer(ViewPort.Actor).zzSwitchedTime = ViewPort.Actor.Level.TimeSeconds;
		ViewPort.Actor.SwitchToBestWeapon();
	}
}

exec function ThrowWeapon()
{
	if (ViewPort != None && ViewPort.Actor != None && !ViewPort.Actor.Weapon.bTossedOut && !bbPlayer(ViewPort.Actor).xxUsingDefaultWeapon()) {
		bbPlayer(ViewPort.Actor).zzSwitchedTime = ViewPort.Actor.Level.TimeSeconds;
		ViewPort.Actor.ThrowWeapon();
	}
}

exec function ShowScores()
{
	if (bbPlayer(ViewPort.Actor) != None)
	{
		bbPlayer(ViewPort.Actor).ShowScores();
		if (!bForcedStats)
		{
			bbPlayer(ViewPort.Actor).ConsoleCommand("mutate smartctf forcestats");
			bForcedStats = true;
		}
	}
	else if (bbCHSpectator(ViewPort.Actor) != None)
	{
		bbCHSpectator(ViewPort.Actor).ShowScores();
		if (!bForcedStats)
		{
			bbCHSpectator(ViewPort.Actor).ConsoleCommand("mutate smartctf forcestats");
			bForcedStats = true;
		}
	}
}

exec function Version()
{
	if (bbPlayer(ViewPort.Actor) != None)
		bbPlayer(ViewPort.Actor).ClientMessage(class'UTPure'.Default.VersionStr@class'UTPure'.Default.LongVersion$class'UTPure'.Default.NiceVer);
	else if (bbCHSpectator(ViewPort.Actor) != None)
		bbCHSpectator(ViewPort.Actor).ClientMessage(class'UTPure'.Default.VersionStr@class'UTPure'.Default.LongVersion$class'UTPure'.Default.NiceVer);
}

defaultproperties
{
     Ello="g0v"
}
