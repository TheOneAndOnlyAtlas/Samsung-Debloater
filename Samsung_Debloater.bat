@echo off
setlocal EnableDelayedExpansion
title Samsung Multi-Mode Debloater - Clean Version

:: ================================
:: CHECK ADB
:: ================================
where adb >nul 2>nul
if errorlevel 1 (
    echo.
    echo [ERROR] adb.exe not found!
    echo Put this .bat file in platform-tools folder or add it to PATH.
    pause
    exit /b 1
)
adb start-server >nul 2>&1

:: ================================
:: DEVICE DETECTION
:: ================================
:CHECK_DEVICE
cls
echo.
echo Checking for connected device...
adb devices

set "DEVICE_ID="
set "UNAUTH="
for /f "skip=1 tokens=1,2" %%a in ('adb devices') do (
    if "%%b"=="device" set "DEVICE_ID=%%a"
    if "%%b"=="unauthorized" set "UNAUTH=1"
)

if not defined DEVICE_ID (
    if defined UNAUTH (
        echo.
        echo [ERROR] Device unauthorized! Allow USB debugging on your phone.
    ) else (
        echo.
        echo [ERROR] No device found! Check cable / USB debugging / File Transfer mode.
    )
    choice /C RQ /N /M "R=Retry, Q=Quit: "
    if errorlevel 2 exit /b 1
    goto CHECK_DEVICE
)

echo.
echo [OK] Device found: %DEVICE_ID%

:: Check if Samsung
for /f "delims=" %%a in ('adb -s %DEVICE_ID% shell getprop ro.product.manufacturer') do set "MANUF=%%a"
for /f "delims=" %%a in ('adb -s %DEVICE_ID% shell getprop ro.product.model') do set "MODEL=%%a"
echo Model: %MODEL%    Manufacturer: %MANUF%
if /I not "%MANUF%"=="samsung" (
    echo.
    echo [ERROR] This script only works on Samsung devices!
    pause
    exit /b 1
)

echo.
echo Samsung device confirmed. Ready to debloat.
echo.

:: ================================
:: CLEAN SINGLE-LINE PROMPT
:: ================================
echo 1) Full debloat (Samsung + Google + carriers + misc)
echo 2) Samsung-only (keep Google apps)
echo 3) Google-only (keep Samsung apps)
echo 4) Carrier-only
echo 5) RESTORE (re-enable ALL listed packages)
echo.
choice /C 12345 /N /M "Select mode (1-5) [1,2,3,4,5]?"
if errorlevel 5 goto RESTORE_ALL
if errorlevel 4 goto CARRIER_ONLY
if errorlevel 3 goto GOOGLE_ONLY
if errorlevel 2 goto SAMSUNG_ONLY
if errorlevel 1 goto FULL_DEBLOAT

