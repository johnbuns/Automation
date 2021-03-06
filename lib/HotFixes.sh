hotFixes() {
	mediaFix
	ensureWifiConnection
	# updateCron
}

# updateCron() {
	# local newCronFilePath=/data/Automation/Automation/lib/NewCron
	# local cronFileDirectory=/data/crontab
	# local cronFilePath=$cronFileDirectory/root
	
	# if [ -f $newCronFilePath ]; then
		# # Kill the last crond.
		# local lastCrondId=$(pidof crond)
		# kill -15 $lastCrondId
		# # Remove old cron file.
		# rm $cronFilePath
		# # Move new cron file into place.
		# mv $newCronFilePath $cronFilePath
		# # "cron-tabify it."
		# # crontab -c $cronFileDirectory $cronFilePath
		# /data/data/berserker.android.apps.sshdroid/home/.bin/crontab -c $cronFileDirectory $cronFilePath
		# # Restart crond.
		# /data/Automation/crond -b -c $cronFileDirectory
	# fi
		# # /data/data/berserker.android.apps.sshdroid/home/.bin/crontab -c /data/crontab /data/crontab/root
# }

mediaFix() {
	stop media && start media
}

# canPingGoogle() {
	# local googlePing=$(/system/bin/ping -c1 www.google.com | grep -o 64)
	
	# if [ $googlePing == "64" ]; then
		# echo "true"
	# else
		# echo "false"
	# fi
# }

isPingError() {
	local googlePing=$(/system/bin/ping -c1 www.google.com 2>&1 | grep -o "unknown host")
	
	if [ "$googlePing" == "unknown host" ]; then
		echo "true"
	else
		echo "false"
	fi
}

isDisconnectedToRouter() {
	local netstatsWlanInfo=$(dumpsys netstats | grep -E 'iface=wlan.*networkId')
	
	if [ "$netstatsWlanInfo" == "" ]; then
		echo "true"
	else
		echo "false"
	fi
}

cycleWiFi() {
	svc wifi disable
	sleep 2
	svc wifi enable
	sleep 1
}

ensureWifiConnection() {
	if [ $(isDisconnectedToRouter) == "true" ]; then
		logStuff "wifiOutage" "Disconnected from router."
		cycleWiFi
	fi
	
	if [ $(isPingError) == "true" ]; then
		logStuff "wifiOutage" "Lost ability to ping."
		cycleWiFi
	fi
}