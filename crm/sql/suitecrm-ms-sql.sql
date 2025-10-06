/* SQLINES DEMO ***  the sandbox mode */ 
-- SQLINES DEMO *** 9-11.7.2-MariaDB, for osx10.20 (arm64)
--
-- SQLINES DEMO ***   Database: CRM
-- SQLINES DEMO *** -------------------------------------
-- SQLINES DEMO *** .7.2-MariaDB

/* SQLINES DEMO *** CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/* SQLINES DEMO *** CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/* SQLINES DEMO *** COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/* SQLINES DEMO ***  utf8mb4 */;
/* SQLINES DEMO *** TIME_ZONE=@@TIME_ZONE */;
/* SQLINES DEMO *** ZONE='+00:00' */;
/* SQLINES DEMO *** UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/* SQLINES DEMO *** FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/* SQLINES DEMO *** SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/* SQLINES DEMO *** D_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- SQLINES DEMO *** or table `accounts`
--

DROP TABLE IF EXISTS accounts;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
-- SQLINES FOR EVALUATION USE ONLY (14 DAYS)
CREATE TABLE accounts (
  id char(36) NOT NULL,
  name varchar(150) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  account_type varchar(50) DEFAULT NULL,
  industry varchar(50) DEFAULT NULL,
  annual_revenue varchar(100) DEFAULT NULL,
  phone_fax varchar(100) DEFAULT NULL,
  billing_address_street varchar(150) DEFAULT NULL,
  billing_address_city varchar(100) DEFAULT NULL,
  billing_address_state varchar(100) DEFAULT NULL,
  billing_address_postalcode varchar(20) DEFAULT NULL,
  billing_address_country varchar(255) DEFAULT NULL,
  rating varchar(100) DEFAULT NULL,
  phone_office varchar(100) DEFAULT NULL,
  phone_alternate varchar(100) DEFAULT NULL,
  website varchar(255) DEFAULT NULL,
  ownership varchar(100) DEFAULT NULL,
  employees varchar(10) DEFAULT NULL,
  ticker_symbol varchar(10) DEFAULT NULL,
  shipping_address_street varchar(150) DEFAULT NULL,
  shipping_address_city varchar(100) DEFAULT NULL,
  shipping_address_state varchar(100) DEFAULT NULL,
  shipping_address_postalcode varchar(20) DEFAULT NULL,
  shipping_address_country varchar(255) DEFAULT NULL,
  parent_id char(36) DEFAULT NULL,
  sic_code varchar(10) DEFAULT NULL,
  campaign_id char(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_accnt_id_del ON accounts (id,deleted);
CREATE INDEX idx_accnt_name_del ON accounts (name,deleted);
CREATE INDEX idx_accnt_assigned_del ON accounts (deleted,assigned_user_id);
CREATE INDEX idx_accnt_parent_id ON accounts (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `accounts_audit`
--

DROP TABLE IF EXISTS accounts_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE accounts_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_accounts_parent_id ON accounts_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `accounts_bugs`
--

DROP TABLE IF EXISTS accounts_bugs;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE accounts_bugs (
  id varchar(36) NOT NULL,
  account_id varchar(36) DEFAULT NULL,
  bug_id varchar(36) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_acc_bug_acc ON accounts_bugs (account_id);
CREATE INDEX idx_acc_bug_bug ON accounts_bugs (bug_id);
CREATE INDEX idx_account_bug ON accounts_bugs (account_id,bug_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `accounts_cases`
--

DROP TABLE IF EXISTS accounts_cases;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE accounts_cases (
  id varchar(36) NOT NULL,
  account_id varchar(36) DEFAULT NULL,
  case_id varchar(36) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_acc_case_acc ON accounts_cases (account_id);
CREATE INDEX idx_acc_acc_case ON accounts_cases (case_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `accounts_contacts`
--

DROP TABLE IF EXISTS accounts_contacts;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE accounts_contacts (
  id varchar(36) NOT NULL,
  contact_id varchar(36) DEFAULT NULL,
  account_id varchar(36) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_account_contact ON accounts_contacts (account_id,contact_id);
CREATE INDEX idx_contid_del_accid ON accounts_contacts (contact_id,deleted,account_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `accounts_cstm`
--

DROP TABLE IF EXISTS accounts_cstm;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE accounts_cstm (
  id_c char(36) NOT NULL,
  jjwg_maps_lng_c float DEFAULT 0.00000000,
  jjwg_maps_lat_c float DEFAULT 0.00000000,
  jjwg_maps_geocode_status_c varchar(255) DEFAULT NULL,
  jjwg_maps_address_c varchar(255) DEFAULT NULL,
  PRIMARY KEY (id_c)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `accounts_opportunities`
--

DROP TABLE IF EXISTS accounts_opportunities;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE accounts_opportunities (
  id varchar(36) NOT NULL,
  opportunity_id varchar(36) DEFAULT NULL,
  account_id varchar(36) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_account_opportunity ON accounts_opportunities (account_id,opportunity_id);
CREATE INDEX idx_oppid_del_accid ON accounts_opportunities (opportunity_id,deleted,account_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `acl_actions`
--

DROP TABLE IF EXISTS acl_actions;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE acl_actions (
  id char(36) NOT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  name varchar(150) DEFAULT NULL,
  category varchar(100) DEFAULT NULL,
  acltype varchar(100) DEFAULT NULL,
  aclaccess int DEFAULT NULL,
  deleted smallint DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_aclaction_id_del ON acl_actions (id,deleted);
CREATE INDEX idx_category_name ON acl_actions (category,name);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `acl_roles`
--

DROP TABLE IF EXISTS acl_roles;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE acl_roles (
  id char(36) NOT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  name varchar(150) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_aclrole_id_del ON acl_roles (id,deleted);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `acl_roles_actions`
--

DROP TABLE IF EXISTS acl_roles_actions;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE acl_roles_actions (
  id varchar(36) NOT NULL,
  role_id varchar(36) DEFAULT NULL,
  action_id varchar(36) DEFAULT NULL,
  access_override int DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_acl_role_id ON acl_roles_actions (role_id);
CREATE INDEX idx_acl_action_id ON acl_roles_actions (action_id);
CREATE INDEX idx_aclrole_action ON acl_roles_actions (role_id,action_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `acl_roles_users`
--

DROP TABLE IF EXISTS acl_roles_users;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE acl_roles_users (
  id varchar(36) NOT NULL,
  role_id varchar(36) DEFAULT NULL,
  user_id varchar(36) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_aclrole_id ON acl_roles_users (role_id);
CREATE INDEX idx_acluser_id ON acl_roles_users (user_id);
CREATE INDEX idx_aclrole_user ON acl_roles_users (role_id,user_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `address_book`
--

DROP TABLE IF EXISTS address_book;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE address_book (
  assigned_user_id char(36) NOT NULL,
  bean varchar(50) DEFAULT NULL,
  bean_id char(36) NOT NULL
) ;

CREATE INDEX ab_user_bean_idx ON address_book (assigned_user_id,bean);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `alerts`
--

DROP TABLE IF EXISTS alerts;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE alerts (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  is_read smallint DEFAULT NULL,
  target_module varchar(255) DEFAULT NULL,
  type varchar(255) DEFAULT NULL,
  url_redirect varchar(255) DEFAULT NULL,
  reminder_id char(36) DEFAULT NULL,
  snooze datetime2(0) DEFAULT NULL,
  date_start datetime2(0) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `am_projecttemplates`
--

DROP TABLE IF EXISTS am_projecttemplates;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE am_projecttemplates (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  status varchar(100) DEFAULT 'Draft',
  priority varchar(100) DEFAULT 'High',
  override_business_hours smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `am_projecttemplates_audit`
--

DROP TABLE IF EXISTS am_projecttemplates_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE am_projecttemplates_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_am_projecttemplates_parent_id ON am_projecttemplates_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `am_projecttemplates_contacts_1_c`
--

DROP TABLE IF EXISTS am_projecttemplates_contacts_1_c;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE am_projecttemplates_contacts_1_c (
  id varchar(36) NOT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  am_projecttemplates_ida varchar(36) DEFAULT NULL,
  contacts_idb varchar(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX am_projecttemplates_contacts_1_alt ON am_projecttemplates_contacts_1_c (am_projecttemplates_ida,contacts_idb);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `am_projecttemplates_project_1_c`
--

DROP TABLE IF EXISTS am_projecttemplates_project_1_c;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE am_projecttemplates_project_1_c (
  id varchar(36) NOT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  am_projecttemplates_project_1am_projecttemplates_ida varchar(36) DEFAULT NULL,
  am_projecttemplates_project_1project_idb varchar(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX am_projecttemplates_project_1_ida1 ON am_projecttemplates_project_1_c (am_projecttemplates_project_1am_projecttemplates_ida);
CREATE INDEX am_projecttemplates_project_1_alt ON am_projecttemplates_project_1_c (am_projecttemplates_project_1project_idb);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `am_projecttemplates_users_1_c`
--

DROP TABLE IF EXISTS am_projecttemplates_users_1_c;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE am_projecttemplates_users_1_c (
  id varchar(36) NOT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  am_projecttemplates_ida varchar(36) DEFAULT NULL,
  users_idb varchar(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX am_projecttemplates_users_1_alt ON am_projecttemplates_users_1_c (am_projecttemplates_ida,users_idb);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `am_tasktemplates`
--

DROP TABLE IF EXISTS am_tasktemplates;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE am_tasktemplates (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  status varchar(100) DEFAULT 'Not Started',
  priority varchar(100) DEFAULT 'High',
  percent_complete int DEFAULT 0,
  predecessors int DEFAULT NULL,
  milestone_flag smallint DEFAULT 0,
  relationship_type varchar(100) DEFAULT 'FS',
  task_number int DEFAULT NULL,
  order_number int DEFAULT NULL,
  estimated_effort int DEFAULT NULL,
  utilization varchar(100) DEFAULT '0',
  duration int DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `am_tasktemplates_am_projecttemplates_c`
--

DROP TABLE IF EXISTS am_tasktemplates_am_projecttemplates_c;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE am_tasktemplates_am_projecttemplates_c (
  id varchar(36) NOT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  am_tasktemplates_am_projecttemplatesam_projecttemplates_ida varchar(36) DEFAULT NULL,
  am_tasktemplates_am_projecttemplatesam_tasktemplates_idb varchar(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX am_tasktemplates_am_projecttemplates_ida1 ON am_tasktemplates_am_projecttemplates_c (am_tasktemplates_am_projecttemplatesam_projecttemplates_ida);
CREATE INDEX am_tasktemplates_am_projecttemplates_alt ON am_tasktemplates_am_projecttemplates_c (am_tasktemplates_am_projecttemplatesam_tasktemplates_idb);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `am_tasktemplates_audit`
--

DROP TABLE IF EXISTS am_tasktemplates_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE am_tasktemplates_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_am_tasktemplates_parent_id ON am_tasktemplates_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aobh_businesshours`
--

DROP TABLE IF EXISTS aobh_businesshours;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aobh_businesshours (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  opening_hours varchar(100) DEFAULT '1',
  closing_hours varchar(100) DEFAULT '1',
  open_status smallint DEFAULT NULL,
  day varchar(100) DEFAULT 'monday',
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aok_knowledge_base_categories`
--

DROP TABLE IF EXISTS aok_knowledge_base_categories;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aok_knowledge_base_categories (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aok_knowledge_base_categories_audit`
--

DROP TABLE IF EXISTS aok_knowledge_base_categories_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aok_knowledge_base_categories_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_aok_knowledge_base_categories_parent_id ON aok_knowledge_base_categories_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aok_knowledgebase`
--

DROP TABLE IF EXISTS aok_knowledgebase;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aok_knowledgebase (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  status varchar(100) DEFAULT 'Draft',
  revision varchar(255) DEFAULT NULL,
  additional_info varchar(max) DEFAULT NULL,
  user_id_c char(36) DEFAULT NULL,
  user_id1_c char(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aok_knowledgebase_audit`
--

DROP TABLE IF EXISTS aok_knowledgebase_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aok_knowledgebase_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_aok_knowledgebase_parent_id ON aok_knowledgebase_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aok_knowledgebase_categories`
--

DROP TABLE IF EXISTS aok_knowledgebase_categories;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aok_knowledgebase_categories (
  id varchar(36) NOT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  aok_knowledgebase_id varchar(36) DEFAULT NULL,
  aok_knowledge_base_categories_id varchar(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX aok_knowledgebase_categories_alt ON aok_knowledgebase_categories (aok_knowledgebase_id,aok_knowledge_base_categories_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aop_case_events`
--

DROP TABLE IF EXISTS aop_case_events;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aop_case_events (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  case_id char(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aop_case_events_audit`
--

DROP TABLE IF EXISTS aop_case_events_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aop_case_events_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_aop_case_events_parent_id ON aop_case_events_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aop_case_updates`
--

DROP TABLE IF EXISTS aop_case_updates;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aop_case_updates (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  case_id char(36) DEFAULT NULL,
  contact_id char(36) DEFAULT NULL,
  internal smallint DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aop_case_updates_audit`
--

DROP TABLE IF EXISTS aop_case_updates_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aop_case_updates_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_aop_case_updates_parent_id ON aop_case_updates_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aor_charts`
--

DROP TABLE IF EXISTS aor_charts;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aor_charts (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  aor_report_id char(36) DEFAULT NULL,
  type varchar(100) DEFAULT NULL,
  x_field int DEFAULT NULL,
  y_field int DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aor_conditions`
--

DROP TABLE IF EXISTS aor_conditions;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aor_conditions (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  aor_report_id char(36) DEFAULT NULL,
  condition_order int DEFAULT NULL,
  logic_op varchar(255) DEFAULT NULL,
  parenthesis varchar(255) DEFAULT NULL,
  module_path varchar(max) DEFAULT NULL,
  field varchar(100) DEFAULT NULL,
  operator varchar(100) DEFAULT NULL,
  value_type varchar(100) DEFAULT NULL,
  value varchar(255) DEFAULT NULL,
  parameter smallint DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX aor_conditions_index_report_id ON aor_conditions (aor_report_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aor_fields`
--

DROP TABLE IF EXISTS aor_fields;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aor_fields (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  aor_report_id char(36) DEFAULT NULL,
  field_order int DEFAULT NULL,
  module_path varchar(max) DEFAULT NULL,
  field varchar(100) DEFAULT NULL,
  display smallint DEFAULT NULL,
  link smallint DEFAULT NULL,
  label varchar(255) DEFAULT NULL,
  field_function varchar(100) DEFAULT NULL,
  sort_by varchar(100) DEFAULT NULL,
  format varchar(100) DEFAULT NULL,
  total varchar(100) DEFAULT NULL,
  sort_order varchar(100) DEFAULT NULL,
  group_by smallint DEFAULT NULL,
  group_order varchar(100) DEFAULT NULL,
  group_display int DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX aor_fields_index_report_id ON aor_fields (aor_report_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aor_reports`
--

DROP TABLE IF EXISTS aor_reports;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aor_reports (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  report_module varchar(100) DEFAULT NULL,
  graphs_per_row int DEFAULT 2,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aor_reports_audit`
--

DROP TABLE IF EXISTS aor_reports_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aor_reports_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_aor_reports_parent_id ON aor_reports_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aor_scheduled_reports`
--

DROP TABLE IF EXISTS aor_scheduled_reports;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aor_scheduled_reports (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  schedule varchar(100) DEFAULT NULL,
  last_run datetime2(0) DEFAULT NULL,
  status varchar(100) DEFAULT NULL,
  email_recipients varchar(max) DEFAULT NULL,
  aor_report_id char(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aos_contracts`
--

DROP TABLE IF EXISTS aos_contracts;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aos_contracts (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  reference_code varchar(255) DEFAULT NULL,
  start_date date DEFAULT NULL,
  end_date date DEFAULT NULL,
  total_contract_value decimal(26,6) DEFAULT NULL,
  total_contract_value_usdollar decimal(26,6) DEFAULT NULL,
  currency_id char(36) DEFAULT NULL,
  status varchar(100) DEFAULT 'Not Started',
  customer_signed_date date DEFAULT NULL,
  company_signed_date date DEFAULT NULL,
  renewal_reminder_date datetime2(0) DEFAULT NULL,
  contract_type varchar(100) DEFAULT 'Type',
  contract_account_id char(36) DEFAULT NULL,
  opportunity_id char(36) DEFAULT NULL,
  contact_id char(36) DEFAULT NULL,
  call_id char(36) DEFAULT NULL,
  total_amt decimal(26,6) DEFAULT NULL,
  total_amt_usdollar decimal(26,6) DEFAULT NULL,
  subtotal_amount decimal(26,6) DEFAULT NULL,
  subtotal_amount_usdollar decimal(26,6) DEFAULT NULL,
  discount_amount decimal(26,6) DEFAULT NULL,
  discount_amount_usdollar decimal(26,6) DEFAULT NULL,
  tax_amount decimal(26,6) DEFAULT NULL,
  tax_amount_usdollar decimal(26,6) DEFAULT NULL,
  shipping_amount decimal(26,6) DEFAULT NULL,
  shipping_amount_usdollar decimal(26,6) DEFAULT NULL,
  shipping_tax varchar(100) DEFAULT NULL,
  shipping_tax_amt decimal(26,6) DEFAULT NULL,
  shipping_tax_amt_usdollar decimal(26,6) DEFAULT NULL,
  total_amount decimal(26,6) DEFAULT NULL,
  total_amount_usdollar decimal(26,6) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aos_contracts_audit`
--

DROP TABLE IF EXISTS aos_contracts_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aos_contracts_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_aos_contracts_parent_id ON aos_contracts_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aos_contracts_documents`
--

DROP TABLE IF EXISTS aos_contracts_documents;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aos_contracts_documents (
  id varchar(36) NOT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  aos_contracts_id varchar(36) DEFAULT NULL,
  documents_id varchar(36) DEFAULT NULL,
  document_revision_id varchar(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX aos_contracts_documents_alt ON aos_contracts_documents (aos_contracts_id,documents_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aos_invoices`
--

DROP TABLE IF EXISTS aos_invoices;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aos_invoices (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  billing_account_id char(36) DEFAULT NULL,
  billing_contact_id char(36) DEFAULT NULL,
  billing_address_street varchar(150) DEFAULT NULL,
  billing_address_city varchar(100) DEFAULT NULL,
  billing_address_state varchar(100) DEFAULT NULL,
  billing_address_postalcode varchar(20) DEFAULT NULL,
  billing_address_country varchar(255) DEFAULT NULL,
  shipping_address_street varchar(150) DEFAULT NULL,
  shipping_address_city varchar(100) DEFAULT NULL,
  shipping_address_state varchar(100) DEFAULT NULL,
  shipping_address_postalcode varchar(20) DEFAULT NULL,
  shipping_address_country varchar(255) DEFAULT NULL,
  number int NOT NULL,
  total_amt decimal(26,6) DEFAULT NULL,
  total_amt_usdollar decimal(26,6) DEFAULT NULL,
  subtotal_amount decimal(26,6) DEFAULT NULL,
  subtotal_amount_usdollar decimal(26,6) DEFAULT NULL,
  discount_amount decimal(26,6) DEFAULT NULL,
  discount_amount_usdollar decimal(26,6) DEFAULT NULL,
  tax_amount decimal(26,6) DEFAULT NULL,
  tax_amount_usdollar decimal(26,6) DEFAULT NULL,
  shipping_amount decimal(26,6) DEFAULT NULL,
  shipping_amount_usdollar decimal(26,6) DEFAULT NULL,
  shipping_tax varchar(100) DEFAULT NULL,
  shipping_tax_amt decimal(26,6) DEFAULT NULL,
  shipping_tax_amt_usdollar decimal(26,6) DEFAULT NULL,
  total_amount decimal(26,6) DEFAULT NULL,
  total_amount_usdollar decimal(26,6) DEFAULT NULL,
  currency_id char(36) DEFAULT NULL,
  quote_number int DEFAULT NULL,
  quote_date date DEFAULT NULL,
  invoice_date date DEFAULT NULL,
  due_date date DEFAULT NULL,
  status varchar(100) DEFAULT NULL,
  template_ddown_c varchar(max) DEFAULT NULL,
  subtotal_tax_amount decimal(26,6) DEFAULT NULL,
  subtotal_tax_amount_usdollar decimal(26,6) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aos_invoices_audit`
--

DROP TABLE IF EXISTS aos_invoices_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aos_invoices_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_aos_invoices_parent_id ON aos_invoices_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aos_line_item_groups`
--

DROP TABLE IF EXISTS aos_line_item_groups;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aos_line_item_groups (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  total_amt decimal(26,6) DEFAULT NULL,
  total_amt_usdollar decimal(26,6) DEFAULT NULL,
  discount_amount decimal(26,6) DEFAULT NULL,
  discount_amount_usdollar decimal(26,6) DEFAULT NULL,
  subtotal_amount decimal(26,6) DEFAULT NULL,
  subtotal_amount_usdollar decimal(26,6) DEFAULT NULL,
  tax_amount decimal(26,6) DEFAULT NULL,
  tax_amount_usdollar decimal(26,6) DEFAULT NULL,
  subtotal_tax_amount decimal(26,6) DEFAULT NULL,
  subtotal_tax_amount_usdollar decimal(26,6) DEFAULT NULL,
  total_amount decimal(26,6) DEFAULT NULL,
  total_amount_usdollar decimal(26,6) DEFAULT NULL,
  parent_type varchar(100) DEFAULT NULL,
  parent_id char(36) DEFAULT NULL,
  number int DEFAULT NULL,
  currency_id char(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aos_line_item_groups_audit`
--

DROP TABLE IF EXISTS aos_line_item_groups_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aos_line_item_groups_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_aos_line_item_groups_parent_id ON aos_line_item_groups_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aos_pdf_templates`
--

DROP TABLE IF EXISTS aos_pdf_templates;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aos_pdf_templates (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  active smallint DEFAULT 1,
  type varchar(100) DEFAULT NULL,
  pdfheader varchar(max) DEFAULT NULL,
  pdffooter varchar(max) DEFAULT NULL,
  margin_left int DEFAULT 15,
  margin_right int DEFAULT 15,
  margin_top int DEFAULT 16,
  margin_bottom int DEFAULT 16,
  margin_header int DEFAULT 9,
  margin_footer int DEFAULT 9,
  page_size varchar(100) DEFAULT NULL,
  orientation varchar(100) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aos_pdf_templates_audit`
--

DROP TABLE IF EXISTS aos_pdf_templates_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aos_pdf_templates_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_aos_pdf_templates_parent_id ON aos_pdf_templates_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aos_product_categories`
--

DROP TABLE IF EXISTS aos_product_categories;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aos_product_categories (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  is_parent smallint DEFAULT 0,
  parent_category_id char(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aos_product_categories_audit`
--

DROP TABLE IF EXISTS aos_product_categories_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aos_product_categories_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_aos_product_categories_parent_id ON aos_product_categories_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aos_products`
--

DROP TABLE IF EXISTS aos_products;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aos_products (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  maincode varchar(100) DEFAULT 'XXXX',
  part_number varchar(25) DEFAULT NULL,
  category varchar(100) DEFAULT NULL,
  type varchar(100) DEFAULT 'Good',
  cost decimal(26,6) DEFAULT NULL,
  cost_usdollar decimal(26,6) DEFAULT NULL,
  currency_id char(36) DEFAULT NULL,
  price decimal(26,6) DEFAULT NULL,
  price_usdollar decimal(26,6) DEFAULT NULL,
  url varchar(255) DEFAULT NULL,
  contact_id char(36) DEFAULT NULL,
  product_image varchar(255) DEFAULT NULL,
  aos_product_category_id char(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aos_products_audit`
--

DROP TABLE IF EXISTS aos_products_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aos_products_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_aos_products_parent_id ON aos_products_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aos_products_quotes`
--

DROP TABLE IF EXISTS aos_products_quotes;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aos_products_quotes (
  id char(36) NOT NULL,
  name varchar(max) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  currency_id char(36) DEFAULT NULL,
  part_number varchar(255) DEFAULT NULL,
  item_description varchar(max) DEFAULT NULL,
  number int DEFAULT NULL,
  product_qty decimal(18,4) DEFAULT NULL,
  product_cost_price decimal(26,6) DEFAULT NULL,
  product_cost_price_usdollar decimal(26,6) DEFAULT NULL,
  product_list_price decimal(26,6) DEFAULT NULL,
  product_list_price_usdollar decimal(26,6) DEFAULT NULL,
  product_discount decimal(26,6) DEFAULT NULL,
  product_discount_usdollar decimal(26,6) DEFAULT NULL,
  product_discount_amount decimal(26,6) DEFAULT NULL,
  product_discount_amount_usdollar decimal(26,6) DEFAULT NULL,
  discount varchar(255) DEFAULT 'Percentage',
  product_unit_price decimal(26,6) DEFAULT NULL,
  product_unit_price_usdollar decimal(26,6) DEFAULT NULL,
  vat_amt decimal(26,6) DEFAULT NULL,
  vat_amt_usdollar decimal(26,6) DEFAULT NULL,
  product_total_price decimal(26,6) DEFAULT NULL,
  product_total_price_usdollar decimal(26,6) DEFAULT NULL,
  vat varchar(100) DEFAULT '5.0',
  parent_type varchar(100) DEFAULT NULL,
  parent_id char(36) DEFAULT NULL,
  product_id char(36) DEFAULT NULL,
  group_id char(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_aospq_par_del ON aos_products_quotes (parent_id,parent_type,deleted);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aos_products_quotes_audit`
--

DROP TABLE IF EXISTS aos_products_quotes_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aos_products_quotes_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_aos_products_quotes_parent_id ON aos_products_quotes_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aos_quotes`
--

DROP TABLE IF EXISTS aos_quotes;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aos_quotes (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  approval_issue varchar(max) DEFAULT NULL,
  billing_account_id char(36) DEFAULT NULL,
  billing_contact_id char(36) DEFAULT NULL,
  billing_address_street varchar(150) DEFAULT NULL,
  billing_address_city varchar(100) DEFAULT NULL,
  billing_address_state varchar(100) DEFAULT NULL,
  billing_address_postalcode varchar(20) DEFAULT NULL,
  billing_address_country varchar(255) DEFAULT NULL,
  shipping_address_street varchar(150) DEFAULT NULL,
  shipping_address_city varchar(100) DEFAULT NULL,
  shipping_address_state varchar(100) DEFAULT NULL,
  shipping_address_postalcode varchar(20) DEFAULT NULL,
  shipping_address_country varchar(255) DEFAULT NULL,
  expiration date DEFAULT NULL,
  number int DEFAULT NULL,
  opportunity_id char(36) DEFAULT NULL,
  template_ddown_c varchar(max) DEFAULT NULL,
  total_amt decimal(26,6) DEFAULT NULL,
  total_amt_usdollar decimal(26,6) DEFAULT NULL,
  subtotal_amount decimal(26,6) DEFAULT NULL,
  subtotal_amount_usdollar decimal(26,6) DEFAULT NULL,
  discount_amount decimal(26,6) DEFAULT NULL,
  discount_amount_usdollar decimal(26,6) DEFAULT NULL,
  tax_amount decimal(26,6) DEFAULT NULL,
  tax_amount_usdollar decimal(26,6) DEFAULT NULL,
  shipping_amount decimal(26,6) DEFAULT NULL,
  shipping_amount_usdollar decimal(26,6) DEFAULT NULL,
  shipping_tax varchar(100) DEFAULT NULL,
  shipping_tax_amt decimal(26,6) DEFAULT NULL,
  shipping_tax_amt_usdollar decimal(26,6) DEFAULT NULL,
  total_amount decimal(26,6) DEFAULT NULL,
  total_amount_usdollar decimal(26,6) DEFAULT NULL,
  currency_id char(36) DEFAULT NULL,
  stage varchar(100) DEFAULT 'Draft',
  term varchar(100) DEFAULT NULL,
  terms_c varchar(max) DEFAULT NULL,
  approval_status varchar(100) DEFAULT NULL,
  invoice_status varchar(100) DEFAULT 'Not Invoiced',
  subtotal_tax_amount decimal(26,6) DEFAULT NULL,
  subtotal_tax_amount_usdollar decimal(26,6) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aos_quotes_aos_invoices_c`
--

DROP TABLE IF EXISTS aos_quotes_aos_invoices_c;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aos_quotes_aos_invoices_c (
  id varchar(36) NOT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  aos_quotes77d9_quotes_ida varchar(36) DEFAULT NULL,
  aos_quotes6b83nvoices_idb varchar(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX aos_quotes_aos_invoices_alt ON aos_quotes_aos_invoices_c (aos_quotes77d9_quotes_ida,aos_quotes6b83nvoices_idb);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aos_quotes_audit`
--

DROP TABLE IF EXISTS aos_quotes_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aos_quotes_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_aos_quotes_parent_id ON aos_quotes_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aos_quotes_os_contracts_c`
--

DROP TABLE IF EXISTS aos_quotes_os_contracts_c;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aos_quotes_os_contracts_c (
  id varchar(36) NOT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  aos_quotese81e_quotes_ida varchar(36) DEFAULT NULL,
  aos_quotes4dc0ntracts_idb varchar(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX aos_quotes_aos_contracts_alt ON aos_quotes_os_contracts_c (aos_quotese81e_quotes_ida,aos_quotes4dc0ntracts_idb);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aos_quotes_project_c`
--

DROP TABLE IF EXISTS aos_quotes_project_c;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aos_quotes_project_c (
  id varchar(36) NOT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  aos_quotes1112_quotes_ida varchar(36) DEFAULT NULL,
  aos_quotes7207project_idb varchar(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX aos_quotes_project_alt ON aos_quotes_project_c (aos_quotes1112_quotes_ida,aos_quotes7207project_idb);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aow_actions`
--

DROP TABLE IF EXISTS aow_actions;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aow_actions (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  aow_workflow_id char(36) DEFAULT NULL,
  action_order int DEFAULT NULL,
  action varchar(100) DEFAULT NULL,
  parameters varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX aow_action_index_workflow_id ON aow_actions (aow_workflow_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aow_conditions`
--

DROP TABLE IF EXISTS aow_conditions;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aow_conditions (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  aow_workflow_id char(36) DEFAULT NULL,
  condition_order int DEFAULT NULL,
  module_path varchar(max) DEFAULT NULL,
  field varchar(100) DEFAULT NULL,
  operator varchar(100) DEFAULT NULL,
  value_type varchar(255) DEFAULT NULL,
  value varchar(255) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX aow_conditions_index_workflow_id ON aow_conditions (aow_workflow_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aow_processed`
--

DROP TABLE IF EXISTS aow_processed;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aow_processed (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  aow_workflow_id char(36) DEFAULT NULL,
  parent_id char(36) DEFAULT NULL,
  parent_type varchar(100) DEFAULT NULL,
  status varchar(100) DEFAULT 'Pending',
  PRIMARY KEY (id)
) ;

CREATE INDEX aow_processed_index_workflow ON aow_processed (aow_workflow_id,status,parent_id,deleted);
CREATE INDEX aow_processed_index_status ON aow_processed (status);
CREATE INDEX aow_processed_index_workflow_id ON aow_processed (aow_workflow_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aow_processed_aow_actions`
--

DROP TABLE IF EXISTS aow_processed_aow_actions;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aow_processed_aow_actions (
  id varchar(36) NOT NULL,
  aow_processed_id varchar(36) DEFAULT NULL,
  aow_action_id varchar(36) DEFAULT NULL,
  status varchar(36) DEFAULT 'Pending',
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_aow_processed_aow_actions ON aow_processed_aow_actions (aow_processed_id,aow_action_id);
CREATE INDEX idx_actid_del_freid ON aow_processed_aow_actions (aow_action_id,deleted,aow_processed_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aow_workflow`
--

DROP TABLE IF EXISTS aow_workflow;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aow_workflow (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  flow_module varchar(100) DEFAULT NULL,
  flow_run_on varchar(100) DEFAULT '0',
  status varchar(100) DEFAULT 'Active',
  run_when varchar(100) DEFAULT 'Always',
  multiple_runs smallint DEFAULT 0,
  run_on_import smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX aow_workflow_index_status ON aow_workflow (status);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `aow_workflow_audit`
--

DROP TABLE IF EXISTS aow_workflow_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE aow_workflow_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_aow_workflow_parent_id ON aow_workflow_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `bugs`
--

DROP TABLE IF EXISTS bugs;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE bugs (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  bug_number int NOT NULL IDENTITY,
  type varchar(255) DEFAULT NULL,
  status varchar(100) DEFAULT NULL,
  priority varchar(100) DEFAULT NULL,
  resolution varchar(255) DEFAULT NULL,
  work_log varchar(max) DEFAULT NULL,
  found_in_release varchar(255) DEFAULT NULL,
  fixed_in_release varchar(255) DEFAULT NULL,
  source varchar(255) DEFAULT NULL,
  product_category varchar(255) DEFAULT NULL,
  PRIMARY KEY (id),
  CONSTRAINT bugsnumk UNIQUE  (bug_number)
) ;

CREATE INDEX bug_number ON bugs (bug_number);
CREATE INDEX idx_bug_name ON bugs (name);
CREATE INDEX idx_bugs_assigned_user ON bugs (assigned_user_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `bugs_audit`
--

DROP TABLE IF EXISTS bugs_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE bugs_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_bugs_parent_id ON bugs_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `cache_rebuild`
--

DROP TABLE IF EXISTS cache_rebuild;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE cache_rebuild (
  cache_key varchar(255) DEFAULT NULL,
  rebuild smallint DEFAULT NULL
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `calls`
--

DROP TABLE IF EXISTS calls;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE calls (
  id char(36) NOT NULL,
  name varchar(50) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  duration_hours int DEFAULT NULL,
  duration_minutes int DEFAULT NULL,
  date_start datetime2(0) DEFAULT NULL,
  date_end datetime2(0) DEFAULT NULL,
  parent_type varchar(255) DEFAULT NULL,
  status varchar(100) DEFAULT 'Planned',
  direction varchar(100) DEFAULT NULL,
  parent_id char(36) DEFAULT NULL,
  reminder_time int DEFAULT -1,
  email_reminder_time int DEFAULT -1,
  email_reminder_sent smallint DEFAULT 0,
  outlook_id varchar(255) DEFAULT NULL,
  repeat_type varchar(36) DEFAULT NULL,
  repeat_interval int DEFAULT 1,
  repeat_dow varchar(7) DEFAULT NULL,
  repeat_until date DEFAULT NULL,
  repeat_count int DEFAULT NULL,
  repeat_parent_id char(36) DEFAULT NULL,
  recurring_source varchar(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_call_name ON calls (name);
CREATE INDEX idx_status ON calls (status);
CREATE INDEX idx_calls_date_start ON calls (date_start);
CREATE INDEX idx_calls_par_del ON calls (parent_id,parent_type,deleted);
CREATE INDEX idx_calls_assigned_del ON calls (deleted,assigned_user_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `calls_contacts`
--

DROP TABLE IF EXISTS calls_contacts;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE calls_contacts (
  id varchar(36) NOT NULL,
  call_id varchar(36) DEFAULT NULL,
  contact_id varchar(36) DEFAULT NULL,
  required varchar(1) DEFAULT '1',
  accept_status varchar(25) DEFAULT 'none',
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_con_call_call ON calls_contacts (call_id);
CREATE INDEX idx_con_call_con ON calls_contacts (contact_id);
CREATE INDEX idx_call_contact ON calls_contacts (call_id,contact_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `calls_leads`
--

DROP TABLE IF EXISTS calls_leads;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE calls_leads (
  id varchar(36) NOT NULL,
  call_id varchar(36) DEFAULT NULL,
  lead_id varchar(36) DEFAULT NULL,
  required varchar(1) DEFAULT '1',
  accept_status varchar(25) DEFAULT 'none',
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_lead_call_call ON calls_leads (call_id);
CREATE INDEX idx_lead_call_lead ON calls_leads (lead_id);
CREATE INDEX idx_call_lead ON calls_leads (call_id,lead_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `calls_reschedule`
--

DROP TABLE IF EXISTS calls_reschedule;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE calls_reschedule (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  reason varchar(100) DEFAULT NULL,
  call_id char(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `calls_reschedule_audit`
--

DROP TABLE IF EXISTS calls_reschedule_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE calls_reschedule_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_calls_reschedule_parent_id ON calls_reschedule_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `calls_users`
--

DROP TABLE IF EXISTS calls_users;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE calls_users (
  id varchar(36) NOT NULL,
  call_id varchar(36) DEFAULT NULL,
  user_id varchar(36) DEFAULT NULL,
  required varchar(1) DEFAULT '1',
  accept_status varchar(25) DEFAULT 'none',
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_usr_call_call ON calls_users (call_id);
CREATE INDEX idx_usr_call_usr ON calls_users (user_id);
CREATE INDEX idx_call_users ON calls_users (call_id,user_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `campaign_log`
--

DROP TABLE IF EXISTS campaign_log;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE campaign_log (
  id char(36) NOT NULL,
  campaign_id char(36) DEFAULT NULL,
  target_tracker_key varchar(36) DEFAULT NULL,
  target_id varchar(36) DEFAULT NULL,
  target_type varchar(100) DEFAULT NULL,
  activity_type varchar(100) DEFAULT NULL,
  activity_date datetime2(0) DEFAULT NULL,
  related_id varchar(36) DEFAULT NULL,
  related_type varchar(100) DEFAULT NULL,
  archived smallint DEFAULT 0,
  hits int DEFAULT 0,
  list_id char(36) DEFAULT NULL,
  deleted smallint DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  more_information varchar(100) DEFAULT NULL,
  marketing_id char(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_camp_tracker ON campaign_log (target_tracker_key);
CREATE INDEX idx_camp_campaign_id ON campaign_log (campaign_id);
CREATE INDEX idx_camp_more_info ON campaign_log (more_information);
CREATE INDEX idx_target_id ON campaign_log (target_id);
CREATE INDEX idx_target_id_deleted ON campaign_log (target_id,deleted);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `campaign_trkrs`
--

DROP TABLE IF EXISTS campaign_trkrs;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE campaign_trkrs (
  id char(36) NOT NULL,
  tracker_name varchar(255) DEFAULT NULL,
  tracker_url varchar(255) DEFAULT 'http://',
  tracker_key int NOT NULL IDENTITY,
  campaign_id char(36) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  is_optout smallint DEFAULT 0,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX campaign_tracker_key_idx ON campaign_trkrs (tracker_key);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `campaigns`
--

DROP TABLE IF EXISTS campaigns;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE campaigns (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  tracker_key int NOT NULL IDENTITY,
  tracker_count int DEFAULT 0,
  refer_url varchar(255) DEFAULT 'http://',
  tracker_text varchar(255) DEFAULT NULL,
  start_date date DEFAULT NULL,
  end_date date DEFAULT NULL,
  status varchar(100) DEFAULT NULL,
  impressions int DEFAULT 0,
  currency_id char(36) DEFAULT NULL,
  budget float DEFAULT NULL,
  expected_cost float DEFAULT NULL,
  actual_cost float DEFAULT NULL,
  expected_revenue float DEFAULT NULL,
  campaign_type varchar(100) DEFAULT NULL,
  objective varchar(max) DEFAULT NULL,
  content varchar(max) DEFAULT NULL,
  frequency varchar(100) DEFAULT NULL,
  survey_id char(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX camp_auto_tracker_key ON campaigns (tracker_key);
CREATE INDEX idx_campaign_name ON campaigns (name);
CREATE INDEX idx_survey_id ON campaigns (survey_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `campaigns_audit`
--

DROP TABLE IF EXISTS campaigns_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE campaigns_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_campaigns_parent_id ON campaigns_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `cases`
--

DROP TABLE IF EXISTS cases;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE cases (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  case_number int NOT NULL IDENTITY,
  type varchar(255) DEFAULT NULL,
  status varchar(100) DEFAULT NULL,
  priority varchar(100) DEFAULT NULL,
  resolution varchar(max) DEFAULT NULL,
  work_log varchar(max) DEFAULT NULL,
  account_id char(36) DEFAULT NULL,
  state varchar(100) DEFAULT 'Open',
  contact_created_by_id char(36) DEFAULT NULL,
  PRIMARY KEY (id),
  CONSTRAINT casesnumk UNIQUE  (case_number)
) ;

CREATE INDEX case_number ON cases (case_number);
CREATE INDEX idx_case_name ON cases (name);
CREATE INDEX idx_account_id ON cases (account_id);
CREATE INDEX idx_cases_stat_del ON cases (assigned_user_id,status,deleted);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `cases_audit`
--

DROP TABLE IF EXISTS cases_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE cases_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_cases_parent_id ON cases_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `cases_bugs`
--

DROP TABLE IF EXISTS cases_bugs;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE cases_bugs (
  id varchar(36) NOT NULL,
  case_id varchar(36) DEFAULT NULL,
  bug_id varchar(36) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_cas_bug_cas ON cases_bugs (case_id);
CREATE INDEX idx_cas_bug_bug ON cases_bugs (bug_id);
CREATE INDEX idx_case_bug ON cases_bugs (case_id,bug_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `cases_cstm`
--

DROP TABLE IF EXISTS cases_cstm;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE cases_cstm (
  id_c char(36) NOT NULL,
  jjwg_maps_lng_c float DEFAULT 0.00000000,
  jjwg_maps_lat_c float DEFAULT 0.00000000,
  jjwg_maps_geocode_status_c varchar(255) DEFAULT NULL,
  jjwg_maps_address_c varchar(255) DEFAULT NULL,
  PRIMARY KEY (id_c)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `config`
--

DROP TABLE IF EXISTS config;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE config (
  category varchar(32) DEFAULT NULL,
  name varchar(32) DEFAULT NULL,
  value varchar(max) DEFAULT NULL
) ;

CREATE INDEX idx_config_cat ON config (category);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `contacts`
--

DROP TABLE IF EXISTS contacts;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE contacts (
  id char(36) NOT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  salutation varchar(255) DEFAULT NULL,
  first_name varchar(100) DEFAULT NULL,
  last_name varchar(100) DEFAULT NULL,
  title varchar(100) DEFAULT NULL,
  photo varchar(255) DEFAULT NULL,
  department varchar(255) DEFAULT NULL,
  do_not_call smallint DEFAULT 0,
  phone_home varchar(100) DEFAULT NULL,
  phone_mobile varchar(100) DEFAULT NULL,
  phone_work varchar(100) DEFAULT NULL,
  phone_other varchar(100) DEFAULT NULL,
  phone_fax varchar(100) DEFAULT NULL,
  lawful_basis varchar(max) DEFAULT NULL,
  date_reviewed date DEFAULT NULL,
  lawful_basis_source varchar(100) DEFAULT NULL,
  primary_address_street varchar(150) DEFAULT NULL,
  primary_address_city varchar(100) DEFAULT NULL,
  primary_address_state varchar(100) DEFAULT NULL,
  primary_address_postalcode varchar(20) DEFAULT NULL,
  primary_address_country varchar(255) DEFAULT NULL,
  alt_address_street varchar(150) DEFAULT NULL,
  alt_address_city varchar(100) DEFAULT NULL,
  alt_address_state varchar(100) DEFAULT NULL,
  alt_address_postalcode varchar(20) DEFAULT NULL,
  alt_address_country varchar(255) DEFAULT NULL,
  assistant varchar(75) DEFAULT NULL,
  assistant_phone varchar(100) DEFAULT NULL,
  lead_source varchar(255) DEFAULT NULL,
  reports_to_id char(36) DEFAULT NULL,
  birthdate date DEFAULT NULL,
  campaign_id char(36) DEFAULT NULL,
  joomla_account_id varchar(255) DEFAULT NULL,
  portal_account_disabled smallint DEFAULT NULL,
  portal_user_type varchar(100) DEFAULT 'Single',
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_cont_last_first ON contacts (last_name,first_name,deleted);
CREATE INDEX idx_contacts_del_last ON contacts (deleted,last_name);
CREATE INDEX idx_cont_del_reports ON contacts (deleted,reports_to_id,last_name);
CREATE INDEX idx_reports_to_id ON contacts (reports_to_id);
CREATE INDEX idx_del_id_user ON contacts (deleted,id,assigned_user_id);
CREATE INDEX idx_cont_assigned ON contacts (assigned_user_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `contacts_audit`
--

DROP TABLE IF EXISTS contacts_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE contacts_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_contacts_parent_id ON contacts_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `contacts_bugs`
--

DROP TABLE IF EXISTS contacts_bugs;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE contacts_bugs (
  id varchar(36) NOT NULL,
  contact_id varchar(36) DEFAULT NULL,
  bug_id varchar(36) DEFAULT NULL,
  contact_role varchar(50) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_con_bug_con ON contacts_bugs (contact_id);
CREATE INDEX idx_con_bug_bug ON contacts_bugs (bug_id);
CREATE INDEX idx_contact_bug ON contacts_bugs (contact_id,bug_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `contacts_cases`
--

DROP TABLE IF EXISTS contacts_cases;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE contacts_cases (
  id varchar(36) NOT NULL,
  contact_id varchar(36) DEFAULT NULL,
  case_id varchar(36) DEFAULT NULL,
  contact_role varchar(50) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_con_case_con ON contacts_cases (contact_id);
CREATE INDEX idx_con_case_case ON contacts_cases (case_id);
CREATE INDEX idx_contacts_cases ON contacts_cases (contact_id,case_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `contacts_cstm`
--

DROP TABLE IF EXISTS contacts_cstm;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE contacts_cstm (
  id_c char(36) NOT NULL,
  jjwg_maps_lng_c float DEFAULT 0.00000000,
  jjwg_maps_lat_c float DEFAULT 0.00000000,
  jjwg_maps_geocode_status_c varchar(255) DEFAULT NULL,
  jjwg_maps_address_c varchar(255) DEFAULT NULL,
  PRIMARY KEY (id_c)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `contacts_users`
--

DROP TABLE IF EXISTS contacts_users;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE contacts_users (
  id varchar(36) NOT NULL,
  contact_id varchar(36) DEFAULT NULL,
  user_id varchar(36) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_con_users_con ON contacts_users (contact_id);
CREATE INDEX idx_con_users_user ON contacts_users (user_id);
CREATE INDEX idx_contacts_users ON contacts_users (contact_id,user_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `cron_remove_documents`
--

DROP TABLE IF EXISTS cron_remove_documents;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE cron_remove_documents (
  id varchar(36) NOT NULL,
  bean_id varchar(36) DEFAULT NULL,
  module varchar(25) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_cron_remove_document_bean_id ON cron_remove_documents (bean_id);
CREATE INDEX idx_cron_remove_document_stamp ON cron_remove_documents (date_modified);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `currencies`
--

DROP TABLE IF EXISTS currencies;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE currencies (
  id char(36) NOT NULL,
  name varchar(36) DEFAULT NULL,
  symbol varchar(36) DEFAULT NULL,
  iso4217 varchar(3) DEFAULT NULL,
  conversion_rate float DEFAULT 0,
  status varchar(100) DEFAULT NULL,
  deleted smallint DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  created_by char(36) NOT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_currency_name ON currencies (name,deleted);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `custom_fields`
--

DROP TABLE IF EXISTS custom_fields;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE custom_fields (
  bean_id varchar(36) DEFAULT NULL,
  set_num int DEFAULT 0,
  field0 varchar(255) DEFAULT NULL,
  field1 varchar(255) DEFAULT NULL,
  field2 varchar(255) DEFAULT NULL,
  field3 varchar(255) DEFAULT NULL,
  field4 varchar(255) DEFAULT NULL,
  field5 varchar(255) DEFAULT NULL,
  field6 varchar(255) DEFAULT NULL,
  field7 varchar(255) DEFAULT NULL,
  field8 varchar(255) DEFAULT NULL,
  field9 varchar(255) DEFAULT NULL,
  deleted smallint DEFAULT 0
) ;

CREATE INDEX idx_beanid_set_num ON custom_fields (bean_id,set_num);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `document_revisions`
--

DROP TABLE IF EXISTS document_revisions;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE document_revisions (
  id varchar(36) NOT NULL,
  change_log varchar(255) DEFAULT NULL,
  document_id varchar(36) DEFAULT NULL,
  doc_id varchar(100) DEFAULT NULL,
  doc_type varchar(100) DEFAULT NULL,
  doc_url varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  filename varchar(255) DEFAULT NULL,
  file_ext varchar(100) DEFAULT NULL,
  file_mime_type varchar(100) DEFAULT NULL,
  revision varchar(100) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  date_modified datetime2(0) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX documentrevision_mimetype ON document_revisions (file_mime_type);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `documents`
--

DROP TABLE IF EXISTS documents;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE documents (
  id char(36) NOT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  document_name varchar(255) DEFAULT NULL,
  doc_id varchar(100) DEFAULT NULL,
  doc_type varchar(100) DEFAULT 'Sugar',
  doc_url varchar(255) DEFAULT NULL,
  active_date date DEFAULT NULL,
  exp_date date DEFAULT NULL,
  category_id varchar(100) DEFAULT NULL,
  subcategory_id varchar(100) DEFAULT NULL,
  status_id varchar(100) DEFAULT NULL,
  document_revision_id varchar(36) DEFAULT NULL,
  related_doc_id char(36) DEFAULT NULL,
  related_doc_rev_id char(36) DEFAULT NULL,
  is_template smallint DEFAULT 0,
  template_type varchar(100) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_doc_cat ON documents (category_id,subcategory_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `documents_accounts`
--

DROP TABLE IF EXISTS documents_accounts;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE documents_accounts (
  id varchar(36) NOT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  document_id varchar(36) DEFAULT NULL,
  account_id varchar(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX documents_accounts_account_id ON documents_accounts (account_id,document_id);
CREATE INDEX documents_accounts_document_id ON documents_accounts (document_id,account_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `documents_bugs`
--

DROP TABLE IF EXISTS documents_bugs;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE documents_bugs (
  id varchar(36) NOT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  document_id varchar(36) DEFAULT NULL,
  bug_id varchar(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX documents_bugs_bug_id ON documents_bugs (bug_id,document_id);
CREATE INDEX documents_bugs_document_id ON documents_bugs (document_id,bug_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `documents_cases`
--

DROP TABLE IF EXISTS documents_cases;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE documents_cases (
  id varchar(36) NOT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  document_id varchar(36) DEFAULT NULL,
  case_id varchar(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX documents_cases_case_id ON documents_cases (case_id,document_id);
CREATE INDEX documents_cases_document_id ON documents_cases (document_id,case_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `documents_contacts`
--

DROP TABLE IF EXISTS documents_contacts;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE documents_contacts (
  id varchar(36) NOT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  document_id varchar(36) DEFAULT NULL,
  contact_id varchar(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX documents_contacts_contact_id ON documents_contacts (contact_id,document_id);
CREATE INDEX documents_contacts_document_id ON documents_contacts (document_id,contact_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `documents_opportunities`
--

DROP TABLE IF EXISTS documents_opportunities;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE documents_opportunities (
  id varchar(36) NOT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  document_id varchar(36) DEFAULT NULL,
  opportunity_id varchar(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_docu_opps_oppo_id ON documents_opportunities (opportunity_id,document_id);
CREATE INDEX idx_docu_oppo_docu_id ON documents_opportunities (document_id,opportunity_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `eapm`
--

DROP TABLE IF EXISTS eapm;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE eapm (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  password varchar(255) DEFAULT NULL,
  url varchar(255) DEFAULT NULL,
  application varchar(100) DEFAULT 'webex',
  api_data varchar(max) DEFAULT NULL,
  consumer_key varchar(255) DEFAULT NULL,
  consumer_secret varchar(255) DEFAULT NULL,
  oauth_token varchar(255) DEFAULT NULL,
  oauth_secret varchar(255) DEFAULT NULL,
  validated smallint DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_app_active ON eapm (assigned_user_id,application,validated);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `email_addr_bean_rel`
--

DROP TABLE IF EXISTS email_addr_bean_rel;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE email_addr_bean_rel (
  id char(36) NOT NULL,
  email_address_id char(36) NOT NULL,
  bean_id char(36) NOT NULL,
  bean_module varchar(100) DEFAULT NULL,
  primary_address smallint DEFAULT 0,
  reply_to_address smallint DEFAULT 0,
  date_created datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_email_address_id ON email_addr_bean_rel (email_address_id);
CREATE INDEX idx_bean_id ON email_addr_bean_rel (bean_id,bean_module);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `email_addresses`
--

DROP TABLE IF EXISTS email_addresses;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE email_addresses (
  id char(36) NOT NULL,
  email_address varchar(255) DEFAULT NULL,
  email_address_caps varchar(255) DEFAULT NULL,
  invalid_email smallint DEFAULT 0,
  opt_out smallint DEFAULT 0,
  confirm_opt_in varchar(255) DEFAULT 'not-opt-in',
  confirm_opt_in_date datetime2(0) DEFAULT NULL,
  confirm_opt_in_sent_date datetime2(0) DEFAULT NULL,
  confirm_opt_in_fail_date datetime2(0) DEFAULT NULL,
  confirm_opt_in_token varchar(255) DEFAULT NULL,
  date_created datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_ea_caps_opt_out_invalid ON email_addresses (email_address_caps,opt_out,invalid_email);
CREATE INDEX idx_ea_opt_out_invalid ON email_addresses (email_address,opt_out,invalid_email);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `email_addresses_audit`
--

DROP TABLE IF EXISTS email_addresses_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE email_addresses_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_email_addresses_parent_id ON email_addresses_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `email_cache`
--

DROP TABLE IF EXISTS email_cache;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE email_cache (
  ie_id char(36) DEFAULT NULL,
  mbox varchar(60) DEFAULT NULL,
  subject varchar(255) DEFAULT NULL,
  fromaddr varchar(100) DEFAULT NULL,
  toaddr varchar(255) DEFAULT NULL,
  senddate datetime2(0) DEFAULT NULL,
  message_id varchar(255) DEFAULT NULL,
  mailsize int check (mailsize > 0) DEFAULT NULL,
  imap_uid int check (imap_uid > 0) DEFAULT NULL,
  msgno int check (msgno > 0) DEFAULT NULL,
  recent smallint DEFAULT NULL,
  flagged smallint DEFAULT NULL,
  answered smallint DEFAULT NULL,
  deleted smallint DEFAULT NULL,
  seen smallint DEFAULT NULL,
  draft smallint DEFAULT NULL
) ;

CREATE INDEX idx_ie_id ON email_cache (ie_id);
CREATE INDEX idx_mail_date ON email_cache (ie_id,mbox,senddate);
CREATE INDEX idx_mail_from ON email_cache (ie_id,mbox,fromaddr);
CREATE INDEX idx_mail_subj ON email_cache (subject);
CREATE INDEX idx_mail_to ON email_cache (toaddr);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `email_marketing`
--

DROP TABLE IF EXISTS email_marketing;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE email_marketing (
  id char(36) NOT NULL,
  deleted smallint DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  name varchar(255) DEFAULT NULL,
  from_name varchar(100) DEFAULT NULL,
  from_addr varchar(100) DEFAULT NULL,
  reply_to_name varchar(100) DEFAULT NULL,
  reply_to_addr varchar(100) DEFAULT NULL,
  inbound_email_id varchar(36) DEFAULT NULL,
  date_start datetime2(0) DEFAULT NULL,
  template_id char(36) NOT NULL,
  status varchar(100) DEFAULT NULL,
  campaign_id char(36) DEFAULT NULL,
  outbound_email_id char(36) DEFAULT NULL,
  all_prospect_lists smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_emmkt_name ON email_marketing (name);
CREATE INDEX idx_emmkit_del ON email_marketing (deleted);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `email_marketing_prospect_lists`
--

DROP TABLE IF EXISTS email_marketing_prospect_lists;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE email_marketing_prospect_lists (
  id varchar(36) NOT NULL,
  prospect_list_id varchar(36) DEFAULT NULL,
  email_marketing_id varchar(36) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX email_mp_prospects ON email_marketing_prospect_lists (email_marketing_id,prospect_list_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `email_templates`
--

DROP TABLE IF EXISTS email_templates;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE email_templates (
  id char(36) NOT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  published varchar(3) DEFAULT NULL,
  name varchar(255) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  subject varchar(255) DEFAULT NULL,
  body varchar(max) DEFAULT NULL,
  body_html varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT NULL,
  assigned_user_id char(36) DEFAULT NULL,
  text_only smallint DEFAULT NULL,
  type varchar(255) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_email_template_name ON email_templates (name);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `emailman`
--

DROP TABLE IF EXISTS emailman;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE emailman (
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  user_id char(36) DEFAULT NULL,
  id int NOT NULL IDENTITY,
  campaign_id char(36) DEFAULT NULL,
  marketing_id char(36) DEFAULT NULL,
  list_id char(36) DEFAULT NULL,
  send_date_time datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  in_queue smallint DEFAULT 0,
  in_queue_date datetime2(0) DEFAULT NULL,
  send_attempts int DEFAULT 0,
  deleted smallint DEFAULT 0,
  related_id char(36) DEFAULT NULL,
  related_type varchar(100) DEFAULT NULL,
  related_confirm_opt_in smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_eman_list ON emailman (list_id,user_id,deleted);
CREATE INDEX idx_eman_campaign_id ON emailman (campaign_id);
CREATE INDEX idx_eman_relid_reltype_id ON emailman (related_id,related_type,campaign_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `emails`
--

DROP TABLE IF EXISTS emails;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE emails (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  orphaned smallint DEFAULT NULL,
  last_synced datetime2(0) DEFAULT NULL,
  date_sent_received datetime2(0) DEFAULT NULL,
  message_id varchar(255) DEFAULT NULL,
  type varchar(100) DEFAULT NULL,
  status varchar(100) DEFAULT NULL,
  flagged smallint DEFAULT NULL,
  reply_to_status smallint DEFAULT NULL,
  intent varchar(100) DEFAULT 'pick',
  mailbox_id char(36) DEFAULT NULL,
  parent_type varchar(100) DEFAULT NULL,
  parent_id char(36) DEFAULT NULL,
  uid varchar(255) DEFAULT NULL,
  category_id varchar(100) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_email_name ON emails (name);
CREATE INDEX idx_message_id ON emails (message_id);
CREATE INDEX idx_email_parent_id ON emails (parent_id);
CREATE INDEX idx_email_assigned ON emails (assigned_user_id,type,status);
CREATE INDEX idx_email_cat ON emails (category_id);
CREATE INDEX idx_email_uid ON emails (uid);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `emails_beans`
--

DROP TABLE IF EXISTS emails_beans;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE emails_beans (
  id char(36) NOT NULL,
  email_id char(36) DEFAULT NULL,
  bean_id char(36) DEFAULT NULL,
  bean_module varchar(100) DEFAULT NULL,
  campaign_data varchar(max) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_emails_beans_bean_id ON emails_beans (bean_id);
CREATE INDEX idx_emails_beans_email_bean ON emails_beans (email_id,bean_id,deleted);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `emails_email_addr_rel`
--

DROP TABLE IF EXISTS emails_email_addr_rel;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE emails_email_addr_rel (
  id char(36) NOT NULL,
  email_id char(36) NOT NULL,
  address_type varchar(4) DEFAULT NULL,
  email_address_id char(36) NOT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_eearl_email_id ON emails_email_addr_rel (email_id,address_type);
CREATE INDEX idx_eearl_address_id ON emails_email_addr_rel (email_address_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `emails_text`
--

DROP TABLE IF EXISTS emails_text;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE emails_text (
  email_id char(36) NOT NULL,
  from_addr varchar(255) DEFAULT NULL,
  reply_to_addr varchar(255) DEFAULT NULL,
  to_addrs varchar(max) DEFAULT NULL,
  cc_addrs varchar(max) DEFAULT NULL,
  bcc_addrs varchar(max) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  description_html varchar(max) DEFAULT NULL,
  raw_source varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (email_id)
) ;

CREATE INDEX emails_textfromaddr ON emails_text (from_addr);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `external_oauth_connections`
--

DROP TABLE IF EXISTS external_oauth_connections;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE external_oauth_connections (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  type varchar(255) DEFAULT NULL,
  client_id varchar(32) DEFAULT NULL,
  client_secret varchar(32) DEFAULT NULL,
  token_type varchar(32) DEFAULT NULL,
  expires_in varchar(32) DEFAULT NULL,
  access_token varchar(max) DEFAULT NULL,
  refresh_token varchar(max) DEFAULT NULL,
  external_oauth_provider_id char(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `external_oauth_providers`
--

DROP TABLE IF EXISTS external_oauth_providers;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE external_oauth_providers (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  type varchar(255) DEFAULT NULL,
  connector varchar(255) DEFAULT NULL,
  client_id varchar(255) DEFAULT NULL,
  client_secret varchar(255) DEFAULT NULL,
  scope varchar(max) DEFAULT NULL,
  url_authorize varchar(255) DEFAULT NULL,
  authorize_url_options varchar(max) DEFAULT NULL,
  url_access_token varchar(255) DEFAULT NULL,
  extra_provider_params varchar(max) DEFAULT NULL,
  get_token_request_grant varchar(255) DEFAULT 'authorization_code',
  get_token_request_options varchar(max) DEFAULT NULL,
  refresh_token_request_grant varchar(255) DEFAULT 'refresh_token',
  refresh_token_request_options varchar(max) DEFAULT NULL,
  access_token_mapping varchar(255) DEFAULT 'access_token',
  expires_in_mapping varchar(255) DEFAULT 'expires_in',
  refresh_token_mapping varchar(255) DEFAULT 'refresh_token',
  token_type_mapping varchar(255) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `favorites`
--

DROP TABLE IF EXISTS favorites;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE favorites (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  parent_id char(36) DEFAULT NULL,
  parent_type varchar(255) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `fields_meta_data`
--

DROP TABLE IF EXISTS fields_meta_data;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE fields_meta_data (
  id varchar(255) NOT NULL,
  name varchar(255) DEFAULT NULL,
  vname varchar(255) DEFAULT NULL,
  comments varchar(255) DEFAULT NULL,
  help varchar(255) DEFAULT NULL,
  custom_module varchar(255) DEFAULT NULL,
  type varchar(255) DEFAULT NULL,
  len int DEFAULT NULL,
  required smallint DEFAULT 0,
  default_value varchar(255) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  audited smallint DEFAULT 0,
  massupdate smallint DEFAULT 0,
  duplicate_merge smallint DEFAULT 0,
  reportable smallint DEFAULT 1,
  importable varchar(255) DEFAULT NULL,
  ext1 varchar(255) DEFAULT NULL,
  ext2 varchar(255) DEFAULT NULL,
  ext3 varchar(255) DEFAULT NULL,
  ext4 varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_meta_id_del ON fields_meta_data (id,deleted);
CREATE INDEX idx_meta_cm_del ON fields_meta_data (custom_module,deleted);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `folders`
--

DROP TABLE IF EXISTS folders;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE folders (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  folder_type varchar(25) DEFAULT NULL,
  parent_folder char(36) DEFAULT NULL,
  has_child smallint DEFAULT 0,
  is_group smallint DEFAULT 0,
  is_dynamic smallint DEFAULT 0,
  dynamic_query varchar(max) DEFAULT NULL,
  assign_to_id char(36) DEFAULT NULL,
  created_by char(36) NOT NULL,
  modified_by char(36) NOT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_parent_folder ON folders (parent_folder);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `folders_rel`
--

DROP TABLE IF EXISTS folders_rel;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE folders_rel (
  id char(36) NOT NULL,
  folder_id char(36) NOT NULL,
  polymorphic_module varchar(25) DEFAULT NULL,
  polymorphic_id char(36) NOT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_poly_module_poly_id ON folders_rel (polymorphic_module,polymorphic_id);
CREATE INDEX idx_fr_id_deleted_poly ON folders_rel (folder_id,deleted,polymorphic_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `folders_subscriptions`
--

DROP TABLE IF EXISTS folders_subscriptions;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE folders_subscriptions (
  id char(36) NOT NULL,
  folder_id char(36) NOT NULL,
  assigned_user_id char(36) NOT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_folder_id_assigned_user_id ON folders_subscriptions (folder_id,assigned_user_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `fp_event_locations`
--

DROP TABLE IF EXISTS fp_event_locations;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE fp_event_locations (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  address varchar(255) DEFAULT NULL,
  address_city varchar(100) DEFAULT NULL,
  address_country varchar(100) DEFAULT NULL,
  address_postalcode varchar(20) DEFAULT NULL,
  address_state varchar(100) DEFAULT NULL,
  capacity varchar(255) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `fp_event_locations_audit`
--

DROP TABLE IF EXISTS fp_event_locations_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE fp_event_locations_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_fp_event_locations_parent_id ON fp_event_locations_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `fp_event_locations_fp_events_1_c`
--

DROP TABLE IF EXISTS fp_event_locations_fp_events_1_c;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE fp_event_locations_fp_events_1_c (
  id varchar(36) NOT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  fp_event_locations_fp_events_1fp_event_locations_ida varchar(36) DEFAULT NULL,
  fp_event_locations_fp_events_1fp_events_idb varchar(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX fp_event_locations_fp_events_1_ida1 ON fp_event_locations_fp_events_1_c (fp_event_locations_fp_events_1fp_event_locations_ida);
CREATE INDEX fp_event_locations_fp_events_1_alt ON fp_event_locations_fp_events_1_c (fp_event_locations_fp_events_1fp_events_idb);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `fp_events`
--

DROP TABLE IF EXISTS fp_events;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE fp_events (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  duration_hours int DEFAULT NULL,
  duration_minutes int DEFAULT NULL,
  date_start datetime2(0) DEFAULT NULL,
  date_end datetime2(0) DEFAULT NULL,
  budget decimal(26,6) DEFAULT NULL,
  currency_id char(36) DEFAULT NULL,
  invite_templates varchar(100) DEFAULT NULL,
  accept_redirect varchar(255) DEFAULT NULL,
  decline_redirect varchar(255) DEFAULT NULL,
  activity_status_type varchar(255) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `fp_events_audit`
--

DROP TABLE IF EXISTS fp_events_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE fp_events_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_fp_events_parent_id ON fp_events_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `fp_events_contacts_c`
--

DROP TABLE IF EXISTS fp_events_contacts_c;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE fp_events_contacts_c (
  id varchar(36) NOT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  fp_events_contactsfp_events_ida varchar(36) DEFAULT NULL,
  fp_events_contactscontacts_idb varchar(36) DEFAULT NULL,
  invite_status varchar(25) DEFAULT 'Not Invited',
  accept_status varchar(25) DEFAULT 'No Response',
  email_responded int DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX fp_events_contacts_alt ON fp_events_contacts_c (fp_events_contactsfp_events_ida,fp_events_contactscontacts_idb);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `fp_events_fp_event_delegates_1_c`
--

DROP TABLE IF EXISTS fp_events_fp_event_delegates_1_c;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE fp_events_fp_event_delegates_1_c (
  id varchar(36) NOT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  fp_events_fp_event_delegates_1fp_events_ida varchar(36) DEFAULT NULL,
  fp_events_fp_event_delegates_1fp_event_delegates_idb varchar(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX fp_events_fp_event_delegates_1_ida1 ON fp_events_fp_event_delegates_1_c (fp_events_fp_event_delegates_1fp_events_ida);
CREATE INDEX fp_events_fp_event_delegates_1_alt ON fp_events_fp_event_delegates_1_c (fp_events_fp_event_delegates_1fp_event_delegates_idb);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `fp_events_fp_event_locations_1_c`
--

DROP TABLE IF EXISTS fp_events_fp_event_locations_1_c;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE fp_events_fp_event_locations_1_c (
  id varchar(36) NOT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  fp_events_fp_event_locations_1fp_events_ida varchar(36) DEFAULT NULL,
  fp_events_fp_event_locations_1fp_event_locations_idb varchar(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX fp_events_fp_event_locations_1_alt ON fp_events_fp_event_locations_1_c (fp_events_fp_event_locations_1fp_events_ida,fp_events_fp_event_locations_1fp_event_locations_idb);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `fp_events_leads_1_c`
--

DROP TABLE IF EXISTS fp_events_leads_1_c;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE fp_events_leads_1_c (
  id varchar(36) NOT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  fp_events_leads_1fp_events_ida varchar(36) DEFAULT NULL,
  fp_events_leads_1leads_idb varchar(36) DEFAULT NULL,
  invite_status varchar(25) DEFAULT 'Not Invited',
  accept_status varchar(25) DEFAULT 'No Response',
  email_responded int DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX fp_events_leads_1_alt ON fp_events_leads_1_c (fp_events_leads_1fp_events_ida,fp_events_leads_1leads_idb);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `fp_events_prospects_1_c`
--

DROP TABLE IF EXISTS fp_events_prospects_1_c;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE fp_events_prospects_1_c (
  id varchar(36) NOT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  fp_events_prospects_1fp_events_ida varchar(36) DEFAULT NULL,
  fp_events_prospects_1prospects_idb varchar(36) DEFAULT NULL,
  invite_status varchar(25) DEFAULT 'Not Invited',
  accept_status varchar(25) DEFAULT 'No Response',
  email_responded int DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX fp_events_prospects_1_alt ON fp_events_prospects_1_c (fp_events_prospects_1fp_events_ida,fp_events_prospects_1prospects_idb);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `import_maps`
--

DROP TABLE IF EXISTS import_maps;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE import_maps (
  id char(36) NOT NULL,
  name varchar(254) DEFAULT NULL,
  source varchar(36) DEFAULT NULL,
  enclosure varchar(1) DEFAULT ' ',
  delimiter varchar(1) DEFAULT ',',
  module varchar(36) DEFAULT NULL,
  content varchar(max) DEFAULT NULL,
  default_values varchar(max) DEFAULT NULL,
  has_header smallint DEFAULT 1,
  deleted smallint DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  assigned_user_id char(36) DEFAULT NULL,
  is_published varchar(3) DEFAULT 'no',
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_owner_module_name ON import_maps (assigned_user_id,module,name,deleted);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `inbound_email`
--

DROP TABLE IF EXISTS inbound_email;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE inbound_email (
  id varchar(36) NOT NULL,
  deleted smallint DEFAULT 0,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  name varchar(255) DEFAULT NULL,
  status varchar(100) DEFAULT 'Active',
  email_body_filtering varchar(255) DEFAULT 'multi',
  server_url varchar(100) DEFAULT NULL,
  connection_string varchar(255) DEFAULT NULL,
  email_user varchar(100) DEFAULT NULL,
  email_password varchar(100) DEFAULT NULL,
  port int DEFAULT 143,
  service varchar(50) DEFAULT NULL,
  mailbox varchar(max) DEFAULT NULL,
  sentFolder varchar(255) DEFAULT NULL,
  trashFolder varchar(255) DEFAULT NULL,
  delete_seen smallint DEFAULT 0,
  move_messages_to_trash_after_import smallint DEFAULT 0,
  mailbox_type varchar(10) DEFAULT NULL,
  template_id char(36) DEFAULT NULL,
  stored_options varchar(max) DEFAULT NULL,
  group_id char(36) DEFAULT NULL,
  is_personal smallint DEFAULT 0,
  groupfolder_id char(36) DEFAULT NULL,
  type varchar(255) DEFAULT NULL,
  auth_type varchar(255) DEFAULT 'basic',
  protocol varchar(255) DEFAULT 'imap',
  is_ssl smallint DEFAULT 0,
  distribution_user_id char(36) DEFAULT NULL,
  outbound_email_id char(36) DEFAULT NULL,
  create_case_template_id char(36) DEFAULT NULL,
  external_oauth_connection_id char(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `inbound_email_autoreply`
--

DROP TABLE IF EXISTS inbound_email_autoreply;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE inbound_email_autoreply (
  id char(36) NOT NULL,
  deleted smallint DEFAULT 0,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  autoreplied_to varchar(100) DEFAULT NULL,
  ie_id char(36) NOT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_ie_autoreplied_to ON inbound_email_autoreply (autoreplied_to);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `inbound_email_cache_ts`
--

DROP TABLE IF EXISTS inbound_email_cache_ts;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE inbound_email_cache_ts (
  id varchar(255) NOT NULL,
  ie_timestamp int check (ie_timestamp > 0) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `jjwg_address_cache`
--

DROP TABLE IF EXISTS jjwg_address_cache;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE jjwg_address_cache (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  lat float DEFAULT NULL,
  lng float DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `jjwg_address_cache_audit`
--

DROP TABLE IF EXISTS jjwg_address_cache_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE jjwg_address_cache_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_jjwg_address_cache_parent_id ON jjwg_address_cache_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `jjwg_areas`
--

DROP TABLE IF EXISTS jjwg_areas;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE jjwg_areas (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  city varchar(255) DEFAULT NULL,
  state varchar(255) DEFAULT NULL,
  country varchar(255) DEFAULT NULL,
  coordinates varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `jjwg_areas_audit`
--

DROP TABLE IF EXISTS jjwg_areas_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE jjwg_areas_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_jjwg_areas_parent_id ON jjwg_areas_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `jjwg_maps`
--

DROP TABLE IF EXISTS jjwg_maps;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE jjwg_maps (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  distance float DEFAULT NULL,
  unit_type varchar(100) DEFAULT 'mi',
  module_type varchar(100) DEFAULT 'Accounts',
  parent_type varchar(255) DEFAULT NULL,
  parent_id char(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `jjwg_maps_audit`
--

DROP TABLE IF EXISTS jjwg_maps_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE jjwg_maps_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_jjwg_maps_parent_id ON jjwg_maps_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `jjwg_maps_jjwg_areas_c`
--

DROP TABLE IF EXISTS jjwg_maps_jjwg_areas_c;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE jjwg_maps_jjwg_areas_c (
  id varchar(36) NOT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  jjwg_maps_5304wg_maps_ida varchar(36) DEFAULT NULL,
  jjwg_maps_41f2g_areas_idb varchar(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX jjwg_maps_jjwg_areas_alt ON jjwg_maps_jjwg_areas_c (jjwg_maps_5304wg_maps_ida,jjwg_maps_41f2g_areas_idb);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `jjwg_maps_jjwg_markers_c`
--

DROP TABLE IF EXISTS jjwg_maps_jjwg_markers_c;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE jjwg_maps_jjwg_markers_c (
  id varchar(36) NOT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  jjwg_maps_b229wg_maps_ida varchar(36) DEFAULT NULL,
  jjwg_maps_2e31markers_idb varchar(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX jjwg_maps_jjwg_markers_alt ON jjwg_maps_jjwg_markers_c (jjwg_maps_b229wg_maps_ida,jjwg_maps_2e31markers_idb);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `jjwg_markers`
--

DROP TABLE IF EXISTS jjwg_markers;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE jjwg_markers (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  city varchar(255) DEFAULT NULL,
  state varchar(255) DEFAULT NULL,
  country varchar(255) DEFAULT NULL,
  jjwg_maps_lat float DEFAULT 0.00000000,
  jjwg_maps_lng float DEFAULT 0.00000000,
  marker_image varchar(100) DEFAULT 'company',
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `jjwg_markers_audit`
--

DROP TABLE IF EXISTS jjwg_markers_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE jjwg_markers_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_jjwg_markers_parent_id ON jjwg_markers_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `job_queue`
--

DROP TABLE IF EXISTS job_queue;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE job_queue (
  assigned_user_id char(36) DEFAULT NULL,
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  scheduler_id char(36) DEFAULT NULL,
  execute_time datetime2(0) DEFAULT NULL,
  status varchar(20) DEFAULT NULL,
  resolution varchar(20) DEFAULT NULL,
  message varchar(max) DEFAULT NULL,
  target varchar(255) DEFAULT NULL,
  data varchar(max) DEFAULT NULL,
  requeue smallint DEFAULT 0,
  retry_count smallint DEFAULT NULL,
  failure_count smallint DEFAULT NULL,
  job_delay int DEFAULT NULL,
  client varchar(255) DEFAULT NULL,
  percent_complete int DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_status_scheduler ON job_queue (status,scheduler_id);
CREATE INDEX idx_status_time ON job_queue (status,execute_time,date_entered);
CREATE INDEX idx_status_entered ON job_queue (status,date_entered);
CREATE INDEX idx_status_modified ON job_queue (status,date_modified);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `leads`
--

DROP TABLE IF EXISTS leads;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE leads (
  id char(36) NOT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  salutation varchar(255) DEFAULT NULL,
  first_name varchar(100) DEFAULT NULL,
  last_name varchar(100) DEFAULT NULL,
  title varchar(100) DEFAULT NULL,
  photo varchar(255) DEFAULT NULL,
  department varchar(100) DEFAULT NULL,
  do_not_call smallint DEFAULT 0,
  phone_home varchar(100) DEFAULT NULL,
  phone_mobile varchar(100) DEFAULT NULL,
  phone_work varchar(100) DEFAULT NULL,
  phone_other varchar(100) DEFAULT NULL,
  phone_fax varchar(100) DEFAULT NULL,
  lawful_basis varchar(max) DEFAULT NULL,
  date_reviewed date DEFAULT NULL,
  lawful_basis_source varchar(100) DEFAULT NULL,
  primary_address_street varchar(150) DEFAULT NULL,
  primary_address_city varchar(100) DEFAULT NULL,
  primary_address_state varchar(100) DEFAULT NULL,
  primary_address_postalcode varchar(20) DEFAULT NULL,
  primary_address_country varchar(255) DEFAULT NULL,
  alt_address_street varchar(150) DEFAULT NULL,
  alt_address_city varchar(100) DEFAULT NULL,
  alt_address_state varchar(100) DEFAULT NULL,
  alt_address_postalcode varchar(20) DEFAULT NULL,
  alt_address_country varchar(255) DEFAULT NULL,
  assistant varchar(75) DEFAULT NULL,
  assistant_phone varchar(100) DEFAULT NULL,
  converted smallint DEFAULT 0,
  refered_by varchar(100) DEFAULT NULL,
  lead_source varchar(100) DEFAULT NULL,
  lead_source_description varchar(max) DEFAULT NULL,
  status varchar(100) DEFAULT NULL,
  status_description varchar(max) DEFAULT NULL,
  reports_to_id char(36) DEFAULT NULL,
  account_name varchar(255) DEFAULT NULL,
  account_description varchar(max) DEFAULT NULL,
  contact_id char(36) DEFAULT NULL,
  account_id char(36) DEFAULT NULL,
  opportunity_id char(36) DEFAULT NULL,
  opportunity_name varchar(255) DEFAULT NULL,
  opportunity_amount varchar(50) DEFAULT NULL,
  campaign_id char(36) DEFAULT NULL,
  birthdate date DEFAULT NULL,
  portal_name varchar(255) DEFAULT NULL,
  portal_app varchar(255) DEFAULT NULL,
  website varchar(255) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_lead_acct_name_first ON leads (account_name,deleted);
CREATE INDEX idx_lead_last_first ON leads (last_name,first_name,deleted);
CREATE INDEX idx_lead_del_stat ON leads (last_name,status,deleted,first_name);
CREATE INDEX idx_lead_opp_del ON leads (opportunity_id,deleted);
CREATE INDEX idx_leads_acct_del ON leads (account_id,deleted);
CREATE INDEX idx_del_user ON leads (deleted,assigned_user_id);
CREATE INDEX idx_lead_assigned ON leads (assigned_user_id);
CREATE INDEX idx_lead_contact ON leads (contact_id);
CREATE INDEX idx_reports_to ON leads (reports_to_id);
CREATE INDEX idx_lead_phone_work ON leads (phone_work);
CREATE INDEX idx_leads_id_del ON leads (id,deleted);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `leads_audit`
--

DROP TABLE IF EXISTS leads_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE leads_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_leads_parent_id ON leads_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `leads_cstm`
--

DROP TABLE IF EXISTS leads_cstm;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE leads_cstm (
  id_c char(36) NOT NULL,
  jjwg_maps_lng_c float DEFAULT 0.00000000,
  jjwg_maps_lat_c float DEFAULT 0.00000000,
  jjwg_maps_geocode_status_c varchar(255) DEFAULT NULL,
  jjwg_maps_address_c varchar(255) DEFAULT NULL,
  PRIMARY KEY (id_c)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `linked_documents`
--

DROP TABLE IF EXISTS linked_documents;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE linked_documents (
  id varchar(36) NOT NULL,
  parent_id varchar(36) DEFAULT NULL,
  parent_type varchar(25) DEFAULT NULL,
  document_id varchar(36) DEFAULT NULL,
  document_revision_id varchar(36) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_parent_document ON linked_documents (parent_type,parent_id,document_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `meetings`
--

DROP TABLE IF EXISTS meetings;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE meetings (
  id char(36) NOT NULL,
  name varchar(50) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  location varchar(50) DEFAULT NULL,
  password varchar(50) DEFAULT NULL,
  join_url varchar(200) DEFAULT NULL,
  host_url varchar(400) DEFAULT NULL,
  displayed_url varchar(400) DEFAULT NULL,
  creator varchar(50) DEFAULT NULL,
  external_id varchar(50) DEFAULT NULL,
  duration_hours int DEFAULT NULL,
  duration_minutes int DEFAULT NULL,
  date_start datetime2(0) DEFAULT NULL,
  date_end datetime2(0) DEFAULT NULL,
  parent_type varchar(100) DEFAULT NULL,
  status varchar(100) DEFAULT 'Planned',
  type varchar(255) DEFAULT 'Sugar',
  parent_id char(36) DEFAULT NULL,
  reminder_time int DEFAULT -1,
  email_reminder_time int DEFAULT -1,
  email_reminder_sent smallint DEFAULT 0,
  outlook_id varchar(255) DEFAULT NULL,
  sequence int DEFAULT 0,
  repeat_type varchar(36) DEFAULT NULL,
  repeat_interval int DEFAULT 1,
  repeat_dow varchar(7) DEFAULT NULL,
  repeat_until date DEFAULT NULL,
  repeat_count int DEFAULT NULL,
  repeat_parent_id char(36) DEFAULT NULL,
  recurring_source varchar(36) DEFAULT NULL,
  gsync_id varchar(1024) DEFAULT NULL,
  gsync_lastsync int DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_mtg_name ON meetings (name);
CREATE INDEX idx_meet_par_del ON meetings (parent_id,parent_type,deleted);
CREATE INDEX idx_meet_stat_del ON meetings (assigned_user_id,status,deleted);
CREATE INDEX idx_meet_date_start ON meetings (date_start);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `meetings_contacts`
--

DROP TABLE IF EXISTS meetings_contacts;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE meetings_contacts (
  id varchar(36) NOT NULL,
  meeting_id varchar(36) DEFAULT NULL,
  contact_id varchar(36) DEFAULT NULL,
  required varchar(1) DEFAULT '1',
  accept_status varchar(25) DEFAULT 'none',
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_con_mtg_mtg ON meetings_contacts (meeting_id);
CREATE INDEX idx_con_mtg_con ON meetings_contacts (contact_id);
CREATE INDEX idx_meeting_contact ON meetings_contacts (meeting_id,contact_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `meetings_cstm`
--

DROP TABLE IF EXISTS meetings_cstm;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE meetings_cstm (
  id_c char(36) NOT NULL,
  jjwg_maps_lng_c float DEFAULT 0.00000000,
  jjwg_maps_lat_c float DEFAULT 0.00000000,
  jjwg_maps_geocode_status_c varchar(255) DEFAULT NULL,
  jjwg_maps_address_c varchar(255) DEFAULT NULL,
  PRIMARY KEY (id_c)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `meetings_leads`
--

DROP TABLE IF EXISTS meetings_leads;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE meetings_leads (
  id varchar(36) NOT NULL,
  meeting_id varchar(36) DEFAULT NULL,
  lead_id varchar(36) DEFAULT NULL,
  required varchar(1) DEFAULT '1',
  accept_status varchar(25) DEFAULT 'none',
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_lead_meeting_meeting ON meetings_leads (meeting_id);
CREATE INDEX idx_lead_meeting_lead ON meetings_leads (lead_id);
CREATE INDEX idx_meeting_lead ON meetings_leads (meeting_id,lead_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `meetings_users`
--

DROP TABLE IF EXISTS meetings_users;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE meetings_users (
  id varchar(36) NOT NULL,
  meeting_id varchar(36) DEFAULT NULL,
  user_id varchar(36) DEFAULT NULL,
  required varchar(1) DEFAULT '1',
  accept_status varchar(25) DEFAULT 'none',
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_usr_mtg_mtg ON meetings_users (meeting_id);
CREATE INDEX idx_usr_mtg_usr ON meetings_users (user_id);
CREATE INDEX idx_meeting_users ON meetings_users (meeting_id,user_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `notes`
--

DROP TABLE IF EXISTS notes;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE notes (
  assigned_user_id char(36) DEFAULT NULL,
  id char(36) NOT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  name varchar(255) DEFAULT NULL,
  file_mime_type varchar(100) DEFAULT NULL,
  filename varchar(255) DEFAULT NULL,
  parent_type varchar(255) DEFAULT NULL,
  parent_id char(36) DEFAULT NULL,
  contact_id char(36) DEFAULT NULL,
  portal_flag smallint DEFAULT NULL,
  embed_flag smallint DEFAULT 0,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_note_name ON notes (name);
CREATE INDEX idx_notes_parent ON notes (parent_id,parent_type);
CREATE INDEX idx_note_contact ON notes (contact_id);
CREATE INDEX idx_notes_assigned_del ON notes (deleted,assigned_user_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `oauth2clients`
--

DROP TABLE IF EXISTS oauth2clients;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE oauth2clients (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  secret varchar(4000) DEFAULT NULL,
  redirect_url varchar(255) DEFAULT NULL,
  is_confidential smallint DEFAULT 1,
  allowed_grant_type varchar(255) DEFAULT 'password',
  duration_value int DEFAULT NULL,
  duration_amount int DEFAULT NULL,
  duration_unit varchar(255) DEFAULT 'Duration Unit',
  assigned_user_id char(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `oauth2tokens`
--

DROP TABLE IF EXISTS oauth2tokens;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE oauth2tokens (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  token_is_revoked smallint DEFAULT NULL,
  token_type varchar(255) DEFAULT NULL,
  access_token_expires datetime2(0) DEFAULT NULL,
  access_token varchar(4000) DEFAULT NULL,
  refresh_token varchar(4000) DEFAULT NULL,
  refresh_token_expires datetime2(0) DEFAULT NULL,
  grant_type varchar(255) DEFAULT NULL,
  state varchar(1024) DEFAULT NULL,
  client char(36) DEFAULT NULL,
  assigned_user_id char(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `oauth_consumer`
--

DROP TABLE IF EXISTS oauth_consumer;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE oauth_consumer (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  c_key varchar(255) DEFAULT NULL,
  c_secret varchar(255) DEFAULT NULL,
  PRIMARY KEY (id),
  CONSTRAINT ckey UNIQUE  (c_key)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `oauth_nonce`
--

DROP TABLE IF EXISTS oauth_nonce;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE oauth_nonce (
  conskey varchar(32) NOT NULL,
  nonce varchar(32) NOT NULL,
  nonce_ts bigint DEFAULT NULL,
  PRIMARY KEY (conskey,nonce)
) ;

CREATE INDEX oauth_nonce_keyts ON oauth_nonce (conskey,nonce_ts);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `oauth_tokens`
--

DROP TABLE IF EXISTS oauth_tokens;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE oauth_tokens (
  id char(36) NOT NULL,
  secret varchar(32) DEFAULT NULL,
  tstate varchar(1) DEFAULT NULL,
  consumer char(36) NOT NULL,
  token_ts bigint DEFAULT NULL,
  verify varchar(32) DEFAULT NULL,
  deleted smallint NOT NULL DEFAULT 0,
  callback_url varchar(255) DEFAULT NULL,
  assigned_user_id char(36) DEFAULT NULL,
  PRIMARY KEY (id,deleted)
) ;

CREATE INDEX oauth_state_ts ON oauth_tokens (tstate,token_ts);
CREATE INDEX constoken_key ON oauth_tokens (consumer);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `opportunities`
--

DROP TABLE IF EXISTS opportunities;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE opportunities (
  id char(36) NOT NULL,
  name varchar(50) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  opportunity_type varchar(255) DEFAULT NULL,
  campaign_id char(36) DEFAULT NULL,
  lead_source varchar(50) DEFAULT NULL,
  amount float DEFAULT NULL,
  amount_usdollar float DEFAULT NULL,
  currency_id char(36) DEFAULT NULL,
  date_closed date DEFAULT NULL,
  next_step varchar(100) DEFAULT NULL,
  sales_stage varchar(255) DEFAULT NULL,
  probability float DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_opp_name ON opportunities (name);
CREATE INDEX idx_opp_assigned ON opportunities (assigned_user_id);
CREATE INDEX idx_opp_id_deleted ON opportunities (id,deleted);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `opportunities_audit`
--

DROP TABLE IF EXISTS opportunities_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE opportunities_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_opportunities_parent_id ON opportunities_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `opportunities_contacts`
--

DROP TABLE IF EXISTS opportunities_contacts;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE opportunities_contacts (
  id varchar(36) NOT NULL,
  contact_id varchar(36) DEFAULT NULL,
  opportunity_id varchar(36) DEFAULT NULL,
  contact_role varchar(50) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_con_opp_con ON opportunities_contacts (contact_id);
CREATE INDEX idx_con_opp_opp ON opportunities_contacts (opportunity_id);
CREATE INDEX idx_opportunities_contacts ON opportunities_contacts (opportunity_id,contact_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `opportunities_cstm`
--

DROP TABLE IF EXISTS opportunities_cstm;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE opportunities_cstm (
  id_c char(36) NOT NULL,
  jjwg_maps_lng_c float DEFAULT 0.00000000,
  jjwg_maps_lat_c float DEFAULT 0.00000000,
  jjwg_maps_geocode_status_c varchar(255) DEFAULT NULL,
  jjwg_maps_address_c varchar(255) DEFAULT NULL,
  PRIMARY KEY (id_c)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `outbound_email`
--

DROP TABLE IF EXISTS outbound_email;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE outbound_email (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  type varchar(15) DEFAULT 'user',
  user_id char(36) DEFAULT NULL,
  smtp_from_name varchar(255) DEFAULT NULL,
  smtp_from_addr varchar(255) DEFAULT NULL,
  reply_to_name varchar(255) DEFAULT NULL,
  reply_to_addr varchar(255) DEFAULT NULL,
  signature varchar(max) DEFAULT NULL,
  mail_sendtype varchar(8) DEFAULT 'SMTP',
  mail_smtptype varchar(20) DEFAULT 'other',
  mail_smtpserver varchar(100) DEFAULT NULL,
  mail_smtpport varchar(5) DEFAULT '25',
  mail_smtpuser varchar(100) DEFAULT NULL,
  mail_smtppass varchar(100) DEFAULT NULL,
  mail_smtpauth_req smallint DEFAULT 0,
  mail_smtpssl varchar(1) DEFAULT '0',
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `outbound_email_audit`
--

DROP TABLE IF EXISTS outbound_email_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE outbound_email_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_outbound_email_parent_id ON outbound_email_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `project`
--

DROP TABLE IF EXISTS project;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE project (
  id char(36) NOT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  assigned_user_id char(36) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  name varchar(50) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  estimated_start_date date DEFAULT NULL,
  estimated_end_date date DEFAULT NULL,
  status varchar(255) DEFAULT NULL,
  priority varchar(255) DEFAULT NULL,
  override_business_hours smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `project_contacts_1_c`
--

DROP TABLE IF EXISTS project_contacts_1_c;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE project_contacts_1_c (
  id varchar(36) NOT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  project_contacts_1project_ida varchar(36) DEFAULT NULL,
  project_contacts_1contacts_idb varchar(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX project_contacts_1_alt ON project_contacts_1_c (project_contacts_1project_ida,project_contacts_1contacts_idb);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `project_cstm`
--

DROP TABLE IF EXISTS project_cstm;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE project_cstm (
  id_c char(36) NOT NULL,
  jjwg_maps_lng_c float DEFAULT 0.00000000,
  jjwg_maps_lat_c float DEFAULT 0.00000000,
  jjwg_maps_geocode_status_c varchar(255) DEFAULT NULL,
  jjwg_maps_address_c varchar(255) DEFAULT NULL,
  PRIMARY KEY (id_c)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `project_task`
--

DROP TABLE IF EXISTS project_task;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE project_task (
  id char(36) NOT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  project_id char(36) NOT NULL,
  project_task_id int DEFAULT NULL,
  name varchar(50) DEFAULT NULL,
  status varchar(255) DEFAULT NULL,
  relationship_type varchar(255) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  predecessors varchar(max) DEFAULT NULL,
  date_start date DEFAULT NULL,
  time_start int DEFAULT NULL,
  time_finish int DEFAULT NULL,
  date_finish date DEFAULT NULL,
  duration int DEFAULT NULL,
  duration_unit varchar(max) DEFAULT NULL,
  actual_duration int DEFAULT NULL,
  percent_complete int DEFAULT NULL,
  date_due date DEFAULT NULL,
  time_due time(0) DEFAULT NULL,
  parent_task_id int DEFAULT NULL,
  assigned_user_id char(36) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  priority varchar(255) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  milestone_flag smallint DEFAULT NULL,
  order_number int DEFAULT 1,
  task_number int DEFAULT NULL,
  estimated_effort int DEFAULT NULL,
  actual_effort int DEFAULT NULL,
  deleted smallint DEFAULT 0,
  utilization int DEFAULT 100,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `project_task_audit`
--

DROP TABLE IF EXISTS project_task_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE project_task_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_project_task_parent_id ON project_task_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `project_users_1_c`
--

DROP TABLE IF EXISTS project_users_1_c;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE project_users_1_c (
  id varchar(36) NOT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  project_users_1project_ida varchar(36) DEFAULT NULL,
  project_users_1users_idb varchar(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX project_users_1_alt ON project_users_1_c (project_users_1project_ida,project_users_1users_idb);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `projects_accounts`
--

DROP TABLE IF EXISTS projects_accounts;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE projects_accounts (
  id varchar(36) NOT NULL,
  account_id varchar(36) DEFAULT NULL,
  project_id varchar(36) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_proj_acct_proj ON projects_accounts (project_id);
CREATE INDEX idx_proj_acct_acct ON projects_accounts (account_id);
CREATE INDEX projects_accounts_alt ON projects_accounts (project_id,account_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `projects_bugs`
--

DROP TABLE IF EXISTS projects_bugs;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE projects_bugs (
  id varchar(36) NOT NULL,
  bug_id varchar(36) DEFAULT NULL,
  project_id varchar(36) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_proj_bug_proj ON projects_bugs (project_id);
CREATE INDEX idx_proj_bug_bug ON projects_bugs (bug_id);
CREATE INDEX projects_bugs_alt ON projects_bugs (project_id,bug_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `projects_cases`
--

DROP TABLE IF EXISTS projects_cases;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE projects_cases (
  id varchar(36) NOT NULL,
  case_id varchar(36) DEFAULT NULL,
  project_id varchar(36) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_proj_case_proj ON projects_cases (project_id);
CREATE INDEX idx_proj_case_case ON projects_cases (case_id);
CREATE INDEX projects_cases_alt ON projects_cases (project_id,case_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `projects_contacts`
--

DROP TABLE IF EXISTS projects_contacts;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE projects_contacts (
  id varchar(36) NOT NULL,
  contact_id varchar(36) DEFAULT NULL,
  project_id varchar(36) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_proj_con_proj ON projects_contacts (project_id);
CREATE INDEX idx_proj_con_con ON projects_contacts (contact_id);
CREATE INDEX projects_contacts_alt ON projects_contacts (project_id,contact_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `projects_opportunities`
--

DROP TABLE IF EXISTS projects_opportunities;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE projects_opportunities (
  id varchar(36) NOT NULL,
  opportunity_id varchar(36) DEFAULT NULL,
  project_id varchar(36) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_proj_opp_proj ON projects_opportunities (project_id);
CREATE INDEX idx_proj_opp_opp ON projects_opportunities (opportunity_id);
CREATE INDEX projects_opportunities_alt ON projects_opportunities (project_id,opportunity_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `projects_products`
--

DROP TABLE IF EXISTS projects_products;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE projects_products (
  id varchar(36) NOT NULL,
  product_id varchar(36) DEFAULT NULL,
  project_id varchar(36) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_proj_prod_project ON projects_products (project_id);
CREATE INDEX idx_proj_prod_product ON projects_products (product_id);
CREATE INDEX projects_products_alt ON projects_products (project_id,product_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `prospect_list_campaigns`
--

DROP TABLE IF EXISTS prospect_list_campaigns;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE prospect_list_campaigns (
  id varchar(36) NOT NULL,
  prospect_list_id varchar(36) DEFAULT NULL,
  campaign_id varchar(36) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_pro_id ON prospect_list_campaigns (prospect_list_id);
CREATE INDEX idx_cam_id ON prospect_list_campaigns (campaign_id);
CREATE INDEX idx_prospect_list_campaigns ON prospect_list_campaigns (prospect_list_id,campaign_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `prospect_lists`
--

DROP TABLE IF EXISTS prospect_lists;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE prospect_lists (
  assigned_user_id char(36) DEFAULT NULL,
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  list_type varchar(100) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  deleted smallint DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  domain_name varchar(255) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_prospect_list_name ON prospect_lists (name);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `prospect_lists_prospects`
--

DROP TABLE IF EXISTS prospect_lists_prospects;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE prospect_lists_prospects (
  id varchar(36) NOT NULL,
  prospect_list_id varchar(36) DEFAULT NULL,
  related_id varchar(36) DEFAULT NULL,
  related_type varchar(25) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_plp_pro_id ON prospect_lists_prospects (prospect_list_id,deleted);
CREATE INDEX idx_plp_rel_id ON prospect_lists_prospects (related_id,related_type,prospect_list_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `prospects`
--

DROP TABLE IF EXISTS prospects;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE prospects (
  id char(36) NOT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  salutation varchar(255) DEFAULT NULL,
  first_name varchar(100) DEFAULT NULL,
  last_name varchar(100) DEFAULT NULL,
  title varchar(100) DEFAULT NULL,
  photo varchar(255) DEFAULT NULL,
  department varchar(255) DEFAULT NULL,
  do_not_call smallint DEFAULT 0,
  phone_home varchar(100) DEFAULT NULL,
  phone_mobile varchar(100) DEFAULT NULL,
  phone_work varchar(100) DEFAULT NULL,
  phone_other varchar(100) DEFAULT NULL,
  phone_fax varchar(100) DEFAULT NULL,
  lawful_basis varchar(max) DEFAULT NULL,
  date_reviewed date DEFAULT NULL,
  lawful_basis_source varchar(100) DEFAULT NULL,
  primary_address_street varchar(150) DEFAULT NULL,
  primary_address_city varchar(100) DEFAULT NULL,
  primary_address_state varchar(100) DEFAULT NULL,
  primary_address_postalcode varchar(20) DEFAULT NULL,
  primary_address_country varchar(255) DEFAULT NULL,
  alt_address_street varchar(150) DEFAULT NULL,
  alt_address_city varchar(100) DEFAULT NULL,
  alt_address_state varchar(100) DEFAULT NULL,
  alt_address_postalcode varchar(20) DEFAULT NULL,
  alt_address_country varchar(255) DEFAULT NULL,
  assistant varchar(75) DEFAULT NULL,
  assistant_phone varchar(100) DEFAULT NULL,
  tracker_key int NOT NULL IDENTITY,
  birthdate date DEFAULT NULL,
  lead_id char(36) DEFAULT NULL,
  account_name varchar(150) DEFAULT NULL,
  campaign_id char(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX prospect_auto_tracker_key ON prospects (tracker_key);
CREATE INDEX idx_prospects_last_first ON prospects (last_name,first_name,deleted);
CREATE INDEX idx_prospecs_del_last ON prospects (last_name,deleted);
CREATE INDEX idx_prospects_id_del ON prospects (id,deleted);
CREATE INDEX idx_prospects_assigned ON prospects (assigned_user_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `prospects_cstm`
--

DROP TABLE IF EXISTS prospects_cstm;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE prospects_cstm (
  id_c char(36) NOT NULL,
  jjwg_maps_lng_c float DEFAULT 0.00000000,
  jjwg_maps_lat_c float DEFAULT 0.00000000,
  jjwg_maps_geocode_status_c varchar(255) DEFAULT NULL,
  jjwg_maps_address_c varchar(255) DEFAULT NULL,
  PRIMARY KEY (id_c)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `relationships`
--

DROP TABLE IF EXISTS relationships;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE relationships (
  id char(36) NOT NULL,
  relationship_name varchar(150) DEFAULT NULL,
  lhs_module varchar(100) DEFAULT NULL,
  lhs_table varchar(64) DEFAULT NULL,
  lhs_key varchar(64) DEFAULT NULL,
  rhs_module varchar(100) DEFAULT NULL,
  rhs_table varchar(64) DEFAULT NULL,
  rhs_key varchar(64) DEFAULT NULL,
  join_table varchar(64) DEFAULT NULL,
  join_key_lhs varchar(64) DEFAULT NULL,
  join_key_rhs varchar(64) DEFAULT NULL,
  relationship_type varchar(64) DEFAULT NULL,
  relationship_role_column varchar(64) DEFAULT NULL,
  relationship_role_column_value varchar(50) DEFAULT NULL,
  reverse smallint DEFAULT 0,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_rel_name ON relationships (relationship_name);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `releases`
--

DROP TABLE IF EXISTS releases;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE releases (
  id char(36) NOT NULL,
  deleted smallint DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  name varchar(50) DEFAULT NULL,
  list_order int DEFAULT NULL,
  status varchar(100) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_releases ON releases (name,deleted);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `reminders`
--

DROP TABLE IF EXISTS reminders;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE reminders (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  popup smallint DEFAULT NULL,
  email smallint DEFAULT NULL,
  email_sent smallint DEFAULT NULL,
  timer_popup varchar(32) DEFAULT NULL,
  timer_email varchar(32) DEFAULT NULL,
  related_event_module varchar(32) DEFAULT NULL,
  related_event_module_id char(36) NOT NULL,
  date_willexecute int DEFAULT -1,
  popup_viewed smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_reminder_name ON reminders (name);
CREATE INDEX idx_reminder_deleted ON reminders (deleted);
CREATE INDEX idx_reminder_related_event_module ON reminders (related_event_module);
CREATE INDEX idx_reminder_related_event_module_id ON reminders (related_event_module_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `reminders_invitees`
--

DROP TABLE IF EXISTS reminders_invitees;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE reminders_invitees (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  reminder_id char(36) NOT NULL,
  related_invitee_module varchar(32) DEFAULT NULL,
  related_invitee_module_id char(36) NOT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_reminder_invitee_name ON reminders_invitees (name);
CREATE INDEX idx_reminder_invitee_assigned_user_id ON reminders_invitees (assigned_user_id);
CREATE INDEX idx_reminder_invitee_reminder_id ON reminders_invitees (reminder_id);
CREATE INDEX idx_reminder_invitee_related_invitee_module ON reminders_invitees (related_invitee_module);
CREATE INDEX idx_reminder_invitee_related_invitee_module_id ON reminders_invitees (related_invitee_module_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `roles`
--

DROP TABLE IF EXISTS roles;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE roles (
  id char(36) NOT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  name varchar(150) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  modules varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_role_id_del ON roles (id,deleted);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `roles_modules`
--

DROP TABLE IF EXISTS roles_modules;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE roles_modules (
  id varchar(36) NOT NULL,
  role_id varchar(36) DEFAULT NULL,
  module_id varchar(36) DEFAULT NULL,
  allow smallint DEFAULT 0,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_role_id ON roles_modules (role_id);
CREATE INDEX idx_module_id ON roles_modules (module_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `roles_users`
--

DROP TABLE IF EXISTS roles_users;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE roles_users (
  id varchar(36) NOT NULL,
  role_id varchar(36) DEFAULT NULL,
  user_id varchar(36) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_ru_role_id ON roles_users (role_id);
CREATE INDEX idx_ru_user_id ON roles_users (user_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `saved_search`
--

DROP TABLE IF EXISTS saved_search;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE saved_search (
  id char(36) NOT NULL,
  name varchar(150) DEFAULT NULL,
  search_module varchar(150) DEFAULT NULL,
  quick_filter smallint DEFAULT NULL,
  deleted smallint DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  assigned_user_id char(36) DEFAULT NULL,
  contents varchar(max) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_desc ON saved_search (name,deleted);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `schedulers`
--

DROP TABLE IF EXISTS schedulers;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE schedulers (
  id varchar(36) NOT NULL,
  deleted smallint DEFAULT 0,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  name varchar(255) DEFAULT NULL,
  job varchar(255) DEFAULT NULL,
  date_time_start datetime2(0) DEFAULT NULL,
  date_time_end datetime2(0) DEFAULT NULL,
  job_interval varchar(100) DEFAULT NULL,
  time_from time(0) DEFAULT NULL,
  time_to time(0) DEFAULT NULL,
  last_run datetime2(0) DEFAULT NULL,
  status varchar(100) DEFAULT NULL,
  catch_up smallint DEFAULT 1,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_schedule ON schedulers (date_time_start,deleted);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `securitygroups`
--

DROP TABLE IF EXISTS securitygroups;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE securitygroups (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  noninheritable smallint DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `securitygroups_acl_roles`
--

DROP TABLE IF EXISTS securitygroups_acl_roles;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE securitygroups_acl_roles (
  id char(36) NOT NULL,
  securitygroup_id char(36) DEFAULT NULL,
  role_id char(36) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `securitygroups_audit`
--

DROP TABLE IF EXISTS securitygroups_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE securitygroups_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_securitygroups_parent_id ON securitygroups_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `securitygroups_default`
--

DROP TABLE IF EXISTS securitygroups_default;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE securitygroups_default (
  id char(36) NOT NULL,
  securitygroup_id char(36) DEFAULT NULL,
  module varchar(50) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `securitygroups_records`
--

DROP TABLE IF EXISTS securitygroups_records;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE securitygroups_records (
  id char(36) NOT NULL,
  securitygroup_id char(36) DEFAULT NULL,
  record_id char(36) DEFAULT NULL,
  module varchar(100) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_securitygroups_records_mod ON securitygroups_records (module,deleted,record_id,securitygroup_id);
CREATE INDEX idx_securitygroups_records_del ON securitygroups_records (deleted,record_id,module,securitygroup_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `securitygroups_users`
--

DROP TABLE IF EXISTS securitygroups_users;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE securitygroups_users (
  id varchar(36) NOT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  securitygroup_id varchar(36) DEFAULT NULL,
  user_id varchar(36) DEFAULT NULL,
  primary_group smallint DEFAULT NULL,
  noninheritable smallint DEFAULT 0,
  PRIMARY KEY (id)
) ;

CREATE INDEX securitygroups_users_idxa ON securitygroups_users (securitygroup_id);
CREATE INDEX securitygroups_users_idxb ON securitygroups_users (user_id);
CREATE INDEX securitygroups_users_idxc ON securitygroups_users (user_id,deleted,securitygroup_id,id);
CREATE INDEX securitygroups_users_idxd ON securitygroups_users (user_id,deleted,securitygroup_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `sugarfeed`
--

DROP TABLE IF EXISTS sugarfeed;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE sugarfeed (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  related_module varchar(100) DEFAULT NULL,
  related_id char(36) DEFAULT NULL,
  link_url varchar(255) DEFAULT NULL,
  link_type varchar(30) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX sgrfeed_date ON sugarfeed (date_entered,deleted);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `surveyquestionoptions`
--

DROP TABLE IF EXISTS surveyquestionoptions;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE surveyquestionoptions (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  sort_order int DEFAULT NULL,
  survey_question_id char(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `surveyquestionoptions_audit`
--

DROP TABLE IF EXISTS surveyquestionoptions_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE surveyquestionoptions_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_surveyquestionoptions_parent_id ON surveyquestionoptions_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `surveyquestionoptions_surveyquestionresponses`
--

DROP TABLE IF EXISTS surveyquestionoptions_surveyquestionresponses;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE surveyquestionoptions_surveyquestionresponses (
  id varchar(36) NOT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  surveyq72c7options_ida varchar(36) DEFAULT NULL,
  surveyq10d4sponses_idb varchar(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX surveyquestionoptions_surveyquestionresponses_alt ON surveyquestionoptions_surveyquestionresponses (surveyq72c7options_ida,surveyq10d4sponses_idb);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `surveyquestionresponses`
--

DROP TABLE IF EXISTS surveyquestionresponses;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE surveyquestionresponses (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  answer varchar(max) DEFAULT NULL,
  answer_bool smallint DEFAULT NULL,
  answer_datetime datetime2(0) DEFAULT NULL,
  surveyquestion_id char(36) DEFAULT NULL,
  surveyresponse_id char(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `surveyquestionresponses_audit`
--

DROP TABLE IF EXISTS surveyquestionresponses_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE surveyquestionresponses_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_surveyquestionresponses_parent_id ON surveyquestionresponses_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `surveyquestions`
--

DROP TABLE IF EXISTS surveyquestions;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE surveyquestions (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  sort_order int DEFAULT NULL,
  type varchar(100) DEFAULT NULL,
  happiness_question smallint DEFAULT NULL,
  survey_id char(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `surveyquestions_audit`
--

DROP TABLE IF EXISTS surveyquestions_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE surveyquestions_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_surveyquestions_parent_id ON surveyquestions_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `surveyresponses`
--

DROP TABLE IF EXISTS surveyresponses;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE surveyresponses (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  happiness int DEFAULT NULL,
  email_response_sent smallint DEFAULT NULL,
  account_id char(36) DEFAULT NULL,
  campaign_id char(36) DEFAULT NULL,
  contact_id char(36) DEFAULT NULL,
  survey_id char(36) DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `surveyresponses_audit`
--

DROP TABLE IF EXISTS surveyresponses_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE surveyresponses_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_surveyresponses_parent_id ON surveyresponses_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `surveys`
--

DROP TABLE IF EXISTS surveys;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE surveys (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  status varchar(100) DEFAULT 'LBL_DRAFT',
  submit_text varchar(255) DEFAULT 'Submit',
  satisfied_text varchar(255) DEFAULT 'Satisfied',
  neither_text varchar(255) DEFAULT 'Neither Satisfied nor Dissatisfied',
  dissatisfied_text varchar(255) DEFAULT 'Dissatisfied',
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `surveys_audit`
--

DROP TABLE IF EXISTS surveys_audit;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE surveys_audit (
  id char(36) NOT NULL,
  parent_id char(36) NOT NULL,
  date_created datetime2(0) DEFAULT NULL,
  created_by varchar(36) DEFAULT NULL,
  field_name varchar(100) DEFAULT NULL,
  data_type varchar(100) DEFAULT NULL,
  before_value_string varchar(255) DEFAULT NULL,
  after_value_string varchar(255) DEFAULT NULL,
  before_value_text varchar(max) DEFAULT NULL,
  after_value_text varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_surveys_parent_id ON surveys_audit (parent_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `tasks`
--

DROP TABLE IF EXISTS tasks;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE tasks (
  id char(36) NOT NULL,
  name varchar(50) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  assigned_user_id char(36) DEFAULT NULL,
  status varchar(100) DEFAULT 'Not Started',
  date_due_flag smallint DEFAULT 0,
  date_due datetime2(0) DEFAULT NULL,
  date_start_flag smallint DEFAULT 0,
  date_start datetime2(0) DEFAULT NULL,
  parent_type varchar(255) DEFAULT NULL,
  parent_id char(36) DEFAULT NULL,
  contact_id char(36) DEFAULT NULL,
  priority varchar(100) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_tsk_name ON tasks (name);
CREATE INDEX idx_task_con_del ON tasks (contact_id,deleted);
CREATE INDEX idx_task_par_del ON tasks (parent_id,parent_type,deleted);
CREATE INDEX idx_task_assigned ON tasks (assigned_user_id);
CREATE INDEX idx_task_status ON tasks (status);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `templatesectionline`
--

DROP TABLE IF EXISTS templatesectionline;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE templatesectionline (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  thumbnail varchar(255) DEFAULT NULL,
  grp varchar(255) DEFAULT NULL,
  ord int DEFAULT NULL,
  PRIMARY KEY (id)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `tracker`
--

DROP TABLE IF EXISTS tracker;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE tracker (
  id int NOT NULL IDENTITY,
  monitor_id char(36) NOT NULL,
  user_id varchar(36) DEFAULT NULL,
  module_name varchar(255) DEFAULT NULL,
  item_id varchar(36) DEFAULT NULL,
  item_summary varchar(255) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  action varchar(255) DEFAULT NULL,
  session_id varchar(36) DEFAULT NULL,
  visible smallint DEFAULT 0,
  deleted smallint DEFAULT 0,
  PRIMARY KEY (id)
)  ;

CREATE INDEX idx_tracker_iid ON tracker (item_id);
CREATE INDEX idx_tracker_userid_vis_id ON tracker (user_id,visible,id);
CREATE INDEX idx_tracker_userid_itemid_vis ON tracker (user_id,item_id,visible);
CREATE INDEX idx_tracker_monitor_id ON tracker (monitor_id);
CREATE INDEX idx_tracker_date_modified ON tracker (date_modified);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `upgrade_history`
--

DROP TABLE IF EXISTS upgrade_history;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE upgrade_history (
  id char(36) NOT NULL,
  filename varchar(255) DEFAULT NULL,
  md5sum varchar(32) DEFAULT NULL,
  type varchar(30) DEFAULT NULL,
  status varchar(50) DEFAULT NULL,
  version varchar(64) DEFAULT NULL,
  name varchar(255) DEFAULT NULL,
  description varchar(max) DEFAULT NULL,
  id_name varchar(255) DEFAULT NULL,
  manifest varchar(max) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  enabled smallint DEFAULT 1,
  PRIMARY KEY (id),
  CONSTRAINT upgrade_history_md5_uk UNIQUE  (md5sum)
) ;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `user_preferences`
--

DROP TABLE IF EXISTS user_preferences;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE user_preferences (
  id char(36) NOT NULL,
  category varchar(50) DEFAULT NULL,
  deleted smallint DEFAULT 0,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  assigned_user_id char(36) DEFAULT NULL,
  contents varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_userprefnamecat ON user_preferences (assigned_user_id,category);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `users`
--

DROP TABLE IF EXISTS users;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE users (
  id char(36) NOT NULL,
  user_name varchar(60) DEFAULT NULL,
  user_hash varchar(255) DEFAULT NULL,
  system_generated_password smallint DEFAULT NULL,
  pwd_last_changed datetime2(0) DEFAULT NULL,
  authenticate_id varchar(100) DEFAULT NULL,
  sugar_login smallint DEFAULT 1,
  first_name varchar(255) DEFAULT NULL,
  last_name varchar(255) DEFAULT NULL,
  is_admin smallint DEFAULT 0,
  external_auth_only smallint DEFAULT 0,
  receive_notifications smallint DEFAULT 1,
  description varchar(max) DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  title varchar(50) DEFAULT NULL,
  photo varchar(255) DEFAULT NULL,
  department varchar(50) DEFAULT NULL,
  phone_home varchar(50) DEFAULT NULL,
  phone_mobile varchar(50) DEFAULT NULL,
  phone_work varchar(50) DEFAULT NULL,
  phone_other varchar(50) DEFAULT NULL,
  phone_fax varchar(50) DEFAULT NULL,
  status varchar(100) DEFAULT NULL,
  address_street varchar(150) DEFAULT NULL,
  address_city varchar(100) DEFAULT NULL,
  address_state varchar(100) DEFAULT NULL,
  address_country varchar(100) DEFAULT NULL,
  address_postalcode varchar(20) DEFAULT NULL,
  deleted smallint DEFAULT NULL,
  portal_only smallint DEFAULT 0,
  show_on_employees smallint DEFAULT 1,
  employee_status varchar(100) DEFAULT NULL,
  messenger_id varchar(100) DEFAULT NULL,
  messenger_type varchar(100) DEFAULT NULL,
  reports_to_id char(36) DEFAULT NULL,
  is_group smallint DEFAULT NULL,
  factor_auth smallint DEFAULT NULL,
  factor_auth_interface varchar(255) DEFAULT NULL,
  PRIMARY KEY (id)
  CREATE INDEX idx_user_name ON users (user_name,is_group,status,last_name(30),dbo.first_name(30),id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 /* COLLATE= */utf8mb3_general_ci;
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `users_feeds`
--

