//
//  ReminderItems.m
//  ReminderMore
//
//  Created by Masayuki Nii on 2012/09/13.
//  Copyright (c) 2012年 Masayuki Nii. All rights reserved.
//

@implementation ReminderItems

-(id)init
{
    self = [super init];
    if (self)   {
        NSMutableArray *tempReminder = [NSMutableArray array];
        EKEventStore *store = [[EKEventStore alloc] initWithAccessToEntityTypes:EKEntityMaskReminder];
        NSPredicate *predicate = [store predicateForRemindersInCalendars:nil];
        [store fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders) {
            for (EKReminder *reminder in reminders) {
                EKAlarm *a = [reminder.alarms objectAtIndex:0];
                [tempReminder addObject:
                 [NSDictionary dictionaryWithObjectsAndKeys:
                  reminder.calendar.title, @"caltitle",
                  reminder.title, @"itemtitle",
                  reminder.URL == nil ? [NSNull null] : reminder.URL, @"url",
                  reminder.notes == nil ? [NSNull null] : reminder.notes, @"notes",
                  a.absoluteDate == nil ? [NSNull null] : a.absoluteDate, @"datetime",
                  [NSNumber numberWithBool:reminder.completed], @"copleted",
                  nil]];
                NSLog(@"===========\nreminder.calendar.title=%@\nreminder.title=%@\nreminder.location=%@\n"
                      "reminder.creationDate=%@\nreminder.lastModifiedDate=%@\nreminder.timeZone=%@\n"
                      "reminder.URL=%@\nreminder.location=%@\nreminder.hasAlarms=%d\nreminder.hasNotes=%d\n"
                      "reminder.notes=%@\n",
                      reminder.calendar.title, reminder.title, reminder.location,
                      reminder.creationDate, reminder.lastModifiedDate, reminder.timeZone,
                      reminder.URL, reminder.location, reminder.hasAlarms, reminder.hasNotes, reminder.notes);
                for ( EKAlarm *a in reminder.alarms )   {
                    NSLog ( @"-------\nalarm.absoluteDate=%@\nalarms.relativeOffset=%f\n"
                           "alarm.structuredLocation.title=%@\nalarm.structuredLocation.geoLocation=%@\n"
                           "alarm.structuredLocation.radius=%f\nalarm.proximity=%ld\nalarm.type=%d\n"
                           "alarm.emailAddress=%@\nalarm.soundName=%@\nalarm.url=%@\n",
                           a.absoluteDate, a.relativeOffset,a.structuredLocation.title,a.structuredLocation.geoLocation,
                           a.structuredLocation.radius, a.proximity, a.type, a.emailAddress, a.soundName, a.url);
                }
                
                NSLog( @"priorityNumber=%@",[reminder performSelector:@selector(priorityNumber) withObject: nil ] );
                
            }
            //self.reminders = [NSArray arrayWithArray: tempReminder];
            //    NSLog( @"%@", self.reminders);
        }];
    }
    return self;
    
}
@end
