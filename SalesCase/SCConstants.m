//
//  SCConstants.m
//  SalesCase2
//
//  Created by Devon DuVernet on 13-01-22.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SCConstants.h"

//enums


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

//QB RELATED
NSInteger const NUMBER_OF_QB_ADDRESS_LINES = 5;
NSInteger const MAX_CUSTOMER_NAME_LENGTH = 41;

//MISC
NSString *const EMPTY_SELECTION_STRING = @"-";

//View States
NSInteger const CREATE_VIEW_STATE = 0;
NSInteger const UPDATE_VIEW_STATE = 1;
NSInteger const READ_VIEW_STATE = 2;

//Tags
NSString *const MAIN_PHONE_TAG = @"Business";
NSString *const MOBILE_PHONE_TAG = @"Mobile";
NSString *const FAX_PHONE_TAG = @"Fax";
NSString *const MAIN_EMAIL_TAG = @"Business";

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
NSString *const WEB_APP_URL = @"http://salescasesgu.evermight.com/"; 
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
NSString *const DISCONNECT_OAUTH_URL_EXT = @"OAuthDisconnect.php";
NSString *const SEND_CUSTOMER_URL_EXT = @"sendCustomer.php";
NSString *const UPDATE_CUSTOMER_URL_EXT = @"updateCustomer.php";

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

// Statuses
NSString *const DRAFT_STATUS = @"Draft";
NSString *const CONFIRMED_STATUS = @"Confirmed";
NSString *const SYNCED_STATUS = @"Synced";
NSString *const NEW_STATUS = @"New";
NSString *const UPDATED_STATUS = @"Updated";


//Style constants
float const UI_DISABLED_ALPHA = 0.5;
NSString *const FONT_DEFAULT = @"Helvetica";
float const FONT_SIZE_DEFAULT = 15.0f;
float const FONT_SIZE_LARGE_LABEL = 34.0f;
