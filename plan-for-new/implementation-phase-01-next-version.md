### **Phase 1 Plan (Revised): Foundation & Environment Setup**

**Objective:** To create a new, fully configured Astro project that will serve as the foundation for the website migration. By the end of this phase, you will have a clean, version-controlled codebase with all necessary tools for styling, interactivity, and content management installed and ready to use.

**Estimated Time:** 2 Days

---

#### **Introduction for the Developer**

Welcome to the project! This first phase is about setting up our workshop. We'll be creating the new project from scratch and installing all the modern tools we'll need. This plan is designed to guide you step-by-step. Don't worry if Astro is new to you; each step includes a "Rationale" section to explain *why* we're doing things a certain way. This will help you get up to speed with the core concepts of Astro quickly.

---

#### **Task 1.1: Initialize the Astro Project**

**Goal:** Create a new Astro project, integrate Svelte for interactivity, and set up version control with Git.

**Steps:**

1.  **Create the Astro Project:**
    Open your terminal in an empty directory and run the following command. This will launch an interactive setup wizard.
    ```bash
    npm create astro@latest
    ```

2.  **Follow the Setup Prompts:**
    When prompted, use these answers:
    *   Where would you like to create your new project? `.` (This creates it in the current directory)
    *   Which template would you like to use? `Empty`
    *   Would you like to install dependencies? `Yes`
    *   Would you like to use TypeScript? `Strict`
    *   Would you like to initialize a new git repository? `Yes`

3.  **Add Svelte Integration:**
    Once the initial setup is complete, run the following command to add Svelte support. Astro will automatically handle the configuration.
    ```bash
    npx astro add svelte
    ```
    Confirm "yes" to all prompts (install dependencies, update config).

**Rationale:**
*   We are using **Astro** because it is excellent for content-heavy sites, shipping zero JavaScript by default for fast performance.
*   We are adding **Svelte** because the project requires interactive "islands" like a command palette, and you already have some familiarity with it. Astro's integration system makes it easy to use Svelte components where needed without slowing down the rest of the site.

---

#### **Task 1.2: Install & Configure Core Dependencies**

**Goal:** Set up our styling framework (Tailwind CSS) and the UI component library (`shadcn-svelte`).

**Steps:**

1.  **Add Tailwind CSS:**
    Run the Astro command to add Tailwind CSS. This will install the necessary packages and create the configuration files for you.
    ```bash
    npx astro add tailwind
    ```
    Confirm "yes" to all prompts. This will create `tailwind.config.mjs` and `postcss.config.cjs`. It will also create a global CSS file at `src/styles/tailwind.css`.

2.  **Install `shadcn-svelte`'s Animation Dependency:**
    The `shadcn-svelte` components use a helper library for animations. Install it with:
    ```bash
    npm install -D tailwindcss-animate
    ```

3.  **Configure TypeScript Path Alias (The Fix):**
    The `shadcn-svelte` tool uses a path alias (a shortcut) called `$lib` to refer to the `src/lib` directory. We need to tell TypeScript what this shortcut means *before* we run the initializer.
    *   Open the `tsconfig.json` file located in the root of your project.
    *   Inside the `compilerOptions` object, add the `"baseUrl"` and `"paths"` properties as shown below.

    ```jsonc
    // tsconfig.json
    {
      "extends": "astro/tsconfigs/strict",
      "compilerOptions": {
        // Add these two properties:
        "baseUrl": ".",
        "paths": {
          "$lib": ["src/lib"],
          "$lib/*": ["src/lib/*"]
        }
      }
    }
    ```

4.  **Initialize `shadcn-svelte`:**
    Now that TypeScript is configured, run the `shadcn-svelte` initialization command:
    ```bash
    npx shadcn-svelte init
    ```

5.  **Follow the `shadcn-svelte` Prompts:**
    When prompted, use these answers:
    *   Would you like to use TypeScript (recommended)? `Yes`
    *   Which style would you like to use? `Default`
    *   Which color would you like to use as base color? `Slate`
    *   Where is your `tailwind.config.js` located? `tailwind.config.mjs`
    *   Where is your global CSS file located? `src/styles/tailwind.css`
    *   Do you want to use CSS variables for colors? `Yes`
    *   Where are your components located? `$lib/components`
    *   Where are your utils located? `$lib/utils`

**Rationale:**
*   **Path Alias:** The `paths` configuration in `tsconfig.json` is a standard TypeScript feature that lets us create import shortcuts. Instead of writing `import MyComponent from '../../../../lib/components/MyComponent.svelte'`, we can write `import MyComponent from '$lib/components/MyComponent.svelte'`. This is cleaner and less prone to breaking if we move files around. The `shadcn-svelte` tool relies on this convention.

---

#### **Task 1.3: Establish the Project Directory Structure**

**Goal:** Create the standard folder structure for an Astro project, ensuring our code is organized logically from the start.

**Steps:**

1.  **Create the Core Directories:**
    In your terminal, create the following folders inside the `src/` directory. The `lib` and `styles` folders should already exist from the previous steps.

    ```
    src/
    ├── components/      # For reusable Astro/Svelte components
    ├── content/         # For our Markdown content collections
    └── layouts/         # For page layouts/templates
    ```

