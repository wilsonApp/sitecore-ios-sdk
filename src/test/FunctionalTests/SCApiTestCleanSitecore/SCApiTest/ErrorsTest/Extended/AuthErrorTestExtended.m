#import "SCAsyncTestCase.h"

@interface AuthErrorTestExtended : SCAsyncTestCase
@end

@implementation AuthErrorTestExtended

-(void)testReadItemWithAllowAnonymousWithWrongLoginPwd
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCApiError* item_error_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                                 login: @"aaa"
                                                              password: @"bbb"
                                                               version: SCWebApiV1 ];
                apiContext_ = strongContext_;
                SCItemSourcePOD* contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];

                NSString* path_ = SCHidedPath;
                
                SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* result_item_, NSError* error_ )
                {
                    item_error_ = (SCApiError*)error_;
                    item_ = result_item_;
                    didFinishCallback_();
                };
                
                SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemOperationForItemPath: path_
                                                                                       itemSource: contextSource ];
                loader(nil, nil, doneHandler);
            }
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    
    GHAssertTrue( [ item_error_ isKindOfClass: [ SCNoItemError class ] ] == TRUE, @"OK" );

}

-(void)testReadItemWithAllowAnonymousWithEmptyLoginPwd
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_        = nil;
    __block SCApiError* item_error_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
                                                             login: @""
                                                          password: @"" ];
            strongContext_.defaultDatabase = @"web";
            apiContext_ = strongContext_;
            SCItemSourcePOD* contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];

            NSString* path_ = SCHidedPath;
            SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* result_item_, NSError* error_ )
            {
                item_error_ = (SCApiError*)error_;
                item_ = result_item_;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemOperationForItemPath: path_
                                                                                   itemSource: contextSource ];
            loader(nil, nil, doneHandler);
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }

    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    
    GHAssertTrue( [ item_error_ isKindOfClass: [ SCNoItemError class ] ] == TRUE, @"OK" );

}

-(void)testReadItemWithAllowAnonymousWithInvalidLogin
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCApiError* item_error_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
                                                                 login: @"yuQ^:`~%" 
                                                              password: @"" ];
                apiContext_ = strongContext_;
                SCItemSourcePOD* contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];
                
                NSString* path_ = SCHidedPath;
                SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* result_item_, NSError* error_ )
                {
                    item_error_ = (SCApiError*)error_;
                    item_ = result_item_;
                    didFinishCallback_();
                };
                
                SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemOperationForItemPath: path_
                                                                                       itemSource: contextSource ];
                loader(nil, nil, doneHandler);
            }
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    GHAssertTrue( [ item_error_ isKindOfClass: [ SCNoItemError class ] ] == TRUE, @"OK" );

}

-(void)testReadItemWithAllowAnonymousWithInvalidPwd
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCApiError* item_error_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
                                                                 login: @"test" 
                                                              password: @"yuQ^:`~%  " ];
                apiContext_ = strongContext_;
                SCItemSourcePOD* contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];
                
                NSString* path_ = SCHidedPath;
                SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* result_item_, NSError* error_ )
                {
                    item_error_ = (SCApiError*)error_;
                    item_ = result_item_;
                    didFinishCallback_();
                };
                
                SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemOperationForItemPath: path_
                                                                                       itemSource: contextSource ];
                loader(nil, nil, doneHandler);
            }
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    GHAssertTrue( [ item_error_ isKindOfClass: [ SCNoItemError class ] ] == TRUE, @"OK" );

}

-(void)testReadItemWithAllowAnonymousWithWrongPwd
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCApiError* item_error_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName 
                                                                 login: @"test" 
                                                              password: @"_test" ];
                apiContext_ = strongContext_;
                SCItemSourcePOD* contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];

                NSString* path_ = SCHidedPath;
                SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* result_item_, NSError* error_ )
                {
                    item_error_ = (SCApiError*)error_;
                    item_ = result_item_;
                    didFinishCallback_();
                };
                
                SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemOperationForItemPath: path_
                                                                                       itemSource: contextSource ];
                loader(nil, nil, doneHandler);
            }
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( item_ == nil, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    GHAssertTrue( [ item_error_ isKindOfClass: [ SCNoItemError class ] ] == TRUE, @"OK" );

}

-(void)testReadItemAsAnonymous
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCApiError* item_error_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName ];
                apiContext_ = strongContext_;
                SCItemSourcePOD* contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];

                NSString* path_ = SCHomePath;
                SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* result_item_, NSError* error_ )
                {
                    item_error_ = (SCApiError*)error_;
                    item_ = result_item_;
                    didFinishCallback_();
                };
                
                SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemOperationForItemPath: path_
                                                                                       itemSource: contextSource ];
                loader(nil, nil, doneHandler);
            }
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( item_error_ == nil, @"OK" );

}

-(void)testReadItemWithAuthWithRightLoginPwd_Shell
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCApiError* item_error_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                                 login: SCWebApiAdminLogin
                                                              password: SCWebApiAdminPassword ];
                apiContext_ = strongContext_;
                apiContext_.defaultSite = @"/sitecore/shell";
                SCItemSourcePOD* contextSource = [ [ apiContext_.extendedApiSession contextSource ] copy ];
                
                NSString* path_ = SCHomePath;
                SCDidFinishAsyncOperationHandler doneHandler = ^( SCItem* result_item_, NSError* error_ )
                {
                    item_error_ = (SCApiError*)error_;
                    item_ = result_item_;
                    didFinishCallback_();
                };
                
                SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemOperationForItemPath: path_
                                                                                       itemSource: contextSource ];
                loader(nil, nil, doneHandler);
            }
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( item_error_ == nil, @"OK" );
}

@end