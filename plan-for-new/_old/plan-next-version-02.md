# url

https://aistudio.google.com/prompts/1AadYCDB8bYLOuylLf2O3RgK-Sv-zA4l4


### **Project Implementation Plan: Website Migration**

#### **Guiding Principles**

*   **Automation-First:** The migration of over 100 content files will be scripted to minimize manual error and ensure consistency. Manual cleanup is for exceptions, not the rule.
*   **Accessibility by Design:** Accessibility (WCAG 2.1 AA) will be a consideration from the initial component construction, not an audit left to the end. Semantic HTML and keyboard navigability are baseline requirements.
*   **Content-First Architecture:** The final site structure must allow new content to be added simply by creating a new Markdown file, with no code changes required (NFR-11).
*   **Performance is a Feature:** The site must be highly performant, targeting a Lighthouse score of 95+ on key pages (NFR-4).

---

#### **Phase 1: Core Prototype & Foundation (1-2 Weeks)**

**Goal:** To rapidly develop a minimal, functional version of the new site using the Astro and Svelte stack. This prototype will validate the core architecture, demonstrate the content collection structure, and be deployable for stakeholder review using a small, manually created set of sample content.

*   **1.1. Project Initialization:**
    *   Initialize a new Astro project.
    *   Install and configure all core dependencies: Svelte and Tailwind CSS.
    *   Establish the foundational directory structure: `src/content/`, `src/layouts/`, `src/components/`, `src/pages/`, and `public/`.

*   **1.2. Content Schema & Sample Data:**
    *   Define the Astro Content Collection schemas for `writing`, `talks`, and `teaching` as specified in the requirements (3.2).
    *   Manually create 2-3 sample Markdown files for each collection. These files will serve as the canonical examples of the new content format.

*   **1.3. Basic Page & Layout Construction:**
    *   Create a primary `Layout.astro` component that includes the basic HTML shell, header, and footer, built with semantic HTML and accessibility in mind from the start.
    *   Implement a clean, modern header component with the author's name and contact info (FR-3).
    *   Build the dynamic list pages:
        *   `/writing`: Fetches and lists sample publications from the content collection (FR-4).
        *   `/talks`: Fetches and lists sample talks (FR-9).
    *   Build the dynamic detail page templates:
        *   `src/pages/writing/[...slug].astro`: Renders a single publication, displaying its metadata and Markdown content (FR-5, FR-6, FR-7).

*   **1.4. Foundational Styling:**
    *   Translate the design ethos from the legacy `style.css.styl` file into a new Tailwind CSS configuration.
    *   Apply this foundational styling to align with the minimalist, `zed.dev`-inspired aesthetic (NFR-2). Focus on typography, layout, and readability for the prototype pages.

*   **1.5. Prototype Deployment:**
    *   Deploy the prototype site to a staging environment (e.g., Netlify, Vercel) for review and feedback.

**Deliverable for Phase 1:** A live URL of the prototype site demonstrating the new technology, file structure, and basic look and feel.

---

#### **Phase 2: Feature Implementation (2-3 Weeks)**

**Goal:** To build the key interactive and functional enhancements specified in the requirements, transforming the prototype into a feature-complete site (still using the sample data).

*   **2.1. Command Palette Implementation:**
    *   Integrate the `shadcn-svelte` Svelte library.
    *   Develop the command palette Svelte component, triggered by `Cmd/Ctrl+K` (FR-19).
    *   Implement fuzzy search to navigate to all sample content pages (FR-20).
    *   Implement context-aware actions for the publication page (e.g., "Copy BibTeX," "Download PDF") by passing data from Astro to the Svelte component (FR-21).

*   **2.2. LLM & Utility Features:**
    *   Create the "Copy for Chat" Svelte component and add it to the publication and talk page templates (FR-18).
    *   Modify the build process to generate the `llms.txt` file from the content collections (FR-17, NFR-9).
    *   Migrate the `hashme-q3.html` utility into a new Astro page, preserving its functionality (FR-22).

*   **2.3. Navigation and UX Refinement:**
    *   Implement the persistent sidebar navigation component (FR-2).
    *   Add the JavaScript required for the sidebar to intelligently highlight the current section on scroll.
    *   Thoroughly test and refine the site's responsiveness across mobile, tablet, and desktop viewports (NFR-1).

**Deliverable for Phase 2:** The prototype URL updated with all new features (Command Palette, LLM tools, sidebar) fully functional.

---

