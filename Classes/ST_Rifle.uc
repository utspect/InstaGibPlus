//=============================================================================
// ST_Rifle.
//=============================================================================
class ST_Rifle extends ST_UnrealWeapons;

var float StillTime, StillStart;
var vector OwnerLocation;
var float BodyHeight;

function float RateSelf( out int bUseAltMode )
{
	local float dist;

	if ( AmmoType.AmmoAmount <=0 )
		return -2;

	bUseAltMode = 0;
	if ( (Bot(Owner) != None) && Bot(Owner).bSniping )
		return AIRating + 1.15;
	if (  Pawn(Owner).Enemy != None )
	{
		dist = VSize(Pawn(Owner).Enemy.Location - Owner.Location);
		if ( dist > 1200 )
		{
			if ( dist > 2000 )
				return (AIRating + 0.75);
			return (AIRating + FMin(0.0001 * dist, 0.45)); 
		}
	}
	return AIRating;
}

simulated function RenderOverlays(Canvas Canvas)
{
	local rotator NewRot;
	local bool bPlayerOwner;
	local int Hand;
	local PlayerPawn PlayerOwner;
	
	Super.RenderOverlays(Canvas);
	
	if ( bHideWeapon || (Owner == None) )
		return;

	PlayerOwner = PlayerPawn(Owner);

	if ( PlayerOwner != None )
	{
		bPlayerOwner = true;
		Hand = PlayerOwner.Handedness;

		if (  (Level.NetMode == NM_Client) && (Hand == 2) )
		{
			bHideWeapon = true;
				return;
		}
	}

	if ( !bPlayerOwner || (PlayerOwner.Player == None) )
		Pawn(Owner).WalkBob = vect(0,0,0);

		if ( (bMuzzleFlash > 0) && bDrawMuzzleFlash && Level.bHighDetailMode && (MFTexture != None) )
		{
			MuzzleScale = Default.MuzzleScale * Canvas.ClipX/640.0;
			if ( !bSetFlashTime )
			{
				bSetFlashTime = true;
				FlashTime = Level.TimeSeconds + FlashLength;
			}
			else if ( FlashTime < Level.TimeSeconds )
				bMuzzleFlash = 0;
			if ( bMuzzleFlash > 0 )
			{
			if ( Hand == 0 )
				Canvas.SetPos(Canvas.ClipX/2 - 0.5 * MuzzleScale * FlashS + Canvas.ClipX * (-0.2 * Default.FireOffset.Y * FlashO), Canvas.ClipY/2 - 0.5 * MuzzleScale * FlashS + Canvas.ClipY * (FlashY + FlashC));
			else
				Canvas.SetPos(Canvas.ClipX/2 - 0.5 * MuzzleScale * FlashS + Canvas.ClipX * (Hand * Default.FireOffset.Y * FlashO), Canvas.ClipY/2 - 0.5 * MuzzleScale * FlashS + Canvas.ClipY * FlashY);

				Canvas.Style = 3;
				Canvas.DrawIcon(MFTexture, MuzzleScale);
				Canvas.Style = 1;
			}
		}
	else
		bSetFlashTime = false;

		SetLocation( Owner.Location + CalcDrawOffset() );
		NewRot = Pawn(Owner).ViewRotation;

	if ( Hand == 0 )
		newRot.Roll = -2 * Default.Rotation.Roll;
	else
		newRot.Roll = Default.Rotation.Roll * Hand;

	setRotation(newRot);
	Canvas.DrawActor(self, false);
}

simulated function bool ClientFire(float Value)
{
	local bbPlayer bbP;

	bbP = bbPlayer(Owner);
	if (Role < ROLE_Authority && bbP != None && bNewNet)
	{
		if (bbP.ClientCannotShoot() || bbP.Weapon != Self)
			return false;
		if ( (AmmoType == None) && (AmmoName != None) )
		{
			GiveAmmo(Pawn(Owner));
		}
		if ( AmmoType.AmmoAmount > 0 )
		{
			Instigator = Pawn(Owner);
			GotoState('ClientFiring');
			bPointing=True;
			bCanClientFire = true;
			if ( bRapidFire || (FiringSpeed > 0) )
				Pawn(Owner).PlayRecoil(FiringSpeed);
			NN_TraceFire();
		}
	}
	return Super.ClientFire(Value);
}