:: =========================================================
:: FULL DEBLOAT
:: =========================================================
:FULL_DEBLOAT
echo.
echo FULL DEBLOAT selected - removing Samsung + Google + Carrier bloat
pause
echo.
for %%P in (
    "com.sec.penup"
    "com.sec.android.app.voicenote"
    "com.sec.android.app.sbrowser"
    "com.samsung.android.app.notes"
    "com.sec.android.app.popupcalculator"
    "com.sec.android.app.samsungapps"
    "com.samsung.android.coldwalletservice"
    "com.samsung.android.themestore"
    "com.google.android.apps.youtube.music"
    "com.google.android.apps.docs"
    "com.google.android.apps.photos"
    "com.google.android.videos"
    "com.google.android.apps.walletnfcrel"
    "com.android.apps.tag"
    "com.android.bookmarkprovider"
    "com.android.chrome"
    "com.android.dreams.basic"
    "com.android.dreams.phototable"
    "com.android.hotwordenrollment.okgoogle"
    "com.android.hotwordenrollment.xgoogle"
    "com.android.providers.partnerbookmarks"
    "com.android.vending"
    "com.facebook.appmanager"
    "com.facebook.services"
    "com.facebook.system"
    "com.google.android.apps.bard"
    "com.google.android.apps.maps"
    "com.google.android.apps.messaging"
    "com.google.android.apps.restore"
    "com.google.android.apps.tachyon"
    "com.google.android.captiveportallogin"
    "com.google.android.cellbroadcastservice"
    "com.google.android.configupdater"
    "com.google.android.ext.services"
    "com.google.android.ext.shared"
    "com.google.android.feedback"
    "com.google.android.gm"
    "com.google.android.gms.location.history"
    "com.google.android.gms"
    "com.google.android.googlequicksearchbox"
    "com.google.android.gsf"
    "com.google.android.health.connect.backuprestore"
    "com.google.android.healthconnect.controller"
    "com.google.android.onetimeinitializer"
    "com.google.android.partnersetup"
    "com.google.android.printservice.recommendation"
    "com.google.android.projection.gearhead"
    "com.google.android.setupwizard"
    "com.google.android.syncadapters.calendar"
    "com.google.android.tts"
    "com.google.android.youtube"
    "com.google.ar.core"
    "com.microsoft.appmanager"
    "com.microsoft.skydrive"
    "com.samsung.android.app.camera.sticker.facearavatar.preload"
    "com.samsung.android.app.clipboardedge"
    "com.samsung.android.app.contacts"
    "com.samsung.android.app.find"
    "com.samsung.android.app.omcagent"
    "com.samsung.android.app.parentalcare"
    "com.samsung.android.app.routines"
    "com.samsung.android.app.spage"
    "com.samsung.android.app.separation"
    "com.samsung.android.app.tips"
    "com.samsung.android.app.watchmanager"
    "com.samsung.android.app.watchmanagerstub"
    "com.samsung.android.aremoji"
    "com.samsung.android.aremojieditor"
    "com.samsung.android.authfw"
    "com.samsung.android.aware.service"
    "com.samsung.android.beaconmanager"
    "com.samsung.android.bixby.agent"
    "com.samsung.android.bixby.service"
    "com.samsung.android.bixby.wakeup"
    "com.samsung.android.bixbyvision.framework"
    "com.samsung.android.coldwalletservice"
    "com.samsung.android.da.daagent"
    "com.samsung.android.dkey"
    "com.samsung.android.dqagent"
    "com.samsung.android.easysetup"
    "com.samsung.android.game.gamehome"
    "com.samsung.android.game.gametools"
    "com.samsung.android.game.gos"
    "com.samsung.android.ipsgeofence"
    "com.samsung.android.kidsinstaller"
    "com.samsung.android.knox.zt.framework"
    "com.samsung.android.mdecservice"
    "com.samsung.android.mdx"
    "com.samsung.android.mobileservice"
    "com.samsung.android.oneconnect"
    "com.samsung.android.rubin.app"
    "com.samsung.android.samsungpass"
    "com.samsung.android.samsungpassautofill"
    "com.samsung.android.sdk.handwriting"
    "com.samsung.android.service.stplatform"
    "com.samsung.android.smartsuggestions"
    "com.samsung.android.smartswitchassistant"
    "com.samsung.android.spay"
    "com.samsung.android.spayfw"
    "com.samsung.android.stickercenter"
    "com.samsung.android.tvplus"
    "com.samsung.android.visionintelligence"
    "com.samsung.storyservice"
    "com.samsung.sree"
    "com.samsung.android.voc"
    "com.sec.android.app.billing"
    "com.sec.android.app.chromecustomizations"
    "com.sec.android.app.shealth"
    "com.sec.android.daemonapp"
    "com.sec.android.easyMover"
    "com.sec.android.easyMover.Agent"
    "com.sec.android.mimage.avatarstickers"
    "com.sec.penup"
    "com.tmobile.echolocate"
    "com.tmobile.pr.adapt"
    "com.tmobile.simlock"
    "com.tmobile.services"
    "com.tmobile.vvm.application"
    "com.ironsrc.aura.tmo"
    "com.vzw.apnlib"
    "com.vzw.ecid"
    "com.vzw.hss.myverizon"
    "com.vzw.hs.android.modlite"
    "com.vcast.mediamanager"
    "com.verizon.llkagent"
    "com.verizon.mips.services"
    "com.vzw.visualvoicemail"
    "com.att.dh"
    "com.att.callprotect"
    "com.att.tv"
    "com.att.myWireless"
    "com.att.visualvoicemail"
    "com.att.android.attsmartwifi"
    "com.boost.vvm"
    "com.sprint.ms.smf.services"
    "com.sprint.provider"
    "com.cricketwireless.mycricket"
    "com.mizmowireless.tethering"
    "com.aura.oobe.samsung.gl"
    "com.aura.oobe.samsung"
    "com.aura.oobe.att"
) do (
    echo Disabling: %%P
    adb -s %DEVICE_ID% shell pm disable-user --user 0 %%P >nul 2>&1 || echo    [Not found / Already disabled] %%P
)
goto DONE

