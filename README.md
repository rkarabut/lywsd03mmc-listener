## What this does

The script queries LYWSD03MMC devices in range for the temperature and humidity data periodically, printing a json string of the following format once per given interval if the query was successful:

```json
{"mac":"A4:C1:38:00:00:00","temperature":25.11,"humidity":31,"timestamp":1633898796} 
```

## Requirements

```bash
sudo apt-get install bluez jo 
```

## Finding your device

Run the BLE scan to get the MACs of your devices (the scan is continuous so hit the Ctrl-C when you're sure you've found all of them):

```bash
hcitool lescan | grep LYWSD03MMC
```

Replace the dummy MACs in the script with the results.
