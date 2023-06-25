source common.sh

print_head "Coping Repo"
cp ${script_location}/files/mongorepo /etc/yum.repos.d/mongo.repo &>>${LOG}
status_check

print_head "Mongodb"
yum install mongodb-org -y &>>${LOG}
status_check

print_head "starting Service"
systemctl enable mongod &>>${LOG}
systemctl start mongod &>>${LOG}
status_check

print_head "Changing Port"
sed -i -e 's/127.0.0.1/0.0.0.0/gi' /etc/mongod.conf &>>${LOG}
status_check

systemctl restart mongod &>>${LOG}