:: =========================================================
:: SAMSUNG-ONLY
:: =========================================================
:SAMSUNG_ONLY
echo.
echo SAMSUNG-ONLY + CARRIER + MISC selected
pause
echo.
for %%P in (
    "com.microsoft.appmanager"
    "com.microsoft.skydrive"
    "com.samsung.android.calendar"
    "com.samsung.android.messaging"
    "com.sec.penup"
    "com.sec.android.app.voicenote"
    "com.sec.android.app.sbrowser"
    "com.samsung.android.app.notes"
    "com.sec.android.app.popupcalculator"
    "com.sec.android.app.samsungapps"
    "com.samsung.android.coldwalletservice"
    "com.samsung.android.themestore"
    "com.samsung.android.app.camera.sticker.facearavatar.preload"
    "com.samsung.android.app.clipboardedge"
    "com.samsung.android.app.contacts"
    "com.samsung.android.app.find"
    "com.samsung.android.app.omcagent"
    "com.samsung.android.app.parentalcare"
    "com.samsung.android.app.routines"
    "com.samsung.android.app.spage"
    "com.samsung.android.app.separation"
    "com.samsung.android.app.tips"
    "com.samsung.android.app.watchmanager"
    "com.samsung.android.app.watchmanagerstub"
    "com.samsung.android.aremoji"
    "com.samsung.android.aremojieditor"
    "com.samsung.android.authfw"
    "com.samsung.android.aware.service"
    "com.samsung.android.beaconmanager"
    "com.samsung.android.bixby.agent"
    "com.samsung.android.bixby.service"
    "com.samsung.android.bixby.wakeup"
    "com.samsung.android.bixbyvision.framework"
    "com.samsung.android.coldwalletservice"
    "com.samsung.android.da.daagent"
    "com.samsung.android.dkey"
    "com.samsung.android.dqagent"
    "com.samsung.android.easysetup"
    "com.samsung.android.game.gamehome"
    "com.samsung.android.game.gametools"
    "com.samsung.android.game.gos"
    "com.samsung.android.ipsgeofence"
    "com.samsung.android.kidsinstaller"
    "com.samsung.android.knox.zt.framework"
    "com.samsung.android.mdecservice"
    "com.samsung.android.mdx"
    "com.samsung.android.mobileservice"
    "com.samsung.android.oneconnect"
    "com.samsung.android.rubin.app"
    "com.samsung.android.samsungpass"
    "com.samsung.android.samsungpassautofill"
    "com.samsung.android.sdk.handwriting"
    "com.samsung.android.service.stplatform"
    "com.samsung.android.smartsuggestions"
    "com.samsung.android.smartswitchassistant"
    "com.samsung.android.spay"
    "com.samsung.android.spayfw"
    "com.samsung.android.stickercenter"
    "com.samsung.android.tvplus"
    "com.samsung.android.visionintelligence"
    "com.samsung.storyservice"
    "com.samsung.sree"
    "com.samsung.android.voc"
    "com.sec.android.app.billing"
    "com.sec.android.app.chromecustomizations"
    "com.sec.android.app.shealth"
    "com.sec.android.daemonapp"
    "com.sec.android.easyMover"
    "com.sec.android.easyMover.Agent"
    "com.sec.android.mimage.avatarstickers"
    "com.sec.penup"
    "com.tmobile.echolocate"
    "com.tmobile.pr.adapt"
    "com.tmobile.simlock"
    "com.tmobile.services"
    "com.tmobile.vvm.application"
    "com.ironsrc.aura.tmo"
    "com.vzw.apnlib"
    "com.vzw.ecid"
    "com.vzw.hss.myverizon"
    "com.vzw.hs.android.modlite"
    "com.vcast.mediamanager"
    "com.verizon.llkagent"
    "com.verizon.mips.services"
    "com.vzw.visualvoicemail"
    "com.att.dh"
    "com.att.callprotect"
    "com.att.tv"
    "com.att.myWireless"
    "com.att.visualvoicemail"
    "com.att.android.attsmartwifi"
    "com.boost.vvm"
    "com.sprint.ms.smf.services"
    "com.sprint.provider"
    "com.cricketwireless.mycricket"
    "com.mizmowireless.tethering"
    "com.aura.oobe.samsung.gl"
    "com.aura.oobe.samsung"
    "com.aura.oobe.att"
) do (
    echo Disabling: %%P
    adb -s %DEVICE_ID% shell pm disable-user --user 0 %%P >nul 2>&1 || echo    [Skip] %%P
)
goto DONE

