# Capstone_project_react_app

Set up a CICD for the react application process in jenkins.

1.) We have two branches Master and dev, each has it's own CICD setup. where the application is built by docker
pushed to dockerhub and deployed in AWS-EC2 instance(server) as per the instructions.

 2.) Monitoring setup made by prometheus and grafana. --config files availble in the monitoring folder.
 these were referred from the pormetheus website.

 3.) Required credentials for these project stored in Jenkins credentials files, and brought to pipeline
 via environment variables.




