source common.sh

print_head "Install Nginx"
yum install nginx -y &>>${LOG}
status_check

print_head "enable Service"
systemctl enable nginx &>>${LOG}
status_check

print_head "start service"
systemctl start nginx &>>${LOG}
status_check

print_head "removing Default content"
rm -rf /usr/share/nginx/html/* &>>${LOG}
status_check

print_head "Extracting Content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
status_check

cd /usr/share/nginx/html &>>${LOG}
unzip /tmp/frontend.zip &>>${LOG}

${script_location}/files/frontend-conf /etc/nginx/default.d/roboshop.conf
