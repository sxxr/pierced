# export adbshell="docker exec adbd adb shell "
# dingactivity="com.alibaba.android.rimet/.biz.SplashActivity"
adbshell="adb shell "
dingactivity="com.alibaba.android.rimet/.biz.LaunchHomeActivity"

#$1 $2 是取值范围
function rnd2() {
  if [ -z "$RANDOM" ] ; then
    SEED=`tr -cd 0-9 </dev/urandom | head -c 8`
  else
    SEED=$RANDOM
  fi

  RND_NUM=`echo $SEED $1 $2|awk '{srand($1);printf "%d",rand()*10000%($3-$2)+$2}'`
  echo $RND_NUM
}


function checktoday_morning() {
  checktoday morningtriger
}
function checktoday_afternoon() {
  checktoday afternoontriger
}

function checktoday() {
  ls *.$1|grep -v $today|awk '{print "rm "$1}'|sh
  
  if [ ! -f $today.$1 ]; then
    randminute=`rnd2 30 40`
    echo $randminute>$today.$1
  # else
  #   echo 'exist, exit'
  fi

  trigermin=`cat $today.$1`
  # nowmin=`date +%M`
  # nowmin=80
  if [ $nowmin -gt $trigermin ]; then 
    echo $nowmin ' gt ' $trigermin
    callding
  else 
    echo $nowmin ' eq or less ' $trigermin
  fi    
}

function callding(){
  $adbshell am start -n $dingactivity
}

export today=`date +%Y%m%d`
# echo $today
# rm $today.morningtriger
# rm $today.afternoontriger

nowmin=`date +%M`
hourmin=`date +%H" "%M|awk '{ printf "%d", $1*60+$2}'`
afternoonhourmin=`echo 14 00 | awk '{printf "%d", $1*60+$2}'`

# echo $hourmin   $afternoonhourmin
if [ $nowmin -lt ${afternoonhourmin} ]; then
  echo morning
  checktoday_morning
else
  echo afternoon
  checktoday_afternoon
fi


# # cat $today.morningtriger
# # cat $today.afternoontriger

# morningtriger=`cat $today.morningtriger`
# afternoontriger=`cat $today.afternoontriger`
# nowmin=`date +%M`
# nowmin=80
# echo $nowmin
# if [ $nowmin -gt $morningtriger ]; then 
#   echo $nowmin ' gt ' $morningtriger
# else 
#   echo $nowmin ' eq or less ' $morningtriger
# fi