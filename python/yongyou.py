#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time : 2021/9/8 16:52
# @Time : 2021/7/9 11:23
# @Time : 2022/10/36 11:00

from HTMLTable import (HTMLTable,)
from email.mime.multipart import MIMEMultipart

import paramiko
from clickhouse_driver import Client, connect
import smtplib
import string
import json
import requests
import time
import datetime
import prettytable as pt
from ntpath import join
from email.header import Header
from aliyunsdkcore import client
from email.mime.text import MIMEText
from aliyunsdkcore.request import CommonRequest
from aliyunsdkecs.request.v20140526 import DescribeInstancesRequest
from aliyunsdkcore.acs_exception.exceptions import ClientException
from aliyunsdkcore.acs_exception.exceptions import ServerException
from aliyunsdkcms.request.v20190101.DescribeMetricTopRequest import DescribeMetricTopRequest
from aliyunsdkr_kvstore.request.v20150101.DescribeInstancesRequest import \
    DescribeInstancesRequest as DescribeInstancesRequest2
from aliyunsdkdts.request.v20200101.DescribeDtsJobsRequest import DescribeDtsJobsRequest
from aliyunsdkr_kvstore.request.v20150101.DescribeInstanceAttributeRequest import DescribeInstanceAttributeRequest

# 阿里云认证
clt = client.AcsClient('LTAI5tHTa19zY7uHHWfUhaLy','U7g30G9PWkdJPLAPn6qDLwjvf0nV4U', 'cn-chengdu')
# 用友
# LTAI5tHTa19zY7uHHWfUhaLy
# U7g30G9PWkdJPLAPn6qDLwjvf0nV4U

# 脚本所需参数
# 设置页数
page_number = '1'
# 设置每页返回多少，默认为10条
strip_number = '100'
# ECS到期时间范围单位是‘天’
expire_days = '7'
# 云服务的数据命名空间(磁盘使用率那进行调用)
ecs_namespace = 'acs_ecs_dashboard'
# 云服务(ECS)的监控项名称
Disk_metricname = 'vm.DiskUtilization'  # 磁盘
Mem_metricname = 'vm.MemoryUtilization'  # 内存
CPU_metricname = 'cpu_total'  # CPU
# 磁盘使用率阀值(%)
Disk_use_rate = '70'
# 内存使用率阀值(%)
Mem_user_rate = '70'
# CPU使用率阀值(%)
Cpu_user_rate = '70'
str_time = "%s-%s-%s" % (datetime.datetime.now().year,
                         datetime.datetime.now().month, datetime.datetime.now().day)
time_mail = time.strftime('%Y%m%d%H%M%S ', time.localtime(time.time()))
# 发送邮件相关信息
sender = 'patrol-alarm@icbf.com.cn'

receiver = 'wangzq@icbf.com.cn','yangyang@icbf.com.cn'
# receiver = 'wangzq@icbf.com.cn','yangyang@icbf.com.cn'

subject = '%s运维巡检表' % (str_time)
username = 'patrol-alarm@icbf.com.cn'
password = 'cbf123456.'

'''
采样范围太大就会提示
{"status":"error","errorType":"execution",
"error":"query processing would load too many samples into memory in query execution"}
'''

# 生成表格
def form(column_name, field_information, title):
    table = HTMLTable(caption='')
    table.append_header_rows(((column_name),))
    for field in field_information:
        table.append_data_rows(((field),))
    # 表格样式，即<table>标签样式
    table.set_style({
        'border-collapse': 'collapse',
        'word-break': 'keep-all',
        'white-space': 'nowrap',
        'font-size': '14px',
        'margin-left': '30px',
        'text-align': 'center',
    })
    # 统一设置所有单元格样式，<td>或<th>
    table.set_cell_style({
        'border-color': '#000',
        'border-width': '1px',
        'border-style': 'solid',
        'padding': '5px',
    })
    # 表头样式
    table.set_header_row_style({
        'color': '#fff',
        'background-color': '#48a6fb',
        'font-size': '18px',
    })

    # 覆盖表头单元格字体样式
    table.set_header_cell_style({
        'padding': '15px',
    })
    html = table.to_html()
    html = '<h3 style="color:red;margin-left: 30px" > %s </h3>' % (
        title) + html
    return html

# 把巡检信息进行html格式化
def html_formatting( Aliyun_html):
    html_text = """
<!DOCTYPE html>
<html lang="en">
<head>
    <title></title>
    <meta charset="utf-8">
</head>
<body>
    <div class="page" style="margin-left: 20px">
        <h1> {time_mail} 巡检结果如下 </h1>
        <h2 style="color:blue;margin-left: 15px"> 阿里云 </h2>
        {Aliyun_html}
        </div>
    </div>
</body>
</html>
""".format(
        time_mail=str_time,
        Aliyun_html=Aliyun_html,
    )
    msge = html_text
    return msge



