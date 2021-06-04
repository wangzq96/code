#!/bin/bash
Host='/root/1.txt'
##1.txt里边放的IP地址
for i in $(cat $Host)
do
     expect  -c "
            spawn ssh root@$i
            expect {
                 "\(yes/no\)\?" {send \"yes \r\"; exp_continue}
                  \"password:\" {send \"ZMe%Rha4Gi\r\"; exp_continue}
                  \"root@*\" {send \"useradd sl_zq && echo 'uMBnRn*#Zp' | passwd --stdin sl_zq &> /dev/null && echo 'sl_zq  ALL=(ALL)    NOPASSWD: ALL' >> /etc/sudoers\r exit\r\" ; exp_continue}
        }
      "
done

#'#!/bin/bash'
#Host='/root/1.txt'
#for i in $(cat $Host)
#do
#     expect -c "
#            spawn ssh root@$i
#            expect {
#                 \"password:\" {send \"ZMe%Rha4Gi\r\"; exp_continue}
#                 \"root@*\" {send \"chage -M 9999 oma\r exit\r\"; exp_continue}
#            }
#     "
#echo "----------------------------------------------------------------------------------------------------"$i""
#done
