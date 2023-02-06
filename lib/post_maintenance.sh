#!/bin/bash

myscript=$0
mydriname=`dirname ${myscript}`
if [[ ${mydriname} == "." ]]
    then
    mydriname=`pwd`
fi

cd $mydriname
#mypwd=${echo $PWD}


select tenant in Tenant1 Tenant2 Tenant3 Tenant4 Tenant5 quit;
do
  case "$tenant" in
         Tenant1)
            tenant_url="https://XXXX.live.dynatrace.com"
            tenant_id="XXXX"
            api_token="XXXXX"
            break
            ;;
        Tenant2)
            tenant_url="https://XXXX.live.dynatrace.com"
            tenant_id="XXXX"
            api_token="XXXXX"
            break
            ;;
        Tenant3)
            tenant_url="https://XXXX.live.dynatrace.com"
            tenant_id="XXXX"
            api_token="XXXXX"
            break
            ;;
        Tenant4)
            tenant_url="https://XXXX.live.dynatrace.com"
            tenant_id="XXXX"
            api_token="XXXXX"
            break
            ;;
        Tenant5)
            tenant_url="https://XXXX.live.dynatrace.com"
            tenant_id="XXXX"
            api_token="XXXXX"
            break
            ;;
        #Pick*)
        #    read -p "Enter a number from 1 to 10000: " number
        #    break
        #    ;;

        quit)
                exit 1
                break
                ;;
    *)
      echo "Invalid option $REPLY"
      ;;
  esac
  shift
done

select maintenance_type in UNPLANNED PLANNED quit;
do
  case "$maintenance_type" in
        UNPLANNED)
            maintenance_type_flag=1
            maintenance_type_msg="UNPLANNED"

            break
          ;;
        PLANNED)
            maintenance_type_flag=2
            maintenance_type_msg="PLANNED"
            break
          ;;

        #Pick*)
        #    read -p "Enter a number from 1 to 10000: " number
        #    break
        quit)
                exit 1
                break
                ;;
    *)
      echo "Invalid option $REPLY"
      ;;
  esac
  shift
done

select suppression in DETECT_PROBLEMS_AND_ALERT DETECT_PROBLEMS_DONT_ALERT DONT_DETECT_PROBLEMS quit;
do
  case "$suppression" in
        DETECT_PROBLEMS_AND_ALERT)
            suppression_flag=1
            suppression_msg="DETECT_PROBLEMS_AND_ALERT"
            break
            ;;
        DETECT_PROBLEMS_DONT_ALERT)
            suppression_flag=2
            suppression_msg="DETECT_PROBLEMS_DONT_ALERT"
            break
            ;;

        DONT_DETECT_PROBLEMS)
            suppression_flag=3
            suppression_msg="DONT_DETECT_PROBLEMS"
            break
            ;;
        #Pick*)
        #    read -p "Enter a number from 1 to 10000: " number
        #    break
        #    ;;
        quit)
            exit 1
            break
            ;;
    *)
      echo "Invalid option $REPLY"
      ;;
  esac
  shift
done

select recurrenceType in ONCE DAILY MONTHLY WEEKLY quit;
do
  case "$recurrenceType" in

        ONCE)
            recurrence_flag=1
            recurrence_msg="ONCE"
            break
            ;;
        DAILY)
            recurrence_flag=2
            recurrence_msg="DAILY"
            break
            ;;
        MONTHLY)
            recurrence_flag=3
            recurrence_msg="MONTHLY"
            break
            ;;
        WEEKLY)
            recurrence_flag=4
            recurrence_msg="WEEKLY"
            break
            ;;
        #Pick*)
        #    read -p "Enter a number from 1 to 10000: " number
        #    break
        #    ;;
        quit)
                exit 1
                break
                ;;
    *)
      echo "Invalid option $REPLY"
      ;;
  esac
  shift
done

current_time=$(date "+%Y_%m_%d-%H_%M:%S")
#cp ../json/default_maintenance.json ../json/maintenance-"$tenant_id"-"$current_time".json
my_json=$(echo ../json/maintenance-"$tenant_id"-"$current_time".json)
cp ../json/default_maintenance.json $my_json
logfile=$(echo ../logs/post_validator_"$tenant_id"_"$current_time".txt)
logs_post=$(echo ../logs/post_response-code_"$tenant_id"_"$current_time".txt)
uid_output=$(echo ../logs/id_"$tenant_id"_"$current_time".json)
touch $uid_output

