import os
import uuid
import requests
import pandas as pd
from datetime import datetime
from urllib.parse import urlparse
from tkinter import Tk, Label, Button, filedialog, messagebox, Entry, StringVar, Frame
from tkinter import ttk

# 获取当前时间默认文件夹名
def get_default_folder_name():
    return datetime.now().strftime('%Y%m%d%H%M')

# 提取 URL 文件名
def extract_filename_from_url(url):
    path = urlparse(url).path
    filename = os.path.basename(path)
    return filename if filename else str(uuid.uuid4())

# 单个下载逻辑
def download_file(url, folder_path):
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        filename = extract_filename_from_url(url)
        save_path = os.path.join(folder_path, filename)
        with open(save_path, 'wb') as f:
            f.write(response.content)
        return True
    except:
        return False

# 下载并更新 UI 进度
def start_download_with_progress(urls, save_path, fail_log_path, progress_bar, status_label, start_button):
    total = len(urls)
    success = 0
    fail = 0

    def process_next(index):
        nonlocal success, fail

        if index >= total:
            status_label.config(text=f"✅ 下载完成，成功 {success} 个，失败 {fail} 个")
            start_button.config(state='normal')
            return

        url = urls[index]
        ok = download_file(url, save_path)
        if ok:
            success += 1
        else:
            fail += 1
            with open(fail_log_path, 'a', encoding='utf-8') as f:
                f.write(url + '\n')

        percent = int(((index + 1) / total) * 100)
        progress_bar['value'] = percent
        status_label.config(text=f"进度：{percent}%  | 成功：{success}  失败：{fail}")
        progress_bar.update()

        # 延迟调用下一项，避免 UI 卡死
        progress_bar.after(100, lambda: process_next(index + 1))

    process_next(0)

# 下载启动逻辑
def start_download(selected_file, folder_name_var, base_path_var, full_path_label_var,
                   progress_bar, status_label, start_button):
    if not selected_file:
        messagebox.showwarning("警告", "请先选择 Excel 文件")
        return

    folder_name = folder_name_var.get().strip() or get_default_folder_name()
    base_path = base_path_var.get().strip() or os.getcwd()
    save_path = os.path.join(base_path, folder_name)
    os.makedirs(save_path, exist_ok=True)
    full_path_label_var.set(f"保存路径：{save_path}")

    try:
        df = pd.read_excel(selected_file, usecols=[0])
        urls = df.iloc[:, 0].astype(str).str.strip()
        urls = urls[urls != '']  # 过滤空字符串
        urls = urls.tolist()

        if not urls:
            messagebox.showinfo("提示", "未检测到有效 URL")
            return

        # 清空失败记录
        failed_log_path = os.path.join(save_path, 'download_fail.log')
        with open(failed_log_path, 'w', encoding='utf-8') as f:
            pass

        progress_bar['maximum'] = 100
        progress_bar['value'] = 0
        progress_bar.pack(pady=10)
        status_label.pack()
        start_button.config(state='disabled')

        start_download_with_progress(urls, save_path, failed_log_path,
                                     progress_bar, status_label, start_button)

    except Exception as e:
        messagebox.showerror("错误", f"下载过程中发生错误：{e}")

# 文件选择
def choose_file(selected_file_var, file_label):
    file_path = filedialog.askopenfilename(filetypes=[("Excel 文件", "*.xlsx")])
    if file_path:
        selected_file_var.set(file_path)
        file_label.config(text=f"已选择文件：{os.path.basename(file_path)}")

# 保存路径选择
def select_directory(base_path_var, folder_name_var, full_path_label_var):
    selected = filedialog.askdirectory()
    if selected:
        base_path_var.set(selected)
        update_full_path_label(folder_name_var, base_path_var, full_path_label_var)

# 路径标签更新
def update_full_path_label(folder_name_var, base_path_var, full_path_label_var):
    folder_name = folder_name_var.get().strip() or get_default_folder_name()
    base_path = base_path_var.get().strip() or os.getcwd()
    full_path_label_var.set(f"保存路径：{os.path.join(base_path, folder_name)}")

# 主界面
def create_gui():
    root = Tk()
    root.title("URL 批量下载工具 作者：XMYX-0")
    root.geometry("620x460")

    selected_file_var = StringVar()
    folder_name_var = StringVar(value=get_default_folder_name())
    base_path_var = StringVar(value=os.getcwd())
    full_path_label_var = StringVar()

    # UI 元素
    Label(root, text="1. 选择包含 URL 的 Excel 文件（.xlsx）", font=("微软雅黑", 11)).pack(pady=10)
    file_label = Label(root, text="尚未选择文件", font=("微软雅黑", 10), fg="gray")
    file_label.pack()
    Button(root, text="选择 Excel 文件", font=("微软雅黑", 10),
           command=lambda: choose_file(selected_file_var, file_label)).pack(pady=5)

    Label(root, text="2. 设置保存目录", font=("微软雅黑", 11)).pack(pady=10)
    Label(root, text="保存子目录名称:", font=("微软雅黑", 10)).pack()
    folder_entry = Entry(root, textvariable=folder_name_var, font=("微软雅黑", 10), width=35)
    folder_entry.pack()

    path_frame = Frame(root)
    path_frame.pack(pady=10)
    Label(path_frame, text="保存路径:", font=("微软雅黑", 10)).grid(row=0, column=0, padx=5)
    path_entry = Entry(path_frame, textvariable=base_path_var, font=("微软雅黑", 10), width=35)
    path_entry.grid(row=0, column=1)
    Button(path_frame, text="浏览", command=lambda: select_directory(base_path_var, folder_name_var, full_path_label_var)).grid(row=0, column=2, padx=5)

    update_full_path_label(folder_name_var, base_path_var, full_path_label_var)
    Label(root, textvariable=full_path_label_var, font=("微软雅黑", 9), fg="gray").pack()

    progress_bar = ttk.Progressbar(root, length=400)
    status_label = Label(root, text="", font=("微软雅黑", 10))

    start_button = Button(root, text="✅ 开始下载", font=("微软雅黑", 12), bg="#4CAF50", fg="white",
                          command=lambda: start_download(
                              selected_file_var.get(),
                              folder_name_var,
                              base_path_var,
                              full_path_label_var,
                              progress_bar,
                              status_label,
                              start_button))
    start_button.pack(pady=20)

    folder_entry.bind("<KeyRelease>", lambda e: update_full_path_label(folder_name_var, base_path_var, full_path_label_var))
    path_entry.bind("<KeyRelease>", lambda e: update_full_path_label(folder_name_var, base_path_var, full_path_label_var))

    Label(root, text="注意：Excel 的第一行为标题，从第二行开始读取 URL", font=("微软雅黑", 9), fg="gray").pack(pady=10)

    root.mainloop()

if __name__ == "__main__":
    create_gui()
