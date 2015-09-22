//
//  TransitTicketsController.m
//  MastercardFinal
//
//  Created by Brillio on 04/08/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "TransitTicketsController.h"
#import "FareViewController.h"
#import "ContactLessTicketsController.h"


@interface TransitTicketsController ()
{
    
    NSMutableArray *ticketListArray;
}
@end

@implementation TransitTicketsController
@synthesize TransitTicketsTableView;
@synthesize isFare;
-(void)viewDidLoad{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TransitTicketsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    NSMutableDictionary *mtaTicket=[[NSMutableDictionary alloc] init];
    [mtaTicket setObject:@"Grand Central - COS COB" forKey:@"ticketName"];
     [mtaTicket setObject:@"MTA 7-Days unlimited" forKey:@"ticketDescription"];
     [mtaTicket setObject:@"Tue, Aug\n 25" forKey:@"expairyDate"];
     [mtaTicket setObject:@"MTA.png" forKey:@"ticketLogo"];
    NSMutableDictionary *lirrTicket=[[NSMutableDictionary alloc] init];
    [lirrTicket setObject:@"Penn Station - Hicksville" forKey:@"ticketName"];
    [lirrTicket setObject:@"Departs track 2, NY Penn" forKey:@"ticketDescription"];
    [lirrTicket setObject:@"Tue, Aug\n 25" forKey:@"expairyDate"];
    [lirrTicket setObject:@"LIRR_icon.png" forKey:@"ticketLogo"];
//    NSMutableDictionary *pTicket=[[NSMutableDictionary alloc] init];
//    [pTicket setObject:@"Parking Lot" forKey:@"ticketName"];
//    [pTicket setObject:@"1783 6th Avenue" forKey:@"ticketDescription"];
//    [pTicket setObject:@"expires" forKey:@"expairyDate"];
//    [pTicket setObject:@"parking_fare.png" forKey:@"ticketLogo"];
    ticketListArray=[[NSMutableArray alloc] init];
    [ticketListArray addObject:mtaTicket];
    [ticketListArray addObject:lirrTicket];
//    [ticketListArray addObject:pTicket];
    //transitType=[[NSArray alloc]initWithObjects:@"New York City Bus", @"Long Island Rail Road",nil];
    
    self.TransitTicketsTableView.delegate = self;
    self.TransitTicketsTableView.dataSource = self;
    
}

- (IBAction)backBtnTap:(id)sender {
   
    if (self.isFare) {
      
        [self dismissViewControllerAnimated:YES completion:nil];

    }
   else
   {
        [self.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];   
   }

}

/*************Table View delegate and DataSource Methods***************/

//delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactLessTicketsController *ContactLessTicketVC = [[ContactLessTicketsController alloc] init];
    
    if (indexPath.row == 0) {
        ContactLessTicketVC.TicketName = @"Grand Central - COS COB";
        ContactLessTicketVC.OriginStationName = @"Grand Central";
        ContactLessTicketVC.DestinationStationName = @"COS COB";
    }
    
    if (indexPath.row == 1) {
        ContactLessTicketVC.TicketName = @"Penn Station - Hicksville";
        ContactLessTicketVC.OriginStationName = @"Pennstation";
        ContactLessTicketVC.DestinationStationName = @"Hicksville";
    }
   
    [self presentViewController:ContactLessTicketVC animated:YES completion:nil];
  
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
////datasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
       return ticketListArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    static NSString *ticketsListIdentifer = @"ticketsListIdentifer";
    
    UITableViewCell *cell = [ self.TransitTicketsTableView dequeueReusableCellWithIdentifier:nil];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:ticketsListIdentifer];
    }
    
    NSMutableDictionary *data=[ticketListArray objectAtIndex:indexPath.row];
   
    UIImageView *ticketLogo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    
    ticketLogo.image = [UIImage imageNamed:[data objectForKey:@"ticketLogo"]];
    
    UILabel *ticketName=[[UILabel alloc] initWithFrame:CGRectMake(60, 10, 210, 30)];
    ticketName.text=[data objectForKey:@"ticketName"];
    ticketName.font=[UIFont fontWithName:@"HelveticaNeue" size:16];
    ticketName.textColor=[UIColor blackColor];
    UILabel *ticketDes=[[UILabel alloc] initWithFrame:CGRectMake(60, 40, 210, 20)];
    ticketDes.text=[data objectForKey:@"ticketDescription"];
    ticketDes.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
    ticketDes.textColor=[UIColor darkGrayColor];
    UILabel *ticketExp=[[UILabel alloc] initWithFrame:CGRectMake(310, 40, 90, 40)];
    ticketExp.text=[data objectForKey:@"expairyDate"];
    ticketExp.textAlignment = NSTextAlignmentLeft;
    ticketExp.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
    ticketExp.numberOfLines = 2;
    ticketExp.textColor=[UIColor blackColor];
    UILabel *expLbl=[[UILabel alloc] initWithFrame:CGRectMake(310, 20, 90, 20)];
    expLbl.text=@"Expires";
    expLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
    expLbl.textColor=[UIColor darkGrayColor];
    expLbl.textAlignment=NSTextAlignmentLeft;
    
    [cell.contentView addSubview:ticketLogo];
    [cell.contentView addSubview:ticketName];
    [cell.contentView addSubview:expLbl];
    [cell.contentView addSubview:ticketDes];
    [cell.contentView addSubview:ticketExp];
    //cell.textLabel.text = [transitType objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    return cell;
}
@end
