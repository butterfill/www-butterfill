# url

- https://aistudio.google.com/prompts/1-M0p7CmeaSSqam3wrwJVMyD3_AWCjM4E

# notes

I use the plan as a prompt for executing the task.

I used qwen (rovodev very few tokens left). Experience:
  - Qwen did a great job of the tests. Even extras like checking linting.
  - Qwen got a bit carried away after getting the tests written and wanted to write extra tests: stopped and told to move on to next step.
  - Had difficulty getting the json-ld to render but did a great job of trying out fixes and using `npm run build` plus `grep` to see what worked. 



# plan

We are working on an astro+svelte static site using tailwind v3. This is mostly working but we are adding features.

The site is available at `http://localhost:4321/` (do not `npm run dev`, as your updates will be reflected here; just `curl` if you need to check anything.)

Below you will see a plan. We want to add json-ld data so that the content of our site can be widely used.  The plan will enable us to do this.

Your task is to execute Step 1 of the plan.


### **Plan: Test-Driven JSON-LD Implementation**

This plan begins with the creation of a comprehensive test suite. These tests will fail initially and will guide the development of the implementation, ensuring all requirements and edge cases are met before any code is integrated into the live pages.

---

#### **Step 1: Set Up the Testing Environment**

Before writing tests, we need a framework. We will use Vitest, a modern, fast testing framework that integrates seamlessly with Vite-based projects like Astro.

vitest is already installed. We have "test": "vitest" as our `test` in `package.json`.
    
*   **Action:** Create a Vitest configuration file (`vitest.config.ts`) in the project root to set up the testing environment. This ensures it works correctly with Astro's path aliases (`$lib`).

---

#### **Step 2: Write the Test Suite (The "Red" Phase)**

We will create a test file that defines the expected behavior of our yet-to-be-written utility functions. This file will serve as the executable specification for the feature.

*   **New File:** `src/lib/jsonld-utils.test.ts`
*   **Action:** Create `describe` blocks for each major function to be implemented in `jsonld-utils.ts`.
*   **Action:** Write specific, failing tests (`it(...)`) for each requirement and edge case.

**Test Cases for `formatContributors`:**

*   `it('should correctly format a single "First Last" name')`
*   `it('should correctly format a "Last, First" name')`
*   `it('should handle multiple authors separated by " and "')`
*   `it('should correctly parse names with LaTeX accents like "Vigan{\\`o}, Luca"')`
*   `it('should handle names with protective braces like "{della Gatta}, Francesco"')`
*   `it('should handle a mix of simple and complex names in a single string')`
*   `it('should return an array of Schema.org Person objects')`

**Test Cases for `parsePageRange`:**

*   `it('should parse a simple hyphenated range like "23-47"')`
*   `it('should parse a range with an en-dash like "123–148"')`
*   `it('should parse a range with a double-hyphen like "53--60"')`
*   `it('should handle a single page number like "104601"')`

**Test Cases for `generateJsonLd` (Main Function):**

*   **`describe('for ScholarlyArticle (writing)')`:**
    *   `it('should generate the correct @type and @context')`
    *   `it('should map title, author, and datePublished correctly')`
    *   `it('should create an absolute URL for the page')`
    *   `it('should create a "Periodical" for isPartOf when a journal is present')`
    *   `it('should create a "Book" for isPartOf when a booktitle is present')`
    *   `it('should include a DOI as an identifier and sameAs link')`
    *   `it('should create an absolute URL for the PDF in the encoding property')`
    *   `it('should omit properties for missing data (e.g., no DOI, no PDF)')`

*   **`describe('for EducationalEvent (talks)')`:**
    *   `it('should generate the correct @type for a talk')`
    *   `it('should format startDate and endDate as ISO strings')`
    *   `it('should create a Place object for the location')`
    *   `it('should create an Organization object for the event organizer')`
    *   `it('should correctly populate the speaker property')`
    *   `it('should include handout and slides URLs in hasPart')`

