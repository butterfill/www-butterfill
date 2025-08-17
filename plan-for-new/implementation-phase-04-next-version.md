
### **Phase 4 Plan: Feature Implementation**

**Objective:** To build all the new and enhanced interactive features for the website. By the end of this phase, the site will have a modern slide viewer, powerful LLM-integration tools, a fully functional command palette for navigation, and all required utility pages.

This phase is exciting because it's where we'll build the advanced, interactive features that make the new site truly modern and powerful.


**Estimated Time:** 5 Days

---

#### **Introduction for the Developer**

With the site's structure and content in place, we can now focus on the dynamic and interactive elements. This phase is where your Svelte knowledge will be particularly useful. We'll be creating "islands of interactivity" using Svelte components that live inside our Astro pages. You'll also learn how to run scripts during Astro's build process to generate files automatically, a powerful technique for modern static sites.

---

#### **Task 4.1: Implement Modern Slide Previews (FR-13)**

**Goal:** Replace the old `deck.js` functionality with a modern, responsive slide viewer using Reveal.js. This will be driven by the `slideImages` array we created in the migration script.

**Steps:**

1.  **Install Reveal.js:**
    We need to add the Reveal.js library to our project.

    ```bash
    npm install reveal.js
    ```

2.  **Create the `<Slides.astro>` Component:**
    This component will be responsible for rendering the slide deck. Create a new file at `src/components/Slides.astro`.

    *Copy this code into `src/components/Slides.astro`:*
    ```astro
    ---
    // src/components/Slides.astro
    interface Props {
      images: string[];
    }
    const { images } = Astro.props;
    ---
    <div class="reveal">
      <div class="slides">
        {images.map(src => (
          <section>
            <img src={src} alt="Slide image" />
          </section>
        ))}
      </div>
    </div>

    <!-- We need to import the CSS and initialize the library on the client -->
    <link rel="stylesheet" href="/node_modules/reveal.js/dist/reveal.css">
    <link rel="stylesheet" href="/node_modules/reveal.js/dist/theme/black.css">

    <script>
      import Reveal from 'reveal.js';
      // Initialize Reveal.js on the .reveal container we created above
      let deck = new Reveal(document.querySelector('.reveal'), {
        embedded: true, // Important for controlling it within our page
      });
      deck.initialize();
    </script>
    ```

3.  **Conditionally Render the Component on Talk Pages:**
    Now, we need to edit our dynamic talk page to show the slides *only* if they exist.

    *Open `src/pages/talks/[...slug].astro` and modify it:*
    ```astro
    ---
    // src/pages/talks/[...slug].astro
    import { getCollection } from 'astro:content';
    import PageLayout from '../../layouts/PageLayout.astro';
    import Slides from '../../components/Slides.astro'; // Import the new component

    export async function getStaticPaths() { /* ... (this part stays the same) */ }

    const { entry } = Astro.props;
    const { Content } = await entry.render();
    ---
    <PageLayout title={entry.data.title}>
      {/* ... (existing code for talk metadata) ... */}

      <!-- Conditionally render the Slides component -->
      {entry.data.slideImages && entry.data.slideImages.length > 0 && (
        <div class="my-8">
          <h2 class="text-2xl font-bold mb-4">Slides</h2>
          <Slides images={entry.data.slideImages} />
        </div>
      )}

      <Content />
    </PageLayout>
    ```

**Rationale:**
*   **Component-Based Logic:** We've encapsulated all the slide logic into a single `<Slides.astro>` component. This keeps our page templates clean and makes the slide viewer reusable.
*   **Conditional Rendering:** The `{condition && (...) }` syntax in Astro is a clean way to render HTML only if a certain condition is met. This ensures the "Slides" section doesn't appear on talks that don't have slides.
*   **Client-Side Scripts:** The `<script>` tag in an Astro component (without `is:inline`) is processed and bundled by Astro. This is the standard way to run JavaScript on the client to initialize libraries like Reveal.js.

---

#### **Task 4.2: Implement LLM Integration Features (FR-17, FR-18)**

**Goal:** Create the `llms.txt` file during the build process and add a "Copy for Chat" button to publication and talk pages.

**Steps:**

