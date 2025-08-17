### **Phase 3 Plan: Core Site Build, Layout & Styling**

**Objective:** To build the visual and structural shell of the website. By the end of this phase, you will have a fully styled, responsive website with a functional dark mode. All the content migrated in Phase 2 will be correctly displayed on the homepage, list pages, and individual detail pages.

**Estimated Time:** 4 Days

---

#### **Introduction for the Developer**

Now that we have all our content neatly organized and standardized, it's time to build the house it will live in. In this phase, we'll use Astro's powerful features to create the main layouts, pages, and navigation. We'll bring the `zed.dev`-inspired design to life with Tailwind CSS and implement a professional dark mode.

This is where you'll see the magic of Astro's component-based architecture. We'll create reusable layouts and components that make the site incredibly easy to manage. You'll learn how Astro uses file-based routing to create pages and how it can dynamically generate hundreds of pages from our Markdown content with just one file.

---

#### **Task 3.1: Build the Base Layouts**

**Goal:** Create a master template (`BaseLayout.astro`) that will contain the common HTML structure for every page on the site (like the `<head>`, header, and footer).

**Steps:**

1.  **Create `BaseLayout.astro`:**
    Inside the `src/layouts/` directory, create a new file named `BaseLayout.astro`.

2.  **Add the HTML Boilerplate:**
    This component will define the main structure of every page. The `<slot />` tag is a special Astro tag that acts as a placeholder where the content of individual pages will be injected.

    *Copy this code into `src/layouts/BaseLayout.astro`:*
    ```astro
    ---
    // src/layouts/BaseLayout.astro
    interface Props {
      title: string;
    }

    const { title } = Astro.props;
    ---
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width" />
        <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
        <title>{title}</title>
        <!-- We will add the dark mode script here in a later task -->
      </head>
      <body class="bg-white dark:bg-slate-900 text-slate-800 dark:text-slate-200">
        <header>
          <!-- Header content will go here later -->
        </header>
        <main>
          <slot /> <!-- Page content will be injected here -->
        </main>
        <footer>
          <!-- Footer content will go here later -->
        </footer>
      </body>
    </html>
    ```

3.  **Create a Content-Specific Layout:**
    Create another file, `src/layouts/PageLayout.astro`. This layout will use the `BaseLayout` and provide specific styling for our content pages (like publications and talks).

    *Copy this code into `src/layouts/PageLayout.astro`:*
    ```astro
    ---
    // src/layouts/PageLayout.astro
    import BaseLayout from './BaseLayout.astro';
    interface Props {
      title: string;
    }
    const { title } = Astro.props;
    ---
    <BaseLayout title={title}>
      <article class="prose prose-slate dark:prose-invert max-w-3xl mx-auto p-4">
        <h1>{title}</h1>
        <slot /> <!-- The Markdown body content will go here -->
      </article>
    </BaseLayout>
    ```

**Rationale:**
*   **Layouts** are a core concept in Astro. They allow us to reuse page structure without duplicating code. The `<slot />` is the key mechanism for this, allowing layouts to "wrap" around page content.
*   We've used Tailwind's `prose` classes in `PageLayout.astro`. This is a fantastic feature that automatically applies beautiful typographic styling to blocks of text rendered from Markdown, saving us a lot of time.

---

#### **Task 3.2: Implement Pages and Routing**

**Goal:** Create the actual pages of the site. We'll make a homepage that lists recent content and a single "template" file that will dynamically generate a unique page for every single publication.

**Steps:**

