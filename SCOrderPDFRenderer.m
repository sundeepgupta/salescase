//
//  SCOrderPDFRenderer.m
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-04-03.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SCOrderPDFRenderer.h"
#import "SCOrder.h"
#import "SCGlobal.h"
#import "SCSalesRep.h"
#import "SCSalesTerm.h"
#import "SCShipMethod.h"
#import "SCCustomer.h"
#import "SCAddress.h"
#import "SCLine.h"
#import "SCItem.h"


//PDF constants
static CGFloat const kPageWidth = 612;
static CGFloat const kPageHeight = 792;
static CGFloat const kPagePadding = 30;
static CGFloat const kFontSize = 10;
static CGFloat const klineHeight = 14;

@interface SCOrderPDFRenderer ()

@property CGContextRef context;
@property NSInteger currentPage;

//User Company Info
@property (strong, nonatomic) IBOutlet UILabel *userCompanyName;
@property (strong, nonatomic) IBOutlet UILabel *userAddress1;
@property (strong, nonatomic) IBOutlet UILabel *userAddress2;
@property (strong, nonatomic) IBOutlet UILabel *userAddress3;
@property (strong, nonatomic) IBOutlet UILabel *userAddress4;
@property (strong, nonatomic) IBOutlet UILabel *userAddress5;
@property (strong, nonatomic) IBOutlet UILabel *userPhone;
@property (strong, nonatomic) IBOutlet UILabel *userFax;
@property (strong, nonatomic) IBOutlet UILabel *userEmail;
@property (strong, nonatomic) IBOutlet UILabel *userWebsite;

//Order Header
@property (strong, nonatomic) IBOutlet UILabel *statusTitle;
@property (strong, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UILabel *orderId;
@property (strong, nonatomic) IBOutlet UILabel *orderDate;
@property (strong, nonatomic) IBOutlet UILabel *orderDateTitle;
@property (strong, nonatomic) IBOutlet UILabel *poNumberTitle;
@property (strong, nonatomic) IBOutlet UILabel *poNumber;
@property (strong, nonatomic) IBOutlet UILabel *shipDate;
@property (strong, nonatomic) IBOutlet UILabel *shipDateTitle;
@property (strong, nonatomic) IBOutlet UILabel *printDate;
@property (strong, nonatomic) IBOutlet UILabel *printDateTitle;
@property (strong, nonatomic) IBOutlet UILabel *rep;
@property (strong, nonatomic) IBOutlet UILabel *repTitle;
@property (strong, nonatomic) IBOutlet UILabel *shipVia;
@property (strong, nonatomic) IBOutlet UILabel *shipViaTitle;
@property (strong, nonatomic) IBOutlet UILabel *terms;
@property (strong, nonatomic) IBOutlet UILabel *termsTitle;

//Bill to and Ship to
@property (strong, nonatomic) IBOutlet UILabel *billToTitle;
@property (strong, nonatomic) IBOutlet UILabel *companyName;
@property (strong, nonatomic) IBOutlet UILabel *address1;
@property (strong, nonatomic) IBOutlet UILabel *address2;
@property (strong, nonatomic) IBOutlet UILabel *address3;
@property (strong, nonatomic) IBOutlet UILabel *address4;
@property (strong, nonatomic) IBOutlet UILabel *address5;
@property (strong, nonatomic) IBOutlet UILabel *shipToTitle;
@property (strong, nonatomic) IBOutlet UILabel *shipTo1;
@property (strong, nonatomic) IBOutlet UILabel *shipTo2;
@property (strong, nonatomic) IBOutlet UILabel *shipTo3;
@property (strong, nonatomic) IBOutlet UILabel *shipTo4;
@property (strong, nonatomic) IBOutlet UILabel *shipTo5;

//Line items
@property (strong, nonatomic) IBOutlet UILabel *itemNameHeader;
@property (strong, nonatomic) IBOutlet UILabel *itemDescriptionHeader;
@property (strong, nonatomic) IBOutlet UILabel *itemQuantityHeader;
@property (strong, nonatomic) IBOutlet UILabel *itemPriceHeader;
@property (strong, nonatomic) IBOutlet UILabel *itemAmountHeader;
@property (strong, nonatomic) IBOutlet UILabel *itemName;
@property (strong, nonatomic) IBOutlet UILabel *itemDescription;
@property (strong, nonatomic) IBOutlet UILabel *itemQuantity;
@property (strong, nonatomic) IBOutlet UILabel *itemPrice;
@property (strong, nonatomic) IBOutlet UILabel *itemAmount;

//Footer
@property (strong, nonatomic) IBOutlet UITextView *notes;
@property (strong, nonatomic) IBOutlet UILabel *total;

//Page number
@property (strong, nonatomic) IBOutlet UILabel *pageNumber;


@end

@implementation SCOrderPDFRenderer

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setOrderId:nil];
    [self setOrderDate:nil];
    [self setPoNumber:nil];
    [self setOrderDateTitle:nil];
    [self setPoNumberTitle:nil];
    [self setUserCompanyName:nil];
    [self setUserAddress1:nil];
    [self setUserAddress2:nil];
    [self setUserAddress3:nil];
    [self setUserAddress4:nil];
    [self setUserAddress5:nil];
    [self setUserPhone:nil];
    [self setUserFax:nil];
    [self setUserEmail:nil];
    [self setUserWebsite:nil];
    [self setShipDate:nil];
    [self setShipDateTitle:nil];
    [self setPrintDate:nil];
    [self setPrintDateTitle:nil];
    [self setRep:nil];
    [self setRepTitle:nil];
    [self setShipVia:nil];
    [self setShipViaTitle:nil];
    [self setTerms:nil];
    [self setTermsTitle:nil];
    [self setBillToTitle:nil];
    [self setCompanyName:nil];
    [self setAddress1:nil];
    [self setAddress2:nil];
    [self setAddress3:nil];
    [self setAddress4:nil];
    [self setAddress5:nil];
    [self setShipToTitle:nil];
    [self setShipTo1:nil];
    [self setShipTo2:nil];
    [self setShipTo3:nil];
    [self setShipTo4:nil];
    [self setShipTo5:nil];
    [self setItemNameHeader:nil];
    [self setItemDescriptionHeader:nil];
    [self setItemQuantityHeader:nil];
    [self setItemPriceHeader:nil];
    [self setItemAmountHeader:nil];
    [self setTotal:nil];
    [self setNotes:nil];
    [self setPageNumber:nil];
    [self setStatusTitle:nil];
    [self setStatus:nil];
    [super viewDidUnload];
}

