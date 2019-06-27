Deprecated
==========

The number of Emoji characters to support has grown exponentially and maintaining them is no longer possible for me and it has been for quite a while. The code is antiqued and assumes iOS 5+.

You could recreate this using a list of emoji characters, displayed in UICollectionView, in a popover (since those exist on iPhone now).

Read the code, share it, update it, fork it, it's all yours now. 

Please don't open an issue.


SYEmojiPopover
==============

Popover view to select emoji character from iOS 6+ possible characters. iOS 6+, ARC.

After cloning the project please run:

	// download Popover submodule(s)
    git submodule init
    git submodule update


It consists in two classes:

  - `SYEmojiPopover`
    
  - `SYEmojiCharacters`


`SYEmojiCharacters` generates a list of Emoji characters separated in sections, depending on the iOS version the phone is running. I used iOS Emji keyboard to list those characters in the file `Characters/characters.txt`. It contains Emoji characters shown by iOS keyboard starting from 5.0, and characters supported by the OS even if they are not in this keyboard.

It contains the following methods:

	// singleton for this class
	+(SYEmojiCharacters*)sharedCharacters; 
	
	// determines if a string is an Emoji character supported in this iOS version
	-(BOOL)isCharacterEmoji:(NSString *)string; 
	
	// number of sections of characters
	-(NSUInteger)numberOfSections; 
	// number of characters in the section
	-(NSUInteger)numberOfRowsInSection:(NSUInteger)section; 
	// character in given section at given index
	-(NSString*)emojiAtRow:(NSUInteger)row andSection:(NSUInteger)section;



The second class, `SYEmojiPopover`, is the popover view. The popover in itslef is made by NicolasChengDev and can be found here: [WYPopoverController](https://github.com/nicolaschengdev/WYPopoverController). The view in the popover is implemented with UITableView. It is much quicker than `GMGridView` that you may find in previous versions, but the ability to change the size of the control is a little bit harder, explaining why it hasn't been implemented yet.

Here are the methods you can use:

	// delegate
	@property (weak, atomic) id<SYEmojiPopoverDelegate> delegate;
	
	// show the control at the specified point of a view, using a title
	-(void)showFromPoint:(CGPoint)point inView:(UIView*)view withTitle:(NSString*)title;


The delegate property implements `SYEmojiPopoverDelegate`, consisting in those methods:

	// required, will be called when a character is tapped
	-(void)emojiPopover:(SYEmojiPopover*)emojiPopover didClickedOnCharacter:(NSString*)character;

Sample project
==============

![Popover](https://raw.github.com/dvkch/SYEmojiPopover/master/screen1.png) ![Emoji character selected](https://raw.github.com/dvkch/SYEmojiPopover/master/screen2.png)



A sample project is included along with the sources. It consists in a simple project showing the popover and displaying character after a click.


The instance to the popover is a private member of the main view controller:

	@interface SYViewController : UIViewController <SYEmojiPopoverDelegate> {
	@private
    	SYEmojiPopover *_emojiPopover;
	}


When clicking on the button:


	- (IBAction)selectEmojiClick:(id)sender {
    	if(!self->_emojiPopover)
        	self->_emojiPopover = [[SYEmojiPopover alloc] init];
    
	    [self->_emojiPopover setDelegate:self];
    	[self->_emojiPopover showFromPoint:self.buttonEmoji.center 
    	                            inView:self.view
    	                         withTitle:@"Click on a character to see it in big"];
	}


Method called when clicking on Emoji character:


	-(void)emojiPopover:(SYEmojiPopover *)emojiPopover didClickedOnCharacter:(NSString *)character
	{
    	[self.labelEmoji setFont:[UIFont fontWithName:@"AppleColorEmoji" size:100.f]];
	    [self.labelEmoji setText:character];
	}



Characters app
==============

The repo also contains a simple OSX app. Its goal is to create the `-(void)loadCharacters` method of `SYEmojiCharacters` using a text file - mine is the `Characters/characters.txt` file. 

The text file uses a home made structure, respect it carefully in order to get the app working.

I included it to have it along with this project on the same repo, but it will only be useful for those of you who want to add characters or organize sections differently. 



Contributing
============

Any contribution of any sort is warmly welcomed, so if you have any question, suggestion or bug report please do not hesitate to contact me on Github, it will be more than a pleasure to answer you.

If you app is using this code please contact me so I can add it to a list of app for people to see this project.


License
=======

I do not really know licenses, so I won't give one precisely. I will just specify some rules I think fair:

  - this code is free to use for both free and commercial use.
  - you can modify it, fork it and redistribute it as you wish as long as I am somewhere in the thanks or licenses of the final program and the new code.



I hope you'll enjoy it,

-- dvkch
