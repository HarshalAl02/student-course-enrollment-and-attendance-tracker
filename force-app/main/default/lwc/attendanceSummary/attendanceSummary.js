import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import TOTAL_ATTENDANCE from '@salesforce/schema/Student__c.Total_Attendance__c';

export default class AttendanceSummary extends LightningElement {
    @api recordId;  // This comes automatically when you put the component on a Student record page
    percent;

    @wire(getRecord, { recordId: '$recordId', fields: [TOTAL_ATTENDANCE] })
    wiredStudent({ data, error }) {
        if (data) {
            this.percent = getFieldValue(data, TOTAL_ATTENDANCE);
        }
        if (error) {
            console.error('Error fetching attendance:', error);
        }
    }

    // Optional: Dispatch event if you want parent to refresh
    handleRefresh() {
        this.dispatchEvent(new CustomEvent('attendanceupdated'));
    }
}