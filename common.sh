script_location=$(pwd)
LOG=/tmp/roboshop.log

print_head() {
  echo -e "\e[1m $1\e[0m"
}

status_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[33mFAILURE\e[0m"
    echo "Please Refer log for more info -${LOG}"
  exit
  fi
}

App_Prereq() {
  print_head "Useradd"
    id roboshop &>>${LOG}
    if [ $? -ne 0 ]; then
      useradd roboshop &>>${LOG}
    fi
    status_check


    print_head "Creating App Folder"
    mkdir /app -p &>>${LOG}
    status_check

    print_head "Downloading"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${LOG}
    status_check

    print_head "Removing App Content"
    rm -rf /app/* &>>${LOG}
    status_check

    print_head "Extracting App content"
    cd /app
    unzip /tmp/${component}.zip &>>${LOG}
    status_check

    cd /app
}
schema_load() {
if [ ${schema_load} == "true" ]; then
  if [ ${schema_type} == "mongo"];then

    cp ${script_location}/files/mongoclient /etc/yum.repos.d/mongo.repo &>>${LOG}

    print_head "Installing Mongoclient"
    yum install mongodb-org-shell -y &>>${LOG}
    status_check

    mongo --host 172.31.84.182 </app/schema/${component}.js &>>${LOG}
  fi

  if [ ${schema_type} == "mysql" ]; then
    print_head "Install Mysql"
    yum install mysql -y &>>${LOG}
    status_check

    print_head "SettingUp password"
    mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -p${set_root_password} < /app/schema/shipping.sql
    status_check

    systemctl restart shipping
  fi

}

systemd() {
  cp ${script_location}/files/${component}-conf /etc/systemd/system/${component}.service &>>${LOG}

    systemctl daemon-reload &>>${LOG}

    print_head "Starting Service"
    systemctl enable ${component} &>>${LOG}
    systemctl start ${component} &>>${LOG}
    status_check
}

nodejs() {
  print_head "Downloading Node Repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
  status_check

  print_head "Install Nodejs"
  yum install nodejs -y &>>${LOG}
  status_check

  App_Prereq

  print_head "Installing Dependencies"
  npm install &>>${LOG}
  status_check

  systemd

  schema_load

}

Maven() {
  print_head "Install Maven"
  yum install maven -y &>>${LOG}
  status_check

  App_Prereq

  cd /app
  mvn clean package
  mv target/shipping-1.0.jar shipping.jar

  systemd

  schema_load

}