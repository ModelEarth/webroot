-- Prompted with:
-- Convert the following two Microsoft CDM json entity definitions into a .sql file containing the core CDM entities with proper database design principles such as a primary key where appropriate, foreign keys, constraints, indexes, stored procedures, user defined types/functions.
-- Using the lowercase plural table naming conventions (accounts, contacts, leads, opportunities, products, activities) 
-- After the core entities, include relation tables with an underscore like: accounts_contacts, accounts_opportunities
-- https://github.com/microsoft/CDM/blob/master/schemaDocuments/core/applicationCommon/foundationCommon/crmCommon/Account.cdm.json
-- https://github.com/microsoft/CDM/blob/master/docs/schema/examples/OrdersProductsCustomersLinked/model.json

-- To determine: Will we retain id fields in relation tables? Find examples of that in use.

-- Microsoft Common Data Model (CDM) Database Schema
-- Core CRM Entities with proper database design principles
-- Created by Claude Sonnet 4 from prompt above: 2025-06-06

-- =====================================================
-- USER DEFINED TYPES
-- =====================================================

-- Create custom types for common CDM data patterns
CREATE TYPE dbo.CDMStatusCode AS TABLE (
    StatusCode INT,
    StatusReason NVARCHAR(100)
);

CREATE TYPE dbo.CDMOptionSet AS TABLE (
    OptionValue INT,
    OptionLabel NVARCHAR(100)
);

-- =====================================================
-- CORE ENTITY TABLES
-- =====================================================

-- Accounts Table (Companies/Organizations)
CREATE TABLE dbo.accounts (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    account_number NVARCHAR(50) NULL,
    name NVARCHAR(160) NOT NULL,
    account_category_code INT NULL, -- OptionSet: Customer, Vendor, Partner, etc.
    customer_type_code INT NULL, -- OptionSet: Competitor, Consultant, Customer, etc.
    primary_contact_id UNIQUEIDENTIFIER NULL,
    parent_account_id UNIQUEIDENTIFIER NULL,
    territory_id UNIQUEIDENTIFIER NULL,
    owner_id UNIQUEIDENTIFIER NOT NULL,
    
    -- Address Information
    address1_line1 NVARCHAR(250) NULL,
    address1_line2 NVARCHAR(250) NULL,
    address1_line3 NVARCHAR(250) NULL,
    address1_city NVARCHAR(80) NULL,
    address1_state_or_province NVARCHAR(50) NULL,
    address1_postal_code NVARCHAR(20) NULL,
    address1_country NVARCHAR(80) NULL,
    address1_address_type_code INT NULL,
    
    -- Contact Information
    telephone1 NVARCHAR(50) NULL,
    telephone2 NVARCHAR(50) NULL,
    fax NVARCHAR(50) NULL,
    email_address1 NVARCHAR(100) NULL,
    website_url NVARCHAR(200) NULL,
    
    -- Business Information
    industry_code INT NULL,
    sic_code NVARCHAR(20) NULL,
    ticker_symbol NVARCHAR(10) NULL,
    annual_revenue MONEY NULL,
    number_of_employees INT NULL,
    credit_limit MONEY NULL,
    credit_on_hold BIT NOT NULL DEFAULT 0,
    
    -- System Fields
    status_code INT NOT NULL DEFAULT 1, -- Active/Inactive
    state_code INT NOT NULL DEFAULT 0, -- Open/Closed
    created_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    created_by UNIQUEIDENTIFIER NOT NULL,
    modified_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    modified_by UNIQUEIDENTIFIER NOT NULL,
    version_number BIGINT NOT NULL DEFAULT 1,
    import_sequence_number INT NULL,
    override_created_on DATETIME2 NULL,
    
    -- Constraints
    CONSTRAINT FK_accounts_parent_account FOREIGN KEY (parent_account_id) REFERENCES dbo.accounts(id),
    CONSTRAINT CK_accounts_status_code CHECK (status_code IN (1, 2)), -- Active, Inactive
    CONSTRAINT CK_accounts_state_code CHECK (state_code IN (0, 1)) -- Open, Closed
);

-- Contacts Table (People)
CREATE TABLE dbo.contacts (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    contact_number NVARCHAR(50) NULL,
    first_name NVARCHAR(50) NULL,
    middle_name NVARCHAR(50) NULL,
    last_name NVARCHAR(50) NOT NULL,
    full_name AS (TRIM(ISNULL(first_name, '') + ' ' + ISNULL(middle_name, '') + ' ' + ISNULL(last_name, ''))) PERSISTED,
    nickname NVARCHAR(100) NULL,
    salutation NVARCHAR(20) NULL,
    job_title NVARCHAR(100) NULL,
    parent_customer_id UNIQUEIDENTIFIER NULL, -- References accounts or contacts
    parent_customer_id_type NVARCHAR(20) NULL, -- 'account' or 'contact'
    owner_id UNIQUEIDENTIFIER NOT NULL,
    
    -- Personal Information
    gender_code INT NULL, -- OptionSet
    marital_status INT NULL, -- OptionSet
    birth_date DATE NULL,
    anniversary DATE NULL,
    spouse_partner_name NVARCHAR(100) NULL,
    children_names NVARCHAR(255) NULL,
    
    -- Address Information
    address1_line1 NVARCHAR(250) NULL,
    address1_line2 NVARCHAR(250) NULL,
    address1_line3 NVARCHAR(250) NULL,
    address1_city NVARCHAR(80) NULL,
    address1_state_or_province NVARCHAR(50) NULL,
    address1_postal_code NVARCHAR(20) NULL,
    address1_country NVARCHAR(80) NULL,
    address1_address_type_code INT NULL,
    
    -- Contact Information
    telephone1 NVARCHAR(50) NULL,
    telephone2 NVARCHAR(50) NULL,
    mobile_phone NVARCHAR(50) NULL,
    fax NVARCHAR(50) NULL,
    email_address1 NVARCHAR(100) NULL,
    email_address2 NVARCHAR(100) NULL,
    email_address3 NVARCHAR(100) NULL,
    preferred_contact_method_code INT NULL, -- Email, Phone, Fax, Mail, etc.
    do_not_email BIT NOT NULL DEFAULT 0,
    do_not_phone BIT NOT NULL DEFAULT 0,
    do_not_fax BIT NOT NULL DEFAULT 0,
    do_not_mail BIT NOT NULL DEFAULT 0,
    do_not_bulk_email BIT NOT NULL DEFAULT 0,
    
    -- Business Information
    credit_limit MONEY NULL,
    credit_on_hold BIT NOT NULL DEFAULT 0,
    payment_terms_code INT NULL,
    
    -- System Fields
    status_code INT NOT NULL DEFAULT 1, -- Active/Inactive
    state_code INT NOT NULL DEFAULT 0, -- Active/Inactive
    created_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    created_by UNIQUEIDENTIFIER NOT NULL,
    modified_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    modified_by UNIQUEIDENTIFIER NOT NULL,
    version_number BIGINT NOT NULL DEFAULT 1,
    import_sequence_number INT NULL,
    override_created_on DATETIME2 NULL,
    
    -- Constraints
    CONSTRAINT CK_contacts_parent_customer_type CHECK (parent_customer_id_type IN ('account', 'contact')),
    CONSTRAINT CK_contacts_status_code CHECK (status_code IN (1, 2)), -- Active, Inactive
    CONSTRAINT CK_contacts_state_code CHECK (state_code IN (0, 1)) -- Active, Inactive
);

