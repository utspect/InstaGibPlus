class IGPlus_GameEventChain extends Object;

var IGPlus_GameEvent Newest;

function Play(float T) {
	local IGPlus_GameEvent E;

	E = new class'IGPlus_GameEvent';
	E.Play(T);
	E.Next = Newest;
	Newest = E;
}

function Pause(float T) {
	local IGPlus_GameEvent E;

	E = new class'IGPlus_GameEvent';
	E.Pause(T);
	E.Next = Newest;
	Newest = E;
}

function bool IsPlaying() {
	return Newest.IsPlaying();
}

function bool IsPaused() {
	return Newest.IsPaused();
}

function float RealPlayTime(float TimeStamp, float DeltaTime) {
	local float RealTime;
	local float SegmentTime;
	local IGPlus_GameEvent E;

	for(E = Newest; DeltaTime > 0; E = E.Next) {
		SegmentTime = FMin(DeltaTime, (TimeStamp - E.TimeStamp));
		if (E.IsPlaying()) {
			RealTime += SegmentTime;
		}
		DeltaTime -= SegmentTime;
	}

	return RealTime;
}
