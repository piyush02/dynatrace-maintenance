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


select entity in hosts synthetic database process_groups applications all quit;
do
  case "$entity" in
    hosts)
            
            apiv1="/api/v1/entity/infrastructure/hosts"
            name="host"
            flag=1
            break
            ;;

    synthetic)
            apiv1="/api/v1/synthetic/monitors"
            name="monitors"
            flag=2
            break
            ;;  

    database)
            apiv1="/api/v1/entity/services?serviceType=Database"
            name="database"
            flag=3
            break
            ;; 

    process_groups)
            apiv1="/api/v1/entity/infrastructure/process-groups"
            name="process-groups"
            flag=4
            break
            ;; 

    applications)
            apiv1="/api/v1/entity/applications"
            name="application"
            flag=5
            break
            ;;  
    all)
            flag=6
            name="all"
            break
            ;;

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


output_json=$(echo ../logs/"$tenant_name"_api_response_"$current_time".json)
list_response=$(echo ../logs/"$tenant_name"_api_response-code_"$current_time".txt)
output_name=$(echo ../output/"$tenant_name"-"$tenant_id"-list-"$current_time".txt)
#touch $output_json

get_json() {

    
    #curl_list_comand="
    curl --write-out %{http_code} --silent --output $output_json -f --location --request GET $tenant_url$apiv1  -H "Authorization: Api-token $api_token" > $list_response
    #curl --write-out %{http_code} --silent --output list_host_2021_03_12-03_15.json -f --location --request GET https://rfc83258.live.dynatrace.com/api/v1/entity/infrastructure/hosts -H 'Authorization: Api-token dt0c01.VPB7IHGJTBB65ZQ7IZS6UQIH.TOGSJCV7GREWE7DTLBVEIITVSRDOORURYZYBAU5G4WWE2IOI3DU36UL7Q7TZTJN2' 
    #curl --write-out %{http_code} --silent --output list_host_2021_03_12-03_15.json -f --head -H "Authorization: Api-token $api_token" --location --request GET $tenant_url$apiv1 

}



name_json() {
    res=$(cat $list_response) 

    if [[  "$res" == "200" ]];
        then

            if [[ $flag -eq 1 ]]; then

                echo "Tenant Name: $tenant_name"
                echo " "
                jq -r '.[]| "\(.entityId)  - \(.displayName)"' $output_json 
                echo "Tenant Name: $tenant_name" >> $output_name
                jq -r '.[]| "\(.entityId)  - \(.displayName)"' $output_json >> $output_name
    
            elif [[ $flag -eq 2 ]]; then
                echo "Tenant Name: $tenant_name"
                echo " "
                jq -r '.monitors[] | "\(.entityId) -  \(.name)"' $output_json
                echo "Tenant Name: $tenant_name" >> $output_name
                jq -r '.monitors[] | "\(.entityId)  - \(.name)"' $output_json >> $output_name
            
            elif [[ $flag -eq 3 ]] && [[ $skip_db -ne 1 ]]; then 
                echo "Tenant Name: $tenant_name"
                echo " "
                jq -r '.[] | "\(.fromRelationships.runsOnProcessGroupInstance) - \(.databaseName)   \(.databaseHostNames)"' $output_json | grep -v 'null' | sed -e 's/\[\"//g' | sed -e 's/\"\]//g'
                echo "Tenant Name: $tenant_name" >> $output_name
                jq -r '.[] | "\(.fromRelationships.runsOnProcessGroupInstance) - \(.databaseName)   \(.databaseHostNames)"' $output_json | grep -v 'null' | sed -e 's/\[\"//g' | sed -e 's/\"\]//g' >> $output_name

            elif [[ $flag -eq 4 ]]; then 
                echo "Tenant Name: $tenant_name"
                echo " "
                jq -r '.[] | select(.discoveredName=="Tomcat") | "\(.toRelationships.isInstanceOf) - \(.displayName)"' $output_json | sed -e 's/\[\"//g' | sed -e 's/\"\]//g' | sed -e 's/\"\,\"/,/g' 
                echo "Tenant Name: $tenant_name" > $output_name
                jq -r '.[] | select(.discoveredName=="Tomcat") | "\(.toRelationships.isInstanceOf) - \(.displayName)"' $output_json | sed -e 's/\[\"//g' | sed -e 's/\"\]//g' | sed -e 's/\"\,\"/,/g' >> $output_name
            
            elif [[ $flag -eq 5 ]]; then 
                echo "Tenant Name: $tenant_name"
                echo " "
                jq -r '.[] | "\(.entityId)  -   \(.displayName)"' $output_json 
                echo "Tenant Name: $tenant_name" >> $output_name
                jq -r '.[] | "\(.entityId)  -   \(.displayName)"' $output_json >> $output_name

            else 
                if [[ $skip_db -eq 1 ]]; then
                    echo " Not Applicable for Database API for tenant $tenant_name"
                else
                    echo "Reach out to Piyush Yadav"
                fi
            fi
        else

        echo -e "\e[33mError unable to connect status code: "$res"\e[0m"
        echo "                       OR                                  "
        echo -e "\e[31;1m### There was an error in the script which triggered a forced exit with status 1 ###\e[0m"
        exit 1
    fi
  
}




