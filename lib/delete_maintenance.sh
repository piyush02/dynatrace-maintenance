
#!/bin/bash

# define script execution dir
myscript=$0
mydirname=`dirname ${myscript}`
if [[ ${mydirname} == "." ]]
    then
     mydirname=`pwd`
fi

cd $mydirname

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

current_time=$(date "+%Y_%m_%d-%H_%M:%S")
logfile=$(echo ../logs/del_response_"$tenant_id"_"$current_time".txt)

read_input() {
echo "Example - 44d1a0e2-cd2b-4796-b5ae-2de8f72bdb34"
read -p "Enter maintenance id: " uid

if [[ -z $uid ]]; then

    echo "forced exit: id is null"
    exit 1

else 
    
    read -p "Are you sure? " -n 1 -r 
    echo " "
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        flag=1
    fi

fi

}

delete_main() {

if [[ $flag -eq 1 ]]; then
    curl --write-out %{http_code} --silent --output /dev/null -f --location --request DELETE "$tenant_url/api/config/v1/maintenanceWindows/$uid" \
    --header "Authorization: Api-token $api_token" > $logfile

else 

    echo "FAIL: Forced exit with status 1"
    exit 1

fi


}


check_del_res() {

    read_del=$(cat $logfile)

    if [[ $read_del -eq 204 ]]; then

        echo "PASS: Successfully deleted"

    else

        echo "FAIL: Unable to delete"
        echo "http status code: $read_del"
    
        exit 1

    fi

}

#Execution Flow
read_input
delete_main
check_del_res
