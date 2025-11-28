# Changelog

## 0.2.0

### Breaking Changes
- Method signatures updated to match yoga-layout exactly (accepts `undefined`)

### New Features
- **Type exports**: All enums now export corresponding TypeScript types (e.g., `Align` works as both value and type)
- **String value support**: Methods now accept percent strings (`"50%"`) and `"auto"` like yoga-layout:
  - `setWidth`, `setHeight`: accept `number | "auto" | \`${number}%\` | undefined`
  - `setMinWidth`, `setMinHeight`, `setMaxWidth`, `setMaxHeight`: accept `number | \`${number}%\` | undefined`
  - `setMargin`: accepts `number | "auto" | \`${number}%\` | undefined`
  - `setPadding`: accepts `number | \`${number}%\` | undefined`
  - `setGap`: accepts `number | \`${number}%\` | undefined`
  - `setPosition`: accepts `number | \`${number}%\` | undefined`
  - `setFlexBasis`: accepts `number | "auto" | \`${number}%\` | undefined`

### New Methods
- `Node.copyStyle(node)`: Copy style from another node
- `Node.setBoxSizing(boxSizing)` / `Node.getBoxSizing()`: Box sizing support
- `Node.setIsReferenceBaseline(isReferenceBaseline)` / `Node.isReferenceBaseline()`: Reference baseline support
- `Node.setAlwaysFormsContainingBlock(alwaysFormsContainingBlock)`: Containing block support
- `Config.setErrata(errata)` / `Config.getErrata()`: Errata configuration
- `Config.setExperimentalFeatureEnabled(feature, enabled)` / `Config.isExperimentalFeatureEnabled(feature)`: Experimental features

### Internal
- Added `Value` type for yoga-layout compatibility
- Added comprehensive tests for string value parsing

## 0.1.3

- Fixed Windows CI: prepare DLL path before running tests
- Fixed publish workflow: explicitly build TypeScript before publishing

## 0.1.2

- Added Windows x64 support
- Added Bun tests to CI for all platforms (Linux, macOS, Windows)

## 0.1.1

- Fixed ARM64 ABI compatibility for callback functions (`setMeasureFunc`, `setBaselineFunc`)
- Implemented trampoline pattern for measure/baseline callbacks to work around Bun FFI limitations on ARM64
- Added `setDirtiedFunc` callback support
- Added callback context management to support multiple callbacks per node
- Fixed tests to account for Yoga's default flex stretch behavior
- Added baseline function test

## 0.1.0

- Initial release with yoga-layout compatible API
- Bun FFI wrapper for Facebook's Yoga layout engine
- Core layout functionality (flex, padding, margin, border, gap)
- Node and Config classes
