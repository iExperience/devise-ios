//
//  DVSHomeViewSpec.m
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

SPEC_BEGIN(DVSHomeViewSpec)

describe(@"Home screen", ^{
    
    describe(@"tapping delete button", ^{
        
        __block id<OHHTTPStubsDescriptor> stub = nil;
        
        beforeAll(^{
            stub = [OHHTTPStubs dvs_stubUserDeleteRequestsWithOptions:nil];
        });
        
        afterAll(^{
            [OHHTTPStubs removeStub:stub];
        });
        
        beforeEach(^{
            [tester dvs_login];
        });
        
        it(@"should show confirm popup", ^{
            [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Delete profile")];
            [tester waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Delete")];
            [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"No")];
            [tester dvs_tapLogOutButton];
        });
        
        
        describe(@"when confirm button is tapped", ^{
            
            beforeEach(^{
                [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Delete profile")];
                [tester waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Delete")];
            });
            
            it(@"should delete profile", ^{
                [tester tapViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Yes")];
                [tester waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Welcome")];
            });
        });
        
    });
});

SPEC_END