-- Leads Table (Prospects)
CREATE TABLE dbo.leads (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    lead_number NVARCHAR(50) NULL,
    subject NVARCHAR(300) NOT NULL,
    first_name NVARCHAR(50) NULL,
    middle_name NVARCHAR(50) NULL,
    last_name NVARCHAR(50) NOT NULL,
    full_name AS (TRIM(ISNULL(first_name, '') + ' ' + ISNULL(middle_name, '') + ' ' + ISNULL(last_name, ''))) PERSISTED,
    salutation NVARCHAR(20) NULL,
    job_title NVARCHAR(100) NULL,
    company_name NVARCHAR(100) NULL,
    owner_id UNIQUEIDENTIFIER NOT NULL,
    
    -- Lead Source and Quality
    lead_source_code INT NULL, -- Advertisement, Employee Referral, Web, etc.
    lead_quality_code INT NULL, -- Hot, Warm, Cold
    priority_code INT NULL, -- High, Normal, Low
    rating NVARCHAR(20) NULL,
    industry_code INT NULL,
    sic_code NVARCHAR(20) NULL,
    annual_revenue MONEY NULL,
    number_of_employees INT NULL,
    
    -- Contact Information
    telephone1 NVARCHAR(50) NULL,
    telephone2 NVARCHAR(50) NULL,
    mobile_phone NVARCHAR(50) NULL,
    fax NVARCHAR(50) NULL,
    email_address1 NVARCHAR(100) NULL,
    website_url NVARCHAR(200) NULL,
    preferred_contact_method_code INT NULL,
    do_not_email BIT NOT NULL DEFAULT 0,
    do_not_phone BIT NOT NULL DEFAULT 0,
    do_not_fax BIT NOT NULL DEFAULT 0,
    do_not_mail BIT NOT NULL DEFAULT 0,
    
    -- Address Information
    address1_line1 NVARCHAR(250) NULL,
    address1_line2 NVARCHAR(250) NULL,
    address1_line3 NVARCHAR(250) NULL,
    address1_city NVARCHAR(80) NULL,
    address1_state_or_province NVARCHAR(50) NULL,
    address1_postal_code NVARCHAR(20) NULL,
    address1_country NVARCHAR(80) NULL,
    
    -- Lead Qualification
    budget_amount MONEY NULL,
    purchase_timeframe INT NULL, -- OptionSet: Immediate, This Quarter, etc.
    purchase_process INT NULL, -- OptionSet: Individual, Committee, Unknown
    decision_maker BIT NOT NULL DEFAULT 0,
    need INT NULL, -- OptionSet: Must have, Should have, etc.
    qualify_comments NVARCHAR(MAX) NULL,
    
    -- Scoring and Tracking
    lead_score INT NULL,
    scheduled_follow_up_date DATETIME2 NULL,
    estimated_close_date DATE NULL,
    estimated_value MONEY NULL,
    
    -- System Fields
    status_code INT NOT NULL DEFAULT 1, -- New, Contacted, Qualified, etc.
    state_code INT NOT NULL DEFAULT 0, -- Open, Qualified, Disqualified
    created_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    created_by UNIQUEIDENTIFIER NOT NULL,
    modified_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    modified_by UNIQUEIDENTIFIER NOT NULL,
    version_number BIGINT NOT NULL DEFAULT 1,
    import_sequence_number INT NULL,
    override_created_on DATETIME2 NULL,
    
    -- Constraints
    CONSTRAINT CK_leads_status_code CHECK (status_code BETWEEN 1 AND 7),
    CONSTRAINT CK_leads_state_code CHECK (state_code IN (0, 1, 2)) -- Open, Qualified, Disqualified
);

