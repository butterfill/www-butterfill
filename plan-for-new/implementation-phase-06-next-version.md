
### **Phase 6 Plan: Deployment**

**Objective:** To deploy the finished website to a live, public URL using a modern, automated workflow. We will first deploy to a temporary "staging" environment for a final review, and then push to our permanent "production" home on Cloudflare Pages.

**Estimated Time:** 1 Day

---

#### **Introduction for the Developer**

Congratulations on building and testing the entire site! This final phase is about moving your work from your local machine to the internet. We'll do this in two steps to ensure everything is perfect.

1.  **Staging Deployment (Surge.sh):** We'll first publish the site to a temporary, public URL using a tool called Surge. This is like a dress rehearsal. It lets us do a final check of the site on a real web server before the official launch.
2.  **Production Deployment (Cloudflare Pages):** Once we're happy with the staging version, we'll set up the official deployment. We'll connect our Git repository to Cloudflare Pages, which will automatically build and publish our site. The best part is that after this is set up, any future updates to the site will be as simple as pushing your code to GitHub.

This two-step process is a professional best practice that helps catch issues and ensures a smooth, confident launch.

---

#### **Task 6.1: Staging Deployment to Surge.sh**

**Goal:** Publish a live, temporary version of the site for final review.

**Steps:**

1.  **Install the Surge Command-Line Tool:**
    Surge is a tool for publishing static sites. We need to install its command-line interface (CLI) globally on your machine so you can run it from any directory.

    ```bash
    npm install -g surge
    ```

2.  **Run the Production Build:**
    First, we need to create the final, optimized version of our site. The `build` command runs all our scripts (like `generate-llms.mjs`) and creates a `dist/` folder containing the complete static website.

    ```bash
    npm run build
    ```

3.  **Deploy the `dist` Folder:**
    Now, run the `surge` command, telling it to publish the contents of the `dist/` folder.

    ```bash
    surge dist/
    ```

4.  **Follow the Surge Prompts:**
    *   **Account:** If this is your first time using Surge, it will prompt you to create a free account. Just enter your email and a password.
    *   **Domain:** Surge will suggest a random domain name (e.g., `random-words.surge.sh`). For this staging deployment, the random domain is perfect. Just press **Enter** to accept it.

5.  **Final Review on Staging:**
    Surge will give you the live URL. Open it in your browser.
    *   Click through a few pages to make sure everything looks and works as expected on a real server.
    *   Send this URL to the project stakeholder for their final approval before moving to production.

**Rationale:**
*   **Why a Staging Step?** Deploying to a staging environment like Surge provides a crucial safety check. It confirms that our build process works correctly and that the site functions properly in a live server environment, which can sometimes reveal issues not present on `localhost`. It's fast, free, and disposable.

---

#### **Task 6.2: Production Deployment to Cloudflare Pages**

**Goal:** Set up an automated, Git-based deployment pipeline to the final production host.

**Prerequisites:**
*   You have a Cloudflare account (a free account is sufficient).
*   The project code has been pushed to a GitHub repository.

**Steps:**

1.  **Push Your Latest Code to GitHub:**
    Make sure your repository is completely up-to-date with all the work from the previous phases.

    ```bash
    git add .
    git commit -m "feat: Final build for production deployment"
    git push origin main
    ```

2.  **Log in to Cloudflare and Create a Pages Project:**
    *   Log in to your Cloudflare dashboard.
    *   In the sidebar, navigate to **Workers & Pages**.
    *   Click **Create application**, then select the **Pages** tab.
    *   Click **Connect to Git**.

3.  **Connect to Your GitHub Repository:**
    *   Follow the prompts to authorize Cloudflare to access your GitHub account.
    *   Select the repository for this project (e.g., `your-username/butterfill-website`).

4.  **Configure the Build Settings:**
    Cloudflare is smart and will likely detect that this is an Astro project and suggest the correct settings. Verify that they are as follows:
    *   **Project name:** Choose a name (e.g., `butterfill-website`).
    *   **Production branch:** `main`
    *   **Framework preset:** `Astro`
    *   **Build command:** `npm run build`
    *   **Build output directory:** `dist`

5.  **Save and Deploy:**
    *   Click the **Save and Deploy** button.
    *   Cloudflare will now pull your code from GitHub, run the `npm run build` command in its own environment, and deploy the resulting `dist` folder to its global network. You can watch the progress in the deployment logs.
    *   The first deployment will take a few minutes. Once it's done, you'll get a unique `*.pages.dev` URL where you can see your live site.

6.  **Set Up the Custom Domain:**
    *   After the first deployment is successful, go to your new Pages project's dashboard.
    *   Click on the **Custom domains** tab.
    *   Click **Set up a domain** and enter the final domain name (e.g., `www.butterfill.com`).
    *   Cloudflare will provide instructions for updating your DNS records at your domain registrar (the service where the domain was purchased). Follow these instructions to point your domain to your new Cloudflare Pages site.

**Rationale:**
*   **Git-based Workflow:** This is the core benefit of Cloudflare Pages. From now on, every time you `git push` a new commit to your `main` branch, Cloudflare will automatically repeat this build and deploy process. This makes updating the site incredibly simple and reliable.
*   **Global Performance:** Cloudflare deploys your static files to its massive global network (CDN), meaning the site will load very quickly for users anywhere in the world.
*   **Automatic Redirects:** Cloudflare Pages will automatically find and apply the rules in your `public/_redirects` file without any extra configuration.

---

#### **Task 6.3: Post-Launch Verification**

**Goal:** Perform a final check on the live production site at its custom domain.

**Steps:**

1.  **Browse the Live Site:**
    Once your custom domain is active, navigate to it (e.g., `https://www.butterfill.com`). Do a final, quick check of the key pages to ensure everything is working.

2.  **Test a Critical Redirect:**
    Pick one important old URL (e.g., from a highly-cited paper) and enter it into your browser. Verify that it correctly 301 redirects to the new page on the live domain.

3.  **Check `llms.txt` and `sitemap.xml`:**
    *   Navigate to `https://www.yourdomain.com/llms.txt` and verify the file is there.
    *   Navigate to `https://www.yourdomain.com/sitemap-0.xml` (Astro's default sitemap name) and verify it has been generated.

4.  **Celebrate!**
    You have successfully migrated and launched the new website.

---

#### **Required Files from Old Codebase**

*   None. This phase is entirely focused on the new codebase and deployment platforms.

---

#### **Definition of Done for Phase 6**

This phase is complete when:

*   [ ] The site has been successfully deployed to a temporary URL on Surge.sh for review.
*   [ ] A Cloudflare Pages project has been created and linked to the GitHub repository.
*   [ ] The first production deployment has completed successfully.
*   [ ] The custom domain is pointing to the Cloudflare Pages site and is active.
*   [ ] A final verification check on the live production URL confirms that the site, a key redirect, and generated files (`llms.txt`, `sitemap-0.xml`) are all working as expected.