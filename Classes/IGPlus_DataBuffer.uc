class IGPlus_DataBuffer extends Object;

var int NumBits;
var int BitsData[20];

var int NumBitsConsumed;

static final function or_eq (out int A, int B) {
	A = A | B;
}

final function Reset() {
	local int i;
	NumBits = 0;
	for (i = 0; i < arraycount(BitsData); i++)
		BitsData[i] = 0;
	NumBitsConsumed = 0;
}

//
// Writing to this Buffer
//

final function int GetSpace() {
	return arraycount(BitsData) * 32;
}

final function int GetSpaceRemaining() {
	return (arraycount(BitsData) * 32) - NumBits;
}

final function bool IsSpaceSufficient(int ReqBits) {
	return (NumBits + ReqBits <= arraycount(BitsData) * 32);
}

final function AddBits(int Num, int Bits) {
	local int Index;
	local int Offset;
	local int IntRem;

	Index = NumBits >>> 5;
	Offset = NumBits & 0x1F;
	IntRem = 32 - Offset;

	if (Num > IntRem) {
		BitsData[Index] = BitsData[Index] | Bits << Offset;
		Bits = Bits >>> IntRem;
		Num -= IntRem;
		NumBits += IntRem;

		Index++;
		Offset = 0;
	}

	if (Num == 32) {
		BitsData[Index] = Bits;
	} else {
		BitsData[Index] = BitsData[Index] | ((Bits & ((1 << Num) - 1)) << Offset);
	}

	NumBits += Num;
}

final function AddFloat(float F) {
	AddBits(32, class'FloatConverter'.static.ToInt(F));
}

final function AddBit(bool Bit) {
	if (Bit) or_eq(BitsData[NumBits >>> 5], 1 << (NumBits & 0x1F));
	NumBits++;
}

//
// Reading from this Buffer
//

final function bool IsDataSufficient(int ReqBits) {
	return (NumBitsConsumed + ReqBits <= NumBits);
}

final function ConsumeBits(int Num, out int Bits) {
	local int Index;
	local int Offset;
	local int Over;

	Index = NumBitsConsumed >>> 5;
	Offset = NumBitsConsumed & 0x1F;
	Bits = 0;

	if (Num + Offset > 32) {
		Over = (32 - Offset);
		or_eq(Bits, (BitsData[Index + 1] & ((1 << Num - Over) - 1)) << Over);
		NumBitsConsumed += (Num - Over);
		Num = Over;
	}

	if (Num == 32) {
		Bits = BitsData[Index];
	} else {
		or_eq(Bits, (BitsData[Index] >>> Offset) & ((1 << Num) - 1));
	}

	NumBitsConsumed += Num;
}

final function ConsumeBit(out int Bit) {
	Bit = (BitsData[NumBitsConsumed>>>5] & (1 << (NumBitsConsumed&0x1F)));
	NumBitsConsumed++;
}

final function ConsumeFloat(out float F) {
	local int V;
	ConsumeBits(32, V);
	F = class'IntConverter'.static.ToFloat(V);
}
