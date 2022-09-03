class Math extends Object;

// Smallest value so that 1.0+FloatEpsilon != 1.0
var const float FloatEpsilon;
// Smallest normalized positive value
var const float FloatMin;
// Largest value
var const float FloatMax;

static final function int Round(float A) {
	if (A < 0.0)
		return int(A - 0.5);
	return int(A + 0.5);
}

static final function int Floor(float A) {
	if (A < 0.0)
		return int(A - (1.0-CalcEpsilon(A)));
	return int(A);
}

static final function int Ceil(float A) {
	if (A < 0.0)
		return int(A);
	return int(A + (1.0-CalcEpsilon(A)));
}

static final function float Sign(float A) {
	if (A == 0.0) {
		return 1.0;
	} else if (A > default.FloatMax) {
		return 1.0;
	} else if (A < -default.FloatMax) {
		return -1.0;
	}
	return A / Abs(A);
}

static final function bool IsNan(float A) {
	return A != A;
}

static final function bool IsInf(float A) {
	return A > default.FloatMax || A < -default.FloatMax;
}

static final function bool IsDenorm(float A) {
	return Abs(A) < default.FloatMin;
}

static final function float CalcEpsilon(float A) {
	return A * default.FloatEpsilon;
}

static final function int IAbs(int A) {
	if (A < 0)
		return -A;
	return A;
}

defaultproperties {
	FloatEpsilon=0.0000001192092896
	FloatMin=1.175494351e-38
	FloatMax=3.402823466e+38
}
