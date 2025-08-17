# url

https://aistudio.google.com/prompts/1Vkfq6RDdboTNeftjVKoUKEOASns4ffM2


### **Project Plan: Website Migration to Astro**

**Version:** 1.0
**Date:** August 12, 2025
**Author:** Gemini

#### **1. Project Summary**

This document outlines the plan for migrating the personal academic website of Stephen Butterfill from the legacy Docpad static site generator to the modern Astro framework. The goal is to create a performant, maintainable, and feature-rich website that preserves all existing content while introducing significant enhancements, including a command palette, LLM-focused features, and a modern, responsive design with dark mode.

This plan incorporates the clarifications provided, notably making all new features and dark mode core requirements, committing to a full slide migration using Reveal.js, and defining a revised content migration strategy to handle the logic present in existing `.jade` template files.

#### **2. Project Phases & Detailed Tasks**

The project will be executed in six distinct phases to ensure a structured and manageable workflow.

---

##### **Phase 1: Foundation & Environment Setup (Est. 2 Days)**

This phase focuses on establishing the technical foundation for the project.

*   **Task 1.1: Initialize Astro Project:**
    *   Create a new Astro project with the Svelte integration.
    *   Initialize a Git repository for version control.
*   **Task 1.2: Install & Configure Core Dependencies:**
    *   Install Tailwind CSS and configure `tailwind.config.cjs` and `postcss.config.cjs` to align with the `zed.dev` aesthetic.
    *   Install Svelte and the `shadcn-svelte` / `Bits UI` libraries for interactive components.
*   **Task 1.3: Establish Project Structure:**
    *   Create the directory structure as outlined in the technical design: `src/content`, `src/components`, `src/layouts`, `src/pages`, `public/`.
*   **Task 1.4: Define Content Collection Schemas:**
    *   In `src/content/config.ts`, define the type-safe schemas for `writing`, `talks`, and `teaching` collections based on the frontmatter mapping in the technical design. This will enforce data consistency from the outset.

---

##### **Phase 2: Content & Data Migration (Est. 5 Days)**

This is the most critical phase, focusing on the automated conversion of all existing content. The migration script will be a one-time, comprehensive Node.js script.

*   **Task 2.1: Develop the Migration Script - Core Logic:**
    *   Set up a Node.js script with dependencies for file system access (`fs-extra`), CSON parsing, and Pug/Jade parsing.
    *   Implement logic to recursively scan the `src/documents/` directory.
*   **Task 2.2: Implement Frontmatter Conversion:**
    *   Parse CSON frontmatter from all source files (`.jade`, `.html.md`, `.html`).
    *   Convert the parsed data to a YAML string, strictly adhering to the new, standardized schema defined in Phase 1.
*   **Task 2.3: Implement Content Body Handling (Revised Strategy):**
    *   **For `.html.md` and `.html` files:** Extract the body content directly.
    *   **For `.jade` files:** The script will **not** attempt to convert layout logic. Instead, it will parse the Jade file to extract only the core content body (e.g., the abstract or main text) and convert it to HTML. The layout and list-generation logic found in files like `index.html.jade` will be manually re-implemented in Astro in Phase 3.
*   **Task 2.4: Implement Asset Handling & Validation:**
    *   Scan content for links to assets (PDFs, images).
    *   Copy all assets to the `public/` directory, sanitizing filenames.
    *   **Crucially, for each publication, the script will check if a PDF with a matching basename exists.** The `pdfUrl` field will only be added to the frontmatter if the file is found.
    *   For talks with `deckslides: true`, the script will locate all associated images and populate the `slideImages` array in the frontmatter with their new paths.
*   **Task 2.5: Implement Redirect Generation:**
    *   For every content file processed, map its old URL (e.g., `/writing/joint_action_development.html`) to its new Astro URL (e.g., `/writing/joint-action-development/`).
    *   Generate a `_redirects` file in the `public/` directory, formatted for Cloudflare Pages (`/old-path /new-path 301`).
*   **Task 2.6: Execute and Validate Migration:**
    *   Run the script on the entire codebase.
    *   Manually review a sample of the generated Markdown files and the `_redirects` file to ensure accuracy and completeness.

---

##### **Phase 3: Core Site Build, Layout & Styling (Est. 4 Days)**

With the content migrated, this phase focuses on building the visual and structural shell of the website in Astro.

*   **Task 3.1: Build Base Layouts:**
    *   Create a `BaseLayout.astro` component containing the main HTML structure, header, footer, and import of global styles.
    *   Create specific layouts for the homepage, content list pages, and content detail pages.
*   **Task 3.2: Implement Static Pages & Routing:**
    *   Create `src/pages/index.astro` to serve as the homepage, fetching and displaying recent publications and talks by querying the content collections.
    *   Create dynamic route pages (e.g., `src/pages/writing/[...slug].astro`) that use `getStaticPaths` to generate a page for each item in the content collections.
*   **Task 3.3: Implement Core Styling & Dark Mode:**
    *   Apply Tailwind CSS utility classes to style all layouts and components, focusing on the minimalist, text-focused `zed.dev` aesthetic.
    *   Implement dark mode using Tailwind's `dark:` variant. A small client-side script will be added to the `BaseLayout` to toggle the `dark` class on the `<html>` element based on user preference (`prefers-color-scheme`) and/or a manual toggle.
