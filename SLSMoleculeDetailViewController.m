//
//  SLSMoleculeDetailViewController.m
//  Molecules
//
//  The source code for Molecules is available under a BSD license.  See License.txt for details.
//
//  Created by Brad Larson on 7/5/2008.
//
//  This controller manages the detail view of the molecule's properties, such as author, publication, etc.

#import "SLSMoleculeDetailViewController.h"
#import "SLSMolecule.h"
#import "SLSTextViewController.h"

#define DESCRIPTION_SECTION 0
#define AUTHOR_SECTION 1
#define STATISTICS_SECTION 2
#define JOURNAL_SECTION 3
#define SOURCE_SECTION 4
#define SEQUENCE_SECTION 5

@implementation SLSMoleculeDetailViewController


- (id)initWithStyle:(UITableViewStyle)style andMolecule:(SLSMolecule *)newMolecule;
{
	if (self = [super initWithStyle:style]) 
	{
		self.view.frame = [[UIScreen mainScreen] applicationFrame];
		self.view.autoresizesSubviews = YES;
		self.molecule = newMolecule;
		[newMolecule readMetadataFromDatabaseIfNecessary];
		self.title = molecule.compound;

		UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(25.0, 60.0, 320.0, 66.0)];
		label.textColor = [UIColor blackColor];
		label.font = [UIFont fontWithName:@"Helvetica" size:18.0];
		label.backgroundColor = [UIColor groupTableViewBackgroundColor];	
		label.text = molecule.compound;
		label.numberOfLines = 3;
		label.lineBreakMode = UILineBreakModeWordWrap;
		label.textAlignment = UITextAlignmentCenter;
		//	label.text = @"Text";
		
		self.tableView.tableHeaderView = label;
		[label release];
	}
	return self;
}

- (void)dealloc 
{
	[super dealloc];
}

