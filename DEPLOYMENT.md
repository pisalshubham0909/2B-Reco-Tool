# DEPLOYMENT GUIDE: GSTR-2B Reconciliation Tool

This guide explains how to host and publish your Streamlit reconciliation tool online so your team or clients can access it from anywhere.

---

## 🔒 Important: Data Security & Privacy
Since this tool processes sensitive corporate financial records (GSTINs, invoices, and accounting registers):
* **No Database Logging**: Our application does not store uploaded files on a server or write them to a database. Uploaded files are parsed completely in-memory and discarded as soon as the user closes the browser session.
* **Hosting Security**: When publishing, choose a deployment option that aligns with your company's IT data protection policies.

---

## Option 1: Streamlit Community Cloud (Easiest & Free)
Streamlit offers free hosting directly from GitHub.

### Steps:
1. **Create a GitHub Account**: If you don't have one, sign up at [github.com](https://github.com).
2. **Create a Repository**:
   * Create a new repository (can be set to **Private** to protect your source code).
   * Upload all files from this folder (`app.py`, `parser.py`, `reconciliation.py`, `requirements.txt`, and `.streamlit/config.toml`) into the repository.
3. **Connect to Streamlit Cloud**:
   * Visit [share.streamlit.io](https://share.streamlit.io) and log in using your GitHub account.
   * Click **"Create app"** (or **"New app"**).
4. **Configure & Deploy**:
   * Select your **Repository**, **Branch** (usually `main` or `master`), and set **Main file path** to `app.py`.
   * Click **"Deploy!"**.
   * Streamlit will compile the `requirements.txt` dependencies and launch your live website (usually within 1–2 minutes).

---

## Option 2: Render or Hugging Face Spaces (Free Cloud Alternatives)
These platforms allow easy web deployment with automatic GitHub syncs.

### Using Hugging Face Spaces:
1. Create an account on [huggingface.co](https://huggingface.co).
2. Go to **Spaces** -> **Create New Space**.
3. Set Space SDK to **Streamlit**.
4. Set visibility to **Public** or **Private**.
5. Upload your files via git or drag-and-drop, and Hugging Face will host the app automatically.

### Using Render:
1. Create a free account on [render.com](https://render.com).
2. Link your GitHub account and select your project repository.
3. Create a **Web Service**:
   * **Build Command**: `pip install -r requirements.txt`
   * **Start Command**: `streamlit run app.py --server.port $PORT --server.address 0.0.0.0`
4. Deploy the service. Render will provide a free public URL (e.g. `your-app.onrender.com`).

---

## Option 3: AWS / Azure / Google Cloud VM (Recommended for Corporate Data)
If you require maximum security and need to deploy behind a private virtual network (VPN), host it on a private virtual machine.

### Setup Steps (Ubuntu Linux Server Example):
1. **Launch a VM instance** (AWS EC2, Azure VM, etc.) on your cloud console.
2. **Install Python & Git**:
   ```bash
   sudo apt update
   sudo apt install python3-pip python3-venv git -y
   ```
3. **Clone your code**:
   ```bash
   git clone <your-private-repo-url> /var/www/reco-tool
   cd /var/www/reco-tool
   ```
4. **Set up a Virtual Environment**:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```
5. **Configure systemd to run Streamlit in the background**:
   Create a service configuration file:
   ```bash
   sudo nano /etc/systemd/system/streamlit.service
   ```
   Paste the following:
   ```ini
   [Unit]
   Description=Streamlit GSTR-2B Reco Service
   After=network.target

   [Service]
   User=ubuntu
   WorkingDirectory=/var/www/reco-tool
   ExecStart=/var/www/reco-tool/venv/bin/streamlit run app.py --server.port 80 --server.address 0.0.0.0
   Restart=always

   [Install]
   WantedBy=multi-user.target
   ```
6. **Start and enable the service**:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl start streamlit
   sudo systemctl enable streamlit
   ```
   *Your site will now run continuously in the background on port `80` (accessible via the VM's public IP or assigned DNS domain).*
