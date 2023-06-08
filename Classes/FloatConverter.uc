// Copied from here: https://wiki.beyondunreal.com/User:Wormbo/Random_useful_code_snippets#Float_to_int_cast
class FloatConverter extends Object abstract;

var float Value;

static final function int ToInt(float V) {
    default.Value = V;
    return Super(IntConverter).ReturnInt();
}

static final function float ReturnFloat() {
    return default.Value;
}
