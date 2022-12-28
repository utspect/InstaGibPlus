class NewNetSA extends Arena;

var WeaponSettings WeaponSettings;
var WeaponSettingsRepl WSettingsRepl;

function InitializeSettings() {
    class'WeaponSettingsRepl'.static.CreateWeaponSettings(Level, "WeaponSettingsNewNet", WeaponSettings, WSettingsRepl);
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