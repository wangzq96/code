import tkinter as tk
from tkinter import filedialog, messagebox, ttk
from PIL import Image, ImageTk
import os
import threading
import webbrowser

class GifMakerApp:
    def __init__(self, root):
        self.root = root
        self.root.title("GIF 动图生成器")
        self.image_paths = []

        self.build_ui()

    def build_ui(self):
        # 图片列表框
        self.listbox = tk.Listbox(self.root, selectmode=tk.SINGLE, width=50, height=8)
        self.listbox.grid(row=0, column=0, columnspan=3, padx=10, pady=5)

        # 上移/下移按钮
        tk.Button(self.root, text="↑ 上移", command=self.move_up).grid(row=1, column=0, sticky="ew", padx=10)
        tk.Button(self.root, text="↓ 下移", command=self.move_down).grid(row=1, column=1, sticky="ew", padx=10)

        # 选择图片
        tk.Button(self.root, text="选择图片", command=self.select_images).grid(row=2, column=0, columnspan=2, pady=5)

        # # 水印文字
        # tk.Label(self.root, text="水印文字：").grid(row=7, column=0, sticky="e")
        # self.watermark_text = tk.StringVar(value="@ CSDN博主XMYX-0")
        # tk.Entry(self.root, textvariable=self.watermark_text, width=30).grid(row=7, column=1, columnspan=2, pady=2)

        # # 字体大小
        # tk.Label(self.root, text="字体大小：").grid(row=8, column=0, sticky="e")
        # self.font_size = tk.IntVar(value=20)
        # tk.Entry(self.root, textvariable=self.font_size, width=8).grid(row=8, column=1, sticky="w", pady=2)


        # 帧间隔时间
        tk.Label(self.root, text="帧间隔 (ms)：").grid(row=3, column=0, sticky="e")
        self.duration_var = tk.IntVar(value=1000)
        tk.Entry(self.root, textvariable=self.duration_var, width=8).grid(row=3, column=1, sticky="w")

        # 选择保存路径
        tk.Button(self.root, text="保存路径", command=self.choose_output_path).grid(row=4, column=0, pady=5)
        self.output_path_var = tk.StringVar(value="output.gif")
        tk.Entry(self.root, textvariable=self.output_path_var, width=30).grid(row=4, column=1)

        # 进度条
        self.progress = ttk.Progressbar(self.root, orient="horizontal", length=300, mode="determinate")
        self.progress.grid(row=5, column=0, columnspan=3, pady=5)

        # 生成按钮
        tk.Button(self.root, text="生成 GIF", command=self.generate_gif_thread).grid(row=6, column=0, columnspan=3, pady=10)

    def select_images(self):
        file_paths = filedialog.askopenfilenames(
            title="选择多张图片",
            filetypes=[("图片文件", "*.png *.jpg *.jpeg *.bmp")]
        )
        if file_paths:
            self.image_paths = list(file_paths)
            self.refresh_listbox()

    def refresh_listbox(self):
        self.listbox.delete(0, tk.END)
        for path in self.image_paths:
            self.listbox.insert(tk.END, os.path.basename(path))

    def move_up(self):
        index = self.listbox.curselection()
        if not index or index[0] == 0:
            return
        idx = index[0]
        self.image_paths[idx-1], self.image_paths[idx] = self.image_paths[idx], self.image_paths[idx-1]
        self.refresh_listbox()
        self.listbox.select_set(idx-1)

    def move_down(self):
        index = self.listbox.curselection()
        if not index or index[0] == len(self.image_paths) - 1:
            return
        idx = index[0]
        self.image_paths[idx+1], self.image_paths[idx] = self.image_paths[idx], self.image_paths[idx+1]
        self.refresh_listbox()
        self.listbox.select_set(idx+1)

    def choose_output_path(self):
        path = filedialog.asksaveasfilename(
            defaultextension=".gif",
            filetypes=[("GIF 文件", "*.gif")],
            title="选择 GIF 保存路径"
        )
        if path:
            self.output_path_var.set(path)

    def generate_gif_thread(self):
        t = threading.Thread(target=self.generate_gif)
        t.start()

    def generate_gif(self):
        if not self.image_paths:
            messagebox.showwarning("未选择图片", "请先选择图片！")
            return

        try:
            duration = int(self.duration_var.get())
        except ValueError:
            messagebox.showerror("无效间隔", "请输入合法的帧间隔（整数）")
            return

        output_path = self.output_path_var.get().strip()
        if not output_path:
            messagebox.showerror("路径错误", "请输入有效的保存路径")
            return

        try:
            frames = []
            self.progress["maximum"] = len(self.image_paths)
            self.progress["value"] = 0

            from PIL import ImageFont, ImageDraw

            # ...在循环中每次读取图片时
            for idx, path in enumerate(self.image_paths):
                img = Image.open(path).convert("RGBA")

                if idx == 0:
                    w, h = img.size
                else:
                    img = img.resize((w, h))

                # 添加水印
                draw = ImageDraw.Draw(img)
                # text = self.watermark_text.get()
                # font_size = self.font_size.get()
                text = "@ CSDN博主XMYX-0"
                font_size = 50


                try:
                    # Windows 通用字体路径（可自定义）
                    # font = ImageFont.truetype("arial.ttf", font_size)
                    font = ImageFont.truetype("C:/Windows/Fonts/simhei.ttf", font_size)
                except:
                    font = ImageFont.load_default()

                bbox = draw.textbbox((0, 0), text, font=font)
                text_width = bbox[2] - bbox[0]
                text_height = bbox[3] - bbox[1]

                position = (w - text_width - 10, h - text_height - 10)  # 右下角

                draw.text(position, text, font=font, fill=(255, 0, 0, 128))  # 半透明红色水印

                frames.append(img)
                self.progress["value"] += 1
                self.root.update_idletasks()

            # for idx, path in enumerate(self.image_paths):
            #     img = Image.open(path).convert("RGBA")
            #     if idx == 0:
            #         w, h = img.size
            #     else:
            #         img = img.resize((w, h))
            #     frames.append(img)
            #     self.progress["value"] += 1
            #     self.root.update_idletasks()

            frames[0].save(
                output_path,
                save_all=True,
                append_images=frames[1:],
                duration=duration,
                loop=0
            )

            messagebox.showinfo("成功", f"GIF 已生成：\n{output_path}")
            webbrowser.open(output_path)

        except Exception as e:
            messagebox.showerror("错误", f"生成失败：\n{str(e)}")

if __name__ == "__main__":
    root = tk.Tk()
    app = GifMakerApp(root)
    root.mainloop()
