class IGPlus_EditBox extends UWindowEditBox;

var bool bNumericNegative;

function KeyType(int Key, float MouseX, float MouseY) {
	if (bCanEdit == false || bKeyDown == false)
		return;

	if (bControlDown)
		return;

	if (bAllSelected)
		Clear();

	bAllSelected = False;

	if (bNumericOnly) {
		if (Key >= 0x30 && Key <= 0x39)
			Insert(Key);
		if (bNumericNegative) {
			if (Key == 0x2D && Left(Value, 1) != "-") {
				Value = "-"$Value;
				CaretOffset += 1;

				if (bDelayedNotify)
					bChangePending = true;
				else
					Notify(DE_Change);
			} else if (Key == 0x2B && Left(Value, 1) == "-") {
				Value = Mid(Value, 1);
				CaretOffset -= 1;

				if (bDelayedNotify)
					bChangePending = true;
				else
					Notify(DE_Change);
			}
		}
	} else {
		if (Key >= 0x20 && Key < 0x80)
			Insert(Key);
	}
}