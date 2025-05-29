# Check Validator Registration Script

This script helps you verify if your sidechain validator public key is registered in the Midnight Testnet for a given epoch.

## 📥 Download

You can directly download the script using:

```bash
curl -O https://raw.githubusercontent.com/Midnight-Scripts/Check_-Registration/refs/heads/main/check_registration.sh?token=GHSAT0AAAAAAC6QXCRC67UOIQ7NJW2UZV342BXVFSQ
chmod +x check_registration.sh
```
📦 Clone from GitHub

Alternatively, you can clone the repository:

git clone https://github.com/Midnight-Scripts/Check_-Registration.git
cd Check_-Registration
chmod +x check_registration.sh

📄 Requirements

Make sure you have partner-chains-public-keys.json in the same directory as this script.

Example structure:

.
├── check_registration.sh
└── partner-chains-public-keys.json

The JSON file must contain your validator public keys, like this:

{
  "sidechain_pub_key": "0x...",
  "aura_pub_key": "0x...",
  "grandpa_pub_key": "0x..."
}

✅ Usage

Run the script from your terminal:

./check_registration.sh

It will:
	•	Extract keys from partner-chains-public-keys.json
	•	Query the Midnight testnet for the current epoch
	•	Check if your validator is registered in the current or future epoch
	•	Display detailed validator information if found

✅ Tested Environment

This script has been tested on:

Midnight Sidechain Node - Testnet - Version: 0.12.0-cab67f3b


⸻

Feel free to fork or contribute improvements via pull request.

---

Let me know if you'd like this saved as a `.md` file or want to add screenshots or example output to the README.
