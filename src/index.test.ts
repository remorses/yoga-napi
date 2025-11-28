import { expect, test, describe } from "bun:test";
import Yoga, { Node, Config, MeasureMode, Direction, FlexDirection, Edge } from "./index";

describe("Node", () => {
  test("create and free", () => {
    const node = Node.create();
    expect(node).toBeDefined();
    node.free();
  });

  test("create with config", () => {
    const config = Config.create();
    const node = Node.create(config);
    expect(node).toBeDefined();
    node.free();
    config.free();
  });

  test("basic layout", () => {
    const root = Node.create();
    root.setWidth(100);
    root.setHeight(100);
    root.setFlexDirection(FlexDirection.Row);

    const child1 = Node.create();
    child1.setFlexGrow(1);
    root.insertChild(child1, 0);

    const child2 = Node.create();
    child2.setFlexGrow(1);
    root.insertChild(child2, 1);

    root.calculateLayout(100, 100, Direction.LTR);

    const layout = root.getComputedLayout();
    expect(layout.width).toBe(100);
    expect(layout.height).toBe(100);

    expect(child1.getComputedWidth()).toBe(50);
    expect(child2.getComputedWidth()).toBe(50);

    root.freeRecursive();
  });
});

describe("MeasureFunc", () => {
  test("setMeasureFunc and hasMeasureFunc", () => {
    const node = Node.create();

    expect(node.hasMeasureFunc()).toBe(false);

    node.setMeasureFunc((width, widthMode, height, heightMode) => {
      return { width: 100, height: 50 };
    });

    expect(node.hasMeasureFunc()).toBe(true);

    node.unsetMeasureFunc();
    expect(node.hasMeasureFunc()).toBe(false);

    node.free();
  });

  test("measure function is called during layout", () => {
    const root = Node.create();
    root.setWidth(200);
    root.setHeight(200);

    const child = Node.create();
    let measureCalled = false;
    let measureWidth = 0;
    let measureWidthMode = -1;

    child.setMeasureFunc((width, widthMode, height, heightMode) => {
      measureCalled = true;
      measureWidth = width;
      measureWidthMode = widthMode;
      return { width: 50, height: 25 };
    });

    root.insertChild(child, 0);
    root.calculateLayout(200, 200, Direction.LTR);

    expect(measureCalled).toBe(true);
    expect(child.getComputedWidth()).toBe(50);
    expect(child.getComputedHeight()).toBe(25);

    root.freeRecursive();
  });

  test("measure function receives correct modes", () => {
    const root = Node.create();
    root.setWidth(100);
    root.setFlexDirection(FlexDirection.Row);

    const child = Node.create();
    child.setFlexGrow(1);

    let receivedWidthMode = -1;
    let receivedHeightMode = -1;

    child.setMeasureFunc((width, widthMode, height, heightMode) => {
      receivedWidthMode = widthMode;
      receivedHeightMode = heightMode;
      return { width: 50, height: 30 };
    });

    root.insertChild(child, 0);
    root.calculateLayout(100, undefined, Direction.LTR);

    // Width should be AtMost because parent has fixed width
    expect(receivedWidthMode).toBe(MeasureMode.AtMost);
    // Height should be Undefined because no height constraint
    expect(receivedHeightMode).toBe(MeasureMode.Undefined);

    root.freeRecursive();
  });
});

describe("DirtiedFunc", () => {
  test("setDirtiedFunc callback is called", () => {
    const root = Node.create();
    root.setWidth(100);
    root.setHeight(100);

    let dirtiedCalled = false;

    // Only nodes with measure function can be marked dirty
    root.setMeasureFunc(() => ({ width: 100, height: 100 }));
    root.setDirtiedFunc(() => {
      dirtiedCalled = true;
    });

    root.markDirty();

    expect(dirtiedCalled).toBe(true);

    root.free();
  });
});

describe("Margins, Padding, Border", () => {
  test("margins affect layout", () => {
    const root = Node.create();
    root.setWidth(100);
    root.setHeight(100);
    root.setFlexDirection(FlexDirection.Column);

    const child = Node.create();
    child.setWidth(50);
    child.setHeight(50);
    child.setMargin(Edge.Left, 10);
    child.setMargin(Edge.Top, 5);

    root.insertChild(child, 0);
    root.calculateLayout(100, 100, Direction.LTR);

    expect(child.getComputedLeft()).toBe(10);
    expect(child.getComputedTop()).toBe(5);

    root.freeRecursive();
  });

  test("padding affects children", () => {
    const root = Node.create();
    root.setWidth(100);
    root.setHeight(100);
    root.setPadding(Edge.All, 10);

    const child = Node.create();
    child.setWidth(50);
    child.setHeight(50);

    root.insertChild(child, 0);
    root.calculateLayout(100, 100, Direction.LTR);

    expect(child.getComputedLeft()).toBe(10);
    expect(child.getComputedTop()).toBe(10);

    root.freeRecursive();
  });

  test("border affects layout", () => {
    const root = Node.create();
    root.setWidth(100);
    root.setHeight(100);
    root.setBorder(Edge.All, 5);

    const child = Node.create();
    child.setFlexGrow(1);

    root.insertChild(child, 0);
    root.calculateLayout(100, 100, Direction.LTR);

    // Child should be offset by border
    expect(child.getComputedLeft()).toBe(5);
    expect(child.getComputedTop()).toBe(5);
    // Child should be smaller due to borders
    expect(child.getComputedWidth()).toBe(90);
    expect(child.getComputedHeight()).toBe(90);

    root.freeRecursive();
  });
});

describe("Gap", () => {
  test("row gap", () => {
    const root = Node.create();
    root.setWidth(100);
    root.setHeight(100);
    root.setFlexDirection(FlexDirection.Column);
    root.setGap(Yoga.Gutter.Row, 10);

    const child1 = Node.create();
    child1.setHeight(20);
    root.insertChild(child1, 0);

    const child2 = Node.create();
    child2.setHeight(20);
    root.insertChild(child2, 1);

    root.calculateLayout(100, 100, Direction.LTR);

    expect(child1.getComputedTop()).toBe(0);
    expect(child2.getComputedTop()).toBe(30); // 20 + 10 gap

    root.freeRecursive();
  });
});
