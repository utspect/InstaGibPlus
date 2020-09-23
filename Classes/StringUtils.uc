class StringUtils extends Object;

static function string PackageOfClass(class C) {
	local string Result;
	local int DotPos;

	Result = string(C);

	DotPos = InStr(Result, ".");
	if (DotPos < 0) return "";

	return Left(Result, DotPos);
}

static function string PackageOfObject(Object O) {
	return PackageOfClass(O.Class);
}

static function string GetPackage() {
	return PackageOfClass(class'StringUtils');
}

static function string RepeatString(int Length, string S) {
	local string result;

	if (Length <= 0 || Len(S) == 0) return "";

	while (Length > 0) {
		if ((Length & 1) == 1)
			result = result $ S;

		Length = Length >> 1;
		S = S $ S;
	}

	return result;
}

static function string RepeatChar(int Length, int Char) {
	if (Char == 0) return "";
	return RepeatString(Length, Chr(Char));
}

static function string CenteredString(coerce string Content, int Length, optional string Fill) {
	local string Dummy;

	if (Len(Fill) == 0) Fill = " ";

	if (Length <= Len(Content))
		return Content;

	Dummy = RepeatString((Length + 1 - Len(Content)) >> 1, Left(Fill, 1));

	return Left(Dummy, (Length - Len(Content)) >> 1) $ Content $ Left(Dummy, (Length + 1 - Len(Content)) >> 1);
}

static function string Trim(string source)
{
	local int index;
	local string result;

	// Remove leading spaces.
	result = source;
	while (index < len(result) && mid(result, index, 1) == " ")
        {
		index++;
	}
	result = mid(result, index);

	// Remove trailing spaces.
	index = len(result) - 1;
	while (index >= 0 && mid(result, index, 1) == " ")
        {
		index--;
	}
	result = left(result, index + 1);

	// Return new string.
	return result;
}
