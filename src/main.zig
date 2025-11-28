const std = @import("std");
const napigen = @import("napigen");
const wrapper = @import("yoga_wrapper.zig");

// Re-export from wrapper
const Layout = wrapper.Layout;

// Define the N-API module
comptime {
    napigen.defineModule(initModule);
}

fn initModule(js: *napigen.JsContext, exports: napigen.napi_value) anyerror!napigen.napi_value {
    // Basic test function
    try js.setNamedProperty(exports, "add", try js.createFunction(wrapper.add));

    // Node functions
    try js.setNamedProperty(exports, "nodeCreate", try js.createFunction(wrapper.nodeCreate));
    try js.setNamedProperty(exports, "nodeFree", try js.createFunction(wrapper.nodeFree));
    try js.setNamedProperty(exports, "nodeSetWidth", try js.createFunction(wrapper.nodeSetWidth));
    try js.setNamedProperty(exports, "nodeSetHeight", try js.createFunction(wrapper.nodeSetHeight));
    try js.setNamedProperty(exports, "nodeSetFlexDirection", try js.createFunction(wrapper.nodeSetFlexDirection));
    try js.setNamedProperty(exports, "nodeSetFlexGrow", try js.createFunction(wrapper.nodeSetFlexGrow));
    try js.setNamedProperty(exports, "nodeSetMargin", try js.createFunction(wrapper.nodeSetMargin));
    try js.setNamedProperty(exports, "nodeInsertChild", try js.createFunction(wrapper.nodeInsertChild));
    try js.setNamedProperty(exports, "nodeCalculateLayout", try js.createFunction(wrapper.nodeCalculateLayout));
    try js.setNamedProperty(exports, "nodeGetComputedLayout", try js.createFunction(wrapper.nodeGetComputedLayout));
    try js.setNamedProperty(exports, "nodeGetComputedWidth", try js.createFunction(wrapper.nodeGetComputedWidth));
    try js.setNamedProperty(exports, "nodeGetComputedHeight", try js.createFunction(wrapper.nodeGetComputedHeight));
    try js.setNamedProperty(exports, "nodeGetComputedLeft", try js.createFunction(wrapper.nodeGetComputedLeft));
    try js.setNamedProperty(exports, "nodeGetComputedTop", try js.createFunction(wrapper.nodeGetComputedTop));

    // Export enum constants
    try js.setNamedProperty(exports, "DIRECTION_INHERIT", try js.write(@as(u32, 0)));
    try js.setNamedProperty(exports, "DIRECTION_LTR", try js.write(@as(u32, 1)));
    try js.setNamedProperty(exports, "DIRECTION_RTL", try js.write(@as(u32, 2)));

    try js.setNamedProperty(exports, "FLEX_DIRECTION_COLUMN", try js.write(@as(u32, 0)));
    try js.setNamedProperty(exports, "FLEX_DIRECTION_COLUMN_REVERSE", try js.write(@as(u32, 1)));
    try js.setNamedProperty(exports, "FLEX_DIRECTION_ROW", try js.write(@as(u32, 2)));
    try js.setNamedProperty(exports, "FLEX_DIRECTION_ROW_REVERSE", try js.write(@as(u32, 3)));

    try js.setNamedProperty(exports, "EDGE_LEFT", try js.write(@as(u32, 0)));
    try js.setNamedProperty(exports, "EDGE_TOP", try js.write(@as(u32, 1)));
    try js.setNamedProperty(exports, "EDGE_RIGHT", try js.write(@as(u32, 2)));
    try js.setNamedProperty(exports, "EDGE_BOTTOM", try js.write(@as(u32, 3)));
    try js.setNamedProperty(exports, "EDGE_START", try js.write(@as(u32, 4)));
    try js.setNamedProperty(exports, "EDGE_END", try js.write(@as(u32, 5)));
    try js.setNamedProperty(exports, "EDGE_HORIZONTAL", try js.write(@as(u32, 6)));
    try js.setNamedProperty(exports, "EDGE_VERTICAL", try js.write(@as(u32, 7)));
    try js.setNamedProperty(exports, "EDGE_ALL", try js.write(@as(u32, 8)));

    return exports;
}
