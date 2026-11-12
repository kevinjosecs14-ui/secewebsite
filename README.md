# SRI ESHWAR COLLEGE OF ENGINEERING
## Centre for Research and Development (CRD)
### Centralized R&D Facility Management System

A production-grade, responsive, and full-featured web application built specifically for **Sri Eshwar College of Engineering (SECE)**.

---

## 🏛️ Official Branding & Identity
- **Institution**: SRI ESHWAR COLLEGE OF ENGINEERING (Autonomous, Approved by AICTE, Affiliated to Anna University)
- **Department**: Centre for Research and Development
- **System**: Centralized R&D Facility Management System
- **Color Palette**:
  - Navy Blue: `#173B63`
  - Primary Blue: `#2F6DB2`
  - White: `#FFFFFF`
  - Slate Background: `#F7F9FC`
  - Light Accent Blue: `#DCEAF7`
  - Accent Gold: `#F4C542`

---

## 🚀 Key Features

### 1. Two Completely Isolated Interfaces
- **User Interface (`/user/dashboard`)**: Dedicated to individual faculty members, research scholars, and project investigators.
- **Host Interface (`/host/dashboard`)**: Dedicated to R&D administrators, directors, and facility coordinators.

### 2. Complete 6-Step Requisition Workflow
1. **Submitted**: Faculty member submits equipment and schedule requirements.
2. **Under Review**: Lab coordinator verifies hardware safety and calibration.
3. **Approved**: R&D Directorate grants formal sanction.
4. **Scheduled**: Bench, operator, and time slots are confirmed.
5. **In Progress**: Active experiment in the research facility.
6. **Completed**: Utilization hours and outcome report archived.

### 3. Built-In Double Booking Prevention
Smart time-overlap validator prevents multiple researchers from reserving overlapping slots on high-demand equipment (e.g. NVIDIA DGX A100 GPU cluster or 3D printers).

### 4. Supabase Database Integration & Ready Schema
- Includes complete PostgreSQL database schema in [`supabase_schema.sql`](./supabase_schema.sql).
- Tables: `departments`, `profiles`, `facilities`, `equipment`, `facility_requests`, `request_status_history`, `facility_allocations`, `notifications`, `facility_maintenance`, `activity_logs`, `user_feedback`.
- Includes Row Level Security (RLS) policies.

---

## 🏃 Running the Application

### Development Server:
```bash
npm run dev
```

### Production Preview:
```bash
npm run build
npm run preview -- --port 4173
```
Open [http://localhost:4173](http://localhost:4173) in your web browser.

---

## 🧪 Demo Credentials

### Researcher User Account:
- **Email**: `dr.anandhan@sece.ac.in`
- **Role**: Associate Professor (AI Research), Computer Science and Engineering
- **Portal URL**: `/user/dashboard`

### Host Directorate Account:
- **Email**: `rd.director@sece.ac.in`
- **Role**: Director - Research & Development & Facility Management
- **Portal URL**: `/host/dashboard`