get_all() {
    #set -x
    declare -a url_list
    url_list=("/api/v1/entity/infrastructure/hosts" "/api/v1/synthetic/monitors" "/api/v1/entity/services?serviceType=Database" "/api/v1/entity/infrastructure/process-groups" "/api/v1/entity/applications")
    count=0

    for i in "${url_list[@]}"; do   
       
        curl --write-out %{http_code} --silent --output $output_json -f --location --request GET $tenant_url$i  -H "Authorization: Api-token $api_token" > $list_response    
        #url_num=
        (( count++ ))
    
        res=$(cat $list_response) 

        if [[  "$res" == "200" ]];
            then

                if [[ $count -eq 1 ]]; then

                    echo "Tenant Name: $tenant_name"
                    echo "Host"
                    echo " "
                    echo "Host" >> $output_name
                    jq -r '.[]| "\(.entityId)  - \(.displayName)"' $output_json 
                    echo "Tenant Name: $tenant_name" > $output_name
                    jq -r '.[]| "\(.entityId)  - \(.displayName)"' $output_json >> $output_name
                    echo " "
    
                elif [[ $count -eq 2 ]]; then
                    echo "Tenant Name: $tenant_name"
                    echo "Monitors"
                    echo " "
                    echo "Monitors" >> $output_name
                    jq -r '.monitors[] | "\(.entityId) -  \(.name)"' $output_json
                    echo "Tenant Name: $tenant_name" > $output_name
                    jq -r '.monitors[] | "\(.entityId)  - \(.name)"' $output_json >> $output_name
                    echo " "
            
                elif [[ $count -eq 3 ]] && [[ $skip_db -ne 1 ]]; then 
                    echo "Tenant Name: $tenant_name"
                    echo "Database"
                    echo " "
                    echo "Database" >> $output_name
                    jq -r '.[] | "\(.fromRelationships.runsOnProcessGroupInstance) - \(.databaseName)   \(.databaseHostNames)"' $output_json | grep -v 'null' | sed -e 's/\[\"//g' | sed -e 's/\"\]//g'
                    echo "Tenant Name: $tenant_name" >> $output_name
                    jq -r '.[] | "\(.fromRelationships.runsOnProcessGroupInstance) - \(.databaseName)   \(.databaseHostNames)"' $output_json | grep -v 'null' | sed -e 's/\[\"//g' | sed -e 's/\"\]//g' >> $output_name
                    echo " "

                elif [[ $count -eq 4 ]]; then 
                    echo "Tenant Name: $tenant_name"
                    echo "Process-groups"
                    echo " "
                    echo "Process-groups" >> $output_name
                    jq -r '.[] | select(.discoveredName=="Tomcat") | "\(.toRelationships.isInstanceOf) - \(.displayName)"' $output_json | sed -e 's/\[\"//g' | sed -e 's/\"\]//g' | sed -e 's/\"\,\"/,/g' 
                    echo "Tenant Name: $tenant_name" >> $output_name
                    jq -r '.[] | select(.discoveredName=="Tomcat") | "\(.toRelationships.isInstanceOf) - \(.displayName)"' $output_json | sed -e 's/\[\"//g' | sed -e 's/\"\]//g' | sed -e 's/\"\,\"/,/g' >> $output_name
                    echo " "

                elif [[ $count -eq 5 ]]; then 
                    echo "Tenant Name: $tenant_name"
                    echo "Applications"
                    echo " "
                    echo "Applications" >> $output_name
                    jq -r '.[] | "\(.entityId)  -   \(.displayName)"' $output_json 
                    echo "Tenant Name: $tenant_name" >> $output_name
                    jq -r '.[] | "\(.entityId)  -   \(.displayName)"' $output_json >> $output_name
                    echo " "

                else 
                    if [[ $skip_db -eq 1 ]]; then
                        echo " Not Applicable for Database API for tenant $tenant_name"
                    else
            
                        echo "Reach out to Piyush Yadav"
                    fi
            
            fi
        else

        echo -e "\e[33mError unable to connect status code: "$res"\e[0m"
        echo "                       OR                                  "
        echo -e "\e[31;1m### There was an error in the script which triggered a forced exit with status 1 ###\e[0m"
        exit 1
    fi 

done

#set +x

}


# Execution flow
if [[ $flag -eq 6 ]]; then

    get_all

else   

    get_json
    name_json
fi
