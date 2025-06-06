-- Core CRM Database Schema
-- Commonly used structure for AI-powered CRM systems

-- Accounts table (Salesforce standard - most widely used)
CREATE TABLE accounts (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(255) NOT NULL,
    domain VARCHAR(255),
    industry VARCHAR(100),
    size_category ENUM('startup', 'small', 'medium', 'large', 'enterprise'),
    employee_count INT,
    annual_revenue DECIMAL(15,2),
    website VARCHAR(255),
    phone VARCHAR(50),
    address_line1 VARCHAR(255),
    address_line2 VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100),
    timezone VARCHAR(50),
    status ENUM('active', 'inactive', 'prospect') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by CHAR(36),
    INDEX idx_domain (domain),
    INDEX idx_industry (industry),
    INDEX idx_status (status)
);

-- Contacts table
CREATE TABLE contacts (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    account_id CHAR(36),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(50),
    mobile VARCHAR(50),
    job_title VARCHAR(150),
    department VARCHAR(100),
    linkedin_url VARCHAR(255),
    status ENUM('active', 'inactive', 'bounced', 'unsubscribed') DEFAULT 'active',
    lead_source VARCHAR(100),
    lead_score INT DEFAULT 0,
    last_contacted_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by CHAR(36),
    FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE SET NULL,
    INDEX idx_email (email),
    INDEX idx_account (account_id),
    INDEX idx_status (status),
    INDEX idx_lead_score (lead_score)
);

-- Users/Team members table
CREATE TABLE users (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    email VARCHAR(255) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    role ENUM('admin', 'manager', 'sales_rep', 'marketing', 'support') NOT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Deals/Opportunities table
CREATE TABLE opportunities (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    account_id CHAR(36) NOT NULL,
    contact_id CHAR(36),
    owner_id CHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    value DECIMAL(15,2),
    currency VARCHAR(3) DEFAULT 'USD',
    stage ENUM('prospecting', 'qualification', 'proposal', 'negotiation', 'closed_won', 'closed_lost') NOT NULL,
    probability INT DEFAULT 0,
    expected_close_date DATE,
    actual_close_date DATE,
    lead_source VARCHAR(100),
    deal_type VARCHAR(100),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
    FOREIGN KEY (contact_id) REFERENCES contacts(id) ON DELETE SET NULL,
    FOREIGN KEY (owner_id) REFERENCES users(id),
    INDEX idx_stage (stage),
    INDEX idx_owner (owner_id),
    INDEX idx_close_date (expected_close_date),
    INDEX idx_value (value)
);

-- Activities table (calls, emails, meetings, tasks)
CREATE TABLE activities (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    type ENUM('call', 'email', 'meeting', 'task', 'note') NOT NULL,
    subject VARCHAR(255) NOT NULL,
    description TEXT,
    contact_id CHAR(36),
    account_id CHAR(36),
    opportunity_id CHAR(36),
    owner_id CHAR(36) NOT NULL,
    status ENUM('completed', 'scheduled', 'cancelled') DEFAULT 'scheduled',
    scheduled_at TIMESTAMP,
    completed_at TIMESTAMP,
    duration_minutes INT,
    outcome VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (contact_id) REFERENCES contacts(id) ON DELETE CASCADE,
    FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
    FOREIGN KEY (opportunity_id) REFERENCES opportunities(id) ON DELETE CASCADE,
    FOREIGN KEY (owner_id) REFERENCES users(id),
    INDEX idx_type (type),
    INDEX idx_scheduled (scheduled_at),
    INDEX idx_status (status),
    INDEX idx_owner (owner_id)
);

-- Email campaigns table
CREATE TABLE campaigns (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(255) NOT NULL,
    type ENUM('email', 'cold_outreach', 'nurture', 'event') NOT NULL,
    status ENUM('draft', 'active', 'paused', 'completed') DEFAULT 'draft',
    subject VARCHAR(255),
    content TEXT,
    sent_count INT DEFAULT 0,
    opened_count INT DEFAULT 0,
    clicked_count INT DEFAULT 0,
    replied_count INT DEFAULT 0,
    created_by CHAR(36),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id),
    INDEX idx_status (status),
    INDEX idx_type (type)
);

-- Campaign recipients/tracking
CREATE TABLE campaign_contacts (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    campaign_id CHAR(36) NOT NULL,
    contact_id CHAR(36) NOT NULL,
    status ENUM('pending', 'sent', 'opened', 'clicked', 'replied', 'bounced') DEFAULT 'pending',
    sent_at TIMESTAMP NULL,
    opened_at TIMESTAMP NULL,
    clicked_at TIMESTAMP NULL,
    replied_at TIMESTAMP NULL,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (contact_id) REFERENCES contacts(id) ON DELETE CASCADE,
    UNIQUE KEY unique_campaign_contact (campaign_id, contact_id),
    INDEX idx_status (status)
);

-- Tags for flexible categorization
CREATE TABLE tags (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(100) UNIQUE NOT NULL,
    color VARCHAR(7), -- hex color code
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tag associations (polymorphic)
CREATE TABLE taggables (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    tag_id CHAR(36) NOT NULL,
    taggable_id CHAR(36) NOT NULL,
    taggable_type ENUM('contact', 'account', 'opportunity', 'lead') NOT NULL,
    FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE,
    UNIQUE KEY unique_tag_association (tag_id, taggable_id, taggable_type),
    INDEX idx_taggable (taggable_id, taggable_type)
);

-- AI-specific tables for enhanced functionality

-- Leads table (Salesforce standard - prospects not yet converted)
CREATE TABLE leads (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(50),
    company VARCHAR(255),
    job_title VARCHAR(150),
    lead_source VARCHAR(100),
    lead_score INT DEFAULT 0,
    status ENUM('new', 'working', 'nurturing', 'qualified', 'unqualified') DEFAULT 'new',
    rating ENUM('hot', 'warm', 'cold') DEFAULT 'cold',
    converted BOOLEAN DEFAULT FALSE,
    converted_account_id CHAR(36),
    converted_contact_id CHAR(36),
    converted_opportunity_id CHAR(36),
    converted_date TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by CHAR(36),
    FOREIGN KEY (converted_account_id) REFERENCES accounts(id) ON DELETE SET NULL,
    FOREIGN KEY (converted_contact_id) REFERENCES contacts(id) ON DELETE SET NULL,
    FOREIGN KEY (converted_opportunity_id) REFERENCES opportunities(id) ON DELETE SET NULL,
    FOREIGN KEY (created_by) REFERENCES users(id),
    INDEX idx_email (email),
    INDEX idx_status (status),
    INDEX idx_lead_score (lead_score),
    INDEX idx_converted (converted)
);