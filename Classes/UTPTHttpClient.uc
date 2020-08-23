class UTPTHttpClient expands UBrowserHTTPClient;

function HTTPReceivedData(string Data) {
   Log(Data);
   Super.HTTPReceivedData(Data);
}

function HTTPError(int Code) {
   Log("We have an error:"@Code);
}

defaultproperties
{
   
}