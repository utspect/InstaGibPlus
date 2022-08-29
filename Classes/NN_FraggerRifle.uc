class NN_FraggerRifle extends NN_SniperRifle;

///////////////////////////////////////////////////////////////////////////////////
// FN_Fraggerv6a, created for the us/euro camping/sniping fn ladder
// This version created by ]TD[Tech
//
// Modified by {MOS}*KrystoF the 08/08/20021
// To add Translocator Modification in the new version
// FraggerRifleV1
//
// Credit to :
// ]TD[Tech , for this rifle.
// ]TKK[KID VICIOUS  for making the first version of the fn gun, season 1
// SkullKrusher for the pure fix, wouldnt have been possible without you help m8.
// :[lol]:Mhor, for the custom arena code
// :[lol]:WalknBullseye for rifle pickup model and the scope code
//  ]TD[Tech for the Remover code.
// ]TD[Fluffy for the new scope.
// all the unsung heros of uscript who have code in this gun , to the unknown, i salute you.
///////////////////////////////////////////////////////////////////////////////

//pickp model thanks to :[lol]:WalknBullseye
#exec MESH IMPORT MESH=PUGroundg ANIVFILE="MODELS/Fragger/PUGroundg_a.3D" DATAFILE="MODELS/Fragger/PUGroundg_d.3D" X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=PUGroundg X=0 Y=0 Z=0 YAW=64
#exec MESH SEQUENCE MESH=PUGroundg SEQ=All          STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=PUGroundg SEQ=Still        STARTFRAME=0   NUMFRAMES=1
#exec MESHMAP SCALE MESHMAP=PUGroundg X=0.07 Y=0.07 Z=0.14

#exec TEXTURE IMPORT NAME=Multig FILE="Textures/Fragger/Multig.pcx" Mips=on

#exec MESHMAP SETTEXTURE MESHMAP=PUGroundg NUM=0 TEXTURE=Multig
#exec MESHMAP SETTEXTURE MESHMAP=PUGroundg NUM=1 TEXTURE=Multig
#exec MESHMAP SETTEXTURE MESHMAP=PUGroundg NUM=2 TEXTURE=Multig
#exec MESHMAP SETTEXTURE MESHMAP=PUGroundg NUM=3 TEXTURE=Multig
#exec MESHMAP SETTEXTURE MESHMAP=PUGroundg NUM=4 TEXTURE=Multig

#exec MESH IMPORT MESH=PUHandg ANIVFILE="MODELS/Fragger/PUHandg_a.3D" DATAFILE="MODELS/Fragger/PUHandg_d.3D" X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=PUHandg X=-150 Y=0 Z=-30 YAW=255 PITCH=0 ROLL=0
#exec MESH SEQUENCE MESH=PUHandg SEQ=Still          STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=PUHandg SEQ=All            STARTFRAME=0   NUMFRAMES=1
#exec MESHMAP SCALE MESHMAP=PUHandg X=0.07 Y=0.07 Z=0.14



#exec MESHMAP SETTEXTURE MESHMAP=PUHandg NUM=0 TEXTURE=Multig
#exec MESHMAP SETTEXTURE MESHMAP=PUHandg NUM=1 TEXTURE=Multig
#exec MESHMAP SETTEXTURE MESHMAP=PUHandg NUM=2 TEXTURE=Multig
#exec MESHMAP SETTEXTURE MESHMAP=PUHandg NUM=3 TEXTURE=Multig
#exec MESHMAP SETTEXTURE MESHMAP=PUHandg NUM=4 TEXTURE=Multig

//////

#exec AUDIO IMPORT FILE="Sounds/Fragger/FIRE.wav" NAME="FraggerFire"
#exec AUDIO IMPORT FILE="Sounds/Fragger/holyshit.wav"
#exec AUDIO IMPORT FILE="Sounds/Fragger/BubbleBlast.wav"

#exec TEXTURE IMPORT FILE="Textures/Fragger/AA.pcx"
#exec TEXTURE IMPORT FILE="Textures/Fragger/SR.pcx"
#exec TEXTURE IMPORT FILE="Textures/Fragger/Rifle2c.pcx"
#exec TEXTURE IMPORT FILE="Textures/Fragger/Rifle2d.pcx"

