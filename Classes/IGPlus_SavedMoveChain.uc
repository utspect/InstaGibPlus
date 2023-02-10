class IGPlus_SavedMoveChain extends Actor;

var IGPlus_SavedMove2 Newest;
var IGPlus_SavedMove2 Oldest;

var IGPlus_SavedMove2 SpareNodes;

final function IGPlus_SavedMove2 AllocateNode() {
	local IGPlus_SavedMove2 Node;
	if (SpareNodes != none) {
		Node = SpareNodes;
		SpareNodes = Node.Next;
	} else {
		Node = Spawn(class'IGPlus_SavedMove2');
	}

	Node.Initialize();
	return Node;
}

final function FreeNode(IGPlus_SavedMove2 Node) {
	if (Node.Prev != none)
		Node.Prev.Next = Node.Next;
	if (Node.Next != none)
		Node.Next.Prev = Node.Prev;

	if (Node == Oldest)
		Oldest = Node.Next;
	if (Node == Newest)
		Newest = Node.Prev;

	Node.Next = SpareNodes;
	Node.Prev = none;

	SpareNodes = Node;
}

final function Add(float Delta, bbPlayer P) {
	local IGPlus_SavedMove2 Node;

	Node = AllocateNode();
	Node.CopyFrom(Delta, P);
	if (AppendNode(Node) == false)
		FreeNode(Node);
}

final function bool AppendNode(IGPlus_SavedMove2 Node) {
	if (Newest == none) {
		Oldest = Node;
		Newest = Node;
	} else {
		if (Newest.TimeStamp >= Node.TimeStamp - 0.5*Node.Delta)
			return false;

		Node.Prev = Newest;
		Newest.Next = Node;
		Newest = Node;
	}
	return true;
}

final function RemoveOutdatedNodes(float CurrentTimeStamp) {
	if (Oldest != none)
		while(Oldest.Next != none && Abs(Oldest.TimeStamp-CurrentTimeStamp) > Abs(Oldest.Next.TimeStamp-CurrentTimeStamp))
			FreeNode(Oldest);
}


final function IGPlus_SavedMove2 SerializeNodes(int MaxNumNodes, IGPlus_DataBuffer B) {
	if (Newest != none)
		return Newest.SerializeNodes(MaxNumNodes, none, B, 0);
	return none;
}

defaultproperties {
	bHidden=True
	DrawType=DT_None
	RemoteRole=ROLE_None
}
