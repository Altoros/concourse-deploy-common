
function chech_error() {
  $ERROR_MESSAGE=$1
  if [ $? != 0 ];
  then
      echo $ERROR_MESSAGE
  fi
}


