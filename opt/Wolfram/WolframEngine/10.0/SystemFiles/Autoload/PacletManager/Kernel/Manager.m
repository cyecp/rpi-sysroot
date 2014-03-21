(* :Title: Manager.m *)

(* :Author:
        Todd Gayley
        tgayley@wolfram.com
*)

(* :Package Version: 2.2 *)

(* :Mathematica Version: 6.0 *)

(* :Copyright: Mathematica source code (c) 1999-2013, Wolfram Research, Inc. All rights reserved. *)

(* :Discussion: This file is a component of the PacletManager Mathematica source code. *)


PacletManager::usage = "PacletManager is used only as a generic symbol for some messages."

RestartPacletManager::usage = "RestartPacletManager[] restarts the Paclet Manager."

PacletFind::usage = "PacletFind is an internal symbol."

PacletInstall::usage = "PacletInstall is an internal symbol."
PacletInstallQueued::usage = "PacletInstallQueued is an internal symbol."
PacletUninstall::usage = "PacletUninstall is an internal symbol."

PacletUpdate::usage = "PacletUpdate is an internal symbol."
PacletCheckUpdate::usage = "PacletCheckUpdate is an internal symbol."

PacletInformation::usage = "PacletInformation is an internal symbol."

PacletResource::usage = "PacletResource is an internal symbol."


PacletDirectoryAdd::usage = "PacletDirectoryAdd is an internal symbol."
PacletDirectoryRemove::usage = "PacletDirectoryRemove is an internal symbol."

Paclet::usage = "Paclet is an internal symbol."

PacletEnable::usage = "PacletEnable is an internal symbol."
PacletDisable::usage = "PacletDisable is an internal symbol."

PacletSetLoading::usage = "PacletSetLoading is an internal symbol."
(* TODO: Need PacletGetLoading, right? *)

RebuildPacletData::usage = "RebuildPacletData[] rebuilds cached paclet information by rescanning paclet directories."

$UserBasePacletsDirectory::usage = "$UserBasePacletsDirectory is the base directory where the PacletManager stores installed paclets and configuration data. If you want this to point to a different directory, you must call RestartPacletManager[\"newBaseDir\"]."
$BasePacletsDirectory::usage = ""


(* Temporary. *)
PacletManagerEnabled::usage = "PacletManagerEnabled is an internal symbol."


Begin["`Package`"]

$managerData

(* This exists only because GetFEKernelInit.tr calls it. It is, in effect, a Quiet version of RestartPacletManager[]. *)
preparePacletManager

initializePacletManager

makePaclet
makePacletInformation

dropDisabledPaclets
isEnabled

contextToFileName

getLoadData
getLoadingState

updateManagerData

(* Called by WRI code outside this package, like GetDataPacletResource function, RLink, CUDALink, and probably others. *)
getPacletWithProgress
(* Called by WRI code outside this package, like background updating of PredictiveInterface paclet. *)
downloadPaclet
(* Shared flag that can be used to determine if a once-per-session PacletSiteUpdate has been called yet. *)
$checkedForUpdates

$isRemoteKernel

(* TODO: Resolve: Called by SystemInformation dialog (i.e., called from outside the PacletManager). *)
lastUpdatedPacletSite
lastUsedPacletSite
numPacletsDownloaded



resourcesLocate

(* Code that is potentially outside the PM (maintained by, say, the docs group) can call this
   function to get information used to populate a management pane.
*)
pacletManagementData
(* Possibly temporary function to generate my management window. *)
pacletManagementDialog

(* Use this in a Dynamic expression that needs reevals when paclet state changes (e.g., Uninstall/change property).
   Increment it when you have changed paclet state.
*)
$pacletDataChangeTrigger

(* Called by FE when user changes interface language in prefs dialog. *)
resetLanguage

