#!/bin/bash

# define script execution dir
myscript=$0
mydirname=`dirname ${myscript}`
if [[ ${mydirname} == "." ]]
    then
     mydirname=`pwd`
fi

cd $mydirname
current_time=$(date "+%Y_%m_%d-%H_%M:%S")

#exit_on_error() {
#  echo ""
#  echo -e "\e[31;1m### There was an error in the script which triggered a forced exit with status 1 ###\e[0m"
##  echo ""
#  exit 1
#}



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

read_input() {
echo "Example - 44d1a0e2-cd2b-4796-b5ae-2de8f72bdb34 OR Leave empty to get all maintenance id"
read -p "Enter maintenance id: " uid

	if [[ -z $uid ]]; then
		apiv1="/api/config/v1/maintenanceWindows"

	else
		apiv1="/api/config/v1/maintenanceWindows/$uid"
	fi

}


#apiv1="/api/config/v1/maintenanceWindows"
output_json=$(echo ../logs/maintenanceWindows_response_"$tenant_name"_"$current_time".json)
list_response=$(echo ../logs/response-code_maintenanceWindows_"$tenant_name"_"$current_time".txt)
output_name=$(echo ../output/"$tenant_name"_"$tenant_id"_list_"maintenanceWindows_$current_time".txt)
#touch $output_json

get_json() {

    
    #curl_list_comand="
    curl --write-out %{http_code} --silent --output $output_json -f --location --request GET $tenant_url$apiv1  -H "Authorization: Api-token $api_token" > $list_response


}



name_json() {
    res=$(cat $list_response) 

    if [[  "$res" == "200" ]];
        then

                echo "Tenant Name: $tenant_name"
                echo " "
                jq -r '.[]' $output_json 
                echo "Tenant Name: $tenant_name" >> $output_name
                jq -r '.[]' $output_json >> $output_name
    
        else

        echo -e "\e[33mError unable to connect status code: "$res"\e[0m"
        echo "                       OR                                  "
        echo -e "\e[31;1m### There was an error in the script which triggered a forced exit with status 1 ###\e[0m"
        exit 1
    fi
  
}


#main
#exit_on_error
read_input
get_json
name_json