simulated function bool ClientAltFire( float Value )
{
	local bbPlayer bbP;

	bbP = bbPlayer(Owner);
	if (bbP.ClientCannotShoot() || bbP.Weapon != Self)
		return false;
	GotoState('Zooming');
	return true;
}

function Fire( float Value )
{
	local bbPlayer bbP;
	
	bbP = bbPlayer(Owner);
	if (bbP != None && bNewNet && Value < 1)
		return;
		
	if ( (AmmoType == None) && (AmmoName != None) )
	{
		GiveAmmo(Pawn(Owner));
	}
	if ( AmmoType.UseAmmo(1) )
	{
		GotoState('NormalFire');
		bPointing=True;
		bCanClientFire = true;
		ClientFire(Value);
		CheckVisibility();
		if ( Owner.IsA('Bot') )
		{
			if ( Bot(Owner).bSniping && (FRand() < 0.65) )
				AimError = AimError/FClamp(StillTime, 1.0, 8.0);
			else if ( VSize(Owner.Location - OwnerLocation) < 6 )
				AimError = AimError/FClamp(0.5 * StillTime, 1.0, 3.0);
			else
				StillTime = 0;
		}
		if ( !bNewNet && ( bRapidFire || (FiringSpeed > 0) ))
			Pawn(Owner).PlayRecoil(FiringSpeed);
		TraceFire(0);
		AimError = Default.AimError;
	}
}

function AltFire( float Value )
{
	local bbPlayer bbP;

	bbP = bbPlayer(Owner);
	if (bbP != None && bNewNet && Value < 1)
		return;
	ClientAltFire(Value);
}

state NormalFire
{
	function Fire(float F) 
	{
		if (Owner.IsA('Bot'))
		{
			Super.Fire(F);
			return;
		}
		if (F > 0 && bbPlayer(Owner) != None)
			Global.Fire(F);
	}
	function AltFire(float F) 
	{
		if (Owner.IsA('Bot'))
		{
			Super.AltFire(F);
			return;
		}
		if (F > 0 && bbPlayer(Owner) != None)
			Global.AltFire(F);
	}
Begin:
	FinishAnim();
	Finish();
}

state Zooming
{
	simulated function AnimEnd()
	{
		if (owner==none)
			return;
		if ((playerpawn(owner) != None)&&( Playerpawn(Owner).DesiredFOV != Playerpawn(Owner).DefaultFOV ))
			PlayAnim('StillScope',1.0, 0.0);
		else
		PlayAnim('Still',1.0, 0.0);
	}
	simulated function Tick(float DeltaTime)
	{
		if (Pawn(Owner).bAltFire == 0)
		{
			if ((PlayerPawn(Owner) != None) && PlayerPawn(Owner).Player.IsA('ViewPort'))
				PlayerPawn(Owner).StopZoom();
				SetTimer(0.0,False);
			if (role==role_authority)
				GoToState('Idle');
			else
				GotoState('');
		}
	}
	simulated function BeginState()
	{
		if ( Owner.IsA('PlayerPawn') )
		{
			if ( PlayerPawn(Owner).Player.IsA('ViewPort') )
				PlayerPawn(Owner).ToggleZoom();
				PlayAltFiring();
				SetTimer(0.075,True);
		}
		else
		{
			Pawn(Owner).bFire = 1;
			Pawn(Owner).bAltFire = 0;
			Global.Fire(0);
		}
	}
}