*   **Task 3.4: Build Navigation Components:**
    *   Create the persistent sidebar navigation component.
    *   Implement the scroll-spying logic using an `IntersectionObserver` in a client-side `<script>` tag to highlight the current section.

---

##### **Phase 4: Feature Implementation (Est. 5 Days)**

This phase focuses on building the new, interactive features of the site.

*   **Task 4.1: Implement Slide Previews (FR-13):**
    *   Create a `<Slides.astro>` component that accepts an array of image URLs.
    *   Integrate Reveal.js, initializing it via a client-side script within the component to generate a responsive slide deck from the images.
*   **Task 4.2: Implement LLM Features (FR-17, FR-18):**
    *   Write a pre-build Node.js script (`scripts/generate-llms.mjs`) that reads all publications from the content collection and generates the `public/llms.txt` file.
    *   Update the `package.json` build script to: `"build": "node ./scripts/generate-llms.mjs && astro build"`.
    *   Create the `CopyForChat.svelte` component and integrate it into the publication and talk detail pages.
*   **Task 4.3: Implement Command Palette (FR-19 to FR-21):**
    *   Build the `CommandPalette.svelte` component using `shadcn-svelte`.
    *   In `BaseLayout.astro`, fetch all content collection entries at build time, format them into a JSON array, and pass this to the Svelte component.
    *   On detail pages, pass page-specific data (e.g., PDF URL, BibTeX) to the component to enable context-aware actions.
*   **Task 4.4: Recreate Utility Pages (FR-22):**
    *   Rebuild the `hashme-q3.html` functionality as a standalone Astro page, including its necessary client-side JavaScript.

---

##### **Phase 5: Testing, Validation & SEO (Est. 3 Days)**

This phase is dedicated to ensuring the site is robust, performant, and accessible before deployment.

*   **Task 5.1: Quality Assurance (QA):**
    *   Conduct thorough cross-browser testing (Chrome, Firefox, Safari) on desktop and mobile.
    *   Verify all internal links, asset links (PDFs, images), and external links.
    *   Test all interactive components: Command Palette, "Copy for Chat", slide decks, and dark mode toggle.
*   **Task 5.2: Validate Redirects:**
    *   Use a tool to test a sample of critical URLs from the generated `_redirects` file to confirm they resolve correctly with a 301 status.
*   **Task 5.3: Performance & Accessibility Audit:**
    *   Run Lighthouse audits on key pages (homepage, list page, detail page) and address any issues to achieve a score of 95+.
    *   Perform an accessibility check using browser tools (e.g., Axe) to ensure WCAG 2.1 AA compliance.
*   **Task 5.4: SEO Best Practices:**
    *   Ensure Astro's built-in SEO features are leveraged to generate appropriate `<title>` and `<meta>` tags for all pages.
    *   Generate and include a `sitemap.xml` file.

---

##### **Phase 6: Deployment (Est. 1 Day)**

This final phase involves deploying the site to the production environment.

*   **Task 6.1: Staging Deployment:**
    *   Deploy the `dist/` output to **Surge.sh** for a final round of live testing and stakeholder review.
*   **Task 6.2: Production Deployment:**
    *   Configure a new project on **Cloudflare Pages**.
    *   Link the Git repository and configure the build command (`npm run build`) and output directory (`dist`).
    *   Initiate the first production deployment.
*   **Task 6.3: Post-Launch Verification:**
    *   Verify the live site is functioning as expected.
    *   Perform a final check on a sample of redirects to ensure they are being handled correctly by Cloudflare Pages.

#### **3. High-Level Timeline & Milestones**

This is a projected timeline assuming a focused, full-time effort.

*   **Week 1:**
    *   **Milestone:** Project environment is fully configured. The migration script is complete and has been successfully run. All content is converted and organized into Astro's content collections.
*   **Week 2:**
    *   **Milestone:** The core site structure is built, styled, and fully responsive. Dark mode is functional. All static and dynamic pages render content correctly from the collections.
*   **Week 3:**
    *   **Milestone:** All content sections (Writing, Talks, Teaching) are complete. The Reveal.js slide integration is functional. The `llms.txt` generation and "Copy for Chat" features are implemented.
*   **Week 4:**
    *   **Milestone:** The Command Palette is fully implemented, including context-aware actions. All functional requirements are met.
*   **Week 5:**
    *   **Milestone:** The site has been thoroughly tested, validated, and deployed to production on Cloudflare Pages. All redirects are confirmed to be working. **Project Complete.**

#### **4. Risk Management**

*   **Risk 1: Jade Logic Re-implementation:** The logic in old Jade templates for generating lists and pages must be correctly replicated in Astro.
    *   **Mitigation:** This plan explicitly separates data extraction (script) from logic implementation (Astro pages). By re-implementing the logic natively in Astro using its modern data-fetching APIs, we avoid complex and brittle code conversion, significantly reducing this risk.
*   **Risk 2: Data Inconsistency in Frontmatter (C-3):** The original Docpad files may have inconsistent or missing frontmatter fields.
    *   **Mitigation:** Astro's Content Collection schemas will enforce a strict, type-safe structure. The migration script will log any files that fail schema validation, creating a clear list for manual data cleanup before the final migration run.
*   **Risk 3: Command Palette Complexity (C-4):** Passing context-aware data to the client-side Svelte component requires careful implementation.
    *   **Mitigation:** The technical design addresses this by passing data as JSON props, a standard and well-supported pattern in the Astro framework. This is a known implementation detail, not a significant unknown.