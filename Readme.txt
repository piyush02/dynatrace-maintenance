
Maintenance windows are typically planned, recurring periods of system downtime during which our DevOps/CloudOps team can perform preventative maintenance and system upgrades outside of peak traffic hours. To avoid having Dynatrace report on any performance anomalies that may result from such events.

Script folder structure.

Output folder - Scripts output logs stores.

Logs folder - Dynatrace API response and status code stores.

Get  the service UID from Dynatrace tenant and use the same for creating a maintenance window.

git clone -

cd dynatrace/dt-maintenance

Execute script - Maintenance.sh

Comand  - bash Maintenance.sh

Select option 1 for get UID lists.

option 2 for creating maintenance window.

option 3 for retrieving maintenance window Information.

option 4 for delete  maintenance window

Select Dynatrace tenant
Select Service to get UID


Re-run the same script for creating maintenance window  

Execute script - Maintenance.sh

Comand  - bash Maintenance.sh

option 1 for get UID lists.

Select option 2 for creating maintenance window.

option 3 for retrieving maintenance window Information.

option 4 for delete  maintenance window

Select Dynatrace tenant and Select appropriate options.

