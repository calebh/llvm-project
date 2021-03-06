// RUN: not llvm-mc -triple=aarch64 -show-encoding -mattr=+sve  2>&1 < %s| FileCheck %s

// --------------------------------------------------------------------------//
// Immediate out of lower bound [0, 63].

ld1rb z0.b, p1/z, [x0, #-1]
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: index must be in range [0, 63].
// CHECK-NEXT: ld1rb z0.b, p1/z, [x0, #-1]
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

ld1rb z0.b, p1/z, [x0, #64]
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: index must be in range [0, 63].
// CHECK-NEXT: ld1rb z0.b, p1/z, [x0, #64]
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:


// --------------------------------------------------------------------------//
// restricted predicate has range [0, 7].

ld1rb z0.b, p8/z, [x0]
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: invalid restricted predicate register, expected p0..p7 (without element suffix)
// CHECK-NEXT: ld1rb z0.b, p8/z, [x0]
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:


// --------------------------------------------------------------------------//
// Negative tests for instructions that are incompatible with movprfx

movprfx z31.d, p7/z, z6.d
ld1rb   { z31.d }, p7/z, [sp, #63]
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: instruction is unpredictable when following a movprfx, suggest replacing movprfx with mov
// CHECK-NEXT: ld1rb   { z31.d }, p7/z, [sp, #63]
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

movprfx z31, z6
ld1rb   { z31.d }, p7/z, [sp, #63]
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: instruction is unpredictable when following a movprfx, suggest replacing movprfx with mov
// CHECK-NEXT: ld1rb   { z31.d }, p7/z, [sp, #63]
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:
