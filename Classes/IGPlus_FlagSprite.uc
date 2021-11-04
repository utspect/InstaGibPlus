class IGPlus_FlagSprite extends Actor;

#exec Texture Import File=Textures\Flag.pcx Mips=Off
#exec Texture Import File=Textures\FlagRed.pcx Mips=Off
#exec Texture Import File=Textures\FlagBlue.pcx Mips=Off
#exec Texture Import File=Textures\FlagGreen.pcx Mips=Off
#exec Texture Import File=Textures\FlagGold.pcx Mips=Off

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
