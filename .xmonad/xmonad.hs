import XMonad
import XMonad.Actions.SpawnOn
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops(fullscreenEventHook,ewmh)
import XMonad.Hooks.SetWMName
import XMonad.Layout.Grid
import XMonad.Layout.ResizableTile
import XMonad.Layout.LayoutHints
import XMonad.Layout.Cross
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.NoBorders
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.Scratchpad
import XMonad.Util.NamedScratchpad
import qualified XMonad.StackSet as W
-- import qualified XMonad.StackSet as S
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
 


myManageHook = 
	manageDocks 
	<+> manageSpawn 
	<+> 
	(composeAll [ isFullscreen --> doFullFloat
    , className =? "Gimp" --> doFloat
    , className =? "Vncviewer" --> doFloat
    , className =? "PrisonArchitect.x86_64" --> doFullFloat
    , className =? "hl_linux" --> doFloat
    , className =? "hl2_linux" --> doFloat
    , className =? "chromium" --> doFloat
    , className =? "Pinentry" --> doFloat
    , className =? "GameClient.exe" --> doFloat
    , className =? "Gajim" --> doShift "ι"
    , className =? "Thunderbird" --> doShift "θ"
    ]) 
	<+> namedScratchpadManageHook myScratchPads
 

manageScratchPad :: ManageHook
manageScratchPad = scratchpadManageHook (W.RationalRect l t w h)

  where

    h = 0.2    -- terminal height, 10%
    w = 0.7       -- terminal width, 100%
    t = 1 - h   -- distance from top edge, 90%
    l = (1 - w)/2   -- distance from left edge, 0%



myScratchPads = [ NS "mixer"	spawnMixer findMixer manageMixer
		, NS "terminal"			spawnTerm findTerm manageTerm
        , NS "bitwarden"         spawnBitwarden findBitwarden manageBitwarden
        , NS "quicknote"        spawnQuicknote findQuicknote manageQuicknote
		]
	where
		spawnMixer = "pavucontrol"
		findMixer = className =? "Pavucontrol"
		manageMixer = customFloating $ W.RationalRect l t w h
		
		 where
			h = 0.6       -- height, 60% 
			w = 0.6       -- width, 60% 
			t = (1 - h)/2 -- centered top/bottom
			l = (1 - w)/2 -- centered left/right


		spawnTerm = myTerminal ++ " -name scratchpad"
		findTerm = resource =? "scratchpad"
 		manageTerm = customFloating $ W.RationalRect l t w h

		 where

			h = 0.5    -- terminal height, 20%
			w = 0.7       -- terminal width, 70%
			t = 1 - h   -- distance from top edge
			l = (1 - w)/2   -- distance from left edge


		spawnQuicknote = myTerminal ++ " -name quicknote -e notology -q"
		findQuicknote = resource =? "quicknote"
		manageQuicknote = customFloating $ W.RationalRect l t w h

		 where

			h = 0.6    -- terminal height, 60%
			w = 0.6       -- terminal width, 60%
			t = 1 - h   -- distance from top edge
			l = (1 - w)/2   -- distance from left edge

		spawnBitwarden = "bitwarden-bin"
		findBitwarden = resource =? "bitwarden"
		manageBitwarden = customFloating $ W.RationalRect l t w h

		 where

			h = 0.8    -- terminal height, 80%
			w = 0.5       -- terminal width, 50%
			t = 1 - h   -- distance from top edge
			l = (1 - w)/2   -- distance from left edge





myWorkspaces    = ["α","β","γ","δ","ε","ζ","η","θ","ι"]

myLogHook xmproc = do
	fadeInactiveLogHook 0.8 
	<+> dynamicLogWithPP xmobarPP
	{ ppOutput = hPutStrLn xmproc
	, ppTitle = xmobarColor "#01b8e0" "" . shorten 50
	}

myTerminal	= "urxvt"


myLayout = tiled ||| Mirror tiled ||| Full ||| Grid   where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

 
     -- The default number of windows in the master pane
     nmaster = 1
 
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
 
     -- Percent of screen to increment by when resizing panes
     delta   = 2/100
 

main = do
    xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
    xmonad $ defaultConfig
        { manageHook = myManageHook -- make sure to include myManageHook definition from above
--                        <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  smartBorders $ myLayout
        , startupHook = setWMName "LG3D"
        , handleEventHook = mconcat
                          [ docksEventHook
                          , fullscreenEventHook
                          , handleEventHook defaultConfig ]
        , logHook = myLogHook xmproc
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
	    , terminal = myTerminal
	    , workspaces = myWorkspaces
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask,		xK_l), spawn "xscreensaver-command -lock")
	    , ((mod4Mask .|. shiftMask,		xK_r), spawn "terminator -e ranger")
	    , ((mod4Mask .|. shiftMask,		xK_f), spawn "firefox")
	    , ((mod4Mask .|. shiftMask,	xK_Return), spawn "terminator")
	    , ((mod4Mask .|. shiftMask, xK_t), namedScratchpadAction myScratchPads "terminal")
	    , ((mod4Mask .|. shiftMask, xK_m), namedScratchpadAction myScratchPads "mixer")
	    , ((mod4Mask .|. shiftMask, xK_n), namedScratchpadAction myScratchPads "quicknote")
	    , ((mod4Mask .|. shiftMask, xK_b), namedScratchpadAction myScratchPads "bitwarden")
	    , ((mod4Mask ,		xK_q), spawn "killall xmobar; xmonad --recompile; xmonad --restart")
	    , ((0                     , 0x1008FF11), spawn "amixer -q sset Master 2%-")
	    , ((0                     , 0x1008FF13), spawn "amixer -q sset Master 2%+")
		, ((0                     , 0x1008ff4a), spawn "xset dpms force off")
        , ((0                     , 0x1008ffb2), spawn "amixer set Capture toggle")
		, ((0                     , 0x1008FF12), spawn "amixer set Master toggle")
		, ((0                     , 0x1008FF03), spawn "xbacklight -dec 5")
		, ((0                     , 0x1008FF02), spawn "xbacklight -inc 5")

        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot")
        ]