#pragma mark - Custom Methods
- (void)createPDF 
{
    [self loadAllPagesElementsData];
    [self setupPDFDocumentNamed:PDF_FILENAME Width:kPageWidth Height:kPageHeight];
    [self beginPDFPage];
    
    self.context = UIGraphicsGetCurrentContext();
    UIColor *lineColor = [UIColor blackColor];
    CGContextSetStrokeColorWithColor(self.context, lineColor.CGColor);
    CGContextSetLineWidth(self.context, 1);
    
    [self addAllPagesElements];
    [self addLines];
    [self finishPDF];
}

- (void)loadAllPagesElementsData
{
    //User Company Info
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *companyInfo = [defaults objectForKey:@"CompanyInfo"];
    self.userCompanyName.text = [companyInfo objectForKey:@"Name"];
    self.userAddress1.text = [companyInfo objectForKey:@"Address1"];
    self.userAddress2.text = [companyInfo objectForKey:@"Address2"];
    self.userAddress3.text = [companyInfo objectForKey:@"Address3"];
    self.userAddress4.text = [companyInfo objectForKey:@"Address4"];
    self.userAddress5.text = [companyInfo objectForKey:@"Address5"];
    self.userPhone.text = [NSString stringWithFormat:@"Phone: %@", [companyInfo objectForKey:@"Phone"]];
    self.userFax.text = [NSString stringWithFormat:@"Fax: %@", [companyInfo objectForKey:@"Fax"]];
    self.userEmail.text = [companyInfo objectForKey:@"Email"];
    self.userWebsite.text = [companyInfo objectForKey:@"Website"];

    //Order Header
    self.status.text = [self.order fullStatus];    
    self.orderId.text = [NSString stringWithFormat:@"SalesCase Order #%@", self.order.scOrderId.stringValue];
    self.orderDate.text = [SCGlobal stringFromDate:self.order.createDate];
    self.poNumber.text = self.order.poNumber;
    self.shipDate.text = [SCGlobal stringFromDate:self.order.shipDate];
    self.printDate.text = [SCGlobal stringFromDate:[NSDate date]];
    self.rep.text = self.order.salesRep.name;
    self.shipVia.text = self.order.shipMethod.name;
    self.terms.text = self.order.salesTerm.name;
    
    //Bill to and Ship to
    self.companyName.text = self.order.customer.dbaName;
    self.address1.text = self.order.customer.primaryBillingAddress.line1;
    self.address2.text = self.order.customer.primaryBillingAddress.line2;
    self.address3.text = self.order.customer.primaryBillingAddress.line3;
    self.address4.text = self.order.customer.primaryBillingAddress.line4;
    self.address5.text = self.order.customer.primaryBillingAddress.line5;
    self.shipTo1.text = self.order.customer.primaryShippingAddress.line1;
    self.shipTo2.text = self.order.customer.primaryShippingAddress.line2;
    self.shipTo3.text = self.order.customer.primaryShippingAddress.line3;
    self.shipTo4.text = self.order.customer.primaryShippingAddress.line4;
    self.shipTo5.text = self.order.customer.primaryShippingAddress.line5;
}

- (void)addAllPagesElements
{
    //User Company Info
    [self addLabel:self.userCompanyName];
    [self addLabel:self.userAddress1];
    [self addLabel:self.userAddress2];
    [self addLabel:self.userAddress3];
    [self addLabel:self.userAddress4];
    [self addLabel:self.userAddress5];
    [self addLabel:self.userPhone];
    [self addLabel:self.userFax];
    [self addLabel:self.userEmail];
    [self addLabel:self.userWebsite];
    
    //Order Options
    [self addRectWithLabel:self.status];
    [self addRectWithLabel:self.statusTitle];
    [self addLabel:self.orderId];
    [self addRectWithLabel:self.orderDateTitle ];
    [self addRectWithLabel:self.orderDate ];
    [self addRectWithLabel:self.shipDateTitle];
    [self addRectWithLabel:self.shipDate];
    [self addRectWithLabel:self.printDateTitle];
    [self addRectWithLabel:self.printDate];
    [self addRectWithLabel:self.poNumberTitle ];
    [self addRectWithLabel:self.poNumber ];
    [self addRectWithLabel:self.rep];
    [self addRectWithLabel:self.repTitle];
    [self addRectWithLabel:self.shipVia];
    [self addRectWithLabel:self.shipViaTitle];
    [self addRectWithLabel:self.terms];
    [self addRectWithLabel:self.termsTitle];
    
    //Bill to and ship to
    [self addLabel:self.billToTitle];
    [self addLabel:self.companyName];
    [self addLabel:self.address1];
    [self addLabel:self.address2];
    [self addLabel:self.address3];
    [self addLabel:self.address4];
    [self addLabel:self.address5];
    [self addLabel:self.shipToTitle];
    [self addLabel:self.shipTo1];
    [self addLabel:self.shipTo2];
    [self addLabel:self.shipTo3];
    [self addLabel:self.shipTo4];
    [self addLabel:self.shipTo5];
    
    //Line items header
    [self addRectWithLabel:self.itemNameHeader];
    [self addRectWithLabel:self.itemDescriptionHeader];
    [self addRectWithLabel:self.itemQuantityHeader];
    [self addRectWithLabel:self.itemPriceHeader];
    [self addRectWithLabel:self.itemAmountHeader];

}

- (void)addLastPageElements
{
    self.total.text =[NSString stringWithFormat:@"Total $%.2f", [self.order totalAmount]];
    self.notes.text = self.order.orderDescription;
    self.pageNumber.text = [NSString stringWithFormat:@"Page %d", self.currentPage];

    [self addRectWithTextView:self.notes];
    [self addRectWithLabel:self.total];
    [self addLabel:self.pageNumber];
}

- (void)addLabel:(UILabel *)label
{
    [label.text drawInRect:label.frame withFont:label.font lineBreakMode:label.lineBreakMode alignment:label.textAlignment];
}

- (void)addRectWithLabel:(UILabel *)label
{
    //To vertically center the text
    CGFloat fontHeight = [label.text sizeWithFont:label.font].height;
    CGFloat yOffset = (label.frame.size.height - fontHeight)/2;
    CGRect textFrame = CGRectMake(label.frame.origin.x, label.frame.origin.y + yOffset, label.frame.size.width, fontHeight);
    
    [label.text drawInRect:textFrame withFont:label.font lineBreakMode:label.lineBreakMode alignment:label.textAlignment];
    CGContextStrokeRect(self.context, label.frame);
}

- (void)addRectWithTextView:(UITextView *)textView
{
    [textView.text drawInRect:textView.frame withFont:textView.font];
    CGContextStrokeRect(self.context, textView.frame);
}