#echo $tenant_id
read_input() {

echo -e "Example - Deployment of a new version of the main application"
read -p "Enter maintenance description: " description
echo -e "Example - Main app update"
read -p "Enter maintenance name: " maintenance_name
echo -e "Example - maintenance start time formate - 2021-02-18 17:15"
read -p "Enter Start time: " maintenance_start

echo -e "Example - maintenance stop time formate - 2021-02-18 18:15"
read -p "Enter Stop time: " maintenance_stop

echo -e "Example - maintenance zoneId - Asia/Calcutta"
read -p "Enter Manintenance ZoneID: " maintenance_zoneId

echo -e "Example Maintenance scopes (add multiple values in comma separated) - HOST-E71C67722B8A84B,HOST-FC6974DB7E5CFD59"
read -p "Enter Scope for Maintenance: " scope

#new_scope=$(echo $scope | sed -e s/\,/\"\,\"/g)

    if [[ -n "$description" ]] && [[ -n "$maintenance_name" ]] && [[ -n "$maintenance_start" ]] && [[ -n "$maintenance_stop" ]] && [[ -n "$maintenance_zoneId" ]] && [[ -n "$scope" ]]; then


        new_scope=$(echo $scope | sed -e s/\,/\"\,\"/g)

    else

      echo "FAIL: Forced Exit... Null value found in the provided parameters"
      exit 1

    fi

}


update_json() {


#sed -i '' "s/maintenance_name/$maintenance_name/" $my_json
#sed -i '' "s/maintenance_description/$description/" $my_json
#sed -i '' "s/maintenance_type/$maintenance_type_msg/" $my_json
#sed -i '' "s/maintenance_suppression/$suppression_msg/" $my_json
#sed -i '' "s/ONCE/$recurrence_msg/" $my_json
#sed -i '' "s/schedule_start/$maintenance_start/" $my_json
#sed -i '' "s/schedule_stop/$maintenance_stop/" $my_json
#sed -i '' "s/maintenance_zoneid/$maintenance_zoneId/" $my_json
#sed -i '' "s/SYNTHETIC_TEST/$new_scope/" $my_json

cat <<EOF > $my_json

{
    "name": "$maintenance_name",
    "description": "$description",
    "type": "$maintenance_type_msg",
    "suppression": "$suppression_msg",
    "suppressSyntheticMonitorsExecution": true,
    "scope": {
    "entities": [
    	"$new_scope"
    	],
    "matches": []
  },
    "schedule": {
        "recurrenceType": "$recurrence_msg",
        "start": "$maintenance_start",
        "end": "$maintenance_stop",
        "zoneId": "$maintenance_zoneId"
    }
}

EOF

}


post_validator() {


        curl --write-out %{http_code} --silent -f --location --request POST "$tenant_url/api/config/v1/maintenanceWindows/validator" \
        --header 'Content-Type: application/json' \
        --header "Authorization: Api-token $api_token" \
        -d @$my_json > $logfile



}

validator_check() {
    res=$(cat $logfile)

    if [[  "$res" == "204" ]];
        then
        flag_v=1
        echo -e "PASS: Json validator"
	read -p "Are you sure? " -n 1 -r 
    	echo " "
    	if [[ $REPLY =~ ^[Yy]$ ]]; then
        	flag_check=1
    	
	else 
		echo "User Exit"
		exit 1
	fi
    else
        echo -e "FAIL: Json validator"
        exit 1

    fi

}

post_maintenanceWindows() {

    if [[  $flag_v -eq 1 ]] && [[ $flag_check -eq 1 ]]; then

        curl --write-out %{http_code} --silent --output $uid_output --location --request POST "$tenant_url/api/config/v1/maintenanceWindows" \
        --header 'Content-Type: application/json' \
        --header "Authorization: Api-token $api_token" \
        -d @$my_json > $logs_post

        echo -e "PASS: Successfully created a maintenance window"

    else
        echo -e "FAIL: There was an error in the script which triggered a forced exit with status 1"
        exit 1
    fi


}

post_maintenance_check() {
    post_res=$(cat $logs_post)

    if [[ $post_res -eq 201 ]]; then

        jq '.' $uid_output
        echo " "
	echo "Post response"
	jq '.' $my_json
        mv $my_json ../logs/
    else

        echo -e "FAIL: Json maintenance window post"
        exit 1

    fi



}

#Execution Flow
read_input
update_json
post_validator
validator_check
post_maintenanceWindows
post_maintenance_check
