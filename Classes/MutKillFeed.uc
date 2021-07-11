class MutKillFeed extends Mutator;

#exec Texture Import Name=KF_ChainSaw        File=Textures\Icons\IconSaw.pcx    Mips=Off
#exec Texture Import Name=KF_ImpactHammer    File=Textures\Icons\IconHammer.pcx Mips=Off
#exec Texture Import Name=KF_Translocator    File=Textures\Icons\IconTrans.pcx  Mips=Off
#exec Texture Import Name=KF_Enforcer        File=Textures\Icons\IconAutoM.pcx  Mips=Off
#exec Texture Import Name=KF_BioRifle        File=Textures\Icons\IconBio.pcx    Mips=Off
#exec Texture Import Name=KF_ShockRifle      File=Textures\Icons\IconASMD.pcx   Mips=Off
#exec Texture Import Name=KF_PulseGun        File=Textures\Icons\IconPulse.pcx  Mips=Off
#exec Texture Import Name=KF_Ripper          File=Textures\Icons\IconRazor.pcx  Mips=Off
#exec Texture Import Name=KF_Minigun         File=Textures\Icons\IconMini.pcx   Mips=Off
#exec Texture Import Name=KF_FlakCannon      File=Textures\Icons\IconFlak.pcx   Mips=Off
#exec Texture Import Name=KF_RocketLauncher  File=Textures\Icons\Icon8ball.pcx  Mips=Off
#exec Texture Import Name=KF_SniperRifle     File=Textures\Icons\IconRifle.pcx  Mips=Off
#exec Texture Import Name=KF_WarheadLauncher File=Textures\Icons\IconWarH.pcx   Mips=Off

struct WeaponIconMapEntry {
	var class<Weapon> Weapon;
	var Texture Icon;
};

var WeaponIconMapEntry WeaponIconMap[16];
const INVALID_WEAPON_ICON_INDEX = 255;

struct MessageEntry {
	var PlayerReplicationInfo Killer;
	var PlayerReplicationInfo Victim;
	var byte IconIndex;
	var float StartTime;
	var float Lifespan;
};

var MessageEntry Messages[4];
var int MessageIndex;

var float LineLifespan;
var float LineFadeTime;

var float LastTimeStamp;
var FontInfo MyFonts;
var Font NameFont;

var float LastMessageTime;
var int LastSwitch;
var PlayerReplicationInfo LastPRI1;
var PlayerReplicationInfo LastPRI2;

replication {
	reliable if (Role == ROLE_Authority)
		Messages;
}

simulated event Destroyed() {
	if (MyFonts != none)
		MyFonts.Destroy();
	super.Destroyed();
}

simulated event PostBeginPlay() {
	RegisterHUDMutator();

	if (Level.Game != none)
		Level.Game.RegisterMessageMutator(self);

	if (MyFonts == none)
		MyFonts = Spawn(Class<FontInfo>(DynamicLoadObject(class'ChallengeHUD'.default.FontInfoClass, class'Class')));
}

simulated function Tick(float DeltaTime) {
	if (bHUDMutator == false) {
		RegisterHUDMutator();
		if (MyFonts == none)
			MyFonts = Spawn(Class<FontInfo>(DynamicLoadObject(class'ChallengeHUD'.default.FontInfoClass, class'Class')));
	}
	super.Tick(DeltaTime);
}

simulated function color GetTeamColor(bool bTeamGame, PlayerReplicationInfo PRI, float Opacity) {
	local Color C;

	if (bTeamGame) {
		switch (PRI.Team) {
			case 0: // red
				C.R = 255;
				C.G = 0;
				C.B = 0;
				break;
			case 1: // blue
				C.R = 32;
				C.G = 32;
				C.B = 255;
				break;
			case 2: // green
				C.R = 0;
				C.G = 255;
				C.B = 0;
				break;
			case 3: // gold
				C.R = 254;
				C.G = 227;
				C.B = 18;
				break;
			default: // white
				C.R = 255;
				C.G = 255;
				C.B = 255;
				break;
		}
	} else {
		C.R = 255;
		C.G = 255;
		C.B = 255;
	}

	C.R = int(Opacity * C.R);
	C.G = int(Opacity * C.G);
	C.B = int(Opacity * C.B);
	C.A = int(Opacity * 255);

	return C;
}

