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
        customThemeFile = "";
        matugenScheme = "scheme-fidelity";
        runUserMatugenTemplates = true;
        matugenTargetMonitor = "";
        popupTransparency = 1;
        dockTransparency = 1;
        widgetBackgroundColor = "sch";
        widgetColorMode = "default";
        cornerRadius = 12;
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
        controlCenterShowVpnIcon = true;
        controlCenterShowBrightnessIcon = false;
        controlCenterShowMicIcon = true;
        controlCenterShowBatteryIcon = false;
        controlCenterShowPrinterIcon = false;
        showPrivacyButton = true;
        privacyShowMicIcon = false;
        privacyShowCameraIcon = false;
        privacyShowScreenShareIcon = false;
        controlCenterWidgets = [
          {
            id = "volumeSlider";
            enabled = true;
            width = 50;
          }
          {
            id = "wifi";
            enabled = true;
            width = 50;
          }
          {
            id = "brightnessSlider";
            enabled = true;
            width = 50;
          }
          {
            id = "audioOutput";
            enabled = true;
            width = 50;
          }
          {
            id = "audioInput";
            enabled = true;
            width = 50;
          }
          {
            id = "nightMode";
            enabled = true;
            width = 50;
          }
          {
            id = "darkMode";
            enabled = true;
            width = 25;
          }
        ];
        showWorkspaceIndex = true;
        showWorkspacePadding = true;
        workspaceScrolling = false;
        showWorkspaceApps = false;
        maxWorkspaceIcons = 1;
        workspacesPerMonitor = true;
        showOccupiedWorkspacesOnly = true;
        dwlShowAllTags = false;
        workspaceNameIcons = {
        };
        waveProgressEnabled = true;
        scrollTitleEnabled = true;
        clockCompactMode = false;
        focusedWindowCompactMode = false;
        runningAppsCompactMode = true;
        keyboardLayoutNameCompactMode = false;
        runningAppsCurrentWorkspace = false;
        runningAppsGroupByApp = false;
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
        weatherLocation = "Երևան";
        weatherCoordinates = "40.1777112,44.5126233";
        useAutoLocation = false;
        weatherEnabled = true;
        networkPreference = "auto";
        vpnLastConnected = "";
        iconTheme = "distrobox";
        launcherLogoMode = "os";
        launcherLogoCustomPath = "";
        launcherLogoColorOverride = "";
        launcherLogoColorInvertOnMode = false;
        launcherLogoBrightness = {
        };
        launcherLogoContrast = 1;
        launcherLogoSizeOffset = 0;
        fontFamily = "SFProDisplay Nerd Font";
        monoFontFamily = "Liberation Mono";
        fontWeight = 400;
        fontScale = {
        };
        notepadUseMonospace = true;
        notepadFontFamily = "";
        notepadFontSize = 14;
        notepadShowLineNumbers = false;
        notepadTransparencyOverride = -1;
        notepadLastCustomTransparency = {
        };
        soundsEnabled = true;
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
        lockBeforeSuspend = false;
        preventIdleForMedia = false;
        loginctlLockIntegration = true;
        fadeToLockEnabled = false;
        fadeToLockGracePeriod = 5;
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
        notificationOverlayEnabled = false;
        modalDarkenBackground = true;
        lockScreenShowPowerActions = true;
        enableFprint = false;
        maxFprintTries = 3;
        lockScreenActiveMonitor = "all";
        lockScreenInactiveColor = "#000000";
        hideBrightnessSlider = false;
        notificationTimeoutLow = 5000;
        notificationTimeoutNormal = 5000;
        notificationTimeoutCritical = 0;
        notificationPopupPosition = 0;
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
        powerActionHoldDuration = {
        };
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
        barConfigs = [
          {
            id = "default";
            name = "Main Bar";
            enabled = true;
            position = 0;
            screenPreferences = [
              "all"
            ];
            showOnLastDisplay = true;
            leftWidgets = [
              {
                id = "workspaceSwitcher";
                enabled = true;
              }
              {
                id = "focusedWindow";
                enabled = true;
                focusedWindowCompactMode = false;
              }
            ];
            centerWidgets = [
              {
                id = "music";
                enabled = true;
                mediaSize = 2;
              }
              {
                id = "clock";
                enabled = true;
                clockCompactMode = false;
              }
            ];
            rightWidgets = [
              {
                id = "keyboard_layout_name";
                enabled = true;
              }
              {
                id = "cpuUsage";
                enabled = true;
                minimumWidth = true;
              }
              {
                id = "vpn";
                enabled = true;
              }
              {
                id = "controlCenterButton";
                enabled = true;
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
            spacing = 2;
            innerPadding = 17;
            bottomGap = 0;
            transparency = {
            };
            widgetTransparency = 1;
            squareCorners = false;
            noBackground = false;
            gothCornersEnabled = false;
            gothCornerRadiusOverride = false;
            gothCornerRadiusValue = 12;
            borderEnabled = true;
            borderColor = "secondary";
            borderOpacity = {
            };
            borderThickness = 1;
            widgetOutlineEnabled = false;
            widgetOutlineColor = "secondary";
            widgetOutlineOpacity = {
            };
            widgetOutlineThickness = 1;
            fontScale = {
            };
            autoHide = false;
            autoHideDelay = 250;
            openOnOverview = false;
            visible = true;
            popupGapsAuto = true;
            popupGapsManual = 0;
            maximizeDetection = true;
          }
        ];
      };
    };
  };
}
