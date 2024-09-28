# CUPS Mitigation Script

## Overview
This script mitigates a critical vulnerability (CVE-2024-47176 and related) in the CUPS printing service for Linux systems, rated 9.9/10. The script provides a way to disable vulnerable services, block CUPS network exposure, and revert changes once a patch is available.

### How It Works:
- Disables the `cups-browsed` service to stop automatic printer discovery.
- Blocks access to UDP port 631 to protect the CUPS service from external threats.
- Restricts CUPS to listen only on `localhost`, preventing network exposure.

## Usage

Clone this repository to your local machine and make the script executable:

```bash
git clone https://github.com/fr33s0ul/CUPS-mitigation-script.git
cd CUPS-mitigation-script
chmod +x cups_mitigation.sh
```

- To **apply the mitigations**:

```bash
sudo ./cups_mitigation.sh apply
```

- To **revert the changes** after a patch is released:

```bash
sudo ./cups_mitigation.sh revert
```

## License
This project is licensed under the MIT License.
