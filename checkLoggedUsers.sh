# Code to check users Logged into the shared directory.

function toView(){
	user=$1
	if ! [ -z "$user" ] 
	then
		name=$( pdbedit -L | grep $user | cut -c29-)
		variable=$(smbstatus | grep $user)
		if ! [ -z "$variable" ]
		then
			echo $variable  "->" $name
		fi
	fi
}


while [ true ]
do
	echo ' '
	date=$(date +%F_%H-%M-%S)
	echo $date
	smbstatus | head -5
	for i in $(pdbedit -L | cut -c1-8)
	do
		toView $i
		echo $(toView)
	done
	sleep 1m
done