:: =========================================================
:: GOOGLE-ONLY + CARRIER
:: =========================================================
:GOOGLE_ONLY
echo.
echo GOOGLE-ONLY + CARRIER + MISC selected
pause
echo.
for %%P in (
    "com.microsoft.appmanager"
    "com.microsoft.skydrive"
    "com.google.android.apps.youtube.music"
    "com.google.android.apps.docs"
    "com.google.android.apps.photos"
    "com.google.android.videos"
    "com.google.android.apps.walletnfcrel"
    "com.android.chrome"
    "com.android.hotwordenrollment.okgoogle"
    "com.android.hotwordenrollment.xgoogle"
    "com.android.vending"
    "com.google.android.apps.bard"
    "com.google.android.apps.maps"
    "com.google.android.apps.messaging"
    "com.google.android.apps.restore"
    "com.google.android.apps.tachyon"
    "com.google.android.captiveportallogin"
    "com.google.android.cellbroadcastservice"
    "com.google.android.configupdater"
    "com.google.android.ext.services"
    "com.google.android.ext.shared"
    "com.google.android.feedback"
    "com.google.android.gm"
    "com.google.android.gms.location.history"
    "com.google.android.gms"
    "com.google.android.googlequicksearchbox"
    "com.google.android.gsf"
    "com.google.android.health.connect.backuprestore"
    "com.google.android.healthconnect.controller"
    "com.google.android.onetimeinitializer"
    "com.google.android.partnersetup"
    "com.google.android.printservice.recommendation"
    "com.google.android.projection.gearhead"
    "com.google.android.setupwizard"
    "com.google.android.syncadapters.calendar"
    "com.google.android.tts"
    "com.google.android.youtube"
    "com.google.ar.core"
    "com.tmobile.echolocate"
    "com.tmobile.pr.adapt"
    "com.tmobile.simlock"
    "com.tmobile.services"
    "com.tmobile.vvm.application"
    "com.ironsrc.aura.tmo"
    "com.vzw.apnlib"
    "com.vzw.ecid"
    "com.vzw.hss.myverizon"
    "com.vzw.hs.android.modlite"
    "com.vcast.mediamanager"
    "com.verizon.llkagent"
    "com.verizon.mips.services"
    "com.vzw.visualvoicemail"
    "com.att.dh"
    "com.att.callprotect"
    "com.att.tv"
    "com.att.myWireless"
    "com.att.visualvoicemail"
    "com.att.android.attsmartwifi"
    "com.boost.vvm"
    "com.sprint.ms.smf.services"
    "com.sprint.provider"
    "com.cricketwireless.mycricket"
    "com.mizmowireless.tethering"
    "com.aura.oobe.samsung.gl"
    "com.aura.oobe.samsung"
    "com.aura.oobe.att"
) do (
    echo Disabling: %%P
    adb -s %DEVICE_ID% shell pm disable-user --user 0 %%P >nul 2>&1 || echo    [Skip] %%P
)
goto DONE

