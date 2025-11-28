# Yoga NAPI Progress

## Project Goal
Create a NAPI module for Yoga layout engine that can be used from Bun, with the same API as `yoga-layout`.

## Technology Stack
- **Zig 0.15.2** - Build system and native code
- **napigen** - NAPI bindings generator for Zig
- **yoga-zig** - Zig bindings for Facebook's Yoga layout engine
- **Bun** - JavaScript runtime for testing

## Part 1 - Setup (COMPLETED)

### Completed Tasks
1. Created basic Zig project structure with `build.zig` and `build.zig.zon`
2. Added napigen dependency for NAPI exports
3. Added yoga-zig dependency for Yoga layout functionality
4. Created simple test in Zig to verify yoga works
5. Exposed basic yoga functions via NAPI
6. Wrote Bun test to verify NAPI module works

### Key Decisions
- Using `yoga-zig` as dependency rather than compiling yoga C++ directly
- Separated code into `main.zig` (NAPI exports) and `yoga_wrapper.zig` (testable code)
- Using opaque pointers (`?*anyopaque`) to pass yoga node handles between JS and Zig

## Current API Implementation

### Implemented Functions
- `add(a, b)` - Test function
- `nodeCreate()` - Create a new yoga node
- `nodeFree(node)` - Free a yoga node
- `nodeSetWidth(node, width)` - Set node width
- `nodeSetHeight(node, height)` - Set node height
- `nodeSetFlexDirection(node, direction)` - Set flex direction
- `nodeSetFlexGrow(node, grow)` - Set flex grow
- `nodeSetMargin(node, edge, margin)` - Set margin
- `nodeInsertChild(parent, child, index)` - Insert child node
- `nodeCalculateLayout(node, width, height, direction)` - Calculate layout
- `nodeGetComputedLayout(node)` - Get computed layout object
- `nodeGetComputedWidth(node)` - Get computed width
- `nodeGetComputedHeight(node)` - Get computed height
- `nodeGetComputedLeft(node)` - Get computed left
- `nodeGetComputedTop(node)` - Get computed top

### Implemented Constants
- `DIRECTION_INHERIT`, `DIRECTION_LTR`, `DIRECTION_RTL`
- `FLEX_DIRECTION_COLUMN`, `FLEX_DIRECTION_COLUMN_REVERSE`, `FLEX_DIRECTION_ROW`, `FLEX_DIRECTION_ROW_REVERSE`
- `EDGE_LEFT`, `EDGE_TOP`, `EDGE_RIGHT`, `EDGE_BOTTOM`, `EDGE_START`, `EDGE_END`, `EDGE_HORIZONTAL`, `EDGE_VERTICAL`, `EDGE_ALL`

## Part 2 - Full API Implementation (TODO)

### TODO: Node API
- [ ] `freeRecursive()`
- [ ] `copyStyle(node)`
- [ ] `getChild(index)`
- [ ] `getChildCount()`
- [ ] `getParent()`
- [ ] `removeChild(child)`
- [ ] `reset()`

### TODO: Style Getters
- [ ] `getAlignContent()`, `getAlignItems()`, `getAlignSelf()`
- [ ] `getAspectRatio()`
- [ ] `getBorder(edge)`
- [ ] `getDirection()`, `getDisplay()`
- [ ] `getFlexBasis()`, `getFlexDirection()`, `getFlexGrow()`, `getFlexShrink()`, `getFlexWrap()`
- [ ] `getHeight()`, `getWidth()`
- [ ] `getJustifyContent()`
- [ ] `getGap(gutter)`
- [ ] `getMargin(edge)`, `getPadding(edge)`, `getPosition(edge)`
- [ ] `getMaxHeight()`, `getMaxWidth()`, `getMinHeight()`, `getMinWidth()`
- [ ] `getOverflow()`
- [ ] `getPositionType()`, `getBoxSizing()`

### TODO: Style Setters
- [ ] `setAlignContent()`, `setAlignItems()`, `setAlignSelf()`
- [ ] `setAspectRatio()`
- [ ] `setBorder(edge, width)`
- [ ] `setDirection()`, `setDisplay()`
- [ ] `setFlex()`, `setFlexBasis()`, `setFlexBasisPercent()`, `setFlexBasisAuto()`
- [ ] `setFlexShrink()`, `setFlexWrap()`
- [ ] `setHeightAuto()`, `setHeightPercent()`
- [ ] `setWidthAuto()`, `setWidthPercent()`
- [ ] `setJustifyContent()`
- [ ] `setGap()`, `setGapPercent()`
- [ ] `setMarginAuto()`, `setMarginPercent()`
- [ ] `setPadding()`, `setPaddingPercent()`
- [ ] `setPosition()`, `setPositionPercent()`, `setPositionType()`, `setPositionAuto()`
- [ ] `setMaxHeight()`, `setMaxHeightPercent()`, `setMaxWidth()`, `setMaxWidthPercent()`
- [ ] `setMinHeight()`, `setMinHeightPercent()`, `setMinWidth()`, `setMinWidthPercent()`
- [ ] `setOverflow()`
- [ ] `setBoxSizing()`
- [ ] `setIsReferenceBaseline()`
- [ ] `setAlwaysFormsContainingBlock()`

### TODO: Layout State
- [ ] `isDirty()`, `markDirty()`
- [ ] `hasNewLayout()`, `markLayoutSeen()`
- [ ] `isReferenceBaseline()`

### TODO: Computed Layout
- [ ] `getComputedBorder(edge)`
- [ ] `getComputedMargin(edge)`
- [ ] `getComputedPadding(edge)`
- [ ] `getComputedRight()`, `getComputedBottom()`

### TODO: Callbacks
- [ ] `setMeasureFunc()`, `unsetMeasureFunc()`
- [ ] `setDirtiedFunc()`, `unsetDirtiedFunc()`

### TODO: Config API
- [ ] `Config.create()`, `Config.destroy()`
- [ ] `Config.setPointScaleFactor()`
- [ ] `Config.setExperimentalFeatureEnabled()`, `Config.isExperimentalFeatureEnabled()`
- [ ] `Config.setErrata()`, `Config.getErrata()`
- [ ] `Config.setUseWebDefaults()`, `Config.useWebDefaults()`
- [ ] `Node.create(config)`, `Node.createWithConfig(config)`

### TODO: More Enums/Constants
- [ ] All Align values
- [ ] All BoxSizing values
- [ ] All Display values
- [ ] All Justify values
- [ ] All Overflow values
- [ ] All PositionType values
- [ ] All Wrap values
- [ ] All Unit values
- [ ] All Gutter values
- [ ] All Errata values
- [ ] All ExperimentalFeature values
- [ ] All MeasureMode values

## Build Commands
```bash
# Build the library
zig build

# Run Zig tests
zig build test

# Run Bun tests
bun test
```

## Output Files
- `zig-out/lib/yoga_napi.node` - Node.js/Bun loadable module
- `zig-out/lib/libyoga_napi.dylib` - Dynamic library
