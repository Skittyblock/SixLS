@class NCNotificationStructuredSectionList;

@interface NCNotificationMasterList : NSObject
@property (nonatomic, retain) NCNotificationStructuredSectionList *incomingSectionList;
- (id)allNotificationRequests; // NCNotificationPriortyList
@end