#exec TEXTURE IMPORT FILE="Textures/Fragger/crosshair.pcx" MIPS="OFF" FLAGS=2
#EXEC TEXTURE IMPORT FILE="Textures/Fragger/simple.pcx" MIPS=0 FLAGS=2
#EXEC TEXTURE IMPORT FILE="Textures/Fragger/Cross.pcx" MIPS=0 FLAGS=2
#EXEC TEXTURE IMPORT FILE="Textures/Fragger/Black.pcx" MIPS=0 FLAGS=2
#EXEC TEXTURE IMPORT FILE="Textures/Fragger/TDOT.pcx" MIPS=0  FLAGS=2
#EXEC TEXTURE IMPORT FILE="Textures/Fragger/ShellB.pcx"
#EXEC TEXTURE IMPORT FILE="Textures/Fragger/ShellR.pcx"
#EXEC TEXTURE IMPORT FILE="Textures/Fragger/ShellG.pcx"


var color TeamColor[6];
var Texture ShellCaseTex[4];

function PostBeginPlay() {
	super(SniperRifle).PostBeginPlay();

	WeaponSettingsHelper = new(none, 'InstaGibPlus') class'Object';
	WeaponSettings = new(WeaponSettingsHelper, 'WeaponSettingsFraggerArena') class'WeaponSettings';

	if (WeaponSettings != none) {
		BodyDamage = WeaponSettings.SniperDamage;
		HeadDamage = WeaponSettings.SniperHeadshotDamage;
		ReloadTime = WeaponSettings.SniperReloadTime;
	} else {
		BodyDamage = 45;
		HeadDamage = 100;
		ReloadTime = 0.6666666;
	}
}

