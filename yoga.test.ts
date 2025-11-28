import { createRequire } from "node:module";
const require = createRequire(import.meta.url);
const yoga = require("./zig-out/lib/yoga_napi.node");

import { test, expect, describe } from "bun:test";

describe("yoga-napi", () => {
  test("add function works", () => {
    expect(yoga.add(1, 2)).toBe(3);
    expect(yoga.add(10, 20)).toBe(30);
  });

  test("basic layout calculation", () => {
    const root = yoga.nodeCreate();
    expect(root).not.toBeNull();

    yoga.nodeSetWidth(root, 100);
    yoga.nodeSetHeight(root, 100);
    yoga.nodeSetFlexDirection(root, yoga.FLEX_DIRECTION_ROW);

    const child0 = yoga.nodeCreate();
    yoga.nodeSetFlexGrow(child0, 1);
    yoga.nodeSetMargin(child0, yoga.EDGE_RIGHT, 10);
    yoga.nodeInsertChild(root, child0, 0);

    const child1 = yoga.nodeCreate();
    yoga.nodeSetFlexGrow(child1, 1);
    yoga.nodeInsertChild(root, child1, 1);

    // Calculate layout with undefined width/height (-1 means undefined)
    yoga.nodeCalculateLayout(root, -1, -1, yoga.DIRECTION_LTR);

    // Get computed values
    const child0Width = yoga.nodeGetComputedWidth(child0);
    const child1Width = yoga.nodeGetComputedWidth(child1);

    console.log("child0Width:", child0Width);
    console.log("child1Width:", child1Width);

    // With flex grow 1 each and 10px margin, children should split 90px (100-10)
    expect(child0Width).toBeCloseTo(45, 0);
    expect(child1Width).toBeCloseTo(45, 0);

    // Clean up
    yoga.nodeFree(child0);
    yoga.nodeFree(child1);
    yoga.nodeFree(root);
  });

  test("getComputedLayout returns object", () => {
    const root = yoga.nodeCreate();
    yoga.nodeSetWidth(root, 200);
    yoga.nodeSetHeight(root, 100);
    yoga.nodeCalculateLayout(root, -1, -1, yoga.DIRECTION_LTR);

    const layout = yoga.nodeGetComputedLayout(root);
    console.log("layout:", layout);

    expect(layout.width).toBe(200);
    expect(layout.height).toBe(100);
    expect(layout.left).toBe(0);
    expect(layout.top).toBe(0);

    yoga.nodeFree(root);
  });

  test("enum constants are exported", () => {
    expect(yoga.DIRECTION_INHERIT).toBe(0);
    expect(yoga.DIRECTION_LTR).toBe(1);
    expect(yoga.DIRECTION_RTL).toBe(2);

    expect(yoga.FLEX_DIRECTION_COLUMN).toBe(0);
    expect(yoga.FLEX_DIRECTION_ROW).toBe(2);

    expect(yoga.EDGE_LEFT).toBe(0);
    expect(yoga.EDGE_TOP).toBe(1);
    expect(yoga.EDGE_RIGHT).toBe(2);
    expect(yoga.EDGE_BOTTOM).toBe(3);
  });
});