# 列表---ECS列表
def get_sys_info():
    request = DescribeInstancesRequest.DescribeInstancesRequest()
    # request.set_PageNumber('page_number')   #设置页数
    request.set_PageSize(strip_number)  # 设置每页返回多少，默认为10条
    request.set_accept_format('json')
    response = json.loads(clt.do_action(request)).get(
        'Instances').get('Instance')
    return response

# ECS 5天内到期时间
def ecs_five_endtime():
    field_information = []
    count = 0
    for i in get_sys_info():
        # 阿里云UTC时间转换成北京时间
        ecs_endtime_0 = i['ExpiredTime']
        ecs_endtime_1 = "%Y-%m-%dT%H:%MZ"
        ecs_endtime_2 = datetime.datetime.strptime(
            ecs_endtime_0, ecs_endtime_1)
        ecs_endtime_3 = ecs_endtime_2 + \
            datetime.timedelta(hours=8) - datetime.timedelta(seconds=1)
        ecs_endtime_4 = ecs_endtime_3.strftime('%Y-%m-%d')
        # 计算到期时间与现在时间之差
        current_time = time.strftime("%Y-%m-%d", time.localtime())
        current = time.mktime(time.strptime(current_time, '%Y-%m-%d'))
        ecs_endtime_5 = time.mktime(time.strptime(ecs_endtime_4, '%Y-%m-%d'))
        count_days = int((ecs_endtime_5 - current) / (24 * 60 * 60))

        # 距离到期时间小于天数
        if count_days <= int(expire_days):
            count = count + 1
            ecs_remarks = i['InstanceId'], i['InstanceName']
            ecs_IP_0 = i['VpcAttributes']
            ecs_IP_1 = ecs_IP_0["PrivateIpAddress"]["IpAddress"][0]
            field = count, list(ecs_remarks)[0], ecs_IP_1, ecs_endtime_3.strftime(
                '%Y年%m月%d日 %H:%M'), list(ecs_remarks)[1]
        #    print(field)
            field_information.append(field)

    title = 'ECS到期时间(%s天内)' % (expire_days)
    column_name = ["序号", "实例ID", "IP地址", "到期时间", "备注"]
    html_table = form(column_name=column_name, title=title,
                      field_information=field_information)
    return html_table

# ECS磁盘使用率
def disk_info():
    request = DescribeMetricTopRequest()
    request.set_accept_format('json')
    request.set_Namespace(ecs_namespace)
    request.set_MetricName(Disk_metricname)
    request.set_Orderby("Average")
    request.set_Length(strip_number)
    response_0 = clt.do_action_with_exception(request)
    response_1 = str(response_0, encoding='utf-8')
    return response_1

# 列出超出磁盘阈值的ECS信息
def get_disk_Value():
    field_information = []
    count = 0
    Slicing_0 = eval(str(disk_info()))
    Slicing_1 = Slicing_0["Datapoints"]
    Slicing_2 = eval(Slicing_1)
    for Slicing_3 in Slicing_2:
        if Slicing_3.get("Average") >= float(Disk_use_rate):
            for ecs_id_0 in get_sys_info():
                if Slicing_3.get("instanceId") == ecs_id_0['InstanceId']:
                    count += 1
                    ecs_remarks = ecs_id_0['InstanceId'], ecs_id_0['InstanceName']
                    ecs_IP_0 = ecs_id_0['VpcAttributes']
                    ecs_IP_1 = ecs_IP_0["PrivateIpAddress"]["IpAddress"][0]
                    field = count, Slicing_3.get("instanceId"), ecs_IP_1, Slicing_3.get(
                        "mountpoint"), Slicing_3.get("Maximum"), list(ecs_remarks)[1]
                    field_information.append(field)

    title = 'ECS磁盘使用率大于%s' % (Disk_use_rate)
    column_name = ["序号", "实例ID", "IP地址", "目录", "使用率(%)", "备注"]
    html_table = form(column_name=column_name, title=title,
                      field_information=field_information)
    return html_table

# ECS-CPU使用率
def CPU_info():
    request = DescribeMetricTopRequest()
    request.set_accept_format('json')
    request.set_Namespace(ecs_namespace)
    request.set_MetricName(CPU_metricname)
    request.set_Orderby("Average")
    request.set_Length(strip_number)
    response_0 = clt.do_action_with_exception(request)
    response_1 = str(response_0, encoding='utf-8')
    return response_1