- (void)viewDidLoad 
{
//	UILabel *label= [[UILabel alloc] initWithFrame:CGRectZero];
	[super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated 
{
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated 
{
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated 
{
}

- (void)viewDidDisappear:(BOOL)animated 
{
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark UITableView Delegate/Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 6;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    switch (section) 
	{
        case DESCRIPTION_SECTION:
            return @"Description";
        case STATISTICS_SECTION:
            return @"Statistics";
        case JOURNAL_SECTION:
            return @"Journal";
        case SOURCE_SECTION:
            return @"Source";
        case AUTHOR_SECTION:
            return @"Author(s)";
        case SEQUENCE_SECTION:
            return @"Sequence";
		default:
			break;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	NSInteger rows = 0;
	
	switch (section) 
	{
		case DESCRIPTION_SECTION:
		case AUTHOR_SECTION:
		case SOURCE_SECTION:
		case SEQUENCE_SECTION:
			rows = 1;
			break;
		case STATISTICS_SECTION:
			rows = 4;
			break;
        case JOURNAL_SECTION:
            rows = 3;
            break;
		default:
			break;
	}
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == STATISTICS_SECTION) 
	{
		static NSString *StatisticsCellIdentifier = @"StatisticsCell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:StatisticsCellIdentifier];
		if (cell == nil) 
		{
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:StatisticsCellIdentifier] autorelease];
			
			CGRect frame = CGRectMake(CGRectGetMaxX(cell.contentView.bounds) - 170.0, 5.0, 160.0, 32.0);
			UILabel *valueLabel = [[UILabel alloc] initWithFrame:frame];
            [valueLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
			valueLabel.tag = 1;
			valueLabel.textAlignment = UITextAlignmentRight;
			valueLabel.textColor = [UIColor colorWithRed:50.0/255.0 green:79.0/255.0 blue:133.0/255.0 alpha:1.0];
            valueLabel.highlightedTextColor = [UIColor whiteColor];
			[cell.contentView addSubview:valueLabel];
			[valueLabel release];
		}
		
		switch (indexPath.row)
		{
			case 0:
			{
				cell.text = @"File name";
				UILabel *valueLabel = (UILabel *)[cell viewWithTag:1];
				valueLabel.text = molecule.filename;
			}; break;
			case 1:
			{
				cell.text = @"Number of atoms";
				UILabel *valueLabel = (UILabel *)[cell viewWithTag:1];
				valueLabel.text = [NSString stringWithFormat:@"%d", molecule.numberOfAtoms];
			}; break;
			case 2:
			{
				cell.text = @"Number of structures";
				UILabel *valueLabel = (UILabel *)[cell viewWithTag:1];
				valueLabel.text = [NSString stringWithFormat:@"%d", molecule.numberOfStructures];
			}; break;
			case 3:
			{
				cell.text = @"Current structure";
				UILabel *valueLabel = (UILabel *)[cell viewWithTag:1];
				valueLabel.text = [NSString stringWithFormat:@"%d", molecule.numberOfStructureBeingDisplayed];
			}; break;
		}
		return cell;
	}

	static NSString *MyIdentifier = @"MyIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	cell.text = [self textForIndexPath:indexPath];
	
	
//	static NSString *DetailedTextCell = @"DetailedTextCell";
//
//	CellTextView *cell = (CellTextView *)[tableView dequeueReusableCellWithIdentifier:DetailedTextCell];
//
//	if (cell == nil)
//	{
//		cell = [[[CellTextView alloc] initWithFrame:CGRectZero reuseIdentifier:DetailedTextCell] autorelease];
//	}
//
//	cell.view = [self createLabelForIndexPath:indexPath];
	return cell;
}

- (UILabel *)createLabelForIndexPath:(NSIndexPath *)indexPath;
{
	NSString *text = nil;
    switch (indexPath.section) 
	{
		case DESCRIPTION_SECTION: // type -- should be selectable -> checkbox
			text = molecule.title;
			break;
		case AUTHOR_SECTION: // instructions
			text = molecule.author;
			break;
        case JOURNAL_SECTION:
		{
			switch (indexPath.row)
			{
				case 0: text = molecule.journalTitle; break;
				case 1: text = molecule.journalAuthor; break;
				case 2: text = molecule.journalReference; break;
			}
		}; break;
        case SOURCE_SECTION:
			text = molecule.source;
			break;
		case SEQUENCE_SECTION:
			text = molecule.sequence;
			break;
		default:
			break;
	}
    	
//	CGRect frame = CGRectMake(0.0, 0.0, 100.0, 100.0);

	UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
    label.textColor = [UIColor blackColor];
//    textView.font = [UIFont fontWithName:@"Helvetica" size:18.0];
//	textView.editable = NO;
    label.backgroundColor = [UIColor whiteColor];
	
	label.text = text;
	
	return [label autorelease];
}

//#define HEIGHTPERLINE 23.0
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	CGFloat result;
//
//	switch (indexPath.section) 
//	{
//		case DESCRIPTION_SECTION: // type -- should be selectable -> checkbox
//			result = (float)[molecule.title length] * HEIGHTPERLINE;
//			break;
//		case AUTHOR_SECTION: // instructions
//			result = (float)[molecule.author length] * HEIGHTPERLINE;
//			break;
//        case JOURNAL_SECTION:
//		{
//			switch (indexPath.row)
//			{
//				case 0: result = (float)[molecule.journalTitle length] * HEIGHTPERLINE; break;
//				case 1: result = (float)[molecule.journalAuthor length] * HEIGHTPERLINE; break;
//				case 2: result = (float)[molecule.journalReference length] * HEIGHTPERLINE; break;
//			}
//		}; break;
//        case SOURCE_SECTION:
//			result = (float)[molecule.source length] * HEIGHTPERLINE;
//			break;
//		case SEQUENCE_SECTION:
//			result = (float)[molecule.sequence length] * HEIGHTPERLINE;
//			break;
//		default:
//			result = 43.0;
//			break;
//	}
//	
//	return result;
//}

- (NSString *)textForIndexPath:(NSIndexPath *)indexPath;
{
	NSString *text;
	switch (indexPath.section) 
	{
		case DESCRIPTION_SECTION:
			text = molecule.title;
			break;
		case AUTHOR_SECTION:
			text = molecule.author;
			break;
        case JOURNAL_SECTION:
		{
			switch (indexPath.row)
			{
				case 0: text = molecule.journalTitle; break;
				case 1: text = molecule.journalAuthor; break;
				case 2: text = molecule.journalReference; break;
			}
		}; break;
        case SOURCE_SECTION:
			text = molecule.source;
			break;
		case SEQUENCE_SECTION:
			text = molecule.sequence;
			break;
//		default:
//			result = 43.0;
//			break;
	}
	
	return [text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (indexPath.section != STATISTICS_SECTION)
	{
		SLSTextViewController *nextViewController = [[SLSTextViewController alloc] initWithTitle:[self tableView:tableView titleForHeaderInSection:indexPath.section] andContent:[self textForIndexPath:indexPath]];
		[self.navigationController pushViewController:nextViewController animated:YES];
		[nextViewController release];
	}
	
}

#pragma mark -
#pragma mark Accessors

@synthesize molecule;

@end
