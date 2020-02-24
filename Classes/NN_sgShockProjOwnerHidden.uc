class NN_sgShockProjOwnerHidden extends ST_sgShockProj;

var bool bAlreadyHidden;
var float NN_OwnerPing, NN_EndAccelTime;

replication
{
	reliable if ( Role == ROLE_Authority )
		NN_OwnerPing;
}

simulated function Tick(float DeltaTime)
{
	local bbPlayer bbP;
	
	if ( Owner == None )
		return;
	
	if (Level.NetMode == NM_Client) {
	
		if (!bAlreadyHidden && Owner.IsA('bbPlayer') && bbPlayer(Owner).Player != None) {
			Texture = None;
			LightType = LT_None;
			SetCollisionSize(0, 0);
			bAlreadyHidden = True;
			Destroy();
			return;
		}
		
		if (NN_OwnerPing > 0)
		{
			if (NN_EndAccelTime == 0)
			{
				Velocity *= 2;
				NN_EndAccelTime = Level.TimeSeconds + NN_OwnerPing * Level.TimeDilation / 2500;
				//for (P = Level.PawnList; P != None; P = P.NextPawn)
				ForEach AllActors(class'bbPlayer', bbP)
					if ( Viewport(bbP.Player) != None )
						NN_EndAccelTime += bbP.PlayerReplicationInfo.Ping * Level.TimeDilation / 2500;
			}
			else if (Level.TimeSeconds > NN_EndAccelTime)
			{
				Velocity = Velocity / 2;
				NN_OwnerPing = 0;
			}
		}
		
	}
	
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
	local bbPlayer bbP;
	
	if (bDeleteMe)
		return;
	if (!bbPlayer(Owner).bNewNet)
		HurtRadius(Damage, 70, MyDamageType, MomentumTransfer, Location );
	
	DoExplode(Damage, HitLocation, HitNormal);
	PlayOwnedSound(ImpactSound, SLOT_Misc, 0.5,,, 0.5+FRand());
	
	bbP = bbPlayer(Instigator);
	if (bbP != None && Level.NetMode != NM_Client)
	{
		bbP.xxNN_ClientProjExplode(zzNN_ProjIndex, HitLocation, HitNormal);
	}
	
	Destroy();
}

simulated function DoExplode(int Dmg, vector HitLocation,vector HitNormal)
{
	local PlayerPawn P;
	local Actor CR;

	if (RemoteRole < ROLE_Authority) {
		//for (P = Level.PawnList; P != None; P = P.NextPawn)
		ForEach AllActors(class'PlayerPawn', P)
			if (P != Instigator) {
				if (Dmg > 60)
					CR = P.Spawn(class'ut_RingExplosion3',P,, HitLocation+HitNormal*8,rotator(HitNormal));
				else
					CR = P.Spawn(class'ut_RingExplosion',P,, HitLocation+HitNormal*8,rotator(Velocity));
				CR.bOnlyOwnerSee = True;
			}
	}
}

function SuperExplosion()	// aka, combo.
{	
	if (!bbPlayer(Owner).bNewNet)
		HurtRadius(Damage*3, 250, MyDamageType, MomentumTransfer*2, Location );
	
	DoSuperExplosion();
	PlayOwnedSound(ExploSound,,20.0,,2000,0.6);
	//Spawn(Class'ut_ComboRing',,'',Location, Instigator.ViewRotation);
	//PlaySound(ExploSound,,20.0,,2000,0.6);
	if (bbPlayer(Instigator) != None)
		bbPlayer(Instigator).xxNN_ClientProjExplode(-1*(zzNN_ProjIndex + 1));
	
	Destroy(); 
}

simulated function DoSuperExplosion()
{
	local PlayerPawn P;
	local Actor CR;

	if (RemoteRole < ROLE_Authority) {
		//for (P = Level.PawnList; P != None; P = P.NextPawn)
		ForEach AllActors(class'PlayerPawn', P)
			if (P != Owner) {
				CR = P.Spawn(Class'ut_ComboRing',P,'',Location, Pawn(Owner).ViewRotation);
				CR.bOnlyOwnerSee = True;
			}
	}
}

function SuperDuperExplosion()	// aka, combo.
{	
	if (!bbPlayer(Owner).bNewNet)
		HurtRadius(Damage*9, 750, MyDamageType, MomentumTransfer*6, Location );
	DoSuperDuperExplosion();
	PlayOwnedSound(ExploSound,,20.0,,2000,0.6);
	//Spawn(Class'UT_SuperComboRing',,'',Location, Instigator.ViewRotation);
	//PlaySound(ExploSound,,20.0,,2000,0.6);
	if (bbPlayer(Instigator) != None)
		bbPlayer(Instigator).xxNN_ClientProjExplode(-1*(zzNN_ProjIndex + 1));
	
	Destroy(); 
}

simulated function DoSuperDuperExplosion()
{
	local PlayerPawn P;
	local Actor CR;

	if (RemoteRole < ROLE_Authority) {
		//for (P = Level.PawnList; P != None; P = P.NextPawn)
		ForEach AllActors(class'PlayerPawn', P)
			if (P != Owner) {
				CR = P.Spawn(Class'UT_SuperComboRing',P,'',Location, Pawn(Owner).ViewRotation);
				CR.bOnlyOwnerSee = True;
			}
	}
}

defaultproperties
{
     bOwnerNoSee=True
}
