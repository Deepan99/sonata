# 🚀 Project Handover & Onboarding Guide
**Project Name:** Serverless Document Processing Service
**Target Audience:** Junior Developers / Freshers

Welcome to the team! This document is designed to take you from knowing absolutely nothing about this project to understanding exactly how it works, why we built it this way, and how to test it.

---

## 1. What Does This Project Do?
Imagine our company receives thousands of documents every day (like resumes, invoices, or insurance claims). 

If we used traditional servers to process these, we would have to pay for servers 24/7, and if 10,000 people uploaded documents at the exact same time, the server would crash.

Instead, we built a **Serverless Event-Driven Architecture**. This means:
1. We have no servers running when the system is idle (saving the company massive amounts of money).
2. The exact millisecond a file is uploaded, AWS instantly spins up a small worker (Lambda) to process it.
3. If 10,000 files are uploaded at once, AWS spins up 10,000 workers in parallel. The system never crashes.

---

## 2. The Core Technologies (The Tech Stack)
We didn't just build this by clicking around the AWS website. We used modern DevOps practices:

*   **AWS (Amazon Web Services):** The cloud provider hosting our infrastructure.
*   **Terraform (Infrastructure as Code):** We wrote code to define our infrastructure. This ensures we can destroy and rebuild the entire project in 2 minutes without human error.
*   **Docker:** We packaged our Python processing code inside a container. This ensures that the code runs exactly the same way on your laptop as it does in the cloud.
*   **GitHub Actions (CI/CD):** A robot that watches our code. Every time we push a code change, it automatically tests it, builds the Docker image, and deploys the updates to AWS.

---

## 3. How the Architecture Works
There are two main ways documents enter our system:

### Flow A: The Event-Driven Flow (Internal Uploads)
1. **S3 Bucket:** A file is uploaded to our secure storage bucket.
2. **EventBridge:** The bucket shouts, *"Hey, a file arrived!"*
3. **Lambda:** The worker wakes up, reads the file, processes the data, and goes back to sleep.

### Flow B: The Secure API Flow (External Customers)
1. **Cognito:** An external customer logs in with an email and password to get a secure `JWT ID Token`.
2. **API Gateway:** The customer sends their document data to our API URL and attaches their Token. The API Gateway acts as a bouncer, verifies the token, and lets them in.
3. **Lambda:** The worker processes the API request and sends a "Success" message back to the customer.

---

## 4. Security Highlights
Security is our top priority. Here is how we locked down the system:
*   **KMS Encryption:** Every single document stored in S3 is encrypted at rest using custom keys.
*   **IAM Least Privilege:** Our Lambda worker is *only* allowed to touch its specific S3 bucket. It is physically blocked from accessing any other part of our AWS account.
*   **Authentication:** The API cannot be spammed by the public internet because Cognito protects the front door.

---

## 5. How to Test the Application
We have provided a Windows PowerShell script (`test_api.ps1`) in the root directory so you can test the API flow locally without needing complex tools.

**Step-by-Step Testing Guide:**
1. Log into the AWS Console and go to **Cognito**.
2. Find the User Pool (`doc-processing-users-dev`) and create a test user with an email and password.
3. Go to the "App integration" tab, scroll to the bottom, and copy the **Client ID**.
4. Go to **API Gateway**, click on the API (`doc-api-dev`), click on **Stages**, and copy the **Invoke URL**.
5. Open `test_api.ps1` in your code editor.
6. Paste the Client ID, API URL, Email, and Password into the top 4 lines of the script.
7. Open PowerShell, navigate to the folder, and run:
   `.\test_api.ps1`

The script will securely authenticate with AWS, handle any forced password resets, grab the secure token, and hit the API. You should see a green **SUCCESS** message!

---

## 6. Where is the Code?
Everything is modular and organized:
*   `/src`: Contains the Python code (`app.py`), the `Dockerfile`, and `requirements.txt`.
*   `/terraform/modules`: Contains the Lego blocks of our infrastructure (`api`, `auth`, `compute`, `events`, `network`, `storage`).
*   `/terraform/environments/dev`: Where we snap the Lego blocks together to build the Development environment.
*   `/.github/workflows`: Contains the `deploy.yml` pipeline that automates our deployments.

Take your time reading through the Terraform files. Welcome aboard!
