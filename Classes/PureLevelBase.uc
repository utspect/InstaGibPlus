// ===============================================================
// UTPureRC7D.PureLevelBase: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class PureLevelBase extends Object;

struct xxURL
{
	var string zzProtocol;
	var string zzHost;
	var int zzPort;
	var string zzMap;
	var array<string> zzOp;
	var string zzPortal;
	var bool zzbvalid;
};

var private native const int zzNetNotify;		// Internal

var const Array<Object> zzActors;

var const Object zzLevel;

var const Object zzNetDriver;
var const Object zzEngine;
var const xxURL zzURL;
var const Object zzDemoRecDriver;

defaultproperties
{
}