function Timer()
{
	local actor targ;
	local float bestAim, bestDist;
	local vector FireDir;

	bestAim = 0.95;
	if ( Pawn(Owner) == None )
	{
		GotoState('');
		return;
	}
	if ( VSize(Pawn(Owner).Location - OwnerLocation) < 6 )
		StillTime += FMin(2.0, Level.TimeSeconds - StillStart);
	else
		StillTime = 0;
		StillStart = Level.TimeSeconds;
		OwnerLocation = Pawn(Owner).Location;
		FireDir = vector(Pawn(Owner).ViewRotation);
		targ = Pawn(Owner).PickTarget(bestAim, bestDist, FireDir, Owner.Location);
	if ( Pawn(targ) != None )
	{
		SetTimer(1 + 4 * FRand(), false);
		bPointing = true;
		Pawn(targ).WarnTarget(Pawn(Owner), 200, FireDir);
	}
	else 
	{
		SetTimer(0.4 + 1.6 * FRand(), false);
			if ( (Pawn(Owner).bFire == 0) && (Pawn(Owner).bAltFire == 0) )
				bPointing = false;
	}
}  

function Finish()
{
	if ( ((Pawn(Owner).bFire!=0) || (Pawn(Owner).bAltFire!=0)) && (FRand() < 0.6) )
		Timer();
	Super.Finish();
}

state Idle
{
	function AltFire( float Value )
	{
		GoToState('Zooming');
	}
	function Fire( float Value )
	{
		if (AmmoType.UseAmmo(1))
		{
			GotoState('NormalFire');
			bCanClientFire = true;
			bPointing=True;
			if ( Owner.IsA('Bot') )
			{
				if ( Bot(Owner).bSniping && (FRand() < 0.65) )
					AimError = AimError/FClamp(StillTime, 1.0, 8.0);
				else if ( VSize(Owner.Location - OwnerLocation) < 6 )
					AimError = AimError/FClamp(0.5 * StillTime, 1.0, 3.0);
				else
					StillTime = 0;
			}
			Pawn(Owner).PlayRecoil(FiringSpeed);
			TraceFire(0.0);
			AimError = Default.AimError;
			ClientFire(Value);
			CheckVisibility();
		}
	}
	function BeginState()
	{
		if (Pawn(Owner).bFire!=0) Fire(0.0);    
			bPointing = false;
			SetTimer(0.4 + 1.6 * FRand(), false);
			Super.BeginState();
	}
	function EndState()
	{  
		SetTimer(0.0, false);
		Super.EndState();
	}
Begin:
	bPointing=False;
	if ( (AmmoType != None) && (AmmoType.AmmoAmount<=0) ) 
		Pawn(Owner).SwitchToBestWeapon();
	if ( Pawn(Owner).bFire!=0 ) Fire(0.0);
		Disable('AnimEnd');
	PlayIdleAnim();
}

simulated function PlayFiring()
{
	if ((playerpawn(owner) != None)&&( Playerpawn(Owner).DesiredFOV != Playerpawn(Owner).DefaultFOV ))
		PlayAnim('ScopeFire', 0.56,0.05);
	else
		PlayAnim('Fire', 0.7,0.05);

	PlayOwnedSound(FireSound, SLOT_None, Pawn(Owner).SoundDampening*3.0);
}

simulated function PlayAltFiring()
{
	if ( Playerpawn(Owner).DesiredFOV != Playerpawn(Owner).DefaultFOV )
		PlayAnim('Scopeup', 3.0,0.05);
	else
		PlayAnim('Scopedown', 3.0,0.05);
}

simulated function PlayIdleAnim()
{
	if ( Mesh != PickupViewMesh )
	{
		if ((playerpawn(owner) != None)&&( Playerpawn(Owner).DesiredFOV != Playerpawn(Owner).DefaultFOV )&&(Animsequence!='scopeup'||!IsAnimating()))
			PlayAnim('StillScope',1.0, 0.05);
		else if ((animsequence!='scopedown'&&animsequence!='scopeup')||IsAnimating())
			PlayAnim('Still',1.0, 0.05);
	}
}

