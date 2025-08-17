
## Project: Website Migration from Docpad to Astro (Svelte Edition)

### 1. Project Overview

**1.1. Goal:**
To migrate the personal academic website of Stephen Butterfill from the legacy Docpad static site generator to the modern Astro framework.

**1.2. Scope:**
The project includes:
*   **Preservation:** Replicating all existing content, structure, and core functionality of the current website.
*   **Modernization:** Rebuilding the site with a new, maintainable technology stack centered around Astro and Svelte.
*   **Enhancement:** Implementing a set of new features to improve user experience, maintainability, and utility for modern applications (e.g., Large Language Models).

**1.3. Guiding Principles:**
*   **Automation over Manual Labor:** The migration process for existing content should be scripted to the greatest extent possible to ensure accuracy and efficiency.
*   **Content-First:** The new architecture must make adding and updating content (publications, talks, etc.) as simple as adding a Markdown file.
*   **Performance and Readability:** The final site must be fast, responsive on all devices, and highly readable, adhering to a clean, professional aesthetic.

---

### 2. Core Technology Stack

**2.1. Primary Framework:**
*   **Requirement:** The website will be built using **Astro**.
*   **Justification:** Astro is ideal for content-heavy static sites, offering excellent performance ("zero JS by default"), a component-based architecture, and first-class support for Markdown/MDX and multiple UI frameworks, including Svelte.

**2.2. Content Format:**
*   **Requirement:** All primary content (publications, talks, teaching pages, etc.) will be stored in **Markdown (`.md`)** or **MDX (`.mdx`)** files with YAML frontmatter.
*   **Justification:** This decouples content from presentation, simplifies content creation, and is the standard for modern static site generators. MDX will be used if Svelte components need to be embedded directly within content.

**2.3. Styling:**
*   **Requirement:** A new, consistent styling system will be implemented to meet the design goals.
*   **Tailwind CSS:** A utility-first CSS framework that aligns perfectly with the component-based nature of Astro and the aesthetic of `zed.dev`.
*   **Justification:**  Tailwind CSS best fits the "low key, highly readable, somewhat nerdy" requirement.

**2.4. Interactivity:**
*   **Requirement:** Interactive elements ("islands of interactivity") will be built using **Svelte** components, integrated via Astro. For very simple cases, Vanilla JS may be used.
*   **UI Library:** Use **shadcn-svelte** (which relies on **Bits UI**), a Svelte UI library, for complex components like the command palette.
*   Simpler interactive elements can be custom Svelte components.

---

### 3. Content & Data Migration Strategy

**3.1. Automated Migration Script:**
*   **Requirement:** A one-time script (e.g., Node.js) must be developed to automate the conversion of existing content.
*   **Script Responsibilities:**
    1.  **Parse Source Files:** Read all `.jade` and `.html.md` files from the `src/documents/` directory.
    2.  **Extract Frontmatter:** Parse the CSON frontmatter from the source files and convert it to standard YAML for the new Markdown files.
    3.  **Standardize Frontmatter:** Define and enforce a consistent schema for frontmatter across different content types (e.g., `writing`, `talks`, `teaching`). This includes standardizing date formats.
    4.  **Convert Content Body:**
        *   For `.html.md` files, the Markdown body can be used directly.
        *   For `.jade` files, the script must convert Jade syntax to Markdown/HTML. This is a critical and potentially complex step.
    5.  **Create New File Structure:** Organize the new Markdown files into Astro's `src/content/` collections structure (e.g., `src/content/writing/`, `src/content/talks/`).
    6.  **Handle Static Assets:** Copy over related assets like PDFs and images, maintaining their associations with the new content files.

**3.2. Target Content Structure:**
*   **Requirement:** The migration will result in the following content collections:
    *   `src/content/writing/`: One Markdown file per publication.
    *   `src/content/talks/`: One Markdown file per talk.
    *   `src/content/teaching/`: One Markdown file per course.
*   **Frontmatter Schema Example (for a publication):**
    ```yaml
    ---
    title: 'Joint Action and Development'
    authors: 'Stephen A. Butterfill'
    year: 2011
    isForthcoming: false
    journal: 'Philosophical Quarterly'
    volume: 62
    # ... other metadata
    pdf: true # Indicates a PDF exists at /pdf/joint_action_development.pdf
    doi: '10.1111/j.1467-9213.2011.00005.x'
    ---
    ## Abstract
    ...

    <!-- Full text of the paper in Markdown will follow -->
    ```

---

### 4. Functional Requirements (Features)

**4.1. General Site Structure & Navigation (Preservation & Enhancement)**
*   **FR-1:** The site must have a main homepage (`/`) that serves as a dashboard, listing recent publications and providing navigation to all major sections.
*   **FR-2:** A persistent sidebar navigation component must be present on the homepage, linking to the main sections (Writing, Talks, etc.). This sidebar should intelligently highlight the current section when scrolling.
*   **FR-3:** The header section must be redesigned to be cleaner and more modern, containing the author's name, contact info, and a brief bio.

**4.2. Writing / Publications Section (Enhancement)**
*   **FR-4:** The `/writing` page (or a section on the homepage) must list all publications, sorted chronologically (newest first).
*   **FR-5:** Each publication must have its own dedicated page (e.g., `/writing/joint-action-development/`).
*   **FR-6:** The publication page must display all relevant metadata (title, authors, journal, year, DOI, etc.) in a clean, standardized format.
*   **FR-7:** The publication page must display the full text of the paper, rendered from its corresponding Markdown file.
*   **FR-8:** The publication page must provide a clear link to download the associated PDF.

**4.3. Talks Section (Preservation & Enhancement)**
*   **FR-9:** The `/talks` page (or a section on the homepage) must list all talks, separated into "Future" and "Recent" sections, sorted chronologically.
*   **FR-10:** Each talk with an abstract or slides must have its own dedicated page.
*   **FR-11:** The talk page must display all relevant metadata (title, event, location, date).
*   **FR-12:** The talk page must provide links to download handouts and slides (PDFs).
*   **FR-13 (Slide Previews):** The existing `deck.js` slide functionality must be preserved.
    *   **Option A (Low Effort):** Keep the existing generated HTML slide decks as static assets and embed them in an `<iframe>` on the talk page.
        *   **Pros:** Very fast to implement, guarantees preservation of the exact look.
        *   **Cons:** Not responsive, uses legacy technology (jQuery), not maintainable.
    *   **Option B (High Effort, Recommended):** Migrate the slide content (images) to a modern slide framework like Reveal.js (which is framework-agnostic) or a simple Astro/Svelte component.
        *   **Pros:** Modern, responsive, maintainable, better performance.
        *   **Cons:** Requires more development effort during migration.

**4.4. Teaching Section (Preservation & Enhancement)**
*   **FR-14:** The `/teaching` page (or a section on the homepage) must list all courses.
*   **FR-15:** Each course must have its own page, displaying the course description and a list of lectures.
*   **FR-16:** Each lecture must provide links to its materials (handouts, slides, YouTube videos).

**4.5. LLM Integration (New Feature)**
*   **FR-17 (`llms.txt`):** The build process must generate a single `llms.txt` file in the root of the output directory. This file must contain:
    1.  A preamble identifying the site and author.
    2.  A structured concatenation of the full text of every publication, clearly demarcated.
*   **FR-18 ("Copy for Chat" Button):** Every publication and talk page must feature a "Copy for Chat" button.
    *   When clicked, this button will copy a formatted plain-text version of the page's content to the user's clipboard.
    *   The format should be optimized for pasting into an LLM prompt, including the title, authors, abstract, and full text, with clear headings.

**4.6. Command Palette (New Feature)**
*   **FR-19:** A command palette must be implemented using a Svelte component (from **shadcn-svelte** which relies on **Bits UI**), accessible via a keyboard shortcut (e.g., `Cmd+K` / `Ctrl+K`).
*   **FR-20:** The palette must provide a fuzzy-search interface for navigating to any page on the site (publications, talks, etc.).
*   **FR-21 (Context-Aware Actions):** When opened on a publication page, the command palette must include specific actions for that publication, such as:
    *   "Download PDF"
    *   "Copy BibTeX Citation"
    *   "Copy Full Text"

**4.7. Utility Pages (Preservation)**
*   **FR-22 (`hashme`):** The `hashme-q3.html` utility must be preserved with identical functionality. It should be an Astro page with its client-side JavaScript included inline or as a Svelte component.

---

### 5. Non-Functional Requirements

**5.1. Styling & User Experience (UX):**
*   **NFR-1:** The design must be fully responsive, providing an excellent experience on mobile, tablet, and desktop screens.
*   **NFR-2:** The aesthetic should be inspired by `zed.dev`: minimalist, professional, text-focused, and "nerdy". High readability is paramount.
*   **NFR-3:** A dark mode option should be considered and implemented if time permits.

**5.2. Performance:**
*   **NFR-4:** The site must achieve a Lighthouse performance score of 95+ for all static pages.
*   **NFR-5:** Page loads should be near-instantaneous, leveraging Astro's static generation and partial hydration. This is further enhanced by Svelte's compile-time approach, which minimizes the amount of client-side JavaScript shipped to the browser.

**5.3. Accessibility:**
*   **NFR-6:** The site must adhere to WCAG 2.1 AA standards. This includes semantic HTML, proper color contrast, and keyboard navigability for all elements, including the command palette.

**5.4. Build Process & Deployment:**
*   **NFR-7:** The build process must be simple, executed via a single `npm run build` command.
*   **NFR-8:** The output must be a fully static site (HTML, CSS, JS, assets) deployable to any static hosting provider (e.g., Netlify, Vercel, S3).
*   **NFR-9:** The build process must include the generation of the `llms.txt` file.

**5.5. Maintainability:**
*   **NFR-10:** The new codebase must be well-structured and easy to understand.
*   **NFR-11:** Adding a new publication, talk, or course should require only the creation of a new Markdown file and its associated assets (e.g., PDF), with no changes to layout code.

---

### 6. Potential Challenges & Risks

*   **C-1: Jade to Markdown/HTML Conversion:** The `.jade` files contain logic and specific syntax that may not have a direct 1-to-1 mapping in Markdown or Astro components. The automated script may handle 80-90% of cases, but manual review and cleanup of each converted file will likely be necessary.
*   **C-2: `deck.js` Slide Preservation:** The existing slide functionality is dependent on jQuery and a specific set of CSS files. Integrating this legacy system into a modern Astro site could be complex. The `iframe` approach (Option A) is safer but provides a poorer user experience. The full migration (Option B) is better but adds significant scope.
*   **C-3: Data Consistency:** The frontmatter in the original files may be inconsistent. The migration script must be robust enough to handle variations or a manual data cleaning phase may be required before running the script.
*   **C-4: Command Palette Complexity:** The context-aware actions for the command palette require passing page-specific data to a client-side Svelte component, which requires careful state management and prop passing within Astro's island architecture.

---

### 7. Out of Scope

*   **Server-Side Rendering (SSR):** The site will be fully static. No server-side logic will be implemented.
*   **Content Management System (CMS):** Content will be managed directly via Markdown files in the Git repository. No external CMS will be integrated.
*   **New Content Creation:** This project covers only the migration of existing content. No new publications, talks, or other content will be created as part of this project.