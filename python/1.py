# -*- coding: utf-8 -*-
from bs4 import BeautifulSoup
import requests
import sys

class downloader(object):
     def __init__(self):
         self.server = 'http://www.qq1986.com/'
         self.target = 'http://www.qq1986.com/class/72786/'
         self.names = []
         self.urls = []
         self.nums = 0
     def get_download_url(self):
         req = requests.get(url=self.target)
         html = req.content
         html_doc = str(html,'gbk')
         div_bf = BeautifulSoup(html_doc)
         div = div_bf.find_all('div',id="list")
         a_bf = BeautifulSoup(str(div[0]))
         a = a_bf.find_all('a')
         self.nums = len(a[:])
         for each in a[:]:
             self.names.append(each.string)
             self.urls.append(self.server + each.get('href'))

     def get_contents(self,target):
         req = requests.get(url=target)
         html = req.content
         html_doc = str(html,'gbk')
         bf = BeautifulSoup(html_doc) 
         texts = bf.find_all('div',id="content")
         texts = texts[0].text.replace('\xa0'*8,'\n')
         return texts

     def writer(self,name,path,text):
         with open(path,'a',encoding='utf-8')as f:
             f.write(name + '\n')
             f.writelines(text)
             f.write('\n')
          
if __name__=='__main__':
    dl = downloader()
    dl.get_download_url()
    print('《xhy》开始下载：')
    for i in range(dl.nums):
        dl.writer(dl.names[i], 'xhy.txt', dl.get_contents(dl.urls[i]))
        sys.stdout.write(" 已下载:%.3f%%" % float(i / dl.nums) + '\r')
        sys.stdout.flush()
    print('《xhy》下载完成')