:: =========================================================
:: CARRIER-ONLY
:: =========================================================
:CARRIER_ONLY
echo.
echo CARRIER-ONLY selected
pause
echo.
for %%P in (
    "com.tmobile.echolocate"
    "com.tmobile.pr.adapt"
    "com.tmobile.simlock"
    "com.tmobile.services"
    "com.tmobile.vvm.application"
    "com.ironsrc.aura.tmo"
    "com.vzw.apnlib"
    "com.vzw.ecid"
    "com.vzw.hss.myverizon"
    "com.vzw.hs.android.modlite"
    "com.vcast.mediamanager"
    "com.verizon.llkagent"
    "com.verizon.mips.services"
    "com.vzw.visualvoicemail"
    "com.att.dh"
    "com.att.callprotect"
    "com.att.tv"
    "com.att.myWireless"
    "com.att.visualvoicemail"
    "com.att.android.attsmartwifi"
    "com.boost.vvm"
    "com.sprint.ms.smf.services"
    "com.sprint.provider"
    "com.cricketwireless.mycricket"
    "com.mizmowireless.tethering"
    "com.aura.oobe.samsung.gl"
    "com.aura.oobe.samsung"
    "com.aura.oobe.att"
) do (
    echo Disabling: %%P
    adb -s %DEVICE_ID% shell pm disable-user --user 0 %%P >nul 2>&1 || echo    [Skip] %%P
)
goto DONE