simulated function RenderKillFeedLine(
	Canvas C,
	out MessageEntry E,
	float X,
	float Y,
	float PositionX,
	bool bTeamGame
) {
	local float Opacity;
	local float YL;
	local float LineLength;
	local float KillerNameX;
	local float VictimNameX;
	local Texture Icon;
	local float IconX, IconY;

	if (E.Victim == none) {
		return;
	}
	if (E.Lifespan <= 0) {
		return;
	}

	if (LineFadeTime > 0) {
		Opacity = FClamp(E.Lifespan / LineFadeTime, 0, 1);
	} else if (E.Lifespan > 0) {
		Opacity = 1.0;
	} else {
		Opacity = 0.0;
	}

	LineLength = 4;

	C.TextSize(E.Victim.PlayerName, VictimNameX, YL);
	LineLength += VictimNameX;
	if (E.Killer != none) {
		C.TextSize(E.Killer.PlayerName, KillerNameX, YL);
		LineLength += KillerNameX;
	}

	Icon = WeaponIconMap[E.IconIndex].Icon;
	// Weapon Icons dont use all vertical space, so add 5 pixels above and below
	IconY = YL + 10;
	// Weapon Icons have fixed 2:1 aspect ratio
	IconX = IconY * 2;
	// Weapon Icons dont use all horizontal space either, so overlap 10 pixels left and right with names
	LineLength += IconX - 16;

	X -= PositionX * LineLength;

	// draw background
	C.DrawColor.R = int(Opacity * 48);
	C.DrawColor.G = int(Opacity * 48);
	C.DrawColor.B = int(Opacity * 48);
	C.DrawColor.A = int(Opacity * 48);
	C.SetPos(X, Y);
	C.DrawTile(Texture'CrossHairBase', LineLength+4, YL+4, 0, 0, 1, 1);

	if (E.Killer != none) {
		C.DrawColor = GetTeamColor(bTeamGame, E.Killer, Opacity);
		C.SetPos(X+2, Y+2);
		C.DrawText(E.Killer.PlayerName);

		C.SetPos(X + 2 + KillerNameX - 8, Y + 2 - 5);
		C.DrawTile(Icon, IconX, IconY, 0, 0, Icon.USize, Icon.VSize);

		C.DrawColor = GetTeamColor(bTeamGame, E.Victim, Opacity);
	} else {
		C.DrawColor = GetTeamColor(bTeamGame, E.Victim, Opacity);
		C.SetPos(X + 2 - 8, Y + 2 - 5);
		C.DrawTile(Icon, IconX, IconY, 0, 0, Icon.USize, Icon.VSize);
	}

	C.SetPos(X + LineLength - VictimNameX - 2, Y + 2);
	C.DrawText(E.Victim.PlayerName);
}

simulated event PostRender(Canvas C) {
	local float DeltaTime;
	local int i;
	local int Latest;
	local float LatestTime;

	local float PositionX;
	local float PositionY;
	local float XL;
	local float LineHeight;
	local float X,Y;
	local bool bTeamGame;

	class'CanvasUtils'.static.SaveCanvas(C);

	if (NameFont == none)
		NameFont = MyFonts.GetMediumFont(C.SizeX);
	if (NameFont == none)
		goto end;

	DeltaTime = Level.TimeSeconds - LastTimeStamp;
	LastTimeStamp = Level.TimeSeconds;
	if (DeltaTime <= 0)
		goto end;

	PositionX = 0;
	PositionY = 0.5;

	C.Font = NameFont;
	C.Style = ERenderStyle.STY_Translucent;
	C.bNoSmooth = false;

	C.TextSize("TEST", XL, LineHeight);

	X = PositionX * C.SizeX;
	Y = PositionY * C.SizeY;
	Y -= PositionY * ((LineHeight + 4) * arraycount(Messages));

	LatestTime = Messages[0].StartTime;
	Latest = 0;
	for (i = 1; i < arraycount(Messages); ++i) {
		if (LatestTime < Messages[i].StartTime) {
			Latest = i;
			LatestTime = Messages[i].StartTime;
		}
	}

	if (C.Viewport != none && C.Viewport.Actor != none && C.Viewport.Actor.GameReplicationInfo != none)
		bTeamGame = C.Viewport.Actor.GameReplicationInfo.bTeamGame;

	i = Latest;
	do {
		RenderKillFeedLine(C, Messages[i], X, Y, PositionX, bTeamGame);
		Messages[i].Lifespan = FMax(Messages[i].Lifespan - DeltaTime, 0.0);

		Y += LineHeight+4;
		if (i == 0)
			i = arraycount(Messages);
		i -= 1;
	} until(i == Latest);

end:
	class'CanvasUtils'.static.RestoreCanvas(C);

	if (NextHUDMutator != none)
		NextHUDMutator.PostRender(C);
}

