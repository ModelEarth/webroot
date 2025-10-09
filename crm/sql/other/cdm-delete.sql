Avoid business_units
Use securitygroups and Access Control Lists (ACL)


-- Prompted with:
-- Convert the following two Microsoft CDM json entity definitions into a .sql file containing the core CDM entities with proper database design principles such as a primary key where appropriate, foreign keys, constraints, indexes, stored procedures, user defined types/functions.
-- Using the lowercase plural table naming conventions (accounts, contacts, leads, opportunities, products, activities, users) 
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
-- USER AND SECURITY TABLES
-- =====================================================

CREATE TABLE dbo.securitygroups (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX) NULL,
    noninheritable BIT NOT NULL DEFAULT 0,
    
    -- System Fields
    created_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    created_by UNIQUEIDENTIFIER NOT NULL,
    modified_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    modified_by UNIQUEIDENTIFIER NOT NULL,
    deleted BIT NOT NULL DEFAULT 0,
    
    CONSTRAINT UQ_securitygroups_name UNIQUE (name)
);

-- Business Units Table (Organizational hierarchy)
CREATE TABLE dbo.business_units (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    name NVARCHAR(160) NOT NULL,
    parent_business_unit_id UNIQUEIDENTIFIER NULL,
    organization_id UNIQUEIDENTIFIER NOT NULL,
    description NVARCHAR(MAX) NULL,
    division_name NVARCHAR(100) NULL,
    file_as_name NVARCHAR(100) NULL,
    
    -- Contact Information
    address1_line1 NVARCHAR(250) NULL,
    address1_line2 NVARCHAR(250) NULL,
    address1_city NVARCHAR(80) NULL,
    address1_state_or_province NVARCHAR(50) NULL,
    address1_postal_code NVARCHAR(20) NULL,
    address1_country NVARCHAR(80) NULL,
    telephone1 NVARCHAR(50) NULL,
    email_address NVARCHAR(100) NULL,
    website_url NVARCHAR(200) NULL,
    
    -- Cost Center Information
    cost_center NVARCHAR(30) NULL,
    credit_limit MONEY NULL,
    
    -- System Fields
    status_code INT NOT NULL DEFAULT 1, -- Active/Inactive
    state_code INT NOT NULL DEFAULT 0, -- Active/Inactive
    created_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    created_by UNIQUEIDENTIFIER NOT NULL,
    modified_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    modified_by UNIQUEIDENTIFIER NOT NULL,
    version_number BIGINT NOT NULL DEFAULT 1,
    
    CONSTRAINT FK_business_units_parent FOREIGN KEY (parent_business_unit_id) REFERENCES dbo.business_units(id),
    CONSTRAINT CK_business_units_status_code CHECK (status_code IN (1, 2)), -- Active, Inactive
    CONSTRAINT CK_business_units_state_code CHECK (state_code IN (0, 1)) -- Active, Inactive
);

-- Security Roles Table
CREATE TABLE dbo.security_roles (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    name NVARCHAR(100) NOT NULL,
    business_unit_id UNIQUEIDENTIFIER NOT NULL,
    description NVARCHAR(MAX) NULL,
    can_be_deleted BIT NOT NULL DEFAULT 1,
    is_managed BIT NOT NULL DEFAULT 0,
    is_inherited BIT NOT NULL DEFAULT 0,
    parent_role_id UNIQUEIDENTIFIER NULL,
    role_template_id UNIQUEIDENTIFIER NULL,
    
    -- System Fields
    created_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    created_by UNIQUEIDENTIFIER NOT NULL,
    modified_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    modified_by UNIQUEIDENTIFIER NOT NULL,
    version_number BIGINT NOT NULL DEFAULT 1,
    
    CONSTRAINT FK_security_roles_business_unit FOREIGN KEY (business_unit_id) REFERENCES dbo.business_units(id),
    CONSTRAINT FK_security_roles_parent FOREIGN KEY (parent_role_id) REFERENCES dbo.security_roles(id),
    CONSTRAINT UQ_security_roles_name_bu UNIQUE (name, business_unit_id)
);

