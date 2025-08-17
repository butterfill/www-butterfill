
# update


### **Revised Plan for Phase 2 (with correct file paths)**

Here is the updated, detailed plan for Phase 2. I have adjusted the code snippets to reflect the correct directory structure.

**Objective:** To write and execute a one-time Node.js script that automatically reads all content from `www-butterfill-old`, transforms it, and organizes it into the `www-butterfill-new` project.

**Estimated Time:** 5 Days

---

#### **Prerequisites: Setting Up Your Scripting Environment**

(This part remains the same. Run this command inside the `www-butterfill-new` directory if you haven't already).

```bash
npm install -D fs-extra cson-parser pug yaml
```

---

#### **Task 2.1: Script Setup & File Discovery**

**Goal:** Create the migration script and make it capable of finding all the content files in the `www-butterfill-old` directory.

**Steps:**

1.  **Create the Script File:**
    Inside the `www-butterfill-new` directory, create a new file named `migration-script.mjs`.

2.  **Import Dependencies and Define Paths:**
    Add the following lines at the top of `migration-script.mjs`. Note the updated paths that point from the new project to the old one.

    ```javascript
    import fs from 'fs-extra';
    import path from 'path';
    import CSON from 'cson-parser';
    import pug from 'pug';
    import yaml from 'yaml';

    // Path to the source content in the OLD project directory
    const OLD_CONTENT_DIR = '../www-butterfill-old/src/documents';

    // Path to the destination content in the NEW project directory
    const NEW_CONTENT_DIR = 'src/content';
    const PUBLIC_DIR = 'public';
    ```

3.  **Implement File Discovery:**
    This function will now correctly look inside the `www-butterfill-old` directory.

    ```javascript
    async function findSourceFiles() {
      // Note: The path must exist relative to where you run the script.
      if (!await fs.pathExists(OLD_CONTENT_DIR)) {
        console.error(`Error: Source directory not found at ${path.resolve(OLD_CONTENT_DIR)}`);
        console.error('Please make sure the www-butterfill-old directory is in the same parent folder as www-butterfill-new.');
        process.exit(1);
      }
      const allFiles = await fs.readdir(OLD_CONTENT_DIR, { recursive: true });
      return allFiles.filter(file => {
        const fullPath = path.join(OLD_CONTENT_DIR, file);
        return fs.statSync(fullPath).isFile() &&
               (file.endsWith('.html') || file.endsWith('.html.md') || file.endsWith('.jade'));
      });
    }
    ```

---

*(The rest of the plan from the previous response follows from here **SEE BELOW**, as the internal logic for parsing, transformation, and asset handling remains the same. The key change was establishing the correct location for the script and the correct relative paths for its input and output.)*

#### **Required Files from Old Codebase**

The list of files for the developer to inspect remains the same. They will need to look inside the `www-butterfill-old` directory to find them. For example, they will look at `www-butterfill-old/src/documents/writing/joint_action_development.html`.

---

#### **Definition of Done for Phase 2**

This phase is complete when:

*   [ ] The `www-butterfill-new/migration-script.mjs` has been written and successfully runs without errors from the `www-butterfill-new` directory.
*   [ ] The `www-butterfill-new/src/content/` directory is populated with `writing`, `talks`, and `teaching` subdirectories.
*   [ ] Each subdirectory contains new `.md` files corresponding to the old content files.
*   [ ] Each new `.md` file has valid YAML frontmatter that conforms to the schemas defined in `src/content/config.ts`.
*   [ ] All relevant assets (PDFs, slide images) have been copied from `www-butterfill-old` to the `www-butterfill-new/public/` directory.
*   [ ] A complete `www-butterfill-new/public/_redirects` file has been generated.


# previous plan


### **Phase 2 Plan: Content & Data Migration**

**Objective:** To write and execute a one-time Node.js script that automatically reads all content from the old Docpad site, transforms it into a modern format (Markdown with YAML frontmatter), and organizes it perfectly for our new Astro project.

**Estimated Time:** 5 Days

---

#### **Introduction for the Developer**

This phase is the heart of the migration. We're going to build a powerful tool—a migration script—that will do the heavy lifting for us. Think of it as a smart assembly line: on one end, we feed it the old, complex files (`.jade`, `.html.md`), and on the other, we get clean, simple Markdown files that Astro can understand.

This is a **one-time script**. It won't be part of the final website, but it's a critical tool for building it. The goal is **automation over manual labor**. Taking the time to build this script properly will save us countless hours of manual copy-pasting and prevent human error. We'll tackle this step-by-step, building up the script's capabilities as we go.

#### **Prerequisites: Setting Up Your Scripting Environment**

Before you start, you'll need a few Node.js packages to help with parsing the old file formats. In your terminal, at the root of your project, run this command:

```bash
npm install -D fs-extra cson-parser pug yaml
```

*   **`fs-extra`**: A powerful tool for working with files and directories.
*   **`cson-parser`**: To parse the CSON frontmatter used by Docpad.
*   **`pug`**: The successor to Jade, which we'll use to process `.jade` files.
*   **`yaml`**: To convert our JavaScript objects into clean YAML frontmatter for the new files.

---

#### **Task 2.1: Script Setup & File Discovery**

**Goal:** Create the basic structure of our migration script and make it capable of finding all the content files we need to process.

**Steps:**

1.  **Create the Script File:**
    In the root of your project, create a new file named `migration-script.mjs`. Using the `.mjs` extension makes it easier to use modern JavaScript features like `import`.

2.  **Import Dependencies:**
    Add the following lines at the top of `migration-script.mjs`:

    ```javascript
    import fs from 'fs-extra';
    import path from 'path';
    import CSON from 'cson-parser';
    import pug from 'pug';
    import yaml from 'yaml';

    const OLD_CONTENT_DIR = 'src/documents';
    const NEW_CONTENT_DIR = 'src/content';
    ```

3.  **Implement File Discovery:**
    Write a function that walks through the `src/documents` directory and finds all the files we care about (`.html`, `.html.md`, and `.jade`).

    ```javascript
    async function findSourceFiles() {
      const allFiles = await fs.readdir(OLD_CONTENT_DIR, { recursive: true });
      return allFiles.filter(file => {
        const fullPath = path.join(OLD_CONTENT_DIR, file);
        // We only want files, not directories, and only specific types
        return fs.statSync(fullPath).isFile() &&
               (file.endsWith('.html') || file.endsWith('.html.md') || file.endsWith('.jade'));
      });
    }
    ```

**Rationale:**
*   The first step in any migration is to get a list of what needs to be migrated. This function gives us a complete inventory of content files, ignoring layouts, styles, and other files we don't need to convert directly.

---

#### **Task 2.2: Frontmatter Parsing & Transformation**

**Goal:** For each file, read the old CSON frontmatter and convert it into a structured JavaScript object that matches our new, standardized schema.

**Steps:**

1.  **Extract the Frontmatter:**
    Write a helper function that takes a file's content as a string and splits it into two parts: the frontmatter block (between the `---` lines) and the body content.

2.  **Parse CSON to a JavaScript Object:**
    Use the `cson-parser` library to convert the CSON string into a JavaScript object.

3.  **Transform the Data (The Core Logic):**
    Create a function that takes the parsed CSON object and transforms it into our new, clean schema. This is where you'll apply the mapping rules.

    *Pseudo-code for the transformation logic:*
    ```javascript
    function transformFrontmatter(oldData, oldFilePath) {
      const newData = {};

      newData.title = oldData.title || 'Untitled';
      newData.authors = oldData.authors || 'Unknown';
      // Standardize the date to YYYY-MM-DD format for Astro
      if (oldData.date) {
        newData.pubDate = new Date(oldData.date).toISOString().split('T')[0];
      } else {
        // Fallback if no date is present
        newData.pubDate = new Date().toISOString().split('T')[0];
      }
      newData.year = oldData.year || new Date(newData.pubDate).getFullYear();

      // Add other fields like journal, booktitle, etc., checking if they exist
      if (oldData.journal) newData.journal = oldData.journal;
      // ... and so on for all fields in your schema from Phase 1.

      return newData;
    }
    ```

**Rationale:**
*   The old website used CSON for its metadata, which is not standard in modern tools. We are converting it to YAML, which is the standard for Astro and most other static site generators.
*   By creating a single `transformFrontmatter` function, we ensure that every single piece of content, regardless of its original format, is standardized. This directly addresses the "Data Consistency" risk (C-3) and makes the rest of our website code much simpler.

---

#### **Task 2.3: Content Body Handling**

**Goal:** Process the main content of each file, converting it to a simple format (HTML or Markdown) that can be placed after the new YAML frontmatter.

**Steps:**

1.  **Handle Markdown and HTML Files:**
    For files ending in `.html.md` or `.html`, the body content you extracted in Task 2.2 can be used directly without any changes.

2.  **Handle Jade/Pug Files:**
    This is the most important part of this task. The old `.jade` files contain logic we don't want to replicate in the script. Our goal is only to **extract the core written content**.
    *   Use the `pug` library to render the body content of the Jade file into an HTML string.
    *   **Important:** Do not try to render the entire file. You only need to render the part *after* the frontmatter block. The Pug renderer will ignore layout-specific logic like `extends layout` if it's not given the context for it, which is exactly what we want.

    *Example Snippet:*
    ```javascript
    // 'jadeBodyContent' is the string content from the .jade file after the '---' block
    const htmlBody = pug.render(jadeBodyContent);
    ```

**Rationale:**
*   As clarified in the Q&A, the logic for creating lists and page structures (e.g., in `index.html.jade`) will be re-implemented natively in Astro in Phase 3. The migration script's job is simplified: it just needs to turn the content of each individual publication or talk into a block of HTML. This is a robust strategy that avoids brittle code conversion.

---

#### **Task 2.4: Asset Handling & Validation**

**Goal:** Find all associated PDFs and slide images, copy them to the new `public/` directory, and update the frontmatter object with the correct new paths.

**Steps:**

1.  **Set Up Asset Directories:**
    In your script, ensure the target directories exist: `public/pdf/`, `public/img/talks/`, etc. Use `fs.ensureDirSync()`.

2.  **Handle PDFs for Publications:**
    For each `writing` document, determine the expected PDF path.
    *   Get the basename of the source file (e.g., `joint_action_development`).
    *   Construct the path to the old PDF (e.g., `src/files/pdf/joint_action_development.pdf`).
    *   **Use `fs.existsSync()` to check if the PDF file actually exists.**
    *   If it exists, copy it to `public/pdf/` and add `pdfUrl: '/pdf/joint_action_development.pdf'` to your `newData` frontmatter object.

3.  **Handle Slide Images for Talks:**
    For each `talks` document, check if the old frontmatter has `deckslides: true`.
    *   If it does, find the corresponding image directory (e.g., `src/documents/img/talks/heidelberg_2011/`).
    *   Create a new directory in `public/img/talks/heidelberg_2011/`.
    *   Copy all images from the old directory to the new one.
    *   Create an array of the new public paths (e.g., `['/img/talks/heidelberg_2011/slide1.jpg', ...]`) and add it to your `newData` frontmatter object as `slideImages`.

**Rationale:**
*   The `public/` directory in Astro is for static assets that are copied directly to the final build without processing. This is the correct place for PDFs and images.
*   By checking for the existence of a PDF before adding the link to the frontmatter, we fulfill the requirement from the Q&A and prevent broken links on the new site.

---

#### **Task 2.5: Redirect Generation**

**Goal:** Create a `_redirects` file that will tell Cloudflare how to redirect all old URLs to their new locations, preserving SEO value.

**Steps:**

1.  **Initialize a Redirects Array:**
    At the start of your script, create an empty array: `const redirects = [];`.

2.  **Generate Rules During File Processing:**
    Inside your main loop for each file, determine the old and new URLs.
    *   *Old URL:* This can be constructed from the file's path relative to `src/documents/`. For example, `writing/joint_action_development.html` becomes `/writing/joint_action_development.html`.
    *   *New URL:* This will be based on the new content collection structure. For example, `/writing/joint-action-development/`.
    *   Push a formatted string to your array: `redirects.push('/writing/joint_action_development.html /writing/joint-action-development/ 301');`.

3.  **Write the Redirects File:**
    After your main loop has processed all files, join the array with newlines and write it to `public/_redirects`.

    ```javascript
    await fs.writeFile('public/_redirects', redirects.join('\n'));
    ```

**Rationale:**
*   A 301 redirect tells search engines that a page has moved permanently. This is the standard and best practice for preserving any existing SEO ranking. The format `/old-path /new-path 301` is specifically required by Cloudflare Pages (and also works for Netlify), as decided in the Q&A.

---

#### **Task 2.6: Final Script Execution**

**Goal:** Combine all the pieces into a single, runnable script that performs the entire migration.

**Steps:**

1.  **Structure the Main Function:**
    Create a `main` async function that orchestrates all the steps:
    *   Clear the `src/content` directory to ensure a fresh start—but be sure to leave `config.ts`!
    *   Call `findSourceFiles()`.
    *   Loop through each source file.
    *   Inside the loop:
        *   Read the file content.
        *   Extract and parse the frontmatter.
        *   Transform the frontmatter.
        *   Process the body content.
        *   Handle any associated assets (PDFs, images), updating the frontmatter object as you go.
        *   Generate the redirect rule for this file.
        *   Convert the final frontmatter object to a YAML string.
        *   Combine the new YAML frontmatter and the processed body content.
        *   Write the new `.md` file to the correct location in `src/content/`.
    *   After the loop, write the final `_redirects` file.

2.  **Run the Script:**
    Execute the script from your terminal:

    ```bash
    node migration-script.mjs
    ```

3.  **Validate the Output:**
    Manually inspect a few files in `src/content/writing/`, `src/content/talks/`, etc. Check that the YAML frontmatter looks correct and that the body content is present. Also, review the `public/_redirects` file to ensure the paths look correct.

---

#### **Required Files from Old Codebase**

To build and test your script, you will need to reference a variety of file types. Focus on these examples:

*   **Standard Publication (HTML):** `src/documents/writing/joint_action_development.html`
*   **Standard Publication (Jade):** `src/documents/writing/minimal_theory_of_mind.html.jade`
*   **Talk with PDF Assets (Jade):** `src/documents/talks/2012/heidelberg_2011.html.jade`
*   **Talk with Image Deck (Jade):** `src/documents/talks/2014/joint_action_warwick.html.jade`
*   **Teaching Course (Jade):** `src/documents/teaching/mindreading_and_joint_action.html.jade`
*   **Layout File (for context, not processing):** `src/layouts/publication.html.jade` (Look at this to understand the *structure* your script is helping to replace, but your script should not process this file itself).

---

#### **Definition of Done for Phase 2**

This phase is complete when:

*   [ ] The `migration-script.mjs` has been written and successfully runs without errors.
*   [ ] The `src/content/` directory is populated with `writing`, `talks`, and `teaching` subdirectories.
*   [ ] Each subdirectory contains new `.md` files corresponding to the old content files.
*   [ ] Each new `.md` file has valid YAML frontmatter that conforms to the schemas defined in `src/content/config.ts`.
*   [ ] All relevant assets (PDFs, slide images) have been copied to the `public/` directory.
*   [ ] A complete `public/_redirects` file has been generated, mapping all old URLs to their new locations.