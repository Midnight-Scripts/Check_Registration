# Check Validator Registration Script

This script helps you verify whether your **Sidechain Public Key** is registered on the Midnight **Testnet** for Validator.

---

## 🧪 Tested Environment

Tested on:

```
Midnight Sidechain Node - Testnet - Version: 0.12.0-cab67f3b
```

---

## ⚙️ How It Works

The script performs the following steps:

1. ✅ **Current Epoch Check**  
   Verifies if your **Sidechain Public Key** is registered in the **current epoch**.

2. 🕒 **Future Epoch Check**  
   If not registered, it checks **two epochs ahead** to see if your validator is scheduled to be active soon.

3. ❌ **No Registration Found**  
   If your key is not found in either check, it means **registration has not gone through**.

   <img width="921" alt="Not Registered" src="https://github.com/user-attachments/assets/9f72f95b-c4d6-4588-a2c4-5fb9aaf6dfee" />

4. 📋 **Validator Details (If Registered)**  
   If registered, it will print **detailed validator metadata**.

   <img width="973" alt="Registered Validator" src="https://github.com/user-attachments/assets/be66ad38-5593-4dcc-8346-55d85b303c9b" />

---

## 📥 Download the Script

Use `curl` to download the script directly:

```bash
curl -O "https://raw.githubusercontent.com/Midnight-Scripts/Check_Registration/refs/heads/main/check_registration.sh?token=GHSAT0AAAAAAC6QXCRDSGHHEBXFFQVX2B622BXVN6Q"
```

Make it executable:

```bash
chmod +x check_registration.sh
```

Run the script:

```bash
./check_registration.sh
```

---

## 📦 Clone from GitHub

Alternatively, you can clone the repo:

```bash
git clone https://github.com/Midnight-Scripts/Check_Registration.git
cd Check_Registration
chmod +x check_registration.sh
./check_registration.sh
```

---

## 📄 Requirements

**Make sure you have `partner-chains-public-keys.json` in the same directory as the script.**

Your directory should look like this:

```
.
├── check_registration.sh
└── partner-chains-public-keys.json
```

The JSON file should contain your public keys in the following format:

```json
{
  "sidechain_pub_key": "0x...",
  "aura_pub_key": "0x...",
  "grandpa_pub_key": "0x..."
}
```

---

## 📌 Notes

- The script requires `jq` and `curl` to be installed.
- Make sure your node or environment can access:  
  `https://rpc.testnet-02.midnight.network`
- Useful for confirming validator setup prior to an epoch.

---

Enjoy seamless validation checks!