function byte MapWeaponClassToIndex(class<Weapon> W) {
	local int i;

	if (W == none)
		return INVALID_WEAPON_ICON_INDEX;

	for (i = 0; i < arraycount(WeaponIconMap); ++i)
		if (WeaponIconMap[i].Weapon != none && ClassIsChildOf(W, WeaponIconMap[i].Weapon))
			return i;

	return INVALID_WEAPON_ICON_INDEX;
}

function AddKillFeedLine(
	PlayerReplicationInfo KillerPRI,
	PlayerReplicationInfo VictimPRI,
	class<Weapon> WeaponClass
) {
	local byte Index;

	if (KillerPRI == VictimPRI)
		KillerPRI = none;

	Index = MapWeaponClassToIndex(WeaponClass);
	if (Index == INVALID_WEAPON_ICON_INDEX)
		return;

	Messages[MessageIndex].Killer = KillerPRI;
	Messages[MessageIndex].Victim = VictimPRI;
	Messages[MessageIndex].IconIndex = Index;
	Messages[MessageIndex].StartTime = Level.TimeSeconds;
	Messages[MessageIndex].Lifespan = LineLifespan + LineFadeTime;

	MessageIndex += 1;
	if (MessageIndex == arraycount(Messages))
		MessageIndex = 0;
}

function bool MutatorBroadcastLocalizedMessage(
	Actor Sender,
	Pawn Receiver,
	out class<LocalMessage> Message,
	out optional int Switch,
	out optional PlayerReplicationInfo RelatedPRI_1,
	out optional PlayerReplicationInfo RelatedPRI_2,
	out optional Object OptionalObject
) {
	if (Message != Level.Game.DeathMessageClass)
		goto end;

	if (Switch != 0) // varying forms of suicide
		goto end;

	if (Level.TimeSeconds == LastMessageTime &&
		Switch == LastSwitch &&
		RelatedPRI_1 == LastPRI1 &&
		RelatedPRI_2 == LastPRI2
	) {
		// dont create more than 1 KillFeed line
		goto end;
	}

	LastMessageTime = Level.TimeSeconds;
	LastSwitch = Switch;
	LastPRI1 = RelatedPRI_1;
	LastPRI2 = RelatedPRI_2;

	AddKillFeedLine(RelatedPRI_1, RelatedPRI_2, class<Weapon>(OptionalObject));

end:
	return super.MutatorBroadcastLocalizedMessage(
		Sender,
		Receiver,
		Message,
		Switch,
		RelatedPRI_1,
		RelatedPRI_2,
		OptionalObject
	);
}

defaultproperties {
	RemoteRole=ROLE_SimulatedProxy
	bAlwaysRelevant=true
	NetUpdateFrequency=10

	LineLifespan=5.0
	LineFadeTime=1.0

	WeaponIconMap(0)=(Weapon=class'ChainSaw',Icon=texture'KF_ChainSaw')
	WeaponIconMap(1)=(Weapon=class'ImpactHammer',Icon=texture'KF_ImpactHammer')
	WeaponIconMap(2)=(Weapon=class'Translocator',Icon=texture'KF_Translocator')
	WeaponIconMap(3)=(Weapon=class'Enforcer',Icon=texture'KF_Enforcer')
	WeaponIconMap(4)=(Weapon=class'UT_BioRifle',Icon=texture'KF_BioRifle')
	WeaponIconMap(5)=(Weapon=class'ShockRifle',Icon=texture'KF_ShockRifle')
	WeaponIconMap(6)=(Weapon=class'PulseGun',Icon=texture'KF_PulseGun')
	WeaponIconMap(7)=(Weapon=class'Ripper',Icon=texture'KF_Ripper')
	WeaponIconMap(8)=(Weapon=class'Minigun2',Icon=texture'KF_Minigun')
	WeaponIconMap(9)=(Weapon=class'UT_FlakCannon',Icon=texture'KF_FlakCannon')
	WeaponIconMap(10)=(Weapon=class'UT_Eightball',Icon=texture'KF_RocketLauncher')
	WeaponIconMap(11)=(Weapon=class'SniperRifle',Icon=texture'KF_SniperRifle')
	WeaponIconMap(12)=(Weapon=class'WarheadLauncher',Icon=texture'KF_WarheadLauncher')
}
