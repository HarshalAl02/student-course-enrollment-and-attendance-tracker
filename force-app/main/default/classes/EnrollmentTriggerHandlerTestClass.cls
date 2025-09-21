@IsTest
public class EnrollmentTriggerHandlerTestClass {

    // ------------------------------
    // Test Insert Enrollment (Trigger: afterInsert)
    // ------------------------------
    @IsTest
    static void testAfterInsert() {
        // Step 1: Create a Guardian (required by Student validation)
        Guardian__c guardian = new Guardian__c(
            First_Name__c = 'Jane',
            Last_Name__c = 'Doe',
            Email__c = 'jane.insert@example.com',
            Phone__c = '9876543210'
        );
        insert guardian;

        // Step 2: Create a Student linked to Guardian (required fields)
        Student__c student = new Student__c(
            First_Name__c = 'John',
            Last_Name__c = 'Doe',
            Student_ID__c = 'STU001',
            Name = 'John Doe',
            Guardian__c = guardian.Id,
            Guardian_Contact__c = guardian.Phone__c
        );
        insert student;

        // Step 3: Ensure at least one Course exists
        List<Course__c> courses = [SELECT Id FROM Course__c LIMIT 1];
        if (courses.isEmpty()) {
            Course__c c = new Course__c(
                Course_Code__c = 'C101',
                Name = 'Math',
                Credits__c = 3
            );
            insert c;
            courses = [SELECT Id FROM Course__c LIMIT 1];
        }

        // Step 4: Insert Enrollment (Trigger fires here)
        Enrollment__c enrollment = new Enrollment__c(
            Student__c = student.Id,
            Course__c = courses[0].Id,
            Status__c = 'Enrolled', // Use exact picklist value
            Enrollment_Date__c = Date.today()
        );

        Test.startTest();
        insert enrollment;
        Test.stopTest();

        // Step 5: Verify Enrollment inserted
        List<Enrollment__c> enrolled = [
            SELECT Id, Student__c, Status__c 
            FROM Enrollment__c 
            WHERE Student__c = :student.Id
        ];
        System.assertEquals(1, enrolled.size(), 'Student should have 1 enrollment');
    }

    // ------------------------------
    // Test Update Enrollment (Trigger: afterUpdate)
    // ------------------------------
    @IsTest
    static void testAfterUpdate() {
        // Step 1: Create Guardian
        Guardian__c guardian = new Guardian__c(
            First_Name__c = 'Anna',
            Last_Name__c = 'Smith',
            Email__c = 'anna.update@example.com',
            Phone__c = '1234567890'
        );
        insert guardian;

        // Step 2: Create Student linked to Guardian
        Student__c student = new Student__c(
            First_Name__c = 'Alice',
            Last_Name__c = 'Smith',
            Student_ID__c = 'STU002',
            Name = 'Alice Smith',
            Guardian__c = guardian.Id,
            Guardian_Contact__c = guardian.Phone__c
        );
        insert student;

        // Step 3: Ensure Course exists
        List<Course__c> courses = [SELECT Id FROM Course__c LIMIT 1];
        if (courses.isEmpty()) {
            Course__c c = new Course__c(
                Course_Code__c = 'C102',
                Name = 'Science',
                Credits__c = 4
            );
            insert c;
            courses = [SELECT Id FROM Course__c LIMIT 1];
        }

        // Step 4: Insert Enrollment
        Enrollment__c enrollment = new Enrollment__c(
            Student__c = student.Id,
            Course__c = courses[0].Id,
            Status__c = 'Enrolled', // exact picklist value
            Enrollment_Date__c = Date.today()
        );
        insert enrollment;

        // Step 5: Update Enrollment Status
        Test.startTest();
        enrollment.Status__c = 'Completed'; // valid picklist value
        update enrollment;
        Test.stopTest();

        // Step 6: Verify Status updated
        Enrollment__c updated = [SELECT Status__c FROM Enrollment__c WHERE Id = :enrollment.Id];
        System.assertEquals('Completed', updated.Status__c, 'Enrollment status should be updated');
    }

    // ------------------------------
    // Test Delete Enrollment (Trigger: afterDelete)
    // ------------------------------
    @IsTest
    static void testAfterDelete() {
        // Step 1: Create Guardian
        Guardian__c guardian = new Guardian__c(
            First_Name__c = 'Mark',
            Last_Name__c = 'Brown',
            Email__c = 'mark.delete@example.com',
            Phone__c = '1234567899'
        );
        insert guardian;

        // Step 2: Create Student linked to Guardian
        Student__c student = new Student__c(
            First_Name__c = 'Bob',
            Last_Name__c = 'Brown',
            Student_ID__c = 'STU003',
            Name = 'Bob Brown',
            Guardian__c = guardian.Id,
            Guardian_Contact__c = guardian.Phone__c
        );
        insert student;

        // Step 3: Ensure Course exists
        List<Course__c> courses = [SELECT Id FROM Course__c LIMIT 1];
        if (courses.isEmpty()) {
            Course__c c = new Course__c(
                Course_Code__c = 'C103',
                Name = 'History',
                Credits__c = 3
            );
            insert c;
            courses = [SELECT Id FROM Course__c LIMIT 1];
        }

        // Step 4: Insert Enrollment
        Enrollment__c enrollment = new Enrollment__c(
            Student__c = student.Id,
            Course__c = courses[0].Id,
            Status__c = 'Enrolled', // exact picklist value
            Enrollment_Date__c = Date.today()
        );
        insert enrollment;

        // Step 5: Delete Enrollment
        Test.startTest();
        delete enrollment;
        Test.stopTest();

        // Step 6: Verify deletion
        List<Enrollment__c> remaining = [SELECT Id FROM Enrollment__c WHERE Student__c = :student.Id];
        System.assertEquals(0, remaining.size(), 'Enrollment should be deleted');
    }
}