simulated function PostRender( canvas Canvas )
{
    local bbPlayer P;
    local float Scale;
    local float Xlength;
    local float range;
    local vector HitLocation, HitNormal, StartTrace, EndTrace, X,Y,Z;
    local actor HitActor;
    local int TC;
    local string ScopeText;

    Super(TournamentWeapon).PostRender(Canvas);

    P = bbPlayer(Owner);
    if (P == none)
    	return;

    TC = Min(P.PlayerReplicationInfo.Team, 4);

    // Calc range
    XLength=255.0;
    GetAxes(Pawn(owner).ViewRotation,X,Y,Z);

    StartTrace = P.Location + P.EyeHeight*vect(0,0,1);
    EndTrace = StartTrace + (20000.0 * X);
    HitActor = P.NN_TraceShot(HitLocation, HitNormal, EndTrace, StartTrace, P);
    range = VSize(StartTrace-HitLocation)/48-0.25;

    if ( (P != None) && (P.DesiredFOV != P.DefaultFOV) )
    {
        Canvas.Font = Font'Botpack.WhiteFont';

        if (range>=200)
        {
            Canvas.DrawColor.R = 0;
            Canvas.DrawColor.G = 255;
            Canvas.DrawColor.B = 0;
            Canvas.SetPos( 100*Canvas.ClipX/401, 4*Canvas.ClipY/7 + Canvas.ClipY/401 -25 );
            Canvas.DrawText( "VERY FAR" );
        }
        if (range<=199.9 && range>=150)
        {
            Canvas.DrawColor.R = 255;
            Canvas.DrawColor.G = 255;
            Canvas.DrawColor.B = 0;
            Canvas.SetPos( 100*Canvas.ClipX/401, 4*Canvas.ClipY/7 + Canvas.ClipY/401 -25 );
            Canvas.DrawText( "FAR" );
        }
        if (range<=149.9 && range>=100)
        {
            Canvas.DrawColor.R = 255;
            Canvas.DrawColor.G = 255;
            Canvas.DrawColor.B = 255;
            Canvas.SetPos( 100*Canvas.ClipX/401, 4*Canvas.ClipY/7 + Canvas.ClipY/401 -25 );
            Canvas.DrawText( "MEDIUM" );
        }
        if (range<=99.9 && range>=50)
        {
            Canvas.DrawColor.R = 255;
            Canvas.DrawColor.G = 0;
            Canvas.DrawColor.B = 255;
            Canvas.SetPos( 100*Canvas.ClipX/401, 4*Canvas.ClipY/7 + Canvas.ClipY/401 -25 );
            Canvas.DrawText( "CLOSE" );
        }
        if (range<=49.99)
        {
            Canvas.DrawColor.R = 255;
            Canvas.DrawColor.G = 0;
            Canvas.DrawColor.B = 0;
            Canvas.SetPos( 100*Canvas.ClipX/401, 4*Canvas.ClipY/7 + Canvas.ClipY/401 -25 );
            Canvas.DrawText( "VERY CLOSE" );
        }
    }
    switch (int(P.Settings.FraggerScopeChoice))
    {
        case 1:         //crosshair #1 Movable #1

            if ( (P != None) && (P.DesiredFOV != P.DefaultFOV) )
            {
                // Draw crosshair
                bOwnsCrossHair = true;
                scale = Canvas.ClipX/640;

                if ( Level.bHighDetailMode ) Canvas.Style = ERenderStyle.STY_Translucent;
                else Canvas.Style = ERenderStyle.STY_Normal;

                // Square
                Canvas.SetPos( 3*Canvas.ClipX/7, 3*Canvas.ClipY/7 );
                Canvas.DrawColor = TeamColor[TC];
                Canvas.DrawTile( Texture 'Cross', Canvas.ClipX/7, Canvas.ClipY/7, 0, 0, 256, 191 );

                // Top Line
                Canvas.SetPos( 200*Canvas.ClipX/401, Canvas.ClipY/229*(90-P.DesiredFOV)+0.6*Canvas.ClipY/28 );
                Canvas.DrawColor = TeamColor[TC];
                Canvas.DrawTile( Texture 'Cross', Canvas.ClipX/401, Canvas.ClipY/28, 0, 20, 3, 10 );

                // Bottom Line
                Canvas.SetPos( 200*Canvas.ClipX/401, 15.35*Canvas.ClipY/28 + Canvas.ClipY/229*P.DesiredFOV );
                Canvas.DrawColor = TeamColor[TC];
                Canvas.DrawTile( Texture 'Cross', Canvas.ClipX/401, Canvas.ClipY/28, 0, 20, 3, 10 );

                // Left Line
                Canvas.SetPos( Canvas.ClipX/229*(90-P.DesiredFOV)+0.6*Canvas.ClipX/28, 200*Canvas.ClipY/401 );
                Canvas.DrawColor = TeamColor[TC];
                Canvas.DrawTile( Texture 'Cross', Canvas.ClipX/28, Canvas.ClipY/401, 10, 0, 10, 3 );

                // Right Line
                Canvas.SetPos( 15.35*Canvas.ClipX/28 + Canvas.ClipX/229*P.DesiredFOV, 200*Canvas.ClipY/401 );
                Canvas.DrawColor = TeamColor[TC];
                Canvas.DrawTile( Texture 'Cross', Canvas.ClipX/28, Canvas.ClipY/401, 10, 0, 10, 3 );


                Canvas.SetPos( 199.5*Canvas.ClipX/401, 199.5*Canvas.ClipY/401 );
                Canvas.DrawColor.R = 255;
                Canvas.DrawColor.G = 0;
                Canvas.DrawColor.B = 0;
                Canvas.DrawTile( Texture 'Cross', 2*Canvas.ClipX/401, 2*Canvas.ClipY/401, 0, 202, 53, 53 );

                // Top Gradient
                Canvas.SetPos( 200*Canvas.ClipX/401, 4*Canvas.ClipY/9 );
                Canvas.DrawColor = TeamColor[TC];
                Canvas.DrawTile( Texture 'Cross', Canvas.ClipX/401, Canvas.ClipY/1360*(90-P.DesiredFOV), 129, 197, 3, 54 );

                // Left Gradient
                Canvas.SetPos( 4*Canvas.ClipX/9, 200*Canvas.ClipY/401 );
                Canvas.DrawColor = TeamColor[TC];
                Canvas.DrawTile( Texture 'Cross', Canvas.ClipX/1360*(90-P.DesiredFOV), Canvas.ClipY/401, 69, 200, 54, 3 );

                //Bottom Gradient
                Canvas.SetPos( 200*Canvas.ClipX/401, 5*Canvas.ClipY/9 - Canvas.ClipY/1360*(90-P.DesiredFOV) );
                Canvas.DrawColor = TeamColor[TC];
                Canvas.DrawTile( Texture 'Cross', Canvas.ClipX/401, Canvas.ClipY/1360*(90-P.DesiredFOV), 144, 199, 3, 54 );

                //Right Gradient
                Canvas.SetPos( 5*Canvas.ClipX/9 - Canvas.ClipX/1360*(90-P.DesiredFOV), 200*Canvas.ClipY/401 );
                Canvas.DrawColor = TeamColor[TC];
                Canvas.DrawTile( texture 'Cross', Canvas.ClipX/1360*(90-P.DesiredFOV), Canvas.ClipY/401, 163, 199, 54, 3 );


                // Magnification Display
                Canvas.SetPos( 205*Canvas.ClipX/401-75, 4*Canvas.ClipY/7 + Canvas.ClipY/401 );
                Canvas.Font = Font'Botpack.medFont';
                Canvas.DrawColor = TeamColor[TC];
                scale = P.DefaultFOV/P.DesiredFOV;
                ScopeText = "FN  Z:"$int(Scale)$"."$int(10 * scale - 10 * int(Scale));
                //if (bUseRange) {
                	ScopeText = ScopeText $ "  R: "$int(range)$"."$int(10 * range -10 * int(range));
                //}
                Canvas.DrawText(ScopeText);

                //if (bUseBlack) {

                    Canvas.Style = ERenderStyle.STY_modulated;

                    // Top Gradient
                    Canvas.SetPos( 200*Canvas.ClipX/401, 4*Canvas.ClipY/9 );
                    Canvas.DrawTile( texture 'black', Canvas.ClipX/401, Canvas.ClipY/1360*(90-P.DesiredFOV), 129, 197, 3, 54 );

                    // Left Gradient
                    Canvas.SetPos( 4*Canvas.ClipX/9, 200*Canvas.ClipY/401 );
                    Canvas.DrawTile( texture 'black', Canvas.ClipX/1360*(90-P.DesiredFOV), Canvas.ClipY/401, 69, 200, 54, 3 );

                    //Bottom Gradient
                    Canvas.SetPos( 200*Canvas.ClipX/401, 5*Canvas.ClipY/9 - Canvas.ClipY/1360*(90-P.DesiredFOV) );
                    Canvas.DrawTile( texture 'black', Canvas.ClipX/401, Canvas.ClipY/1360*(90-P.DesiredFOV), 144, 199, 3, 54 );

                    //Right Gradient
                    Canvas.SetPos( 5*Canvas.ClipX/9 - Canvas.ClipX/1360*(90-P.DesiredFOV), 200*Canvas.ClipY/401 );
                    Canvas.DrawTile( texture 'black', Canvas.ClipX/1360*(90-P.DesiredFOV), Canvas.ClipY/401, 163, 199, 54, 3 );
                //}
            }
            else
                bOwnsCrossHair = false;
            break;

        case 2:         //Crosshair # 3 static crosshair    #1

            if ( (P != None) && (P.DesiredFOV != P.DefaultFOV) )
            {
                bOwnsCrossHair = true;
                scale = (Canvas.ClipX/1024);

                if ( Level.bHighDetailMode )
                    Canvas.Style = ERenderStyle.STY_Translucent;
                else
                    Canvas.Style = ERenderStyle.STY_Normal;
                Canvas.DrawColor = TeamColor[5];
                Canvas.SetPos(0.5 * Canvas.ClipX - 128 * Scale, 0.5 * Canvas.ClipY - 128 * scale );
                Canvas.DrawIcon( texture 'simple', Scale);

                // Magnification Display
                Canvas.SetPos( 205*Canvas.ClipX/401-75, 4*Canvas.ClipY/7 + Canvas.ClipY/401 );
                Canvas.Font = Font'Botpack.medFont';
                Canvas.DrawColor = TeamColor[TC];
                scale = P.DefaultFOV/P.DesiredFOV;
                ScopeText = "FN  Z:"$int(Scale)$"."$int(10 * scale - 10 * int(Scale));
                //if (bUseRange) {
                	ScopeText = ScopeText $ "  R: "$int(range)$"."$int(10 * range -10 * int(range));
                //}
                Canvas.DrawText(ScopeText);

                //if (bUseBlack) {
                    Canvas.Style = ERenderStyle.STY_modulated;


                    // Top Gradient
                    Canvas.SetPos( 200*Canvas.ClipX/401, 4*Canvas.ClipY/9 );
                    Canvas.DrawTile( texture 'black', Canvas.ClipX/401, Canvas.ClipY/1360*(90-P.DesiredFOV), 129, 197, 3, 54 );

                    // Left Gradient
                    Canvas.SetPos( 4*Canvas.ClipX/9, 200*Canvas.ClipY/401 );
                    Canvas.DrawTile( texture 'black', Canvas.ClipX/1360*(90-P.DesiredFOV), Canvas.ClipY/401, 69, 200, 54, 3 );

                    //Bottom Gradient
                    Canvas.SetPos( 200*Canvas.ClipX/401, 5*Canvas.ClipY/9 - Canvas.ClipY/1360*(90-P.DesiredFOV) );
                    Canvas.DrawTile( texture 'black', Canvas.ClipX/401, Canvas.ClipY/1360*(90-P.DesiredFOV), 144, 199, 3, 54 );

                    //Right Gradient
                    Canvas.SetPos( 5*Canvas.ClipX/9 - Canvas.ClipX/1360*(90-P.DesiredFOV), 200*Canvas.ClipY/401 );
                    Canvas.DrawTile( texture 'black', Canvas.ClipX/1360*(90-P.DesiredFOV), Canvas.ClipY/401, 163, 199, 54, 3 );
                //}
            }
            else
                bOwnsCrossHair = false;

            break;

        case 0:

            if ( (P != None) && (P.DesiredFOV != P.DefaultFOV) )
            {
                bOwnsCrosshair = False;
                if ( Level.bHighDetailMode )
                    Canvas.Style = ERenderStyle.STY_Normal;
                else
                    Canvas.Style = ERenderStyle.STY_Normal;
            }
            else
            {
                bOwnsCrossHair = False;
            }
            break;
    } //switch end
}


