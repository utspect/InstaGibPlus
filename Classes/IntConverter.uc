// Copied from here: https://wiki.beyondunreal.com/User:Wormbo/Random_useful_code_snippets#Float_to_int_cast
class IntConverter extends Object abstract;

var int Value;

static final function float ToFloat(int V) {
    default.Value = V;
    return Super(FloatConverter).ReturnFloat();
}

static final function int ReturnInt() {
    return default.Value;
}
