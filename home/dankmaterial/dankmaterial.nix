{
lib,
config,
...
}:
{
  options = {
    dankmaterial.enable = lib.mkEnableOption "enables dankmaterial";
  };

  config = lib.mkIf config.dankmaterial.enable {
    programs.dank-material-shell = {
      enable = true;

      systemd = {
        enable = true;
        restartIfChanged = true;
      };

      enableSystemMonitoring = true;
      enableVPN = true;
      enableDynamicTheming = true;
      enableAudioWavelength = true;
      enableCalendarEvents = true;

      settings = {
        currentThemeName = "dynamic";
        currentThemeCategory = "generic";
        customThemeFile = "";
        registryThemeVariants = {
        };
        matugenScheme = "scheme-fidelity";
        runUserMatugenTemplates = true;
        matugenTargetMonitor = "";
        popupTransparency = 1;
        dockTransparency = 1;
        widgetBackgroundColor = "sch";
        widgetColorMode = "default";
        cornerRadius = 12;
        niriLayoutGapsOverride = -1;
        niriLayoutRadiusOverride = -1;
        niriLayoutBorderSize = -1;
        hyprlandLayoutGapsOverride = -1;
        hyprlandLayoutRadiusOverride = -1;
        hyprlandLayoutBorderSize = -1;
        mangoLayoutGapsOverride = -1;
        mangoLayoutRadiusOverride = -1;
        mangoLayoutBorderSize = -1;
        use24HourClock = true;
        showSeconds = true;
        useFahrenheit = false;
        nightModeEnabled = false;
        animationSpeed = 2;
        customAnimationDuration = 500;
        wallpaperFillMode = "Fill";
        blurredWallpaperLayer = false;
        blurWallpaperOnOverview = false;
        showLauncherButton = true;
        showWorkspaceSwitcher = true;
        showFocusedWindow = true;
        showWeather = true;
        showMusic = true;
        showClipboard = true;
        showCpuUsage = true;
        showMemUsage = true;
        showCpuTemp = true;
        showGpuTemp = true;
        selectedGpuIndex = 0;
        enabledGpuPciIds = [

        ];
        showSystemTray = true;
        showClock = true;
        showNotificationButton = true;
        showBattery = true;
        showControlCenterButton = true;
        showCapsLockIndicator = true;
        controlCenterShowNetworkIcon = true;
        controlCenterShowBluetoothIcon = true;
        controlCenterShowAudioIcon = true;
        controlCenterShowAudioPercent = false;
        controlCenterShowVpnIcon = true;
        controlCenterShowBrightnessIcon = false;
        controlCenterShowBrightnessPercent = false;
        controlCenterShowMicIcon = true;
        controlCenterShowMicPercent = false;
        controlCenterShowBatteryIcon = false;
        controlCenterShowPrinterIcon = false;
        controlCenterShowScreenSharingIcon = true;
        showPrivacyButton = true;
        privacyShowMicIcon = false;
        privacyShowCameraIcon = false;
        privacyShowScreenShareIcon = false;
        controlCenterWidgets = [
          {
            enabled = true;
            id = "volumeSlider";
            width = 50;
          }
          {
            enabled = true;
            id = "wifi";
            width = 50;
          }
          {
            enabled = true;
            id = "brightnessSlider";
            width = 50;
          }
          {
            enabled = true;
            id = "audioOutput";
            width = 50;
          }
          {
            enabled = true;
            id = "audioInput";
            width = 50;
          }
          {
            enabled = true;
            id = "nightMode";
            width = 50;
          }
          {
            enabled = true;
            id = "darkMode";
            width = 25;
          }
        ];
        showWorkspaceIndex = false;
        showWorkspaceName = false;
        showWorkspacePadding = true;
        workspaceScrolling = false;
        showWorkspaceApps = true;
        maxWorkspaceIcons = 2;
        groupWorkspaceApps = true;
        workspaceFollowFocus = false;
        showOccupiedWorkspacesOnly = true;
        reverseScrolling = false;
        dwlShowAllTags = false;
        workspaceColorMode = "default";
        workspaceUnfocusedColorMode = "default";
        workspaceUrgentColorMode = "default";
        workspaceFocusedBorderEnabled = false;
        workspaceFocusedBorderColor = "primary";
        workspaceFocusedBorderThickness = 2;
        workspaceNameIcons = {
        };
        waveProgressEnabled = true;
        scrollTitleEnabled = true;
        audioVisualizerEnabled = true;
        audioScrollMode = "volume";
        clockCompactMode = false;
        focusedWindowCompactMode = false;
        runningAppsCompactMode = true;
        keyboardLayoutNameCompactMode = false;
        runningAppsCurrentWorkspace = false;
        runningAppsGroupByApp = false;
        appIdSubstitutions = [
          {
            pattern = "Spotify";
            replacement = "spotify";
            type = "exact";
          }
          {
            pattern = "beepertexts";
            replacement = "beeper";
            type = "exact";
          }
          {
            pattern = "home assistant desktop";
            replacement = "homeassistant-desktop";
            type = "exact";
          }
          {
            pattern = "com.transmissionbt.transmission";
            replacement = "transmission-gtk";
            type = "contains";
          }
          {
            pattern = "^steam_app_(\\d+)$";
            replacement = "steam_icon_$1";
            type = "regex";
          }
        ];
        centeringMode = "index";
        clockDateFormat = "d MMMM, dddd";
        lockDateFormat = "d MMMM, dddd";
        mediaSize = 1;
        appLauncherViewMode = "list";
        spotlightModalViewMode = "list";
        sortAppsAlphabetically = false;
        appLauncherGridColumns = 4;
        spotlightCloseNiriOverview = true;
        niriOverviewOverlayEnabled = true;
        useAutoLocation = false;
        weatherEnabled = false;
        networkPreference = "auto";
        vpnLastConnected = "";
        iconTheme = "distrobox";
        cursorSettings = {
          theme = "System Default";
          size = 24;
          niri = {
            hideWhenTyping = false;
            hideAfterInactiveMs = 0;
          };
          hyprland = {
            hideOnKeyPress = false;
            hideOnTouch = false;
            inactiveTimeout = 0;
          };
          dwl = {
            cursorHideTimeout = 0;
          };
        };
        launcherLogoMode = "os";
        launcherLogoCustomPath = "";
        launcherLogoColorOverride = "";
        launcherLogoColorInvertOnMode = false;
        launcherLogoBrightness = null;
        launcherLogoContrast = 1;
        launcherLogoSizeOffset = 0;
        fontFamily = "SFProDisplay Nerd Font";
        monoFontFamily = "Liberation Mono";
        fontWeight = 400;
        fontScale = null;
        notepadUseMonospace = true;
        notepadFontFamily = "";
        notepadFontSize = 14;
        notepadShowLineNumbers = false;
        notepadTransparencyOverride = -1;
        notepadLastCustomTransparency = null;
        soundsEnabled = false;
        useSystemSoundTheme = false;
        soundNewNotification = true;
        soundVolumeChanged = true;
        soundPluggedIn = true;
        acMonitorTimeout = 0;
        acLockTimeout = 0;
        acSuspendTimeout = 0;
        acSuspendBehavior = 0;
        acProfileName = "";
        batteryMonitorTimeout = 0;
        batteryLockTimeout = 0;
        batterySuspendTimeout = 0;
        batterySuspendBehavior = 0;
        batteryProfileName = "";
        batteryChargeLimit = 100;
        lockBeforeSuspend = false;
        loginctlLockIntegration = true;
        fadeToLockEnabled = false;
        fadeToLockGracePeriod = 5;
        fadeToDpmsEnabled = true;
        fadeToDpmsGracePeriod = 5;
        launchPrefix = "uwsm-app";
        brightnessDevicePins = {
        };
        wifiNetworkPins = {
        };
        bluetoothDevicePins = {
        };
        audioInputDevicePins = {
        };
        audioOutputDevicePins = {
        };
        gtkThemingEnabled = false;
        qtThemingEnabled = false;
        syncModeWithPortal = true;
        terminalsAlwaysDark = false;
        runDmsMatugenTemplates = true;
        matugenTemplateGtk = true;
        matugenTemplateNiri = true;
        matugenTemplateHyprland = true;
        matugenTemplateMangowc = true;
        matugenTemplateQt5ct = true;
        matugenTemplateQt6ct = true;
        matugenTemplateFirefox = true;
        matugenTemplatePywalfox = true;
        matugenTemplateZenBrowser = true;
        matugenTemplateVesktop = true;
        matugenTemplateEquibop = true;
        matugenTemplateGhostty = true;
        matugenTemplateKitty = true;
        matugenTemplateFoot = true;
        matugenTemplateAlacritty = true;
        matugenTemplateNeovim = true;
        matugenTemplateWezterm = true;
        matugenTemplateDgop = true;
        matugenTemplateKcolorscheme = true;
        matugenTemplateVscode = true;
        showDock = false;
        dockAutoHide = false;
        dockGroupByApp = false;
        dockOpenOnOverview = false;
        dockPosition = 1;
        dockSpacing = 4;
        dockBottomGap = 0;
        dockMargin = 0;
        dockIconSize = 40;
        dockIndicatorStyle = "circle";
        dockBorderEnabled = false;
        dockBorderColor = "surfaceText";
        dockBorderOpacity = 1;
        dockBorderThickness = 1;
        dockIsolateDisplays = false;
        notificationOverlayEnabled = false;
        modalDarkenBackground = true;
        lockScreenShowPowerActions = true;
        lockScreenShowSystemIcons = true;
        lockScreenShowTime = true;
        lockScreenShowDate = true;
        lockScreenShowProfileImage = true;
        lockScreenShowPasswordField = true;
        enableFprint = false;
        maxFprintTries = 3;
        lockScreenActiveMonitor = "all";
        lockScreenInactiveColor = "#000000";
        lockScreenNotificationMode = 0;
        hideBrightnessSlider = false;
        notificationTimeoutLow = 5000;
        notificationTimeoutNormal = 5000;
        notificationTimeoutCritical = 0;
        notificationCompactMode = false;
        notificationPopupPosition = 0;
        notificationHistoryEnabled = true;
        notificationHistoryMaxCount = 50;
        notificationHistoryMaxAgeDays = 1;
        notificationHistorySaveLow = true;
        notificationHistorySaveNormal = true;
        notificationHistorySaveCritical = true;
        osdAlwaysShowValue = false;
        osdPosition = 6;
        osdVolumeEnabled = true;
        osdMediaVolumeEnabled = true;
        osdBrightnessEnabled = false;
        osdIdleInhibitorEnabled = true;
        osdMicMuteEnabled = true;
        osdCapsLockEnabled = false;
        osdPowerProfileEnabled = false;
        osdAudioOutputEnabled = true;
        powerActionConfirm = true;
        powerActionHoldDuration = null;
        powerMenuActions = [
          "reboot"
          "logout"
          "poweroff"
          "lock"
          "suspend"
          "restart"
        ];
        powerMenuDefaultAction = "logout";
        powerMenuGridLayout = false;
        customPowerActionLock = "";
        customPowerActionLogout = "";
        customPowerActionSuspend = "";
        customPowerActionHibernate = "";
        customPowerActionReboot = "";
        customPowerActionPowerOff = "";
        updaterHideWidget = false;
        updaterUseCustomCommand = true;
        updaterCustomCommand = "nix-u";
        updaterTerminalAdditionalParams = "";
        displayNameMode = "model";
        screenPreferences = {
          dock = [

          ];
        };
        showOnLastDisplay = {
          dock = false;
        };
        niriOutputSettings = {
        };
        hyprlandOutputSettings = {
        };
        barConfigs = [
          {
            autoHide = false;
            autoHideDelay = 1143;
            borderColor = "secondary";
            borderEnabled = true;
            borderOpacity = {
            };
            borderThickness = 1;
            bottomGap = 0;
            centerWidgets = [
              {
                id = "workspaceSwitcher";
                enabled = true;
              }
            ];
            enabled = true;
            fontScale = {
            };
            gothCornerRadiusOverride = false;
            gothCornerRadiusValue = 12;
            gothCornersEnabled = false;
            id = "default";
            innerPadding = 17;
            leftWidgets = [
              {
                id = "clock";
                enabled = true;
                clockCompactMode = false;
              }
              {
                id = "controlCenterButton";
                enabled = true;
                showNetworkIcon = true;
                showBluetoothIcon = true;
                showAudioIcon = true;
                showAudioPercent = false;
                showVpnIcon = true;
                showBrightnessIcon = false;
                showBrightnessPercent = false;
                showMicIcon = true;
                showMicPercent = false;
                showBatteryIcon = false;
                showPrinterIcon = false;
                showScreenSharingIcon = true;
              }
              {
                id = "network_speed_monitor";
                enabled = true;
              }
            ];
            maximizeDetection = true;
            name = "Main Bar";
            noBackground = false;
            openOnOverview = false;
            popupGapsAuto = true;
            popupGapsManual = 0;
            position = 0;
            rightWidgets = [
              {
                id = "keyboard_layout_name";
                enabled = true;
              }
              {
                id = "music";
                enabled = true;
              }
              {
                id = "cpuUsage";
                enabled = true;
                minimumWidth = true;
              }
              {
                id = "systemTray";
                enabled = true;
              }
              {
                id = "notificationButton";
                enabled = true;
              }
            ];
            screenPreferences = [
              "all"
            ];
            showOnLastDisplay = true;
            spacing = 0;
            squareCorners = false;
            transparency = {
            };
            visible = true;
            widgetOutlineColor = "secondary";
            widgetOutlineEnabled = false;
            widgetOutlineOpacity = {
            };
            widgetOutlineThickness = 1;
            widgetTransparency = 1;
            showOnWindowsOpen = false;
          }
        ];
        desktopClockEnabled = false;
        desktopClockStyle = "analog";
        desktopClockTransparency = 0.8;
        desktopClockColorMode = "primary";
        desktopClockCustomColor = {
          r = 1;
          g = 1;
          b = 1;
          a = 1;
          hsvHue = -1;
          hsvSaturation = 0;
          hsvValue = 1;
          hslHue = -1;
          hslSaturation = 0;
          hslLightness = 1;
          valid = true;
        };
        desktopClockShowDate = true;
        desktopClockShowAnalogNumbers = false;
        desktopClockShowAnalogSeconds = true;
        desktopClockX = -1;
        desktopClockY = -1;
        desktopClockWidth = 280;
        desktopClockHeight = 180;
        desktopClockDisplayPreferences = [
          "all"
        ];
        systemMonitorEnabled = false;
        systemMonitorShowHeader = true;
        systemMonitorTransparency = 0.8;
        systemMonitorColorMode = "primary";
        systemMonitorCustomColor = {
          r = 1;
          g = 1;
          b = 1;
          a = 1;
          hsvHue = -1;
          hsvSaturation = 0;
          hsvValue = 1;
          hslHue = -1;
          hslSaturation = 0;
          hslLightness = 1;
          valid = true;
        };
        systemMonitorShowCpu = true;
        systemMonitorShowCpuGraph = true;
        systemMonitorShowCpuTemp = true;
        systemMonitorShowGpuTemp = false;
        systemMonitorGpuPciId = "";
        systemMonitorShowMemory = true;
        systemMonitorShowMemoryGraph = true;
        systemMonitorShowNetwork = true;
        systemMonitorShowNetworkGraph = true;
        systemMonitorShowDisk = true;
        systemMonitorShowTopProcesses = false;
        systemMonitorTopProcessCount = 3;
        systemMonitorTopProcessSortBy = "cpu";
        systemMonitorGraphInterval = 60;
        systemMonitorLayoutMode = "auto";
        systemMonitorX = -1;
        systemMonitorY = -1;
        systemMonitorWidth = 320;
        systemMonitorHeight = 480;
        systemMonitorDisplayPreferences = [
          "all"
        ];
        systemMonitorVariants = [

        ];
        desktopWidgetPositions = {
        };
        desktopWidgetGridSettings = {
        };
        desktopWidgetInstances = [

        ];
        desktopWidgetGroups = [

        ];
        builtInPluginSettings = {
          dms_settings_search = {
            trigger = "?";
          };
        };
        configVersion = 5;
      };
    };
  };
}
