truncateCask () {
	for i in "$@" ; do
		currentCask=""
		latestCask=""
		# Show the latest version and the installed one.
		echo  "$i \c" 
		for i in $(brew cask info $i | sed '2d' | sed -n '1,2p'); do
			if [[ $i == [0-9]*[0-9] ]] || [[ $i == latest ]] ; then
				latestCask=$i
				echo  "$i \c"
			fi

			if [[ $i == /* ]]; then
				for terms in $(echo $i | sed 's/\// /g'); do
					if [[ $terms == [0-9]* ]] || [[ $terms == latest ]] ; then
						currentCask=$terms
						echo  " $terms\c"
					fi
				done
			fi
		done

		if [[ $currentCask == "$latestCask" ]]; then
			echo " [OK]"
		elif [[ $currentCask == latest ]] || [[ $latestCask == latest ]]; then
			echo " [UNKNOWN]"
		else
			echo " [OUTDATED]"
		fi
	done
}

printCask () {
	# Print all the apps
	if [[ $1 == 0 ]]; then
		awk 'BEGIN {
			printf "\033[;;1m%-24s %-24s %-24s %-24s\033[0m\n"  ,"Cask Name","Current Version","Latest Version","Status"
			printf "%-24s %-24s %-24s %-24s\n"  ,"------------","------------------","-----------------","-----------" 
		}
		{
			if($4=="[OK]") 
				{printf "%-24s %-24s %-24s \033[32m%-24s\033[0m\n"  ,$1,$3,$2,$4}
			else if($4=="[UNKNOWN]") 
				{printf "\033[33m%-24s\033[0m \033[33m%-24s\033[0m \033[33m%-24s\033[0m \033[33m%-24s\033[0m\n" ,$1,$3,$2,$4 }
			else
				{printf "\033[31m%-24s %-24s %-24s %-24s\033[0m\n" ,$1,$3,$2,$4 }
		}' ~/Library/Caches/brewcaskUpgrade/temp
	fi
		
	#########  UI  #############	
	echo "\n\n\033[;31;1m==>\033[0m \033[;37;1mOutdated Casks:\n\033[0m" 
	#########  UI  #############	

	# Print apps needed to be upgraded
	if [[ $3 == 0 ]]; then
		awk '
		{
			if($4=="[OUTDATED]")
				{printf "\033[31m%-24s %-24s %-24s %-24s\033[0m\n" ,$1,$3,$2,$4 ; count = count+1}
		}
		' ~/Library/Caches/brewcaskUpgrade/temp
	else
		awk '
		{
			if($4=="[OUTDATED]")
				{printf "\033[31m%-24s\033[0m %-24s \033[31m%-24s %-24s\033[0m\n" ,$1,$3,$2,$4 ; count = count+1}
			else if($4=="[UNKNOWN]")
				{printf "\033[33m%-24s\033[0m %-24s \033[33m%-24s %-24s\033[0m\n" ,$1,$3,$2,$4 ; count = count+1}
		}
		' ~/Library/Caches/brewcaskUpgrade/temp
	fi
	

	# How many apps need upgrading?
	appCount=$(if [[ $3 == 0 ]]; then
		awk -v count=0 '{if($4=="[OUTDATED]"){count = count+1}} END{print count}' ~/Library/Caches/brewcaskUpgrade/temp
	else
		awk -v count=0 '{if($4=="[OUTDATED]"||$4=="[UNKNOWN]"){count = count+1}} END{print count}' ~/Library/Caches/brewcaskUpgrade/temp
	fi)


	#########  UI  #############	
	if [[ $appCount == 0 ]]; then
		printf "\033[;31;1m==>\033[0m \033[;37;1mNo cask need to be upgraded.\n\033[0m"
		exit 0;
	fi
	#########  UI  #############	

	# Checking
	if [[ $2 == 0 ]]; then
		printf "\nDo you want to upgrade those apps? (Y/N)\n"
		read result
	else
		return 0
	fi

	# Quit or continue to upgrade
	if [[ $result == [yY] || $result == "" ]]; then
		return 0
	else
		exit 0
	fi
}


updateCask () {

	#########  UI  #############	
	echo "\033[;31;1m==>\033[0m \033[;37;1mUpgrading Casks\033[0m"
	#########  UI  #############	

	for i in $@; do
		brew cask reinstall $i
	done

	#########  UI  #############	
	echo "\033[;31;1m==>\033[0m \033[;37;1mNow all the apps are the latest.😄\033[0m"
	#########  UI  #############	
}



parseArguments () {
	forceStatus=0
	skipStatus=0
	silentStatus=0
	yesStatus=0

	# Parse the arguments
	for i in "$@"; do
		if [[ $i == -* ]]; then
			for word in $i; do
				case $word in
					-help | -h )
						Help
						exit 0;;
					-force )
						forceStatus=1;;
					-skip )
						skipStatus=1;;
					-[nfsy][nfsy][nfsy][nfsy] | -[nfsy][nfsy][nfsy] | -[nfsy][nfsy] | -[nfsy])
						for char in $(echo $word | sed 's/[^\033]/& /g')  ; do
							if [[ $char == n ]]; then 
								silentStatus=1 
							elif [[ $char == s ]]; then 
								skipStatus=1
							elif [[ $char == f ]]; then 
								forceStatus=1 
							elif [[ $char == y ]]; then 
								yesStatus=1
							fi
						done;;
					-yes )
						yesStatus=1;;
					* )
						echo "Invalid parameters!"
						echo "Using '-help' options!"
						exit 1;;
				esac
			done
		fi
	done


	echo "\033[;31;1m==>\033[0m \033[;37;1mOptions:\033[0m"
	echo "\t-f -force\n\t-s -skip\n\t-yes\n\t-n"


	# Update Homebrew to get the correct version
	if [[ $skipStatus == 0 ]]; then
		echo "\033[;31;1m==>\033[0m \033[;37;1mUpdating Homebrew\033[0m"
		brew update
	fi

	echo "\033[;31;1m==>\033[0m \033[;37;1mCollecting Information\033[0m"

	# Collect Cask information
	truncateCask $(brew cask list) >~/Library/Caches/brewcaskUpgrade/temp

	# Print
	if printCask $silentStatus $yesStatus $forceStatus; then
		# Create the list of apps which will be reinstalled
		if [[ $forceStatus == 1 ]]; then
			updateCask $(gawk '{ if($4=="[OUTDATED]"||$4=="[UNKNOWN]") {printf "%s ",$1} }' ~/Library/Caches/brewcaskUpgrade/temp)
		else
			updateCask $(gawk '{ if($4=="[OUTDATED]") {printf "%s ",$1} }' ~/Library/Caches/brewcaskUpgrade/temp)
		fi
	fi
}


Help () {
	printf "%10s%-10s\t%-20s\n"  "" "-f,-force" "Also update the casks in unknown status."
	printf "%10s%-10s\t%-20s\n" "" "-s,-skip" "Skip the 'brew update'."
	printf "%10s%-10s\t%-20s\n" "" "-y,-yes" "Update all outdated casks without asking."
	printf "%10s%-10s\t%-20s\n" "" "-n" "By Default, all status of the casks will be shown." 
	printf "%-20s\t%-20s\n" "" "This option will only display the outdated ones."
}



# For storing temp file
[ -d ~/Library/Caches/brewcaskUpgrade/ ]
if [[ $? != 0 ]]; then
	mkdir ~/Library/Caches/brewcaskUpgrade/
fi

parseArguments $*