-- Teams Table
CREATE TABLE dbo.teams (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    name NVARCHAR(160) NOT NULL,
    business_unit_id UNIQUEIDENTIFIER NOT NULL,
    team_type INT NOT NULL DEFAULT 0, -- Owner, Access, etc.
    description NVARCHAR(MAX) NULL,
    email_address NVARCHAR(100) NULL,
    administrator_id UNIQUEIDENTIFIER NULL,
    
    -- Team Settings
    is_default BIT NOT NULL DEFAULT 0,
    queue_id UNIQUEIDENTIFIER NULL,
    regarding_object_id UNIQUEIDENTIFIER NULL,
    regarding_object_type_code NVARCHAR(50) NULL,
    
    -- System Fields
    created_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    created_by UNIQUEIDENTIFIER NOT NULL,
    modified_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    modified_by UNIQUEIDENTIFIER NOT NULL,
    version_number BIGINT NOT NULL DEFAULT 1,
    
    CONSTRAINT FK_teams_business_unit FOREIGN KEY (business_unit_id) REFERENCES dbo.business_units(id),
    CONSTRAINT CK_teams_type CHECK (team_type IN (0, 1, 2)) -- Owner, Access, Custom
);

-- Users Table
CREATE TABLE dbo.users (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    domain_name NVARCHAR(1024) NOT NULL, -- Active Directory domain\username
    internal_email_address NVARCHAR(100) NOT NULL,
    user_name NVARCHAR(100) NOT NULL, -- Login username
    
    -- Personal Information
    first_name NVARCHAR(64) NULL,
    middle_name NVARCHAR(50) NULL,
    last_name NVARCHAR(64) NOT NULL,
    full_name AS (TRIM(ISNULL(first_name, '') + ' ' + ISNULL(middle_name, '') + ' ' + ISNULL(last_name, ''))) PERSISTED,
    nickname NVARCHAR(50) NULL,
    salutation NVARCHAR(20) NULL,
    title NVARCHAR(128) NULL,
    personal_email_address NVARCHAR(100) NULL,
    
    -- Organizational Information
    business_unit_id UNIQUEIDENTIFIER NOT NULL,
    parent_user_id UNIQUEIDENTIFIER NULL, -- Manager
    territory_id UNIQUEIDENTIFIER NULL,
    position_id UNIQUEIDENTIFIER NULL,
    
    -- Contact Information
    address1_line1 NVARCHAR(250) NULL,
    address1_line2 NVARCHAR(250) NULL,
    address1_city NVARCHAR(80) NULL,
    address1_state_or_province NVARCHAR(50) NULL,
    address1_postal_code NVARCHAR(20) NULL,
    address1_country NVARCHAR(80) NULL,
    address1_telephone1 NVARCHAR(50) NULL,
    address1_telephone2 NVARCHAR(50) NULL,
    address1_fax NVARCHAR(50) NULL,
    mobile_phone NVARCHAR(64) NULL,
    home_phone NVARCHAR(50) NULL,
    
    -- User Preferences
    ui_language_id INT NULL,
    help_language_id INT NULL,
    default_mail_box UNIQUEIDENTIFIER NULL,
    incoming_email_delivery_method INT NULL, -- None, Email Router, Forward Mailbox, etc.
    outgoing_email_delivery_method INT NULL,
    email_router_access_approval INT NULL, -- Approved, Pending, Rejected
    
    -- Access Control
    access_mode INT NOT NULL DEFAULT 0, -- Read-Write, Administrative, Read, Support User, etc.
    cal_type INT NOT NULL DEFAULT 0, -- Professional, Administrative, Basic, etc.
    license_type INT NOT NULL DEFAULT 0, -- Professional, Administrative, Basic, etc.
    is_disabled BIT NOT NULL DEFAULT 0,
    is_licensed BIT NOT NULL DEFAULT 1,
    is_sync_with_directory BIT NOT NULL DEFAULT 0,
    disable_reason NVARCHAR(500) NULL,
    
    -- Authentication
    azure_active_directory_object_id UNIQUEIDENTIFIER NULL,
    windows_live_id NVARCHAR(1024) NULL,
    
    -- Invitation Information
    invitation_status_code INT NULL, -- InvitationNotSent, Invited, InvitationNearExpired, etc.
    invited_on DATETIME2 NULL,
    invite_status_code INT NULL,
    
    -- Personal Settings
    time_zone_rule_version_number INT NULL,
    utc_conversion_time_zone_code INT NULL,
    time_zone_code INT NULL,
    preferred_phone_code INT NULL,
    preferred_address_code INT NULL,
    preferred_email_code INT NULL,
    
    -- Photo and Signature
    entity_image VARBINARY(MAX) NULL,
    entity_image_timestamp BIGINT NULL,
    entity_image_url NVARCHAR(200) NULL,
    email_signature NVARCHAR(MAX) NULL,
    
    -- System Fields
    created_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    created_by UNIQUEIDENTIFIER NOT NULL,
    modified_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    modified_by UNIQUEIDENTIFIER NOT NULL,
    version_number BIGINT NOT NULL DEFAULT 1,
    deleted_state INT NOT NULL DEFAULT 0, -- 0 = Active, 1 = Deleted
    
    CONSTRAINT FK_users_business_unit FOREIGN KEY (business_unit_id) REFERENCES dbo.business_units(id),
    CONSTRAINT FK_users_parent FOREIGN KEY (parent_user_id) REFERENCES dbo.users(id),
    CONSTRAINT UQ_users_domain_name UNIQUE (domain_name),
    CONSTRAINT UQ_users_internal_email UNIQUE (internal_email_address),
    CONSTRAINT CK_users_access_mode CHECK (access_mode IN (0, 1, 2, 3, 4)), -- Read-Write, Administrative, Read, Support, Non-interactive
    CONSTRAINT CK_users_cal_type CHECK (cal_type IN (0, 1, 2, 3)), -- Professional, Administrative, Basic, Essential
    CONSTRAINT CK_users_deleted_state CHECK (deleted_state IN (0, 1))
);

-- User-Role Relationships (Many-to-Many)
CREATE TABLE dbo.users_roles (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    user_id UNIQUEIDENTIFIER NOT NULL,
    role_id UNIQUEIDENTIFIER NOT NULL,
    
    -- Audit Fields
    created_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    created_by UNIQUEIDENTIFIER NOT NULL,
    
    CONSTRAINT FK_users_roles_user FOREIGN KEY (user_id) REFERENCES dbo.users(id) ON DELETE CASCADE,
    CONSTRAINT FK_users_roles_role FOREIGN KEY (role_id) REFERENCES dbo.security_roles(id) ON DELETE CASCADE,
    CONSTRAINT UQ_users_roles UNIQUE (user_id, role_id)
);

-- Team Membership (Many-to-Many)
CREATE TABLE dbo.team_membership (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    team_id UNIQUEIDENTIFIER NOT NULL,
    user_id UNIQUEIDENTIFIER NOT NULL,
    
    -- Audit Fields
    created_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    created_by UNIQUEIDENTIFIER NOT NULL,
    
    CONSTRAINT FK_team_membership_team FOREIGN KEY (team_id) REFERENCES dbo.teams(id) ON DELETE CASCADE,
    CONSTRAINT FK_team_membership_user FOREIGN KEY (user_id) REFERENCES dbo.users(id) ON DELETE CASCADE,
    CONSTRAINT UQ_team_membership UNIQUE (team_id, user_id)
);

-- Territories Table
CREATE TABLE dbo.territories (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    name NVARCHAR(200) NOT NULL,
    description NVARCHAR(MAX) NULL,
    manager_id UNIQUEIDENTIFIER NULL,
    organization_id UNIQUEIDENTIFIER NOT NULL,
    
    -- System Fields
    created_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    created_by UNIQUEIDENTIFIER NOT NULL,
    modified_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    modified_by UNIQUEIDENTIFIER NOT NULL,
    version_number BIGINT NOT NULL DEFAULT 1,
    
    CONSTRAINT FK_territories_manager FOREIGN KEY (manager_id) REFERENCES dbo.users(id)
);

