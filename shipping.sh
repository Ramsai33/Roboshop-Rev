source common.sh

if [ -z "${set_root_password}" ];then
  echo "Please enter password"
fi

component=shipping

schema_load=true

schema_type=mysql

Maven