1.  **Create the Pre-build Script:**
    Create a new folder `scripts/` in the project root. Inside it, create a file named `generate-llms.mjs`. This script will use Astro's content API to read our data.

    *Copy this code into `scripts/generate-llms.mjs`:*
    ```javascript
    import { getCollection } from 'astro:content';
    import fs from 'fs-extra';
    import { stripHtml } from 'string-strip-html';

    const publications = await getCollection('writing');
    let fullText = "Site: Stephen Butterfill's Personal Academic Website\nAuthor: Stephen Butterfill\n\n---\n\n";

    for (const pub of publications) {
      const { Content } = await pub.render();
      // We need the raw text, so we strip HTML tags from the rendered content
      const cleanText = stripHtml(Content).result;

      fullText += `Title: ${pub.data.title}\n`;
      fullText += `Authors: ${pub.data.authors}\n`;
      fullText += `Year: ${pub.data.year}\n\n`;
      fullText += `${cleanText}\n\n---\n\n`;
    }

    await fs.writeFile('public/llms.txt', fullText);
    console.log('Successfully generated llms.txt');
    ```
    *Note:* You'll need to install a helper to remove HTML tags: `npm install string-strip-html`.

2.  **Update the Build Command:**
    Modify the `build` script in your `package.json` file to run our new script before Astro's build command.

    ```json
    // package.json
    "scripts": {
      "dev": "astro dev",
      "start": "astro start",
      "build": "node ./scripts/generate-llms.mjs && astro build",
      "preview": "astro preview"
    },
    ```

3.  **Create the `CopyForChat.svelte` Component:**
    This will be a client-side interactive component. Create a new file at `src/components/CopyForChat.svelte`.

    *Copy this code into `src/components/CopyForChat.svelte`:*
    ```svelte
    <script>
      export let contentToCopy = '';
      let buttonText = 'Copy for Chat';

      async function copyToClipboard() {
        try {
          await navigator.clipboard.writeText(contentToCopy);
          buttonText = 'Copied!';
          setTimeout(() => { buttonText = 'Copy for Chat'; }, 2000);
        } catch (err) {
          console.error('Failed to copy: ', err);
          buttonText = 'Failed to copy';
        }
      }
    </script>

    <button on:click={copyToClipboard} class="px-4 py-2 bg-slate-200 dark:bg-slate-700 rounded hover:bg-slate-300 dark:hover:bg-slate-600">
      {buttonText}
    </button>
    ```

4.  **Integrate the Button into Detail Pages:**
    Update the publication page template (`src/pages/writing/[...slug].astro`) to include the button and pass it the correctly formatted content. You will do the same for the talks page.

    *Add this to `src/pages/writing/[...slug].astro`:*
    ```astro
    ---
    // ... (imports and getStaticPaths)
    import CopyForChat from '../../components/CopyForChat.svelte';
    import { stripHtml } from 'string-strip-html';

    const { entry } = Astro.props;
    const { Content } = await entry.render();

    // Format the content specifically for the clipboard
    const textForLLM = `
    Title: ${entry.data.title}
    Authors: ${entry.data.authors}
    Year: ${entry.data.year}

    ---

    ${stripHtml(Content).result}
    `.trim();
    ---
    <PageLayout title={entry.data.title}>
      <div class="flex justify-end mb-4">
        <CopyForChat contentToCopy={textForLLM} client:load />
      </div>
      {/* ... (rest of the page layout) ... */}
      <Content />
    </PageLayout>
    ```

**Rationale:**
*   **Build-time Generation:** Generating `llms.txt` during the build is highly efficient. The file is created once and then served statically, with no server-side processing needed.
*   **Svelte for Interactivity:** The "Copy for Chat" button is a perfect use case for a Svelte component. It has its own internal state (`buttonText`) and logic that only needs to run on the client. The `client:load` directive tells Astro to load this component's JavaScript as soon as the page loads.

---

#### **Task 4.3: Implement the Command Palette (FR-19 to FR-21)**

**Goal:** Create a global, fuzzy-search command palette for site navigation with context-aware actions.

**Steps:**

1.  **Add the `Command` Component from `shadcn-svelte`:**
    Use the CLI tool to add the necessary component files to your project.

    ```bash
    npx shadcn-svelte add command
    ```

2.  **Create the `CommandPalette.svelte` Wrapper:**
    This will be our main component that contains all the logic. Create it at `src/components/CommandPalette.svelte`. This is a complex component, so we'll start with the basic structure.

