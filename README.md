# 扫雷游戏部署指南

完全不需要后端开发经验，照着步骤做，约 15 分钟上线。

---

## 第一步：创建 Supabase 项目（5 分钟）

1. 打开 https://supabase.com → 点击 **Start your project**
2. 用 GitHub 账号或邮箱注册
3. 点击 **New project**，填写：
   - **Name**：minesweeper（随便填）
   - **Database Password**：设一个强密码（保存好）
   - **Region**：选 **Northeast Asia (Tokyo)**，离中国最近
4. 等待约 2 分钟，项目创建完成

---

## 第二步：建数据库表（2 分钟）

1. 在 Supabase 控制台左侧点 **SQL Editor**
2. 点 **New query**
3. 把 `supabase-setup.sql` 文件的全部内容粘贴进去
4. 点 **Run**（右上角绿色按钮）
5. 看到 `Success` 即可

---

## 第三步：获取 API Key（1 分钟）

1. 左侧点 **Project Settings** → **API**
2. 复制以下两个值：
   - **Project URL**（形如 `https://xxxx.supabase.co`）
   - **anon public** key（一长串字母）

---

## 第四步：填写到游戏文件（1 分钟）

打开 `index.html`，找到这两行（约第 270 行）：

```js
const SUPABASE_URL = 'https://YOUR_PROJECT_ID.supabase.co';
const SUPABASE_KEY = 'YOUR_ANON_KEY';
```

把 `YOUR_PROJECT_ID.supabase.co` 和 `YOUR_ANON_KEY` 替换为你刚复制的值。

---

## 第五步：关闭邮箱验证（可选，方便测试）

如果不想让注册用户验证邮箱：

1. 左侧 **Authentication** → **Providers** → **Email**
2. 关闭 **Confirm email**

---

## 第六步：部署上线（5 分钟）

### 方案 A：Vercel（推荐，免费）

1. 打开 https://vercel.com，用 GitHub 登录
2. 把 `index.html` 和 `supabase-setup.sql` 放进一个 GitHub 仓库
3. 在 Vercel 点 **New Project** → 导入该仓库 → 一键部署
4. Vercel 会给你一个 `xxx.vercel.app` 的网址，全球可访问

### 方案 B：直接发文件（最简单）

直接把 `index.html` 发给朋友，他们双击就能本地玩，但排行榜也能联网共享（因为连的 Supabase 是同一个库）。

### 方案 C：GitHub Pages（免费）

1. 创建 GitHub 仓库，上传 `index.html`
2. 仓库 Settings → Pages → Source 选 main 分支
3. 得到 `https://你的用户名.github.io/仓库名/` 地址

---

## 常见问题

**Q: 注册没反应？**  
A: 检查 Supabase URL 和 Key 是否填对，注意不要有多余空格。

**Q: 排行榜不更新？**  
A: 确认 SQL 脚本最后一行 `alter publication supabase_realtime...` 执行成功。

**Q: 提交成绩报错？**  
A: 检查 RLS 策略是否正确执行，或在 Supabase SQL Editor 中重新运行 setup.sql。

**Q: 想自定义域名？**  
A: Vercel 免费支持绑定自定义域名，在项目设置里添加即可。

---

## 文件说明

| 文件 | 说明 |
|------|------|
| `index.html` | 游戏主文件，包含全部前端代码 |
| `supabase-setup.sql` | 数据库初始化脚本，运行一次即可 |
| `README.md` | 本部署指南 |
