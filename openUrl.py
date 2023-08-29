# -*- coding:utf-8 -*-


# import json
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.common.exceptions import NoSuchElementException
# from selenium.webdriver.chrome.service import Service
import time
import requests
# from base64 import b64decode
# import cv2
# import pyautogui
# pip install Pillow
# from PIL import Image
# from selenium.webdriver import ActionChains
# from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.wait import WebDriverWait
import os




# http://chromedriver.storage.googleapis.com/index.html
# https://registry.npmmirror.com/binary.html?path=chromedriver/
# https://mydown.yesky.com/pcsoft/105582038/versions/
# http://chrome-downs.fatcarter.cn/chrome/mac/x64/stable
# https://www.chromedownloads.net/chrome64osx-stable/
# chrome://plugins
# chrome://flags
# chrome://version
# /usr/local/bin/chromedriver

class openUrl():
    _url = ''
    def __init__(self) -> None:
        self._url = 'https://vcf.jd.com/sub_finance/settlement/search'
        self._url = 'http://chromedriver.storage.googleapis.com/index.html'
        self.headless = 0


    def start_chrome(self):
        """启动chrome浏览器"""
        # service = Service(executable_path=r"C:\Program Files (x86)\Google\Chrome\Application\chromedriver.exe")
        # service = Service(executable_path=r"./chromedriver_109.0.5414")

        # driver = webdriver.Chrome()
        option = webdriver.ChromeOptions()
        # 无界面模式
        # if self.headless == 1 :
        if self.isHeadless() :
            option.add_argument('--headless')

        # 设置下载路径
        path = self.get_path_parent_dir()
        # 每月一个
        dt = time.strftime("%Y-%m", time.localtime())
        # new_path = path + '/public/excel' + '/' + dt + '/1' + '/a'
        # defaultDirectory = path + '\public\excel' + '\\' + dt + '\\' + self.memo_type_obj[self.classTitle] + '\\' + self.account_item['filepath']
        tmpDirList = [
            path,
            'excel',
            dt,
        ]
        defaultDirectory = os.path.join(*tmpDirList)
        self.mkdir(path=defaultDirectory)
        self.removeFiles(defaultDirectory)
        self.download_path = defaultDirectory

        # prefs = {"download.default_directory" : defaultDirectory}
        # option.add_experimental_option("prefs",prefs)
        option.add_argument("--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) "
                    "Chrome/104.0.0.0 Safari/537.36")
        # 忽略SSL证书错误问题
        option.add_argument('--ignore-certificate-errors')
        option.add_argument('--ignore-ssl-errors')
        # 隐藏浏览器检测selenium
        option.add_argument("--disable-blink-features=AutomationControlled")
        # 忽略无用日志
        option.add_experimental_option("excludeSwitches", ["enable-automation", "enable-logging"])
        option.add_experimental_option("detach", True)
        
        # 禁用记住密码弹框
        option.add_experimental_option("prefs",{"credentials_enable_service":False,"profile.password_manager_enabled":False,"download.default_directory" : defaultDirectory})
        driver = webdriver.Chrome(chrome_options=option,executable_path=r"/usr/local/bin/chromedriver")
        # 窗口最大化
        driver.maximize_window()
        # 设置请求拦截器-只要有请求就会被拦截获取到
        # driver.request_interceptor = interceptor_request
        # 设置响应拦截器
        # driver.response_interceptor = self.interceptor_response
        driver.implicitly_wait(10)      # 设置最长等待时间，每隔半秒寻找一次，最长等待时间为10秒
        self.driver = driver


    def screenShotDriver(self,fileName):
        ''' 截图 '''
        date = time.strftime("%Y-%m-%d", time.localtime())
        defaultDirectory = './image_path/{}/'.format(date)
        self.mkdir(path=defaultDirectory)
        png_path = defaultDirectory + '{}={}={}.png'.format(fileName,self.headless, '1-' +  '-截图-')
        self.driver.get_screenshot_as_file(png_path)
        # self.driver.save_screenshot(png_path)
        return png_path

    def setHeadles(self,headles):
        ''' 设置为无界面模式 '''
        # if headles == 1 :
        if headles :
            self.headless = headles
        else:
            self.headless = 0

    def isHeadless(self):
        ''' 是否是无界面模式'''
        if self.headless :
            ''' 是 '''
            return True
        return False
        
    def imitate_login(self,account,pwd):
        """模拟登陆（输入账号密码）"""
        self.driver.get(self.toJdUrl)
        time.sleep(6)
        self.driver.find_element(By.XPATH, '//div[@class="login-tab login-tab-r"]').click()
        time.sleep(2)
        self.driver.find_element(By.XPATH, '//input[@id="loginname"]').send_keys(account)

        self.account = account

        time.sleep(1)
        self.driver.find_element(By.XPATH, '//input[@id="nloginpwd"]').send_keys(pwd)
        time.sleep(1)
        self.driver.find_element(By.XPATH, '//a[@id="loginsubmit"]').click()

        self.run_log('账号：' + account + " ===== 账号密码验证通过。")
    
    def get_path_parent_dir(self):
        ''' 获取当前文件的所在目录的上一级目录 '''
        # /Users/a123456/zwn/gs_gitee/jingtong-data-capture
        parent_directory_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        return parent_directory_path
    
    def quit(self):
        self.driver.quit()
    
    def toJdUrl(self):
        self.driver.get(self._url)
        time.sleep(6)

    def mkdir(self,path):
        ''' 创建目录 '''
        # 引入模块
        # import os
    
        # 去除首位空格
        path=path.strip()
        # 去除尾部 \ 符号
        path=path.rstrip("\\")
    
        # 判断路径是否存在
        # 存在     True
        # 不存在   False
        isExists=os.path.exists(path)
    
        # 判断结果
        if not isExists:
            # 如果不存在则创建目录
            # 创建目录操作函数
            os.makedirs(path)
            # print(path+' 创建成功')
            return True
        else:
            # 如果目录存在则不创建，并提示目录已存在
            # print(path+' 目录已存在')
            return False
    
    def removeFiles(self,my_path):
        ''' 删除目录下的所有文件 '''
        for file_name in os.listdir(my_path):
            os.remove(my_path + file_name)

    
    def clickVersion(self,version=''):
        '''
        点击进入制定版本
        '''
        # <a href="?path=94.0.4606.41/">94.0.4606.41</a>
        self.driver.find_element(By.XPATH, f"//a[@href='?path={version}/']").click()


def exec(params = {} ):
    start = openUrl()
    start.setHeadles(params['headless'])
    start.start_chrome()
    start.toJdUrl()
    # start.imitate_login(params['username'],params['pwd'])
    time.sleep(4)
    print('保存截图')
    start.screenShotDriver(fileName='初始化')
    time.sleep(4)
    start.clickVersion(version='94.0.4606.41')
    time.sleep(4)
    print('保存截图 version')
    start.screenShotDriver(fileName='version')
    time.sleep(4)
    

    

if __name__ == '__main__':
    params = {
        'username':'123456',
        'pwd':'123456',
        'headless':1,
    }
    exec(params)






