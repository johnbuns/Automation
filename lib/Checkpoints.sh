checkpointsPackage="com.checkpoints.app"
checkpointsMainActivity="com.checkpoints.app.ui.MainActivity"
checkpointsPressActivity="com.checkpoints.app.ui.MainActivity"
checkPointsLogName="checkpoints"

launchCheckpoints() {
	launchCheckpoints2
	
	while :
	do
		sleep 20
		checkPointsHealthCheck
	done
}

launchCheckpoints2() {
	echo "Launching Checkpoints"
	waitUntilTextFound "tab_videos"
	normalTouch 200 457
	waitUntilTextFound "play_all_button"
	normalTouch 80 140
}

checkPointsHealthCheck() {
	dumpScreen
	standardHealthCheck
	
	if [ $(isValueOnScreen "Unfortunately") == "true" ]; then
		logStuff $checkPointsLogName "Unfortunately checkpoints has stopped."
		normalTouch 175 250
		sleep 2
		restartTheWholeThing
	fi
	
	if [ $(isValueOnScreen "Can't play this video") == "true" ]; then
		logStuff $checkPointsLogName "Can't play this video."
		normalTouch 240 200
	fi
	
	if [ $(isValueOnScreen "text=\"X\"") == "true" ]; then
		logStuff $checkPointsLogName "Static ad."
		normalTouch 455 25  ## Horizontal coordinates...
	fi
	
	
	if [ $(isValueOnScreen "Network Problem") == "true" ]; then
		logStuff $checkPointsLogName "Network problem."
		restartTheWholeThing
	fi
	
	if [ $(isValueOnScreen "tab_videos") == "true" ]; then
		restartTheWholeThing
	fi
	
	if [ $(isValueOnScreen "play_all_button") == "true" ]; then
		restartTheWholeThing
	fi
	
	if [ $(isValueOnScreen "CheckPoints isn't responding. Do you want to close it?") == "true" ]; then
		logStuff $checkPointsLogName "CheckPoints isn't responding. Do you want to close it?"
		boundedTouch 240 179 384 227
		sleep 2
		restartTheWholeThing
	fi
}