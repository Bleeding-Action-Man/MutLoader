///////////////////////////////////////////////////
// Modified version of MutLoader with multiple
// Settings support, GameTypes, GameDifficulty &
// Server Name change
// By Flame, Essence & Vel-San
///////////////////////////////////////////////////

class MutLoader extends Mutator Config(MutLoaderV2);

// Normal Vars
var string sServerName;
var bool bKeepServerNameDefault;
var KFGameType KF;

function PreBeginPlay()
{
  // Vars
  local array<MutLoaderObject> MutLoaderRecords;
  local array<string> MutatorList;
  local array<string> Names;
  local int i;

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
      else bKeepServerNameDefault = True;
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
      MutLog("-----|| Mutator Added =>"@MutatorList[i]$ " ||-----");
    }
  }
}

function PostBeginPlay()
{
  SetTimer(1, False);
}

function Timer()
{
  KF = KFGameType(Level.Game);
  TimeStampLog("-----|| Default ServerName: " $Level.GRI.ServerName$ " ||-----");
  TimeStampLog("-----|| 'MutLoader' ServerName: " $sServerName$ " ||-----");

  CheckMutators(sServerName);

  if(!bKeepServerNameDefault)
  {
    Level.GRI.ServerName = sServerName;
    TimeStampLog("-----|| New ServerName: " $Level.GRI.ServerName$ " ||-----");
  }
  else TimeStampLog("-----|| Keeping Default Server Name ||-----");
}

// Special Function to detect Faked Mutator and append XF to ServerName
function CheckMutators(out string ServerName)
{
  local Mutator M;

  // Do not append anything or change the ServerName, if empty ServerName detected in Config
  if(bKeepServerNameDefault) return;

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
  FriendlyName="MutLoader - v2.1"
  Description="seamlessly load mutators With optimized config (Difficulty, ServerName, Several GameTypes); By Flame, Essence & Vel-San"
}
