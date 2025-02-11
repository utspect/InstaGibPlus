// ====================================================================
//  Class:  UTPureRC4d.PureFlag
//  Parent: Botpack.GreenFlag
//
//  <Enter a description here>
// ====================================================================

class PureFlag extends GreenFlag;

event PreBeginPlay()
{
// Dont call PreBP or risk being Destroyed
}

event PostBeginPlay()
{
		loopanim('pflag',0.7);
		animframe = FRand();
}

function SendHome()
{
}

function Drop(vector newVel)
{
}

auto state Home
{
ignores Touch, Timer, BeginState, EndState;
}

defaultproperties
{
     Skin=Texture'PureFlag'
     bCollideWorld=False
     LightType=LT_None
     Team=2
}
