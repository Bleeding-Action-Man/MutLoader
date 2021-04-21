///////////////////////////////////////////////////
// Modified version of MutLoader with multiple
// Settings support, GameTypes, GameDifficulty &
// Server Name change
// By Flame, Essence & Vel-San
///////////////////////////////////////////////////

class MutLoader extends Mutator Config(MutLoaderV2);

// Local Vars
var string sServerName;
var bool AppendFaked, UpdateServerName;
var KFGameType KF;

function PreBeginPlay()
{
  // Vars
  local array<MutLoaderObject> MutLoaderRecords;
  local array<string> MutatorList;
  local array<string> Names;
  local int i;

  Names=Class'MutLoaderObject'.Static.GetPerObjectNames("MutLoaderV2");
  for(i=0; i<Names.Length; i++) MutLoaderRecords[i]=New(None, Names[i]) Class'MutLoaderObject';
  for(i=0; i<MutLoaderRecords.Length; i++)
  {
    if( MutLoaderRecords[i].sGameTypeName==string(Level.Game.Class.Name)
     && MutLoaderRecords[i].fGameDifficulty==Level.Game.GameDifficulty)
    {
      MutatorList=MutLoaderRecords[i].Mutator;
      MutLog("-----|| Adding [" $MutatorList.Length$ "] Mutators found in MutLoader Config # [" $i$ "]; Total Configs Found: " $MutLoaderRecords.Length$ " ||-----");
      if (MutLoaderRecords[i].bUpdateServerName)
      {
        sServerName = MutLoaderRecords[i].sServerName;
        UpdateServerName = true;
      }
      if (MutLoaderRecords[i].bAppendFaked) AppendFaked = true;
      Break;
    }
  }

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
      MutLog("-----|| Mutator Added =>"@MutatorList[i]$ " ||-----");
    }
  }
}

function PostBeginPlay()
{
  SetTimer(1, false);
}

function Timer()
{
  KF = KFGameType(Level.Game);
  TimeStampLog("-----|| Default ServerName: " $Level.GRI.ServerName$ " ||-----");

  // Check for FakedPlus
  if (AppendFaked) CheckMutators(sServerName);

  // Update Server Name
  if(UpdateServerName)
  {
    TimeStampLog("-----|| New ServerName: " $sServerName$ " ||-----");
    Level.GRI.ServerName = sServerName;
  }
  else TimeStampLog("-----|| Keeping Default Server Name ||-----");
}

// Detect FakedPlus Mutator and append 'xF' to ServerName
function CheckMutators(out string ServerName)
{
  local Mutator M;

  for ( M = KF.BaseMutator; M != None; M = M.NextMutator ) {
    if(M.IsA('Faked_1')) ServerName $= " | 1F";
    if(M.IsA('Faked_2')) ServerName $= " | 2F";
    if(M.IsA('Faked_3')) ServerName $= " | 3F";
    if(M.IsA('Faked_4')) ServerName $= " | 4F";
    if(M.IsA('Faked_5')) ServerName $= " | 5F";
    if(M.IsA('Custom')) ServerName $= " | CustomFaked";
  }
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
  GroupName="KF-MutLoaderV2"
  FriendlyName="MutLoader - v2.2"
  Description="Seamlessly load mutators based on Game Difficulty & Game Type; By Flame, Essence & Vel-San"
}
