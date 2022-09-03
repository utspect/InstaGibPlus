class NewNetSA extends Arena;

var Object WeaponSettingsHelper;
var WeaponSettings WeaponSettings;

function PreBeginPlay() {
     super.PreBeginPlay();

     WeaponSettingsHelper = new(none, 'InstaGibPlus') class'Object';
     WeaponSettings = new(WeaponSettingsHelper, 'WeaponSettingsNewNet') class'WeaponSettings';
     WeaponSettings.SaveConfig();
}


defaultproperties
{
     WeaponName=NN_SniperArenaRifle
     AmmoName=BulletBox
     AmmoString="Botpack.BulletBox"
     DefaultWeapon=class'NN_SniperArenaRifle'
}