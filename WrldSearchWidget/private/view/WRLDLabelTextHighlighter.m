#import "WRLDLabelTextHighlighter.h"

@implementation WRLDLabelTextHighlighter

+ (void) applyAttributedTextTo :(UILabel*)label
                       fullText:(NSString*) fullText
              regularAttributes:(NSDictionary *) regularAttributes
                       boldText:(NSString*) boldText
                 boldAttributes:(NSDictionary*) boldAttributes
{
    if(!label)
    {
        return;
    }
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:fullText attributes:regularAttributes];
    NSRange remainingString = NSMakeRange(0, [fullText length]);
    NSRange boldRange = [fullText rangeOfString:boldText options:NSCaseInsensitiveSearch range:remainingString];
    
    while(boldRange.location != NSNotFound)
    {
        [attributedText setAttributes:boldAttributes range:boldRange];
        NSInteger endOfBoldText = boldRange.location + boldRange.length;
        remainingString = NSMakeRange(endOfBoldText, [fullText length] - endOfBoldText);
        boldRange = [fullText rangeOfString:boldText options:NSCaseInsensitiveSearch range:remainingString];
    }
    
    [label setAttributedText: attributedText];
}

@end
