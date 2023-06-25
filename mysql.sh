source common.sh

if [ -z "${set_root_password}" ]; then
  echo "Please Enter Password"
fi

print_head "Disable Repo"
yum module disable mysql -y &>>${LOG}
status_check

print_head "Install Mysql"
yum install mysql-community-server -y &>>${LOG}
status_check

print_head "Starting Service"
systemctl enable mysqld &>>${LOG}
systemctl start mysqld &>>${LOG}
status_check

print_head "Setting up Password"
mysql_secure_installation --set-root-pass ${set_root_password} &>>${LOG}
status_check