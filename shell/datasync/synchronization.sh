#!/bin/bash
[  -z $1 ] && echo "no 参数 退出"&& exit
[  -z $2 ] && echo "no 参数 退出"&& exit
compress=$1
Province=$2
dataBase=$3
cataLog=/data/deploy/backshell/province.txt
wgetURL=http://ftp01.ops01.sllhtv.com:50080/mysql/
dataUser=`grep "$2" "$cataLog" | awk '{print $2}'`
dataIP=`grep "$2" "$cataLog" | awk '{print $3}'`
dataPORT=`grep "$2" "$cataLog" | awk '{print $4}'`
dataHost=`grep "$2" "$cataLog" | awk '{print $5}'`
mysqlPort=`grep "$2" "$cataLog" | awk '{print $6}'`


if [ "$Province" == guangdong ]
then
    #ssh "$dataUser"@"$dataIP" -p "$dataPORT" "ssh "$dataHost" -p "$mysqlPort" "hostname""
    #广东
    ssh "$dataUser"@"$dataIP" -p "$dataPORT" "ssh "$dataHost" -p "$mysqlPort" "wget -P /data/ "$wgetURL""$compress"""
    ssh "$dataUser"@"$dataIP" -p "$dataPORT" "ssh "$dataHost" -p "$mysqlPort" sudo sh -x /data/script/recovery/recoveryDate.sh "$compress" "$dataBase""    
elif [ "$Province" == nmg ]
then
    #ssh "$dataUser"@"$dataIP" -p "$dataPORT" "ssh "$dataHost" -p "$mysqlPort" "hostname""
    #内蒙古
    ssh "$dataUser"@"$dataIP" -p "$dataPORT" "sudo wget -P /data/html/ "$wgetURL""$compress""
    ssh "$dataUser"@"$dataIP" -p "$dataPORT" "sudo chmod 755 /data/html/"$compress""
    ssh "$dataUser"@"$dataIP" -p "$dataPORT" "ssh "$dataHost" -p "$mysqlPort" "sudo wget -P /data/ 10.221.181.222:50040/"$compress"""""
    ssh "$dataUser"@"$dataIP" -p "$dataPORT" "ssh "$dataHost" -p "$mysqlPort" sudo sh -x /data/script/recovery/recoveryDate.sh "$compress" "$dataBase"" 
elif [ "$Province" == yunnan ]
then
    #ssh "$dataUser"@"$dataIP" -p "$dataPORT" "ssh "$dataHost" -p "$mysqlPort" "hostname""
    #云南
    ssh "$dataUser"@"$dataIP" -p "$dataPORT" "sudo wget -P /data/ "$wgetURL""$compress""
    ssh "$dataUser"@"$dataIP" -p "$dataPORT" "scp -P"$mysqlPort" /data/"$compress" "$dataHost":/tmp/"
    ssh "$dataUser"@"$dataIP" -p "$dataPORT" "ssh "$dataHost" -p "$mysqlPort" "sudo mv /tmp/"$compress" /data/""
    ssh "$dataUser"@"$dataIP" -p "$dataPORT" "ssh "$dataHost" -p "$mysqlPort" sudo sh -x /data/script/recovery/recoveryDate.sh "$compress" "$dataBase""
elif [ "$Province" == henan ]
then
    #ssh "$dataUser"@"$dataIP" -p "$dataPORT" "ssh "$dataHost" -p "$mysqlPort" "hostname""
    #河南
    ssh "$dataUser"@"$dataIP" -p "$dataPORT" "ssh "$dataHost" -p "$mysqlPort" "wget -P /data/ "$wgetURL""$compress"""
    ssh "$dataUser"@"$dataIP" -p "$dataPORT" "ssh "$dataHost" -p "$mysqlPort" sudo sh -x /data/script/recovery/recoveryDate.sh "$compress" "$dataBase""
elif [ "$Province" == tianjin ]
then
    #ssh "$dataUser"@"$dataIP" -p "$dataPORT" "ssh "$dataHost" -p "$mysqlPort" "hostname""
    #天津
    ssh "$dataUser"@"$dataIP" -p "$dataPORT" "ssh "$dataHost" -p "$mysqlPort" "wget -P /home/ "$wgetURL""$compress"""
    ssh "$dataUser"@"$dataIP" -p "$dataPORT" "ssh "$dataHost" -p "$mysqlPort" sudo sh -x /data/script/recovery/recoveryDate.sh "$compress" "$dataBase""
elif [ "$Province" == zq-10.65 ]
then
    #ssh "$dataUser"@"$dataIP" -p "$dataPORT" "ssh "$dataHost" -p "$mysqlPort" "hostname""
    #政企mysql2-192.168.10.65
    ssh "$dataUser"@"$dataIP" -p "$dataPORT" "ssh "$dataHost" -p "$mysqlPort" "sudo wget -P /data/ "$wgetURL""$compress"""
    ssh "$dataUser"@"$dataIP" -p "$dataPORT" "ssh "$dataHost" -p "$mysqlPort" sudo sh -x /data/script/recovery/recoveryDate.sh "$compress" "$dataBase""
elif [ "$Province" == zq-10.56 ]
then
    #ssh "$dataUser"@"$dataIP" -p "$dataPORT" "ssh "$dataHost" -p "$mysqlPort" "hostname""
    #政企mysqlslave-192.168.10.56
    ssh "$dataUser"@"$dataIP" -p "$dataPORT" "ssh "$dataHost" -p "$mysqlPort" "sudo wget -P /data/ "$wgetURL""$compress"""
    ssh "$dataUser"@"$dataIP" -p "$dataPORT" "ssh "$dataHost" -p "$mysqlPort" sudo sh -x /data/script/recovery/recoveryDate.sh "$compress" "$dataBase""
fi