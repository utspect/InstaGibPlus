class MMultiKillMessage extends LocalMessagePlus;

#exec OBJ LOAD FILE=..\Sounds\Announcer.uax PACKAGE=Announcer

var(Messages)   localized string    DoubleKillString;
var(Messages)	localized string 	TripleKillString;
var(Messages)   localized string    MultiKillString;
var(Messages)   localized string    MegaKillString;
var(Messages)   localized string    UltraKillString;
var(Messages)   localized string    MonsterKillString;
var(Messages)   localized string    LudicrousKillString;
var(Messages)   localized string    HolyShitString;

static function float GetOffset(int Switch, float YL, float ClipY )
{
    return (Default.YPos/768.0) * ClipY + YL;
}

static function int GetFontSize( int Switch )
{
    if ( Switch == 1 )
        return Default.FontSize;
    else
        return 2;
}

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    /* switch (Switch)
    {
        case 1:
            return Default.DoubleKillString;
            break;
        case 2:
            return Default.TripleKillString;
            break;
        case 3:
            return Default.MultiKillString;
            break;
        case 4:
            return Default.MegaKillString;
            break;
        case 5:
            return default.UltraKillString;
            break;
        case 6:
            return Default.MonsterKillString;
            break;
        case 7:
            return Default.LudicrousKillString;
            break;
        case 8:
        case 9:
        case 10:
        case 11:
        case 12:
        case 13:
        case 14:
        case 15:
        case 16:
        case 17:
        case 18:
        case 19:
        case 20:
            return Default.HolyShitString;
            break;
    } */

    switch (Switch)
    {
        case 1:
            return Default.DoubleKillString;
            break;
        case 2:
            return Default.MultiKillString;
            break;
        case 3:
            return Default.UltraKillString;
            break;
        case 4:
            return Default.MonsterKillString;
            break;
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
        case 11:
        case 12:
        case 13:
        case 14:
        case 15:
        case 16:
        case 17:
        case 18:
        case 19:
        case 20:
    return "";
    }
}

static simulated function ClientReceive(
    PlayerPawn P,
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

    /* switch (Switch)
    {
        case 1:
            P.ClientPlaySound(sound'DoubleKill',, true);
            break;
        case 2:
            P.ClientPlaySound(sound'TripleKill',, true);
            break;
        case 3:
            P.ClientPlaySound(sound'MultiKill',, true);
            break;
        case 4:
            P.ClientPlaySound(sound'MegaKill',, true);
            break;
        case 5:
            P.ClientPlaySound(sound'UltraKill',, true);
            break;
        case 6:
            P.ClientPlaySound(sound'MonsterKill',, true);
            break;
        case 7:
            P.ClientPlaySound(sound'LudicrousKill',, true);
            break;
        case 8:
        case 9:
        case 10:
        case 11:
        case 12:
        case 13:
        case 14:
        case 15:
        case 16:
        case 17:
        case 18:
        case 19:
        case 20:
            P.ClientPlaySound(sound'HolyShit',, true);
            break;
    } */

    switch (Switch)
    {
        case 1:
            P.ClientPlaySound(sound'DoubleKill',, true);
            break;
        case 2:
            P.ClientPlaySound(sound'MultiKill',, true);
            break;
        case 3:
            P.ClientPlaySound(sound'UltraKill',, true);
            break;
        case 4:
            P.ClientPlaySound(sound'MonsterKill',, true);
            break;
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
        case 11:
        case 12:
        case 13:
        case 14:
        case 15:
        case 16:
        case 17:
        case 18:
        case 19:
        case 20:
    }
}

static function color GetColor( optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2 )
{
  local Color cres;

  cres = Default.DrawColor;
  if( Switch >= 1 && Switch <= 5 )
  {
    //cres.G = 48 * ( 5 - Switch );
    return cres;
  }
  else if( Switch > 5 )
  {
    //cres.B = Min( 48 * ( Switch - 5 ), 255 );
    return cres;
  }
  else
  {
    return cres;
  }
}

defaultproperties
{
     DoubleKillString="Double Kill!"
     TripleKillString="Triple Kill!"
     MultiKillString="Multi Kill!"
     MegaKillString="Mega Kill!"
     UltraKillString="ULTRA KILL!!"
     MonsterKillString="M O N S T E R  K I L L !!!"
     LudicrousKillString="L U D I C R O U S  K I L L !!!"
     HolyShitString="H O L Y  S H I T!!!"
     FontSize=1
     bIsSpecial=True
     bIsUnique=True
     bFadeMessage=True
     DrawColor=(G=0,B=0)
     YPos=196.000000
     bCenter=True
}