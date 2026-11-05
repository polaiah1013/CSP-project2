-- SheShield Database Schema for MySQL / XAMPP
-- Database Name: sheshield

CREATE DATABASE IF NOT EXISTS sheshield DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sheshield;

-- 1. Users Table
CREATE TABLE IF NOT EXISTS users (
  id VARCHAR(64) PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  phone VARCHAR(20) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  emergency_medical_info TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_users_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Emergency Contacts Table
CREATE TABLE IF NOT EXISTS emergency_contacts (
  id VARCHAR(64) PRIMARY KEY,
  user_id VARCHAR(64) NOT NULL,
  name VARCHAR(100) NOT NULL,
  relationship VARCHAR(50) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  is_primary BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_contacts_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. SOS Alerts Table
CREATE TABLE IF NOT EXISTS sos_alerts (
  id VARCHAR(64) PRIMARY KEY,
  user_id VARCHAR(64) NOT NULL,
  latitude DECIMAL(10, 6) NOT NULL,
  longitude DECIMAL(10, 6) NOT NULL,
  accuracy INT DEFAULT 15,
  status ENUM('ACTIVE', 'CANCELLED', 'COMPLETED') DEFAULT 'ACTIVE',
  contacts_notified_count INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_sos_user (user_id),
  INDEX idx_sos_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Safety Resources Table
CREATE TABLE IF NOT EXISTS safety_resources (
  id VARCHAR(64) PRIMARY KEY,
  title VARCHAR(150) NOT NULL,
  description TEXT NOT NULL,
  category VARCHAR(50) NOT NULL,
  phone VARCHAR(20),
  website_url VARCHAR(255),
  icon_name VARCHAR(50) DEFAULT 'ShieldAlert',
  key_points JSON,
  is_verified BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_safety_cat (category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. Empowerment Resources Table
CREATE TABLE IF NOT EXISTS empowerment_resources (
  id VARCHAR(64) PRIMARY KEY,
  title VARCHAR(150) NOT NULL,
  description TEXT NOT NULL,
  category VARCHAR(50) NOT NULL,
  provider VARCHAR(100) NOT NULL,
  badge_text VARCHAR(50) NOT NULL,
  link VARCHAR(255) NOT NULL,
  tags JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_empowerment_cat (category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. Safe Places Table
CREATE TABLE IF NOT EXISTS safe_places (
  id VARCHAR(64) PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  category VARCHAR(50) NOT NULL,
  address VARCHAR(255) NOT NULL,
  distance VARCHAR(20) DEFAULT '1.0 km',
  phone VARCHAR(20) NOT NULL,
  open_hours VARCHAR(50) DEFAULT 'Open 24/7',
  latitude DECIMAL(10, 6) NOT NULL,
  longitude DECIMAL(10, 6) NOT NULL,
  is_verified BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_safe_cat (category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===================================================
-- DEMO SEED DATA
-- Default password for demo user is: password123 (bcrypt hashed below)
-- ===================================================

INSERT INTO users (id, full_name, email, phone, password_hash, emergency_medical_info)
VALUES (
  'usr_demo_123',
  'Elena Rostova',
  'elena@sheshield.org',
  '+1 (555) 987-6543',
  '$2a$10$wN9cZ/UuN22j/c6vK0mFxeU1r3g9eX8JpWvYmU8YxYyZzZzZzZzZ',
  'Blood Type: O+ | No known drug allergies'
) ON DUPLICATE KEY UPDATE email=email;

INSERT INTO emergency_contacts (id, user_id, name, relationship, phone, is_primary)
VALUES 
  ('c1', 'usr_demo_123', 'Eleanor Vance (Mother)', 'Mother', '+1 (555) 234-5678', TRUE),
  ('c2', 'usr_demo_123', 'Sarah Vance (Sister)', 'Sister', '+1 (555) 876-5432', TRUE),
  ('c3', 'usr_demo_123', 'Maya Patel (Best Friend)', 'Friend', '+1 (555) 432-1098', FALSE)
ON DUPLICATE KEY UPDATE id=id;

INSERT INTO safety_resources (id, title, description, category, phone, website_url, icon_name, key_points, is_verified)
VALUES
  ('res-1', 'National Emergency Helpline', 'Instant 24/7 emergency dispatch service for immediate police, fire, or medical aid.', 'Emergency Helplines', '112', NULL, 'PhoneCall', '["Toll-Free", "24/7 Availability", "GPS Triangulation Supported"]', TRUE),
  ('res-2', 'Women Emergency Helpline', 'Dedicated national helpline for women in distress or experiencing violence.', 'Emergency Helplines', '1091', NULL, 'ShieldAlert', '["Immediate Police Intervention", "Counseling Services", "Confidential Support"]', TRUE),
  ('res-3', 'National Commission for Women (NCW)', 'Helpline against domestic violence, harassment, and legal aid guidance.', 'Emergency Helplines', '7827170170', NULL, 'HeartHandshake', '["Legal Guidance", "Online Complaint Portal", "Counselor Assistance"]', TRUE),
  ('res-4', 'Cyber Crime Helpline', 'Report online harassment, cyberstalking, financial fraud, or non-consensual image sharing.', 'Online Safety', '1930', 'https://cybercrime.gov.in', 'Lock', '["Report Anonymously", "Digital Asset Takedown Support", "24/7 Cyber Cell"]', TRUE),
  ('res-5', 'Understanding Workplace Protection Laws', 'Know your rights regarding Prevention of Sexual Harassment (POSH) at workplaces.', 'Women\'s Rights', NULL, NULL, 'BookOpen', '["Internal Complaints Committee (ICC) mandatory in 10+ employee companies", "Right to zero-tolerance harassment policy", "Confidential inquiry within 90 days"]', TRUE),
  ('res-6', 'Free Legal Aid & Legal Rights Awareness', 'Access zero-cost legal assistance and understand basic Constitutional rights.', 'Legal Awareness', NULL, NULL, 'Scale', '["Right to Zero FIR: File a police complaint in any station regardless of location", "Right to Virtual / In-Camera Investigation", "Women cannot be arrested after sunset or before sunrise except in extraordinary cases"]', TRUE)
ON DUPLICATE KEY UPDATE id=id;

INSERT INTO empowerment_resources (id, title, description, category, provider, badge_text, link, tags)
VALUES
  ('emp-1', 'Women in Tech & Leadership Global Fellowship', '100% funded mentorship program for women pursuing careers in technology, engineering, and product design.', 'Education', 'Global Women Tech Network', 'Full Scholarship', 'https://example.org/fellowship', '["Tech", "Mentorship", "Leadership", "Scholarship"]'),
  ('emp-2', 'Remote Software Developer & Data Analyst Roles', 'Verified flexible female-inclusive hiring initiative connecting women with remote-first global companies.', 'Jobs', 'SheWorks Career Portal', 'Hiring Fast', 'https://example.org/careers', '["Remote", "Flexible Hours", "Inclusive Workplace"]'),
  ('emp-3', 'Financial Independence & Investment Bootcamp', 'Master budgeting, tax planning, mutual funds, equity investments, and personal wealth creation.', 'Financial Literacy', 'EmpowerHER Finance Academy', 'Free Course', 'https://example.org/finance-bootcamp', '["Investment", "Wealth Management", "Budgeting"]'),
  ('emp-4', 'Female Founder Incubator & Micro-Grants', 'Seed funding up to $15,000, legal consultation, and pitch guidance for women launching small businesses.', 'Entrepreneurship', 'SheCapital Venture Fund', '$15k Micro-Grant', 'https://example.org/incubator', '["Funding", "Startup", "Mentorship", "Grants"]'),
  ('emp-5', 'Full-Stack Web & AI Engineering Certification', '12-week intensive self-paced online bootcamp with guaranteed mock interviews and resume reviews.', 'Skills', 'CodeHER Institute', 'Certified', 'https://example.org/codeher', '["Coding", "AI", "Certification", "Career Support"]')
ON DUPLICATE KEY UPDATE id=id;

INSERT INTO safe_places (id, name, category, address, distance, phone, open_hours, latitude, longitude, is_verified)
VALUES
  ('sp-1', 'Central Women Protection & Police Station', 'Police Station', '45 Civic Center Blvd, Downtown', '0.4 km', '+1 (555) 019-2831', 'Open 24/7', 37.774900, -122.419400, TRUE),
  ('sp-2', 'St. Jude Emergency Hospital & Trauma Center', 'Hospital', '102 Healthcare Ave, Medical District', '0.9 km', '+1 (555) 911-4000', 'Open 24/7', 37.779000, -122.414000, TRUE),
  ('sp-3', 'Grace 24/7 Pharmacy & First Aid Desk', 'Pharmacy', '88 Market St, Suite 4', '1.2 km', '+1 (555) 443-8821', 'Open 24/7', 37.781000, -122.409000, TRUE),
  ('sp-4', 'Nari Shakti Women Support & Shelter Center', 'Help Center', '15 Harmony Lane, Community Hub', '1.8 km', '+1 (555) 777-1010', '8:00 AM - 10:00 PM', 37.769000, -122.425000, TRUE),
  ('sp-5', 'Metro North Police Patrol Post', 'Police Station', '320 Station Plaza, North District', '2.3 km', '+1 (555) 019-9944', 'Open 24/7', 37.788000, -122.430000, TRUE)
ON DUPLICATE KEY UPDATE id=id;