-- Opportunities Table (Sales Deals)
CREATE TABLE dbo.opportunities (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    name NVARCHAR(300) NOT NULL,
    account_id UNIQUEIDENTIFIER NULL,
    contact_id UNIQUEIDENTIFIER NULL,
    originating_lead_id UNIQUEIDENTIFIER NULL,
    owner_id UNIQUEIDENTIFIER NOT NULL,
    
    -- Sales Information
    estimated_close_date DATE NULL,
    estimated_value MONEY NULL,
    actual_close_date DATE NULL,
    actual_value MONEY NULL,
    probability_score INT NULL, -- 0-100
    sales_stage NVARCHAR(50) NULL,
    sales_stage_code INT NULL, -- OptionSet
    budget_amount MONEY NULL,
    purchase_timeframe INT NULL, -- OptionSet
    purchase_process INT NULL, -- OptionSet
    
    -- Opportunity Details
    description NVARCHAR(MAX) NULL,
    current_situation NVARCHAR(MAX) NULL,
    customer_need NVARCHAR(MAX) NULL,
    proposed_solution NVARCHAR(MAX) NULL,
    competitor NVARCHAR(100) NULL,
    discount_amount MONEY NULL,
    discount_percentage DECIMAL(5,2) NULL,
    freight_amount MONEY NULL,
    total_amount MONEY NULL,
    total_amount_less_freight MONEY NULL,
    total_discount_amount MONEY NULL,
    total_line_item_amount MONEY NULL,
    total_line_item_discount_amount MONEY NULL,
    total_tax MONEY NULL,
    
    -- Classification
    opportunity_rating_code INT NULL, -- Hot, Warm, Cold
    priority_code INT NULL, -- High, Normal, Low
    customer_category_code INT NULL,
    step_name NVARCHAR(100) NULL,
    step_id UNIQUEIDENTIFIER NULL,
    
    -- System Fields
    status_code INT NOT NULL DEFAULT 1, -- In Progress, On Hold, Won, Canceled
    state_code INT NOT NULL DEFAULT 0, -- Open, Won, Lost
    created_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    created_by UNIQUEIDENTIFIER NOT NULL,
    modified_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    modified_by UNIQUEIDENTIFIER NOT NULL,
    version_number BIGINT NOT NULL DEFAULT 1,
    import_sequence_number INT NULL,
    override_created_on DATETIME2 NULL,
    
    -- Foreign Key Constraints
    CONSTRAINT FK_opportunities_account FOREIGN KEY (account_id) REFERENCES dbo.accounts(id),
    CONSTRAINT FK_opportunities_contact FOREIGN KEY (contact_id) REFERENCES dbo.contacts(id),
    CONSTRAINT FK_opportunities_lead FOREIGN KEY (originating_lead_id) REFERENCES dbo.leads(id),
    
    -- Constraints
    CONSTRAINT CK_opportunities_probability CHECK (probability_score BETWEEN 0 AND 100),
    CONSTRAINT CK_opportunities_status_code CHECK (status_code IN (1, 2, 3, 4)), -- In Progress, On Hold, Won, Canceled
    CONSTRAINT CK_opportunities_state_code CHECK (state_code IN (0, 1, 2)) -- Open, Won, Lost
);

-- Products Table
CREATE TABLE dbo.products (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    product_number NVARCHAR(100) NULL,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX) NULL,
    product_type_code INT NULL, -- Sales Inventory, Miscellaneous Charges, Services, etc.
    default_unit_id UNIQUEIDENTIFIER NULL,
    default_unit_of_measure NVARCHAR(100) NULL,
    
    -- Pricing Information
    price MONEY NULL,
    standard_cost MONEY NULL,
    current_cost MONEY NULL,
    list_price MONEY NULL,
    
    -- Product Classification
    product_structure INT NULL, -- Product, Product Family, Product Bundle, etc.
    parent_product_id UNIQUEIDENTIFIER NULL,
    vendor_id UNIQUEIDENTIFIER NULL,
    vendor_name NVARCHAR(100) NULL,
    vendor_part_number NVARCHAR(100) NULL,
    
    -- Inventory Information
    stock_volume DECIMAL(18,2) NULL,
    stock_weight DECIMAL(18,2) NULL,
    quantity_decimal INT NULL,
    quantity_on_hand DECIMAL(18,2) NULL,
    
    -- Product Details
    size NVARCHAR(200) NULL,
    product_url NVARCHAR(255) NULL,
    supplier_name NVARCHAR(100) NULL,
    
    -- System Fields
    status_code INT NOT NULL DEFAULT 1, -- Active, Draft, Under Revision, etc.
    state_code INT NOT NULL DEFAULT 0, -- Active, Retired
    created_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    created_by UNIQUEIDENTIFIER NOT NULL,
    modified_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    modified_by UNIQUEIDENTIFIER NOT NULL,
    version_number BIGINT NOT NULL DEFAULT 1,
    import_sequence_number INT NULL,
    override_created_on DATETIME2 NULL,
    
    -- Constraints
    CONSTRAINT FK_products_parent FOREIGN KEY (parent_product_id) REFERENCES dbo.products(id),
    CONSTRAINT CK_products_status_code CHECK (status_code IN (1, 2, 3)), -- Active, Draft, Under Revision
    CONSTRAINT CK_products_state_code CHECK (state_code IN (0, 1)) -- Active, Retired
);