DROP TABLE IF EXISTS users_feeds;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE users_feeds (
  user_id varchar(36) DEFAULT NULL,
  feed_id varchar(36) DEFAULT NULL,
  rank int DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT 0
) ;

CREATE INDEX idx_ud_user_id ON users_feeds (user_id,feed_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `users_last_import`
--

DROP TABLE IF EXISTS users_last_import;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE users_last_import (
  id char(36) NOT NULL,
  assigned_user_id char(36) DEFAULT NULL,
  import_module varchar(36) DEFAULT NULL,
  bean_type varchar(36) DEFAULT NULL,
  bean_id char(36) DEFAULT NULL,
  deleted smallint DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_user_id ON users_last_import (assigned_user_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `users_password_link`
--

DROP TABLE IF EXISTS users_password_link;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE users_password_link (
  id char(36) NOT NULL,
  keyhash varchar(255) DEFAULT NULL,
  user_id varchar(36) DEFAULT NULL,
  username varchar(36) DEFAULT NULL,
  date_generated datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_username ON users_password_link (username);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `users_signatures`
--

DROP TABLE IF EXISTS users_signatures;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE users_signatures (
  id char(36) NOT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  deleted smallint DEFAULT NULL,
  user_id varchar(36) DEFAULT NULL,
  name varchar(255) DEFAULT NULL,
  signature varchar(max) DEFAULT NULL,
  signature_html varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_usersig_uid ON users_signatures (user_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;

--
-- SQLINES DEMO *** or table `vcals`
--

DROP TABLE IF EXISTS vcals;
/* SQLINES DEMO *** d_cs_client     = @@character_set_client */;
/* SQLINES DEMO *** cter_set_client = utf8mb4 */;
CREATE TABLE vcals (
  id char(36) NOT NULL,
  deleted smallint DEFAULT NULL,
  date_entered datetime2(0) DEFAULT NULL,
  date_modified datetime2(0) DEFAULT NULL,
  user_id char(36) NOT NULL,
  type varchar(100) DEFAULT NULL,
  source varchar(100) DEFAULT NULL,
  content varchar(max) DEFAULT NULL,
  PRIMARY KEY (id)
) ;

CREATE INDEX idx_vcal ON vcals (type,user_id);
/* SQLINES DEMO *** cter_set_client = @saved_cs_client */;
/* SQLINES DEMO *** ZONE=@OLD_TIME_ZONE */;

/* SQLINES DEMO *** ODE=@OLD_SQL_MODE */;
/* SQLINES DEMO *** GN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/* SQLINES DEMO *** E_CHECKS=@OLD_UNIQUE_CHECKS */;
/* SQLINES DEMO *** CTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/* SQLINES DEMO *** CTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/* SQLINES DEMO *** TION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/* SQLINES DEMO *** E_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- SQLINES DEMO ***  2025-06-14 12:51:19