(* Called from J/Link's autoClassPath[] function. Legacy only. *)
findJava


$userTemporaryDir
$userConfigurationDir
$userRepositoryDir
$sharedRepositoryDir
systemPacletDirs
applicationDirs

(* Called from DataPaclets/Common.m *)
getTaskData

$pmMode


End[]  (* `Package` *)


(* Current context will be PacletManager`. *)

Begin["`Manager`Private`"]


$managerDataSerializationVersion = 1;
(* This is the data that gets serialized in the managerData_xxx.pmd2 file. The following values
   establish the defaults.
*)
$defaultManagerData = {
    "ManagerDataVersion" -> $managerDataSerializationVersion,
    "AllowInternet" -> True,
    "LastUpdatedSite" -> Null,
    "LastUpdatedSiteDate" -> Null,
    "LastUsedSite" -> Null,
    "LastUsedSiteDate" -> Null,
    "NumPacletsDownloaded" -> 0,
    "IsDataAutoUpdate" -> True,
    "IsDocAutoUpdate" -> True,
    "UseProxy" -> Automatic,
    "HTTPProxyHost" -> Null,
    "HTTPProxyPort" -> 0,
    "HTTPSProxyHost" -> Null,
    "HTTPSProxyPort" -> 0,
    "FTPProxyHost" -> Null,
    "FTPProxyPort" -> 0,
    "SocksProxyHost" -> Null,
    "SocksProxyPort" -> 0,
    "Disabled" -> {},         (* List of keys for paclets that are disabled. *)
    "DisabledTransient" -> {},(* List of keys for transient paclets that are disabled. *)
    "LoadingAutomatic" -> {}, (* List of keys for paclets that are specifically set by user to be auto-load. *)
    "LoadingStartup" -> {},   (* List of keys for paclets that are specifically set by user to be startup-load. *)
    "LoadingAutomaticTransient" -> {}, (* List of keys for transient paclets that are specifically set by user to be auto-load. *)
    "CachesValid" -> {},      (* List of $SystemID values for which following data caches are valid. *)
    "PreloadData" -> {},      (* List of lists of full paths to be Get at startup: {"Windows"->{"path1"}, "Linux"->{"path2"}} *)
    "DeclareLoadData" -> {},  (* List of lists of data ready to be immediately fed to DeclareLoad: {"Windows"->{{"ctxt1", "sym1"..}..}, "Linux"->{..etc..}} *)
    "FunctionInformation" -> {} (* List of lists of function info data: {"Windows"->{...}, "Linux"->{..etc..}} *)
}


(***********************  PacletManager  ************************)

(* Quiet when called during startup, but not during RestartPacletManager[]. *)
preparePacletManager[] := Quiet[initializePacletManager[]]


(* This variable is modified by code that might modify paclet data (PacletInstall, PacletUninstall,
   RebuildPacletData, perhaps others). We don't care about its value, but it is a TrackedSymbol in the
   PacletManagement dialog so that it can dynamically update the contents of any displayed UI.
*)
If[!ValueQ[$pacletDataChangeTrigger], $pacletDataChangeTrigger = 0]


initializePacletManager[] :=
    executionProtect @
    Module[{foundManagerPersistentFile, needsCacheRebuild, cachesValid, managerData, lockFile, freshStart,
             declareLoadData, preloadData, functionInformation, totalFunctionInformation = {}, filePrefix, feLang},
        $pmMode = If[MemberQ[$CommandLine, "-nopaclet"], "ReadOnly", "Normal"];
        (* Define the dirs the paclet manager uses for data and paclets.
           These might be used by Calculate or other internal webM apps, so don't change without consulting.
        *)
        If[!StringQ[$UserBasePacletsDirectory], $UserBasePacletsDirectory = ExpandFileName[ToFileName[$UserBaseDirectory, "Paclets"]]];
        If[!StringQ[$BasePacletsDirectory], $BasePacletsDirectory = ExpandFileName[ToFileName[$BaseDirectory, "Paclets"]]];
        Protect[$UserBasePacletsDirectory, $BasePacletsDirectory];

        If[!StringQ[$frontEndInitDir], $frontEndInitDir = ToFileName[{$UserBaseDirectory, "Autoload", "PacletManager", "Configuration", "FrontEnd"}]];

        (* These globals could be set individually, but by default they are built off of $UserBasePacletsDirectory. *)
        If[!StringQ[$userRepositoryDir], $userRepositoryDir = ExpandFileName[ToFileName[$UserBasePacletsDirectory, "Repository"]]];
        If[!StringQ[$sharedRepositoryDir], $sharedRepositoryDir = ExpandFileName[ToFileName[$BasePacletsDirectory, "Repository"]]];
        If[!StringQ[$userConfigurationDir], $userConfigurationDir = ToFileName[$UserBasePacletsDirectory, "Configuration"]];
        If[!StringQ[$userTemporaryDir], $userTemporaryDir = ToFileName[$UserBasePacletsDirectory, "Temporary"]];

        If[$pmMode =!= "ReadOnly",
            Quiet[
                (* Quiet permissions-related error messages. *)
                If[FileType[$sharedRepositoryDir] =!= Directory,
                    CreateDirectory[$sharedRepositoryDir]
                ]
            ];
            If[FileType[$userRepositoryDir] =!= Directory,
                (* Set freshStart to force rebuild if user has blown away the Repository dir. *)
                freshStart = True;
                CreateDirectory[$userRepositoryDir]
            ];
            If[FileType[$userConfigurationDir] =!= Directory,
                CreateDirectory[$userConfigurationDir]
            ];
            If[FileType[$userTemporaryDir] =!= Directory,
                CreateDirectory[$userTemporaryDir]
            ];
            If[FileType[$frontEndInitDir] =!= Directory,
                CreateDirectory[$frontEndInitDir]
            ]
        ];

        (* Any lock files unexpectedly left behind will cause major problems, so try to delete them. On Windows, if one
           happens to be open in another M process, and thus not actually orphaned, the delete will simply fail. On Mac
           and Linux, the delete will succeed, depriving the existing instance of M the protection of the lock. But this is
           deemed a much smaller problem than orphaned lock files.
           TODO: consider doing this only if !isSubKernel[].
        *)
        If[$pmMode =!= "ReadOnly",
            Quiet[DeleteFile /@ FileNames["*.lock", $userTemporaryDir]]
        ];

        (* Init data for paclet sites. This is quick; does no work. *)
        initializeSites[$pmMode === "ReadOnly"];

        (* Restore collection information from serialized file. *)
        PCinitialize[TrueQ[freshStart]];

        $managerData = $defaultManagerData;
        (* Restore manager data (disabled/loading state of paclets, allow internet, etc.) *)
        foundManagerPersistentFile = False;
        filePrefix = "managerData_" <> If[TrueQ[Developer`ProtectedMode[]], "p_", ""];
        $managerPersistentFile = findMostRecentVersion[$userConfigurationDir, filePrefix, ".pmd2"];
        If[StringQ[$managerPersistentFile],
            lockFile = ToFileName[$userTemporaryDir, FileNameTake[$managerPersistentFile] <> ".lock"];
            If[acquireLock[lockFile, 1, True],
                managerData = Read[$managerPersistentFile, Expression];
                Close[$managerPersistentFile];
                releaseLock[lockFile]
            ];
            (* Only assign to $managerData if it passes a sanity test. *)
            If[MatchQ[managerData, {Rule[_String, _]..}],
                serVersion = "ManagerDataVersion" /. managerData;
                If[serVersion != $managerDataSerializationVersion,
                    (* If the stored data is different than this version of the PM, merge the stored data with
                       the current set of managerdata default rules. In this way, we keep old stored values
                       and pick up any new rules added to managerdata in this PM version. It's harder to be sure
                       this will work for forward compatibility (stored managerdata is newer than current PM version),
                       but that circumstance should be quite rare, and in fact impossible unless the PM serialization
                       format changes without a change in M version.
                    *)
                    $managerData = DeleteDuplicates[Join[managerData, $managerData], First[#1] == First[#2]&];
                    foundManagerPersistentFile = True,
                (* else *)
                    (* serVersion is equal to $managerDataSerializationVersion *)
                    $managerData = managerData;
                    foundManagerPersistentFile = True
                ]
            ],
        (* else *)
            $managerPersistentFile = ToFileName[$userConfigurationDir, filePrefix <> getKernelVersionString[] <> ".pmd2"]
        ];

        (* Check whether pre/autoload caches are valid for this $SystemID. If not, must rebuild. *)
        needsCacheRebuild = True;
        cachesValid = "CachesValid" /. $managerData;
        If[foundManagerPersistentFile && MemberQ[cachesValid, $SystemID],
            needsCacheRebuild = False;
            {preloadData, declareLoadData, functionInformation} =
                    $SystemID /.
                        ({"PreloadData", "DeclareLoadData", "FunctionInformation"} /. $managerData) /.
                            $SystemID -> {}
        ];
        If[needsCacheRebuild,
            (* Must rebuild loading data from scratch. Read the load data
               from paclets based on their specified loading state.
            *)
            {preloadData, declareLoadData, functionInformation} = getLoadData[];
            (* Use data after quick sanity checks. *)
            If[MatchQ[preloadData, {___String}],
                updateManagerData["PreloadData" -> preloadData]
            ];
            If[MatchQ[declareLoadData, {{__String}...}],
                updateManagerData["DeclareLoadData" -> declareLoadData]
            ];
            If[MatchQ[functionInformation, {{_String, {_List...}}...}],
                totalFunctionInformation = functionInformation;
                updateManagerData["FunctionInformation" -> functionInformation]
            ];
            (* Really should do this only if all the above three types of data were ok. *)
            updateManagerData["CachesValid" -> DeleteDuplicates[cachesValid ~Append~ $SystemID]]
        ];
        (* Examined in StartUp/Documentation.m. *)
        PacletManagerEnabled[] = True;

        (* Skip everything else if in ReadOnly mode. This decision is arguable, but ReadOnly isn't
           really a perfect name for this mode. It's more like "ultra-low footprint".
        *)
        If[$pmMode === "ReadOnly", Return[]];
        
        (* Set the kernel's $Language to be the same as the FE's stored language preference value. The FE will do this,
           but only much later, when its kernel init code is executed. But that deprives paclets and other early
           kernel startup code from knowing the correct setting for $Language. Therefore we ask the FE what its value
           is and set $Language now. See bug 236272.
        *)
        If[hasFrontEnd[],
            Quiet[
                feLang = Language /. MathLink`CallFrontEnd[FrontEnd`Options[FrontEnd`$FrontEnd, FrontEnd`Language]];
                If[StringQ[feLang] && feLang =!= $Language, $Language = feLang]
            ]
        ];
        
        If[MatchQ[preloadData, {__String}],
            Get /@ preloadData
        ];
        If[MatchQ[declareLoadData, {{_String, _List}..}],
            doDeclareLoad[declareLoadData]
        ];
        If[!foundManagerPersistentFile,
            writeManagerData[]
        ];
        initSearchCache[$userTemporaryDir];
        resetFEData[];

        If[MathLink`NotebookFrontEndLinkQ[$ParentLink] && MatchQ[totalFunctionInformation, {{_String, {_List...}}...}],
            (* Because the FE crashes if we execute this during startup, we do it later.
               The task runs once every second for at most 30 times. The first time it completes its job it
               removes itself. What we are waiting for with the hasFrontEnd[] call is for the FE to set up
               its ServiceLink. If 30 secs go by and hasFrontEnd[] is never satisfied, we proceed and remove
               the task.
            *)
            periodicalCnt = 0;
            With[{totalFunctionInformation = totalFunctionInformation},
                RunScheduledTask[
                    If[hasFrontEnd[] || ++periodicalCnt > 30,
                        RemoveScheduledTask[$ScheduledTask];
                        MathLink`CallFrontEnd[FrontEnd`SetFunctionInformation[totalFunctionInformation]]
                    ],
                    1
                ]
            ]
        ];

        (* Schedule a task that purges partially-deleted paclets from the Repository, but don't run this
           in parallel subkernels.
        *)
        If[!isSubKernel[],
            RunScheduledTask[purgePartiallyDeletedPaclets[], {5}]
        ];
    ]



(* RestartPacletManager[] should, as much as possible, have the same effect on the PM as a kernel restart
   would. Mainly, this means that so-called "transient" (Extra collection) paclets and their settings would
   be lost. It isn't a user-level function. Just about the only reason I can think to call it would be for
   testing purposes, and to switch the $UserBasePacletsDirectory (which is also a highly advanced operation
   that would only be done by very knowledgeable programs like Wolfram|Alpha, and likely only at startup.
*)

RestartPacletManager[] := initializePacletManager[]

RestartPacletManager[userBasePacletsDir_String] :=
    (
        Unprotect[$UserBasePacletsDirectory];
        $UserBasePacletsDirectory = userBasePacletsDir;
        Protect[$UserBasePacletsDirectory];
        (* Any time the code changes $UserBasePacletsDirectory, it must change these non-public globals as well. *)
        $userRepositoryDir = ToFileName[$UserBasePacletsDirectory, "Repository"];
        $userConfigurationDir = ToFileName[$UserBasePacletsDirectory, "Configuration"];
        $userTemporaryDir = ToFileName[$UserBasePacletsDirectory, "Temporary"];
        RestartPacletManager[]
    )



(* Dirs in the layout that can hold WRI paclets. Users will not be modifying the contents of these
   dirs, or if they do (such as to manually install a new J/Link version), they will have to call
   RebuildPacletData[] afterward.
*)
systemPacletDirs[] :=
    {
        ToFileName[{$InstallationDirectory, "SystemFiles", "Links"}],
        ToFileName[{$InstallationDirectory, "SystemFiles", "Autoload"}],
        ToFileName[{$InstallationDirectory, "AddOns", "Packages"}]
    }

(* This is the set of dirs into which we want to support users hand-installing legacy-style apps
   that are at least partially pacletized (that is, they have a PacletInfo.m file). The PM will never
   install into these dirs, but we want to allow users to do this, especially with legacy apps that
   have PacletInfo.m files to support their new-style documentation. These paclets are rebuilt from
   their PacletInfo.m files every time, never serialized. This is because with the users doing manual
   installation/removal, we could never trust the serialized data anyway.
*)
applicationDirs[] :=
    Join[
        {ToFileName[{$InstallationDirectory, "AddOns", "Applications"}]},
        If[!Developer`$ProtectedMode,
            {ToFileName[{$UserBaseDirectory, "Applications"}],
             ToFileName[{$UserBaseDirectory, "Autoload"}],
             ToFileName[{$BaseDirectory, "Applications"}],
             ToFileName[{$BaseDirectory, "Autoload"}]},
        (* else *)
            {}
        ]
    ]


Options[updateManagerData] = {"Write" -> False}

updateManagerData[field_ -> value_, OptionsPattern[]] :=
    executionProtect @
    Module[{oldValue, newValue},
        If[MatchQ[field, "PreloadData" | "DeclareLoadData" | "FunctionInformation"],
            (* These stored values are lists of $SystemID rules: {"Windows"->{...}, "Linux"->{...}}. Replace the
               part for the current $SystemID.
            *)
            oldValue = field /. $managerData;
            newValue = If[oldValue === {}, {$SystemID -> value}, oldValue /. ($SystemID -> _) -> ($SystemID -> value)],
        (* else *)
            newValue = value
        ];
        $managerData = $managerData /. (field -> _) :> (field -> newValue);
        If[TrueQ[OptionValue["Write"]],
            writeManagerData[]
        ];
    ]

updateManagerData[newRules:{___Rule}, opts:OptionsPattern[]] := (updateManagerData[#, opts]& /@ newRules;)


writeManagerData[] /; $pmMode =!= "ReadOnly" :=
    executionProtect @
    Module[{lockFile},
        lockFile = ToFileName[$userTemporaryDir, FileNameTake[$managerPersistentFile] <> ".lock"];
        (* The False argument means we don't force the lock acquisition to succeed. Writing the
           managerData is not critical; it just means that some state might not be properly saved for
           future sessions. Perhaps a later atempt to write the managerData in this session will succeed.
        *)
        If[acquireLock[lockFile, 0.5, False],
            using[{strm = OpenWrite[$managerPersistentFile]},
                (* Two rules in managerData are not serialized--LoadingAutomaticTransient amd DisabledTransient, as they
                  refer to so-called transient paclets, and info about them does not survive a restart.
                *)
                Write[strm,
                    $managerData /. {("LoadingAutomaticTransient" -> _) -> ("LoadingAutomaticTransient" -> {}),
                                      ("DisabledTransient" -> _) -> ("DisabledTransient" -> {})}
                ]
            ];
            releaseLock[lockFile]
        ]
    ]


(* This function implements "file lookback". Several .pmd2 files stored in the Configuration dir are tied
   to a specific version of M. To preserve these settings when a new M version
   is installed, we want to look back to find the most recent version if no file with the correct version exists.
   Returns the full pathname of a file known to exist, or Null if no appropriate file exists.
*)
findMostRecentVersion[dir_String, prefix_String, suffix_String] :=
    Module[{thisVersionFile, allFiles, versions, latest},
        thisVersionFile = ToFileName[dir, prefix <> getKernelVersionString[] <> suffix];
        If[FileExistsQ[thisVersionFile],
            thisVersionFile,
        (* else *)
            allFiles = FileNames[prefix <> "*" <> suffix, dir];
            If[Length[allFiles] > 0,
                versions = StringCases[allFiles, prefix ~~ vers__ ~~ suffix :> vers];
                latest = Last[Sort[versions, versionGreater]];
                ToFileName[dir, prefix <> latest <> suffix],
            (* else *)
                Null
            ]
        ]
    ]


(* FE calls this when user changes Interface to a new language in prefs dialog. *)
resetLanguage[newLanguage_String] :=
    If[newLanguage != $Language,
        $Language = newLanguage;
        RestartPacletManager[]
    ]


(* Here is where the PM communicates to the FE what the paths are for paclet FE resources like Palettes and Stylesheets. *)
resetFEData[] /; $pmMode =!= "ReadOnly" :=
    Module[{paclets, p, pacletRootPath, exts, extPaths, ext, prependFEData, appendFEData, feData, initFile,
               newPalettePath, newStylePath, newTextPath, newSysPath, strm,
                   needsComma, needsPaletteWrite, needsStyleWrite, needsTextWrite, needsSysWrite, lockFile},
        If[hasFrontEnd[],
            paclets =
                takeLatestEnabledVersionOfEachPaclet[
                    PCfindMatching["Extension" -> "FrontEnd", "Collections" -> {"User", "Layout", "Legacy", "Extra"}]
                ];
            feData =
                forEach[p, paclets,
                    pacletRootPath = PgetPathToRoot[p];
                    exts = cullExtensionsFor[PgetExtensions[p, "FrontEnd"], {"MathematicaVersion", "SystemID", "Language"}];
                    extPaths =
                        forEach[ext, exts,
                            {ExpandFileName[ToFileName[pacletRootPath, EXTgetProperty[ext, "Root"]]], EXTgetProperty[ext, "Prepend", False]}
                        ] // Union;
                    Select[extPaths, FileExistsQ[First[#]]&]
                ] // Flatten[#, 1]&;
            (* feData is a list of pairs: {"path to FrontEnd dir", True | False (whether to prepend)} *)
            prependFEData = Cases[feData, {path_, True} :> path];
            appendFEData = Cases[feData, {path_, False} :> path];
            newPalettePath = setFrontEndPaths["PalettePath", "Palettes", prependFEData, appendFEData];
            newStylePath = setFrontEndPaths["StyleSheetPath", "StyleSheets", prependFEData, appendFEData];
            newTextPath = setFrontEndPaths[{"PrivatePaths", "TextResources"}, "TextResources", prependFEData, appendFEData];
            newSysPath = setFrontEndPaths[{"PrivatePaths", "SystemResources"}, "SystemResources", prependFEData, appendFEData];
            If[First[newPalettePath] =!= Null || First[newStylePath] =!= Null || First[newTextPath] =!= Null || First[newSysPath] =!= Null,
                (* If anything is different from the current FE state, force new settings to take effect right away. *)
                FrontEndExecute[FrontEnd`ResetMenusPacket[{Automatic, Automatic}]]
            ];

            (* The code in this block concerns writing the PM's FE init file. That won't work in
               the plugin, so catch and swallow the exception that will be thrown if that's our environment.
            *)
            catchSystemException[
                (* Now decide if we need to write out the PM's init.m file, and write it if necessary. We always
                   write the file if the PM has any FE data at all, as we want these paths to be known immediately
                   at the next FE startup. We only write out relevant data, though, so if there are no paclet FrontEnd/Palettes
                   dirs, for example, we don't write out a PalettePath section.
                *)
                needsPaletteWrite = Or @@ (FileExistsQ[ToFileName[First[#], "Palettes"]]& /@ feData);
                needsStyleWrite = Or @@ (FileExistsQ[ToFileName[First[#], "StyleSheets"]]& /@ feData);
                needsTextWrite = Or @@ (FileExistsQ[ToFileName[First[#], "TextResources"]]& /@ feData);
                needsSysWrite = Or @@ (FileExistsQ[ToFileName[First[#], "SystemResources"]]& /@ feData);
                If[needsPaletteWrite || needsStyleWrite || needsTextWrite || needsSysWrite,
                    Quiet@executionProtect[
                        initFile = ToFileName[$frontEndInitDir, "init_" <> getKernelVersionString[] <> ".m"];
                        lockFile = ToFileName[$userTemporaryDir, "fe" <> FileNameTake[initFile] <> ".lock"];
                        If[acquireLock[lockFile, 0.5, False],
                            strm = OpenWrite[initFile];
                            WriteString[strm, "SetOptions[$FrontEndSession,\n"];
                            needsComma = False;
                            If[needsPaletteWrite,
                                Write[strm, System`PalettePath->Join[newPalettePath[[2]], {System`ParentList}, newPalettePath[[3]]]];
                                needsComma = True
                            ];
                            If[needsStyleWrite,
                                If[needsComma, WriteString[strm, ",\n"]];
                                Write[strm, System`StyleSheetPath->Join[newStylePath[[2]], {System`ParentList}, newStylePath[[3]]]];
                                needsComma = True
                            ];
                            If[needsTextWrite || needsSysWrite,
                                If[needsComma, WriteString[strm, ",\n"]];
                                Write[strm, System`PrivatePaths->{
                                    "SystemResources"->Join[newSysPath[[2]], {System`ParentList}, newSysPath[[3]]],
                                    "TextResources"->Join[newTextPath[[2]], {System`ParentList}, newTextPath[[3]]]}]
                            ];
                            WriteString[strm, "]"];
                            Close[strm];
                            releaseLock[lockFile]
                        ]
                    ]
                ]
            ]
        ]
    ]


(* Worker function for resetFEData[] *)
setFrontEndPaths[resType_, resDir_, prependFEData_, appendFEData_] :=
    Module[{newPmPrependPaths, newPmAppendPaths, curPaths, oldPre, oldPost, newPaths},
        (* Because these paths will be compared to ones from Options[$FrontEndSession] (which came out of the PM's init.m file),
           we need to call restoreUserBase on them to put them into the same form.
        *)
        newPmPrependPaths = restoreUserBase[Select[prependFEData, FileExistsQ[ToFileName[#, resDir]]&] /.
                                 s_String :> FrontEnd`FileName[{s, resDir}, "PacletManager"->True, "Prepend"->True]];
        newPmAppendPaths = restoreUserBase[Select[appendFEData, FileExistsQ[ToFileName[#, resDir]]&] /.
                                 s_String :> FrontEnd`FileName[{s, resDir}, "PacletManager"->True]];
        (* Use Options instead of CurrentValue here because Options gives a result with explicit ParentList,
           instead of fully resolved, like CurrentValue does.
        *)
        curPaths =
            If[ListQ[resType],
                Last[resType] /. (System`PrivatePaths /. Options[$FrontEndSession, "PrivatePaths"]),
            (* else *)
                Symbol["System`" <> resType] /. Options[$FrontEndSession, resType]
            ];
        If[!ListQ[curPaths], curPaths = {}];
        If[Select[curPaths, !FreeQ[#, "PacletManager"]&] == Join[newPmPrependPaths, newPmAppendPaths],
            Return[{Null, newPmPrependPaths, newPmAppendPaths}]
        ];
        (* If we get here we know we are going to change $FrontEndSession, and thus return non-Null as first part of result. *)
        If[MemberQ[curPaths, System`ParentList],
            (* We are going to build a result like {newPre, ParentList, newPost} *)
            {oldPre, oldPost} = curPaths /. {a___, System`ParentList, b___} :> {{a}, {b}};
            newPaths = Join[Select[oldPre, FreeQ[#, "PacletManager"]&], newPmPrependPaths, {System`ParentList},
                                Select[oldPost, FreeQ[#, "PacletManager"]&], newPmAppendPaths],
        (* else *)
            (* $FrontEndSession has become a static list. *)
            newPaths = DeleteDuplicates[Join[newPmPrependPaths, curPaths, newPmAppendPaths]]
        ];
        If[MatchQ[newPaths, {(_String | _FrontEnd`FileName | System`ParentList)..}],
            CurrentValue[$FrontEndSession, resType] = newPaths,
        (* else *)
            (* Unexpected value for newPaths. Shouldn't happen, but as a fail-safe, don't assign. *)
            newPaths = Null;
        ];
        {newPaths, newPmPrependPaths, newPmAppendPaths}
    ]


(* Paths read from a frontend init.m file are in some cases (TextResources, SystemResources at the least) interpreted
   at a time when the front end knows nothing about character encodings. This means that it doesn't work to have any non-ASCII
   chars in paths in these files. The front end will correctly replace $UserBaseDirectory and $BaseDirectory, however,
   even if they have non-ASCII elements in them, so this function restores those symbolc elements in places where the
   fully-spelled out path includes them as components.
*)
SetAttributes[restoreUserBase, Listable]

restoreUserBase[FrontEnd`FileName[{p_, rest___}, opts___]] :=
    Which[
        StringMatchQ[p, $UserBaseDirectory ~~ __, IgnoreCase -> True],
            With[{parts = Join[{HoldForm@$UserBaseDirectory}, DeleteCases[Drop[FileNameSplit[p], Length[FileNameSplit[$UserBaseDirectory]]], "."], Flatten[{rest}]]},
                FrontEnd`FileName[parts, opts] /. HoldForm[x_] :> Unevaluated[x]
            ],
        StringMatchQ[p, $BaseDirectory ~~ __, IgnoreCase -> True],
            With[{parts = Join[{HoldForm@$BaseDirectory}, DeleteCases[Drop[FileNameSplit[p], Length[FileNameSplit[$BaseDirectory]]], "."], Flatten[{rest}]]},
                FrontEnd`FileName[parts, opts] /. HoldForm[x_] :> Unevaluated[x]
            ],
        True,
            FrontEnd`FileName[{p, rest}, opts]
    ]

restoreUserBase[f_] := f


(* Purges partially-deleted paclets from the Repository. Run from a ScheduledTask a few seconds after startup.
   It is thought that such paclets are likely to accumulate because they might have had a file open (like a doc
   notebook in the FE, or a data paclet index) when the user tried to delete it. These paclets have already had
   their PacletInfo.m files deleted (that file is always deleted successfully on a paclet uninstall), so they are
   "dead" to the PacletManager already, but we want to delete their remnant contents. Note that this is a
   dangerous procedure. We are going to delete any dirs in Repository that don't have PacletInfo.m files.
   Need to make sure that any standard subdirs of Repository (like SystemDocumentation) are skipped.
*)
purgePartiallyDeletedPaclets[] :=
    Module[{dir},
        RemoveScheduledTask[$ScheduledTask];
        doForEach[dir, FileNames["*", ToFileName[$UserBasePacletsDirectory, "Repository"]],
            If[Length[FileNames[{"PacletInfo.m", "PacletInfo.wl"}, dir]] < 1 && FileNameTake[dir] =!= "SystemDocumentation",
                Quiet[DeleteDirectory[dir, DeleteContents->True]]
            ]
        ]
    ]


(******************************  "Loading State" Management  ********************************)

PacletSetLoading::notfound = "Paclet named `1` not found or not enabled."
PacletSetLoading::vnotfound = "Paclet with name `1` and version `2` not found or not enabled."
PacletSetLoading::loadstate = "Invalid value for load state: `1`. Must be one of Automatic, Manual, or \"Startup\"."
PacletSetLoading::noload = "Paclet named `1` at location `2` does not specify any Mathematica code to load. Its loading state cannot be set."
PacletSetLoading::nostartup = "\"Startup\" loading status is not meaningful for the paclet named `1` at location `2` because this paclet was added to Mathematica using PacletDirectoryAdd. All such paclet locations are not automatically visible in subsequent Mathematica sessions."


PacletSetLoading[name_String, loading_] := PacletSetLoading[{name, All}, loading]

PacletSetLoading[{name_String, vers:(_String | All):All}, loading_] :=
    Module[{paclets},
        paclets = PacletFind[{name, vers}, "Internal"->All];
        If[Length[paclets] > 0,
            PacletSetLoading[#, loading]& /@ paclets,
        (* else *)
            If[vers === All,
                Message[PacletSetLoading::notfound, name],
            (* else *)
                Message[PacletSetLoading::vnotfound, name, vers]
            ]
        ];
    ]

PacletSetLoading[p_Paclet, loading_] :=
    Module[{canonicalizedLoadingState, didModifyManagerData, key, currentAuto, currentStartup,
               declareLoadData, preloadData, currentDeclareLoadData, currentPreloadData,
                    changingFromAutomatic, origLoadingState},
        (* The documented values are Automatic, Manual, and "Startup", but there's no reason not to
           help users out by allowing variants, such as "Automatic" or "StartUp". Also, we want to allow users
           to incorrectly enter Startup as a symbol, which is why we call SymbolName, to strip symbols of their contexts.
        *)
        canonicalizedLoadingState =
            Which[
                Head[loading] === Symbol,
                    ToLowerCase[SymbolName[loading]],
                StringQ[loading],
                    ToLowerCase[loading],
                True,
                    (* Won't be valid, but issue message later. *)
                    loading
            ];
        If[!MemberQ[{"automatic", "startup", "manual"}, canonicalizedLoadingState],
            Message[PacletSetLoading::loadstate, loading];
            Return[Null]  (* Not $Failed, I think *)
        ];
        origLoadingState = getLoadingState[p];
        (* If we aren't changing the value, then there is nothing to do. *)
        If[ToLowerCase[ToString[origLoadingState]] == canonicalizedLoadingState,
            Return[]
        ];
        didModifyManagerData = changingFromAutomatic = False;
        preloadData = PgetPreloadData[p];
        declareLoadData = PgetDeclareLoadData[p];
        If[preloadData === {} && declareLoadData === {},
            (* No code to load. *)
            Message[PacletSetLoading::noload, p["Name"], p["Location"]];
            Return[Null]
        ];
        key = PgetKey[p];
        If[!isInExtraCollection[p],
            (* Note that we don't deal with functionInformation here. Changing a paclet's loading state does not affect that. *)
            {currentAuto, currentStartup, currentPreloadData, currentDeclareLoadData} =
                        {"LoadingAutomatic", "LoadingStartup", "PreloadData", "DeclareLoadData"} /. $managerData;
            (* These values have $SystemID-specific sub-rules, so extract the appropriate values. *)
            {currentPreloadData, currentDeclareLoadData} =
                  $SystemID /. {currentPreloadData, currentDeclareLoadData} /. $SystemID -> {};
            (* Here we want the raw values from the paclet, not based on any user-provided setting for its loading state. *)
            (* Two-step update procedure. First, make sure the paclet does not appear in any list it doesn't belong in.
               Second, add it to the one it does belong in (if it isn't already there).
            *)
            Switch[origLoadingState,
                Automatic,
                    If[canonicalizedLoadingState != "automatic",
                        updateManagerData["LoadingAutomatic" -> DeleteCases[currentAuto, key]];
                        updateManagerData["DeclareLoadData" -> DeleteCases[currentDeclareLoadData, Alternatives @@ declareLoadData]];
                        changingFromAutomatic = True;
                        didModifyManagerData = True
                    ],
                "Startup",
                    If[canonicalizedLoadingState != "startup",
                        updateManagerData["LoadingStartup" -> DeleteCases[currentStartup, key]];
                        updateManagerData["PreloadData" -> DeleteCases[currentPreloadData, Alternatives @@ preloadData]];
                        didModifyManagerData = True
                    ]
            ];
            Switch[canonicalizedLoadingState,
                "automatic",
                    If[origLoadingState =!= Automatic,
                        updateManagerData["LoadingAutomatic" -> DeleteDuplicates[Append[currentAuto, key]]];
                        If[MatchQ[declareLoadData, {{_String, _List}..}],
                            doDeclareLoad[declareLoadData];
                            (* Add the declareLoadData from this paclet, first eliminating existing data that has the same context. *)
                            updateManagerData["DeclareLoadData" ->
                                Join[Select[currentDeclareLoadData, !MemberQ[declareLoadData[[All,1]], First[#]]&], declareLoadData]];
                            didModifyManagerData = True
                        ]
                    ],
                "startup",
                    If[origLoadingState =!= "Startup",
                        updateManagerData["LoadingStartup" -> DeleteDuplicates[Append[currentStartup, key]]];
                        If[MatchQ[preloadData, {__String}],
                            (* It is an open question as to whether setting a paclet to startup loading should
                               cause its appropriate .m files to be read in immediately, not just the next time we
                               startup the kernel. Commenting out the following line leaves this choice at "No".
                            *)
                            (* Quiet[doPreload[preloadData]]; *)
                            updateManagerData["PreloadData" -> DeleteDuplicates[Join[currentPreloadData, preloadData]]]
                        ];
                        didModifyManagerData = True
                    ],
                _,
                    Null (* was Manual; do nothing. *)
            ];
            If[didModifyManagerData,
                (* Mark the "load data" caches invalid for any other $SystemID, so that the next time the manager data
                   is read on that OS, the load data will have to be rebuilt. This is because we don't know for sure
                   whether the paclet we have just modified is valid for any other $SystemID.
                 *)
                updateManagerData["CachesValid" -> {$SystemID}, "Write" -> True]
            ],
        (* else *)
            (* Paclet is in Extra collection, which is not serialized in managerData. *)
            currentAuto = "LoadingAutomaticTransient" /. $managerData;
            Switch[canonicalizedLoadingState,
                "startup",
                    Message[PacletSetLoading::nostartup, p["Name"], p["Location"]];
                    Return[],
                "automatic",
                    doDeclareLoad[declareLoadData];
                    updateManagerData["LoadingAutomaticTransient" -> Append[currentAuto, key]],
                "manual",
                    changingFromAutomatic = origLoadingState === Automatic;
                    If[changingFromAutomatic,
                        updateManagerData["LoadingAutomaticTransient" -> DeleteCases[currentAuto, key]]
                    ]
            ]
        ];
        If[changingFromAutomatic,
            (* Undo the system settings that set the paclet's symbols to autoload the package. *)
            undoDeclareLoad[p]
        ];
        If[didModifyManagerData,
            $pacletDataChangeTrigger++
        ];
    ]



getLoadingState[p_Paclet] :=
    Block[{key = PgetKey[p]},
        If[isInExtraCollection[p],
            If[MemberQ["LoadingAutomaticTransient" /. $managerData, key],
                Automatic,
            (* else *)
                PgetLoadingState[p]
            ],
        (* else *)
            Which[
                MemberQ["LoadingAutomatic" /. $managerData, key],
                    Automatic,
                MemberQ["LoadingStartup" /. $managerData, key],
                    "Startup",
                True,
                    (* If there is no stored data for the user-set loading state, use the value
                       set in the PI file (defaults to Manual if not explicitly given).
                    *)
                    PgetLoadingState[p]
            ]
        ]
    ]


(* Get data from paclets that have LoadingState set to Automatic or StartUp so that we can set up
   appropriate startup defs (Package`DeclareLoad for Automatic loading, full paths to .m files for Startup loading).
   Note that these functions return data based on the user's settings for their loading state, or the paclet's built-in
   setting if no user value is known--they don't just extract the raw values from a paclet.

   getLoadData returns a 4-element list of {loadingState, preloadData, declareLoadData, funcInfo} when called on
   a single paclet, and a 3-element list of {preloadData, declareLoadData, funcInfo} when called on a list (each
   element is the joined set of all repective elements from the set of paclets). This is just a useful optimization,
   since when it is called on a single paclet, we generally want to also get the paclet's loadingState.
*)

getLoadData[] :=
    getLoadData[
        takeLatestEnabledVersionOfEachPaclet[PCfindMatching["Extension" -> "Kernel" | "Application", "Collections" -> {"User", "Layout", "Legacy"}]]
    ]

(*  Transient means that it is from ExtraPacletCollection, not serialized. *)
(* UNNEEDED: transient (extra) paclets are only dealt with at attach time.
getTransientLoadData[] :=
    getLoadData0[
        takeLatestEnabledVersionOfEachPaclet[PCfindMatching["Extension" -> "Kernel", "Collections" -> {"Extra"}]]
    ]
*)

getLoadData[paclet_Paclet] :=
    Switch[#,
        "Startup",
            {#, PgetPreloadData[paclet], {}, PgetFunctionInformation[paclet]},
        Automatic,
            {#, {}, PgetDeclareLoadData[paclet], PgetFunctionInformation[paclet]},
        _,
            {#, {}, {}, {}}
    ]& @ getLoadingState[paclet]

getLoadData[{}] := {{}, {}, {}}

getLoadData[paclets_List] := Rest[MapThread[Join, getLoadData /@ paclets]]



doPreload[paclet_Paclet] := doPreload[ getLoadData[paclet][[2]] ]

doPreload[filesToLoad:{__String}] := Get /@ filesToLoad


doDeclareLoad[paclet_Paclet] := doDeclareLoad[ getLoadData[paclet][[3]] ]

(* Use this form when you have already extracted the relevant info from the paclet. *)
doDeclareLoad[loadData:{{_String, _List}..}] :=
    Function[{ctxt, syms},
        If[!MemberQ[$Packages, ctxt],
            Quiet[Package`DeclareLoad[syms, ctxt, Package`ExportedContexts -> {ctxt}]]
        ]
    ] @@@ loadData



undoDeclareLoad[paclet_Paclet] :=
    Module[{declareLoadData, symbolsNeedingClearing},
        declareLoadData = getLoadData[paclet][[3]];
        If[Length[declareLoadData] > 0,
            (* Symbols that need clearing are those that are in the paclet context (the check that it is on $Packages
               is a shortcut to avoid looking at symbols that definitely aren't set up with DeclareLoad)
               and have OwnValues that contain Package`ActivateLoad. We cull these out and clear them in a few programming steps.
            *)
            symbolsNeedingClearing = ToHeldExpression /@ Flatten[Rest /@ Select[declareLoadData, MemberQ[$Packages, First[#]]&]];
            symbolsNeedingClearing = Select[symbolsNeedingClearing, !FreeQ[OwnValues @@ #, Package`ActivateLoad]&];
            Function[sym, ClearAttributes[sym, {Protected,ReadProtected}]; Clear[sym], HoldFirst] @@@ symbolsNeedingClearing;
            (* Remove the contexts from $Packages, but only if the context hasn't been loaded. *)
            If[Length[symbolsNeedingClearing] > 0,
                using[{Unprotect[$Packages]},
                    $Packages = DeleteCases[$Packages, Alternatives @@ (First /@ declareLoadData)]
                ]
            ];
        ]
    ]


doFunctionInformation[funcInfo:{{_String, {_List...}}..}] :=
    If[hasFrontEnd[],
 (* Print["calling SetFunctionInformation: ", funcInfo];*)
        MathLink`CallFrontEnd[FrontEnd`SetFunctionInformation[funcInfo]]
    ]


(*************************  Disabled State Management  ***************************)

dropDisabledPaclets[paclets_List] :=
    With[{disabled = "Disabled" /. $managerData},
        Select[paclets, !MemberQ[disabled, PgetKey[#]]&]
    ]

isEnabled[paclet_Paclet] := !MemberQ["Disabled" /. $managerData, PgetKey[paclet]]

isEnabled[key:{qualifiedName_String, location_String}] := !MemberQ["Disabled" /. $managerData, key]


(******************************  PacletFindFile  *******************************)

Unprotect[Internal`PacletFindFile]

Internal`PacletFindFile[ctxtOrFile_String] /; PacletManagerEnabled[] :=
    Which[
        StringMatchQ[ctxtOrFile, "*`"],
            contextToFileName[Null, ctxtOrFile],
        StringMatchQ[ctxtOrFile, "http:*"] || StringMatchQ[ctxtOrFile, "ftp:*"],
            Null,
        StringMatchQ[ctxtOrFile, Except[{"/", "\\"}].. ~~ "." ~~ System`Dump`LibraryExtension[]],
            (* Only used for plain filenames like foo.dll; no partials like dir/foo.so. *)
            findLibrary[Null, ctxtOrFile],
        !StringMatchQ[ctxtOrFile, "/" ~~ ___] && !StringMatchQ[ctxtOrFile, "\\" ~~ ___] && !StringMatchQ[ctxtOrFile, LetterCharacter~~":"~~___],
            (* Here we look for files within paclets when given a partial path like Foo/Bar.txt. We take the the first
               segment of the filename as a paclet name, so that Foo/Bar.txt would look for Bar.txt in the Root dir of
               the Foo paclet. If this seems like too bold a thing to do, remember that it is already how non-paclet apps
               work--for any parts of them to be found, their installation dirs have to be on $Path. Conceptually, this
               step for paclets is like making all paclets be on $Path (really, the parent dirs of their root dirs).
               We are just making paclets work like non-paclet apps already do. This is essential for enabling the
               common (but outdated) idiom of having a main context found via Get["Foo`Foo`"] in your Kernel/init.m file,
               and having that main context file try to find its dir using FindFile[$Input] ($Input will be Foo/Foo.m in
               this case).
               We only do this lookup for non-absolute paths, and ones that have at least one file separator char in them.
            *)
            Block[{parts = FileNameSplit[ctxtOrFile], paclets, file},
                If[Length[parts] > 1,
                     paclets =
                         takeLatestEnabledVersionOfEachPaclet[
                             PCfindMatching["Name" -> First[parts], "Collections" -> {"User", "Layout", "Legacy", "Extra"}]
                         ];
                     If[Length[paclets] > 0,
                         file = FileNameJoin[Rest[parts] ~Prepend~ PgetPathToRoot[First[paclets]]];
                         If[FileExistsQ[file],
                             ExpandFileName[file],
                         (* else *)
                             Null
                         ],
                     (* else *)
                         Null
                     ],
                (* else *)
                    Null
                ]
            ],
        True,
            Null
    ]

Protect[Internal`PacletFindFile]


(* Worker function called by PacletFindFile. Resolves a context to the full path to the .wl or .m file that it
   represents, if the context is supplied by a paclet. Paclets must announce the contexts they provide in
   their Kernel extensions--it is not enough to match the paclet's name (this seems like a good idea to
   help avoid inadvertantly loading a paclet that has chosen a name that is not its context but happens
   to match another context). Gives Null if the context cannot be found, or if no appropriate .wl or .m file exists.
   If a string is returned, the file has been verified to exist.

   If paclet != Null look up path in given paclet; otherwise look in all paclets.
*)
contextToFileName[paclet_, ctxt_String] :=
    Block[{paclets, p, pacletsFromMap, pacletRootPath, fullPathToKernelRoot, fullPathToFile,
              isSubContext, contextPos, listedContext, kernelExt, parentContext},  (* Block for speed only *)
        contextPos = StringPosition[ctxt, "`"];
        isSubContext = Length[contextPos] > 1;
        If[paclet === Null,
            (* Find all paclets that announce they supply the context. Use the contextMap for speed. *)
            pacletsFromMap = First /@ Select[getContextMap[], MemberQ[Last[#], ctxt]&];
            If[Length[pacletsFromMap] == 0 && isSubContext,
                (* Look for parent context if subcontext. *)
                parentContext = StringTake[ctxt, contextPos[[1,1]]];
                pacletsFromMap = First /@ Select[getContextMap[], MemberQ[Last[#], parentContext]&]
            ];
            If[Length[pacletsFromMap] > 0,
                p = First[pacletsFromMap],
            (* else *)
                Return[Null]
            ],
        (* else *)
            p = paclet
        ];
        pacletRootPath = PgetPathToRoot[p];
        (* Loop over all contexts in all Kernel extensions until we find a match. *)
        doForEach[kernelExt, cullExtensionsFor[PgetExtensions[p, "Kernel" | "Application"], {"MathematicaVersion", "SystemID"}],
            fullPathToKernelRoot = ToFileName[pacletRootPath, EXTgetProperty[kernelExt, "Root", $defaultKernelRoot]];
            fullPathToFile =
                Scan[
                    Function[{ctxtRec},
                        Switch[ctxtRec,
                            "Context",
                                (* No Contexts listed at all. Ignore this ext. *)
                                Null,
                            _String | {_String},
                                (* Context listed without a path. *)

                                (* init.m handling is here.
                                   An init.m file is a legacy fature of the pre-paclet world. A typical app layout looked like
                                   this:
                                        MyApp/
                                            Kernel/
                                                init.m   <---- Get["MyApp`MyApp`"]
                                            MyApp.m

                                   M resolved MyApp` to the MyApp/Kernel/init.m file, and that file would Get["MyApp`MyApp`"],
                                   which would resolve according to "normal" M rules (the first MyApp` would resolve to the MyApp dir,
                                   and the second MyApp` would resolve to the MyApp.m file).
                                   The Workbench still creates app layouts with this design.
                                   If a paclet has this layout, and we want its Kernel extension to have Root->".", Context->"MyApp`"
                                   then we must first try mapping MyApp` to extroot/Kernel/init.m. To help out developers, we also try
                                   mapping it to extroot/init.m, in case they set the Kernel ext Root->"Kernel" and want all their .m files,
                                   including init.m, in the Kernel dir.

                                   Only map context to init.m if it isn't a subcontext--the init.m feature should only work
                                   for loading the "main" context.
                                *)
                                If[!isSubContext,
                                    If[FileExistsQ[#], Return[#]]& @ ToFileName[{fullPathToKernelRoot, "Kernel"}, "init.wl"];
                                    If[FileExistsQ[#], Return[#]]& @ ToFileName[fullPathToKernelRoot, "init.wl"];
                                    If[FileExistsQ[#], Return[#]]& @ ToFileName[{fullPathToKernelRoot, "Kernel"}, "init.m"];
                                    If[FileExistsQ[#], Return[#]]& @ ToFileName[fullPathToKernelRoot, "init.m"]
                                ];

                                (* Drop trailing `, append .wl or .m or .mx, and replace internal ` with /.
                                   This will find the "normal" case of a like-named .m file in the ext root directory, or a subdir based
                                   on a nested context.
                                *)
                                If[FileExistsQ[#], Return[#]]& @
                                        ToFileName[fullPathToKernelRoot, StringReplace[StringDrop[ctxt, -1], "`"->$PathnameSeparator] <> ".wl"];
                                If[FileExistsQ[#], Return[#]]& @
                                        ToFileName[fullPathToKernelRoot, StringReplace[StringDrop[ctxt, -1], "`"->$PathnameSeparator] <> ".m"];
                                If[FileExistsQ[#] && !DirectoryQ[#], Return[#]]& @
                                        ToFileName[fullPathToKernelRoot, StringReplace[StringDrop[ctxt, -1], "`"->$PathnameSeparator] <> ".mx"];
                                (* Now the special mapping of Foo` --> Foo.mx/$SystemID/Foo.mx. *)
                                If[FileExistsQ[#], Return[#]]& @
                                        ToFileName[{fullPathToKernelRoot, StringReplace[StringDrop[ctxt, -1], "`"->$PathnameSeparator] <> ".mx",
                                                      $SystemID}, StringReplace[StringDrop[ctxt, -1], "`"->$PathnameSeparator] <> ".mx"];

                                If[isSubContext,
                                    (* Subcontexts would have been correctly mapped by the above line if they were done as subdirs
                                       of the ext root dir. But it's also common in legacy apps to have all the .m files in the top dir:
                                           MyApp/
                                               MyApp.m
                                               SubContext.m
                                               Kernel/
                                                   init.m  <--- Get["MyApp`MyApp`"]; Get["MyApp`SubContext`"]
                                       If we want this to work for a paclet, we have to act like the root part of the context maps us to the
                                       ext root (whereas in reality, getting there is "free"), and then the second part takes us to the file.
                                    *)
                                    If[FileExistsQ[#], Return[#]]& @
                                            ToFileName[fullPathToKernelRoot, StringJoin[Riffle[Rest[StringSplit[ctxt, "`"]], $PathnameSeparator]] <> ".wl"];
                                    If[FileExistsQ[#], Return[#]]& @
                                            ToFileName[fullPathToKernelRoot, StringJoin[Riffle[Rest[StringSplit[ctxt, "`"]], $PathnameSeparator]] <> ".m"];
                                    (* Now the special mapping of Foo` --> Foo.mx/$SystemID/Foo.mx. *)
                                    If[FileExistsQ[#], Return[#]]& @
                                            ToFileName[{fullPathToKernelRoot, StringJoin[Riffle[Rest[StringSplit[ctxt, "`"]], $PathnameSeparator]] <> ".mx",
                                                          $SystemID}, Last[StringSplit[ctxt, "`"]] <> ".mx"];
                                ],
                            {_String, _String},
                                (* Context listed with a path. The named context must be a precise match for the requested one;
                                   no subcontext searching.
                                *)
                                listedContext = First[ctxtRec];
                                If[listedContext == ctxt,
                                    If[FileExistsQ[#], Return[#]]& @
                                            ToFileName[fullPathToKernelRoot, Last[ctxtRec]];
                                ],
                            _,
                                (* Bad entry in context list. *)
                                Null
                        ]
                    ],
                    (* We need to deal with no "Context" rule, or a "Context"->(_String | {(_String | {__String})..)},
                       hence the Flatten[{...},1].
                    *)
                    Select[Flatten[{"Context" /. Rest[kernelExt]}, 1], contextMatches[#, ctxt]&]
                ];
            (* If the inner Scan that just finished (searching over contexts from one extension) found a file,
               it returned it. If that happened, we want to immediately return it from the outer Scan (searching
               over all extensions).
            *)
            If[fullPathToFile =!= Null, Return[ExpandFileName[fullPathToFile]]]
        ]  (* The result of this doForEach will be a found file path, or Null. *)
    ]


(* Private worker function only used in contextToFilename[]. This decides whether a Kernel ext should be examined
   for matches to a requested context, based on the entries in the ext's Context list. We get called with either
   "ctxt`", {"ctxt`"}, or {"ctxt`", "path"}. The listed context matches the requested context if it is equal to it, or
   if it is the parent context, so that a Kernel ext can list "ctxt`" and be examined for requests for "ctxt`subcontext`".
*)
contextMatches[{listedContext_String, ___String}, requestedContext_String] := contextMatches[listedContext, requestedContext]

contextMatches[listedContext_String, requestedContext_String] :=
    listedContext == requestedContext || StringMatchQ[requestedContext, listedContext <> "*"]

contextMatches[___] = False  (* Quietly reject any unexpected values in Context property. *)


(* Worker function called by PacletFindFile. Resolves a library name (with extension) to the full path that it
   represents, if the library is supplied by a paclet. Paclets do not need to announce the libraries they
   have, although they must have a LibraryLink extension.
   Gives Null if the library cannot be found.

   If paclet != null look up path in given paclet; otherwise look in all paclets.
*)
findLibrary[paclet_, libWithExt_String] :=
    Block[{paclets, pacletRootPath, fullPathToLibRoot, fullPathToLibRootWithSystemID, fullPathToLib},  (* Block for speed only *)
        If[paclet === Null,
            (* Find all paclets that have LibraryLink extensions. *)
            paclets = takeLatestEnabledVersionOfEachPaclet[
                          PCfindMatching["Extension" -> "LibraryLink", "Collections" -> {"User", "Layout", "Legacy", "Extra"}]
                      ];
            If[paclets === {},
                Return[Null]
            ],
        (* else *)
            paclets = {paclet}
        ];
        (* Loop over all LibraryLink extensions in all paclets until we find a match. *)
        Scan[
            Function[{p},
                pacletRootPath = PgetPathToRoot[p];
                fullPathToLib =
                    Scan[
                        Function[{libraryExt},
                            fullPathToLibRoot = ToFileName[pacletRootPath, EXTgetProperty[libraryExt, "Root", $defaultLibraryRoot]];
                            fullPathToLibRootWithSystemID = ToFileName[fullPathToLibRoot, $SystemID];
                            (* At the moment I don't support listing of libraries. Just always check to see if the file exists. *)
                            If[FileExistsQ[#], Return[#]]& @ ToFileName[fullPathToLibRootWithSystemID, libWithExt];
                            If[FileExistsQ[#], Return[#]]& @ ToFileName[fullPathToLibRoot, libWithExt]
                        ],
                        cullExtensionsFor[PgetExtensions[p, "LibraryLink"], {"MathematicaVersion", "SystemID"}]
                    ];
                (* If the inner Scan that just finished (searching over extensions of one paclet) found a file,
                   it returned it. If that happened, we want to immediately return it from the outer Scan (searching
                   over all paclets).
                *)
                If[fullPathToLib =!= Null, Return[ExpandFileName[fullPathToLib]]]
            ],
            paclets
        ]  (* The result of this Scan will be a found file path, or Null. *)
    ]


(* Called from J/Link's autoClassPath[] to get list of Java dirs from paclets. This is only called at Java startup,
   so the classpath still needs to be adjusted as new paclets are installed/enabled/etc.
   This is a legacy function, superseded by calls in M 9.1 J/Link to resourcesLocate[]. It remains here only
   to support older versions of J/Link.
*)
findJava[] := findJava[Null]

findJava[paclet:(_Paclet | Null)] :=
    Module[{paclets, pacletRootPath, javaLocations},
        If[paclet === Null,
            (* Find all paclets that have Java extensions. *)
            paclets = takeLatestEnabledVersionOfEachPaclet[
                          PCfindMatching["Extension" -> "JLink", "Collections" -> {"User", "Layout", "Legacy", "Extra"}]
                      ];
            If[paclets === {},
                Return[{}]
            ],
        (* else *)
            paclets = {paclet}
        ];
        javaLocations =
            Function[{p},
                pacletRootPath = PgetPathToRoot[p];
                ToFileName[pacletRootPath, EXTgetProperty[#, "Root", $defaultJLinkRoot]]& /@
                      cullExtensionsFor[PgetExtensions[p, "JLink"], {"MathematicaVersion", "SystemID"}]
            ] /@ paclets;
        ExpandFileName /@ Select[Flatten[javaLocations], FileExistsQ]
    ]


(* The context map is a list of {paclet, {ctxts..}} of paclets that declare the given contexts. Disabled paclets
   have been dropped, and only the highest version number of each like-named paclet is represented.
   This provides very fast lookup in contextToFileName, but it needs to be regenerated every time a paclet
   is added or removed. It is only cached for the duration of a session, and never serialized. Thus, it is
   created the first time it is needed, regenerated during a session as necessary, and discarded when you quit.
*)
getContextMap[] := If[ListQ[$contextMap], $contextMap, makeContextMap[]]
    
makeContextMap[] :=
    Module[{paclets, p, map},
        paclets = takeLatestEnabledVersionOfEachPaclet[
                     PCfindMatching["Collections"->{"User", "Layout", "Legacy", "Extra"}]
                  ];
        map = forEach[p, paclets, {p, PgetContexts[p]}];
	    $contextMap = Cases[map, {_Paclet, {__String}}]
    ]
    

(********************************  PacletResource  **********************************)

(* Returns either:
    - $Failed (after a message) if paclet not found.
    - Null if paclet does not contain the resource
    - String that is the full path to the resource (file must exist)
*)

PacletResource[pacletName_String, resource_String] := PacletResource[{pacletName, ""}, resource]

PacletResource[{pacletName_String, pacletVersion_String}, resource_String] :=
    Module[{locals},
        locals = PacletFind[{pacletName, pacletVersion}, "Internal"->All];
        If[MatchQ[locals, {__Paclet}],
            PacletResource[First[locals], resource],
        (* else *)
            If[pacletVersion == "",
                Message[PacletResource::pcltni, pacletName],
            (* else *)
                Message[PacletResource::pcltnvi, pacletName, pacletVersion]
            ];
            $Failed
        ]
    ]

PacletResource[p_Paclet, resource_String] :=
    Module[{resExt, pacletRootPath, resPath, fullPath},
        pacletRootPath = PgetPathToRoot[p];
        doForEach[resExt, cullExtensionsFor[PgetExtensions[p, "Resource"], {"SystemID", "MathematicaVersion", "Language"}],
            resPath = EXTgetNamedResourcePath[resExt, resource];
            If[StringQ[resPath],
                fullPath = ToFileName[{pacletRootPath, EXTgetProperty[resExt, "Root", "."]}, resPath];
                If[FileExistsQ[fullPath], Return[ExpandFileName[fullPath]]]
            ]
        ]
        (* Return value will be full path to an existing file, or Null if the dorForEach walks off the end. *)
    ]


(****************************  Looking up local paclets  *****************************)

(* PacletFind is a quick lookup of a locally-installed paclet given name and version.
   Use "" for version to mean "find latest version".
   It will mainly be used as a way to get a Paclet expression from a name and possibly
   also a version.

   The list that is returned is sorted, with latest version number first.
*)

Options[PacletFind] = {"Location"->All, "Qualifier"->All, "SystemID"->Automatic, "MathematicaVersion"->Automatic,
                            "Enabled"->True, "Extension"->All, "Creator"->All, "Publisher"->All,
                               "Context"->All, "Loading"->All, "IncludeDocPaclets"->False, "Internal"->False}

PacletFind[pacletName:(_String | All):All, opts:OptionsPattern[]] :=
    PacletFind[{pacletName, All}, opts]

PacletFind[{pacletName:(_String | All):All, pacletVersion:(_String | All):All}, opts:OptionsPattern[]] :=
    Module[{options, paclets, disabledPacletsList},
        options = Flatten[{opts}];
        If[OptionValue["IncludeDocPaclets"],
            AppendTo[options, "Collections" -> {"User", "Layout", "Legacy", "Extra", "LayoutDocs", "DownloadedDocs"}]
        ];
        paclets = PCfindMatching["Name" -> pacletName, "Version" -> pacletVersion, FilterRules[options, Options[PCfindMatching]]];
        Switch[OptionValue["Enabled"],
            True,
                paclets = dropDisabledPaclets[paclets],
            False,
                disabledPacletsList = "Disabled" /. $managerData;
                paclets = Select[paclets, MemberQ[disabledPacletsList, PgetKey[#]]&]
        ];
        Switch[OptionValue["Loading"],
            Manual | "Manual",
                paclets = Select[paclets, (getLoadingState[#] == Manual)&],
            Automatic,
                paclets = Select[paclets, (getLoadingState[#] == Automatic)&],
            "Startup",
                paclets = Select[paclets, (getLoadingState[#] == "Startup")&]
        ];
        Flatten[groupByNameAndSortByVersion[paclets]]
    ]



(********************************  Installing  ********************************)

PacletInstall::offline = "Mathematica cannot install paclet `1` because it is currently configured not to use the Internet for paclet downloads. To allow internet access, use Help > Internet Connectivity...."
PacletInstall::notavail = "No paclet named `1` is available for download from any currently enabled paclet sites."
PacletInstall::vnotavail = "No paclet named `1` with version number `2` is available for download from any currently enabled paclet sites."
PacletInstall::fnotfound = "Paclet file `1` not found."
PacletInstall::dwnld = "An error occurred downloading paclet `1` from site `2`: `3`. `4`"
PacletInstall::instl = "An error occurred installing paclet from file `1`: `2`. `3`"
(* Use this one for cases where an exception message was already issued. *)
PacletInstall::inst = "An error occurred installing paclet from file `1`."
PacletInstall::samevers = "A paclet named `1` with the same version number (`2`) is already installed. Use PacletUninstall to remove the existing version first, or call PacletInstall with IgnoreVersion->True."
PacletInstall::newervers = "A paclet named `1` with a newer version number (`2`) is already installed. If you wish to install an older version, use PacletUninstall to remove the existing version first, or call PacletInstall with IgnoreVersion->True."
PacletInstall::lock = "The paclet installation cannot proceed at this time because another paclet operation is being performed by a different instance of Mathematica. Try the operation again."
PacletInstall::readonly = "The PacletManager application is running in \"read-only\" mode; paclets cannot be installed or uninstalled."


Options[PacletInstall] = Options[PacletInstallQueued] = {"IgnoreVersion"->False, "DeletePacletFile"->False,
                                                          "Site"->Automatic, "UpdateSites" -> False}

(*
    PacletInstall returns:
        - the installed Paclet expression if a successful installation occurs
        - an existing Paclet expression if a newer one is already installed and not IgnoreVersion->True
        - $Failed if an error occurs
        - $Failed if the argument is a filename and a newer version is already installed. In other words,
             in the case of a .paclet file as the argument, if we don't install we return $Failed, never an
             existing Paclet expression as in the first bullet above

      The IgnoreVersion option controls whether the install should be allowed if an identical or newer version
      of the same paclet is already installed. The default is False, meaning that
      PacletInstall should not attempt to install the paclet in this circumstance.
*)

(* Arg is either a file path to a .paclet file, or a URL to a .paclet file (that is, not using a paclet server),
   or paclet name with no version spec.
*)
PacletInstall[str_String, opts:OptionsPattern[]] :=
    If[StringMatchQ[str, "*.paclet", IgnoreCase->True] || StringMatchQ[str, "*.cdf", IgnoreCase->True],
        installPacletFromFileOrURL[str, OptionValue["IgnoreVersion"], OptionValue["DeletePacletFile"]],
    (* else *)
        PacletInstall[{str, ""}, opts]
    ]

(* The paclet arg here would have to be a server paclet (otherwise it would already be installed). *)
PacletInstall[p_Paclet, opts:OptionsPattern[]] := PacletInstall[{p["Name"], p["Version"]}, opts]

PacletInstall[{pacletName_String, pacletVersion_String}, opts:OptionsPattern[]] :=
    Module[{q},
        q = PacletInstallQueued[{pacletName, pacletVersion}, opts];
        (* q is either a Paclet expr (the paclet was already installed), or an AsynchronousTaskObject, or $Failed. *)
        If[Head[q] === Paclet || q === $Failed,
            q,
        (* else *)
            (* q is an AsynchronousTaskObject. *)
            PacletInstall[q, opts]
        ]
    ]

PacletInstall[downloadTask_AsynchronousTaskObject, opts:OptionsPattern[]] :=
    Module[{pacletQualifiedName, pacletFile, pacletSite, statusCode, errorString, msgLines},
        {pacletQualifiedName, pacletFile, pacletSite} = getTaskData[downloadTask][[1;;3]];
        If[!StringQ[pacletFile],
            (* TODO: Message here, or some better handling of errors. *)
            Return[$Failed]
        ];
        CheckAbort[
            While[MemberQ[AsynchronousTasks[], downloadTask] &&
                     getTaskData[downloadTask][[5]] === 0 && getTaskData[downloadTask][[6]] == "",
                Quiet @ WaitAsynchronousTask[downloadTask, "Timeout" -> 0.2]
            ],
            (* On abort: *)
            Quiet[
                StopAsynchronousTask[downloadTask];
                RemoveAsynchronousTask[downloadTask]
            ];
            Abort[]
        ];
        {statusCode, errorString} = getTaskData[downloadTask][[5;;6]];
        freeTaskData[downloadTask];
        If[statusCode == 200,
            (* This will issue messages if paclet is bad. *)
            installPacletFromFileOrURL[pacletFile, True, True],
        (* else *)
            (* was network or server problem. *)
            If[errorString != "",
                msgLines = {"Network error", errorString},
            (* else *)
                msgLines = {errorStringFromHTTPStatusCode[statusCode], ""}
            ];
            Message[PacletInstall::dwnld, pacletQualifiedName, pacletSite, Sequence @@ msgLines];
            $Failed
        ]
    ]



(* Can return a Paclet[] expression, $Failed, or an installer object. Always call PacletInstall on the installer object
    to properly finish the installation sequence.

    Callers can get a download progress percentage by calling ReleaseHold[Options[task, "UserData"]].
*)

PacletInstallQueued[pacletName_String, opts:OptionsPattern[]] := PacletInstallQueued[{pacletName, ""}, opts]

PacletInstallQueued[p_Paclet, opts:OptionsPattern[]] := PacletInstallQueued[{p["Name"], p["Version"]}, opts]

PacletInstallQueued[{pacletName_String, pacletVersion_String}, opts:OptionsPattern[]] :=
    Module[{existing, newestExisting, existingVers, availablePaclets, result, remotePaclet, downloadTask, site, isNewSite},
        (* Look for existing installed paclets of the same name. *)
        existing = PacletFind[{pacletName, ""}, "Enabled"->All, "Internal"->All,
                                "IncludeDocPaclets"->StringMatchQ[pacletName, "SystemDocs_*"]];
        If[MatchQ[existing, {__Paclet}],
            newestExisting = First[existing];
            existingVers = newestExisting["Version"];
            (* If the requested version was "", then the caller didn't care about what
               version to install, and the presence of any version makes the whole operation a no-op.
            *)
            If[pacletVersion == "",
                Return[newestExisting],
            (* else *)
                (* Specific version was specified by caller. If IgnoreVersion->True, just go on and
                   pretend there was no existing paclet. Otherwise give some messages in certain circumstances.
                *)
                If[!TrueQ[OptionValue["IgnoreVersion"]],
                    (* If caller requests a version that is equal to or less than a currently-installed one,
                       issue a message, do not install, and return the existing Paclet. This means that
                       specifying a version in PacletInstall without setting IgnoreVersion->True is like
                       saying "make sure that user has at least the given version installed."
                    *)
                    Which[
                        PacletNewerQ[existingVers, pacletVersion],
                            Message[PacletInstall::newervers, newestExisting["Name"], newestExisting["Version"]];
                            Return[newestExisting],
                        existingVers === pacletVersion,
                            Message[PacletInstall::samevers, newestExisting["Name"], newestExisting["Version"]];
                            Return[newestExisting],
                        True,
                            (* Existing version is older than the one to be installed. Go on and quietly install. *)
                            Null
                    ]
                ]
            ]
        ];
        (* If we get here, we have decided to go ahead and attempt to install the paclet. For ReadOnly mode,
           we do nothing special; there will be empty site data, so it will appear that the paclet is unavailable
           for download.
        *)
        (* Using the Site option temporarily adds that paclet site, and also forces an immediate update of that site.
           This enables one-shot:   PacletInstall["paclet", "Site" -> "SomeNewSiteIJustFoundOutAbout"]
        *)
        site = OptionValue["Site"];
        If[StringQ[site],
            try[
                isNewSite = !MemberQ[PacletSites[], PacletSite[site, __]];
                PacletSiteAdd[site];
                PacletSiteUpdate[site];
                result = PacletInstallQueued[{pacletName, pacletVersion}, FilterRules[{opts}, {"IgnoreVersion", "DeletePacletFile"}]],
            (* finally *)
                If[isNewSite, PacletSiteRemove[site]]
            ];
            Return[result]
        ];
        availablePaclets = PacletFindRemote[{pacletName, pacletVersion}, "UpdateSites" -> OptionValue["UpdateSites"]];
        result = $Failed;
        If[Length[availablePaclets] == 0,
            (* Paclet not found on any server. *)
            If[pacletVersion == "",
                Message[PacletInstall::notavail, pacletName],
            (* else *)
                Message[PacletInstall::vnotavail, pacletName, pacletVersion]
            ],
        (* else *)
            (* Paclet is believed to be available from one or more servers. *)
            remotePaclet = First[availablePaclets];
            If[$AllowInternet,
                downloadTask = downloadPaclet[remotePaclet];
                (* TODO: Deal with $Failed, etc. here. *)
                result = downloadTask,
            (* else *)
                (* Message isn't perfect because you can also get here if allowinternet is True but the
                   site is not enabled. Perhaps I should have PacletFindRemote skip non-enabled sites.
                *)
                Message[PacletInstall::offline, pacletName]
            ]
        ];
        result
    ]


(* Return $Failed for all failures. *)
installPacletFromFileOrURL[pacletFileOrURL_String, ignoreVersion_, deletePacletFile_] :=
    Module[{pacletFile, absoluteFileName, name, version, existing, newestExisting, packedPaclet, installedPaclet,
              pacletTopDir, isSystemDocs, lockFile, tempFile},
        If[$pmMode == "ReadOnly",
            Message[PacletInstall::readonly];
            Return[$Failed]
        ];
        pacletFile = pacletFileOrURL;
        (* Here is where we handle the case where the file spec is a URL. Simply download the file and proceed as usual. *)
        If[StringMatchQ[pacletFile, "http:*", IgnoreCase->True] || StringMatchQ[pacletFile, "ftp:*", IgnoreCase->True],
            tempFile = ToFileName[$TemporaryDirectory, "temp" <> ToString[$ProcessID] <> ToString[$ModuleNumber]<> ".paclet"];
            If[URLSave[pacletFile, tempFile, "StatusCode"] === 200,
                pacletFile = tempFile,
            (* else *)
                (* Rely on error messages issued by URLSave to notify user. *)
                Return[$Failed]
            ]
        ];
        (* Expand to absolute name in M so that we capture M's notion of current directory, expand ~ and such. *)
        absoluteFileName = ExpandFileName[pacletFile];
        If[FileType[absoluteFileName] === File,
            {name, version} = {"Name", "Version"} /. PacletInformation[absoluteFileName];
            If[name === "Name" || version === "Version",
                Message[PacletInstall::instl, absoluteFileName, "Not a valid paclet", ""];
                Return[$Failed]
            ];
            If[!TrueQ[ignoreVersion],
                (* Unless ignoreVersion, we want to issue a message and fail if this paclet is not newer than
                   any currently-installed version.
                *)
                existing = PacletFind[{name, ""}, "Enabled"->All, "Internal"->All];
                If[MatchQ[existing, {__Paclet}],
                    newestExisting = First[existing];
                    Which[
                        PacletNewerQ[newestExisting["Version"], version],
                            Message[PacletInstall::newervers, newestExisting["Name"], newestExisting["Version"]];
                            Return[$Failed],
                        newestExisting["Version"] === version,
                            Message[PacletInstall::samevers, newestExisting["Name"], newestExisting["Version"]];
                            Return[$Failed],
                        True,
                            Null
                    ]
                ]
            ];
            (* If we get here, we have decided to install the paclet. *)
            packedPaclet = CreatePaclet[pacletFile];
            isSystemDocs = TrueQ[isSystemDocsGroup[packedPaclet]];
            executionProtect[
                If[isSystemDocs,
                    (* TODO: Entire issue of special handling of SystemDocs is ignored for now.
                       Don't forget to rebuild DownloadedDocs collection.
                    *)
                    Null,
                (* else *)
                    lockFile = ToFileName[$userTemporaryDir, "repository.lock"];
                    If[!acquireLock[lockFile, 2, False],
                        Message[PacletInstall::lock];
                        Return[$Failed]
                    ];
                    pacletTopDir = ZipExtractArchive[pacletFile, $userRepositoryDir, "Overwrite" -> True];
                    If[StringQ[pacletTopDir],
                        installedPaclet = CreatePaclet[pacletTopDir]
                    ];
                    releaseLock[lockFile]
                ];

                If[TrueQ[deletePacletFile] || StringQ[tempFile], Quiet[DeleteFile[absoluteFileName]]];
                If[Head[installedPaclet] === Paclet,
                    PCrebuild["Collections" -> {"User"}];
                    PCwrite[];
                    makeContextMap[];
                    attachPaclet[installedPaclet];
                    installedPaclet,
                (* else *)
                    Message[PacletInstall::inst, absoluteFileName];
                    $Failed
                ]
            ],
        (* else *)
            (* File doesn't exist. *)
            Message[PacletInstall::fnotfound, absoluteFileName];
            $Failed
        ]
    ]



(* For async, returns task or $Failed. For sync, returns filename, $Failed, or anything URLSave can return. *)
downloadPaclet[remotePaclet_Paclet, async:(True | False):True] :=
    Module[{loc, downloadTask, pacletFileName, downloadedFileName},
        loc = PgetLocation[remotePaclet];
        pacletFileName = PgetQualifiedName[remotePaclet] <> ".paclet";
        (* To avoid conflicts with multiple instances of M, or preemptive computations, downloading the same paclet,
           generate a unique name for the download file.
        *)
        downloadedFileName = ToFileName[$userTemporaryDir, PgetQualifiedName[remotePaclet] <>
                                    ToString[$ProcessID] <> ToString[Random[Integer,{1,1000}]] <> ".paclet"];
        If[StringMatchQ[loc, "http:*", IgnoreCase->True] || StringMatchQ[loc, "file:*", IgnoreCase->True],
            If[async,
                PreemptProtect[
                    (* Use PreemptProtect to ensure that setTaskData[] gets called before downloadCallback can fire. *)
                    downloadTask = URLSaveAsynchronous[
                                  loc <> "/Paclets/" <> ExternalService`EncodeString[pacletFileName],
                                  downloadedFileName,
                                  downloadCallback,
                                  "Headers" -> {"Mathematica-systemID" -> $SystemID,
                                                  "Mathematica-license" -> ToString[$LicenseID],
                                                    "Mathematica-mathID" -> ToString[$MachineID],
                                                      "Mathematica-language" -> ToString[$Language],
                                                        "Mathematica-activationKey" -> ToString[$ActivationKey]},
                                  "UserAgent" -> $userAgent, BinaryFormat -> True, "Progress" -> True
                               ];
                    setTaskData[downloadTask, {PgetQualifiedName[remotePaclet], downloadedFileName, loc, "Running", 0, "", "Unknown"}]
                ];
                downloadTask,
            (* else *)
                (* Synchronous; returns filename. *)
                URLSave[loc <> "/Paclets/" <> pacletFileName,
                        ToFileName[$userTemporaryDir, pacletFileName],
                        "UserAgent" -> $userAgent, BinaryFormat -> True
                ]
            ],
        (* else *)
            $Failed
        ]
    ]


(* taskData values are either a list:
    {"qualifiedName", "downloadFileName", "pacletSite", "Running" | "Done", statuscode | 0, errorString | "", progressPercentage}
      or
    {None, None, None, None, 0, "", 0}.

    DataPaclets/Common.m relies on the structure of this expr to some degree.
*)
downloadCallback[task_, "statuscode", data_] := setTaskData[task, ReplacePart[getTaskData[task], 5->First[data]]]
downloadCallback[task_, "error", data_] := setTaskData[task, ReplacePart[getTaskData[task], 6->First[data]]]
(* Do nothing if the download size is not known (progress percentage will remain at 0 during download). *)
downloadCallback[task_, "progress", {_, 0., _, _}] = Null
downloadCallback[task_, "progress", {a_Real, b_Real, __}] := setTaskData[task, ReplacePart[getTaskData[task], 7->a/b]]


(***************************  WRI-Internal utility download/install functions  **************************)

(* This Package-context function is called by the DataPaclets subsystem, RLink, and CUDALink, and perhaps others.
   It encapsulates the functionality of applications that need to download "sub-paclets" during their normal operations,
   and require that progress text is displayed to the user, so that they know what is going on and possibly causing a
   significant delay. Also, messages can be targeted to the application, thus hiding the involvement of the PacletManager
   from users. These apps thus need slightly specialized behavior compated to simply calling, say, PacletUpdate.
   This code was formerly in the PacletTools package, and in the DataPaclets code.
   The pacletName argument is the name of the paclet you want to download and install (the same as you would pass to
   PacletUpdate). The pacletDisplayName is the name you want displayed in messages and possibly other text (e.g., a
   paclet might be actually named GraphData_Index, but you want the user to see just GraphData).
*)
Options[getPacletWithProgress] = {"IsDataPaclet" -> False, "AllowUpdate" -> True, "UpdateSites" -> Automatic}

getPacletWithProgress[pacletName_String, pacletDisplayName_String, OptionsPattern[]] :=
    Module[{p, downloadTask, progressText, availablePaclets, locals, temp, isDataPaclet, allowUpdate, updateSites},
        {isDataPaclet, allowUpdate, updateSites} = OptionValue[{"IsDataPaclet", "AllowUpdate", "UpdateSites"}];
        (* Once-per-session update of site data. *)
        If[TrueQ[updateSites] || updateSites === Automatic && !TrueQ[$checkedForUpdates],
            Quiet[temp = PacletSiteUpdate /@ PacletSites[]];
            $checkedForUpdates = True
        ];

        locals = Quiet[PacletFind[pacletName]];
        p = If[Length[locals] > 0, First[locals], Null];

        Which[
            Head[p] =!= Paclet,
                (* No paclet of the desired type is currently installed. *)
                downloadTask = Quiet[PacletInstallQueued[pacletName]];
                (* PacletInstallQueued can return a Paclet expression, $Failed, or an AsynchronousTaskObject.
                   We know it won't return a Paclet expression because PacletFind already told us one doesn't
                   exist locally. If it returns an AsynchronousTaskObject then we wait for it to finish.
                   If it returns $Failed we want to issue the most appropriate message.
                *)
                If[Head[downloadTask] == AsynchronousTaskObject,
                    progressText =
                        If[hasFrontEnd[],
                            If[isDataPaclet, General::datainstx, "Loading from Wolfram Research server (`1`%)"],
                        (* else *)
                            If[isDataPaclet, General::datainst, "Loading from Wolfram Research server ..."]
                        ];
                    p = downloadAndInstallWithProgress[downloadTask, progressText],
                (* else *)
                    If[!TrueQ[$AllowInternet],
                        If[isDataPaclet,
                            Message[Evaluate[MessageName[Evaluate[ToExpression[pacletDisplayName]], "dloff"]], pacletDisplayName],
                        (* else *)
                            Message[PacletManager::dloff, pacletDisplayName]
                        ];
                        (* Return here, as we don't want to fall through to the dlfail message at end. *)
                        Return[$Failed]
                    ]
                ],
            TrueQ[allowUpdate],
                (* A paclet of the desired type exists locally. See if we can download an update. *)
                (* Calling PacletCheckUpdate does not hit the Internet--it just looks in the local server index file. *)
                availablePaclets = Quiet[PacletCheckUpdate[pacletName]];
                If[Length[availablePaclets] > 0,
                    downloadTask = Quiet[PacletInstallQueued[First[availablePaclets]]];
                    (* PacletInstallQueued can return a Paclet expression, $Failed (e.g., AllowInternet is false),
                       or an AsynchronousTaskObject object. If it returns an AsynchronousTaskObject then we can start it up.
                       On any other return value we do nothing--a currently-installed paclet can do the job.
                    *)
                    If[Head[downloadTask] == AsynchronousTaskObject,
                        progressText =
                            If[hasFrontEnd[],
                                If[isDataPaclet, General::dataupdx, "Updating from Wolfram Research server (`1`%)"],
                            (* else *)
                                If[isDataPaclet, General::datainst, "Updating from Wolfram Research server ..."]
                            ];
                        p = downloadAndInstallWithProgress[downloadTask, progressText];
                        If[Head[p] === Paclet,
                            (* Install was a success, so delete the old paclets *)
                            Quiet[PacletUninstall /@ locals]
                        ]
                    ]
                ],
            True,
                (* If we get here, an appropriate paclet was already installed and allowUpdate
                   was False so we will not attempt to update. Do nothing.
                *)
                Null
        ];
        If[Head[p] === Paclet,
            p,
        (* else *)
            If[isDataPaclet,
                Message[Evaluate[MessageName[Evaluate[ToExpression[pacletDisplayName]], "dlfail"]], pacletDisplayName],
           (* else *)
                Message[PacletManager::dlfail, pacletDisplayName]
            ];
            $Failed
        ]
    ]

(* Downloads and installs paclets with progress display. Returns either a Paclet expression
   representing the newly-installed paclet or $Failed on any error.
*)
downloadAndInstallWithProgress[downloadTask_, progressText_String] :=
    Module[{nb, text, paclet, usingFE},
        paclet = $Failed;
        usingFE = hasFrontEnd[];
        If[usingFE,
            text = StringForm[progressText,
                Dynamic[Refresh[Max[Round[100 * (Last[getTaskData[downloadTask]] /. Except[_?NumericQ] -> 0)], 0], UpdateInterval -> 0.5]]
            ];
            nb = DisplayTemporary[
                Framed[
                    Style[text,
                        FontFamily -> "Verdana", FontSize -> 11,
                    FontColor -> RGBColor[0.2, 0.4, 0.6]],
                    FrameMargins -> {{24, 24}, {8, 8}},
                    FrameStyle -> RGBColor[0.2, 0.4, 0.6],
                    Background -> RGBColor[0.96, 0.98, 1.]
                ]
            ],
        (* else *)
            Print[progressText]
        ];
        try[
            paclet = PacletInstall[downloadTask],
        (* finally *)
           If[usingFE, NotebookDelete[nb]];
        ];
        If[Head[paclet] === Paclet,
            paclet,
        (* else *)
            $Failed
        ]
    ]


(*****************************  PacletUpdate  *******************************)

(* Returns a Paclet expression if a successful update occurred, Null if no update was available,
   or $Failed if there was a failure (this is just the return value of PacletInstall). If no
   current version exists, PacletUpdate acts like PacletInstall.

   More precisely:
       no local paclet with this name exists: result from PacletInstall
       local paclet exists, but no updates are available: Null
       local paclet exists and updates are available: result from PacletInstall
*)

PacletUpdate::fail = "Could not uninstall paclet named `1` at location `2`. Reason: `3`."
PacletUpdate::notvalid = "`1` does not refer to a valid paclet in the current session."
PacletUpdate::uptodate = "No newer version of the paclet named `1` could be found on any available paclet servers."

Options[PacletUpdate] = {"KeepExisting" -> Automatic, "Site" -> Automatic, "UpdateSites" -> False}


PacletUpdate[pacletName_String, opts:OptionsPattern[]] :=
    Module[{localPaclets},
        localPaclets = Quiet[PacletFind[pacletName, "Enabled"->All, "Internal"->All,
                                "IncludeDocPaclets"->StringMatchQ[pacletName, "SystemDocs_*"]]];
        If[Length[localPaclets] == 0,
            PacletInstall[pacletName, FilterRules[{opts}, Options[PacletInstall]]],
        (* else *)
            PacletUpdate[First[localPaclets], opts]
        ]
    ]

PacletUpdate[paclet_Paclet, opts:OptionsPattern[]] :=
    Module[{result = Null, remote, bestRemote, site, isNewSite},
        (* Using the Site option temporarily adds that paclet site, and also forces an immediate update of that site.
           This enables one-shot:   PacletInstall["paclet", "Site" -> "SomeNewSiteIJustFoundOutAbout"]
        *)
        site = OptionValue["Site"];
        If[StringQ[site],
            try[
                isNewSite = !MemberQ[PacletSites[], PacletSite[site, __]];
                PacletSiteAdd[site];
                PacletSiteUpdate[site];
                result = PacletUpdate[paclet, "KeepExisting" -> OptionValue["KeepExisting"]],
            (* finally *)
                If[isNewSite, PacletSiteRemove[site]]
            ];
            Return[result]
        ];
        remote = PacletFindRemote[paclet["Name"], "UpdateSites" -> OptionValue["UpdateSites"]];
        If[Length[remote] > 0,
            bestRemote = First[remote];
            If[PacletNewerQ[bestRemote["Version"], paclet["Version"]],
                result = PacletInstall[bestRemote, FilterRules[{opts}, Options[PacletInstall]]];
                If[Head[result] === Paclet,
                    (* Restore the load state of the updated version. *)
                    PacletSetLoading[result, getLoadingState[paclet]];
                    Switch[OptionValue["KeepExisting"],
                        False,
                            PacletUninstall[paclet],
                        Automatic,
                            (* Automatic means "only uninstall old one if it is not in the layout".
                               Paclet locations are already in canonical form.
                            *)
                            If[!StringMatchQ[PgetLocation[paclet], $InstallationDirectory <> "*"],
                                PacletUninstall[paclet]
                            ]
                    ]
                ]
            ],
        (* else *)
            Message[PacletUpdate::uptodate, paclet["Name"]]
        ];
        result
    ]



Options[PacletCheckUpdate] = {"UpdateSites" -> False}

PacletCheckUpdate[p_Paclet, opts:OptionsPattern[]] := PacletCheckUpdate[p["Name"], opts]

PacletCheckUpdate[name_String, OptionsPattern[]] :=
    Module[{bestLocal, remote},
        bestLocal = Quiet[First[PacletFind[name, "Enabled"->All, "Internal"->All,
                                    "IncludeDocPaclets"->StringMatchQ[name, "SystemDocs_*"]]]];
        remote = PacletFindRemote[name, "UpdateSites" -> OptionValue["UpdateSites"]];
        If[Head[bestLocal] === Paclet,
            Select[remote, PacletNewerQ[#, bestLocal]&],
        (* else *)
            remote
        ]
    ]



PacletUninstall::open = "Some files could not be deleted from paclet named `1` at location `2`, probably because they are open in the current session. The deletion will automatically complete the next time the Mathematica kernel is started."
PacletUninstall::notinstalled = "The paclet named `1` at location `2` cannot be uninstalled because it is not installed."
PacletUninstall::nodelete = "The paclet named `1` at location `2` cannot be uninstalled because it does not reside in the standard paclet repository. You will have to delete the paclet's files manually, such as by using DeleteDirectory with DeleteContents->True."
PacletUninstall::notfound = "Paclet `1` not found."
PacletUninstall::vnotfound = "Paclet with name `1` and version `2` not found."
PacletUninstall::lock = "The paclet uninstall cannot proceed at this time because another paclet operation is being performed by a different instance of Mathematica. Try the operation again."
PacletUninstall::readonly = PacletInstall::readonly

(*

   Returns Null if successful, $Failed if not. Failure to delete all files because some of them are open does not
   constitute failure of the uninstall operation. The detachPaclet does as much as possible to make the paclet
   unavailable in the current session, and the deletion of the PacletInfo.m file makes it no longer viable in
   subsequent sessions (and the auto-deletion operation that scans for dirs without PacletInfo.m files will clean
   it up eventually).

   Can only uninstall paclets that are in the repository.
*)

PacletUninstall[p_Paclet] :=
    executionProtect @
    Module[{location, result, lockFile},
        location = p["Location"];
        If[StringMatchQ[location, "http:*", IgnoreCase->True] || StringMatchQ[location, "ftp:*", IgnoreCase->True] ||
                StringMatchQ[location, "*.paclet", IgnoreCase->True],
            Message[PacletUninstall::notinstalled, p["Name"], location];
            Return[$Failed]
        ];
        If[$pmMode == "ReadOnly",
            Message[PacletUninstall::readonly];
            Return[$Failed]
        ];
        If[StringMatchQ[location, $userRepositoryDir<>"*"] || StringMatchQ[location, $sharedRepositoryDir<>"*"],
            detachPaclet[p];
            lockFile = ToFileName[$userTemporaryDir, "repository.lock"];
            If[!acquireLock[lockFile, 2, False],
                Message[PacletUninstall::lock];
                Return[$Failed]
            ];
            result = Quiet[Check[DeleteDirectory[location, DeleteContents -> True], $Failed]];
            releaseLock[lockFile];
            If[result === $Failed,
                (* In cases that I know of, the PacletInfo.m file will be deleted. If that happens, the paclet
                   is fully uninstalled, at least for the next kernel session, so I don't want to give $Failed
                   as a result. The message lets users know that some parts of the paclet might still be in use.
                *)
                Message[PacletUninstall::open, p["Name"], location];
                If[Length[FileNames[{"PacletInfo.m", "PacletInfo.wl"}, location]] == 0,
                    result = Null
                ]
            ],
        (* else *)
            result = Null;
            Message[PacletUninstall::nodelete, p["Name"], location]
        ];
        PCrebuild["Collections" -> {"User"}];
        PCwrite[];
        makeContextMap[];
        result
    ]


PacletUninstall[pacletName_String] := PacletUninstall[{pacletName, All}]

PacletUninstall[{pacletName_String, pacletVersion:(_String | All)}] :=
    Module[{paclets},
        paclets = PacletFind[{pacletName, pacletVersion}, "Enabled"->All, "Internal"->All];
        If[Length[paclets] > 0,
            If[MemberQ[#, $Failed], $Failed, Null]& [PacletUninstall /@ paclets],
        (* else *)
            If[pacletVersion === "" || pacletVersion === All,
                Message[PacletUninstall::notfound, pacletName],
            (* else *)
                Message[PacletUninstall::vnotfound, pacletName, pacletVersion]
            ];
            $Failed
        ]
    ]

PacletUninstall[paclets:{__Paclet}] := PacletUninstall /@ paclets



(****************************  PacletEnable/PacletDisable  ****************************)

(*
   PacletEnable["name"]              - leaves just the latest version enabled
   PacletEnable[{"name", "vers"}]    - leaves just this version enabled
   PacletEnable[Paclet[...]]         - leaves just this one enabled
   PacletEnable[pacletObj]           - leaves just this one enabled
   PacletEnable["location"]          - leaves just this one enabled (Use PacletEnable[First[PacletFind[Loction->loc]]] )

   Returns the Paclet expression for the single enabled paclet, or $Failed

   PacletDisable["name"]             - disables all with that name
   PacletDisable[{"name", "vers"}]   - disables just the given version
   PacletDisable[Paclet[...]]        - disables just this one
   PacletDisable[pacletObj]          - disables just this one

   Returns the Paclet expressions for the newly-disabled paclets
*)

PacletEnable::notfound = "Paclet `1` not found."
PacletEnable::vnotfound = "Paclet with name `1` and version `2` not found."
PacletEnable::notsup = PacletDisable::notsup = "PacletEnable and PacletDisable are not supported in this version of Mathematica."


PacletEnable[name_String] := PacletEnable[{name, ""}]

PacletEnable[{name_String, vers_String}] :=
    Module[{paclets},
        paclets = PacletFind[{name, vers}, "Enabled"->All, "Internal"->All];
        If[Length[paclets] > 0,
            PacletEnable[First[paclets]],
        (* else *)
            If[vers == "",
                Message[PacletEnable::notfound, name],
            (* else *)
                Message[PacletEnable::vnotfound, name, vers]
            ];
            Null
        ]
    ]


PacletEnable[paclet_Paclet] :=
    Module[{wasEnabled},
        Message[PacletEnable::notsup];
        $Failed
        (*
        wasEnabled = pm@isEnabled[pacletObj];
        pm@setEnabled[#["Object"], False]& /@ PacletFind[pacletObj@getName[], "Internal"->All];
        pm@setEnabled[pacletObj, True];
        doPacletGainingStuff[pacletObj];
        makePaclet[pacletObj]
        *)
    ]


PacletDisable[name_String] := PacletDisable[{name, ""}]

PacletDisable[{name_String, vers_String}] := Flatten[PacletDisable /@ PacletFind[{name, vers}, "Internal"->All]]


PacletDisable[paclet_Paclet] :=
    (
        Message[PacletDisable::notsup];
        $Failed
        (*
        getPacletManager[]@setEnabled[pacletObj, False];
        doPacletLosingStuff[pacletObj];
        makePaclet[pacletObj]
        *)
    )


(***************************  PacletInformation  ****************************)

(*
   Gives a list of rules describing attributes of a paclet. Modelled after FileInformation,
   except lhs of rules in result are strings.

   When given a name and version, it only looks in local paclets and only returns a result
   for one paclet (this will be the latest version). Paclets that do not match M version and
   SystemID requirements will not be found. You can use this function to get info for server
   paclets or non-matching paclets if you use another function like PacletFind to acquire
   a Paclet[] expression and then pass that expression to PacletInformation.

   No version specified, or "", means to find the latest version.

   Args:    One of:
              - lone string that is either a paclet name or a path to a .paclet file.
              - {name, version} list.
              - Paclet[] expression

   Returns: A list of rules, the LHS of which are all strings. List is empty if paclet
            is not found (no messages are issued, in parallel to how FileInformation works)
            or arg was a .paclet file and there was a failure in creating the Paclet
            expression from that file (in which case a message is issued).
*)

(* Arg is either a file path to a .paclet file or a paclet name with no version spec. *)
PacletInformation[str_String] :=
    Module[{paclet},
        If[StringMatchQ[str, "*.paclet", IgnoreCase->True] || StringMatchQ[str, "*.cdf", IgnoreCase->True],
            If[FileExistsQ[str],
                paclet = CreatePaclet[str];
                If[Head[paclet] === Paclet,
                    PacletInformation[paclet],
                (* else *)
                    (* Will have gotten some message out of CreatePaclet. *)
                    {}
                ],
            (* else *)
                (* File not found; quietly return empty list. *)
                {}
            ],
        (* else *)
            PacletInformation[{str, ""}]
        ]
    ]


(* Will not find a disabled paclet unless there are no matching enabled ones (regardless of version number). *)
PacletInformation[{name_String, version_String}] :=
    Module[{paclets},
        paclets = PacletFind[{name, version}];
        If[paclets === {},
            paclets = PacletFind[{name, version}, "Enabled" -> False]
        ];
        (* Take the first one if more than one was found. *)
        If[Length[paclets] == 0,
            {},
        (* else *)
            PacletInformation[First[paclets]]
        ]
    ]


PacletInformation[paclets:{___Paclet}] := PacletInformation /@ paclets

PacletInformation[paclet_Paclet] :=
    Join[
        Thread[$pacletInformationPIFields -> getPIValue[paclet, $pacletInformationPIFields]],
        {"Context" -> PgetContexts[paclet],
        "Enabled" -> isEnabled[paclet],
        "Loading" -> getLoadingState[paclet]}
    ]


$pacletInformationPIFields = {
    "Name",
    "Version",
    "BuildNumber",
    "Qualifier",
    "MathematicaVersion",
    "SystemID",
    "Description",
    "Category",
    "Creator",
    "Publisher",
    "Support",
    "Internal",
    "Location"  (* Not in the PI.m file, but always added during creation of a Paclet expression, and immutable. *)
}

(* These are fields in PacletInformation output that are not directly present as top-level fields in the PacletInfo.m file. *)
(*
    "Context",
    "Enabled",
    "Loading"
*)


(********************************  ResourcesLocate  **********************************)

(*
    Called from ResourceLocator to lookup resources found in paclets. For example, the
    DocumentationSearch package uses the ResourceLocator to find Index dirs. The ResourceLocator
    then calls here to get such resources from paclets.
    Returns a list: {{"/path/to/res", "PacletName"}, {"/path/to/res", "PacletName"}, ...}
    "PacletName" may be repeated, as a paclet can contain more than one of any given resource type.
    Only paths that are known to exist are returned.

    This is an important function, being the link between the ResourceLocator's idealized "horizontal"
    view of applications, and the PM's more detailed, primarily vertical, view. The way to think of the
    ResourceLocator is as a utility that sits on top of the PM and simplifies asking questions like "find
    all the Java resources in the system". That is a horizontal scan over all paclets and non-paclets
    (non-paclets handled by the ResourceLocator's internals) to find Java extensions (Java dirs in
    non-paclets).
*)

resourcesLocate[type_String] :=
    Module[{parts, lang, extensionType, paclets, p, pacletRootPath, ext, exts, extPaths, docIndexType},
        (* Special treatment for "Documentation/Language/Index" and "Documentation\Language\SpellIndex".
           Convert these to special forms recognized by the PacletManager ("DocumentationIndex" and
           "DocumentationSpellIndex").
           For other types, the type value is the name of an extension, like "JLink".
        *)
        lang = $Language;
        (* ResourceLocator uses names for resources different than PM uses for extensions, so correct those here. *)
        extensionType =
            Switch[type,
                "LibraryResources", "LibraryLink",
                "Java", "JLink",
                _, type
            ];
        If[StringMatchQ[type, "Documentation*"],
            parts = StringSplit[type, {"\\","/"}];
            If[MatchQ[parts, {"Documentation", _, _}],
                {extensionType, lang, docIndexType} = parts,
            (* else *)
                (* Shouldn't ever get here, but for completeness give this variable a harmless string value. *)
                docIndexType = ""
            ]
        ];
        paclets =
            takeLatestEnabledVersionOfEachPaclet[
                PCfindMatching["Extension" -> extensionType, "Collections" -> {"User", "Layout", "Legacy", "Extra"}]
            ];
        forEach[p, paclets,
            pacletRootPath = PgetPathToRoot[p];
            (* cullExtensionsFor only culls for $Language, not a caller-specified one, so we cannot use it
               for DocumentationIndex or DocumentationSpellIndex resources, which come in with a language
               specified (although I don't think it is ever different from $Language). Thus we do the language-culling
               separately for this case.
            *)
            If[extensionType == "Documentation",
                exts = cullExtensionsFor[PgetExtensions[p, "Documentation"], {"MathematicaVersion", "SystemID"}];
                (* Note the default is English here--we don't want a language-unspecified doc extension (which
                   always means English) to look like it might be referring to, say, Japanese.
                *)
                exts = Select[exts, languageMatches[lang, EXTgetProperty[#, "Language", "English"]]&];
                (* Note that for docindex and docspellindex resources, the code here requires that they be nested in
                   language-specific subdirs (e.g., Documentation/English/SpellIndex). The code that resolves doc notebook
                   links doesn't require language subdirs, so this here is a flaw. I should check for both cases.
                   For now I ignore this because all of our apps _do_ have such dirs, and this all might get ripped out
                   for a new search system anyway.
                *)
                extPaths =
                    forEach[ext, exts,
                        ExpandFileName[ToFileName[{pacletRootPath, EXTgetProperty[ext, "Root"], lang}, docIndexType]]
                    ] // Union,
            (* else *)
                exts = cullExtensionsFor[PgetExtensions[p, extensionType], {"MathematicaVersion", "SystemID", "Language"}];
                extPaths =
                    forEach[ext, exts,
                        ExpandFileName[ToFileName[pacletRootPath, EXTgetProperty[ext, "Root"]]]
                    ] // Union
            ];
            Thread[{Select[extPaths, FileExistsQ], p["Name"]}]
        ] // Flatten[#, 1]&
    ]


(******************************  RebuildPacletData  ********************************)

(* This message is actually issued only from Collections.m. *)
RebuildPacletData::lock = "Another process appears to be writing into the paclet repository at this time. Try RebuildPacletData[] again."

Options[RebuildPacletData] = {"Collections" -> All}

RebuildPacletData[OptionsPattern[]] :=
    Module[{collections, paclets, p, currentAuto, currentStartup, currentAutoTransient, currentDisabled, currentDisabledTransient,
              newAuto, newStartup, newAutoTransient, newPreloadData, newDeclareLoadData, newFuncInfo,
                 newDisabled, newDisabledTransient, loadingState, preloadData, declareLoadData, funcInfo},
        collections = OptionValue["Collections"];
        PCrebuild["Collections" -> collections];
        PCwrite[];

        resetFEData[];

        (* TODO: remove if not used. A no-op for now: *)
        clearMessageLinkCache[];
        
        makeContextMap[];

        (* First pass: remove all paclets that don't exist or are disabled from
            LoadingAutomatic, LoadingAutomaticTransient, LoadingStartup.
           Also update Disabled and DisabledTransient.
        *)
        {currentStartup, currentAuto, currentAutoTransient, currentDisabled, currentDisabledTransient} =
            {"LoadingStartup", "LoadingAutomatic", "LoadingAutomaticTransient", "Disabled", "DisabledTransient"} /. $managerData;

        (* Note that we skip Extra paclets in the first pass, as they need to be treated specially. *)
        paclets = PCfindMatching["Collections" -> {"User", "Layout", "Legacy", "DownloadedDocs"}];
        newAuto = newStartup = newAutoTransient = newPreloadData =
           newDeclareLoadData = newFuncInfo = newDisabled = newDisabledTransient = {};
        doForEach[p, paclets,
            If[isEnabled[p],
                {loadingState, preloadData, declareLoadData, funcInfo} = getLoadData[p];
                Switch[loadingState,
                    "Startup",
                        AppendTo[newStartup, PgetKey[p]];
                        If[MatchQ[preloadData, {__String}],
                            newPreloadData = Join[newPreloadData, preloadData]
                        ],
                    Automatic,
                        AppendTo[newAuto, PgetKey[p]];
                        If[MatchQ[declareLoadData, {{_String, _List}..}],
                            newDeclareLoadData = Join[newDeclareLoadData, declareLoadData]
                        ]
                ];
                If[MatchQ[funcInfo, {{_String, {_List...}}..}],
                    newFuncInfo = Join[newFuncInfo, funcInfo]
                ],
            (* else *)
                (* Disabled. *)
                AppendTo[newDisabled, PgetKey[p]]
            ]
        ];
        doDeclareLoad[newDeclareLoadData];
        doFunctionInformation[newFuncInfo];
        (* Go back and do more or less the same things for Extra paclets. They are treated separately because
           their data is not stored in $managerData.
        *)
        paclets = PCfindMatching["Collections" -> {"Extra"}];
        doForEach[p, paclets,
            If[isEnabled[p],
                {loadingState, preloadData, declareLoadData, funcInfo} = getLoadData[p];
                If[loadingState == Automatic,
                    AppendTo[newAutoTransient, PgetKey[p]];
                    doDeclareLoad[declareLoadData]
                ];
                doFunctionInformation[funcInfo],
            (* else *)
                (* Disabled. *)
                AppendTo[newDisabledTransient, PgetKey[p]]
            ]
        ];

        (* Now update the managerData with all the new info. *)
        updateManagerData[{
            "LoadingStartup" -> newStartup,
            "LoadingAutomatic" -> newAuto,
            "LoadingAutomaticTransient" -> newAutoTransient,
            "PreloadData" -> newPreloadData,
            "DeclareLoadData" -> newDeclareLoadData,
            "FunctionInformation" -> newFuncInfo,
            "Disabled" -> newDisabled,
            "DisabledTransient" -> newDisabledTransient,
            "CachesValid" -> {$SystemID}
        }, "Write" -> True];

        (* Modify this variable that can be used in Dynamics that need to update state when a paclet is installed. *)
        $pacletDataChangeTrigger++;
    ]



(* Next two functions encapsulate all the external things that need to be done when a paclet
   is either gained (via install or enable) or lost (via uninstall or disable). Some paclet
   functionality does not require anything done in advance (for example, finding of paclet files via Get
   or PacletResource is always a run-time lookup, and this will succeed merely by virtue of the paclet
   being present in the collection). Other things, though, need side-effects performed in advance, like
   adding a dir to the J/Link classpath, or setting up DeclareLoad definitions. These are the things
   that must be done/undone in the attach/detach operations. For speed purposes, we do not call attach
   on every paclet at startup; instead, we cache all the information needed to perform the setup, and load
   it quickly, without needing to walk through the set of paclets (e.g., the PreloadData and DeclareLoadData
   rules in managerData). Therefore, anything done here in attach/detach must have a corresponding rule in the
   managerData that is read at startup, and must be rewritten as necessary during the run time of the PM.
*)

attachPaclet[paclet_Paclet] :=
    Block[{loadingState, preloadData, declareLoadData, funcInfo, didModifyManagerData,
            currentAuto, currentAutoTransient, currentStartup, currentPreloadData,
              currentDeclareLoadData, currentFuncInfo, currentDisabled, currentDisabledTransient, enabled},

        didModifyManagerData = False;
        resetFEData[];

        enabled = isEnabled[paclet];

        {currentStartup, currentAuto, currentAutoTransient, currentPreloadData,
            currentDeclareLoadData, currentFuncInfo, currentDisabled, currentDisabledTransient} =
                {"LoadingStartup", "LoadingAutomatic", "LoadingAutomaticTransient", "PreloadData",
                    "DeclareLoadData", "FunctionInformation", "Disabled", "DisabledTransient"} /. $managerData;
        (* These values have $SystemID-specific sub-rules, so extract the appropriate values. *)
        {currentPreloadData, currentDeclareLoadData, currentFuncInfo} =
                $SystemID /. {currentPreloadData, currentDeclareLoadData, currentFuncInfo} /. $SystemID -> {};

        If[enabled,
            {loadingState, preloadData, declareLoadData, funcInfo} = getLoadData[paclet];
            Switch[loadingState,
                "Startup",
                    (* At one point I had (preloadData ~Complement~ currentPreloadData) here, but I think that's
                       wrong. When you attach a paclet you should load its startup code regardless of whether the
                       commands to do so are already in the preload data from a previous version of the paclet (and
                       thus were already done in this session). If you don't, then you won't pick up code changes when
                       a paclet is uninstalled and re-installed in a session. Similarly for declareLoadData below.
                    *)
                    doPreload[preloadData],
                Automatic,
                    doDeclareLoad[declareLoadData]
            ];
            doFunctionInformation[funcInfo];
        ];

        (* For persistent paclets, store data after quick sanity checks. *)
        If[!isInExtraCollection[paclet],
            If[enabled,
                If[MatchQ[preloadData, {__String}],
                    updateManagerData["PreloadData" -> DeleteDuplicates[Join[currentPreloadData, preloadData]]];
                    didModifyManagerData = True
                ];
                If[MatchQ[declareLoadData, {{__String}..}],
                    updateManagerData["DeclareLoadData" -> Join[Select[currentDeclareLoadData, !MemberQ[declareLoadData[[All,1]], First[#]]&], declareLoadData]];
                    didModifyManagerData = True
                ];
                If[MatchQ[funcInfo, {{_String, {_List...}}..}],
                    updateManagerData["FunctionInformation" -> Join[Select[currentFuncInfo, !MemberQ[funcInfo[[All,1]], First[#]]&], funcInfo]];
                    didModifyManagerData = True
                ];
                (* Only the above fields are part of the CachesValid determination, so now is the time to check it. *)
                If[didModifyManagerData, updateManagerData["CachesValid" -> {$SystemID}]];
                Switch[loadingState,
                    "Startup",
                        updateManagerData["LoadingStartup" -> DeleteDuplicates[Append[currentStartup, PgetKey[paclet]]]];
                        didModifyManagerData = True,
                    Automatic,
                        updateManagerData["LoadingAutomatic" -> DeleteDuplicates[Append[currentAuto, PgetKey[paclet]]]];
                        didModifyManagerData = True
                ],
            (* else *)
                (* Disabled *)
                updateManagerData["Disabled" -> DeleteDuplicates[Append[currentDisabled, PgetKey[paclet]]]];
                didModifyManagerData = True
            ],
        (* else *)
            (* Extra collection paclet *)
            If[enabled,
                If[loadingState == Automatic,
                    updateManagerData["LoadingAutomaticTransient" -> DeleteDuplicates[Append[currentAutoTransient, PgetKey[paclet]]]];
                    updateManagerData["CachesValid" -> {$SystemID}];
                    didModifyManagerData = True;
                    doDeclareLoad[declareLoadData]
                ];
                doFunctionInformation[funcInfo],
            (* else *)
                (* Disabled. *)
                updateManagerData["DisabledTransient" -> DeleteDuplicates[Append[currentDisabledTransient, PgetKey[paclet]]]];
                didModifyManagerData = True
            ]
        ];

        (* Nothing needed here to wire up Java extensions. Classpath modifications are handled by J/Link itself
           during LoadJavaClass.
           TODO: NET/Link needs a bit of work. It looks up dirs via contexts and then demands a subdir
           called 'assembly'. See the findAppDir function in NETLink.
        *)
        (* Modify this variable that can be used in Dynamics that need to update state when a paclet is installed. *)
        If[didModifyManagerData,
            writeManagerData[]
        ];

        $pacletDataChangeTrigger++;
    ]


detachPaclet[paclet_Paclet] :=
    Module[{pacletRootPath, ext, exts, extRoot, indexDirs, loadingState, preloadData, declareLoadData, funcInfo,
              currentStartup, currentAuto, currentAutoTransient, currentPreloadData, currentDeclareLoadData,
                 currentFuncInfo, currentDisabled, currentDisabledTransient, enabled, didModifyManagerData, olderPaclet},

        didModifyManagerData = False;

        enabled = isEnabled[paclet];

        (**** Close doc indexes. ****)
        pacletRootPath = PgetPathToRoot[paclet];
        (* cullExtensionsFor only culls for $Language, not a caller-specified one, so we cannot use it
           for DocumentationIndex or DocumentationSpellIndex resources, which come in with a language
           specified (although I don't think it is ever different from $Language). Thus we do the language-culling
           separately for this case.
        *)
        exts = cullExtensionsFor[PgetExtensions[paclet, "Documentation"], {"MathematicaVersion", "SystemID"}];
        (* Note the default is English here--we don't want a language-unspecified doc extension (which
           always means English) to look like it might be referring to, say, Japanese.
        *)
        exts = Select[exts, MatchQ[EXTgetProperty[#, "Language", "English"], "English" | $Language | All]&];
        (* Find all Index and SpellIndex dirs in each Documentation extension. Look for all languages
           and all possible locations.
        *)
        indexDirs =
            forEach[ext, exts,
                extRoot = EXTgetProperty[ext, "Root"];
                {ExpandFileName[ToFileName[{pacletRootPath, extRoot, "English"}, "Index"]],
                 ExpandFileName[ToFileName[{pacletRootPath, extRoot, $Language}, "Index"]],
                 ExpandFileName[ToFileName[{pacletRootPath, extRoot}, "Index"]],
                 ExpandFileName[ToFileName[{pacletRootPath, extRoot, "English"}, "SpellIndex"]],
                 ExpandFileName[ToFileName[{pacletRootPath, extRoot, $Language}, "SpellIndex"]],
                 ExpandFileName[ToFileName[{pacletRootPath, extRoot}, "SpellIndex"]]}
            ] // Flatten // Union // Select[#, DirectoryQ]&;
        If[Length[indexDirs] > 0,
            Needs["DocumentationSearch`"];
            Symbol["DocumentationSearch`CloseDocumentationIndex"] /@ indexDirs
        ];

        resetFEData[];

        {currentStartup, currentAuto, currentAutoTransient, currentPreloadData,
            currentDeclareLoadData, currentFuncInfo, currentDisabled, currentDisabledTransient} =
                {"LoadingStartup", "LoadingAutomatic", "LoadingAutomaticTransient", "PreloadData",
                    "DeclareLoadData", "FunctionInformation", "Disabled", "DisabledTransient"} /. $managerData;
        (* These values have $SystemID-specific sub-rules, so extract the appropriate values. *)
        {currentPreloadData, currentDeclareLoadData, currentFuncInfo} =
                $SystemID /. {currentPreloadData, currentDeclareLoadData, currentFuncInfo} /. $SystemID -> {};

        If[enabled,
            {loadingState, preloadData, declareLoadData, funcInfo} = getLoadData[paclet];
            If[loadingState == Automatic,
                undoDeclareLoad[paclet]
            ]
        ];
        (* For persistent paclets, store data after quick sanity checks. *)
        If[!isInExtraCollection[paclet],
            If[enabled,
                If[MatchQ[preloadData, {__String}],
                    updateManagerData["PreloadData" -> Complement[currentPreloadData, preloadData]];
                    didModifyManagerData = True
                ];
                If[MatchQ[declareLoadData, {{__String}..}],
                    updateManagerData["DeclareLoadData" -> Select[currentDeclareLoadData, !MemberQ[declareLoadData[[All,1]], First[#]]&]];
                    didModifyManagerData = True
                ];
                If[MatchQ[funcInfo, {{_String, {_List...}}..}],
                    updateManagerData["FunctionInformation" -> Select[currentFuncInfo, !MemberQ[funcInfo[[All,1]], First[#]]&]];
                    didModifyManagerData = True
                ];
                If[didModifyManagerData, updateManagerData["CachesValid" -> {$SystemID}]];
                Switch[loadingState,
                    "Startup",
                        updateManagerData["LoadingStartup" -> DeleteCases[currentStartup, PgetKey[paclet]]];
                        didModifyManagerData = True,
                    Automatic,
                        updateManagerData["LoadingAutomatic" -> DeleteCases[currentAuto, PgetKey[paclet]]];
                        didModifyManagerData = True
                ],
            (* else *)
                (* Disabled *)
                updateManagerData["Disabled" -> DeleteCases[currentDisabled, PgetKey[paclet]]];
                didModifyManagerData = True
            ],
        (* else *)
            (* Extra collection paclet. *)
            If[enabled,
                If[loadingState == Automatic,
                    updateManagerData["LoadingAutomaticTransient" -> DeleteCases[currentAutoTransient, PgetKey[paclet]]];
                    updateManagerData["CachesValid" -> {$SystemID}];
                    didModifyManagerData = True
                ],
            (* else *)
                (* Disabled. *)
                updateManagerData["DisabledTransient" -> DeleteCases[currentDisabledTransient, PgetKey[paclet]]];
                didModifyManagerData = True
            ]
        ];

        If[didModifyManagerData,
            writeManagerData[]
        ];

        (* Set up data for newly-exposed versions of the paclet we lost. Note that because pc hasn't yet been rebuilt,
           PacletFind will still find the paclet we are detaching, so we have to eliminate it from the result.
        *)
        olderPaclet = DeleteCases[PacletFind[paclet["Name"], "Internal"->All], paclet];
        If[MatchQ[olderPaclet, {__Paclet}],
            attachPaclet[First[olderPaclet]]
        ];

        (* Cannot remove from J/Link classpath. *)

        $pacletDataChangeTrigger++;
    ]


(***********************  Paclet Management Dialog  *************************)

pacletManagementDialog[] :=
    CreateDialog[pacletManagementGrid[], WindowTitle -> "Paclet Management",
                     WindowSize -> {All, 500}, WindowElements -> "VerticalScrollBar"]

pacletManagementDynamicGrid[] :=
    Dynamic[
        $pacletDataChangeTrigger;
        pacletManagementGrid[],
        TrackedSymbols :> {$pacletDataChangeTrigger}
    ]

pacletManagementGrid[] :=
    Module[{data, headerRow, dataRows},
        data = pacletManagementData[];
        headerRow = {{Item[makeGridElement["Name", FontWeight -> Bold], Alignment -> Center],
                      makeGridElement["Version", FontWeight -> Bold], makeGridElement["Description", FontWeight -> Bold],
                      makeGridElement["Autoload", FontWeight -> Bold], ""}};
        dataRows =  makeRow /@ PacletManager`Package`pacletManagementData[];
        Dynamic[
            Grid[ Join[headerRow, dataRows], Dividers -> {{False, {True}, False}, {False, {True}, False}}, Alignment -> {{Left, Center}}],
            TrackedSymbols :> {$pacletDataChangeTrigger}
        ]
    ]

makeRow[rules_List] :=
    Module[{name, nameLinkOpts, nameLinkTooltip, version, desc, descTooltip, loadButtonOpts, loadButtonTooltip, updateButtonOpts, uninstallButtonOpts},
        {name, nameLinkOpts, nameLinkTooltip, version, desc, loadButtonOpts, loadButtonTooltip, updateButtonOpts, uninstallButtonOpts} =
            {"Name", "NameLinkOptions", "NameLinkTooltip", "Version", "Description", "LoadButtonOptions", "LoadButtonTooltip", "UpdateButtonOptions", "UninstallButtonOptions"} /. rules;
        {
            Tooltip[Button[makeGridElement[makeShortString[name, 30]], Inherited, BaseStyle -> "Link",
                                Appearance -> Inherited,  Evaluator -> Automatic, Evaluate[Sequence @@ nameLinkOpts]], nameLinkTooltip],
            makeGridElement[makeShortString[version, 8]],
            Tooltip[makeGridElement[makeShortString[desc, 45]], desc],
            Checkbox[],
            Row[{
                If[loadButtonOpts =!= None,
                    Tooltip[Button[makeGridElement["Load"], Inherited, Evaluator -> Automatic,
                                FrameMargins -> Tiny, Evaluate[Sequence @@ loadButtonOpts]],
                            loadButtonTooltip
                    ],
                (* else *)
                    Invisible[Button["Load", Null, FrameMargins -> Tiny]]
                ],
                Button[makeGridElement["Update"], Inherited, Evaluator -> Automatic,
                                FrameMargins -> Tiny, Evaluate[Sequence @@ updateButtonOpts]],
                Button[makeGridElement["Uninstall"], Inherited, Evaluator -> Automatic,
                                FrameMargins -> Tiny, Evaluate[Sequence @@ uninstallButtonOpts]]
            }]
        }
    ]

makeGridElement[s_, opts:OptionsPattern[]] := Style[s, opts, FontSize -> 10, FontFamily -> "Helvetica"]

makeShortString[s_String, maxChars_Integer] :=
    If[StringLength[s] <= maxChars, s, StringTake[s, maxChars - 1] <> "\[Ellipsis]"]


(* Keep this list updated... *)
$dataPaclets = {"WordData", "ParticleData", "IsotopeData", "FinancialData", "ExampleData",
                "ElementData", "CountryData", "CityData", "ChemicalData", "AstronomicalData"}

pacletManagementData[] :=
    Module[{paclets, nonDataPaclets, userPaclets},
        paclets = PacletFind["Enabled"->All];
        nonDataPaclets = Select[paclets, !MemberQ[$dataPaclets, StringReplace[#["Name"], name:Except[{"_", "-"}].. ~~ ___ :> name]] &];
        userPaclets = Select[nonDataPaclets, !StringMatchQ[#["Location"], $InstallationDirectory ~~ __, IgnoreCase -> True] &];
        Function[{p},
            Join[PacletInformation[p],
                 {"NameLinkOptions" -> {ButtonData -> "paclet:" <> p["Name"] <> "/about"},
                  "NameLinkTooltip" -> "paclet:" <> p["Name"] <> "/about",
                  "LoadButtonOptions" -> If[StringQ[FindFile[p["Name"]<>"`"]], {ButtonFunction->(Get[p["Name"]<>"`"]&)}, None],
                  "LoadButtonTooltip" -> "Get[\"" <> p["Name"] <> "`\"]",
                  "UninstallButtonOptions" -> {ButtonFunction -> (confirmUninstall[p["Name"]]&), Method->"Queued"},
                  "UpdateButtonOptions" -> {ButtonFunction -> (PacletUpdate[#["Name"]]&), Enabled -> (Length[PacletCheckUpdate[p["Name"]]] > 0)}
                  }
            ]
        ] /@ userPaclets
    ]


confirmUninstall[name_String] :=
    Module[{dlg},
        dlg = ChoiceDialog["Are you sure you want to completely remove the paclet " <> name <>
                                " from your system?", "Yes" -> True, "No" -> $Canceled];
        If[dlg, PacletUninstall[name]]
    ]


(***********************  PacletManager Persistent Data  *************************)

(* These are Package`-level functions but called outside of this package (by the
   SystemInformation dialog).
*)

(* Returns information about the most-recently-updated PacletSite.
   This is a `Package-level function called by the SystemInformation dialog.
   Returns either:

      - A list consisting of two elements: The site URL and the date of last successful
        update in M Date[] format. Only considers wolfram.com sites.
        ex:  {"http://pacletserver.wolfram.com", {2006, 10, 2, 0, 49, 16.9325775}}

      - Null, if no wolfram.com sites exist, or none have yet been updated.

*)
lastUpdatedPacletSite[] :=
    Module[{siteURL, date},
        {siteURL, date} = {"LastUpdatedSite", "LastUpdatedSiteDate"} /. $managerData;
        If[StringQ[siteURL] && Head[date] === List,
            {siteURL, date},
        (* else *)
            (* No wolfram sites exist, or none have ever been updated. *)
            Null
        ]
    ]


(* Returns information about the most-recently-used PacletSite, meaning the one from which
   a paclet was last downloaded.
   This is a `Package-level function called by the SystemInformation dialog.
   Returns either:

      - A list consisting of two elements: The site URL and the date of last successful
        use in M Date[] format. Only considers wolfram.com sites.
        ex:  {"http://pacletserver.wolfram.com", {2006, 10, 2, 0, 49, 16.9325775}}

      - Null, if no wolfram.com sites exist, or none have yet been used.

*)
lastUsedPacletSite[] :=
    Module[{siteURL, date},
        {siteURL, date} = {"LastUsedSite", "LastUsedSiteDate"} /. $managerData;
        If[StringQ[siteURL] && Head[date] === List,
            {siteURL, date},
        (* else *)
            Null
        ]
    ]


(*
    Returns integer, or $Failed on any problem.

    TODO: Talk to Lou about getting this out of the SystemInformation dialog.
*)
numPacletsDownloaded[] = $Failed




(*********************  Paclet Directory Funcs  **********************)

(* When dirs are added, they are canonicalized by a call to ExpandFileName. Whenever
   we test to see if a dir is among PacletDirectories[], we canonicalize it
   as well. This allows us to use ==, MemberQ, etc. to test if a dir is a member.
   Canonicalization handles expansion of . and .., conversions to correct case
   on Windows, etc.
*)

Options[PacletDirectoryAdd] = Options[PacletDirectoryRemove] = {"Rebuild" -> True}


PacletDirectoryAdd[dirs___String, opts:OptionsPattern[]] := PacletDirectoryAdd[{dirs}, opts]

PacletDirectoryAdd[dirs:{___String}, OptionsPattern[]] :=
    executionProtect @
    Module[{wasModified, canonicalPath, oldExtraPaclets},
        wasModified = False;
        Function[{dir},
            canonicalPath = ExpandFileName[dir];
            If[!MemberQ[$extraPacletDirs, canonicalPath],
                AppendTo[$extraPacletDirs, canonicalPath];
                wasModified = True
            ]
        ] /@ dirs;
        If[wasModified && TrueQ[OptionValue["Rebuild"]],
            oldExtraPaclets = PCfindMatching["Collections"->{"Extra"}];
            PCrebuild["Collections" -> "Extra"];
            makeContextMap[];
            (* Call attach on the new paclets. *)
            attachPaclet /@ Complement[PCfindMatching["Collections"->{"Extra"}], oldExtraPaclets]
        ];
        $extraPacletDirs
    ]


PacletDirectoryRemove[dirs__String, opts:OptionsPattern[]] := PacletDirectoryRemove[{dirs}, opts]

PacletDirectoryRemove[dirs:{___String}, OptionsPattern[]] :=
    executionProtect @
    Module[{wasModified, canonicalPath, newExtraPacletDirs, currentExtraPaclets, currentPacletsInTheseDirs},
        wasModified = False;
        newExtraPacletDirs = $extraPacletDirs;
        Function[{dir},
            canonicalPath = ExpandFileName[dir];
            If[MemberQ[$extraPacletDirs, canonicalPath],
                newExtraPacletDirs = DeleteCases[newExtraPacletDirs, canonicalPath];
                wasModified = True
            ]
        ] /@ dirs;
        If[wasModified && TrueQ[OptionValue["Rebuild"]],
            (* We need to call detach on the paclets that are disappearing, and we need to do that
               before we remove them from the collection by calling PCrebuild (after they are removed,
               some aspects of what detach needs to do will not work properly). Thus we manually call
               createPacletsFromParentDirs to see what these paclets are, take the ones from that set
               that are actually present in the existing Extra collection, and detach them.
               Wrap the createPacletsFromParentDirs in Quiet in case the dirs have junk in them (like
               incomplete or broken paclets).
            *)
            currentExtraPaclets = PCfindMatching["Collections"->{"Extra"}];
            currentPacletsInTheseDirs = Quiet[createPacletsFromParentDirs[dirs, 2]];
            detachPaclet /@ Intersection[currentExtraPaclets, currentPacletsInTheseDirs];
            $extraPacletDirs = newExtraPacletDirs;
            PCrebuild["Collections" -> "Extra"];
            makeContextMap[]
        ];
        $extraPacletDirs
    ]


(***********************************  Utility funcs  **************************************)

isInExtraCollection[paclet_Paclet] :=
    Module[{isInExtraCollection = False, location},
        If[Length[$extraPacletDirs] > 0,
            location = paclet["Location"];
            Scan[
                Function[{extraDir},
                    If[StringMatchQ[location, extraDir ~~ ___, IgnoreCase->True],
                        isInExtraCollection = True;
                        Return[]
                    ]
                ],
                $extraPacletDirs
            ]
        ];
        isInExtraCollection
    ]


End[]