-- Activities Table (Tasks, Phone Calls, Appointments, Emails)
CREATE TABLE dbo.activities (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    subject NVARCHAR(400) NOT NULL,
    activity_type_code NVARCHAR(64) NOT NULL, -- task, phonecall, appointment, email, etc.
    description NVARCHAR(MAX) NULL,
    owner_id UNIQUEIDENTIFIER NOT NULL,
    
    -- Regarding (What the activity is about)
    regarding_object_id UNIQUEIDENTIFIER NULL,
    regarding_object_type_code NVARCHAR(64) NULL, -- account, contact, lead, opportunity, etc.
    
    -- Scheduling
    scheduled_start DATETIME2 NULL,
    scheduled_end DATETIME2 NULL,
    actual_start DATETIME2 NULL,
    actual_end DATETIME2 NULL,
    actual_duration_minutes INT NULL,
    scheduled_duration_minutes INT NULL,
    
    -- Priority and Status
    priority_code INT NULL, -- Low, Normal, High
    status_code INT NOT NULL DEFAULT 1, -- Open, Completed, Canceled, Scheduled
    state_code INT NOT NULL DEFAULT 0, -- Open, Completed, Canceled
    
    -- Activity Specific Fields
    direction_code BIT NULL, -- For phone calls/emails: Outgoing = 1, Incoming = 0
    category NVARCHAR(250) NULL,
    subcategory NVARCHAR(250) NULL,
    location NVARCHAR(200) NULL,
    
    -- Email Specific
    from_email NVARCHAR(320) NULL,
    to_email NVARCHAR(MAX) NULL,
    cc_email NVARCHAR(MAX) NULL,
    bcc_email NVARCHAR(MAX) NULL,
    
    -- Phone Call Specific
    phone_number NVARCHAR(200) NULL,
    
    -- System Fields
    created_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    created_by UNIQUEIDENTIFIER NOT NULL,
    modified_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    modified_by UNIQUEIDENTIFIER NOT NULL,
    version_number BIGINT NOT NULL DEFAULT 1,
    import_sequence_number INT NULL,
    override_created_on DATETIME2 NULL,
    
    -- Constraints
    CONSTRAINT CK_activities_type CHECK (activity_type_code IN ('task', 'phonecall', 'appointment', 'email', 'fax', 'letter')),
    CONSTRAINT CK_activities_status_code CHECK (status_code IN (1, 2, 3, 4)), -- Open, Completed, Canceled, Scheduled
    CONSTRAINT CK_activities_state_code CHECK (state_code IN (0, 1, 2)) -- Open, Completed, Canceled
);

-- =====================================================
-- RELATIONSHIP TABLES
-- =====================================================

-- Account-Contact Relationships
CREATE TABLE dbo.accounts_contacts (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    account_id UNIQUEIDENTIFIER NOT NULL,
    contact_id UNIQUEIDENTIFIER NOT NULL,
    relationship_type NVARCHAR(50) NULL, -- Primary Contact, Decision Maker, Influencer, etc.
    is_primary_contact BIT NOT NULL DEFAULT 0,
    created_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    created_by UNIQUEIDENTIFIER NOT NULL,
    
    CONSTRAINT FK_accounts_contacts_account FOREIGN KEY (account_id) REFERENCES dbo.accounts(id) ON DELETE CASCADE,
    CONSTRAINT FK_accounts_contacts_contact FOREIGN KEY (contact_id) REFERENCES dbo.contacts(id) ON DELETE CASCADE,
    CONSTRAINT UQ_accounts_contacts UNIQUE (account_id, contact_id)
);