# 列出超出CPU阈值的ECS信息
def get_CPU_Value():
    count = 0
    field_information = []
    Slicing_0 = eval(str(CPU_info()))
    Slicing_1 = Slicing_0["Datapoints"]
    Slicing_2 = eval(Slicing_1)
    for Slicing_3 in Slicing_2:
        if Slicing_3.get("Average") >= float(Cpu_user_rate):
            for ecs_id_0 in get_sys_info():
                if Slicing_3.get("instanceId") == ecs_id_0['InstanceId']:
                    ecs_remarks = ecs_id_0['InstanceId'], ecs_id_0['InstanceName']
                    ecs_IP_0 = ecs_id_0['VpcAttributes']
                    ecs_IP_1 = ecs_IP_0["PrivateIpAddress"]["IpAddress"][0]
                    count += 1
            field = count, Slicing_3.get("instanceId"), ecs_IP_1, Slicing_3.get(
                "Maximum"), list(ecs_remarks)[1]
            field_information.append(field)

    title = 'ECS-CPU使用率大于%s' % (Cpu_user_rate)
    column_name = ["序号", "实例ID", "IP地址", "使用率(%)", "备注"]
    html_table = form(column_name=column_name, title=title,
                      field_information=field_information)
    return html_table

# ECS内存使用率
def Member_info():
    request = DescribeMetricTopRequest()
    request.set_accept_format('json')
    request.set_Namespace(ecs_namespace)
    request.set_MetricName(Mem_metricname)
    request.set_Orderby("Average")
    request.set_Length(strip_number)
    response_0 = clt.do_action_with_exception(request)
    response_1 = str(response_0, encoding='utf-8')
    return response_1

# 列出超出内存阈值的ECS信息
def get_Member_Value():
    count = 0
    field_information = []
    Slicing_0 = eval(str(Member_info()))
    Slicing_1 = Slicing_0["Datapoints"]
    Slicing_2 = eval(Slicing_1)
    for Slicing_3 in Slicing_2:
        if Slicing_3.get("Average") >= float(Mem_user_rate):
            for ecs_id_0 in get_sys_info():
                if Slicing_3.get("instanceId") == ecs_id_0['InstanceId']:
                    ecs_remarks = ecs_id_0['InstanceId'], ecs_id_0['InstanceName']
                    ecs_IP_0 = ecs_id_0['VpcAttributes']
                    ecs_IP_1 = ecs_IP_0["PrivateIpAddress"]["IpAddress"][0]
                    count += 1
            field = count, Slicing_3.get("instanceId"), ecs_IP_1, Slicing_3.get(
                "Maximum"), list(ecs_remarks)[1]
            field_information.append(field)

    title = 'ECS内存使用率大于%s' % (Mem_user_rate)
    column_name = ["序号", "实例ID", "IP地址", "使用率(%)", "备注"]
    html_table = form(column_name=column_name, title=title,
                      field_information=field_information)
    return html_table

# 列表---RDS实例列表
def get_rds_info():
    request = CommonRequest()
    request.set_accept_format('json')
    request.set_domain('rds.aliyuncs.com')
    request.set_method('POST')
    request.set_protocol_type('https')  # https | http
    request.set_version('2014-08-15')
    request.set_action_name('DescribeDBInstances')
    request.add_query_param('RegionId', "cn-beijing")
    request.add_query_param('PageSize', strip_number)  # 条数
    # request.add_query_param('PageNumber', page_number) ###页码
    response = clt.do_action(request)
    false = 0
    rds_list_0 = eval(str(response, encoding='utf-8'))
    rds_list_1 = rds_list_0["Items"]["DBInstance"]
    return rds_list_1

# 列出RDS到期时间
def rds_endtime():
    field_information = []
    count = 0
    for i in get_rds_info():
        # 阿里云UTC时间转换成北京时间
        rds_endtime_0 = i['ExpireTime']
        rds_endtime_1 = "%Y-%m-%dT%H:%M:%SZ"
        rds_endtime_2 = datetime.datetime.strptime(
            rds_endtime_0, rds_endtime_1)
        rds_endtime_3 = rds_endtime_2 + \
            datetime.timedelta(hours=8) - datetime.timedelta(seconds=1)
        rds_endtime_4 = rds_endtime_3.strftime('%Y-%m-%d')
        # 计算到期时间与现在时间之差
        current_time = time.strftime("%Y-%m-%d", time.localtime())
        current = time.mktime(time.strptime(current_time, '%Y-%m-%d'))
        rds_endtime_5 = time.mktime(time.strptime(rds_endtime_4, '%Y-%m-%d'))
        count_days = int((rds_endtime_5 - current) / (24 * 60 * 60))

        # 距离到期时间小于天数
        if count_days <= int(expire_days):
            count = count + 1
            field = count, i["DBInstanceId"], rds_endtime_3.strftime(
                '%Y年%m月%d日 %H:%M'), i["DBInstanceDescription"]
            field_information.append(field)

    title = 'RDS到期时间(%s天内)' % (expire_days)
    column_name = ["序号", "实例ID", "到期时间", "备注"]
    html_table = form(column_name=column_name, title=title,
                      field_information=field_information)
    return html_table

