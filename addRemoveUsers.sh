# Bash code to add/remove users for shared directory access

function retrieve_name(){
	user=$1
	retrieve=$(pdbedit -L | grep $user)
	echo "User data"
	echo $retrieve
}

function search_user(){
	user=$1
	exists=false
	for registered in $(pdbedit -L | cut -c1-8); do
		if [ "$registered" = "$user"  ]
		then 
			retrieve_name $user
			echo "User $user is already registered."
			exit
		fi
	done
	echo "User $user NOT found. Add him with the command users.sh -i username."
}

function add_users(){
	pass="password"
	file_users=$1
	echo $file_users
	while read user # Loop to add users to samba
	do
		(echo $pass; echo $pass) | smbpasswd -s -a ${user,,}
	done < $file_users
}


function add_specific_user(){
        pass="password"
	(echo $pass; echo $pass) | smbpasswd -s -a $1
}

function remove_users(){
	for user in $(pdbedit -L | cut -c1-8); do
		smbpasswd -x $user  # Remove user
	done
}

function remove_specific_user(){
	smbpasswd -x $1  # User removal
}

function list_users(){
	pdbedit -L # List all users
}

argument=$1

if [ "$argument" = "" ]
then
	echo 'Null argument.'	
	exit 1
elif [ "$argument" = "-a" ] # Automatically add all users from file
then
	file_users=$2
	add_users $file_users
elif [ "$argument" = "-l" ] # List all samba users
then
	list_users
elif [ "$argument" = "-i" ] # Add a specific user
then
	user=$2
	add_specific_user $user
elif [ "$argument" = "-x" ] # Remove a specific user
then
	user=$2
	remove_specific_user $user
elif [ "$argument" = "-d" ] # Delete all users a specific user
then
	remove_users
elif [ "$argument" = "-s" ] # Search for specific user
then
	user=$2
	search_user $user
elif [ "$argument" = "-h" ] # Basic Menu
then
	echo 'Arguments for each operation'
	echo ''
	echo '-l List all users'
	echo '-a file Add all users from a text file'
	echo '-i username Add a specific user'
	echo '-x username Remove a specific user'
	echo '-d Delete all users'
	echo '-s username Search user by registration'
	echo '-h Command menu'

fi


