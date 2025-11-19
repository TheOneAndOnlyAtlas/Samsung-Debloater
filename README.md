# Samsung One-Click Multi-Mode Debloater (ADB + Batch)

A Windows batch script that allows you to **debloat Samsung Android phones** automatically using ADB.  
It includes a clean multi-mode menu, device detection, Samsung verification, and a full restore mode.

This README provides full installation instructions, usage steps, and guidelines for organizing your package lists.  
⚠️ *Package names are **not** included here — you will insert them yourself inside the `.bat` script.*  

---

## ⭐ Features

This debloater includes **five powerful debloat modes**:

Full package lists for each mode can be seen in the main branch.

### 1️⃣ Full Debloat
Removes **Samsung apps**, **Google apps**, **carrier apps**, and any other third-party packages you place in the list.

### 2️⃣ Samsung-Only Debloat
Removes **only Samsung apps** (plus carrier bloat).  
Google apps remain untouched.

### 3️⃣ Google-Only Debloat
Removes **Google apps/services** you define (plus carrier bloat).  
Samsung apps remain untouched.

### 4️⃣ Carrier-Only Debloat
Removes **all carrier/oem bloat**, such as:
- T-Mobile
- AT&T
- Verizon
- Sprint
- Boost
- Cricket
- Aura OEM onboarding apps
- Diagnostics / analytics / MyCarrier apps  
(whatever you list here)

### 5️⃣ Restore Mode
Re-enables **every package you list** in the restore block.  
Acts as a full safety net to undo any debloat operation.

---

## 🔧 Prerequisites

### ✔ 1. Install Samsung USB Drivers

These drivers allow your PC to correctly detect Samsung phones for ADB.

**Download:**  
Samsung USB Driver for Mobile Phones (official Samsung website)

**Steps:**
1. Download the installer  
2. Run setup  
3. Reboot your PC (recommended)

---

### ✔ 2. Install Android Platform-Tools (ADB)

**Download:**  
Android SDK Platform-Tools for Windows (from Google’s official site)

**Steps:**
1. Extract the ZIP to a simple folder such as:

   C:\platform-tools

2. You should now see:

   adb.exe  
   fastboot.exe

---

### ✔ 3. Place the Batch Script into the Platform-Tools Folder

Place your `.bat` script directly next to `adb.exe` so the script can find it automatically.

Correct folder layout:

C:\platform-tools\  
 adb.exe  
 fastboot.exe  
 Samsung_Debloater.bat  ← place script here

If the folder does not contain `adb.exe`, the script will not run.

---

### ✔ 4. Enable USB Debugging on Your Samsung Device

On your phone:

1. Go to **Settings → About phone → Software information**
2. Tap **Build number** 7 times  
3. Go to **Developer options**
4. Enable **USB debugging**
5. Connect your phone to the PC
6. Accept the prompt:

   Allow USB debugging?

Tap **Allow**.

---

## ▶️ Running the Script

1. Connect your Samsung device via USB  
2. Use **File Transfer (MTP)** mode if prompted  
3. Open **Command Prompt**  
4. Navigate to the platform-tools folder:

   cd C:\platform-tools

5. Launch the script:

   Samsung_Debloater.bat 

6. The script will:
- Detect ADB
- Detect your device
- Confirm whether it’s a Samsung device
- Display a mode selection menu
- Ask you to press any key (other than Backspace)
- Apply the chosen debloat mode

---

## ❗ Troubleshooting

### Device not recognized
- Reinstall Samsung USB drivers  
- Use a better USB cable  
- Enable USB debugging  
- Try another USB port  
- Run:

  adb kill-server  
  adb start-server

### Device shows “unauthorized”
Look at your phone and accept the “Allow USB debugging?” dialog.

### Script closes instantly
Run it from Command Prompt:

cmd  
cd C:\platform-tools  
Samsung_Debloater.bat

### adb.exe not found
You did not place the script in the same folder as platform-tools.

---

## ⚠️ Disclaimer

Removing system apps can result in:
- Missing notifications  
- Disabled Samsung features  
- Issues with Google services  
- Biometric failures  
- Payment app issues  
- Casting/mirroring problems  
- Boot loops if disabling essential apps

Always test progressively.  
Keep Restore Mode available.
I'm not responsible for any device failures

---

## 📄 License

You may freely modify, redistribute, and use this tool.

---

## 🙌 Contributing

You may contribute by:
- Improving script logic
- Documenting safe/unsafe packages
- Providing curated package lists
- Suggesting new features
