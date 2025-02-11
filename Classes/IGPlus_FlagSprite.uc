class IGPlus_FlagSprite extends Actor;

simulated function ConfigureForTeam(byte Team) {
	switch(Team) {
		case 0:
			Texture = Texture'FlagRed';
			break;

		case 1:
			Texture = Texture'FlagBlue';
			break;

		case 2:
			Texture = Texture'FlagGreen';
			break;

		case 3:
			Texture = Texture'FlagGold';
			break;

		default:
			Texture = Texture'Flag';
			break;
	}
}

defaultproperties {
	DrawType=DT_Sprite
	Style=STY_Translucent
	Texture=Texture'Flag'

	RemoteRole=ROLE_None
	bHidden=True
}
