const std = @import("std");
const yoga = @import("yoga-zig");

// Re-export yoga types for convenience
pub const Node = yoga.Node;
pub const Config = yoga.Config;
pub const enums = yoga.enums;
pub const Layout = yoga.Layout;
pub const Value = yoga.Value;

// Simple test function to verify NAPI is working
pub fn add(a: i32, b: i32) i32 {
    return a + b;
}

// Create a new yoga node
pub fn nodeCreate() ?*anyopaque {
    const node = Node.new();
    // We need to return the handle as opaque pointer
    return @ptrCast(node.handle);
}

// Free a yoga node
pub fn nodeFree(ptr: ?*anyopaque) void {
    if (ptr) |p| {
        const node = Node{ .handle = @ptrCast(p) };
        node.free();
    }
}

// Set width
pub fn nodeSetWidth(ptr: ?*anyopaque, width: f32) void {
    if (ptr) |p| {
        const node = Node{ .handle = @ptrCast(p) };
        node.setWidth(width);
    }
}

// Set height
pub fn nodeSetHeight(ptr: ?*anyopaque, height: f32) void {
    if (ptr) |p| {
        const node = Node{ .handle = @ptrCast(p) };
        node.setHeight(height);
    }
}

// Set flex direction
pub fn nodeSetFlexDirection(ptr: ?*anyopaque, direction: u32) void {
    if (ptr) |p| {
        const node = Node{ .handle = @ptrCast(p) };
        node.setFlexDirection(@enumFromInt(direction));
    }
}

// Set flex grow
pub fn nodeSetFlexGrow(ptr: ?*anyopaque, grow: f32) void {
    if (ptr) |p| {
        const node = Node{ .handle = @ptrCast(p) };
        node.setFlexGrow(grow);
    }
}

// Set margin
pub fn nodeSetMargin(ptr: ?*anyopaque, edge: u32, margin: f32) void {
    if (ptr) |p| {
        const node = Node{ .handle = @ptrCast(p) };
        node.setMargin(@enumFromInt(edge), margin);
    }
}

// Insert child
pub fn nodeInsertChild(parentPtr: ?*anyopaque, childPtr: ?*anyopaque, index: u32) void {
    if (parentPtr) |pp| {
        if (childPtr) |cp| {
            const parent = Node{ .handle = @ptrCast(pp) };
            const child = Node{ .handle = @ptrCast(cp) };
            parent.insertChild(child, index);
        }
    }
}

// Calculate layout
pub fn nodeCalculateLayout(ptr: ?*anyopaque, width: f32, height: f32, direction: u32) void {
    if (ptr) |p| {
        const node = Node{ .handle = @ptrCast(p) };
        const w: ?f32 = if (width < 0) null else width;
        const h: ?f32 = if (height < 0) null else height;
        node.calculateLayout(w, h, @enumFromInt(direction));
    }
}

// Get computed layout - returns struct that napigen will convert to JS object
pub fn nodeGetComputedLayout(ptr: ?*anyopaque) Layout {
    if (ptr) |p| {
        const node = Node{ .handle = @ptrCast(p) };
        return node.getComputedLayout();
    }
    return Layout{ .left = 0, .right = 0, .top = 0, .bottom = 0, .width = 0, .height = 0 };
}

// Get computed width
pub fn nodeGetComputedWidth(ptr: ?*anyopaque) f32 {
    if (ptr) |p| {
        const node = Node{ .handle = @ptrCast(p) };
        return node.getComputedWidth();
    }
    return 0;
}

// Get computed height
pub fn nodeGetComputedHeight(ptr: ?*anyopaque) f32 {
    if (ptr) |p| {
        const node = Node{ .handle = @ptrCast(p) };
        return node.getComputedHeight();
    }
    return 0;
}

// Get computed left
pub fn nodeGetComputedLeft(ptr: ?*anyopaque) f32 {
    if (ptr) |p| {
        const node = Node{ .handle = @ptrCast(p) };
        return node.getComputedLeft();
    }
    return 0;
}

// Get computed top
pub fn nodeGetComputedTop(ptr: ?*anyopaque) f32 {
    if (ptr) |p| {
        const node = Node{ .handle = @ptrCast(p) };
        return node.getComputedTop();
    }
    return 0;
}

// Tests
test "basic yoga test" {
    const root = Node.new();
    defer root.free();

    root.setFlexDirection(enums.FlexDirection.Row);
    root.setWidth(100);
    root.setHeight(100);

    const child0 = Node.new();
    defer child0.free();
    child0.setFlexGrow(1);
    child0.setMargin(enums.Edge.Right, 10);
    root.insertChild(child0, 0);

    const child1 = Node.new();
    defer child1.free();
    child1.setFlexGrow(1);
    root.insertChild(child1, 1);

    root.calculateLayout(null, null, enums.Direction.LTR);

    const child0Width = child0.getComputedWidth();
    const child1Width = child1.getComputedWidth();

    // With flex grow 1 each and 10px margin, children should split 90px (100-10)
    try std.testing.expectApproxEqAbs(@as(f32, 45), child0Width, 0.1);
    try std.testing.expectApproxEqAbs(@as(f32, 45), child1Width, 0.1);
}