#### **Phase 3: Automated Content & Asset Migration (2-3 Weeks)**

**Goal:** To develop, execute, and verify the automated script that will migrate all content from the legacy Docpad site into the new Astro content structure, including the generation of a complete redirect map.

*   **3.1. Pre-Migration Analysis & Schema Refinement:**
    *   Audit the CSON frontmatter across all source files (`.jade`, `.html.md`, `.html`) to identify all unique fields and inconsistencies (C-3).
    *   Define a canonical and strict YAML schema for each content collection (`writing`, `talks`, `teaching`).
    *   Create a "migration rulebook" to programmatically handle data inconsistencies (e.g., standardizing date formats, handling missing authors, mapping old fields to new ones).

*   **3.2. Develop Migration Script:**
    *   Create a Node.js script to handle the migration tasks based on the rulebook from 3.1.
    *   **Task 1: Parsing:** Read all source `.jade`, `.html.md`, and `.html` files from the legacy `src/documents/` directory.
    *   **Task 2: Frontmatter Conversion:** Convert CSON frontmatter to the new, standardized YAML schema, applying the rules defined in the pre-migration analysis.
    *   **Task 3: Content Body Conversion:** Convert `.jade` syntax to Markdown/HTML. This is a high-risk task; the script must flag any files that use complex logic and require manual intervention (C-1).
    *   **Task 4: File Structure Mapping:** Write the new `.md` files to the correct content collection directories (`src/content/writing/`, etc.).
    *   **Task 5: Asset Handling:** Copy all associated assets (PDFs, images) to the `public/` directory, ensuring they can be correctly referenced from the new content files.
    *   **Task 6: Redirect Map Generation:** Create a `_redirects` file that maps all legacy URLs (e.g., `/writing/joint_action_development.html`) to their new, clean Astro URLs (e.g., `/writing/joint-action-development/`) to ensure permanent (301) redirects are implemented (NFR-12, NFR-13).

*   **3.3. Execute, Verify, and Refine Migration:**
    *   Run the migration script on the entire Docpad source.
    *   **Crucial Step:** Manually review and clean up every file flagged by the script, and spot-check a significant sample of the automatically converted files against the live legacy site to ensure content fidelity.
    *   Build the Astro site with the full set of migrated content and debug any issues that arise.

**Deliverable for Phase 3:** A local, fully populated website with all historical content and assets migrated and rendering correctly, plus a complete `_redirects` file.

---

#### **Phase 4: Finalization, Slide Migration & Launch (1-2 Weeks)**

**Goal:** To address the final complex feature (slide decks), conduct comprehensive testing, and deploy the completed website to production.

*   **4.1. Handle `deck.js` Slide Decks (FR-13):**
    *   **Recommended (Option B):** Migrate slide content to a modern, responsive framework like Reveal.js, integrated via a simple Astro component. This provides the best long-term value.
    *   **Contingency (Option A):** If time is critical, copy the legacy slide decks as-is and embed them using `<iframe>`s on the talk pages.

*   **4.2. Comprehensive Testing and Optimization:**
    *   **Component Testing:** Write unit/integration tests for the Svelte interactive components (Command Palette, Copy for Chat) using a framework like Vitest to ensure their logic is sound.
    *   **End-to-End (E2E) Testing:** Use a framework like Playwright or Cypress to test critical user journeys: navigating between sections, using the command palette to find a paper, downloading a PDF, and verifying a talk page renders correctly.
    *   **Redirect Testing:** Systematically test a sample of URLs from the `_redirects` map to confirm they correctly 301 redirect to the new pages.
    *   **Performance Audit:** Run Lighthouse performance tests on key pages (homepage, a publication, a talk) and optimize to achieve a score of 95+ (NFR-4).
    *   **Accessibility Audit:** Conduct a full audit using Axe tools to ensure WCAG 2.1 AA compliance (NFR-6).
    *   **Cross-Browser & Device Testing:** Perform final checks on the latest versions of major browsers (Chrome, Firefox, Safari) and on representative mobile and tablet devices.

*   **4.3. Optional Enhancements:**
    *   Implement a dark mode option if the core project is on schedule, as per NFR-3.

*   **4.4. Production Deployment:**
    *   Finalize the production build process (`npm run build`).
    *   Deploy the final, static output to the production hosting provider (NFR-8).
    *   Update DNS records to point the domain to the new site.

**Deliverable for Phase 4:** The live, public-facing website, fully migrated, functional, performant, and accessible.