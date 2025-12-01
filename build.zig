const std = @import("std");
const napigen = @import("napigen");

const CXXFLAGS = .{
    "--std=c++20",
    "-Wall",
    "-Wextra",
    "-Werror",
};

const yoga_files = .{
    "YGConfig.cpp",
    "YGEnums.cpp",
    "YGNode.cpp",
    "YGNodeLayout.cpp",
    "YGNodeStyle.cpp",
    "YGPixelGrid.cpp",
    "YGValue.cpp",
    "algorithm/AbsoluteLayout.cpp",
    "algorithm/Baseline.cpp",
    "algorithm/Cache.cpp",
    "algorithm/CalculateLayout.cpp",
    "algorithm/FlexLine.cpp",
    "algorithm/PixelGrid.cpp",
    "config/Config.cpp",
    "debug/AssertFatal.cpp",
    "debug/Log.cpp",
    "event/event.cpp",
    "node/LayoutResults.cpp",
    "node/Node.cpp",
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Get yoga dependency from Facebook
    const yoga_dep = b.dependency("yoga", .{
        .target = target,
        .optimize = optimize,
    });

    // ========================================================================
    // NAPI Library (for Node.js/Bun)
    // ========================================================================

    const napi_mod = b.addModule("bun-yoga", .{
        .root_source_file = b.path("src/yoga_napi.zig"),
        .target = target,
        .optimize = optimize,
        .link_libcpp = true,
    });

    const napi_lib = b.addLibrary(.{
        .name = "yoga",
        .linkage = .dynamic,
        .root_module = napi_mod,
    });

    // Add napigen support
    napigen.setup(napi_lib);

    // Compile yoga C++ source files
    napi_lib.addCSourceFiles(.{
        .root = yoga_dep.path("yoga"),
        .files = &yoga_files,
        .flags = &CXXFLAGS,
    });

    // Install headers for @cImport
    napi_lib.installHeadersDirectory(yoga_dep.path("yoga"), "yoga", .{
        .include_extensions = &.{".h"},
    });

    // Add include path for yoga headers
    napi_lib.addIncludePath(yoga_dep.path(""));

    // Build and install
    b.installArtifact(napi_lib);

    // Copy the result to a *.node file so we can require() it
    const copy_node_step = b.addInstallLibFile(napi_lib.getEmittedBin(), "yoga.node");
    b.getInstallStep().dependOn(&copy_node_step.step);

    // ========================================================================
    // Tests
    // ========================================================================

    const test_mod = b.addModule("bun-yoga-test", .{
        .root_source_file = b.path("src/yoga_napi.zig"),
        .target = target,
        .optimize = optimize,
        .link_libcpp = true,
    });

    const lib_unit_tests = b.addTest(.{
        .root_module = test_mod,
    });

    // Add napigen for tests
    const napigen_dep = b.dependencyFromBuildZig(napigen, .{});
    lib_unit_tests.root_module.addImport("napigen", napigen_dep.module("napigen"));

    // Add yoga source files for tests too
    lib_unit_tests.addCSourceFiles(.{
        .root = yoga_dep.path("yoga"),
        .files = &yoga_files,
        .flags = &CXXFLAGS,
    });
    lib_unit_tests.addIncludePath(yoga_dep.path(""));

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
}
