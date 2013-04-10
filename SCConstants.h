//
//  SCConstants.h
//  SalesCase2
//
//  Created by Devon DuVernet on 13-01-22.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>

////Storyboard IDs
////Detail VCs
//FOUNDATION_EXPORT NSString *const @"SCCustomerDetailVC";
//FOUNDATION_EXPORT NSString *const @"SCCustomersVC";
//FOUNDATION_EXPORT NSString *const @"SCItemCartVC";
//FOUNDATION_EXPORT NSString *const @"SCItemDetailVC";
//FOUNDATION_EXPORT NSString *const ITEMS_VC;
//FOUNDATION_EXPORT NSString *const ORDER_ACTIONS_VC;
//FOUNDATION_EXPORT NSString *const @"SCOrderDetailVC";
//FOUNDATION_EXPORT NSString *const @"SCOrderOptionsVC";
//FOUNDATION_EXPORT NSString *const ORDERS_VC;
//FOUNDATION_EXPORT NSString *const @"SCLoginVC";
////Master VCs
//FOUNDATION_EXPORT NSString *const ORDER_MASTER_VC;
////NCs
//FOUNDATION_EXPORT NSString *const @"CustomersNC";
//FOUNDATION_EXPORT NSString *const @"ItemsNC";
//FOUNDATION_EXPORT NSString *const LOGIN_NC;
//
//FOUNDATION_EXPORT NSString *const SYNC_NC;
//FOUNDATION_EXPORT NSString *const NO_DATA_NC;
//
////Login VCs
//FOUNDATION_EXPORT NSString *const @"SCLoginVC";
//FOUNDATION_EXPORT NSString *const INTUIT_@"SCLoginVC";

//User Defaults
FOUNDATION_EXPORT NSString *const USER_COMPANY_INFO;
FOUNDATION_EXPORT NSString *const USER_COMPANY_NAME;
FOUNDATION_EXPORT NSString *const USER_COMPANY_ADDRESS1;
FOUNDATION_EXPORT NSString *const USER_COMPANY_ADDRESS2;
FOUNDATION_EXPORT NSString *const USER_COMPANY_ADDRESS3;
FOUNDATION_EXPORT NSString *const USER_COMPANY_ADDRESS4;
FOUNDATION_EXPORT NSString *const USER_COMPANY_ADDRESS5;
FOUNDATION_EXPORT NSString *const USER_COMPANY_PHONE;
FOUNDATION_EXPORT NSString *const USER_COMPANY_FAX;
FOUNDATION_EXPORT NSString *const USER_COMPANY_EMAIL;
FOUNDATION_EXPORT NSString *const USER_COMPANY_WEBSITE;

//PDF
FOUNDATION_EXPORT NSString *const PDF_FILENAME;
FOUNDATION_EXPORT NSString *const PDF_MIME_TYPE;
FOUNDATION_EXPORT NSString *const PDF_TEXT_ENCODING;
FOUNDATION_EXPORT NSString *const PDF_FILENAME_EXTENSION;

// EXCEPTION
FOUNDATION_EXPORT NSString *const EXCEPTION_CONNECTION;
FOUNDATION_EXPORT NSString *const EXCEPTION_DOWNLOAD;
FOUNDATION_EXPORT NSString *const EXCEPTION_UPLOAD;

//datetime constants
FOUNDATION_EXPORT NSString *const SC_DATETIME_LOCALE;

// Web app url constants
FOUNDATION_EXPORT NSString *const WEB_APP_URL;
FOUNDATION_EXPORT NSString *const OAUTH_REQUEST_URL_EXT;
FOUNDATION_EXPORT NSString *const LIST_CUSTOMERS_URL_EXT;
FOUNDATION_EXPORT NSString *const LIST_ITEMS_URL_EXT;
FOUNDATION_EXPORT NSString *const LIST_SALES_REPS_URL_EXT;
FOUNDATION_EXPORT NSString *const LIST_SHIP_METHODS_URL_EXT;
FOUNDATION_EXPORT NSString *const LIST_SALES_TERMS_URL_EXT;
FOUNDATION_EXPORT NSString *const SEND_ORDER_URL_EXT;
FOUNDATION_EXPORT NSString *const SEND_ESTIMATE_URL_EXT;
FOUNDATION_EXPORT NSString *const EMAIL_ORDER_URL_EXT;
FOUNDATION_EXPORT NSString *const LIST_COMPANY_INFO_URL_EXT;
FOUNDATION_EXPORT int const WEB_APP_MAX_PAGES;
FOUNDATION_EXPORT NSString *const VALIDATE_TENANT_URL_EXT; 

// Core Data managed object entity type names
FOUNDATION_EXPORT NSString *const ENTITY_SCCUSTOMER;
FOUNDATION_EXPORT NSString *const ENTITY_SCITEM;
FOUNDATION_EXPORT NSString *const ENTITY_SCORDER;
FOUNDATION_EXPORT NSString *const ENTITY_SCLINE;
FOUNDATION_EXPORT NSString *const ENTITY_SCADDRESS;
FOUNDATION_EXPORT NSString *const ENTITY_SCEMAIL;
FOUNDATION_EXPORT NSString *const ENTITY_SCPHONE;
FOUNDATION_EXPORT NSString *const ENTITY_SCSALESREP;
FOUNDATION_EXPORT NSString *const ENTITY_SCSALESTERM;
FOUNDATION_EXPORT NSString *const ENTITY_SCSHIPMETHOD;
FOUNDATION_EXPORT NSString *const ENTITY_SCEMAILTOSEND;

//Default styles
FOUNDATION_EXPORT float const UI_DISABLED_ALPHA;
FOUNDATION_EXPORT NSString *const FONT_DEFAULT;
FOUNDATION_EXPORT float const FONT_SIZE_DEFAULT;
FOUNDATION_EXPORT float const FONT_SIZE_LARGE_LABEL;
//FOUNDATION_EXPORT NSString *const FONT_SIZE_SMALL_LABEL;