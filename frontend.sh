script_location=$(pwd)
LOG=/tmp/roboshop.log

echo -e "\e[31m Install nginx \e[0m"
yum install nginx -y &>>${LOG}
if [ $? -eq 0 ]; then
  echo -e "\e[32mSUCCESS\e[0m"
else
  echo -e "\e[33mFAILURE\e[0m"
  echo "Please Refer log for more info -${LOG}"
exit1
fi

systemctl enable nginx &>>${LOG}
systemctl start nginx &>>${LOG}

rm -rf /usr/share/nginx/html/* &>>${LOG}

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}

cd /usr/share/nginx/html &>>${LOG}
unzip /tmp/frontend.zip &>>${LOG}

