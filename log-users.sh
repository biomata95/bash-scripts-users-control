while [ true ]
do
	date=$(date +%F_%H-%M-%S)
	smbstatus > /home/admin/Logs/$date".log"
	sleep 60
done
