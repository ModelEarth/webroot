-- These may be less standards based, we'll see what else emerges through promoting.

-- AI-specific tables for enhanced functionality

-- AI conversation summaries and insights
CREATE TABLE ai_insights (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    entity_type ENUM('contact', 'account', 'opportunity', 'lead') NOT NULL,
    entity_id CHAR(36) NOT NULL,
    insight_type ENUM('sentiment', 'next_action', 'summary', 'prediction') NOT NULL,
    content TEXT NOT NULL,
    confidence_score DECIMAL(3,2), -- 0.00 to 1.00
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    INDEX idx_entity (entity_type, entity_id),
    INDEX idx_type (insight_type)
);

-- Email/communication tracking for AI analysis
CREATE TABLE communications (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    contact_id CHAR(36),
    account_id CHAR(36),
    direction ENUM('inbound', 'outbound') NOT NULL,
    channel ENUM('email', 'phone', 'linkedin', 'other') NOT NULL,
    subject VARCHAR(255),
    content TEXT,
    sentiment_score DECIMAL(3,2), -- -1.00 to 1.00
    responded BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (contact_id) REFERENCES contacts(id) ON DELETE CASCADE,
    FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
    INDEX idx_direction (direction),
    INDEX idx_channel (channel),
    INDEX idx_sentiment (sentiment_score)
);

-- Custom fields for flexibility (JSON approach)
CREATE TABLE custom_fields (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    entity_type ENUM('contact', 'account', 'opportunity', 'lead') NOT NULL,
    entity_id CHAR(36) NOT NULL,
    field_data JSON NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_entity_fields (entity_type, entity_id),
    INDEX idx_entity (entity_type, entity_id)
);