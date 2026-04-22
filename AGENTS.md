# AGENTS.md

Guidelines for AI agents (and human contributors) working on XPlatform.
These rules encode decisions that have been made deliberately and
discussed in detail. Revisit them only with explicit discussion, not
by default.

## What XPlatform is

A small Swift package that provides cross-platform type aliases and
narrow utility helpers bridging **AppKit (macOS) and UIKit (iOS)**.
Scope is deliberately narrow:

- Type aliases for NS/UI types (`XView`, `XColor`, `XImage`, `XFont`, ...)
- Small bridge helpers for native-name conflicts (`XPasteboard.stringValue`)
- Coordinate-system primitives (`XCanvasView`, `XCanvasClipView`)
- A handful of cross-platform convenience properties where the same
  return-type makes sense on both platforms (`XColor.primaryBackground`,
  `XView.tintColor`, `XView.backgroundColor`)

What XPlatform is **not**:

- A UI framework.
- A graphics abstraction layer.
- A domain model library (no scenes, canvases, documents, tools).
- A cross-platform rendering engine.

## Platform support

- **iOS 15+**
- **macOS 12+**

Deliberately **not** supported:

- **tvOS** — several UIKit semantic color APIs XPlatform uses
  (`UIColor.secondarySystemBackground` and relatives) are unavailable.
- **watchOS** — most of the semantic UIColor palette is unavailable.

Prior versions declared tvOS/watchOS support, but they never actually
compiled. v2.0.0 aligned declared support with tested support. **Do not
re-add tvOS or watchOS** without first verifying every UIKit API
XPlatform uses is actually available on those platforms.

## Naming conventions

The `X`-prefix has specific meaning. Use it consistently.

### Capital `X` prefix: platform bridges only

| Purpose | Example |
|---------|---------|
| Direct typealias for an NS/UI type | `XView`, `XColor`, `XImage`, `XFont`, `XPasteboard` |
| Cross-platform subclass or variant of an NS/UI type | `XCanvasView`, `XCanvasClipView` |
| Protocol bridge for an NS/UI protocol | `XScrollViewDelegate` |
| **Not** domain concepts | ~~`XScene`~~, ~~`XArtboard`~~, ~~`XTool`~~, ~~`XCanvas`~~ |

### Member names: use the plain native name when possible

The return type (`XColor`, `XFont`, ...) already signals cross-platform
intent. An extra prefix on the member name is redundant noise.

Good:

```swift
XColor.primaryBackground
XView.tintColor
XView.backgroundColor
XPasteboard.general
```

### Lowercase `x` prefix: reserved for real name collisions

Use `xSomething` **only** when a plain name would shadow an existing
native property or method on one platform, and no better alternative
name exists.

The current codebase has **zero** `x`-prefixed members because every
former candidate had a cleaner alternative:

| Before | After | Why |
|--------|-------|-----|
| `XPasteboard.xString` | `XPasteboard.stringValue` | `stringValue` doesn't collide and reads better |
| `XPasteboard.xGeneral` | `XPasteboard.general` | `.general` is native on both platforms; no wrapper needed |
| `XFont.xSystemFont(...)` | `XFont.systemFont(...)` | Native on both platforms |
| `XColor.xLabel` | `XColor.label` | Native on iOS; macOS extension adds it too |
| `XView.xTintColor` | `XView.tintColor` | macOS extension adds `tintColor`, making the name cross-platform |

Do **not** create `x`-prefixed wrappers for APIs that already exist
natively on both platforms. Delete such wrappers if you encounter them.

## What NOT to add

Deliberately deferred after discussion. Re-read this section before
adding any of these.

- **`XScene` / `XCanvas` / `XArtboard` model types.** Domain concepts,
  not platform bridges. They belong in libraries that own the domain
  (drawing apps, spreadsheets, page engines, etc.), not in XPlatform.
- **Event type bridges** (e.g. a common `XTouch` wrapping
  `UITouch`/`NSEvent`). Those carry genuinely different data (force,
  azimuth, modifier flags, button number, estimation updates). A bridge
  either strips information or rebuilds half of both SDKs.
- **Rendering abstractions** (protocols that unify `CGContext` and
  `MTLRenderCommandEncoder` drawing). That's a multi-month graphics
  library, out of scope.
- **Rendering backend classes.** Lightweight CoreGraphics geometry
  utilities (`CGRect`, `CGAffineTransform`) are fine — the package
  already imports CoreGraphics for `CGRect.transform(to:)`. What's out
  of scope is **renderer classes**: no `CGContext`-based drawing
  wrappers, no `MTKView` subclasses, no `MTLRenderCommandEncoder`
  helpers. Adding `import MetalKit` would force every consumer to link
  MetalKit even if they only want `XView` / `XColor`.
- **Scroll-view wrapper classes that embed render pipelines.**
  Qiita-style vector renderers, MangaLoft-style Metal canvases, etc. —
  these share scaffolding (scroll view + flipped content view) but have
  backend-specific renderers, so they belong in domain libraries that
  own the backend. The shared scaffolding is already exposed via
  `XCanvasView` + `XCanvasClipView`.