-- User Settings Table (Personalization)
CREATE TABLE dbo.user_settings (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    user_id UNIQUEIDENTIFIER NOT NULL,
    
    -- UI Preferences
    advance_find_startup_mode INT NULL,
    auto_create_contact_on_promote INT NULL,
    business_card_options NVARCHAR(400) NULL,
    currency_decimal_precision INT NULL,
    currency_format_code INT NULL,
    date_format_code INT NULL,
    date_format_string NVARCHAR(255) NULL,
    date_separator NVARCHAR(5) NULL,
    decimal_symbol NVARCHAR(5) NULL,
    default_calendar_view INT NULL,
    default_dashboard_id UNIQUEIDENTIFIER NULL,
    
    -- Number and Time Formats
    full_name_conversion_map NVARCHAR(1000) NULL,
    long_date_format_code INT NULL,
    negative_currency_format_code INT NULL,
    negative_format_code INT NULL,
    number_format_code INT NULL,
    number_grouping_format NVARCHAR(50) NULL,
    number_separator NVARCHAR(5) NULL,
    paginate_excel_options NVARCHAR(400) NULL,
    personal_mail_box UNIQUEIDENTIFIER NULL,
    pricing_decimal_precision INT NULL,
    
    -- Regional Settings
    time_format_code INT NULL,
    time_format_string NVARCHAR(255) NULL,
    time_separator NVARCHAR(5) NULL,
    tracking_token_id INT NULL,
    ui_language_id INT NULL,
    use_cue_lang INT NULL,
    
    -- System Fields
    created_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    created_by UNIQUEIDENTIFIER NOT NULL,
    modified_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    modified_by UNIQUEIDENTIFIER NOT NULL,
    version_number BIGINT NOT NULL DEFAULT 1,
    
    CONSTRAINT FK_user_settings_user FOREIGN KEY (user_id) REFERENCES dbo.users(id) ON DELETE CASCADE,
    CONSTRAINT UQ_user_settings_user UNIQUE (user_id)
);

-- Positions Table (Job Positions/Titles)
CREATE TABLE dbo.positions (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX) NULL,
    parent_position_id UNIQUEIDENTIFIER NULL,
    
    -- System Fields
    created_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    created_by UNIQUEIDENTIFIER NOT NULL,
    modified_on DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    modified_by UNIQUEIDENTIFIER NOT NULL,
    version_number BIGINT NOT NULL DEFAULT 1,
    
    CONSTRAINT FK_positions_parent FOREIGN KEY (parent_position_id) REFERENCES dbo.positions(id)
);

-- Update foreign key constraints for existing tables to reference users table
ALTER TABLE dbo.accounts ADD CONSTRAINT FK_accounts_owner FOREIGN KEY (owner_id) REFERENCES dbo.users(id);
ALTER TABLE dbo.accounts ADD CONSTRAINT FK_accounts_created_by FOREIGN KEY (created_by) REFERENCES dbo.users(id);
ALTER TABLE dbo.accounts ADD CONSTRAINT FK_accounts_modified_by FOREIGN KEY (modified_by) REFERENCES dbo.users(id);
ALTER TABLE dbo.accounts ADD CONSTRAINT FK_accounts_primary_contact FOREIGN KEY (primary_contact_id) REFERENCES dbo.contacts(id);

ALTER TABLE dbo.contacts ADD CONSTRAINT FK_contacts_owner FOREIGN KEY (owner_id) REFERENCES dbo.users(id);
ALTER TABLE dbo.contacts ADD CONSTRAINT FK_contacts_created_by FOREIGN KEY (created_by) REFERENCES dbo.users(id);
ALTER TABLE dbo.contacts ADD CONSTRAINT FK_contacts_modified_by FOREIGN KEY (modified_by) REFERENCES dbo.users(id);

ALTER TABLE dbo.leads ADD CONSTRAINT FK_leads_owner FOREIGN KEY (owner_id) REFERENCES dbo.users(id);
ALTER TABLE dbo.leads ADD CONSTRAINT FK_leads_created_by FOREIGN KEY (created_by) REFERENCES dbo.users(id);
ALTER TABLE dbo.leads ADD CONSTRAINT FK_leads_modified_by FOREIGN KEY (modified_by) REFERENCES dbo.users(id);

ALTER TABLE dbo.opportunities ADD CONSTRAINT FK_opportunities_owner FOREIGN KEY (owner_id) REFERENCES dbo.users(id);
ALTER TABLE dbo.opportunities ADD CONSTRAINT FK_opportunities_created_by FOREIGN KEY (created_by) REFERENCES dbo.users(id);
ALTER TABLE dbo.opportunities ADD CONSTRAINT FK_opportunities_modified_by FOREIGN KEY (modified_by) REFERENCES dbo.users(id);

ALTER TABLE dbo.products ADD CONSTRAINT FK_products_created_by FOREIGN KEY (created_by) REFERENCES dbo.users(id);
ALTER TABLE dbo.products ADD CONSTRAINT FK_products_modified_by FOREIGN KEY (modified_by) REFERENCES dbo.users(id);

