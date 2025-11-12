DEV NOTES — accidental tool output pasted into source files

What happened
- Some files accidentally contained stray XML/markup fragments (for example `</content>` and `<parameter name=...>`) that were pasted into Dart files. These markers break Dart parsing and produce many cascading analyzer/compile errors.

How I fixed it
- Removed the stray markers from affected files:
  - `lib/firebase_options.dart`
  - `lib/services/notification_service.dart`
  - `lib/providers/notification_provider.dart`
- Added `firebase_core` dependency to `pubspec.yaml` (compatible with `firebase_messaging`).
- Removed an unused private field in `NotificationService` and updated providers wiring.

Prevention / quick checklist
- Before committing, run this grep to detect accidental markers:

  # bash / Git Bash
  git grep -n "</content>\|<parameter name=" || true

  # PowerShell
  git ls-files -z | ForEach-Object { Get-Content -Raw -Path $_ } | Select-String -Pattern "</content>|<parameter name="

- Add this as a pre-commit check (see `scripts/pre-commit` and `scripts/pre-commit.ps1`).

Installation: add the pre-commit hook
- Unix / Git Bash users:
  cp scripts/pre-commit .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit

- Windows PowerShell users (manual install):
  Copy `scripts/pre-commit.ps1` to `.git/hooks/pre-commit`.
  Ensure Git executes PowerShell scripts (or run the script via Git Bash). If Windows blocks execution, you can install the hook to call PowerShell explicitly.

If you want, I can add instructions to automate hook installation as part of project setup.

If you see similar parser errors mentioning '<' or unexpected tokens after a recent edit, run the grep above immediately; these markers are the most common cause.
