#import "SCAsyncTestCase.h"

static SCReadItemScopeType scope_ = SCReadItemChildrenScope;

@interface ReadItemsCTestAuthExtended : SCAsyncTestCase
@end

@implementation ReadItemsCTestAuthExtended

-(void)testReadItemCAllowedItemAllowedChildrenWithAllFields
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;
    
    NSString* path_ = @"/sitecore/content/Home/Allowed_Parent";
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
        apiContext_ = strongContext_;
        
        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: path_
                                                                        fieldsNames: nil ];
        request_.scope = scope_;
        
        SCDidFinishAsyncOperationHandler doneHandelr = ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            
            SCDidFinishAsyncOperationHandler doneHandler1 = ^( NSArray* result_items_, NSError* error_ )
            {
                items_auth_ = result_items_;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader1 = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
            loader1(nil, nil, doneHandler1);
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandelr);
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    NSLog( @"items_: %@", items_ );
    NSLog( @"items_auth_: %@", items_auth_ );
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    //test get item without auth
    GHAssertTrue( [ items_ count ] == 1, @"OK" );

    //test get item with auth
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 2, @"OK" );
    SCItem* item_auth_ = items_auth_[ 0 ];
    //test item
    {   
        GHAssertTrue( item_auth_.parent == nil, @"OK" );
        GHAssertTrue( [ item_auth_.displayName isEqualToString: @"Allowed_Item" ], @"OK" );
        
        GHAssertTrue( item_auth_.allChildren == nil, @"OK" );
        GHAssertTrue( item_auth_.allFields != nil, @"OK" );
        GHAssertTrue( [ item_auth_.readFields count ] == 
                     [ item_auth_.allFields count ], @"OK" );
    }
}

-(void)testReadItemCNotAllowedItemAllowedChildrenWithSomeFields
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;
    
    NSString* path_ = @"/sitecore/content/Home/Not_Allowed_Parent";
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
        apiContext_ = strongContext_;
        
        NSSet* field_names_ = [ NSSet setWithObjects: @"Title", nil];
        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: path_
                                                                        fieldsNames: field_names_ ];
        request_.scope = scope_;
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            
            SCDidFinishAsyncOperationHandler doneHandler1 = ^( NSArray* result_items_, NSError* error_ )
            {
                items_auth_ = result_items_;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader1 = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
            loader1(nil, nil, doneHandler1);
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    NSLog( @"items_: %@", items_ );
    NSLog( @"items_auth_: %@", items_auth_ );
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    //test get item with auth
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 2, @"OK" );
    SCItem* item_ = nil;
    //test item
    {
        item_ = items_auth_[ 0 ];
        GHAssertTrue( item_.parent == nil, @"OK" );
        GHAssertTrue( item_.readChildren == nil, @"OK" );
        GHAssertTrue( item_.allFields == nil, @"OK" );
        GHAssertTrue( [ item_.readFields count ] == 1, @"OK" );
        GHAssertTrue( [ [ [ item_ fieldWithName: @"Title" ] rawValue ] isEqualToString: @"Allowed_Item" ], @"OK" );
    }
    
    //test get item without auth
    GHAssertTrue( [ items_ count ] == 0, @"OK" );
}


-(void)testReadItemCWithQuery
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;
    
    NSString* path_ = @"/sitecore/content/descendant::*[@@key='not_allowed_item']";
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
        apiContext_ = strongContext_;
        
        NSSet* field_names_ = [ NSSet new ];
        SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];
        request_.fieldNames = field_names_;
        request_.request = path_;
        request_.requestType = SCReadItemRequestQuery;
        request_.scope = scope_;
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            
            SCDidFinishAsyncOperationHandler doneHandler1 = ^( NSArray* result_items_, NSError* error_ )
            {
                items_auth_ = result_items_;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader1 = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
            loader1(nil, nil, doneHandler1);
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    NSLog( @"items_: %@", items_ );
    NSLog( @"items_auth_: %@", items_auth_ );
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    //test get item without auth
    GHAssertTrue( [ items_ count ] == 0, @"OK" );
    //test get item with auth
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 2, @"OK" );
    SCItem* item_ = nil;
    //test item
    {
        item_ = items_auth_[ 0 ];
        GHAssertTrue( [item_.displayName isEqualToString: @"Not_Allowed_Item"], @"OK" );
    }
}

@end
