// ============================================================
// LlamaMessage
// ============================================================
class LlamaMessage extends CriticalEventPlus;

var localized string LlamaMessages[10];

static final function ReplaceText(out string Text, coerce string Replace, coerce string With)
{
	local int i;
	local string Input;

	Input = Text;
	Text = "";
	i = InStr(Input, Replace);
	while (i != -1) {
		Text = Text $ Left(Input, i) $ With;
		Input = Mid(Input, i + Len(Replace));
		i = InStr(Input, Replace);
	}
	Text = Text $ Input;
}

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	local string Msg;

	Msg = Default.LlamaMessages[Rand(10)];
	if ( RelatedPRI_1 != None )
		ReplaceText(Msg, "%k", RelatedPRI_1.PlayerName);
	if ( RelatedPRI_2 != None )
		ReplaceText(Msg, "%o", RelatedPRI_2.PlayerName);

	return Msg;
}

defaultproperties
{
      LlamaMessages(0)="Houston, we have a Llama."
      LlamaMessages(1)="Telefragging is not allowed here."
      LlamaMessages(2)="%k tried to telefrag %o, but Failed!"
      LlamaMessages(3)="%o is laughing at you %k"
      LlamaMessages(4)="%k  telefragger wannabe"
      LlamaMessages(5)="FAIL %k"
      LlamaMessages(6)="%k it was good, but its not quite right!"
      LlamaMessages(7)="Anyone else what to telefrag?"
      LlamaMessages(8)="%o Was Very Happy that %k's is a bit stupid."
      LlamaMessages(9)="%k went BOOM!"
      bBeep=False
      Lifetime=4
}
