class IGPlus_GameEvent extends Object;

var IGPlus_GameEvent Next;

enum EGameState {
	GS_Unknown,
	GS_Play,
	GS_Pause
};

var float TimeStamp;
var EGameState GameState;

function Play(float T) {
	TimeStamp = T;
	GameState = GS_Play;
}

function Pause(float T) {
	TimeStamp = T;
	GameState = GS_Pause;
}

function bool IsPlaying() {
	return GameState == GS_Play;
}

function bool IsPaused() {
	return GameState == GS_Pause;
}

