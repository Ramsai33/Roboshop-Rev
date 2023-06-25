source common.sh

print_head "Downloading Node Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

print_head "Install Nodejs"
yum install nodejs -y &>>${LOG}
status_check

print_head "Useradd"
id roboshop &>>${LOG}
if [ $? -ne 0 ]; then
  useradd roboshop &>>${LOG}
  status_check
fi

mkdir /app &>>${LOG}

print_head "Downloadinga and Extracting App content"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
cd /app
unzip /tmp/catalogue.zip &>>${LOG}
status_check

cd /app

print_head "Installing Dependencies"
npm install &>>${LOG}
status_check

cp ${script_location}/files/catalogue-conf /etc/systemd/system/catalogue.service &>>${LOG}

systemctl daemon-reload &>>${LOG}

print_head "Starting Service"
systemctl enable catalogue &>>${LOG}
systemctl start catalogue &>>${LOG}
status_check

cp ${script_location}/files/mongoclient /etc/yum.repos.d/mongo.repo &>>${LOG}

print_head "Installing Mongoclient"
yum install mongodb-org-shell -y &>>${LOG}
status_check

mongo --host 172.31.84.182 </app/schema/catalogue.js &>>${LOG}