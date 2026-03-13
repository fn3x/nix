{
lib,
config,
inputs,
pkgs,
...
}:
{
  options = {
    noctalia.enable = lib.mkEnableOption "enables noctalia";
  };

  config = lib.mkIf config.noctalia.enable {
    programs.noctalia-shell = {
      enable = true;
      systemd.enable = true;
      settings = {
        settingsVersion = 57;

        bar = {
          barType = "simple";
          position = "top";
          monitors = [];
          density = "spacious";
          showOutline = false;
          showCapsule = true;
          capsuleOpacity = 1;
          capsuleColorKey = "none";
          widgetSpacing = 10;
          contentPadding = 0;
          fontScale = 1.11;
          enableExclusionZoneInset = true;
          backgroundOpacity = 0.93;
          useSeparateOpacity = false;
          floating = false;
          marginVertical = 4;
          marginHorizontal = 4;
          frameThickness = 8;
          frameRadius = 12;
          outerCorners = true;
          hideOnOverview = true;
          displayMode = "always_visible";
          autoHideDelay = 500;
          autoShowDelay = 150;
          showOnWorkspaceSwitch = true;

          widgets = {
            left = [
              {
                compactMode = false;
                hideMode = "visible";
                hideWhenIdle = false;
                id = "MediaMini";
                maxWidth = 500;
                panelShowAlbumArt = true;
                scrollingMode = "hover";
                showAlbumArt = true;
                showArtistFirst = false;
                showProgressRing = true;
                showVisualizer = true;
                textColor = "none";
                useFixedWidth = false;
                visualizerType = "wave";
              }
            ];

            center = [
              {
                clockColor = "none";
                customFont = "";
                formatHorizontal = "HH:mm:ss dd MMMM, dddd";
                formatVertical = "HH mm - dd MM";
                id = "Clock";
                tooltipFormat = "HH:mm:ss ddd, MMM dd";
                useCustomFont = false;
              }
            ];

            right = [
              {
                displayMode = "forceOpen";
                iconColor = "none";
                id = "KeyboardLayout";
                showIcon = true;
                textColor = "none";
              }
              {
                compactMode = true;
                diskPath = "/";
                iconColor = "none";
                id = "SystemMonitor";
                showCpuCores = false;
                showCpuFreq = false;
                showCpuTemp = true;
                showCpuUsage = true;
                showDiskAvailable = false;
                showDiskUsage = false;
                showDiskUsageAsPercent = false;
                showGpuTemp = false;
                showLoadAverage = false;
                showMemoryAsPercent = false;
                showMemoryUsage = true;
                showNetworkStats = false;
                showSwapUsage = false;
                textColor = "none";
                useMonospaceFont = true;
                usePadding = false;
              }
              {
                blacklist = [];
                chevronColor = "none";
                colorizeIcons = false;
                drawerEnabled = false;
                hidePassive = true;
                id = "Tray";
                pinned = [];
              }
              {
                displayMode = "onhover";
                iconColor = "none";
                id = "Volume";
                middleClickCommand = "pwvucontrol || pavucontrol";
                textColor = "none";
              }
              {
                hideWhenZero = false;
                hideWhenZeroUnread = false;
                iconColor = "none";
                id = "NotificationHistory";
                showUnreadBadge = true;
                unreadBadgeColor = "primary";
              }
            ];
          };

          mouseWheelAction = "none";
          reverseScroll = false;
          mouseWheelWrap = true;
          middleClickAction = "none";
          middleClickFollowMouse = false;
          middleClickCommand = "";
          rightClickAction = "controlCenter";
          rightClickFollowMouse = true;
          rightClickCommand = "";
          screenOverrides = [];
        };

        general = {
          avatarImage = "";
          dimmerOpacity = 0.1;
          showScreenCorners = false;
          forceBlackScreenCorners = false;
          scaleRatio = 1.1;
          radiusRatio = 1;
          iRadiusRatio = 1;
          boxRadiusRatio = 1;
          screenRadiusRatio = 1;
          animationSpeed = 1;
          animationDisabled = false;
          compactLockScreen = false;
          lockScreenAnimations = false;
          lockOnSuspend = true;
          showSessionButtonsOnLockScreen = true;
          showHibernateOnLockScreen = false;
          enableLockScreenMediaControls = false;
          enableShadows = true;
          enableBlurBehind = true;
          shadowDirection = "bottom_right";
          shadowOffsetX = 2;
          shadowOffsetY = 3;
          language = "";
          allowPanelsOnScreenWithoutBar = true;
          showChangelogOnStartup = true;
          telemetryEnabled = false;
          enableLockScreenCountdown = true;
          lockScreenCountdownDuration = 10000;
          autoStartAuth = false;
          allowPasswordWithFprintd = false;
          clockStyle = "custom";
          clockFormat = "hh\nmm";
          passwordChars = false;
          lockScreenMonitors = [];
          lockScreenBlur = 0;
          lockScreenTint = 0;

          keybinds = {
            keyUp    = [ "Up" ];
            keyDown  = [ "Down" ];
            keyLeft  = [ "Left" ];
            keyRight = [ "Right" ];
            keyEnter  = [ "Return" "Enter" ];
            keyEscape = [ "Esc" ];
            keyRemove = [ "Del" ];
          };

          reverseScroll = false;
        };

        ui = {
          fontDefault = "Berkeley Mono";
          fontFixed = "Berkeley Mono";
          fontDefaultScale = 1;
          fontFixedScale = 1;
          tooltipsEnabled = true;
          scrollbarAlwaysVisible = true;
          boxBorderEnabled = false;
          panelBackgroundOpacity = 0.93;
          translucentWidgets = false;
          panelsAttachedToBar = true;
          settingsPanelMode = "attached";
          settingsPanelSideBarCardStyle = false;
        };

        location = {
          name = "Yerevan";
          weatherEnabled = true;
          weatherShowEffects = true;
          useFahrenheit = false;
          use12hourFormat = false;
          showWeekNumberInCalendar = false;
          showCalendarEvents = true;
          showCalendarWeather = true;
          analogClockInCalendar = true;
          firstDayOfWeek = 1;
          hideWeatherTimezone = false;
          hideWeatherCityName = false;
        };

        calendar = {
          cards = [
            { enabled = true; id = "calendar-header-card"; }
            { enabled = true; id = "calendar-month-card"; }
            { enabled = true; id = "weather-card"; }
          ];
        };

        wallpaper = {
          enabled = true;
          overviewEnabled = false;
          directory = "";
          monitorDirectories = [];
          enableMultiMonitorDirectories = false;
          showHiddenFiles = false;
          viewMode = "single";
          setWallpaperOnAllMonitors = true;
          fillMode = "crop";
          fillColor = "#000000";
          useSolidColor = false;
          solidColor = "#1a1a2e";
          automationEnabled = false;
          wallpaperChangeMode = "random";
          randomIntervalSec = 300;
          transitionDuration = 1500;
          transitionType = "random";
          skipStartupTransition = false;
          transitionEdgeSmoothness = 0.05;
          panelPosition = "follow_bar";
          hideWallpaperFilenames = false;
          overviewBlur = 0.4;
          overviewTint = 0.6;
          useWallhaven = false;
          wallhavenQuery = "";
          wallhavenSorting = "relevance";
          wallhavenOrder = "desc";
          wallhavenCategories = "111";
          wallhavenPurity = "100";
          wallhavenRatios = "";
          wallhavenApiKey = "";
          wallhavenResolutionMode = "atleast";
          wallhavenResolutionWidth = "";
          wallhavenResolutionHeight = "";
          sortOrder = "name";
          favorites = [];
        };

        appLauncher = {
          enableClipboardHistory = false;
          autoPasteClipboard = false;
          enableClipPreview = true;
          clipboardWrapText = true;
          clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
          clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
          position = "center";
          pinnedApps = [];
          sortByMostUsed = true;
          terminalCommand = "${inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default} -e";
          customLaunchPrefixEnabled = false;
          customLaunchPrefix = "";
          viewMode = "list";
          showCategories = true;
          iconMode = "tabler";
          showIconBackground = false;
          enableSettingsSearch = true;
          enableWindowsSearch = true;
          enableSessionSearch = true;
          ignoreMouseInput = false;
          screenshotAnnotationTool = "";
          overviewLayer = false;
          density = "default";
        };

        controlCenter = {
          position = "close_to_bar_button";
          diskPath = "/";

          shortcuts = {
            left = [
              { id = "AirplaneMode"; }
              { id = "Network"; }
              { id = "Bluetooth"; }
            ];
            right = [
              { id = "Notifications"; }
              { id = "NightLight"; }
              { id = "WallpaperSelector"; }
            ];
          };

          cards = [
            { enabled = true;  id = "profile-card"; }
            { enabled = true;  id = "shortcuts-card"; }
            { enabled = true;  id = "audio-card"; }
            { enabled = false; id = "brightness-card"; }
            { enabled = true;  id = "weather-card"; }
            { enabled = true;  id = "media-sysmon-card"; }
          ];
        };

        systemMonitor = {
          cpuWarningThreshold = 80;
          cpuCriticalThreshold = 90;
          tempWarningThreshold = 80;
          tempCriticalThreshold = 90;
          gpuWarningThreshold = 80;
          gpuCriticalThreshold = 90;
          memWarningThreshold = 80;
          memCriticalThreshold = 90;
          swapWarningThreshold = 80;
          swapCriticalThreshold = 90;
          diskWarningThreshold = 80;
          diskCriticalThreshold = 90;
          diskAvailWarningThreshold = 20;
          diskAvailCriticalThreshold = 10;
          batteryWarningThreshold = 20;
          batteryCriticalThreshold = 5;
          enableDgpuMonitoring = true;
          useCustomColors = false;
          warningColor = "";
          criticalColor = "";
          externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
        };

        noctaliaPerformance = {
          disableWallpaper = true;
          disableDesktopWidgets = true;
        };

        dock = {
          enabled = false;
          position = "bottom";
          displayMode = "auto_hide";
          dockType = "floating";
          backgroundOpacity = 1;
          floatingRatio = 1;
          size = 1;
          onlySameOutput = true;
          monitors = [];
          pinnedApps = [];
          colorizeIcons = false;
          showLauncherIcon = false;
          launcherPosition = "end";
          launcherIconColor = "none";
          pinnedStatic = false;
          inactiveIndicators = false;
          groupApps = false;
          groupContextMenuMode = "extended";
          groupClickAction = "cycle";
          groupIndicatorStyle = "dots";
          deadOpacity = 0.6;
          animationSpeed = 1;
          sitOnFrame = false;
          showDockIndicator = false;
          indicatorThickness = 3;
          indicatorColor = "primary";
          indicatorOpacity = 0.6;
        };

        network = {
          wifiEnabled = true;
          airplaneModeEnabled = false;
          bluetoothRssiPollingEnabled = false;
          bluetoothRssiPollIntervalMs = 60000;
          networkPanelView = "wifi";
          wifiDetailsViewMode = "grid";
          bluetoothDetailsViewMode = "grid";
          bluetoothHideUnnamedDevices = false;
          disableDiscoverability = false;
          bluetoothAutoConnect = true;
        };

        sessionMenu = {
          enableCountdown = true;
          countdownDuration = 10000;
          position = "center";
          showHeader = true;
          showKeybinds = true;
          largeButtonsStyle = true;
          largeButtonsLayout = "single-row";

          powerOptions = [
            { action = "lock";            command = ""; countdownEnabled = true;  enabled = true;  keybind = "1"; }
            { action = "suspend";         command = ""; countdownEnabled = true;  enabled = true;  keybind = "2"; }
            { action = "hibernate";       command = ""; countdownEnabled = true;  enabled = true;  keybind = "3"; }
            { action = "reboot";          command = ""; countdownEnabled = true;  enabled = true;  keybind = "4"; }
            { action = "logout";          command = ""; countdownEnabled = true;  enabled = true;  keybind = "5"; }
            { action = "shutdown";        command = ""; countdownEnabled = true;  enabled = true;  keybind = "6"; }
            { action = "rebootToUefi";    command = ""; countdownEnabled = true;  enabled = true;  keybind = "7"; }
            { action = "userspaceReboot"; command = ""; countdownEnabled = true;  enabled = false; keybind = "";  }
          ];
        };

        notifications = {
          enabled = true;
          enableMarkdown = false;
          density = "compact";
          monitors = [];
          location = "top_right";
          overlayLayer = true;
          backgroundOpacity = 1;
          respectExpireTimeout = false;
          lowUrgencyDuration = 3;
          normalUrgencyDuration = 8;
          criticalUrgencyDuration = 15;
          clearDismissed = true;

          saveToHistory = {
            low = false;
            normal = true;
            critical = true;
          };

          sounds = {
            enabled = false;
            volume = 0.5;
            separateSounds = false;
            criticalSoundFile = "";
            normalSoundFile = "";
            lowSoundFile = "";
            excludedApps = "discord,firefox,chrome,brave,chromium,edge";
          };

          enableMediaToast = false;
          enableKeyboardLayoutToast = false;
          enableBatteryToast = true;
        };

        osd = {
          enabled = true;
          location = "left";
          autoHideMs = 2000;
          overlayLayer = true;
          backgroundOpacity = 1;
          enabledTypes = [ 0 1 2 ];
          monitors = [];
        };

        audio = {
          volumeStep = 5;
          volumeOverdrive = false;
          spectrumFrameRate = 60;
          visualizerType = "wave";
          mprisBlacklist = [];
          preferredPlayer = "";
          volumeFeedback = false;
          volumeFeedbackSoundFile = "";
        };

        brightness = {
          brightnessStep = 5;
          enforceMinimum = true;
          enableDdcSupport = false;
          backlightDeviceMappings = [];
        };

        colorSchemes = {
          useWallpaperColors = false;
          predefinedScheme = "Gruvbox";
          darkMode = true;
          schedulingMode = "off";
          manualSunrise = "06:30";
          manualSunset = "18:30";
          generationMethod = "tonal-spot";
          monitorForColors = "";
        };

        templates = {
          activeTemplates = [
            { enabled = true; id = "gtk"; }
            { enabled = true; id = "qt"; }
            { enabled = true; id = "discord"; }
            { enabled = true; id = "vicinae"; }
            { enabled = true; id = "telegram"; }
            { enabled = true; id = "niri"; }
            { enabled = true; id = "steam"; }
          ];
          enableUserTheming = false;
        };

        nightLight = {
          enabled = false;
          forced = false;
          autoSchedule = true;
          nightTemp = "4000";
          dayTemp = "6500";
          manualSunrise = "06:30";
          manualSunset = "18:30";
        };

        hooks = {
          enabled = false;
          wallpaperChange = "";
          darkModeChange = "";
          screenLock = "";
          screenUnlock = "";
          performanceModeEnabled = "";
          performanceModeDisabled = "";
          startup = "";
          session = "";
        };

        plugins = {
          autoUpdate = false;
        };

        idle = {
          enabled = false;
          screenOffTimeout = 600;
          lockTimeout = 660;
          suspendTimeout = 1800;
          fadeDuration = 5;
          screenOffCommand = "";
          lockCommand = "";
          suspendCommand = "";
          resumeScreenOffCommand = "";
          resumeLockCommand = "";
          resumeSuspendCommand = "";
          customCommands = "[]";
        };

        desktopWidgets = {
          enabled = true;
          overviewEnabled = true;
          gridSnap = true;
          gridSnapScale = true;

          monitorWidgets = [
            {
              name = "DP-1";
              widgets = [
                {
                  clockColor = "none";
                  clockStyle = "digital";
                  customFont = "";
                  format = "HH:mm\\nd MMMM yyyy";
                  id = "Clock";
                  roundedCorners = true;
                  scale = 1.937358426810417;
                  showBackground = true;
                  useCustomFont = false;
                  x = 32;
                  y = 96;
                }
                {
                  id = "Weather";
                  roundedCorners = true;
                  scale = 1.1586939125069184;
                  showBackground = true;
                  x = 32;
                  y = 416;
                }
                {
                  hideMode = "visible";
                  id = "MediaPlayer";
                  roundedCorners = true;
                  scale = 1.2733593793415183;
                  showAlbumArt = true;
                  showBackground = true;
                  showButtons = true;
                  showVisualizer = true;
                  visualizerType = "linear";
                  x = 352;
                  y = 96;
                }
              ];
            }
          ];
        };
      };
    };
  };
}