simulated exec function Scope()
{
	local bbPlayer P;

	P = bbPlayer(Owner);
	if (P == none)
		return;

    if (Role < ROLE_Authority || Level.NetMode < NM_Client) {
        P.Settings.CycleFraggerScope();
    }
}

simulated function PlayFiring()
{
	PlayOwnedSound(FireSound, SLOT_None, Pawn(Owner).SoundDampening*3.0);
	if ( (Owner.Physics != PHYS_Falling && Owner.Physics != PHYS_Swimming && Pawn(Owner).bDuck != 0) ||
		Owner.Velocity == vect(0,0,0)
	) {
		PlayAnim(FireAnims[Rand(5)], 3.57 * 0.6666666 / ReloadTime, 0.05);
	} else {
		PlayAnim(FireAnims[Rand(5)], 0.6666666 / ReloadTime, 0.05);
	}

	if ( (PlayerPawn(Owner) != None) && (PlayerPawn(Owner).DesiredFOV == PlayerPawn(Owner).DefaultFOV) )
		bMuzzleFlash++;
}

function TraceFire( float Accuracy )
{
	if ((Owner.Physics != PHYS_Falling && Owner.Physics != PHYS_Swimming && Pawn(Owner).bDuck != 0) || Owner.Velocity == 0 * Owner.Velocity)
		super.TraceFire(0.0);
	else
		super.TraceFire(100.0);
}

