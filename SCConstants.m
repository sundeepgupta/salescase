//
//  SCConstants.m
//  SalesCase2
//
//  Created by Devon DuVernet on 13-01-22.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SCConstants.h"

////Storyboard IDs
////Detail VCs
//NSString *const @"SCCustomerDetailVC" = @"SCCustomerDetailVC";
//NSString *const @"SCCustomersVC" = @"SCCustomersVC"
//NSString *const @"SCItemCartVC" = @"SCItemCartVC"
//NSString *const @"SCItemDetailVC" = @"SCItemDetailVC"
//NSString *const ITEMS_VC = @"SCItemsVC"
//NSString *const ORDER_ACTIONS_VC = @"SCOrderActionsVC"
//NSString *const @"SCOrderDetailVC" = @"SCOrderDetailVC"
//NSString *const @"SCOrderOptionsVC" = @"SCOrderOptionsVC"
//NSString *const ORDERS_VC = @"SCOrdersVC"
////Master VCs
//NSString *const ORDER_MASTER_VC = @"SCOrderMasterVC"
////NCs
//NSString *const @"CustomersNC" = @"CustomersNC"
//NSString *const @"ItemsNC" = @"ItemsNC"
//NSString *const LOGIN_NC = @"LoginNC"
//
//NSString *const SYNC_NC = @"SyncNC"
//NSString *const NO_DATA_NC = @"NoDataNC"
//
//
////Login VCs
//NSString *const @"SCLoginVC" = @"SCLoginVC"
//NSString *const INTUIT_@"SCLoginVC" = @"SCIntuitLoginVC"

//User Defaults
NSString *const USER_COMPANY_INFO = @"CompanyInfo";
NSString *const USER_COMPANY_NAME = @"Name";
NSString *const USER_COMPANY_ADDRESS1 = @"Address1";
NSString *const USER_COMPANY_ADDRESS2 = @"Address2";
NSString *const USER_COMPANY_ADDRESS3 = @"Address3";
NSString *const USER_COMPANY_ADDRESS4 = @"Address4";
NSString *const USER_COMPANY_ADDRESS5 = @"Address5";
NSString *const USER_COMPANY_PHONE = @"Phone";
NSString *const USER_COMPANY_FAX = @"Fax";
NSString *const USER_COMPANY_EMAIL = @"Email";
NSString *const USER_COMPANY_WEBSITE = @"Website";

//MISC
NSString *const EMPTY_SELECTION_STRING = @"-";

//Tags
NSString *const MAIN_PHONE_TAG = @"Business";
NSString *const MOBILE_PHONE_TAG = @"Mobile";
NSString *const FAX_PHONE_TAG = @"Fax";

//PDF
NSString *const PDF_FILENAME = @"ThePDF";
NSString *const PDF_MIME_TYPE = @"application/pdf";
NSString *const PDF_TEXT_ENCODING = @"utf-8";
NSString *const PDF_FILENAME_EXTENSION = @"pdf";

//Exceptions
NSString *const EXCEPTION_CONNECTION = @"Failed to connect";
NSString *const EXCEPTION_DOWNLOAD = @"Failed to download data";
NSString *const EXCEPTION_UPLOAD = @"Failed to upload data";

//datetime constants
NSString *const SC_DATETIME_LOCALE = @"en_US_POSIX";

//WEB app url constants
NSString *const WEB_APP_URL = @"http://salescasesgu.evermight.net/"; //Dev sgu
//NSString *const WEB_APP_URL = @"https://salescaseapp.evermight.com/"; //prod
NSString *const OAUTH_REQUEST_URL_EXT = @"OAuthRequestToken.php";
NSString *const LIST_CUSTOMERS_URL_EXT = @"listCustomers.php";
NSString *const LIST_ITEMS_URL_EXT = @"listItems.php";
NSString *const LIST_SALES_REPS_URL_EXT = @"listSalesReps.php";
NSString *const LIST_SHIP_METHODS_URL_EXT = @"listShipMethods.php";
NSString *const LIST_SALES_TERMS_URL_EXT = @"listSalesTerms.php";
NSString *const SEND_ORDER_URL_EXT= @"sendOrder.php";
NSString *const EMAIL_ORDER_URL_EXT = @"sendEmail.php";
NSString *const LIST_COMPANY_INFO_URL_EXT = @"listCompanyInfo.php";
int const WEB_APP_MAX_PAGES = 200;
NSString *const VALIDATE_TENANT_URL_EXT = @"validateTenant.php";

// Core Data managed object entity type names
NSString *const ENTITY_SCCUSTOMER = @"SCCustomer";
NSString *const ENTITY_SCITEM = @"SCItem";
NSString *const ENTITY_SCORDER = @"SCOrder";
NSString *const ENTITY_SCLINE = @"SCLine";
NSString *const ENTITY_SCADDRESS = @"SCAddress";
NSString *const ENTITY_SCEMAIL = @"SCEmail";
NSString *const ENTITY_SCPHONE = @"SCPhone";
NSString *const ENTITY_SCSALESREP = @"SCSalesRep";
NSString *const ENTITY_SCSALESTERM = @"SCSalesTerm";
NSString *const ENTITY_SCSHIPMETHOD = @"SCShipMethod";
NSString *const ENTITY_SCEMAILTOSEND = @"SCEmailToSend";

//Style constants
float const UI_DISABLED_ALPHA = 0.5;
NSString *const FONT_DEFAULT = @"Helvetica";
float const FONT_SIZE_DEFAULT = 15.0f;
float const FONT_SIZE_LARGE_LABEL = 34.0f;