:: =========================================================
:: RESTORE ALL
:: =========================================================
:RESTORE_ALL
echo.
echo RESTORE MODE - Re-enabling all packages
echo This may take a minute...
pause
echo.
for %%P in (
    "com.samsung.android.app.notes"
    "com.samsung.android.calendar"
    "com.samsung.android.scloud"
    "com.sec.android.app.popupcalculator"
    "com.sec.android.app.samsungapps"
    "com.sec.android.app.sbrowser"
    "com.samsung.android.messaging"
    "com.google.android.apps.youtube.music"
    "com.google.android.apps.docs"
    "com.google.android.apps.photos"
    "com.google.android.videos"
    "com.google.android.apps.walletnfcrel"
    "com.android.apps.tag"
    "com.android.bookmarkprovider"
    "com.android.chrome"
    "com.android.dreams.basic"
    "com.android.dreams.phototable"
    "com.android.hotwordenrollment.okgoogle"
    "com.android.hotwordenrollment.xgoogle"
    "com.android.providers.partnerbookmarks"
    "com.android.vending"
    "com.facebook.appmanager"
    "com.facebook.services"
    "com.facebook.system"
    "com.google.android.apps.bard"
    "com.google.android.apps.maps"
    "com.google.android.apps.messaging"
    "com.google.android.apps.restore"
    "com.google.android.apps.tachyon"
    "com.google.android.captiveportallogin"
    "com.google.android.cellbroadcastservice"
    "com.google.android.configupdater"
    "com.google.android.ext.services"
    "com.google.android.ext.shared"
    "com.google.android.feedback"
    "com.google.android.gm"
    "com.google.android.gms.location.history"
    "com.google.android.gms.supervision"
    "com.google.android.gms"
    "com.google.android.googlequicksearchbox"
    "com.google.android.gsf"
    "com.google.android.health.connect.backuprestore"
    "com.google.android.healthconnect.controller"
    "com.google.android.onetimeinitializer"
    "com.google.android.partnersetup"
    "com.google.android.printservice.recommendation"
    "com.google.android.projection.gearhead"
    "com.google.android.setupwizard"
    "com.google.android.syncadapters.calendar"
    "com.google.android.tts"
    "com.google.android.youtube"
    "com.google.ar.core"
    "com.microsoft.appmanager"
    "com.microsoft.skydrive"
    "com.samsung.android.app.camera.sticker.facearavatar.preload"
    "com.samsung.android.app.clipboardedge"
    "com.samsung.android.app.contacts"
    "com.samsung.android.app.find"
    "com.samsung.android.app.omcagent"
    "com.samsung.android.app.parentalcare"
    "com.samsung.android.app.routines"
    "com.samsung.android.app.spage"
    "com.samsung.android.app.separation"
    "com.samsung.android.app.tips"
    "com.samsung.android.app.watchmanager"
    "com.samsung.android.app.watchmanagerstub"
    "com.samsung.android.aremoji"
    "com.samsung.android.aremojieditor"
    "com.samsung.android.authfw"
    "com.samsung.android.aware.service"
    "com.samsung.android.beaconmanager"
    "com.samsung.android.bixby.agent"
    "com.samsung.android.bixby.service"
    "com.samsung.android.bixby.wakeup"
    "com.samsung.android.bixbyvision.framework"
    "com.samsung.android.coldwalletservice"
    "com.samsung.android.da.daagent"
    "com.samsung.android.dkey"
    "com.samsung.android.dqagent"
    "com.samsung.android.easysetup"
    "com.samsung.android.game.gamehome"
    "com.samsung.android.game.gametools"
    "com.samsung.android.game.gos"
    "com.samsung.android.ipsgeofence"
    "com.samsung.android.kidsinstaller"
    "com.samsung.android.knox.zt.framework"
    "com.samsung.android.mdecservice"
    "com.samsung.android.mdx"
    "com.samsung.android.mobileservice"
    "com.samsung.android.oneconnect"
    "com.samsung.android.rubin.app"
    "com.samsung.android.samsungpass"
    "com.samsung.android.samsungpassautofill"
    "com.samsung.android.sdk.handwriting"
    "com.samsung.android.service.stplatform"
    "com.samsung.android.smartsuggestions"
    "com.samsung.android.smartswitchassistant"
    "com.samsung.android.spay"
    "com.samsung.android.spayfw"
    "com.samsung.android.stickercenter"
    "com.samsung.android.tvplus"
    "com.samsung.android.visionintelligence"
    "com.samsung.storyservice"
    "com.samsung.sree"
    "com.samsung.android.voc"
    "com.sec.android.app.billing"
    "com.sec.android.app.chromecustomizations"
    "com.sec.android.app.shealth"
    "com.sec.android.daemonapp"
    "com.sec.android.easyMover"
    "com.sec.android.easyMover.Agent"
    "com.sec.android.mimage.avatarstickers"
    "com.sec.penup"
    "com.tmobile.echolocate"
    "com.tmobile.pr.adapt"
    "com.tmobile.simlock"
    "com.tmobile.services"
    "com.tmobile.vvm.application"
    "com.ironsrc.aura.tmo"
    "com.vzw.apnlib"
    "com.vzw.ecid"
    "com.vzw.hss.myverizon"
    "com.vzw.hs.android.modlite"
    "com.vcast.mediamanager"
    "com.verizon.llkagent"
    "com.verizon.mips.services"
    "com.vzw.visualvoicemail"
    "com.att.dh"
    "com.att.callprotect"
    "com.att.tv"
    "com.att.myWireless"
    "com.att.visualvoicemail"
    "com.att.android.attsmartwifi"
    "com.boost.vvm"
    "com.sprint.ms.smf.services"
    "com.sprint.provider"
    "com.cricketwireless.mycricket"
    "com.mizmowireless.tethering"
    "com.aura.oobe.samsung.gl"
    "com.aura.oobe.samsung"
    "com.aura.oobe.att"
) do (
    echo Enabling: %%P
    adb -s %DEVICE_ID% shell pm enable --user 0 %%P >nul 2>&1 || echo    [Failed / System package] %%P
)
echo.
echo Restore complete!

:: =========================================================
:: DONE
:: =========================================================
:DONE
echo.
echo ================================
echo     OPERATION COMPLETE
echo   Reboot your phone now!
echo ================================
echo.
pause
exit /b 0