simulated function NN_TraceFire(optional float Accuracy)
{
	if ((Owner.Physics != PHYS_Falling && Owner.Physics != PHYS_Swimming && Pawn(Owner).bDuck != 0) || Owner.Velocity == 0 * Owner.Velocity)
		super.NN_TraceFire(0.0);
	else
		super.NN_TraceFire(100.0);
}

simulated function NN_DoShellCase(PlayerPawn Pwner, vector HitLoc, Vector X, Vector Y, Vector Z) {
	local UT_ShellCase s;

	if (Owner.IsA('Bot'))
		return;

	s = Spawn(class'NN_FraggerShell', Pwner,, HitLoc);
	if ( s != None )
	{
		s.DrawScale = 0.55;
		s.MultiSkins[1] = ShellCaseTex[Pwner.PlayerReplicationInfo.Team];
		s.Eject(((FRand()*0.3+0.4)*X + (FRand()*0.2+0.2)*Y + (FRand()*0.3+1.0) * Z)*160);
		s.RemoteRole = ROLE_None;
	}
}

simulated function DoShellCase(PlayerPawn Pwner, vector HitLoc, Vector X, Vector Y, Vector Z)
{
	local UT_Shellcase s;

	if (RemoteRole < ROLE_Authority) {
		s = Spawn(class'NN_FraggerShellOwnerHidden', Pwner,, HitLoc);
		if ( s != None ) {
			s.DrawScale = 0.55;
			s.MultiSkins[1] = ShellCaseTex[Pwner.PlayerReplicationInfo.Team];
			s.Eject(((FRand()*0.3+0.4)*X + (FRand()*0.2+0.2)*Y + (FRand()*0.3+1.0) * Z)*160);
		}
	}
}

