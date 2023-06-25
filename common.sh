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