simulated function TweenToStill()
{
	if (playerpawn(owner)==none||Playerpawn(Owner).DesiredFOV == Playerpawn(Owner).DefaultFOV)
		TweenAnim('Still', 0.1);
	else
		TweenAnim('StillScope', 0.1);
}

simulated function NN_TraceFire()
{
	local vector HitLocation, HitDiff, HitNormal, StartTrace, EndTrace, X,Y,Z;
	local actor Other;
	local Pawn PawnOwner;
	local bbPlayer bbP;
	local bool bHeadshot;
	
	if (Owner.IsA('Bot'))
		return;
	
	yModInit();
	
	PawnOwner = Pawn(Owner);
	bbP = bbPlayer(Owner);
	if (bbP == None)
		return;

	GetAxes(GV,X,Y,Z);
	StartTrace = Owner.Location + bbP.Eyeheight * vect(0,0,1);
	EndTrace = StartTrace + (100000 * vector(GV));
	
	Other = bbP.NN_TraceShot(HitLocation,HitNormal,EndTrace,StartTrace,PawnOwner);
	if (Other.IsA('Pawn'))
		HitDiff = HitLocation - Other.Location;
	
	bHeadshot = NN_ProcessTraceHit(Other, HitLocation, HitNormal, X,Y,Z,yMod);
	bbP.xxNN_Fire(-1, bbP.Location, bbP.Velocity, bbP.zzViewRotation, Other, HitLocation, HitDiff, bHeadshot);
}

simulated function bool NN_ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z, float yMod)
{
	local UT_Shellcase s;
	local Pawn PawnOwner;
	local float CH;
	
	if (Owner.IsA('Bot'))
		return false;

	PawnOwner = Pawn(Owner);

	s = Spawn(class'UT_ShellCase',, '', Owner.Location + CDO + 30 * X + (2.8 * yMod+5.0) * Y - Z * 1);
	if ( s != None ) 
	{
		s.DrawScale = 2.0;
		s.Eject(((FRand()*0.3+0.4)*X + (FRand()*0.2+0.2)*Y + (FRand()*0.3+1.0) * Z)*160);              
	}
	if (Other == Level || Other.IsA('Mover'))
	{
		Spawn(class'UT_HeavyWallHitEffect',,, HitLocation+HitNormal, Rotator(HitNormal));
		if (bbPlayer(Owner) != None)
			bbPlayer(Owner).xxClientDemoFix(None, class'UT_HeavyWallHitEffect', HitLocation+HitNormal,,, Rotator(HitNormal));
	}
	else if ( (Other != self) && (Other != Owner) && (Other != None) )
	{
		if ( Other.bIsPawn )
		{
			if ((Other.GetAnimGroup(Other.AnimSequence) == 'Ducking') && (Other.AnimFrame > -0.03)) {
				CH = 0.3 * Other.CollisionHeight;
				return false; // disable crouching headshot
			} else {
				CH = Other.CollisionHeight;
			}
			
			if (HitLocation.Z - Other.Location.Z > BodyHeight * CH)
				return true;
		}
		
		if ( !Other.bIsPawn && !Other.IsA('Carcass') )
			spawn(class'UT_SpriteSmokePuff',,,HitLocation+HitNormal*9);	
	}
	return false;
}

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local vector realLoc;
	local Pawn PawnOwner, POther;
	local PlayerPawn PPOther;
	local vector HeadHitLocation, HeadHitNormal;
	local actor Head;
	local int ArmorAmount;
	local inventory inv;
	local bbPlayer bbP;

	if (Owner.IsA('Bot'))
	{
		Super(SniperRifle).ProcessTraceHit(Other, HitLocation, HitNormal, X, Y, Z);
		return;
	}

	bbP = bbPlayer(Owner);
	if (bbP == None || !bNewNet)
	{
		Super.ProcessTraceHit(Other, HitLocation, HitNormal, X,Y,Z);
		return;
	}

	PawnOwner = Pawn(Owner);
	POther = Pawn(Other);
	PPOther = PlayerPawn(Other);

	realLoc = Owner.Location + CalcDrawOffset();
	DoShellCase(PlayerPawn(Owner), realLoc + 20 * X + FireOffset.Y * Y + Z, X,Y,Z);

	if (Other == Level)
	{
		if (bNewNet)
			Spawn(class'NN_UT_HeavyWallHitEffectOwnerHidden',Owner,, HitLocation+HitNormal, Rotator(HitNormal));
		else
			Spawn(class'UT_HeavyWallHitEffect',,, HitLocation+HitNormal, Rotator(HitNormal));
	}
	else if ( (Other != self) && (Other != Owner) && (Other != None) )
	{
		if ( Other.bIsPawn )
			Other.PlaySound(Sound 'ChunkHit',, 4.0,,100);
		
		if ( (bbP.zzbNN_Special || !bNewNet &&
			Other.bIsPawn && (HitLocation.Z - Other.Location.Z > BodyHeight * Other.CollisionHeight) 
			&& (instigator.IsA('PlayerPawn') || (instigator.IsA('Bot') && !Bot(Instigator).bNovice)) )
			&& !PPOther.bIsCrouching && PPOther.GetAnimGroup(PPOther.AnimSequence) != 'Ducking' )
		{
			Other.TakeDamage(100, PawnOwner, HitLocation, 35000 * X, AltDamageType);
		}
		else
		{
			Other.TakeDamage(45,  PawnOwner, HitLocation, 30000.0*X, MyDamageType);
		}
		if ( !Other.bIsPawn && !Other.IsA('Carcass') )
		{
			if (bNewNet)
				spawn(class'NN_UT_SpriteSmokePuffOwnerHidden',Owner,,HitLocation+HitNormal*9);
			else
				spawn(class'UT_SpriteSmokePuff',,,HitLocation+HitNormal*9);
		}
	}
}

