-- ====================================================================
-- SRI ESHWAR COLLEGE OF ENGINEERING
-- Centre for Research and Development
-- Centralized R&D Facility Management System Database Schema
-- ====================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Departments Table
CREATE TABLE IF NOT EXISTS public.departments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    hod_name VARCHAR(100),
    contact_email VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. User Roles Enum & Profiles Table
CREATE TYPE user_role_type AS ENUM ('user', 'host', 'admin');

CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    faculty_id VARCHAR(50) UNIQUE NOT NULL,
    role user_role_type DEFAULT 'user' NOT NULL,
    department_id UUID REFERENCES public.departments(id) ON DELETE SET NULL,
    designation VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    avatar_url TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Facilities Table
CREATE TYPE facility_status_type AS ENUM ('Available', 'Reserved', 'In Use', 'Under Maintenance', 'Unavailable');

CREATE TABLE IF NOT EXISTS public.facilities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(150) NOT NULL,
    category VARCHAR(100) NOT NULL,
    department_id UUID REFERENCES public.departments(id) ON DELETE SET NULL,
    location VARCHAR(150) NOT NULL,
    capacity INT DEFAULT 1,
    operating_hours VARCHAR(100) DEFAULT '08:30 AM - 05:30 PM',
    description TEXT,
    status facility_status_type DEFAULT 'Available',
    image_url TEXT,
    coordinator_name VARCHAR(100),
    coordinator_email VARCHAR(100),
    guidelines TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Equipment Table
CREATE TYPE equipment_status_type AS ENUM ('Available', 'In Use', 'Under Maintenance', 'Decommissioned');

CREATE TABLE IF NOT EXISTS public.equipment (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    equipment_id VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(150) NOT NULL,
    category VARCHAR(100) NOT NULL,
    facility_id UUID REFERENCES public.facilities(id) ON DELETE CASCADE,
    model_number VARCHAR(100),
    specifications TEXT,
    status equipment_status_type DEFAULT 'Available',
    calibration_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. Facility Requests Table
CREATE TYPE request_status_type AS ENUM (
    'Submitted', 
    'Under Review', 
    'Approved', 
    'Scheduled', 
    'In Progress', 
    'Completed', 
    'Rejected', 
    'On Hold', 
    'Additional Information Required', 
    'Cancelled'
);

CREATE TABLE IF NOT EXISTS public.facility_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    request_number VARCHAR(30) UNIQUE NOT NULL, -- e.g. SECE-RD-2026-001
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    facility_id UUID REFERENCES public.facilities(id) ON DELETE RESTRICT NOT NULL,
    title VARCHAR(255) NOT NULL,
    purpose TEXT NOT NULL,
    description TEXT NOT NULL,
    preferred_date DATE NOT NULL,
    preferred_start_time TIME NOT NULL,
    preferred_end_time TIME NOT NULL,
    expected_duration VARCHAR(50),
    equipment_required TEXT[],
    additional_requirements TEXT,
    document_attachment_url TEXT,
    status request_status_type DEFAULT 'Submitted' NOT NULL,
    coordinator_remarks TEXT,
    rejection_reason TEXT,
    allocated_date DATE,
    allocated_start_time TIME,
    allocated_end_time TIME,
    is_draft BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. Request Status History Table
CREATE TABLE IF NOT EXISTS public.request_status_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    request_id UUID REFERENCES public.facility_requests(id) ON DELETE CASCADE NOT NULL,
    previous_status request_status_type,
    new_status request_status_type NOT NULL,
    updated_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    remarks TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 7. Facility Allocations Table
CREATE TABLE IF NOT EXISTS public.facility_allocations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    request_id UUID REFERENCES public.facility_requests(id) ON DELETE CASCADE NOT NULL,
    facility_id UUID REFERENCES public.facilities(id) ON DELETE CASCADE NOT NULL,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    allocated_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    allocated_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    notes TEXT,
    status VARCHAR(50) DEFAULT 'Confirmed',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 8. Notifications Table
CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) DEFAULT 'info', -- 'submitted', 'approved', 'rejected', 'allocated', 'info', etc.
    request_id UUID REFERENCES public.facility_requests(id) ON DELETE CASCADE,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 9. Facility Maintenance Table
CREATE TABLE IF NOT EXISTS public.facility_maintenance (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    facility_id UUID REFERENCES public.facilities(id) ON DELETE CASCADE NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    performed_by VARCHAR(150),
    status VARCHAR(50) DEFAULT 'Scheduled',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 10. Activity Logs Table
CREATE TABLE IF NOT EXISTS public.activity_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    action VARCHAR(100) NOT NULL,
    details TEXT,
    ip_address VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 11. User Feedback Table
CREATE TABLE IF NOT EXISTS public.user_feedback (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    request_id UUID REFERENCES public.facility_requests(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    facility_id UUID REFERENCES public.facilities(id) ON DELETE CASCADE NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comments TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_facility_requests_user ON public.facility_requests(user_id);
CREATE INDEX IF NOT EXISTS idx_facility_requests_status ON public.facility_requests(status);
CREATE INDEX IF NOT EXISTS idx_facility_requests_facility ON public.facility_requests(facility_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user ON public.notifications(user_id, is_read);
CREATE INDEX IF NOT EXISTS idx_allocations_facility_date ON public.facility_allocations(facility_id, allocated_date);

-- Row Level Security (RLS) setup
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.departments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.facilities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.equipment ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.facility_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.request_status_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.facility_allocations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- Sample Policies
-- Departments & Facilities & Equipment are readable by all authenticated users
CREATE POLICY "Public departments readable" ON public.departments FOR SELECT USING (true);
CREATE POLICY "Public facilities readable" ON public.facilities FOR SELECT USING (true);
CREATE POLICY "Public equipment readable" ON public.equipment FOR SELECT USING (true);

-- User Profiles
CREATE POLICY "Users can view own profile or Hosts can view all" ON public.profiles
    FOR SELECT USING (
        auth.uid() = id OR 
        EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('host', 'admin'))
    );

CREATE POLICY "Users can update own profile" ON public.profiles
    FOR UPDATE USING (auth.uid() = id);

-- Facility Requests
CREATE POLICY "Users can view own requests or Hosts can view all" ON public.facility_requests
    FOR SELECT USING (
        auth.uid() = user_id OR 
        EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('host', 'admin'))
    );

CREATE POLICY "Users can insert own requests" ON public.facility_requests
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own draft or pending requests" ON public.facility_requests
    FOR UPDATE USING (
        (auth.uid() = user_id AND status IN ('Submitted', 'On Hold', 'Additional Information Required')) OR
        EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('host', 'admin'))
    );

-- Notifications
CREATE POLICY "Users view their own notifications" ON public.notifications
    FOR SELECT USING (auth.uid() = user_id);

