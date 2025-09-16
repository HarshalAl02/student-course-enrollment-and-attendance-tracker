# 📘 STUDENT COURSE ENROLLMENT & ATTENDANCE TRACKER
### Phase 2: Org Setup & Configuration – Completion Report

**Project:** Assignment & Exam Management System  
**Institute:** Prof. Ram Meghe Institute of Technology & Research

---

## ✅ 1. Salesforce Edition
- Developer Org used for implementation.

---

## ✅ 2. Company Profile Setup
- **Organization Name:** Prof. Ram Meghe Institute of Technology & Research  
- **Default Locale:** English (India)  
- **Default Currency:** INR  
- **Default Time Zone:** (GMT+05:30) India Standard Time

---

## ✅ 3. Business Hours & Holidays
- **Business Hours:** "School Hours" (All days, available 7:00 AM to 05:00 PM)  
- **Holidays:** Configurable (none added yet)

---

## ✅ 4. Fiscal Year Settings
- **Fiscal Year:** Custom, 01-Apr-2025 to 31-Mar-2026

---

## ✅ 5. User Setup & Licenses
Configured users with appropriate roles and permissions:

- **Teacher User**  
  License: Salesforce  
  Profile: Teacher_Profile  
  Role: Teacher

- **Student User**  
  License: Salesforce  
  Profile: Student_Profile  
  Role: Student

- **Guardian User**  
  License: Salesforce  
  Profile: Guardian_Profile  
  Role: Guardian

---

## ✅ 6. Roles Hierarchy
- Academic_Admin → Teacher → Student  
- Guardian role placed under Admin

---

## ✅ 7. Profiles
Custom profiles created by cloning the standard user profile:

- Teacher_Profile  
- Student_Profile  
- Guardian_Profile

---

## ✅ 8. Permission Sets
Additional permissions granted as needed:

- **PS_Grade_Manager** → Grants extra edit rights on `Grade__c`, assigned to Teacher user (Anita).
- **PS_Attendance_Manager** → Grants management rights on `Attendance__c`, assigned to Teacher user (Anita).

---

## ✅ 9. Organization-Wide Defaults (OWD)
Privacy and access rules applied at the record level:

- `Student__c` = Private  
- `Guardian__c` = Private  
- `Attendance__c` = Private  
- `Grade__c` = Private  
- `Course__c` = Public Read Only

---

## ✅ 10. Sharing Rules
Collaboration rules set to allow controlled access:

- **Grades (`Grade__c`)** → Shared with Guardian role  
- **Attendance (`Attendance__c`)** → Shared with Guardian role if needed  
- **Assignments** → Shared with Teacher role

---

## 📂 OUTCOMES OF PHASE 2
✔ Developer Org successfully configured  
✔ Company academic information standardized  
✔ Academic roles, profiles, and permission sets created and assigned  
✔ OWD and Sharing Rules enforced for record-level security  
✔ Teachers and Guardians provided with controlled access to Assignments, Attendance, and Grades  
✔ Phase 2 deliverables completed and ready to proceed to Phase 3: Data Modeling & Relationships

---

> _End of Phase 2 Completion Report – Assignment & Exam Management System_
