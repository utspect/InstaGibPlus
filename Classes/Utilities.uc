class Utilities extends Object;

static function int IAbs(int A) {
	if (A < 0) return -A;
	return A;
}

// convert rotation representation from signed to unsigned
static function int RotS2U(int A) {
	return A & 0xFFFF;
}

// convert rotation representation from unsigned to signed
static function int RotU2S(int A) {
	return A << 16 >> 16;
}

static function rotator RotS2UR(rotator R) {
	R.Yaw = RotS2U(R.Yaw);
	R.Pitch = RotS2U(R.Pitch);
	R.Roll = RotS2U(R.Roll);
	return R;
}

static function rotator RotU2SR(rotator R) {
	R.Yaw = RotU2S(R.Yaw);
	R.Pitch = RotU2S(R.Pitch);
	R.Roll = RotU2S(R.Roll);
	return R;
}