# 列出RDS磁盘使用率
def rds_disk_info():
    request = DescribeMetricTopRequest()
    request.set_accept_format('json')
    request.set_MetricName("DiskUsage")
    request.set_Namespace("acs_rds_dashboard")
    request.set_Orderby("Average")
    request.set_Length(strip_number)
    response_0 = clt.do_action_with_exception(request)
    response_1 = str(response_0, encoding='utf-8')
    return response_1

# 列出RDS超出阀值的资源
def rds_disk_threshold():
    count = 0
    field_information = []

    rds_threshold_0 = eval(rds_disk_info())
    rds_threshold_1 = eval(rds_threshold_0["Datapoints"])
    for rds_threshold_3 in rds_threshold_1:
        if rds_threshold_3["Average"] >= float(Disk_use_rate):
            for rds_id_0 in get_rds_info():
                if rds_id_0["DBInstanceId"] == 'rm-2ze3bzdt0ej4za0t6':
                    break
                if rds_threshold_3["instanceId"] == rds_id_0["DBInstanceId"]:
                    count += 1
                    field = count, rds_threshold_3["instanceId"], rds_id_0[
                        "DBInstanceDescription"], rds_threshold_3["Average"]
                    field_information.append(field)

    title = 'RDS-磁盘使用率大于70%'
    column_name = ["序号", "实例ID", "备注", "使用率(%)"]
    html_table = form(column_name=column_name, title=title,
                      field_information=field_information)
    return html_table

# 列出redis实例列表
def get_redis_info():
    request = DescribeInstancesRequest2()
    request.set_accept_format('json')
    request.set_PageNumber(page_number)  # 页码
    request.set_PageSize(strip_number)  # 条数
    response_0 = clt.do_action_with_exception(request)
    false = true = 0
    response_1 = eval(str(response_0, encoding='utf-8'))
    response_2 = response_1["Instances"]["KVStoreInstance"]
    return response_2

# Redis到期时间
def redis_endtime():
    field_information = []
    count = 0
  
    for i in get_redis_info():
        # 阿里云UTC时间转换成北京时间
        # if i.get('UserName') == 'r-2vcik2bo8gzn07yri9':
        redis_endtime_0 = i['EndTime']
        redis_endtime_1 = "%Y-%m-%dT%H:%M:%SZ"
        redis_endtime_2 = datetime.datetime.strptime(
            redis_endtime_0, redis_endtime_1)
        redis_endtime_3 = redis_endtime_2 + datetime.timedelta(hours=8)
        redis_endtime_4 = redis_endtime_3.strftime('%Y-%m-%d')
        # 计算到期时间与现在时间之差
        current_time = time.strftime("%Y-%m-%d", time.localtime())
        current = time.mktime(time.strptime(current_time, '%Y-%m-%d'))
        redis_endtime_5 = time.mktime(
            time.strptime(redis_endtime_4, '%Y-%m-%d'))
        count_days = int((redis_endtime_5 - current) / (24 * 60 * 60))

        # 距离到期时间小于天数
        if count_days <= int(expire_days):
            count = count + 1
            field = [count, i["InstanceId"], redis_endtime_3.strftime(
                '%Y年%m月%d日 %H:%M'), i["InstanceName"]]
            field_information.append(field)

    title = 'Redis到期时间(%s天内)' %(expire_days)
    column_name = ["序号", "实例ID", "到期时间", "备注"]
    html_table = form(column_name=column_name, title=title,
                      field_information=field_information)
    return html_table

# 邮件
def send_mail(email_html):
    msg = MIMEMultipart()
    msg['Subject'] = Header(subject, 'utf-8')
    msg['From'] = Header('patrol-alarm@icbf.com.cn', 'utf-8')  # 发送者
    msg['To'] = Header('运维组', 'utf-8')
    msg.attach(MIMEText(email_html, 'html', 'utf-8'))
    smtp = smtplib.SMTP()
    smtp.connect('smtp.qiye.aliyun.com')
    smtp.login(username, password)
    for mailuser in receiver:
        smtp.sendmail(sender, mailuser, msg.as_string())
    print("邮件发送成功")
    smtp.quit()

# 执行
if __name__ == '__main__':
    # 到期时间 ETC_endtime() + redis_endtime() + rds_endtime() + ecs_five_endtime()
    # 磁盘阀值类： rds_disk_threshold() + get_disk_Value()
    # CPU&内存类：get_CPU_Value() + get_Member_Value()
    print(redis_endtime())
    # html = html_formatting(
    #     Aliyun_html=get_disk_Value() +
    #     rds_disk_threshold() +
    #     rds_endtime() +
    #     ecs_five_endtime() +
    #     get_CPU_Value() +
    #     get_Member_Value() +
    #     redis_endtime()
    # )
    
    # send_mail(email_html=html)
