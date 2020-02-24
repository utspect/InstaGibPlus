class PureAssaultHUD expands AssaultHUD;

simulated function DrawStatus(Canvas Canvas)
{
	local float StatScale, ChestAmount, ThighAmount, H1, H2, X, Y, XL, DamageTime;
	Local int ArmorAmount,CurAbs,i,OverTime;
	Local inventory Inv,BestArmor;
	local bool bChestArmor, bShieldbelt, bThighArmor, bJumpBoots, bHasDoll;
	local Bot BotOwner;
	local TournamentPlayer TPOwner;
	local texture Doll, DollBelt;
	local int BootCharges;

	ArmorAmount = 0;
	CurAbs = 0;
	i = 0;
	BestArmor=None;
	for( Inv=PawnOwner.Inventory; Inv!=None; Inv=Inv.Inventory )
	{ 
		if (Inv.bIsAnArmor) 
		{
			if ( Inv.IsA('UT_Shieldbelt') )
				bShieldbelt = true;
			else if ( Inv.IsA('Thighpads') )
			{
				ThighAmount += Inv.Charge;
				bThighArmor = true;
			}
			else
			{ 
				bChestArmor = true;
				ChestAmount += Inv.Charge;
			}
			ArmorAmount += Inv.Charge;
		}
		else if ( Inv.IsA('UT_JumpBoots') )
		{
			bJumpBoots = true;
			BootCharges = Inv.Charge;
		}
		else
		{
			i++;
			if ( i > 100 )
				break; // can occasionally get temporary loops in netplay
		}
	}

	if ( !bHideStatus )
	{	
		TPOwner = TournamentPlayer(PawnOwner);
		if ( Canvas.ClipX < 400 )
			bHasDoll = false;
		else if ( TPOwner != None)
		{
			Doll = TPOwner.StatusDoll;
			DollBelt = TPOwner.StatusBelt;
			bHasDoll = true;
		}
		else
		{
			BotOwner = Bot(PawnOwner);
			if ( BotOwner != None )
			{
				Doll = BotOwner.StatusDoll;
				DollBelt = BotOwner.StatusBelt;
				bHasDoll = true;
			}
		}
		if ( bHasDoll )
		{ 							
			Canvas.Style = ERenderStyle.STY_Translucent;
			StatScale = Scale * StatusScale;
			X = Canvas.ClipX - 128 * StatScale;
			Canvas.SetPos(X, 0);
			if (PawnOwner.DamageScaling > 2.0)
				Canvas.DrawColor = PurpleColor;
			else
				Canvas.DrawColor = HUDColor;
			Canvas.DrawTile(Doll, 128*StatScale, 256*StatScale, 0, 0, 128.0, 256.0);
			Canvas.DrawColor = HUDColor;
			if ( bShieldBelt )
			{
				Canvas.DrawColor = BaseColor;
				Canvas.DrawColor.B = 0;
				Canvas.SetPos(X, 0);
				Canvas.DrawIcon(DollBelt, StatScale);
			}
			if ( bChestArmor )
			{
				ChestAmount = FMin(0.01 * ChestAmount,1);
				Canvas.DrawColor = HUDColor * ChestAmount;
				Canvas.SetPos(X, 0);
				Canvas.DrawTile(Doll, 128*StatScale, 64*StatScale, 128, 0, 128, 64);
			}
			if ( bThighArmor )
			{
				ThighAmount = FMin(0.02 * ThighAmount,1);
				Canvas.DrawColor = HUDColor * ThighAmount;
				Canvas.SetPos(X, 64*StatScale);
				Canvas.DrawTile(Doll, 128*StatScale, 64*StatScale, 128, 64, 128, 64);
			}
			if ( bJumpBoots )
			{
				Canvas.DrawColor = HUDColor;
				Canvas.SetPos(X, 128*StatScale);
				Canvas.DrawTile(Doll, 128*StatScale, 64*StatScale, 128, 128, 128, 64);
			}
			Canvas.Style = Style;
			if ( (PawnOwner == PlayerOwner) && Level.bHighDetailMode && !Level.bDropDetail )
			{
				for ( i=0; i<4; i++ )
				{
					DamageTime = Level.TimeSeconds - HitTime[i];
					if ( DamageTime < 1 )
					{
						Canvas.SetPos(X + HitPos[i].X * StatScale, HitPos[i].Y * StatScale);
						if ( (HUDColor.G > 100) || (HUDColor.B > 100) )
							Canvas.DrawColor = RedColor;
						else
							Canvas.DrawColor = (WhiteColor - HudColor) * FMin(1, 2 * DamageTime);
						Canvas.DrawColor.R = 255 * FMin(1, 2 * DamageTime);
						Canvas.DrawTile(Texture'BotPack.HudElements1', StatScale * HitDamage[i] * 25, StatScale * HitDamage[i] * 64, 0, 64, 25.0, 64.0);
					}
				}
			}
		}
	}
	Canvas.DrawColor = HUDColor;
	if ( bHideStatus && bHideAllWeapons )
	{
		X = 0.5 * Canvas.ClipX;
		Y = Canvas.ClipY - 64 * Scale;
	}
	else
	{
		X = Canvas.ClipX - 128 * StatScale - 140 * Scale;
		Y = 64 * Scale;
	}
	Canvas.SetPos(X,Y);
	if ( PawnOwner.Health < 50 )
	{
		H1 = 1.5 * TutIconBlink;
		H2 = 1 - H1;
		Canvas.DrawColor = WhiteColor * H2 + (HUDColor - WhiteColor) * H1;
	}
	else
		Canvas.DrawColor = HUDColor;
	Canvas.DrawTile(Texture'BotPack.HudElements1', 128*Scale, 64*Scale, 128, 128, 128.0, 64.0);

	if ( PawnOwner.Health < 50 )
	{
		H1 = 1.5 * TutIconBlink;
		H2 = 1 - H1;
		Canvas.DrawColor = Canvas.DrawColor * H2 + (WhiteColor - Canvas.DrawColor) * H1;
	}
	else
		Canvas.DrawColor = WhiteColor;

	DrawBigNum(Canvas, Max(0, PawnOwner.Health), X + 4 * Scale, Y + 16 * Scale, 1);

	Canvas.DrawColor = HUDColor;

	if ( bHideStatus && bHideAllWeapons )
	{
		X = 0.5 * Canvas.ClipX - 128 * Scale;
		Y = Canvas.ClipY - 64 * Scale;
	}
	else
	{
		X = Canvas.ClipX - 128 * StatScale - 140 * Scale;
		Y = 0;
	}
	Canvas.SetPos(X, Y);
	Canvas.DrawTile(Texture'BotPack.HudElements1', 128*Scale, 64*Scale, 0, 192, 128.0, 64.0);
	if ( bHideStatus && bShieldBelt )
		Canvas.DrawColor = GoldColor;
	else
		Canvas.DrawColor = WhiteColor;
	DrawBigNum(Canvas, Min(150,ArmorAmount), X + 4 * Scale, Y + 16 * Scale, 1);

	if ((bbPlayer(PlayerOwner) != None && bbPlayer(PlayerOwner).HUDInfo > 0) || bbCHSpectator(PlayerOwner) != None)
	{
		Canvas.DrawColor = HUDColor;

        i = PlayerOwner.GameReplicationInfo.RemainingTime;
        if (i == 0)
        {
            i = PlayerOwner.GameReplicationInfo.ElapsedTime;
            if (OverTime < 0)
                OverTime = i;
            if (OverTime > 0)
                i = OverTime - i;
        }
        else
            OverTime = -1;

		XL = 0;
		if ( i/60 > 199 )
			XL = 25;
		else if ( i/60 > 99 )
			XL = 15;

        if ( bHideStatus && bHideAllWeapons )
        {
            X = 0.5 * Canvas.ClipX - 384 * Scale - XL * Scale;
            Y = Canvas.ClipY - 64 * Scale;
        }
        else
        {
            X = Canvas.ClipX - 128 * StatScale - 140 * Scale - XL * Scale;
            Y = 128 * Scale;
        }

        Canvas.SetPos(X,Y);
        Canvas.DrawTile(Texture'PureTimeBG', 128*Scale + XL * Scale, 64*Scale, 0, 0, 128.0, 64.0);
        Canvas.Style = Style;
        Canvas.DrawColor = WhiteColor;
		//Class'PureHUDHelper'.Static.DrawTime(Canvas, X + 64 * Scale, Y + 32 * Scale, PlayerOwner);
		DrawTime(Canvas, X, Y, i, XL);

		if (bJumpBoots)
		{
			Canvas.DrawColor = HUDColor;
			if ( bHideStatus && bHideAllWeapons )
			{	// Draw after ammo.
				X = 0.5 * Canvas.ClipX + 256 * Scale;
				Y = Canvas.ClipY - 64 * Scale;
			}
			else
			{
				X = Canvas.ClipX - 128 * StatScale - 140 * Scale;
				Y = 192 * Scale;
			}
			Canvas.SetPos(X,Y);
			Canvas.DrawTile(Texture'PureBoots', 128*Scale, 64*Scale, 0, 0, 128.0, 64.0);
			Canvas.DrawColor = WhiteColor;
			DrawBigNum(Canvas, BootCharges, X + 4 * Scale, Y + 16 * Scale, 1);
		}
	}
}