1.  **Create the Homepage:**
    Create a new file at `src/pages/index.astro`. This file will automatically become the homepage of the site.

    *Add this code to `src/pages/index.astro`:*
    ```astro
    ---
    // src/pages/index.astro
    import BaseLayout from '../layouts/BaseLayout.astro';
    import { getCollection } from 'astro:content';

    // Get the 5 most recent publications
    const recentWriting = (await getCollection('writing')).sort(
      (a, b) => b.data.pubDate.valueOf() - a.data.pubDate.valueOf()
    ).slice(0, 5);
    ---
    <BaseLayout title="Stephen Butterfill | Home">
      <div class="p-8">
        <h2 class="text-2xl font-bold mb-4">Recent Writing</h2>
        <ul>
          {recentWriting.map(item => (
            <li class="mb-2">
              <a href={`/writing/${item.slug}/`} class="text-blue-600 dark:text-blue-400 hover:underline">
                {item.data.title} ({item.data.year})
              </a>
            </li>
          ))}
        </ul>
        <!-- We will add the sidebar and other sections here later -->
      </div>
    </BaseLayout>
    ```

2.  **Create the Dynamic Route for Publications:**
    This is the most powerful step. We will create *one* file that generates *all* the individual publication pages.
    *   Create a new file at `src/pages/writing/[...slug].astro`. The square brackets `[]` tell Astro that this is a dynamic route.

    *Add this code to `src/pages/writing/[...slug].astro`:*
    ```astro
    ---
    // src/pages/writing/[...slug].astro
    import { getCollection } from 'astro:content';
    import PageLayout from '../../layouts/PageLayout.astro';

    // This function runs at build time to find all publications
    // and tell Astro to create a page for each one.
    export async function getStaticPaths() {
      const writingEntries = await getCollection('writing');
      return writingEntries.map(entry => ({
        params: { slug: entry.slug },
        props: { entry },
      }));
    }

    const { entry } = Astro.props;
    const { Content } = await entry.render(); // This gets the Markdown content
    ---
    <PageLayout title={entry.data.title}>
      <div class="mb-4 text-sm text-slate-600 dark:text-slate-400">
        <p><strong>Authors:</strong> {entry.data.authors}</p>
        <p><strong>Published:</strong> {entry.data.year}</p>
        {entry.data.journal && <p><strong>Journal:</strong> {entry.data.journal}</p>}
        {entry.data.doi && <p><a href={`http://dx.doi.org/${entry.data.doi}`} target="_blank">DOI: {entry.data.doi}</a></p>}
      </div>
      <Content /> <!-- This renders the main body of the Markdown file -->
    </PageLayout>
    ```

3.  **Test Your Work:**
    Run `npm run dev` in your terminal. You should be able to see your homepage at `http://localhost:4321`. Clicking on a publication link should take you to a fully rendered page for that publication.

**Rationale:**
*   **File-based Routing:** In Astro, any `.astro` file inside `src/pages/` becomes a page on your site. `index.astro` is the root page.
*   **`getStaticPaths`:** This is the key to Astro's static site generation. The function you wrote queries the `writing` content collection (which we set up in Phase 2) and returns a list of pages that Astro needs to build. It's incredibly efficient because it runs once at build time.

---

#### **Task 3.3: Implement Core Styling & Dark Mode**

**Goal:** Apply the `zed.dev` aesthetic using Tailwind CSS and implement a fully functional, system-aware dark mode.

**Steps:**

1.  **Apply Basic Styles:**
    Go through the layouts and pages you've created (`BaseLayout.astro`, `index.astro`, etc.) and use Tailwind's utility classes to style them. Focus on creating a clean, professional, and text-focused look. Use margins (`m-`), padding (`p-`), font sizes (`text-xl`), and colors (`text-slate-800`, `dark:text-slate-200`).

2.  **Implement the Dark Mode Script:**
    The best way to handle dark mode is with a small script that runs before the page loads to prevent any "flash" of the wrong theme.

    *Add this `<script>` tag inside the `<head>` of your `src/layouts/BaseLayout.astro` file:*
    ```html
    <script is:inline>
      // This script is executed as-is, before the page is rendered.
      const theme = (() => {
        if (typeof localStorage !== 'undefined' && localStorage.getItem('theme')) {
          return localStorage.getItem('theme');
        }
        if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
          return 'dark';
        }
        return 'light';
      })();

      if (theme === 'dark') {
        document.documentElement.classList.add('dark');
      } else {
        document.documentElement.classList.remove('dark');
      }
    </script>
    ```

