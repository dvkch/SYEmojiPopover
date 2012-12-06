//
//  main.m
//  Characters
//
//  Created by rominet on 12/6/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
    for(uint i = 0; i < argc; ++i)
        NSLog(@"%@", [NSString stringWithUTF8String:argv[i]]);
    
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:NO];
    [openDlg setPrompt:@"Use this character set"];
    [openDlg setTitle:@"Choose the character set file"];
    
    if ([openDlg runModal] == NSOKButton)
    {
        NSArray* files = [openDlg URLs];
        if([files count] == 0)
            return 0;
        
        NSString* pathIN  = [[files objectAtIndex:0] path];
        NSString* pathOUT = [[[[files objectAtIndex:0] path] stringByDeletingPathExtension] stringByAppendingString:@".m"];
        
        NSStringEncoding encoding;
        NSString *strIN  = [NSString stringWithContentsOfFile:pathIN usedEncoding:&encoding error:nil];
        NSString *strOUT = @"";
        
        strOUT = [strOUT stringByAppendingString:@"-(void)loadCharacters"];
        strOUT = [strOUT stringByAppendingString:@"\n"];
        strOUT = [strOUT stringByAppendingString:@"{"];
        strOUT = [strOUT stringByAppendingString:@"\n"];
        strOUT = [strOUT stringByAppendingString:@"    self->_characters = [NSMutableArray array];"];
        
        int uid_count = 0;
        NSArray *strINlines = [strIN componentsSeparatedByString:@"\n"];
        for(NSString *s in strINlines)
        {
            strOUT = [strOUT stringByAppendingString:@"\n"];
            
            BOOL commentLine  = [s hasPrefix:@"##"] || [s isEqualToString:@""];
            BOOL versionLine1 = [s hasPrefix:@"#>="];
            BOOL versionLine2 = [s hasPrefix:@"#<"];
            BOOL endBlockLine = [s hasPrefix:@"#;"];
            
            if(commentLine) {
                strOUT = [strOUT stringByAppendingFormat:@"// %@", s];
                continue;
            }
            else if (versionLine1) {
                NSString *version = [s stringByReplacingOccurrencesOfString:@"#>=" withString:@""];
                version = [version stringByReplacingOccurrencesOfString:@" " withString:@""];
                strOUT = [strOUT stringByAppendingFormat:@"    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@\"%@\") &&", version];
                continue;
            }
            else if (versionLine2) {
                NSString *version = [s stringByReplacingOccurrencesOfString:@"#<" withString:@""];
                version = [version stringByReplacingOccurrencesOfString:@" " withString:@""];
                strOUT = [strOUT stringByAppendingFormat:@"        SYSTEM_VERSION_LESS_THAN(@\"%@\")) {", version];
                continue;
            }
            else if (endBlockLine) {
                strOUT = [strOUT stringByAppendingString:@"    }"];
                continue;
            }
            
            NSString *uid = [NSString stringWithFormat:@"chars_%03d", uid_count];
            ++uid_count;

            NSArray *sCharacters = [s componentsSeparatedByString:@","];
            NSString *c = nil;
            
            strOUT = [strOUT stringByAppendingFormat:@"        NSArray *%@ = @[", uid];
            strOUT = [strOUT stringByAppendingString:@"\n            "];
            
            for(uint i = 0; i < [sCharacters count]; ++i) {
                
                c = [sCharacters objectAtIndex:i];
                
//                NSLog(@"%s", [c UTF8String]);
                
                strOUT = [strOUT stringByAppendingFormat:@"@\"%@\"%@", c, (i+1 == [sCharacters count] ? @"" : @", ")];
                
                if(i % 10 == 9) // filled a line of 10 characters
                    strOUT = [strOUT stringByAppendingString:@"\n            "];
            }
            strOUT = [strOUT stringByAppendingString:@"];"];
            strOUT = [strOUT stringByAppendingString:@"\n"];
            strOUT = [strOUT stringByAppendingFormat:@"        [self->_characters addObject:%@];", uid];
            strOUT = [strOUT stringByAppendingString:@"\n"];
        }

        strOUT = [strOUT stringByAppendingString:@"\n"];
        strOUT = [strOUT stringByAppendingString:@"}"];
        
        [strOUT writeToFile:pathOUT atomically:YES encoding:encoding error:nil];
    }
}
