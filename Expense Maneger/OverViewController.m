//
//  OverViewController.m
//  Expense Maneger
//
//  Created by David on 1/19/16.
//  Copyright © 2016 elena. All rights reserved.
//

#import "OverViewController.h"
#import "PNChart.h"
#import "Model.h"

@implementation OverViewController


@synthesize pickerData;


- (void)viewDidLoad {
    [super viewDidLoad];
 
    colors = @[PNBlue,PNRed,PNGreen,PNYellow,PNGrey];
    sheetNamesForPicker = [[NSArray alloc]initWithArray:[[Model instance] getAllSheetNames]];
    _currentSheet = [[Model instance]getSheetId:[sheetNamesForPicker objectAtIndex:0]];
    NSMutableDictionary* itemsRec = [[Model instance]getUsersAndSums:_currentSheet];
    NSArray* allKeys = [itemsRec allKeys];
    
    for (int i = 0; i < itemsRec.count; i++) {
        NSNumber* temp = [itemsRec valueForKey:[allKeys objectAtIndex:i]];
        float f = [temp floatValue];
        
        [items addObject:[PNPieChartDataItem dataItemWithValue:f color:[colors objectAtIndex:i%5] description:[allKeys objectAtIndex:i]]];
    }
    
    if (items.count > 0) {
        [self setChart];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self refreshItems];
}

-(void)refreshItems{
    if (items == nil) {
        items = [[NSMutableArray alloc] init];
    }else{
        [items removeAllObjects];
    }
    
    [[Model instance]getAllRelevantExpensesAsync:^{
        sheetNamesForPicker = [[NSArray alloc]initWithArray:[[Model instance] getAllSheetNames]];
        NSMutableDictionary* itemsRec = [[Model instance]getUsersAndSums:_currentSheet];
        NSArray* allKeys = [itemsRec allKeys];
        
        for (int i = 0; i < itemsRec.count; i++) {
            NSNumber* temp = [itemsRec valueForKey:[allKeys objectAtIndex:i]];
            float f = [temp floatValue];
            
            [items addObject:[PNPieChartDataItem dataItemWithValue:f color:[colors objectAtIndex:i%5] description:[allKeys objectAtIndex:i]]];
        }
        [self setChart];
        [self.activityIndicator stopAnimating];
    }];
}

-(void)setChart{
    if (items.count > 0) {
        pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(40.0, 155.0, 240.0, 240.0) items:items];
        pieChart.descriptionTextColor = [UIColor whiteColor];
        pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
        [pieChart strokeChart];
        
        pieChart.legendStyle = PNLegendItemStyleStacked;
        UIView *legend = [pieChart getLegendWithMaxWidth:200];
        
        //Move legend to the desired position and add to view
        [legend setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, 420, legend.frame.size.width, legend.frame.size.height)];
        [self.view addSubview:legend];
        [self.view addSubview:pieChart];
    }
}

//The void statment to configue the REST of a pickerView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;//The Lable
}
//How many Rows of Data the picker display = How many Rows in NSArray
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [sheetNamesForPicker count];
}

//To Display the Title of the Row
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [sheetNamesForPicker objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _currentSheet = [sheetNamesForPicker objectAtIndex:row];
    [self setChart];
//    expenses = [[Model instance]getExpensesForSheet:_currentSheet useSheetName:YES];
//    [currentExpenses removeAllObjects];
//    
//    for (int i=0; i < expenses.count % 7; i++) {
//        [currentExpenses addObject:[expenses objectAtIndex:i]];
//    }
//    
//    [self.myTableView reloadData];
//    
//    
}- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end