simulated function float GetMinHeadshotZ(Pawn Other) {
	if ((Owner.Physics != PHYS_Falling && Owner.Physics != PHYS_Swimming && Pawn(Owner).bDuck != 0) || Owner.Velocity == 0 * Owner.Velocity)
		return BodyHeight * Other.CollisionHeight;
	return Other.CollisionHeight*2.0;
}

function setHand(float Hand) {
    Super.SetHand(Hand);
    MultiSkins[0] = Texture'AA';
    MultiSkins[1] = Texture'SR';
    MultiSkins[2] = Texture'Rifle2c';
    MultiSkins[3] = Texture'Rifle2d';
}

simulated function Tick(float DeltaTime) {
	local PlayerPawn P;

	if (Owner != none &&
		Owner.IsA('PlayerPawn') &&
		bCanClientFire
	) {
		P = PlayerPawn(Owner);
		switch (ZoomState) {
		case ZS_None:
			if (Pawn(Owner).bAltFire != 0) {
				SetTimer(0.2, true);
				ZoomState = ZS_Zooming;
			}
			break;
		case ZS_Zooming:
			if (Pawn(Owner).bAltFire == 0) {
				ZoomState = ZS_Zoomed;
				break;
			}
			if (P.Player.IsA('ViewPort')) {
				P.DesiredFOV -= P.DesiredFOV*DeltaTime*3.4;
				P.DesiredFOV = FClamp(P.DesiredFOV, 2.0, 170.0);
			}
			break;
		case ZS_Zoomed:
			if (Pawn(Owner).bAltFire != 0) {
				SetTimer(0.0, false);
				if (P.Player.IsA('ViewPort'))
					P.EndZoom();
				ZoomState = ZS_Reset;
			}
			break;
		case ZS_Reset:
			if (Pawn(Owner).bAltFire == 0) {
				ZoomState = ZS_None;
			}
			break;
		}
	}
}


defaultproperties {
	BodyHeight=0.62
	PickupAmmoCount=150

	TeamColor(0)=(R=255,G=0,B=0,A=0)
	TeamColor(1)=(R=0,G=128,B=255,A=0)
	TeamColor(2)=(R=0,G=255,B=0,A=0)
	TeamColor(3)=(R=255,G=255,B=0,A=0)
	TeamColor(4)=(R=206,G=103,B=0,A=0)
	TeamColor(5)=(R=255,G=255,B=255,A=0)

	ShellCaseTex(0)=Texture'ShellR'
	ShellCaseTex(1)=Texture'ShellB'
	ShellCaseTex(2)=Texture'ShellG'
	ShellCaseTex(3)=Texture'Botpack.Shellcase1'

	AmmoName=Class'NN_FraggerAmmo'
	FireSound=Sound'FraggerFire'
	SelectSound=Sound'BubbleBlast'

	PickupViewMesh=LodMesh'PUGroundg'
	ThirdPersonMesh=LodMesh'PUHandg'
	Mesh=LodMesh'PUGroundg'
	MultiSkins(0)=Texture'AA'
	MultiSkins(1)=Texture'SR'
	MultiSkins(2)=Texture'Rifle2c'
	MultiSkins(3)=Texture'Rifle2d'

	WeaponDescription="Fragger Rifle"
	DeathMessage="%k Killed %o with the FraggerRifle"
	PickupMessage="you got the Fragger Rifle"

	shakemag=0.0
	shaketime=0.0
	shakevert=0.0
}
