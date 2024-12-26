class NewNetSA extends Arena;
// Description="SniperArena with lag-compensated SniperRifle"

var IGPlus_WeaponImplementation WImp;

function InitializeSettings() {
    WImp = Spawn(class'IGPlus_WeaponImplementationBase');
    WImp.InitWeaponSettings("WeaponSettingsNewNet");
}

function PreBeginPlay() {
    super.PreBeginPlay();

    InitializeSettings();
}


defaultproperties
{
    WeaponName=NN_SniperArenaRifle
    AmmoName=BulletBox
    AmmoString="Botpack.BulletBox"
    DefaultWeapon=class'NN_SniperArenaRifle'
}