ALTER TABLE dbo.activities ADD CONSTRAINT FK_activities_owner FOREIGN KEY (owner_id) REFERENCES dbo.users(id);
ALTER TABLE dbo.activities ADD CONSTRAINT FK_activities_created_by FOREIGN KEY (created_by) REFERENCES dbo.users(id);
ALTER TABLE dbo.activities ADD CONSTRAINT FK_activities_modified_by FOREIGN KEY (modified_by) REFERENCES dbo.users(id);

-- Update relationship tables
ALTER TABLE dbo.accounts_contacts ADD CONSTRAINT FK_accounts_contacts_created_by FOREIGN KEY (created_by) REFERENCES dbo.users(id);
ALTER TABLE dbo.accounts_opportunities ADD CONSTRAINT FK_accounts_opportunities_created_by FOREIGN KEY (created_by) REFERENCES dbo.users(id);
ALTER TABLE dbo.contacts_leads ADD CONSTRAINT FK_contacts_leads_created_by FOREIGN KEY (created_by) REFERENCES dbo.users(id);
ALTER TABLE dbo.opportunities_products ADD CONSTRAINT FK_opportunities_products_created_by FOREIGN KEY (created_by) REFERENCES dbo.users(id);
ALTER TABLE dbo.opportunities_products ADD CONSTRAINT FK_opportunities_products_modified_by FOREIGN KEY (modified_by) REFERENCES dbo.users(id);
ALTER TABLE dbo.activities_entities ADD CONSTRAINT FK_activities_entities_created_by FOREIGN KEY (created_by) REFERENCES dbo.users(id);

-- Add territory foreign key constraint to accounts
ALTER TABLE dbo.accounts ADD CONSTRAINT FK_accounts_territory FOREIGN KEY (territory_id) REFERENCES dbo.territories(id);

-- Add position foreign key constraint to users
ALTER TABLE dbo.users ADD CONSTRAINT FK_users_position FOREIGN KEY (position_id) REFERENCES dbo.positions(id);

-- Add territory foreign key constraint to users
ALTER TABLE dbo.users ADD CONSTRAINT FK_users_territory FOREIGN KEY (territory_id) REFERENCES dbo.territories(id);

-- Add administrator foreign key constraint to teams
ALTER TABLE dbo.teams ADD CONSTRAINT FK_teams_administrator FOREIGN KEY (administrator_id) REFERENCES dbo.users(id);

-- =====================================================
-- INDEXES FOR USER AND SECURITY TABLES
-- =====================================================

-- Business Units Indexes
CREATE NONCLUSTERED INDEX IX_business_units_name ON dbo.business_units (name);
CREATE NONCLUSTERED INDEX IX_business_units_parent ON dbo.business_units (parent_business_unit_id);
CREATE NONCLUSTERED INDEX IX_business_units_status_state ON dbo.business_units (status_code, state_code);

-- Security Roles Indexes
CREATE NONCLUSTERED INDEX IX_security_roles_name ON dbo.security_roles (name);
CREATE NONCLUSTERED INDEX IX_security_roles_business_unit ON dbo.security_roles (business_unit_id);

-- Teams Indexes
CREATE NONCLUSTERED INDEX IX_teams_name ON dbo.teams (name);
CREATE NONCLUSTERED INDEX IX_teams_business_unit ON dbo.teams (business_unit_id);
CREATE NONCLUSTERED INDEX IX_teams_administrator ON dbo.teams (administrator_id);

-- Users Indexes
CREATE NONCLUSTERED INDEX IX_users_name ON dbo.users (last_name, first_name);
CREATE NONCLUSTERED INDEX IX_users_full_name ON dbo.users (full_name);
CREATE NONCLUSTERED INDEX IX_users_email ON dbo.users (internal_email_address);
CREATE NONCLUSTERED INDEX IX_users_domain_name ON dbo.users (domain_name);
CREATE NONCLUSTERED INDEX IX_users_business_unit ON dbo.users (business_unit_id);
CREATE NONCLUSTERED INDEX IX_users_manager ON dbo.users (parent_user_id);
CREATE NONCLUSTERED INDEX IX_users_territory ON dbo.users (territory_id);
CREATE NONCLUSTERED INDEX IX_users_disabled ON dbo.users (is_disabled, deleted_state);

