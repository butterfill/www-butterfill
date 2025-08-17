
### **Phase 5 Plan: Testing, Validation & SEO**

**Objective:** To rigorously test and validate every aspect of the new website, ensuring it meets the high standards for performance, accessibility, and search engine optimization outlined in the project requirements.

This phase is all about quality control—ensuring the website is fast, accessible, bug-free, and optimized for search engines before it goes live.

**Estimated Time:** 3 Days

---

#### **Introduction for the Developer**

Great work getting all the features built! Now, we enter a crucial phase: quality assurance. Our goal here is to be methodical and thorough. We'll act like the site's first real users, trying to find anything that's broken, slow, or confusing.

This phase is less about writing new code and more about using professional tools to audit our work. We'll use the developer tools built into your browser, specifically the Lighthouse and Accessibility auditors, to get objective scores on our site's quality. This process ensures that the final product is not just functional but also a high-quality experience for every visitor on any device.

---

#### **Task 5.1: Quality Assurance (QA) & Cross-Browser Testing**

**Goal:** Manually test the entire website to ensure all features work as expected and the design is consistent across major browsers and on mobile devices.

**Steps:**

1.  **Start the Development Server:**
    Run `npm run dev` to have a live version of the site to test.

2.  **Desktop Browser Testing (Chrome, Firefox, Safari):**
    Open the site in each of these browsers and systematically check the following:
    *   **Homepage:**
        *   Does the layout look correct?
        *   Does the sidebar navigation work when you click the links?
        *   Does the scroll-spying correctly highlight the section you're viewing?
    *   **Navigation:**
        *   Click through to a publication, a talk, and a teaching page. Do all links work?
        *   Use the browser's back and forward buttons. Does everything behave as expected?
    *   **Content Pages:**
        *   Is the text readable and well-formatted?
        *   Do PDF download links work?
        *   On talk pages, does the Reveal.js slide deck load and can you navigate through the slides?
    *   **Interactive Features:**
        *   Open the Command Palette (`Cmd/Ctrl+K`). Can you search for a page and navigate to it?
        *   On a publication page, does the "Copy for Chat" button work?
        *   Test the dark mode toggle (we'll build the toggle itself later, but you can change your OS setting to see if the site responds).

3.  **Mobile Responsive Testing:**
    Use Chrome's Device Mode (in Developer Tools) to simulate a mobile device (e.g., "iPhone 12 Pro").
    *   Does the layout adapt correctly? Is the navigation usable?
    *   Is the text size appropriate and readable?
    *   Are interactive elements like buttons and links easy to tap?

**Rationale:**
*   Even though modern web frameworks are very good, different browsers can still render things slightly differently. Testing across the most common browsers ensures a consistent experience for all users. Responsive design is non-negotiable, so testing the mobile layout is just as important as the desktop one.

---

#### **Task 5.2: Validate Redirects**

**Goal:** Confirm that the old URLs from the Docpad site correctly redirect to their new locations with a permanent (301) status code.

**Steps:**

1.  **Build the Site for Production:**
    The redirect file is a static asset that only exists in the final build output.

    ```bash
    npm run build
    ```

2.  **Preview the Production Site:**
    Astro has a built-in command to serve the `dist` folder, which will also respect our redirect rules.

    ```bash
    npm run preview
    ```
    This will start a local server, usually at `http://localhost:4321`.

3.  **Test the Redirects:**
    *   Open your browser's Developer Tools and go to the **Network** tab. Make sure "Disable cache" is checked.
    *   Open the `dist/_redirects` file in your code editor and pick 5-10 URLs from the left-hand column (the old URLs).
    *   In your browser, navigate to one of the **old** URLs (e.g., `http://localhost:4321/writing/joint_action_development.html`).
    *   **Observe the Network Tab:** You should see the browser make a request to the old URL, receive a `301` status code, and then be automatically redirected to the new URL (e.g., `/writing/joint-action-development/`), which should return a `200` status code.
    *   Repeat this for a good sample of publications and talks to ensure the mapping is correct.

**Rationale:**
*   Validating redirects is critical for SEO. A `301` redirect tells search engines that a page has moved permanently, and they should transfer all of the old page's ranking authority to the new one. Testing this locally before deployment ensures we won't lose valuable search traffic.

---

#### **Task 5.3: Performance & Accessibility Audit**

**Goal:** Use automated tools to measure and improve the site's performance and accessibility, aiming for a Lighthouse score of 95+.

**Steps:**

1.  **Run Lighthouse Audits:**
    *   In Chrome, with the preview server running (`npm run preview`), open an incognito window to ensure no extensions interfere.
    *   Navigate to your site's homepage.
    *   Open Developer Tools, go to the **Lighthouse** tab.
    *   Select "Navigation" and "Desktop". Check the "Performance" and "Accessibility" categories.
    *   Click "Analyze page load".
    *   Review the report. Look for any red or orange items in the "Performance" section. Common issues might be large images or layout shifts. Address these issues.
    *   Repeat this process for a publication page and a talk page.

2.  **Perform Manual Accessibility Checks:**
    *   **Keyboard Navigation:** Close your eyes and try to navigate the site using only the `Tab` key to move forward and `Shift+Tab` to move backward. Can you tell where you are at all times? Is the focus outline clear? Can you operate the slide deck and command palette?
    *   **Color Contrast:** Use a color contrast checker tool (available as a browser extension or online) to check that your text has sufficient contrast against its background, especially for links.
    *   **Install and Run Axe DevTools:** This is a browser extension that provides a more detailed accessibility audit than Lighthouse. Install it, run it on your key pages, and fix any critical violations it reports.

**Rationale:**
*   **Lighthouse** is the industry-standard tool for measuring web page quality. A high score is a direct measure of our success against the non-functional requirements (NFR-4, NFR-5).
*   **Accessibility (a11y)** is about making the web usable for everyone, including people who use screen readers or cannot use a mouse. It's a legal and ethical requirement. While automated tools like Lighthouse and Axe are great, manual keyboard testing is essential to catch issues they might miss.

---

#### **Task 5.4: Final SEO Checks**

**Goal:** Ensure the site has the basic technical SEO features in place.

**Steps:**

1.  **Add the Astro Sitemap Integration:**
    This package will automatically create a `sitemap.xml` file, which helps search engines discover all the pages on our site.

    ```bash
    npx astro add sitemap
    ```    Follow the prompts. It will ask for your site's domain in `astro.config.mjs`. You can use `https://example.com` as a placeholder for now.

2.  **Create a `robots.txt` File:**
    This file tells search engine crawlers which parts of the site they are allowed to visit.
    *   Create a new file at `public/robots.txt`.
    *   Add the following content:
    ```
    User-agent: *
    Allow: /

    Sitemap: https://www.butterfill.com/sitemap.xml
    ```

3.  **Verify Meta Tags:**
    *   Go to your `src/layouts/BaseLayout.astro` file.
    *   Ensure the `<title>` tag is using the `title` prop we passed to it.
    *   Add a meta description tag that can be overridden by individual pages:
    ```astro
    ---
    interface Props {
      title: string;
      description?: string;
    }
    const { title, description = "Stephen Butterfill's research on philosophical issues in cognitive development." } = Astro.props;
    ---
    <head>
      <title>{title}</title>
      <meta name="description" content={description} />
    </head>
    ```

**Rationale:**
*   A **sitemap** and **robots.txt** are fundamental for good SEO. They make it easy for Google to find and index all of our content efficiently.
*   Unique and descriptive **title and meta description tags** are crucial for how our pages appear in search results.

---

#### **Required Files from Old Codebase**

*   `src/documents/robots.txt`: You can compare the old `robots.txt` with the new one you are creating. The old one is very simple, and our new one will be an improvement by linking to the sitemap.

---

#### **Definition of Done for Phase 5**

This phase is complete when:

*   [ ] A comprehensive manual test of all pages and features has been completed on Chrome, Firefox, and Safari, and on a simulated mobile device.
*   [ ] All identified bugs and layout issues have been fixed.
*   [ ] The `_redirects` file has been tested and confirmed to be working correctly using `npm run preview`.
*   [ ] Lighthouse reports for the homepage, a list page, and a detail page all show scores of 95+ for Performance and Accessibility.
*   [ ] The site is fully navigable using only a keyboard.
*   [ ] The Astro sitemap integration has been added.
*   [ ] A `public/robots.txt` file has been created.
*   [ ] All pages have unique, descriptive `<title>` and `<meta name="description">` tags.