**Rationale:**
*   `src/components`: This is where we'll put reusable UI pieces, like the `CommandPalette.svelte` or a `Slides.astro` component.
*   `src/content`: This is a special Astro directory. It's where we will store all the website's content (publications, talks, etc.) as Markdown files. Astro treats this folder like a database, giving us a powerful and type-safe way to query our content.
*   `src/layouts`: These are Astro components that wrap around our pages to provide a consistent structure, like a header and footer.

---

#### **Task 1.4: Define Content Collection Schemas**

**Goal:** Define the "schema" for each type of content (writing, talks, teaching). This is like defining the structure of a database table and is one of Astro's most powerful features. It will prevent errors and make our code much easier to work with.

**Steps:**

1.  **Create the Configuration File:**
    Create a new file at `src/content/config.ts`.

2.  **Define the Schemas:**
    Copy and paste the following code into `src/content/config.ts`. This code uses the **Zod** library (which Astro includes) to define the expected fields and data types for the frontmatter of our Markdown files.

    ```typescript
    import { defineCollection, z } from 'astro:content';

    // Schema for 'writing' (publications)
    const writingCollection = defineCollection({
      schema: z.object({
        title: z.string(),
        authors: z.string(),
        pubDate: z.date(),
        year: z.number(),
        isForthcoming: z.boolean().optional(),
        journal: z.string().optional(),
        booktitle: z.string().optional(),
        volume: z.string().optional(),
        number: z.string().optional(),
        pages: z.string().optional(),
        doi: z.string().optional(),
        pdfUrl: z.string().optional(), // Will only be present if a PDF exists
      }),
    });

    // Schema for 'talks'
    const talksCollection = defineCollection({
      schema: z.object({
        title: z.string(),
        authors: z.string(),
        pubDate: z.date(),
        endDate: z.date().optional(),
        event: z.string().optional(),
        address: z.string().optional(),
        handoutUrl: z.string().optional(),
        slidesUrl: z.string().optional(),
        slideImages: z.array(z.string()).optional(), // For Reveal.js slide decks
      }),
    });

    // Schema for 'teaching' (courses)
    const teachingCollection = defineCollection({
        schema: z.object({
            title: z.string(),
            year: z.string(),
            term: z.string(),
            authors: z.string(),
            place: z.string(),
            abstract: z.string(),
            // Defines an object where keys are strings (e.g., '01') and values are strings (lecture titles)
            lectures: z.record(z.string()),
        }),
    });

    export const collections = {
      'writing': writingCollection,
      'talks': talksCollection,
      'teaching': teachingCollection,
    };
    ```

**Rationale:**
*   **Astro Content Collections** allow us to treat our Markdown files like a database. By defining a schema with **Zod**, Astro will automatically validate every `.md` file we add. If a file is missing a required field (like `title`) or has the wrong data type (like a string for `year` instead of a number), Astro will give us a clear error during development. This completely solves the risk of "Data Consistency" (C-3) mentioned in the project documents.

---

#### **Required Files from Old Codebase**

To help you understand the data we'll be working with in the next phase, you should review the frontmatter (the block of text between the `---` lines) of the following files from the old codebase. This will show you where the fields in the schemas you just created come from.

*   **Publication Example:** `src/documents/writing/joint_action_development.html`
    *   *Purpose:* Shows typical metadata for a journal article, including `doi` and `pdf: true`.
*   **Talk Example (with Slides):** `src/documents/talks/2012/heidelberg_2011.html.jade`
    *   *Purpose:* Shows metadata for a talk, including `event`, `handout: true`, and `slides: true`.
*   **Talk Example (with Deckslides):** `src/documents/talks/2014/joint_action_warwick.html.jade`
    *   *Purpose:* This is an example of a talk that used the old `deck.js` system. The presence of `deckslides: true` is the trigger we will use to look for a folder of images to create a new Reveal.js deck.
*   **Teaching Example:** `src/documents/teaching/mindreading_and_joint_action.html.jade`
    *   *Purpose:* Shows the structure for a course, including the `lectures` object which maps lecture numbers to titles.

---

#### **Definition of Done for Phase 1**

This phase is complete when all of the following are true:

*   [ ] A new Astro project exists and is initialized as a Git repository.
*   [ ] The Svelte integration has been added (`npx astro add svelte`).
*   [ ] The Tailwind CSS integration has been added (`npx astro add tailwind`).
*   [ ] The `tsconfig.json` file has been updated with the correct `baseUrl` and `paths` for `$lib`.
*   [ ] `shadcn-svelte` has been initialized (`npx shadcn-svelte init`).
*   [ ] The project contains the following directories: `src/components`, `src/content`, `src/layouts`.
*   [ ] The file `src/content/config.ts` exists and contains the Zod schemas for the `writing`, `talks`, and `teaching` collections as specified above.
*   [ ] The project runs without errors when you start the development server with `npm run dev`.

Once these tasks are complete, the project foundation is solid and ready for the content migration in Phase 2. Good luck