-- Account-Opportunity Relationships
CREATE TABLE dbo.accounts_opportunities (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    account_id UNIQUEIDENTIFIER NOT NULL,
    opportunity_id UNIQUEIDENTIFIER NOT NULL,
    relationship_type NVARCHAR(50) NULL, -- Customer, Partner, Competitor, etc.
    created_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    created_by UNIQUEIDENTIFIER NOT NULL,
    
    CONSTRAINT FK_accounts_opportunities_account FOREIGN KEY (account_id) REFERENCES dbo.accounts(id) ON DELETE CASCADE,
    CONSTRAINT FK_accounts_opportunities_opportunity FOREIGN KEY (opportunity_id) REFERENCES dbo.opportunities(id) ON DELETE CASCADE,
    CONSTRAINT UQ_accounts_opportunities UNIQUE (account_id, opportunity_id)
);

-- Contact-Lead Relationships
CREATE TABLE dbo.contacts_leads (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    contact_id UNIQUEIDENTIFIER NOT NULL,
    lead_id UNIQUEIDENTIFIER NOT NULL,
    relationship_type NVARCHAR(50) NULL, -- Converted From, Related To, etc.
    created_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    created_by UNIQUEIDENTIFIER NOT NULL,
    
    CONSTRAINT FK_contacts_leads_contact FOREIGN KEY (contact_id) REFERENCES dbo.contacts(id) ON DELETE CASCADE,
    CONSTRAINT FK_contacts_leads_lead FOREIGN KEY (lead_id) REFERENCES dbo.leads(id) ON DELETE CASCADE,
    CONSTRAINT UQ_contacts_leads UNIQUE (contact_id, lead_id)
);

-- Opportunity-Product Relationships (Opportunity Products)
CREATE TABLE dbo.opportunities_products (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    opportunity_id UNIQUEIDENTIFIER NOT NULL,
    product_id UNIQUEIDENTIFIER NOT NULL,
    quantity DECIMAL(18,2) NOT NULL DEFAULT 1,
    price_per_unit MONEY NULL,
    manual_discount_amount MONEY NULL,
    discount_percentage DECIMAL(5,2) NULL,
    tax MONEY NULL,
    base_amount MONEY NULL,
    extended_amount MONEY NULL,
    line_item_number INT NULL,
    description NVARCHAR(MAX) NULL,
    is_product_overridden BIT NOT NULL DEFAULT 0,
    product_description NVARCHAR(MAX) NULL,
    created_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    created_by UNIQUEIDENTIFIER NOT NULL,
    modified_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    modified_by UNIQUEIDENTIFIER NOT NULL,
    
    CONSTRAINT FK_opportunities_products_opportunity FOREIGN KEY (opportunity_id) REFERENCES dbo.opportunities(id) ON DELETE CASCADE,
    CONSTRAINT FK_opportunities_products_product FOREIGN KEY (product_id) REFERENCES dbo.products(id),
    CONSTRAINT CK_opportunities_products_quantity CHECK (quantity > 0)
);

-- Activity-Entity Relationships (Activities can be related to multiple entity types)
CREATE TABLE dbo.activities_entities (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    activity_id UNIQUEIDENTIFIER NOT NULL,
    entity_id UNIQUEIDENTIFIER NOT NULL,
    entity_type NVARCHAR(50) NOT NULL, -- account, contact, lead, opportunity, product
    participation_type NVARCHAR(50) NULL, -- Owner, Organizer, Required, Optional, etc.
    created_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    created_by UNIQUEIDENTIFIER NOT NULL,
    
    CONSTRAINT FK_activities_entities_activity FOREIGN KEY (activity_id) REFERENCES dbo.activities(id) ON DELETE CASCADE,
    CONSTRAINT CK_activities_entities_type CHECK (entity_type IN ('account', 'contact', 'lead', 'opportunity', 'product')),
    CONSTRAINT UQ_activities_entities UNIQUE (activity_id, entity_id, entity_type)
);