-- User-Role Relationships Indexes
CREATE NONCLUSTERED INDEX IX_users_roles_user ON dbo.users_roles (user_id);
CREATE NONCLUSTERED INDEX IX_users_roles_role ON dbo.users_roles (role_id);

-- Team Membership Indexes
CREATE NONCLUSTERED INDEX IX_team_membership_team ON dbo.team_membership (team_id);
CREATE NONCLUSTERED INDEX IX_team_membership_user ON dbo.team_membership (user_id);

-- Territories Indexes
CREATE NONCLUSTERED INDEX IX_territories_name ON dbo.territories (name);
CREATE NONCLUSTERED INDEX IX_territories_manager ON dbo.territories (manager_id);

-- Positions Indexes
CREATE NONCLUSTERED INDEX IX_positions_name ON dbo.positions (name);
CREATE NONCLUSTERED INDEX IX_positions_parent ON dbo.positions (parent_position_id);

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

-- Procedure to create a new user
CREATE PROCEDURE dbo.sp_CreateSystemUser
    @DomainName NVARCHAR(1024),
    @InternalEmailAddress NVARCHAR(100),
    @UserName NVARCHAR(100),
    @FirstName NVARCHAR(64),
    @LastName NVARCHAR(64),
    @BusinessUnitId UNIQUEIDENTIFIER,
    @AccessMode INT = 0,
    @LicenseType INT = 0,
    @CreatedBy UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        SET @UserId = NEWID();
        
        INSERT INTO dbo.users (
            id, domain_name, internal_email_address, user_name,
            first_name, last_name, business_unit_id, access_mode,
            license_type, created_by, modified_by
        )
        VALUES (
            @UserId, @DomainName, @InternalEmailAddress, @UserName,
            @FirstName, @LastName, @BusinessUnitId, @AccessMode,
            @LicenseType, @CreatedBy, @CreatedBy
        );
        
        -- Create default user settings
        INSERT INTO dbo.user_settings (
            user_id, created_by, modified_by
        )
        VALUES (
            @UserId, @CreatedBy, @CreatedBy
        );
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

-- Procedure to assign role to user
CREATE PROCEDURE dbo.sp_AssignRoleToUser
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER,
    @CreatedBy UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if assignment already exists
    IF NOT EXISTS (SELECT 1 FROM dbo.users_roles WHERE user_id = @UserId AND role_id = @RoleId)
    BEGIN
        INSERT INTO dbo.users_roles (user_id, role_id, created_by)
        VALUES (@UserId, @RoleId, @CreatedBy);
    END;
END;
GO

-- Procedure to add user to team
CREATE PROCEDURE dbo.sp_AddUserToTeam
    @UserId UNIQUEIDENTIFIER,
    @TeamId UNIQUEIDENTIFIER,
    @CreatedBy UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if membership already exists
    IF NOT EXISTS (SELECT 1 FROM dbo.team_membership WHERE user_id = @UserId AND team_id = @TeamId)
    BEGIN
        INSERT INTO dbo.team_membership (user_id, team_id, created_by)
        VALUES (@UserId, @TeamId, @CreatedBy);
    END;
END;
GO

-- Function to get user's security roles
CREATE FUNCTION dbo.fn_GetUserRoles(@UserId UNIQUEIDENTIFIER)
RETURNS TABLE
AS
RETURN (
    SELECT 
        sr.id,
        sr.name,
        sr.description,
        bu.name AS business_unit_name
    FROM dbo.users_roles ur
    INNER JOIN dbo.security_roles sr ON ur.role_id = sr.id
    INNER JOIN dbo.business_units bu ON sr.business_unit_id = bu.id
    WHERE ur.user_id = @UserId
);
GO

-- Function to get user's teams
CREATE FUNCTION dbo.fn_GetUserTeams(@UserId UNIQUEIDENTIFIER)
RETURNS TABLE
AS
RETURN (
    SELECT 
        t.id,
        t.name,
        t.description,
        t.team_type,
        bu.name AS business_unit_name
    FROM dbo.team_membership tm
    INNER JOIN dbo.teams t ON tm.team_id = t.id
    INNER JOIN dbo.business_units bu ON t.business_unit_id = bu.id
    WHERE tm.user_id = @UserId
);
GO