simulated function DoShellCase(PlayerPawn Pwner, vector HitLoc, Vector X, Vector Y, Vector Z)
{
	local PlayerPawn P;
	local Actor CR;
	local UT_Shellcase s;
	
	if (Owner.IsA('Bot'))
		return;

	if (RemoteRole < ROLE_Authority)
	{
		ForEach AllActors(class'PlayerPawn', P)
		{
			if (P != Pwner) {
				CR = P.Spawn(class'UT_ShellCase',P, '', HitLoc);
				CR.bOnlyOwnerSee = True;
				s = UT_Shellcase(CR);
			if ( s != None ) 
			{
				s.DrawScale = 2.0;
				s.Eject(((FRand()*0.3+0.4)*X + (FRand()*0.2+0.2)*Y + (FRand()*0.3+1.0) * Z)*160);              
			}
			}
		}
	}
}

function TraceFire( float Accuracy )
{
	local bbPlayer bbP;
	local vector NN_HitLoc, HitLocation, HitNormal, StartTrace, EndTrace, X,Y,Z;
	
	if (Owner.IsA('Bot'))
	{
		Super.TraceFire(Accuracy);
		return;
	}
	
	bbP = bbPlayer(Owner);
	
	if (bbP == None || !bNewNet)
	{
		Super.TraceFire(Accuracy);
		return;
	}
	
	if (bbP == None)
	{
		if (bbP.zzNN_HitActor.IsA('bbPlayer') && !bbPlayer(bbP.zzNN_HitActor).xxCloseEnough(bbP.zzNN_HitLoc))
		bbP.zzNN_HitActor = None;
	}
	
	Owner.MakeNoise(bbP.SoundDampening);
	GetAxes(bbP.zzNN_ViewRot,X,Y,Z);
	StartTrace = Owner.Location + bbP.Eyeheight * vect(0,0,1);
	AdjustedAim = bbP.AdjustAim(1000000, StartTrace, 2*AimError, False, False);	
	X = vector(AdjustedAim);
	EndTrace = StartTrace + 100000 * X;
	
	if (bbP.zzNN_HitActor != None && VSize(bbP.zzNN_HitDiff) > bbP.zzNN_HitActor.CollisionRadius + bbP.zzNN_HitActor.CollisionHeight)
		bbP.zzNN_HitDiff = vect(0,0,0);
	
	if (bbP.zzNN_HitActor != None && (bbP.zzNN_HitActor.IsA('Pawn') || bbP.zzNN_HitActor.IsA('Projectile')) && FastTrace(bbP.zzNN_HitActor.Location + bbP.zzNN_HitDiff, StartTrace))
	{
		NN_HitLoc = bbP.zzNN_HitActor.Location + bbP.zzNN_HitDiff;
		bbP.TraceShot(HitLocation,HitNormal,NN_HitLoc,StartTrace);
	}
	else
	{
		bbP.zzNN_HitActor = bbP.TraceShot(HitLocation,HitNormal,EndTrace,StartTrace);
		NN_HitLoc = bbP.zzNN_HitLoc;
	}
	ProcessTraceHit(bbP.zzNN_HitActor, NN_HitLoc, HitNormal, X,Y,Z);
	bbP.zzNN_HitActor = None;
}