simulated function DrawTime(Canvas Canvas, float X, float Y, int Seconds, float ExtraSize)
{
	local int Min, Sec;
	local float FullSize;

	Min = Seconds / 60;
	Sec = Seconds % 60;
	X += ExtraSize * Scale;

	if ( Level.bHighDetailMode )
		Canvas.Style = ERenderStyle.STY_Translucent;

	FullSize = 25 * Scale * 4 + 16 * Scale; //At least 4 digits and : (extra size not counted)

	Canvas.SetPos( X + 64 * Scale, Y + 12 * Scale);
	Canvas.CurX -= (FullSize / 2);
	if ( Min >= 100 )
	{
		Canvas.CurX -= ExtraSize * Scale;
		Canvas.DrawTile(Texture'BotPack.HudElements1', Scale*ExtraSize, 64*Scale, ((Min / 100)%10) * 25 + (25 - ExtraSize), 0, ExtraSize, 64.0);
	}
	Canvas.DrawTile(Texture'BotPack.HudElements1', Scale*25, 64*Scale, ((Min/10)%10) *25, 0, 25.0, 64.0);
	Canvas.DrawTile(Texture'BotPack.HudElements1', Scale*25, 64*Scale, (Min%10)*25, 0, 25.0, 64.0);
	Canvas.CurX -= 6 * Scale;
	Canvas.DrawTile(Texture'BotPack.HudElements1', Scale*25, 64*Scale, 25, 64, 25.0, 64.0); //DOUBLE DOT HERE
	Canvas.CurX -= 6 * Scale;
	Canvas.DrawTile(Texture'BotPack.HudElements1', Scale*25, 64*Scale, ((Sec/10)%10) *25, 0, 25.0, 64.0);
	Canvas.DrawTile(Texture'BotPack.HudElements1', Scale*25, 64*Scale, (Sec%10)*25, 0, 25.0, 64.0);
}