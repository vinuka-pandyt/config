Repo-level instructions override these. My direct instructions override both.

I'm Vinuka Kodituwakku. You're my agent and we'll work together a lot, so here's a but about me. I mainly work on Backend Systems, DevOps and Infra. I love to build and think problems through. I focus on building complex things as simple as possible. I love to find ways to reduce complexity when solving problems. I care about precise implementation details, small diffs, and claims that hold up under technical review.

I want to share some of my preferences here so we can be more aligned as we work together.

## General coding preferences
- Keep things simple.
- Type safety is useful.
- Don't be scared to propose bold ideas that can meaningfully benefit our work.
- Be careful with destructive actions that are not explicitly requested, Always ask me before doing those things. Destructuive actions include any git write operation, file deletions, chaging file permissions, killing processes that you have not created and etc ...
- Tests are good. Endless smoke tests, regression tests for feature deletions, etc.
  are much less good. Tests should be focused, not slop.
- Comments are a great way to clarify functions and how code is used. Don't comment every line, but feel free to concisely describe how functions are used above function definitions, classes, etc. Keep comments up to date when making changes. It's important to keep things in sync.

## Coding preferences for Typescript
- If your Typescript code looks like a python dev wrote it, it's bad Typescript code.
- Avoid oneliners that are just casting wrappers.
- Write TypeScript in ways that Matt Pocock and Theo would be proud of.
- Inspire from the mattpocock/skills when writing or working in a typescript codebase.

When creating a new web application unless I explicitly say the tech stack, use the below given tech stack.
- Use NEXTjs with bun
- If a database is needed use postgresql as the database unless I explicitly say the database
- Use redis for all the key value requirements
- If the application needs auth load the auth skill to handle the authentication requirements
- Use Zustand for state management, Tanstack for query and ArkType for validation

## Coding preferences for Rust
- When building a rust project which is an application from scratch use the scaffolding-axum-services skill
- No `unsafe` without asking. If approved, add a `// SAFETY:` comment.
- Doc comments on public items. Keep them in sync with the code.
- Web services: Axum with typed extractors and `ValidatedJson`. Keep handlers thin.

## Questions are read-only
When I ask a question about the code or project, answer it. Don't edit files,
run fixes, or start implementing unless I ask you to.

## Match ceremony to the task
Do not spawn subagents or multi-agent panels for work a single agent finishes in one pass. Delegation is for breadth or adversarial review, not for ordinary tasks. If several agents do work in parallel, state file ownership upfront so they don't collide.

<!-- CODEGRAPH_START -->
## CodeGraph

In repositories indexed by CodeGraph (a `.codegraph/` directory exists at the repo root), reach for it BEFORE grep/find or reading files when you need to understand or locate code:

- **MCP tool** (when available): `codegraph_explore` answers most code questions in one call — the relevant symbols' verbatim source plus the call paths between them, including dynamic-dispatch hops grep can't follow. Name a file or symbol in the query to read its current line-numbered source. If it's listed but deferred, load it by name via tool search.
- **Shell** (always works): `codegraph explore "<symbol names or question>"` prints the same output.

If there is no `.codegraph/` directory, skip CodeGraph entirely — indexing is the user's decision.
<!-- CODEGRAPH_END -->

## Handling Jira tikckets

I may sometimes give you tickets that are poorly written by bad software enginners, heck even somtimes the QA team. So don't treat that ticket as the ultimate guideline ask the questions that you need to ask about the ticket before assusming that the ticket is correct in describing what they need. Think that ticket in my thinking pattern and breakdown on what they are trying to say rather than assume that they know what they are talking about.
