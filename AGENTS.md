# AGENTS.md — Night of the Sigbin

Project-level rules for any AI agent working in this repository.
These add to, and never override, the global rules in `~/.config/opencode/AGENTS.md`.

---

## 1. Git is READ-ONLY. Do not commit. Do not push.

**Default stance: the agent never commits, stages, pushes, merges, rebases, tags, stashes, resets, or otherwise mutates this repository's git state.** Not as a checkpoint, not "while we're here", not to keep the tree tidy, not because a task seems finished.

This is not a style preference. The human owns the commit history and the GitHub remote. Commits carry authorship, timing, and messages that must reflect the human's decisions, and pushes are visible to other people. An agent creating either is making a decision that was not delegated to it.

### Forbidden unless the human explicitly asks for it in the current message

| Command | Status |
|---|---|
| `git commit`, `git commit --amend` | Forbidden |
| `git push`, `git push --force`, `git push -u` | Forbidden |
| `git add`, `git stage`, `git rm --cached` | Forbidden |
| `git merge`, `git rebase`, `git cherry-pick`, `git revert` | Forbidden |
| `git reset`, `git restore`, `git checkout -- <path>`, `git clean` | Forbidden |
| `git tag`, `git branch -d`, `git branch -m` | Forbidden |
| `git stash` / `git stash pop` | Forbidden |
| `git config` (user.name, user.email, remotes, hooks) | Forbidden |
| `gh pr create`, `gh release create`, `gh repo edit` | Forbidden |
| Deleting or moving `.git/` | Forbidden |
| Editing files under `.git/` | Forbidden |

### Allowed at any time (read-only inspection)

`git status`, `git diff`, `git diff --stat`, `git log`, `git show`, `git blame`,
`git branch --list`, `git remote -v`, `git ls-files`, `git rev-parse`.

Use these freely when the human asks what changed or what state the repo is in.

### If the human does ask

Only act on the exact request, in the same turn it was made:

1. Run `git status` and `git diff --stat` and **show the human what would go in**.
2. Propose a commit message. Wait for approval if any part of the request was ambiguous (which files, which branch, which message).
3. Stage only the files the human named or that the stated task actually touched. Never `git add -A` or `git add .` without explicit instruction.
4. Commit. Do **not** push unless "push" was also said. "Commit" never implies "push".
5. Never force-push, never push to a branch other than the one requested, never rewrite published history.

A request in an earlier message does not carry forward. "Commit this" once does not license committing the next three changes.

### Never commit

- Credentials, tokens, `.env` files, `user://` save data, API keys, private paths.
- Generated build output, `.godot/` cache, or engine import artifacts.
- The scratch logs the agent itself produced (`test_out.txt`, `import_out.txt`, `shot_out.txt`).

If something looks like it should be ignored, **say so and let the human update `.gitignore`.** Do not edit `.gitignore` unprompted, and do not commit it unprompted.

---

## 2. Working-tree edits are allowed

The rule above is about git, not about files. Creating, editing, and deleting project files in the working tree is normal work and does not require permission. The human reviews and commits.

Signal clearly when a batch of file changes is ready for review — list the paths and a one-line summary of each — then stop. Do not "helpfully" snapshot it into a commit.

---

## 3. Keep `PROGRESS.md` current

`PROGRESS.md` is the standing status ledger. After any major step:

- Add a dated line to its **Changelog**.
- Move items between *Completed*, *Partial / known-broken*, and *Remaining*.
- Do not delete history; strike through instead.

This file is a working document and is expected to be edited freely.

---

## 4. Project orientation

- **Engine:** Godot 4.7.2, `E:\godot\Godot_v4.7.2-stable_win64_console.exe`
- **Run:** `& 'E:\godot\Godot_v4.7.2-stable_win64_console.exe' --path .`
- **Headless test:** `... --headless --path . --fixed-fps 60 --quit-after 7200 -- --autotest --god` (60 frames = 1 simulated second)
- **Design source of truth:** `NIGHT_OF_THE_SIGBIN_GDD.md`
- **Current state and open bugs:** `PROGRESS.md`
- **Art is 100% procedural** — regenerate with the scripts in `tools/` (`py -3.13 gen_*.py`), never hand-edit generated PNGs.
- **Audio:** none. Music is deliberately deferred; do not add it until asked.