**Rationale:**
*   **Utility Classes:** Using Tailwind classes directly in your HTML is fast and keeps your styling co-located with your structure, making components easy to understand and modify.
*   **`is:inline` script:** The `is:inline` directive tells Astro to not process or bundle this script. This is crucial for the dark mode switcher, as it needs to run immediately to set the `dark` class on the `<html>` tag *before* the browser starts painting the page, thus avoiding a flicker of the light theme.

---

#### **Task 3.4: Build Navigation Components**

**Goal:** Create the persistent sidebar navigation for the homepage and implement the "scroll-spying" logic to highlight the current section.

**Steps:**

1.  **Create the Sidebar Component:**
    Create a new file at `src/components/Sidebar.astro`.

    *Add this code to `src/components/Sidebar.astro`:*
    ```astro
    ---
    // src/components/Sidebar.astro
    const navItems = [
      { href: '#writing', label: 'Writing' },
      { href: '#talks', label: 'Talks' },
      { href: '#teaching', label: 'Teaching' },
      { href: '#about', label: 'About' },
    ];
    ---
    <nav class="sticky top-8">
      <ul id="sidebar-nav">
        {navItems.map(item => (
          <li>
            <a href={item.href} class="block p-2 rounded hover:bg-slate-200 dark:hover:bg-slate-700">
              {item.label}
            </a>
          </li>
        ))}
      </ul>
    </nav>
    ```

2.  **Add the Sidebar to the Homepage:**
    Update `src/pages/index.astro` to use a two-column layout and include your new sidebar.

3.  **Implement Scroll-Spying:**
    Add a client-side script to your `Sidebar.astro` component to handle the highlighting.

    *Add this `<script>` tag to the bottom of `src/components/Sidebar.astro`:*
    ```javascript
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        const sections = document.querySelectorAll('main section[id]');
        const navLinks = document.querySelectorAll('#sidebar-nav a');

        const observer = new IntersectionObserver((entries) => {
          entries.forEach(entry => {
            if (entry.isIntersecting) {
              navLinks.forEach(link => {
                link.classList.toggle('font-bold', link.getAttribute('href') === `#${entry.target.id}`);
                link.classList.toggle('bg-slate-100', link.getAttribute('href') === `#${entry.target.id}`);
                link.classList.toggle('dark:bg-slate-800', link.getAttribute('href') === `#${entry.target.id}`);
              });
            }
          });
        }, { rootMargin: "-50% 0px -50% 0px" }); // Triggers when a section is in the middle of the viewport

        sections.forEach(section => observer.observe(section));
      });
    </script>
    ```

**Rationale:**
*   **`IntersectionObserver`:** This is a modern browser API that is much more performant than listening for `scroll` events. It allows the browser to efficiently tell us when an element (like our `#writing` section) enters the viewport, which is exactly what we need for our scroll-spying feature. This is a perfect example of how Astro lets us use standard, client-side web APIs for simple interactivity.

---

#### **Required Files from Old Codebase**

*   `src/documents/index.html.jade`: Look at this file to understand the structure of the old homepage. Your new `index.astro` will serve the same purpose but will be built with modern components. Pay attention to how it lists publications and talks; you will replicate this by fetching from your content collections.
*   `src/layouts/default.html.jade`: This shows the overall HTML structure of the old site. Your `BaseLayout.astro` replaces this, but it's useful to see what was there before.

---

#### **Definition of Done for Phase 3**

This phase is complete when:

*   [ ] `BaseLayout.astro` and `PageLayout.astro` are created and functional.
*   [ ] The homepage (`index.astro`) correctly fetches and displays a list of recent publications.
*   [ ] Dynamic pages for all publications are generated correctly at `/writing/[slug]/`.
*   [ ] The site is fully styled with Tailwind CSS and is responsive on mobile and desktop.
*   [ ] Dark mode is implemented and correctly responds to system preferences on first load.
*   [ ] The sidebar navigation is present on the homepage and correctly highlights the active section as the user scrolls.