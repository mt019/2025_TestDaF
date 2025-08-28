# 2025_TestDaF 專案技術總結

## 1. 版本控制 (Git + GitHub)
- **Git 初始化與遠端倉庫**
  - `git init` → 建立本地倉庫
  - `git remote add origin git@github.com:mt019/2025_TestDaF.git` → 綁定遠端
  - `git branch -M main` → 設定主分支為 `main`
  - `git push -u origin main` → 推送到 GitHub

- **忽略大檔案**
  - 使用 `.gitignore` 忽略 `_Material/` 資料夾
  - 避免超過 GitHub 100MB 限制

- **部署策略**
  - GitHub Pages 支援兩種方式：
    1. **Deploy from branch** → 預設會建立一個 `gh-pages` 分支，將靜態網站內容放到該分支
    2. **Deploy from Actions** → 使用 GitHub Actions CI/CD 流程，直接將建置結果發佈到 Pages  
       （更彈性，但執行過程稍慢，且要處理 workflow 設定）

---

## 2. 文件框架 (MkDocs)
- **選擇工具**
  - [MkDocs](https://www.mkdocs.org/) → 文件生成框架，適合技術文件、學習筆記
  - [mkdocs-material](https://squidfunk.github.io/mkdocs-material/) → 主題，提供現代化 UI

- **主要設定檔**
  - `mkdocs.yml`
    - 定義網站標題、主題、導航、外掛
    - 可自訂 logo、favicon、顏色
  - `docs/` → 放置 Markdown 內容
  - `docs/assets/extra.css` → 自訂 CSS 調整顏色、樣式

- **本地預覽 (兩種方法)**
  1. **Docker 容器**
     - `docker compose up` → 啟動網站 (http://127.0.0.1:8000)
     - `docker compose down` → 關閉
     - 優點：乾淨、一致，不用裝 Python
     - 缺點：必須開啟 Docker Desktop
  2. **本地 Python**
     - `pip install mkdocs mkdocs-material`
     - `mkdocs serve` → 啟動網站 (http://127.0.0.1:8000)
     - 優點：不依賴 Docker
     - 缺點：需要維護 Python 環境

---

## 3. 容器化 (Docker)
- **Dockerfile**  
  - 建立基於 Python 的環境  
  - 安裝 `mkdocs` 與必要套件  
  - 預設 `CMD mkdocs serve -a 0.0.0.0:8000`

- **docker-compose.yml**
  - 定義服務 `docs`  
  - 映射端口 `8000:8000`  
  - 將專案目錄掛載到容器內 `/docs`  
  - 好處：修改檔案後可即時預覽，不用重新 build

---

## 4. GitHub Pages 部署
- **方式一：Deploy from branch (推薦)**
  - 使用 `mkdocs gh-deploy --force`
  - 自動產生 `gh-pages` 分支作為 PageSource
  - 優點：穩定、簡單
  - 缺點：倉庫多一個 `gh-pages` 分支

- **方式二：Deploy from Actions**
  - 透過 `.github/workflows/mkdocs-docker.yml` 定義自動建置
  - 可加上 `git config --global --add safe.directory ...` 解決權限問題
  - 優點：CI/CD 彈性大
  - 缺點：速度稍慢，偶爾遇到 runner 限制

---

## 5. 前端自訂化
- **自訂樣式 (extra.css)**
  - 修改滑動條顏色：由預設紅/綠 → 改為粉色背景、深灰色滑桿
  - 可進一步定義字體、按鈕顏色

- **主題顏色**
  - 在 `mkdocs.yml` 中設定 `theme.palette`  
  - 也可透過 `extra.css` 微調細節

---

## 6. 常見問題與解決
1. **GitHub push 被拒絕**  
   - 因大檔案超過 100MB，需忽略或用 Git LFS
2. **Actions 出現 safe.directory 錯誤**  
   - 加入  
     ```yaml
     - run: git config --global --add safe.directory /__w/2025_TestDaF/2025_TestDaF
     ```
3. **Jekyll 預設構建錯誤**  
   - 必須指定 GitHub Pages 使用 MkDocs，而非 Jekyll
   - 在 Settings → Pages → Build and deployment → Source，選 **GitHub Actions 或 gh-pages branch**

---

## 7. 未來優化方向
- 整合 **CI/CD**，每次 push 自動部署
- 使用 **mkdocs-awesome-pages-plugin** 讓目錄排序更靈活
- 增加 **版本號** / **更新日期外掛**
- 如果內容龐大，可考慮 Git LFS 儲存 PDF/Zip

---