3.  **Integrate the Palette into `BaseLayout.astro`:**
    The palette needs to be on every page. The best place for it is the main layout. We also need to feed it a list of all pages on the site.

    *Modify `src/layouts/BaseLayout.astro`:*
    ```astro
    ---
    // src/layouts/BaseLayout.astro
    import CommandPalette from '../components/CommandPalette.svelte';
    import { getCollection } from 'astro:content';

    // Fetch ALL content at build time
    const writing = await getCollection('writing');
    const talks = await getCollection('talks');
    const teaching = await getCollection('teaching');

    // Format it into a simple structure for the command palette
    const allPages = [
      ...writing.map(item => ({ title: item.data.title, url: `/writing/${item.slug}/` })),
      ...talks.map(item => ({ title: item.data.title, url: `/talks/${item.slug}/` })),
      ...teaching.map(item => ({ title: item.data.title, url: `/teaching/${item.slug}/` })),
    ];

    interface Props {
      title: string;
      // Allow pages to pass extra actions
      contextualActions?: { label: string; action: () => void; }[];
    }
    const { title, contextualActions = [] } = Astro.props;
    ---
    <html lang="en">
      <!-- ... -->
      <body>
        <!-- ... -->
        <CommandPalette allPages={allPages} contextualActions={contextualActions} client:load />
      </body>
    </html>
    ```

4.  **Implement Context-Aware Actions:**
    Now, a specific page can pass its own actions to the palette.

    *Example in `src/pages/writing/[...slug].astro`:*
    ```astro
    ---
    // ... (imports)
    const { entry } = Astro.props;
    const pdfUrl = entry.data.pdfUrl;

    // Define actions specific to this page
    const pageActions = [];
    if (pdfUrl) {
      pageActions.push({
        label: 'Download PDF',
        // The action is a string of JS code we'll execute in Svelte
        onSelect: `() => window.open('${pdfUrl}', '_blank')`
      });
    }
    ---
    <PageLayout title={entry.data.title} contextualActions={pageActions}>
      <!-- ... page content ... -->
    </PageLayout>
    ```
    Your Svelte component will then need to be updated to receive and display these `contextualActions`.

**Rationale:**
*   **Global Component:** Placing the command palette in the `BaseLayout` ensures it's available everywhere with a single import.
*   **Build-time Data Fetching:** Astro fetches the list of all pages *at build time* and passes it as a JSON prop to the Svelte component. This is extremely performant. The client doesn't need to make any extra requests; the data is already there when the page loads.
*   **Prop Passing for Context:** The pattern of passing page-specific data down through layouts to a client-side component is a powerful way to handle context-aware UI in Astro.

---

#### **Task 4.4: Recreate Utility Pages (FR-22)**

**Goal:** Re-implement the `hashme-q3.html` utility with identical functionality.

**Steps:**

1.  **Copy Static Assets:**
    Find the old `q3-browser.js` file and place it in the `public/` directory of your new project.

2.  **Create the Astro Page:**
    Create a new file at `src/pages/hashme-q3.astro`.

3.  **Add HTML and Link the Script:**
    Copy the HTML structure from the old `hashme-q3.html` file into your new `.astro` file. You can update the styling with Tailwind classes. Then, link to the JavaScript file.

    *Inside `src/pages/hashme-q3.astro`:*
    ```astro
    ---
    import BaseLayout from '../layouts/BaseLayout.astro';
    ---
    <BaseLayout title="q3-hashme Utility">
      <!-- Paste the old HTML form structure here -->
      <h1>q3-hashme</h1>
      <form>
        <!-- ... form inputs ... -->
      </form>
      <div id="result">...</div>
      <!-- ... etc ... -->

      <!-- Link to the script. Because it's in /public, the path is from the root. -->
      <script src="/q3-browser.js"></script>
    </BaseLayout>
    ```

**Rationale:**
*   For simple, self-contained utilities like this, there's no need for a complex Svelte component. A standard Astro page with a linked client-side script is the simplest and most direct way to preserve the functionality.

---

#### **Required Files from Old Codebase**

*   **For Slides:** `src/layouts/slides.html.jade` (to see how `deck.js` was used) and an example talk directory like `src/documents/img/talks/heidelberg_2011/`.
*   **For LLM Features:** Any publication file with a full body, like `src/documents/writing/joint_action_development.html`.
*   **For Utility Page:** `src/documents/hashme-q3.html` and `src/documents/q3-browser.js`.

---

#### **Definition of Done for Phase 4**

This phase is complete when:

*   [ ] Talks with slide images now display a functional and responsive Reveal.js slide deck.
*   [ ] The `npm run build` command successfully generates a `public/llms.txt` file containing all publication text.
*   [ ] A "Copy for Chat" button is present on all publication and talk pages and successfully copies formatted content to the clipboard.
*   [ ] The command palette can be opened with a keyboard shortcut (`Cmd/Ctrl+K`) on any page.
*   [ ] The palette allows fuzzy searching and navigation to all content pages.
*   [ ] On a publication page with a PDF, the command palette shows a "Download PDF" action that works correctly.
*   [ ] The `/hashme-q3` page is functional and identical in behavior to the old version.