-- =====================================================
-- INDEXES
-- =====================================================

-- Accounts Indexes
CREATE NONCLUSTERED INDEX IX_accounts_name ON dbo.accounts (name);
CREATE NONCLUSTERED INDEX IX_accounts_account_number ON dbo.accounts (account_number);
CREATE NONCLUSTERED INDEX IX_accounts_owner_id ON dbo.accounts (owner_id);
CREATE NONCLUSTERED INDEX IX_accounts_parent_account_id ON dbo.accounts (parent_account_id);
CREATE NONCLUSTERED INDEX IX_accounts_primary_contact_id ON dbo.accounts (primary_contact_id);
CREATE NONCLUSTERED INDEX IX_accounts_status_state ON dbo.accounts (status_code, state_code);
CREATE NONCLUSTERED INDEX IX_accounts_created_on ON dbo.accounts (created_on);

-- Contacts Indexes
CREATE NONCLUSTERED INDEX IX_contacts_name ON dbo.contacts (last_name, first_name);
CREATE NONCLUSTERED INDEX IX_contacts_full_name ON dbo.contacts (full_name);
CREATE NONCLUSTERED INDEX IX_contacts_email ON dbo.contacts (email_address1);
CREATE NONCLUSTERED INDEX IX_contacts_owner_id ON dbo.contacts (owner_id);
CREATE NONCLUSTERED INDEX IX_contacts_parent_customer ON dbo.contacts (parent_customer_id, parent_customer_id_type);
CREATE NONCLUSTERED INDEX IX_contacts_status_state ON dbo.contacts (status_code, state_code);

-- Leads Indexes
CREATE NONCLUSTERED INDEX IX_leads_name ON dbo.leads (last_name, first_name);
CREATE NONCLUSTERED INDEX IX_leads_company ON dbo.leads (company_name);
CREATE NONCLUSTERED INDEX IX_leads_email ON dbo.leads (email_address1);
CREATE NONCLUSTERED INDEX IX_leads_owner_id ON dbo.leads (owner_id);
CREATE NONCLUSTERED INDEX IX_leads_status_state ON dbo.leads (status_code, state_code);
CREATE NONCLUSTERED INDEX IX_leads_source ON dbo.leads (lead_source_code);
CREATE NONCLUSTERED INDEX IX_leads_quality ON dbo.leads (lead_quality_code);

-- Opportunities Indexes
CREATE NONCLUSTERED INDEX IX_opportunities_name ON dbo.opportunities (name);
CREATE NONCLUSTERED INDEX IX_opportunities_account_id ON dbo.opportunities (account_id);
CREATE NONCLUSTERED INDEX IX_opportunities_contact_id ON dbo.opportunities (contact_id);
CREATE NONCLUSTERED INDEX IX_opportunities_owner_id ON dbo.opportunities (owner_id);
CREATE NONCLUSTERED INDEX IX_opportunities_close_date ON dbo.opportunities (estimated_close_date);
CREATE NONCLUSTERED INDEX IX_opportunities_value ON dbo.opportunities (estimated_value);
CREATE NONCLUSTERED INDEX IX_opportunities_status_state ON dbo.opportunities (status_code, state_code);
CREATE NONCLUSTERED INDEX IX_opportunities_sales_stage ON dbo.opportunities (sales_stage_code);

-- Products Indexes
CREATE NONCLUSTERED INDEX IX_products_name ON dbo.products (name);
CREATE NONCLUSTERED INDEX IX_products_number ON dbo.products (product_number);
CREATE NONCLUSTERED INDEX IX_products_type ON dbo.products (product_type_code);
CREATE NONCLUSTERED INDEX IX_products_parent_id ON dbo.products (parent_product_id);
CREATE NONCLUSTERED INDEX IX_products_status_state ON dbo.products (status_code, state_code);

