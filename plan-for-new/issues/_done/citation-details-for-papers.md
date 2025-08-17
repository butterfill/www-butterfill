Write a script to 
  (i) filter only entries with butterfill as one of the authors from `phd_biblio.bib` to create `publications_butterfill.bib`; 
  (ii) match the titles of publications to the bibtex entries from the filtered list; and 
  (iii) thereby add the correct bibtex entries to each publication. Also provide a list of entries in `publications_butterfill.bib` which are not in the `src/content/writing` folder; and 
  (iv) offer to generate entries in that folder for each of the missing publications (nb user must be able to select which subset of missing publications to create entries for).

Having done this, update the code for the new site so that (i) full publication details are provided, and (ii) there is a button to download the citation info, and a command pallet option to download the citation info.


# prompt

Of course. Here is a revised and improved version of your prompt.

### Why this version is better:

*   **Clearer Structure:** It's organized into logical sections (`Persona`, `Context`, `High-Level Goal`, `Core Requirements`, `Key Features`) which makes it easier for the model to understand the request.
*   **More Specificity:** It provides more concrete details, such as suggesting the use of a specific library for user prompts (`prompts` or `inquirer`) and for creating tables (`console.table`).
*   **Action-Oriented Language:** The prompt uses more direct and action-oriented language, which is generally more effective for language models.
*   **Emphasis on Best Practices:** It includes a section on code quality and best practices, which will help ensure the generated code is maintainable and robust.
*   **"Bonus" Section:** The "Bonus" section encourages the model to go a step further by suggesting additional features that would make the script even more useful.

Here is the improved prompt:

***

### **Prompt:**

You are an expert Node.js developer tasked with creating a command-line interface (CLI) script for managing a static Astro.js and Svelte website.

**Context:**

*   The codebase is for a static site built with Astro and Svelte.
*   The script will be located in the `scripts/` directory.
*   The script will manage publication files located in `src/content/writing/`.
*   The schema for the frontmatter of these files is defined in `src/content/config.ts`.
*   A BibTeX file containing all publications is located at `~/endnote/phd_biblio.bib`.
*   You may use the '@orcid/bibtex-parse-js' library (already installed)

**High-Level Goal:**

Create a Node.js CLI script that synchronizes the BibTeX file with the content files in `src/content/writing/`. The script will update existing files, create new ones, and report on the status of the content.

**Core Requirements:**

1.  **Idempotency:** The script must be safely re-runnable without causing errors or creating duplicate content.
2.  **User Confirmation:** The script must **always** preview the proposed changes (creations, updates) and prompt the user for confirmation before writing any files. Use a `[Y]es/[S]kip/[Q]uit` pattern for user input. Consider using a library like `prompts` or `inquirer` for a better user experience.
3.  **Input Paths:** The paths to the BibTeX file (`~/endnote/phd_biblio.bib`) and the content directory (`src/content/writing/`) can be hardcoded.
4.  **Technology:**
    *   The script should be written in modern JavaScript or TypeScript.
    *   Use the `bib-filter.js` library to parse and filter the BibTeX file.
    *   Use `console.table` or a similar library to display tabular data in a clean and readable format.
5.  **Matching Logic:** Use the `title` field to match BibTeX entries with the corresponding files in `src/content/writing/`.

**Key Features:**

1.  **Update Existing Content:**
    *   For each file in `src/content/writing/` that has a matching entry in the BibTeX file, the script should:
        *   Check the YAML frontmatter for a `bibtex` field.
        *   If the `bibtex` field is missing, add it.
        *   If the `bibtex` field exists but is different from the BibTeX entry, update it.

2.  **Create New Content:**
    *   For each entry in the BibTeX file that does not have a corresponding file in `src/content/writing/`, the script should offer to create a new file.
    *   When creating a new file, the script must:
        *   Adhere to the schema defined in `src/content/config.ts`.
        *   Pre-fill as much of the YAML frontmatter as possible from the BibTeX data.
        *   Include the abstract in the body of the new file, if available.

3.  **Reporting:**
    *   The script should generate a report of all files in `src/content/writing/` that do not have a matching entry in the BibTeX file.
    *   The script should also generate a report of all files in `src/content/writing/` that are missing a `pdfUrl` in their frontmatter.

**Bonus Features (Optional):**

*   Add a "fuzzy matching" capability to suggest possible matches for titles that are similar but not identical.
*   Include an option to "dry run" the script to see all proposed changes without being prompted for each one.

Please generate the complete, well-documented code for this CLI script.



# old

You are working on an astro+svelte codebase which builds a static site.

We are going to write an new CLI script in scripts/. This script’s purpose is to add to, and update, the files in src/content/writing. Each of those files represents a publication.

The script’s inputs are (i) the path `~/endnote/phd_biblio.bib` (which can be hardcoded) and the path `src/content/writing/`

The CLI script will always show the user exactly what it is about to do and ask for confirmation (yes/skip/quit). No actions involving writing to files will be taken without explicit approval.

The CLI script will be designed so that it can be re-run without causing errors or duplication.

The CLI script will use the `bib-filter.js` library on `~/endnote/phd_biblio.bib` in order to extract a list of bibtex entries for consideration.

The CLI script will use titles to match entries in bibtex with entries in `src/content/writing/`.

The functions of the script are as follows:
  - where there is an file in `src/content/writing/` already, the script will (i) add if missing, or update if changed, the `bibtex` field of the yaml frontmatter with the corresponding bibtex entry.
  - for those files in `src/content/writing/` for which there are no bibtex entries, the script will present a neatly formatted table including all relevant metadata.
  - where there is an entry in the bibtex file but no corresponding file in `src/content/writing/`, the script will offer to create one. In implementing this function, be sure to check the exact requirements for yaml metadata, and all other formatting. You can scan the codebase to find examples; there is also a schema in `config.ts`. The script will provide the maximum possible frontmatter and, if possible, the abstract.
  - The script will also produce tables of those files in `src/content/writing/` which are missing `pdfUrls`.