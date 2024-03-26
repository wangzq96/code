# -*- coding: utf-8 -*-
#python3.9.0
from bs4 import BeautifulSoup
import requests
import sys

class downloader(object):
     #类说明下载笔趣阁天才小侯爷，self只有再类的方法中才会有
     #独立的函数或方法是不必带有self的，self再定义类的方法时是必须有的
     #虽然在调用时不必传入相应的参数
    
     def __init__(self): #初始化变量
        #爬取图书地址.self.server='http://www.qq1986.com/'的意思
        #就是把外部传来的参数server的值赋值给类downloader自己的属性
        #变量self.server下边函数可共用
         self.server = 'http://www.qq1986.com/'
         self.target = 'http://www.qq1986.com/class/72786/'
        # https://558411d2.kmrrnxhmj.com/aff-jMy3P # 仅供学习
        #爬取图书主目录所在网址，用来获取每一章节的url
         self.names = [] #存放章节名
         self.urls = []  #存放章节连接
         self.nums = 0   #章节数
          
     def get_download_url(self): #获取下载链接
         req = requests.get(url=self.target)  #获取该网页的html信息
         html = req.content                   #获得html文件
         html_doc = str(html,'gbk')
         div_bf = BeautifulSoup(html_doc)       #创建一个BeautifulSoup对象
         div = div_bf.find_all('div',id="list")
        #匹配div标签，获取id属性list的内容，用find_all是因为获得的是列表
         a_bf = BeautifulSoup(str(div[0]))  #以list中的内容构建Beautiful对象
         a = a_bf.find_all('a')           #找到所有a标签，a标签中为每一张网址
         self.nums = len(a[:])            #索引从第一章到最后一张，记数
         for each in a[:]:
             self.names.append(each.string)    #添加a标签下的字符串即章节名
             self.urls.append(self.server + each.get('href'))
         #获取每一章链接，用get（）方法获取a标签中的href属性

     def get_contents(self,target):     #获取章节内容
         req = requests.get(url=target)
         html = req.content
         html_doc = str(html,'gbk')
         bf = BeautifulSoup(html_doc) 
         texts = bf.find_all('div',id="content")
        #获取企业duv不爱全部ud上个月虚报个cibtebt的内容
         texts = texts[0].text.replace('\xa0'*8,'\n')
         #剔除"'div'标签及'id=content'"和br/
         #提取texts内容中text文本
         return texts

     def writer(self,name,path,text):    #将爬取的文章内容写入到文件
         with open(path,'a',encoding='utf-8')as f:
          #‘a’表示追加到文件，encoding=utf-8表示以utf-8进行编码
             f.write(name + '\n')    #write发放写入章节名并换行
             f.writelines(text)      #witelines方法写入文章内容
             f.write('\n')           #换行写完一章

#当.py文件被执行运行时，if__name__== '__main__'之下的代码块将被运行
if __name__=='__main__':
    dl = downloader()
    dl.get_download_url()
    print('《天才小侯爷》开始下载：')
    for i in range(dl.nums):
        dl.writer(dl.names[i], '天才小侯爷.txt', dl.get_contents(dl.urls[i]))
        sys.stdout.write(" 已下载:%.3f%%" % float(i / dl.nums) + '\r')
        #sys.stdout是映射到打开脚本的串口
        sys.stdout.flush()
        #linux系统下，必须加入sys.stdout.flush()才能一秒输一个数字
        #windwos系统下，加不加sys.stdout.flush()都能一秒输一个数字
    print('《天才小侯爷》下载完成')