## Design principles

### Solve coordinate problems geometrically, not by bridging events

The main lesson of v2.1.0: `UITouch` and `NSEvent` can stay native if
you make `contentView.bounds == scene.bounds` on a view that is
top-left-origin on both platforms. Then:

- iOS: `touch.location(in: contentView)` returns scene coordinates directly.
- macOS: `contentView.convert(event.locationInWindow, from: nil)` returns scene coordinates directly.

No manual Y-flipping, no offset math, no zoom math. `XCanvasView`
guarantees the top-left origin on both platforms; anything that uses
a canvas-like coordinate space should subclass it.

See README's **Canvas Coordinate Convention** section for the full pattern.

### Prefer additive over breaking

For API safety issues, the house style is:

1. Add a safer sibling (`xxxIfAvailable`, `transformIfValid`).
2. Have the existing API forward to it where practical (no duplicate logic).
3. Break in the next major version only if necessary.

Existing examples:

- `XPlatform.documentsDirectory` (force-unwrapping) + 
  `XPlatform.documentsDirectoryIfAvailable` (safe). The unsafe variant
  calls through to the safe one internally.
- `CGRect.transform(to:)` (unchecked) + `CGRect.transformIfValid(to:)`
  (guarded). Both public; the safe one is the recommended default in
  new code.

### "What weight does this pull?"

Before adding a protocol, base class, or concrete type, ask:

- Who is the concrete consumer today?
- What code does this eliminate that consumers currently duplicate?
- Would it leak its opinions into consumers' code?

If the answer to the first is "no one" or "hypothetical," **defer**.
Small libraries become kitchen sinks by accretion of unchallenged
additions.

### Source files: one concern each

Extensions live in file names that reflect what they extend:
`XView+Extensions.swift`, `XColor+Extensions.swift`, etc. New utility
categories get their own file (`XCanvasView.swift`, `XColors.swift` for
canonical color tiers). Don't dump unrelated helpers into a single
file.

## Verification

Required before **code / API** commits:

```sh
swift build                 # clean
swift test                  # all passing
xcodebuild -scheme XPlatform \
  -destination 'generic/platform=iOS' \
  -skipPackagePluginValidation build    # succeeds
```

For **docs-only** commits, run tests when a snippet or a documented API
has changed; otherwise rely on CI to catch regressions. Tiny typo fixes
and prose tweaks don't need local re-verification.

CI (`.github/workflows/ci.yml`) runs all three automatically on every
push and pull request. Do not merge without green CI.

`testDocsExamplesCompile` in the test target mirrors README code
snippets. When updating the README with new code examples, mirror them
in that test so future drift gets caught by `swift test` rather than
by a reviewer.

## SemVer and releases

- `v2.X.0` — additive features (new safe siblings, new coordinate
  primitives, new extensions).
- `v2.X.Y` — docs / metadata only (README tweaks, CHANGELOG
  corrections). CI and tooling changes usually do **not** need a
  release tag — tag only when bundled with docs or API changes that
  consumers care about.
- `v3.0.0` — breaking changes (API removals, behavior changes, type
  signature changes).

**Release workflow:**

1. Commit the change.
2. Push the commit: `git push`.
3. **Wait for CI to go green** on GitHub Actions.
4. Only then push the tag: `git push origin vX.Y.Z`.

This avoids publishing a release tag that points at known-broken code
on the runner (even if it built locally).

### Deferred breaking changes

Slated for a future v3.0.0 design pass:

- **Remove retroactive `XResponder: Sequence` conformance.** Global
  conformance on an Apple framework type creates collision risk with
  other packages. `.responders` array property + `findResponder(of:)`
  method already cover the use cases.
- **Fix `XAlert.showAlert` iOS behavior.** Currently prints to console
  on iOS, which is misleading given the method name. Options include:
  requiring a presenting view controller parameter, removing the iOS
  branch entirely, or renaming to signal macOS-modal / iOS-debug
  behavior.

When starting v3.0.0 work, **open a design discussion first**; don't
code the removals silently.

## Commit conventions

Follow **Conventional Commits**:

- `feat:` — new feature (additive API).
- `feat!:` — breaking change (also note in CHANGELOG).
- `fix:` — bug fix.
- `docs:` — docs only (README, CHANGELOG, source comments).
- `ci:` — CI / build config.
- `chore:` — tooling, housekeeping, `.gitignore`.
- `refactor:` — code change with no public API impact.

For agent-authored commits, include an appropriate co-author footer
identifying the tool that actually authored the change. Do not invent
an identity or reuse a stale one. If no footer applies, omit it.

Example for Claude Code:

```
Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
```

Other agents/tools (Codex, future Claude versions, other assistants)
should use whatever footer their own docs recommend.

## When in doubt

Default to **no**:

- No to new abstractions without a concrete consumer.
- No to type unifications that lose platform-specific information.
- No to scope creep beyond "thin cross-platform glue."
- No to breaking changes when an additive sibling would suffice.

When a design decision is not obvious, **raise it explicitly** instead
of shipping the decision silently in code.