function SetSwitchPriority(pawn Other)
{
	Class'NN_WeaponFunctions'.static.SetSwitchPriority( Other, self, 'SniperRifle');
}

simulated function TweenDown()
{
	if ( IsAnimating() && (AnimSequence != '') && (GetAnimGroup(AnimSequence) == 'Select') )
		TweenAnim( AnimSequence, AnimFrame * 0.4 );
	else if ((playerpawn(owner) != None)&&( Playerpawn(Owner).DesiredFOV != Playerpawn(Owner).DefaultFOV ))
		PlayAnim('DownWscope', 1.0, 0.05);
	else PlayAnim('Down', 1.0, 0.05);
}

state Active
{
	function Fire(float F)
	{
		if (Owner.IsA('Bot'))
		{
			Super.Fire(F);
			return;
		}
		if (F > 0 && bbPlayer(Owner) != None)
			Global.Fire(F);
	}
	function AltFire(float F) 
	{
		if (Owner.IsA('Bot'))
		{
			Super.AltFire(F);
			return;
		}
		if (F > 0 && bbPlayer(Owner) != None)
			Global.AltFire(F);
	}
}

defaultproperties
{
	AmmoName=Class'ST_RifleAmmo'
    BodyHeight=0.66
    WeaponDescription="Classification: Long-Range Ballistic\n\nRegular Fire: Fires a high powered bullet. Long range, very powerful, accurate. \n\nSecondary Fire: Zooms the rifle in, up to eight times normal vision. Allows for extreme precision from hundreds of yards away.\n\nTechniques: Great for long distance headshots!"
    PickupAmmoCount=8
    bInstantHit=True
    bAltInstantHit=True
    FireOffset=(X=0.00,Y=-5.00,Z=-2.00),
    MyDamageType=shot
    AltDamageType=Decapitated
    shakemag=400.00
    shaketime=0.15
    shakevert=8.00
    AIRating=0.70
    RefireRate=0.60
    AltRefireRate=0.30
    FireSound=Sound'UnrealI.Rifle.RifleShot'
    SelectSound=Sound'UnrealI.Rifle.RiflePickup'
    DeathMessage="%k put a bullet through %o's head."
    AutoSwitchPriority=5
    InventoryGroup=10
    PickupMessage="You got the Rifle"
    ItemName="Sniper Rifle"
	PlayerViewOffset=(X=3.20,Y=-1.20,Z=-1.50),
    PlayerViewMesh=LodMesh'UnrealI.RifleM'
    PickupViewMesh=LodMesh'UnrealI.RiPick'
    ThirdPersonMesh=LodMesh'UnrealI.Rifle3rd'
    StatusIcon=Texture'UseR'
    Icon=Texture'UseR'
    Mesh=LodMesh'UnrealI.RiPick'
    CollisionRadius=28.00
    CollisionHeight=8.00
}