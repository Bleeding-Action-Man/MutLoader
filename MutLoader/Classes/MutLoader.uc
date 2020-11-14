///////////////////////////////////////////////////
// Modified version of MutLoader with multiple
// Settings support, GameTypes, GameDifficulty &
// Server Name change
// By Flame, Essence & Vel-San
///////////////////////////////////////////////////

class MutLoader extends Mutator Config(MutLoaderV2);

var config bool bDebug;
var string sServerName;

function PreBeginPlay()
{
	// Vars
	local array<MutLoaderObject> MutLoaderRecords;
	local array<string> MutatorList;
	local array<string> Names;
	local int i;

	Super.PreBeginPlay();

	//////////////////// Essence & Vel-San ///////////
	Names=Class'MutLoaderObject'.Static.GetPerObjectNames("MutLoaderV2");
	for(i=0; i<Names.Length; i++) MutLoaderRecords[i]=New(None, Names[i]) Class'MutLoaderObject';
	for(i=0; i<MutLoaderRecords.Length; i++)
	{
		if	(
				MutLoaderRecords[i].GameTypeName==string(Level.Game.Class.Name)
				&& MutLoaderRecords[i].GameDifficulty==Level.Game.GameDifficulty
			)
		{
			MutLog("-----|| Using MutLoader Config # [" $i$ "]; Total Configs Found: " $MutLoaderRecords.Length$ " ||-----");
			MutatorList=MutLoaderRecords[i].Mutator;
			if (MutLoaderRecords[i].ServerName != "") sServerName = MutLoaderRecords[i].ServerName;
			Break;
		}
	}
	//////////////////////////////////////////////////
	for(i=0; i<MutatorList.Length; i++)
	{
		if	(
				MutatorList[i]==""
				|| MutatorList[i]==string(Self.Class)
			)
		{
			Continue;
		}
		else
		{
			Level.Game.AddMutator(MutatorList[i], True);
			if(bDebug) MutLog("-----|| Mutator Added =>"@MutatorList[i]$ " ||-----");
		}
	}
}

function Tick(float DeltaTime)
{
	if(bDebug)
	{
		TimeStampLog("-----|| TICK - Default ServerName: " $Level.GRI.ServerName$ " ||-----");
		TimeStampLog("-----|| TICK - 'MutLoader' ServerName: " $sServerName$ " ||-----");
	}
	Level.GRI.ServerName = sServerName;
	if(bDebug) TimeStampLog("-----|| TICK - Updated Default ServerName: " $Level.GRI.ServerName$ " ||-----");
	Disable('Tick');
}

function TimeStampLog(coerce string s)
{
  log("["$Level.TimeSeconds$"s]" @ s, 'MutLoaderV2');
}

function MutLog(string s)
{
  log(s, 'MutLoaderV2');
}

defaultproperties
{
	bDebug=True
	GroupName="KF-MutLoaderV2"
	FriendlyName="MutLoader - v2.0"
	Description="seamlessly load mutators With optimized config (Difficulty, ServerName, Several GameTypes); By Flame, Essence & Vel-San"
}