-- Activities Indexes
CREATE NONCLUSTERED INDEX IX_activities_subject ON dbo.activities (subject);
CREATE NONCLUSTERED INDEX IX_activities_type ON dbo.activities (activity_type_code);
CREATE NONCLUSTERED INDEX IX_activities_owner_id ON dbo.activities (owner_id);
CREATE NONCLUSTERED INDEX IX_activities_regarding ON dbo.activities (regarding_object_id, regarding_object_type_code);
CREATE NONCLUSTERED INDEX IX_activities_scheduled_start ON dbo.activities (scheduled_start);
CREATE NONCLUSTERED INDEX IX_activities_status_state ON dbo.activities (status_code, state_code);

-- Relationship Table Indexes
CREATE NONCLUSTERED INDEX IX_accounts_contacts_account ON dbo.accounts_contacts (account_id);
CREATE NONCLUSTERED INDEX IX_accounts_contacts_contact ON dbo.accounts_contacts (contact_id);
CREATE NONCLUSTERED INDEX IX_accounts_opportunities_account ON dbo.accounts_opportunities (account_id);
CREATE NONCLUSTERED INDEX IX_accounts_opportunities_opportunity ON dbo.accounts_opportunities (opportunity_id);
CREATE NONCLUSTERED INDEX IX_opportunities_products_opportunity ON dbo.opportunities_products (opportunity_id);
CREATE NONCLUSTERED INDEX IX_opportunities_products_product ON dbo.opportunities_products (product_id);

-- =====================================================
-- USER DEFINED FUNCTIONS
-- =====================================================

-- Function to get the full display name for contacts
CREATE FUNCTION dbo.fn_GetContactDisplayName(@ContactId UNIQUEIDENTIFIER)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @DisplayName NVARCHAR(200);
    
    SELECT @DisplayName = 
        CASE 
            WHEN salutation IS NOT NULL THEN salutation + ' ' + full_name
            ELSE full_name
        END
    FROM dbo.contacts 
    WHERE id = @ContactId;
    
    RETURN ISNULL(@DisplayName, '');
END;
GO

-- Function to calculate opportunity probability based on sales stage
CREATE FUNCTION dbo.fn_GetOpportunityProbability(@SalesStageCode INT)
RETURNS INT
AS
BEGIN
    DECLARE @Probability INT;
    
    SELECT @Probability = 
        CASE @SalesStageCode
            WHEN 1 THEN 10  -- Qualify
            WHEN 2 THEN 25  -- Develop
            WHEN 3 THEN 50  -- Propose
            WHEN 4 THEN 75  -- Close
            WHEN 5 THEN 100 -- Won
            ELSE 0
        END;
    
    RETURN @Probability;
END;
GO

-- Function to calculate weighted pipeline value
CREATE FUNCTION dbo.fn_GetWeightedPipelineValue(@OpportunityId UNIQUEIDENTIFIER)
RETURNS MONEY
AS
BEGIN
    DECLARE @WeightedValue MONEY;
    
    SELECT @WeightedValue = 
        CASE 
            WHEN estimated_value IS NOT NULL AND probability_score IS NOT NULL 
            THEN estimated_value * (probability_score / 100.0)
            ELSE 0
        END
    FROM dbo.opportunities 
    WHERE id = @OpportunityId;
    
    RETURN ISNULL(@WeightedValue, 0);
END;
GO

-- =====================================================
-- STORED PROCEDURES
-- =====================================================

-- Procedure to create a new lead from web form
CREATE PROCEDURE dbo.sp_CreateLeadFromWebForm
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @CompanyName NVARCHAR(100),
    @EmailAddress NVARCHAR(100),
    @PhoneNumber NVARCHAR(50) = NULL,
    @Subject NVARCHAR(300),
    @LeadSourceCode INT = 3, -- Web
    @OwnerId UNIQUEIDENT