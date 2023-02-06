#!/bin/bash

# define script execution dir
myscript=$0
mydirname=`dirname ${myscript}`
if [[ ${mydirname} == "." ]]
    then
     mydirname=`pwd`
fi

cd $mydirname
mypwd=$(echo $PWD)
current_time=$(date "+%Y_%m_%d-%H_%M:%S")



select script in get-list create-maintenance get-maintenance delete-maintenance quit;
do
  case "$script" in
        get-list)
            my_script=$(echo $mypwd/lib/get_list.sh)
            break
            ;;
        create-maintenance)
            my_script=$(echo $mypwd/lib/post_maintenance.sh)
            break
            ;;
        get-maintenance)
            my_script=$(echo $mypwd/lib/get_maintenance.sh)
            break
            ;;
        delete-maintenance)
            my_script=$(echo $mypwd/lib/delete_maintenance.sh)
            break
            ;;
        #Pick*)
        #    read -p "Enter a number from 1 to 10000: " number
        #    break
        #    ;;
        #;;
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

run_script() {

    bash $my_script

}

run_script 