- (void)addLines
{
    self.currentPage = 1;
    CGFloat lineTopY = [self resetLineTopY];
    for (SCLine *line in self.order.lines.allObjects) {
        
        if (lineTopY + klineHeight > self.notes.frame.origin.y) { //it too low, need to start a new page
            
            //setup the labels based on the page
            self.total.text = @"Continued...";
            self.pageNumber.text = [NSString stringWithFormat:@"Page %d", self.currentPage];
            [self addLabel:self.total];
            [self addLabel:self.pageNumber];
            
            //start a new page and reset things
            [self beginPDFPage];
            self.currentPage = self.currentPage + 1;
            [self addAllPagesElements];
            lineTopY = [self resetLineTopY];
        }
        [self addLine:line fromY:lineTopY];
        lineTopY = lineTopY + klineHeight;
    }
    [self addLastPageElements];
}

- (CGFloat)resetLineTopY
{
    //get the starting Y point to draw (bottome of the line items header)
    return self.itemNameHeader.frame.origin.y + self.itemNameHeader.frame.size.height;
}

- (void)addLine:(SCLine *)line fromY:(CGFloat)y
{
    NSString *nameText = line.item.name;
    NSString *descriptionText = line.item.itemDescription;
    NSString *quantityText = line.quantity.stringValue;
    NSString *priceText = [NSString stringWithFormat:@"$%.2f", line.item.price.floatValue];
    NSString *amountText = [NSString stringWithFormat:@"$%.2f", [line amount]];
    
    CGFloat nameWidth =  self.itemNameHeader.frame.size.width;
    CGFloat descriptionWidth = self.itemDescriptionHeader.frame.size.width;
    CGFloat quantityWidth = self.itemQuantityHeader.frame.size.width;
    CGFloat priceWidth =  self.itemPriceHeader.frame.size.width;
    CGFloat amountWidth = self.itemAmountHeader.frame.size.width;
    
    CGFloat nameX = kPagePadding;
    CGFloat descriptionX = nameX + nameWidth;
    CGFloat quantityX = descriptionX + descriptionWidth;
    CGFloat priceX = quantityX + quantityWidth;
    CGFloat amountX = priceX + priceWidth;
    
    CGRect nameFrame = CGRectMake(nameX, y, nameWidth, klineHeight);
    CGRect descriptionFrame = CGRectMake(descriptionX, y, descriptionWidth, klineHeight);
    CGRect quantityFrame = CGRectMake(quantityX, y, quantityWidth, klineHeight);
    CGRect priceFrame = CGRectMake(priceX, y, priceWidth, klineHeight);
    CGRect amountFrame = CGRectMake(amountX, y, amountWidth, klineHeight);
    
    [self addCellWithText:nameText withFrame:nameFrame withAlignment:NSTextAlignmentLeft];
    [self addCellWithText:descriptionText withFrame:descriptionFrame withAlignment:NSTextAlignmentLeft];
    [self addCellWithText:quantityText withFrame:quantityFrame withAlignment:NSTextAlignmentRight];
    [self addCellWithText:priceText withFrame:priceFrame withAlignment:NSTextAlignmentRight];
    [self addCellWithText:amountText withFrame:amountFrame withAlignment:NSTextAlignmentRight];
}

- (void)addCellWithText:(NSString *)text withFrame:(CGRect)frame withAlignment:(NSTextAlignment)alignment
{
    UIFont *font = [UIFont systemFontOfSize:kFontSize];
    [text drawInRect:frame
            withFont:font
       lineBreakMode:UILineBreakModeTailTruncation
           alignment:alignment];
}

- (NSString *)pathForFileName:(NSString *)name withFileNameExtension:(NSString *)extension
{
    NSString *nameWithExtension = [NSString stringWithFormat:@"%@.%@", name, extension];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:nameWithExtension];
}

-   (CGRect)addLineWithFrame:(CGRect)frame withColor:(UIColor*)color
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(currentContext, color.CGColor);
    
    // this is the thickness of the line
    CGContextSetLineWidth(currentContext, frame.size.height);
    CGPoint startPoint = frame.origin;
    CGPoint endPoint = CGPointMake(frame.origin.x + frame.size.width, frame.origin.y);
    
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    
    return frame;
}

- (CGRect)addImage:(UIImage*)image atPoint:(CGPoint)point
{
    CGRect imageFrame = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [image drawInRect:imageFrame];
    return imageFrame;
}

- (void)setupPDFDocumentNamed:(NSString*)name Width:(CGFloat)width Height:(CGFloat)height
{
    NSString *pdfPath = [self pathForFileName:name withFileNameExtension:@"pdf"];
    UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, nil);
}

- (void)beginPDFPage {
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, kPageWidth, kPageHeight), nil);
}

- (void)endPDFPage {
    
}

- (void)finishPDF {
    UIGraphicsEndPDFContext();
}



@end