*   **`describe('for CourseInstance (teaching)')`:**
    *   `it('should generate a nested Course within a CourseInstance')`
    *   `it('should use the external URL for the Course if provided')`
    *   `it('should correctly parse the provider name from the "place" field')`
    *   `it('should map the "lectures" object to an array of CreativeWork objects in hasPart')`
    *   `it('should construct a descriptive name for the CourseInstance from title, term, and year')`

*   **Initial State:** Running `npm test` at this point will result in errors because the functions and the file `src/lib/jsonld-utils.ts` do not exist yet. This confirms the "Red" phase of TDD.

---

#### **Step 3: Implement the Utility (`src/lib/jsonld-utils.ts`) (The "Green" Phase)**

Now, we write the code with the explicit goal of making all the tests pass.

*   **Action:** Create the file `src/lib/jsonld-utils.ts`.
*   **Action:** Implement the `formatContributors` function. Run `npm test` repeatedly until all author-related tests pass.
*   **Action:** Implement the `parsePageRange` function. Run tests until they pass.
*   **Action:** Implement the `createScholarlyArticle`, `createEducationalEvent`, and `createCourseInstance` helper functions one by one.
*   **Action:** Implement the main `generateJsonLd` function that calls the helpers.
*   **Process:** Continue implementing and refining the logic until `npm test` reports that all tests are passing. This iterative process ensures each piece of logic is correct before moving to the next.

---

#### **Step 4: Integrate and Validate (The "Refactor" and Final Verification Phase)**

With the core logic verified by unit tests, we can confidently integrate it into the Astro components.

*   **Action:** Modify the three page templates (`src/pages/{writing,talks,teaching}/[...slug].astro`) to import and use the `generateJsonLd` function, passing the resulting object to the `PageLayout`.
*   **Action:** Modify `BaseLayout.astro` to accept the `jsonLd` prop and render the `<script>` tag in the `<head>`.
*   **Action: End-to-End Validation.** This is the final, crucial verification step.
    1.  Run the development server (`npm run dev`).
    2.  Visit one of each type of page (an article, a talk, a course).
    3.  **View Source** and verify the `<script type="application/ld+json">` tag is present and contains the expected, correctly formatted JSON.
    4.  Copy the content of the script tag and paste it into the **Schema.org Validator**.
    5.  Take the live URL from the dev server (e.g., `http://localhost:4321/writing/collective_goals/`) and test it with **Google's Rich Results Test**.
    6.  Use the **Zotero Connector** browser extension on each page type to confirm that it correctly identifies the content and imports it with the expected metadata and attached PDF.

---

### **Revised Risk Assessment**

The test-driven approach significantly mitigates the primary risks.

*   **Risk 1 (High -> Low): Parsing Fragility.**
    *   **Mitigation:** The risk is now low because the behavior for all known edge cases is explicitly defined in the test suite *before* implementation. The implementation is not "done" until it passes these tests.

*   **Risk 2 (Medium -> Low): Schema Complexity & Correctness.**
    *   **Mitigation:** The unit tests will verify the exact structure of the generated JSON objects, including nested properties, ensuring they match Schema.org's requirements before they are ever rendered in the browser.

*   **Risk 3 (Low): Integration Issues.** A unit-tested function might still be used incorrectly in the Astro components.
    *   **Mitigation:** The final end-to-end validation step (Step 4) is designed to catch these issues by testing the final rendered HTML with external tools.

---

### **Revised Definition of Done**

The task is complete when:

1.  **Test Suite:**
    *   [ ] A comprehensive test suite exists in `src/lib/jsonld-utils.test.ts` covering all specified requirements and edge cases.
    *   [ ] All tests in the suite pass (`npm test` reports success).

2.  **Code Implementation:**
    *   [ ] The `src/lib/jsonld-utils.ts` utility is fully implemented and all its functions are documented.
    *   [ ] The Astro page and layout files are updated to integrate the utility.

3.  **Validation:**
    *   [ ] The generated JSON-LD on representative pages for `writing`, `talks`, and `teaching` **validates without errors** in both the Schema.org Validator and Google's Rich Results Test.

4.  **Functional Goal:**
    *   [ ] The Zotero Connector browser extension successfully and accurately imports citation data and associated PDFs from all three content types.